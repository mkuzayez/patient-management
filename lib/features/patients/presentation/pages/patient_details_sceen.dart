import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';
import 'package:patient_managment/features/patients/presentation/widgets/given_medicene_card.dart';

import '../../../../common/utils/base_state.dart';
import '../../data/models/patients.dart';
import '../manager/patients_bloc.dart';

class PatientDetailScreen extends StatefulWidget {
  final int patientId;

  const PatientDetailScreen({super.key, required this.patientId});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        print("state.uiStatus ${state.uiStatus}");
        print("state.shouldPop ${state.uiStatus}");

        if (state.actionStatus == Status.failure) {
          if (state.failure != null) _showErrorSnackBar(state.failure!.message);
        }

        if (state.actionStatus == Status.success && state.shouldPop == true) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state.uiStatus == Status.loading;
        final Patient patient = state.patients.firstWhere((element) => element.id == widget.patientId);

        return Scaffold(
          appBar: AppBar(
            title: Text(isLoading ? 'بيانات المريض' : patient?.fullName ?? 'بيانات المريض'),
            actions: [
              if (!isLoading && patient != null && patient.id != null)
                ...[IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.push('/patients/edit-patient/${patient.id!}');
                  },
                ),
                  IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('هل أنت متأكد؟'),
                        content: const Text('هل تريد حذف هذا المريض؟ لا يمكن التراجع عن هذا الإجراء.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true) {
                      if (context.mounted) {
                      final patientId = widget.patientId;
                      if (patientId != null) {
                        context.read<PatientBloc>().add(PatientDelete(patientId));
                      }
                    }
                    }
                  },
                  icon: const Icon(Icons.delete),
                )
                ]
            ],
          ),
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : patient == null
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPatientInfo(context, patient),
                        _buildGivenMeds(patientBloc: context.read<PatientBloc>(), patientID: widget.patientId),
                        // const Divider(height: 32),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('السجلات الطبية', style: Theme.of(context).textTheme.titleLarge),
                        //       ElevatedButton.icon(
                        //         icon: const Icon(Icons.add),
                        //         label: const Text('إضافة سجل'),
                        //         onPressed: () {
                        //           // Navigator.push(
                        //           //   context,
                        //           //   MaterialPageRoute(
                        //           //     builder: (context) => AddRecordScreen(patientId: widget.patientId),
                        //           //   ),
                        //           // ).then((_) => _loadRecords());
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                      ],
                    ),
                  ),
        );
      },
    );
  }

  Widget _buildPatientInfo(BuildContext context, Patient patient) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المعلومات الشخصية', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      if (patient.status != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: patient.status == 'active' ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(patient.status!.toUpperCase(), style: const TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('العمر', '${patient.age} سنة'),
                  _buildInfoRow('الجنس', patient.gender == 'male' ? 'ذكر' : (patient.gender == 'female' ? 'أنثى' : "")),
                  if (patient.area != null) _buildInfoRow('العنوان', patient.area!),
                  if (patient.mobileNumber != null) _buildInfoRow('رقم الهاتف', patient.mobileNumber!),
                  // if (patient.pastIllnesses != null) _buildInfoRow('أمراض سابقة', patient.pastIllnesses!),
                  // _buildInfoRow('Created', patient.createdAt.toString()),
                  // _buildInfoRow('Last Updated', patient.updatedAt.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildGivenMeds({required PatientBloc patientBloc, required int patientID}) {
    return BlocBuilder<PatientBloc, PatientState>(
      builder: (context, state) {

        if (state.uiStatus == Status.loading) {
          return const CircularProgressIndicator();
        }

        return context.read<PatientBloc>().state.givenMeds.isEmpty
            ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("الأدوية الموصوفة", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (ctx) => BlocProvider.value(
                                  value: context.read<PatientBloc>()..add(const MedsFetchAll()),
                                  child: AddMedDialog(patientID: patientID),
                                ),
                          );
                        },
                        child: const Text("إضافة دواء"),
                      ),
                    ],
                  ),
                ),
                const Text("لا يوجد أدوية موصوفة"),
              ],
            )
            : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: Text("الأدوية الموصوفة")),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (ctx) => BlocProvider.value(
                                  value: context.read<PatientBloc>()..add(const MedsFetchAll()),
                                  child: AddMedDialog(patientID: patientID),
                                ),
                          );
                        },
                        child: const Text("إضافة دواء"),
                      ),
                    ],
                  ),
                ),
                ...List.generate(context.read<PatientBloc>().state.givenMeds.length, (index) {
                  return MedicineCard(medicine: context.read<PatientBloc>().state.givenMeds[index]!);
                }),
              ],
            );
      },
    );
  }

  // Widget _buildRecordsList() {
  //   if (_isLoadingRecords) {
  //     return const Center(child: CircularProgressIndicator());
  //   }
  //
  //   if (_records.isEmpty) {
  //     return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: Text('لا يوجد سجلات طبية لهذا المريض.')));
  //   }
  //
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: _records.length,
  //     itemBuilder: (context, index) {
  //       final record = _records[index];
  //       return Card(
  //         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //         child: ListTile(
  //           title: Text('تاريخ الزيارة: ${record.issuedDate}'),
  //           subtitle: Text('الطبيب: ${record.doctorSpecialization} • الأدوية: ${record.totalGivenMedicines}'),
  //           trailing: const Icon(Icons.chevron_right),
  //           onTap: () {
  //             // Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => RecordDetailScreen(recordId: record.id!),
  //             //   ),
  //             // ).then((_) => _loadRecords());
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}

class AddMedDialog extends StatefulWidget {
  final int patientID;

  const AddMedDialog({super.key, required this.patientID});

  @override
  State<AddMedDialog> createState() => _AddMedDialogState();
}

class _AddMedDialogState extends State<AddMedDialog> {

  bool isLoading = true;
  late Medicine _selectedMed;
   TextEditingController _medController = TextEditingController();
   final TextEditingController _quantityController = TextEditingController();

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Builder(
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: const Text("إضافة دواء"),
            content: BlocConsumer<PatientBloc, PatientState>(
              listener: (context, state) {
                if (state.dialogStatus == Status.failure) {
                  context.pop();
                  _showErrorSnackBar("خطأ بتحميل الأدوية، حاول مجددًا");
                }

                if (state.dialogStatus == Status.success || state.dialogStatus == Status.failure){
                  isLoading = false;
                }


              },
                builder: (context, state) {

                  // Handle loading state first
                  if (isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Handle error state
                  if (state.uiStatus == Status.failure) {
                    return Center(child: Text(state.errorMessage ?? "خطأ غير معروف"));
                  }

                  // Handle empty state only AFTER confirming success
                  if (state.allMeds.isEmpty) {
                    return const Center(child: Text("لا يوجد أدوية متاحة."));
                  }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TypeAheadField<Medicine?>(
                      suggestionsCallback:
                          (search) => state.allMeds.where((element) => element!.name.toLowerCase().contains(search.toLowerCase())).toList(),
                      builder: (context, controller, focusNode) {
                        _medController = controller;
                        return TextField(
                          controller: _medController,
                          focusNode: focusNode,
                          autofocus: true,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'اسم الدواء'),
                        );
                      },
                      itemBuilder: (context, Medicine? med) {
                        return ListTile(title: Text(med?.name ?? ''));
                      },
                      onSelected: (Medicine? value) {
                        setState(() {
                          _selectedMed = value!;
                          _medController.text = _selectedMed.name;
                        });
                      },
                      emptyBuilder: (context) => const ListTile(title: Text("لا يوجد أدوية")),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'الكمية'),
                    ),
                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        final quantity = int.tryParse(_quantityController.text) ?? 1;
                        context.read<PatientBloc>().add(
                          AddGivenMed(medId: _selectedMed.id, quantity: quantity, patientId: widget.patientID, dosage: "not-set", context: context),
                        );
                        setState(() {
                          isLoading = true;
                        });
                      },
                      child: const Text("إضافة"),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//
// class SearchableDropdownDialog extends StatefulWidget {
//   final List<Medicine?> allMeds;
//   final Function(Medicine) onSelect;
//
//   const SearchableDropdownDialog({required this.allMeds, required this.onSelect});
//
//   @override
//   _SearchableDropdownDialogState createState() => _SearchableDropdownDialogState();
// }
//
// class _SearchableDropdownDialogState extends State<SearchableDropdownDialog> {
//   String _searchQuery = "";
//   late List<Medicine?> _filteredMeds;
//
//   @override
//   void initState() {
//     super.initState();
//     _filteredMeds = widget.allMeds;
//   }
//
//   void _filterMeds(String query) {
//     setState(() {
//       _searchQuery = query;
//       _filteredMeds = widget.allMeds
//           .where((med) => med != null && med!.name.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 400,
//       width: double.maxFinite,
//       child: Column(
//         children: [
//           TextField(
//             decoration: const InputDecoration(
//               hintText: "ابحث عن دواء...",
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.search),
//             ),
//             onChanged: _filterMeds,
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredMeds.length,
//               itemBuilder: (context, index) {
//                 final med = _filteredMeds[index];
//                 return ListTile(
//                   title: Text(med!.name),
//                   onTap: () {
//                     widget.onSelect(med);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
