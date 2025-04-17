import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:patient_managment/core/di/injection.dart' as di;
import 'package:patient_managment/features/patients/presentation/pages/patients_screen.dart';

import '../../features/home/home_screen.dart';
import '../../features/patients/presentation/manager/patients_bloc.dart';
import '../../features/patients/presentation/pages/patient_waitlist_screen.dart';

class AppRouter {
  static PatientBloc? patientBloc;

  static final GoRouter router = GoRouter(
    initialLocation: '/patients',

    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },

        routes: [
          GoRoute(
            path: '/patients',
            builder: (context, state) {
              patientBloc == null ? patientBloc = di.getIt<PatientBloc>() : null;
              return BlocProvider.value(value: patientBloc!, child: const PatientsScreen());
            },
          ),
          GoRoute(
            path: '/patients/waitlist',
            builder: (context, state) {
              return BlocProvider.value(value: patientBloc!, child: const PatientsWaitlistScreen());
            },
          ),
        ],
      ),
    ],
  );
}
