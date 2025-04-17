import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../manager/patients_bloc.dart';

class PatientCard extends StatelessWidget {
  final int index;
  final bool isFromWaitlist;

  const PatientCard({super.key, required this.index, this.isFromWaitlist = false});

  @override
  Widget build(BuildContext context) {
    switch (isFromWaitlist) {
      case true:
        return context.read<PatientBloc>().state.patients[index].isWaiting == false ? const SizedBox.shrink() : _card(context: context, index: index);

      case false:
        return context.read<PatientBloc>().state.patients[index].isWaiting == true ? const SizedBox.shrink() : _card(context: context, index: index);
    }
  }
}

Widget _card({required BuildContext context, required int index}) {
  return GestureDetector(
    child: Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name + Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.read<PatientBloc>().state.patients[index].fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Checkbox(
                  value: context.watch<PatientBloc>().state.patients[index].isWaiting,
                  onChanged: (value) {
                    context.read<PatientBloc>().add(
                      PatientUpdate(patient: context.read<PatientBloc>().state.patients[index].copyWith(isWaiting: value)),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Subtitle: Age + Area
            Text(
              '${context.read<PatientBloc>().state.patients[index].age} عام • ${context.read<PatientBloc>().state.patients[index].area ?? "-"}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Bottom Row: Info Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoBox(title: 'السجلات الطبية', value: '${context.read<PatientBloc>().state.patients[index].recordsCount}'),
                _infoBox(title: 'الزيارة الأخيرة', value: context.read<PatientBloc>().state.patients[index].lastVisit ?? '-'),
                _infoBox(
                  title: 'الحالة',
                  value: (context.read<PatientBloc>().state.patients[index].status ?? '').toUpperCase(),
                  color: context.read<PatientBloc>().state.patients[index].status?.toLowerCase() == 'active' ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _infoBox({required String title, required String value, Color? color}) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color ?? Colors.black), overflow: TextOverflow.ellipsis),
        ],
      ),
    ),
  );
}
