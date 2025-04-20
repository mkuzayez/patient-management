import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_managment/features/patients/presentation/manager/invoice_cubit/invoice_cubit.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تقرير'),
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.error) {
            return Center(child: Text('Error: ${state.failure?.message ?? "Unknown error"}'));
          } else if (state.status == Status.success) {
            final report = state.invoice;
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                if (report?.metadata.fromDate != null)
                  ListTile(
                    title: Flexible(
                      child: Text(
                        'من تاريخ: ${report?.metadata.fromDate}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (report?.metadata.toDate != null)
                  ListTile(
                    subtitle: Flexible(
                      child: Text(
                        'حتى تاريخ: ${report?.metadata.toDate}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ListTile(
                  title: Text('السعر الإجمالي: ${report?.metadata.totalPrice}'),
                ),
                ...report?.medicines.map((med) => ListTile(
                  title: Text(
                    med.medicineName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "الكمية الإجمالية: ${med.totalQuantity}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 150),
                    child: Text(
                      "السعر: ${med.totalPrice}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )) ?? [],
              ],
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
