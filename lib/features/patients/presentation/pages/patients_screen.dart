
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_managment/common/loading_dialog.dart';
import 'package:throttling/throttling.dart';

import '../../../../common/utils/base_state.dart';
import '../manager/patients_bloc.dart';
import '../widgets/patient_card.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  String _searchQuery = '';
  late Debouncing debounce;

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(const PatientFetchAll());
    debounce = Debouncing(duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    debounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => GoRouterHelper(context).push('/patients/add-patient/'),
      child: const Icon(Icons.add)
      ),
      body: BlocConsumer<PatientBloc, PatientState>(
        listener: (context, state) {
          switch (state.actionStatus) {
            case (Status.loading):
              LoadingDialog.show(context);

            case (Status.failure):
              LoadingDialog.close();
              _showErrorSnackBar("خطأ بالاتصال، يرجى المحاولة مجددًا");

            case (Status.success):
              LoadingDialog.close();

            default:
              break;
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'البحث عن مريض', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });

                    debounce.debounce(() {
                      if (value.isEmpty) {
                        context.read<PatientBloc>().add(const PatientFetchAll());
                      } else {
                        state.uiStatus == Status.success ? (context.read<PatientBloc>().add(PatientSearch(value))) : null;
                      }
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: SizedBox(
              //     width: double.maxFinite,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         GoRouterHelper(context).push('/patients/add-patient/');
              //       },
              //       child: const Text("إضافة مريض"),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<PatientBloc>().add(const PatientFetchAll(shouldRefresh: true));
                  },
                  child: Builder(
                    builder: (context) {
                      switch (state.uiStatus) {
                        case Status.loading:
                          return const Center(child: CircularProgressIndicator());

                        case Status.failure:
                          return SizedBox(
                            height: MediaQuery.sizeOf(context).height * .7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text("خطأ بالإتصال", style: Theme.of(context).textTheme.titleMedium)),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context.read<PatientBloc>().add(const PatientFetchAll());
                                    },
                                    child: const Text("المحاولة مجددًا"),
                                  ),
                                ),
                              ],
                            ),
                          );

                        case Status.success:
                          if (state.patients.isEmpty) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.5,
                                  child: Center(
                                    child: Text(
                                      _searchQuery.isEmpty ?
                                      'لا يوجد مرضى' :
                                      'لا يوجد مرضى يطابقون "$_searchQuery"',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return ListView.builder(
                            itemCount: state.patients.length,
                            itemBuilder: (context, index) {
                              return BlocProvider.value(
                                value: context.read<PatientBloc>(),
                                child: PatientCard(
                                  index: index,
                                  isFromWaitlist: false,
                                  // onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => PatientDetailScreen(patientId: patient.id!),
                                  //   ),
                                  // ).then((_) {
                                  //   if (context.mounted) {
                                  //     context.read<PatientBloc>().add(const PatientFetchAll());
                                  //   }
                                  // });
                                  // },
                                ),
                              );
                            },
                          );

                        case Status.initial:
                          return const SizedBox(); // empty state or placeholder
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.push('/add-patient');
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
