import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/features/admin_home/presentation/view/admin_home_screen.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';
import 'package:sales_tracker/features/clients/presentation/view/add_clients_screen.dart';
import 'package:sales_tracker/features/clients/presentation/view/clients_details_screen.dart';
import 'package:sales_tracker/features/clients/presentation/view/clients_screen.dart';
import 'package:sales_tracker/features/home/presentation/view/home_screen.dart';
import 'package:sales_tracker/features/representatives/presentation/view/representative_management_screen.dart';
import 'package:sales_tracker/features/representatives/presentation/view/representatives_details_screen.dart';
import 'package:sales_tracker/features/representatives/presentation/view/representatives_screen.dart';
import 'package:sales_tracker/features/visits/presentation/view/add_visits_screen.dart';
import 'package:sales_tracker/features/visits/presentation/view/visit_screen.dart';
import 'package:sales_tracker/features/visits/presentation/view/visits_details_screen.dart';

import '../../core/constants.dart';
import '../../core/di.dart';
import '../../core/routing/app_routes.dart';
import '../../features/auth/presentation/controllers/bloc/auth_bloc.dart';
import '../../features/auth/presentation/views/forget_password_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/auth/presentation/views/reset_password_screen.dart';
import '../../features/auth/presentation/views/verification_screen.dart';
// import '../../features/intro/onboarding/cubit/onboarding_cubit.dart';
// import '../../features/intro/onboarding/onboarding_screen.dart';
import '../../features/intro/splash/splash_view.dart';
import '../../features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import '../../features/main_layout/presentation/views/main_layout_view.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splashScreen,
    routes: [
      /// ------------------ < Intro Routes > ------------------
      GoRoute(
        path: AppRoutes.splashScreen,
        name: AppRoutes.splashScreen,
        builder: (context, state) => const SplashView(),
      ),

      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        builder: (context, state) => BlocProvider<ClientCubit>(
          create: (context) => getIt<ClientCubit>(),
          child: HomeScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.adminHomeScreen,
        name: AppRoutes.adminHomeScreen,
        builder: (context, state) => BlocProvider<ClientCubit>(
          create: (context) => getIt<ClientCubit>(),
          child: AdminHomeScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.clientsScreen,
        name: AppRoutes.clientsScreen,
        builder: (context, state) {
          BlocProvider<ClientCubit>(
            create: (context) => getIt<ClientCubit>()..getClients(),
          );
          final clients = state.extra! as List<ClientModel>;
          //  => BlocProvider<ProductCubit>(
          //   create: (context) => getIt<ProductCubit>()..getProducts(),
          return ClientsScreen(clients: clients);
        },
      ),

      GoRoute(
        path: AppRoutes.visitsScreen,
        name: AppRoutes.visitsScreen,
        builder: (context, state) {
          BlocProvider<ClientCubit>(
            create: (context) => getIt<ClientCubit>()..getClients(),
          );
          final visits = state.extra! as List<ClientModel>;
          return VisitScreen(visits: visits);
        },
      ),

      GoRoute(
        path: AppRoutes.representativeScreen,
        name: AppRoutes.representativeScreen,
        builder: (context, state) {
          BlocProvider<ClientCubit>(
            create: (context) => getIt<ClientCubit>()..getClients(),
          );
          final representatives = state.extra! as List<ClientModel>;
          return RepresentativesScreen(representatives: representatives);
        },
      ),

      GoRoute(
        path: AppRoutes.addClientsScreen,
        name: AppRoutes.addClientsScreen,
        builder: (context, state) {
          return BlocProvider<ClientCubit>(
            create: (context) => getIt<ClientCubit>(),
            child: const AddClientsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.addVisitsScreen,
        name: AppRoutes.addVisitsScreen,
        builder: (context, state) {
          return BlocProvider<ClientCubit>(
            create: (context) => getIt<ClientCubit>()..getClients(),
            child: const AddVisitsScreen(),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.clientsDetailsScreen,
        path: AppRoutes.clientsDetailsScreen,
        builder: (context, state) {
          final client = state.extra! as ClientModel;
          return ClientsDetailsScreen(client: client);
        },
      ),

      GoRoute(
        path: AppRoutes.visitsDetailsScreen,
        name: AppRoutes.visitsDetailsScreen,
        builder: (context, state) {
          final visit = state.extra! as ClientModel;
          return VisitsDetailsScreen(visit: visit);
        },
      ),

      GoRoute(
        path: AppRoutes.representativeDetailsScreen,
        name: AppRoutes.representativeDetailsScreen,
        builder: (context, state) {
          final representative = state.extra! as ClientModel;
          return RepresentativesDetailsScreen(representative: representative);
        },
      ),

      GoRoute(
        path: AppRoutes.representativeManagementScreen,
        name: AppRoutes.representativeManagementScreen,
        builder: (context, state) {
          final representative = state.extra as ClientModel?;
          return RepresentativeManagementScreen(representative: representative);
        },
      ),

      // GoRoute(
      //   path: AppRoutes.onBoardingScreen,
      //   name: AppRoutes.onBoardingScreen,
      //   builder: (context, state) => BlocProvider<OnboardingCubit>(
      //     create: (context) => getIt<OnboardingCubit>(),
      //     child: const OnBoardingScreen(),
      //   ),
      // ),

      /// ------------------ < Main Layout Route > ------------------
      GoRoute(
        path: AppRoutes.mainLayoutScreen,
        name: AppRoutes.mainLayoutScreen,
        builder: (context, state) => BlocProvider<MainLayoutCubit>(
          create: (context) => getIt<MainLayoutCubit>(),
          child: const MainLayoutView(),
        ),
      ),

      /// ------------------ < Auth Routes > ------------------
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider<AuthBloc>.value(
          value: getIt<AuthBloc>(),
          child: const LogInScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        name: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider<AuthBloc>.value(
          value: getIt<AuthBloc>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordScreen,
        name: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => BlocProvider<AuthBloc>.value(
          value: getIt<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.resetPasswordScreen,
        name: AppRoutes.resetPasswordScreen,
        builder: (context, state) {
          final email = state.extra! as String;

          return BlocProvider<AuthBloc>.value(
            value: getIt<AuthBloc>(),
            child: ResetPasswordScreen(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.verificationScreen,
        name: AppRoutes.verificationScreen,
        builder: (context, state) {
          final email = state.extra! as String;

          return BlocProvider<AuthBloc>.value(
            value: getIt<AuthBloc>(),
            child: VerificationScreen(email: email),
          );
        },
      ),

      /// ------------- < >  -------------
      // GoRoute(
      //     path: AppRoutes.allCoursesScreen,
      //     name: AppRoutes.allCoursesScreen,
      //     builder: (context, state) {
      //       final args = state.extra! as Map<String, dynamic>;
      //       final title = args['title'] as String;
      //       final subject = args['items'] as List<Course>;
      //       final subscriptions = args['subscriptions'] as List<Subscription>;
      //       final currencySymbol = args['currencySymbol'] as String?;
      //       return BlocProvider<CartBloc>.value(
      //         value: getIt<CartBloc>(),
      //         child: AllContentScreen(
      //           items: subject,
      //           title: title,
      //           subscriptions: subscriptions,
      //           currencySymbol: currencySymbol,
      //         ),
      //       );
      //     },
      //   ),
    ],
  );
}
