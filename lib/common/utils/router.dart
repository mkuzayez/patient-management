import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_managment/core/di/injection.dart' as di;
import 'package:patient_managment/features/patients/presentation/manager/invoice_cubit/invoice_cubit.dart';
import 'package:patient_managment/features/patients/presentation/pages/medicines_screen.dart';
import 'package:patient_managment/features/patients/presentation/pages/patient_details_sceen.dart';
import 'package:patient_managment/features/patients/presentation/pages/patients_screen.dart';
import 'package:patient_managment/features/patients/presentation/pages/report_screen.dart';

import '../../features/home/home_screen.dart';
import '../../features/patients/presentation/manager/meds_bloc/meds_bloc.dart';
import '../../features/patients/presentation/manager/patients_bloc.dart';
import '../../features/patients/presentation/pages/add_patient_screen.dart';

// Global key for the root navigator
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// GlobalKey for the shell's nested navigator (used in ShellRoute)
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static PatientBloc? patientBloc;

  static final GoRouter router = GoRouter(
    initialLocation: '/patients',
    navigatorKey: _rootNavigatorKey,

    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },

        routes: [
          GoRoute(
            path: '/patients',
            builder: (context, state) {
              patientBloc == null ? patientBloc = di.getIt<PatientBloc>() : null;
              return BlocProvider.value(value: patientBloc!..add((const PatientFetchAll())), child: const PatientsScreen());
            },
          ),

          // GoRoute(
          //   path: '/patients/waitlist',
          //   builder: (context, state) {
          //     return BlocProvider.value(value: patientBloc!, child: const PatientsWaitlistScreen());
          //   },
          // ),
          GoRoute(
            path: '/meds',
            builder: (context, state) {
              return BlocProvider(create: (context) => di.getIt<MedsBloc>()..add(LoadAllMedsEvent()), child: const MedicinesScreen());
            },
          ),

          GoRoute(
            path: '/report',
            builder: (context, state) {
              return BlocProvider(create: (context) => di.getIt<ReportCubit>()..fetchInvoice(), child: const ReportScreen());
            },
          ),
        ],
      ),
      GoRoute(
        path: '/patients/details/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);

          patientBloc == null ? patientBloc = di.getIt<PatientBloc>() : null;
          return BlocProvider.value(
            value:
                patientBloc!
                  ..add(PatientFetchOne(id))
                  ..add(GivenMedsFetchAll(id: id)),
            child: PatientDetailScreen(patientId: id),
          );
        },
      ),

      GoRoute(
        path: '/patients/add-patient',
        builder: (context, state) => BlocProvider.value(value: patientBloc!, child: const AddEditPatientScreen(patient: null, shouldInit: false, isEditing: false,)),
      ),

      GoRoute(
        path: '/patients/edit-patient/:id',
        builder: (context, state) {
          final patientId = int.parse(state.pathParameters['id']!);
          return BlocProvider.value(value: patientBloc!, child: AddEditPatientScreen(patient: patientBloc!.state.patients.firstWhere((element) => element.id == patientId,), patientId: patientId, isEditing: true,));
        },
      ),
    ],
  );
}
