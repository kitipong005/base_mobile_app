// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:base_mobile_app/core/config/env_config.dart' as _i328;
import 'package:base_mobile_app/core/config/hive_config.dart' as _i671;
import 'package:base_mobile_app/core/di/dio_module.dart' as _i893;
import 'package:base_mobile_app/core/di/env_module.dart' as _i839;
import 'package:base_mobile_app/data/datasources/local_datasource.dart'
    as _i408;
import 'package:base_mobile_app/data/repositories/auth_repository.dart'
    as _i706;
import 'package:base_mobile_app/features/auth/bloc/auth_bloc.dart' as _i703;
import 'package:base_mobile_app/features/example/bloc/example_bloc.dart'
    as _i21;
import 'package:base_mobile_app/features/theme/cubit/theme_cubit.dart' as _i67;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final envModule = _$EnvModule();
    final dioModule = _$DioModule();
    await gh.factoryAsync<_i328.EnvConfig>(
      () => envModule.provideEnv(),
      preResolve: true,
    );
    gh.factory<_i21.ExampleBloc>(() => _i21.ExampleBloc());
    gh.singleton<_i361.Dio>(() => dioModule.dio);
    gh.singleton<_i671.HiveConfig>(() => _i671.HiveConfig());
    gh.singleton<_i408.LocalDataSource>(() => _i408.LocalDataSource());
    gh.lazySingleton<_i67.ThemeCubit>(() => _i67.ThemeCubit());
    gh.singleton<_i706.AuthRepository>(
        () => _i706.AuthRepository(gh<_i361.Dio>()));
    gh.factory<_i703.AuthBloc>(
        () => _i703.AuthBloc(gh<_i706.AuthRepository>()));
    return this;
  }
}

class _$EnvModule extends _i839.EnvModule {}

class _$DioModule extends _i893.DioModule {}
