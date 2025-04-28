// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../common/utils/cache_manager.dart' as _i899;
import '../../features/patients/data/data_sources/patients_data_source.dart'
    as _i292;
import '../../features/patients/data/repositories/patients_repository_impl.dart'
    as _i347;
import '../../features/patients/domain/repositories/patients_repository.dart'
    as _i420;
import '../../features/patients/domain/use_cases/add_given_med.dart' as _i322;
import '../../features/patients/domain/use_cases/add_med.dart' as _i501;
import '../../features/patients/domain/use_cases/create_patient.dart' as _i1004;
import '../../features/patients/domain/use_cases/delete_given_med.dart'
    as _i625;
import '../../features/patients/domain/use_cases/delete_patient.dart' as _i870;
import '../../features/patients/domain/use_cases/get_all_meds.dart' as _i506;
import '../../features/patients/domain/use_cases/get_all_patients.dart'
    as _i857;
import '../../features/patients/domain/use_cases/get_given_meds.dart' as _i941;
import '../../features/patients/domain/use_cases/get_invoice.dart' as _i24;
import '../../features/patients/domain/use_cases/get_patient.dart' as _i517;
import '../../features/patients/domain/use_cases/search_patients.dart' as _i105;
import '../../features/patients/domain/use_cases/update_med.dart' as _i875;
import '../../features/patients/domain/use_cases/update_patient.dart' as _i1043;
import '../../features/patients/presentation/manager/invoice_cubit/invoice_cubit.dart'
    as _i773;
import '../../features/patients/presentation/manager/meds_bloc/meds_bloc.dart'
    as _i122;
import '../../features/patients/presentation/manager/patients_bloc.dart'
    as _i171;
import '../network/http_client.dart' as _i1069;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i899.CacheManager>(() => _i899.CacheManager());
    gh.lazySingleton<_i1069.HTTPClient>(() => _i1069.DioClient());
    gh.lazySingleton<_i292.PatientDataSource>(
      () => _i292.PatientDataSource(httpClient: gh<_i1069.HTTPClient>()),
    );
    gh.lazySingleton<_i420.PatientRepository>(
      () => _i347.PatientRepositoryImpl(gh<_i292.PatientDataSource>()),
    );
    gh.lazySingleton<_i322.AddGivenMedUseCase>(
      () => _i322.AddGivenMedUseCase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i501.AddMedUseCase>(
      () => _i501.AddMedUseCase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i1004.CreatePatient>(
      () => _i1004.CreatePatient(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i625.DeleteGivenMedUsecase>(
      () => _i625.DeleteGivenMedUsecase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i870.DeletePatient>(
      () => _i870.DeletePatient(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i506.GetAllMedsUseCase>(
      () => _i506.GetAllMedsUseCase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i857.GetAllPatients>(
      () => _i857.GetAllPatients(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i941.GetGivenMedsUseCase>(
      () => _i941.GetGivenMedsUseCase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i24.GetInvoiceUseCase>(
      () => _i24.GetInvoiceUseCase(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i517.GetPatient>(
      () => _i517.GetPatient(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i105.SearchPatients>(
      () => _i105.SearchPatients(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i875.UpdateMed>(
      () => _i875.UpdateMed(gh<_i420.PatientRepository>()),
    );
    gh.lazySingleton<_i1043.UpdatePatient>(
      () => _i1043.UpdatePatient(gh<_i420.PatientRepository>()),
    );
    gh.factory<_i773.ReportCubit>(
      () => _i773.ReportCubit(getInvoiceUseCase: gh<_i24.GetInvoiceUseCase>()),
    );
    gh.factory<_i171.PatientBloc>(
      () => _i171.PatientBloc(
        gh<_i857.GetAllPatients>(),
        gh<_i517.GetPatient>(),
        gh<_i941.GetGivenMedsUseCase>(),
        gh<_i1004.CreatePatient>(),
        gh<_i1043.UpdatePatient>(),
        gh<_i870.DeletePatient>(),
        gh<_i899.CacheManager>(),
        gh<_i322.AddGivenMedUseCase>(),
        gh<_i625.DeleteGivenMedUsecase>(),
        gh<_i506.GetAllMedsUseCase>(),
      ),
    );
    gh.factory<_i122.MedsBloc>(
      () => _i122.MedsBloc(
        getAllMedsUseCase: gh<_i506.GetAllMedsUseCase>(),
        addMedUseCase: gh<_i501.AddMedUseCase>(),
        updateMed: gh<_i875.UpdateMed>(),
      ),
    );
    return this;
  }
}
