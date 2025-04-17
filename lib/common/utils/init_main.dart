import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patient_managment/common/utils/shared_preferences_helper.dart';

import '../../core/di/injection.dart';
import 'bloc_observer.dart';

class Initialization {
  static Future<void> initMain() async {
    WidgetsFlutterBinding.ensureInitialized();
    configureDependencies();
    Bloc.observer = AppBlocObserver();
    await ShPH.init();
  }
}
