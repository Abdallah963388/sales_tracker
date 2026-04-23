import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sit/core/di.dart';
import 'package:sit/core/functions/config_loading.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/router_generation_config.dart';
import 'package:sit/core/theme/app_themes.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';
import 'package:sit/features/sales_features/my_app/controller/localization_cubit/localization_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizationCubit>(
          create: (context) => LocalizationCubit(),
        ),
        BlocProvider<ServiceBloc>(
          create: (context) => ServiceBloc(repository: getIt()),
        ),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, localeState) {
          return GestureDetector(
            onTap: () => unfocusScope(context),
            child: MaterialApp.router(
              title: 'SIT',
              debugShowCheckedModeBanner: false,
              routerConfig: RouterGenerationConfig.goRouter,
              theme: Appthemes.lightTheme(),
              locale: localeState.locale, //const Locale('ar'),
              supportedLocales: S.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, myWidget) {
                final widget = EasyLoading.init()(context, myWidget);
                configLoading(context);

                return widget;
              },
            ),
          );
        },
      ),
    );
  }
}

void unfocusScope(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    currentFocus.unfocus();
  }
}
