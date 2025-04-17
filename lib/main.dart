import 'package:flutter/material.dart';
import 'package:patient_managment/common/utils/router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/utils/init_main.dart';

void main() async {
  await Initialization.initMain();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PatientManagement());
}

class PatientManagement extends StatelessWidget {
  const PatientManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Patient Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, surface: Colors.white),
        textTheme: GoogleFonts.cairoTextTheme(),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      routerConfig: AppRouter.router,
    );  }
}
