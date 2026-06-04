// ignore_for_file: cast_nullable_to_non_nullable

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/constants.dart';
import 'package:sit/core/di.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sit/features/admin_home/presentation/view/admin_home_screen.dart';
import 'package:sit/features/auth/presentation/controllers/auth_cubit.dart';
import 'package:sit/features/auth/presentation/views/login_screen.dart';
import 'package:sit/features/clients/data/model/client_model.dart';
import 'package:sit/features/clients/presentation/controller/client_cubit.dart';
import 'package:sit/features/clients/presentation/view/add_clients_screen.dart';
import 'package:sit/features/clients/presentation/view/all_clients_screen.dart';
import 'package:sit/features/clients/presentation/view/clients_details_screen.dart';
import 'package:sit/features/clients/presentation/view/clients_screen.dart';
import 'package:sit/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sit/features/home/presentation/view/home_screen.dart';
import 'package:sit/features/intro/onboarding/cubit/onboarding_cubit.dart';
import 'package:sit/features/intro/onboarding/onboarding_screen.dart';
import 'package:sit/features/intro/splash/splash_view.dart';
import 'package:sit/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/main_layout/presentation/views/main_layout_view.dart';
import 'package:sit/features/profile/presentation/controller/profile_cubit.dart';
import 'package:sit/features/profile/presentation/view/edit_profile_screen.dart';
import 'package:sit/features/representative/data/model/single_rep_model.dart';
import 'package:sit/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sit/features/representative/presentation/view/create_rep_screen.dart';
import 'package:sit/features/representative/presentation/view/rep_details_screen.dart';
import 'package:sit/features/representative/presentation/view/rep_screen.dart';
import 'package:sit/features/visits/data/model/visits_model.dart';
import 'package:sit/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sit/features/visits/presentation/view/add_visits_screen.dart';
import 'package:sit/features/visits/presentation/view/all_visits_screen.dart';
import 'package:sit/features/visits/presentation/view/visit_screen.dart';
import 'package:sit/features/visits/presentation/view/visits_details_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splashScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreen,
        name: AppRoutes.splashScreen,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onBoardingScreen,
        name: AppRoutes.onBoardingScreen,
        builder: (context, state) => BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(),
          child: const OnBoardingScreen(),
        ),
      ),

      // GoRoute(
      //   path: AppRoutes.mainlayout,
      //   name: AppRoutes.mainlayout,
      //   builder: (context, state) => BlocProvider<SalesMainLayoutCubit>(
      //     create: (context) => SalesMainLayoutCubit(),
      //     child: const SalesMainLayoutView(),
      //   ),
      // ),

      // GoRoute(
      //   path: AppRoutes.serviceDetailView,
      //   name: AppRoutes.serviceDetailView,
      //   builder: (context, state) {
      //     final id = state.extra! as int;
      //     return BlocProvider<ServiceDetailCubit>(
      //       create: (context) => getIt<ServiceDetailCubit>(),
      //       child: ServiceDetailView(serviceId: id),
      //     );
      //   },
      // ),

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
      //  GoRoute(
      //   path: AppRoutes.splashScreen,
      //   name: AppRoutes.splashScreen,
      //   builder: (context, state) => const SplashView(),
      // ),
      GoRoute(
        path: AppRoutes.homeScreen,
        name: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: AppRoutes.adminHomeScreen,
        name: AppRoutes.adminHomeScreen,
        builder: (context, state) => BlocProvider<AdminHomeCubit>.value(
          value: getIt<AdminHomeCubit>()..fetchAdminHome(),
          child: const AdminHomeScreen(),
        ),
      ),

      GoRoute(
        path: AppRoutes.clientsScreen,
        name: AppRoutes.clientsScreen,
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<ClientCubit>(),
            child: const ClientsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.allClientsScreen,
        name: AppRoutes.allClientsScreen,
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<ClientCubit>(),
            child: const AllClientsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.repsScreen,
        name: AppRoutes.repsScreen,
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<RepCubit>(),
            child: const RepScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.visitsScreen,
        name: AppRoutes.visitsScreen,
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<VisitsCubit>(),
            child: const VisitScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.allVisitsScreen,
        name: AppRoutes.allVisitsScreen,
        builder: (context, state) {
          return BlocProvider.value(
            value: getIt<VisitsCubit>()..getAllVisits(),
            child: const AllVisitsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.editProfileScreen,
        name: AppRoutes.editProfileScreen,
        builder: (context, state) {
          return BlocProvider<ProfileCubit>.value(
            value: getIt<ProfileCubit>(),
            child: const EditProfileScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.addClientsScreen,
        name: AppRoutes.addClientsScreen,
        builder: (context, state) {
          final client = state.extra as Client?;

          return MultiBlocProvider(
            providers: [
              BlocProvider<ClientCubit>.value(
                value: getIt<ClientCubit>(),
              ),
              BlocProvider.value(
                value: getIt<RepHomeCubit>(),
              ),
            ],
            child: AddClientsScreen(client: client),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.addVisitsScreen,
        name: AppRoutes.addVisitsScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<VisitsCubit>.value(
                value: getIt<VisitsCubit>(),
              ),
              BlocProvider<ClientCubit>.value(
                value: getIt<ClientCubit>(),
              ),
            ],
            child: const AddVisitsScreen(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.addRepScreen,
        name: AppRoutes.addRepScreen,
        builder: (context, state) {
          final rep = state.extra as SingleRepData?;

          return MultiBlocProvider(
            providers: [
              BlocProvider<RepCubit>.value(
                value: getIt<RepCubit>(),
              ),
              BlocProvider.value(
                value: getIt<AdminHomeCubit>(),
              ),
            ],
            child: AddRepScreen(rep: rep),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.clientsDetailsScreen,
        path: AppRoutes.clientsDetailsScreen,
        builder: (context, state) {
          final client = state.extra! as Client;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<ClientCubit>(),
              ),
              BlocProvider.value(
                value: getIt<AdminHomeCubit>(),
              ),
              BlocProvider.value(
                value: getIt<VisitsCubit>(),
              ),
              BlocProvider.value(
                value: getIt<RepHomeCubit>(),
              ),
            ],
            child: ClientsDetailsScreen(client: client),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.visitsDetailsScreen,
        name: AppRoutes.visitsDetailsScreen,
        builder: (context, state) {
          final visit = state.extra! as Visit;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<VisitsCubit>(),
              ),
              BlocProvider.value(
                value: getIt<AdminHomeCubit>(),
              ),
              BlocProvider.value(
                value: getIt<RepHomeCubit>(),
              ),
            ],
            child: VisitsDetailsScreen(visit: visit),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.repDetailsScreen,
        name: AppRoutes.repDetailsScreen,
        builder: (context, state) {
          final rep = state.extra! as int;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<RepCubit>(),
              ),
              BlocProvider.value(
                value: getIt<AdminHomeCubit>(),
              ),
              BlocProvider.value(
                value: getIt<VisitsCubit>(),
              ),
            ],
            child: RepDetailsScreen(repId: rep),
          );
        },
      ),

      // GoRoute(
      //   path: AppRoutes.representativeManagementScreen,
      //   name: AppRoutes.representativeManagementScreen,
      //   builder: (context, state) {
      //     final representative = state.extra as ClientModel?;
      //     return RepresentativeManagementScreen(representative: representative);
      //   },
      // ),

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
        path: AppRoutes.salesMainLayoutScreen,
        name: AppRoutes.salesMainLayoutScreen,
        builder: (context, state) => BlocProvider<SalesMainLayoutCubit>.value(
          value: getIt<SalesMainLayoutCubit>(),
          child: const SalesMainLayoutView(),
        ),
      ),
      // GoRoute(
      //   path: AppRoutes.requestServiceView,
      //   name: AppRoutes.requestServiceView,
      //   builder: (context, state) {
      //     final projectQuestions = state.extra! as List<String>;
      //     return BlocProvider<ServiceBloc>.value(
      //       value: getIt<ServiceBloc>(),
      //       child: RequestServiceView(
      //         projectQuestions: projectQuestions,
      //       ),
      //     );
      //   },
      // ),

      /// ------------------ < Auth Routes > ------------------
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: getIt<LoginCubit>(),
              ),
              // BlocProvider.value(
              //   value: getIt<SalesMainLayoutCubit>(),
              // ),
            ],
            child: const LogInScreen(),
          );
        },
      ),
    ],
  );
}
