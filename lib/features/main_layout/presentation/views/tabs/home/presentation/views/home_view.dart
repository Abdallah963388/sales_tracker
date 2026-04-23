import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
// import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    required this.onPageChanged,
    required this.pageController,
    super.key,
  });

  final void Function(int) onPageChanged;
  final PageController pageController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _redirect() async {
    final token = await CacheHelper.getSecured(
      CacheKeys.userToken,
    );
    final isLogin = token?.toString();
    if (isLogin != null && isLogin.isNotEmpty) {
      await context.pushNamed(AppRoutes.salesMainLayoutScreen);
    } else {
      await context.pushNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: 12.verticalSpace),
              SliverToBoxAdapter(
                child: _statCard(
                  context: context,
                  title: s.salesTracker,
                  subTitle: s.salesTrackerDescription,
                  icon: Icons.trending_up,
                  onTap: () async {
                    await _redirect();
                  },
                ),
              ),

              // const SliverToBoxAdapter(
              //   child: LaunchIdeaCard(),
              // ),
              SliverToBoxAdapter(child: 16.verticalSpace),

              SliverToBoxAdapter(
                child: Text(
                  s.featuredServices,
                  style: AppTextStyle.style16W700.copyWith(
                    color: AppColors.blackColor.withAlpha(200),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Text(
                  s.quickAccessToOurMostPopularServices,
                  style: AppTextStyle.style14W400.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),

              SliverToBoxAdapter(child: 12.verticalSpace),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => context.read<MainLayoutCubit>().goToPage(
                        1,
                        widget.pageController,
                      ),
                      child: Text(
                        s.viewAll,
                        style: AppTextStyle.style12W600.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SliverToBoxAdapter(child: 8.verticalSpace),

              BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200.h,
                        child: const LoadingWidget(),
                      ),
                    );
                  }

                  if (state is ServiceError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          '${s.errorLoadingServices}: ${state.message}',
                        ),
                      ),
                    );
                  }

                  if (state is ServiceLoaded) {
                    final featuredServices = state.services.take(4).toList();

                    if (featuredServices.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(child: Text(s.noServicesToShow)),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: featuredServices.length,
                            itemBuilder: (context, i) {
                              final service = featuredServices[i];

                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: ListTile(
                                  onTap: () => context.pushNamed(
                                    AppRoutes.serviceDetailView,
                                    extra: service.id,
                                  ),

                                  leading: service.id == 1
                                      ? Image.asset(
                                          'assets/images/png/erp white 1.png',
                                          width: 40,
                                          color: AppColors.primaryColor,
                                        )
                                      : service.id == 2
                                      ? Image.asset(
                                          'assets/images/png/point of sale.png',
                                          width: 40,
                                          color: AppColors.primaryColor,
                                        )
                                      : service.id == 3
                                      ? Image.asset(
                                          'assets/images/png/web development.png',
                                          width: 40,
                                          color: AppColors.primaryColor,
                                        )
                                      : service.id == 4
                                      ? Image.asset(
                                          'assets/images/png/mobile application.png',
                                          width: 40,
                                          color: AppColors.primaryColor,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: service.image,
                                          width: 40,
                                          color: AppColors.primaryColor,
                                          errorWidget: (_, _, _) =>
                                              const Icon(Icons.error),
                                          placeholder: (_, _) =>
                                              const Icon(Icons.image),
                                        ),

                                  title: Text(
                                    service.name,
                                    style: AppTextStyle.style16W700.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),

                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),

                                  tileColor: AppColors.secondaryColor.withAlpha(
                                    30,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                              );
                            },
                          ),
                          20.verticalSpace,
                          const LaunchIdeaCard(),
                          50.verticalSpace,
                        ],
                      ),
                    );
                  }

                  return SliverToBoxAdapter(
                    child: 50.verticalSpace,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ServiceCardWidget extends StatelessWidget {
  const ServiceCardWidget({required this.service, super.key});
  final Service service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.serviceDetailView,
        extra: service.id,
      ),
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryColor.withAlpha(150),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(15.r),
          // color: AppColors.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (service.id == 1)
              Image.asset(
                'assets/images/png/erp white 1.png',
                color: AppColors.primaryColor,
              )
            else if (service.id == 2)
              Image.asset(
                'assets/images/png/point of sale.png',
                color: AppColors.primaryColor,
              )
            else if (service.id == 3)
              Image.asset(
                'assets/images/png/web development.png',
                color: AppColors.primaryColor,
              )
            else if (service.id == 4)
              Image.asset(
                'assets/images/png/mobile application.png',
                color: AppColors.primaryColor,
              )
            else
              CachedNetworkImage(
                imageUrl: service.image,
                height: 50,
                color: AppColors.primaryColor,
                errorWidget: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  color: AppColors.primaryColor,
                ),
                placeholder: (context, url) => const Icon(
                  Icons.error,
                  color: AppColors.primaryColor,
                ),
              ),
            4.verticalSpace,
            FittedBox(
              child: Text(
                service.name,
                textAlign: TextAlign.center,
                style: AppTextStyle.style16W700.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statCard({
  required String title,
  required String subTitle,
  required IconData icon,
  required BuildContext context,
  VoidCallback? onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.primaryColor,
          // gradient: const LinearGradient(
          //   colors: [
          //     AppColors.primaryColor,
          //     AppColors.forthColor,
          //   ],
          // ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40.r,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                children: [
                  Text(
                    title,
                    style: AppTextStyle.style16Bold.copyWith(
                      color: AppColors.scaffoldBackgroundLightColor,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subTitle,
                    style: AppTextStyle.style14W500.copyWith(
                      color: AppColors.scaffoldBackgroundLightColor.withAlpha(
                        200,
                      ),
                      fontSize: 15.sp,
                    ),
                  ),
                  16.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.r),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),

                    child: Text(
                      S.of(context)!.enterServiceNow,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.style14W900.copyWith(
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class LaunchIdeaCard extends StatelessWidget {
  const LaunchIdeaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.requestServiceView,
        extra: [
          s.projectIdeaQuestion,
          s.requiredPlatformsQuestion,
          s.mainFeaturesQuestion,
          s.uiuxDesignQuestion,
          s.similarAppQuestion,
          s.budgetAndTimelineQuestion,
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          color: AppColors.primaryColor,
          // gradient: const LinearGradient(
          //   colors: [
          //     AppColors.thirdColor,
          //     AppColors.primaryColor,
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(39),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 40.r,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.launchYourIdeaNow,
                    style: AppTextStyle.style16Bold.copyWith(
                      color: AppColors.scaffoldBackgroundLightColor,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    '${s.requestYourTechService}\n'
                    '${s.executeYourProject}',
                    style: AppTextStyle.style16W500.copyWith(
                      color: AppColors.scaffoldBackgroundLightColor.withAlpha(
                        200,
                      ),
                      fontSize: 15.sp,
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),

                    child: Text(
                      s.orderNow,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.style14W900.copyWith(
                        color: AppColors.thirdColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
