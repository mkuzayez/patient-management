import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_managment/features/patients/data/models/given_medicine.dart';
import 'package:patient_managment/features/patients/presentation/manager/patients_bloc.dart';

class MedicineCard extends StatelessWidget {
  final GivenMedicine medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(medicine.medicineName, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis)),
                const Spacer(),
                IconButton(onPressed: () => context.read<PatientBloc>()..add(DeleteGivenMedEvent(id: medicine.id)), icon: const Icon(Icons.delete), padding: const EdgeInsets.all(0)),
              ],
            ),
            const SizedBox(height: 8),
            Text('الكمية: ${medicine.quantity}'),
            const SizedBox(height: 8),
            Text('تاريخ الإعطاء ${medicine.givenAt.split('T')[0]}'),
            const SizedBox(height: 8),
            Text('السعر الإجمالي: ${medicine.totalPrice}'),
          ],
        ),
      ),
    );
  }
}
