import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/services/cubit/service_detail_cubit.dart';

class ServiceDetailView extends StatelessWidget {
  const ServiceDetailView({required this.serviceId, super.key});

  final int serviceId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    context.read<ServiceDetailCubit>().fetchServiceDetail(serviceId);

    return Scaffold(
      appBar: const CustomAppBar(
        canBack: true,
        title: '',
      ),

      body: BlocBuilder<ServiceDetailCubit, ServiceDetailState>(
        builder: (context, state) {
          if (state is ServiceDetailLoading) {
            return const LoadingWidget();
          }
          if (state is ServiceDetailError) {
            return Center(child: Text(state.message));
          }
          if (state is ServiceDetailLoaded) {
            return _buildServiceContent(context, state.service);
          }
          return Center(child: Text(s.loadingDetails));
        },
      ),
    );
  }

  Widget _buildServiceContent(BuildContext context, Service service) {
    final s = S.of(context)!;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.verticalSpace,
                HeaderSectionWidget(service: service),

                16.verticalSpace,

                const Divider(height: 1, thickness: 1),

                16.verticalSpace,

                OverviewSectionWidget(service: service),

                16.verticalSpace,

                FeaturesSectionWidget(service: service),

                16.verticalSpace,

                ProcessSectionWidget(service: service),

                24.verticalSpace,
                CustomPrimaryButton(
                  width: SizeConfig.screenWidth - 32.w,
                  text: S.of(context)!.requestCustomService,
                  onPressed: () => context.pushNamed(
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
                ),
                10.verticalSpace,
                CustomPrimaryButton(
                  width: SizeConfig.screenWidth - 32.w,
                  text: S.of(context)!.contactSales,
                  onPressed: () => context.pushNamed(AppRoutes.chatView),
                ),

                24.verticalSpace,
              ],
            ),
          ),
        ),
      ],
    );
  }

  // في ملف
}

class FeaturesSectionWidget extends StatelessWidget {
  const FeaturesSectionWidget({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.keyFeatures,
            style: AppTextStyle.style16W700,
          ),
          8.verticalSpace,
          ...service.keyFeatures.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outlined,
                    color: AppColors.primaryColor,
                    size: 20.r,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyle.style14W400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewSectionWidget extends StatelessWidget {
  const OverviewSectionWidget({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context)!.serviceOverview,
          style: AppTextStyle.style16W700,
        ),
        8.verticalSpace,
        Text(
          service.overview,
          style: AppTextStyle.style14W400.copyWith(
            color: AppColors.secondaryColor,
          ),
        ),
      ],
    );
  }
}

class HeaderSectionWidget extends StatelessWidget {
  const HeaderSectionWidget({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: CachedNetworkImage(
            imageUrl: service.image,
            width: 130.w,
            height: 130.w,
            fit: BoxFit.cover,
            errorWidget: (context, error, stackTrace) => Container(
              width: 130.w,
              height: 130.w,
              color: Colors.grey[300],
              child: Icon(Icons.business_center, size: 40.r),
            ),
            placeholder: (context, url) => Container(
              width: 130.w,
              height: 130.w,
              color: Colors.grey[300],
              child: Icon(Icons.business_center, size: 40.r),
            ),
          ),
        ),
        16.horizontalSpace,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.name,
                style: AppTextStyle.style18W700.copyWith(fontSize: 20),
              ),
              4.verticalSpace,
              Text(
                S.of(context)!.enterprise,
                style: AppTextStyle.style14W400.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              8.verticalSpace,
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20.r,
                    );
                  }),
                  8.horizontalSpace,
                  Text(
                    service.rating,
                    style: AppTextStyle.style14W400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProcessSectionWidget extends StatelessWidget {
  const ProcessSectionWidget({
    required this.service,
    super.key,
  });

  final Service service;

  @override
  Widget build(BuildContext context) {
    final processSteps = service.typicalProcess;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.primaryColor.withAlpha(33)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context)!.typicalProcess,
            style: AppTextStyle.style16W700,
          ),
          10.verticalSpace,

          ...processSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == processSteps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      width: 12.r,
                      height: 12.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 40.h,
                        color: AppColors.primaryColor,
                      ),
                    if (isLast) SizedBox(height: 40.h),
                  ],
                ),
                10.horizontalSpace,
                Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: Text(
                    step,
                    style: AppTextStyle.style14W400,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
