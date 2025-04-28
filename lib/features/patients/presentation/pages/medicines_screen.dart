import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_managment/features/patients/data/models/medicine.dart';

import '../../../../common/utils/base_state.dart';
import '../manager/meds_bloc/meds_bloc.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  void _showAddOrUpdateDialog(BuildContext context, {required bool isUpdate, Medicine? med}) {
    showDialog(
      context: context,
      builder: (ctx) {
        // Initialize controllers with existing data if updating
        final nameController = TextEditingController(text: med?.name);
        final doseController = TextEditingController(text: med?.dose);
        final scientificController = TextEditingController(text: med?.scientificName);
        final companyController = TextEditingController(text: med?.company);
        final priceController = TextEditingController(text: med?.price);

        return BlocProvider.value(
          value: context.read<MedsBloc>(),
          child: BlocConsumer<MedsBloc, MedsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final isLoading = state.dialogStatus == Status.loading;

              return AlertDialog(
                title: Text(isUpdate ? "تعديل الدواء" : "إضافة دواء"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم الدواء')),
                      TextField(controller: doseController, decoration: const InputDecoration(labelText: 'العيار')),
                      // TextField(controller: scientificController, decoration: const InputDecoration(labelText: 'الاسم العلمي')),
                      // TextField(controller: companyController, decoration: const InputDecoration(labelText: 'الشركة المصنعة')),
                      TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'السعر'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                actions: [
                  if (isLoading)
                    const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
                  else
                    TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("إلغاء")),
                  ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (isUpdate) {
                                context.read<MedsBloc>().add(
                                  UpdateMedEvent(
                                    id: med!.id,
                                    name: nameController.text.trim(),
                                    dose: doseController.text.trim(),
                                    scientificName: scientificController.text.trim(),
                                    company: companyController.text.trim(),
                                    price: priceController.text.trim(),
                                  ),
                                );
                              } else {
                                context.read<MedsBloc>().add(
                                  AddMedEvent(
                                    name: nameController.text.trim(),
                                    dose: doseController.text.trim(),
                                    scientificName: scientificController.text.trim(),
                                    company: companyController.text.trim(),
                                    price: priceController.text.trim(),
                                  ),
                                );
                              }
                            },
                    child: Text(isUpdate ? "تحديث" : "إضافة"),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الأدوية")),
      body: BlocConsumer<MedsBloc, MedsState>(
        // ... keep existing listener and builder code ...
        builder: (context, state) {
          if (state.uiStatus == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.uiStatus == Status.failure) {
            return Center(child: Text(state.errorMessage ?? "خطأ بالاتصال، يرجى المحاولة مجددًا"));
          }

          final meds = state.allMeds;

          if (meds.isEmpty && state.uiStatus != Status.loading) {
            return const Center(child: Text("لا يوجد أدوية مُضافة"));
          }
          return ListView.builder(
            itemCount: meds.length,
            itemBuilder: (context, index) {
              final med = meds[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  onLongPress: () => _showAddOrUpdateDialog(context, isUpdate: true, med: med),
                  // ... rest of the ListTile code ...
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(med.name),
                  subtitle: Text.rich(
                    TextSpan(children: [TextSpan(text: "الاسم العلمي: ${med.scientificName}\n"), TextSpan(text: "العيار: ${med.dose}")]),
                  ),
                  trailing: Text("السعر: ${med.price}"),
                ),
              );
            },
          );
        },
        listener: (context, state) {
          switch (state.dialogStatus) {
            case Status.success:
              context.pop();
            case Status.failure:
              context.pop();
            default:
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _showAddOrUpdateDialog(context, isUpdate: false), child: const Icon(Icons.add)),
    );
  }
}
