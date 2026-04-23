import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_primary_button.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/data/models/service_model.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  @override
  void initState() {
    super.initState();

    context.read<ServiceBloc>().add(const FetchServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Text(
              s.allServices,
              style: AppTextStyle.style18W700,
            ),
            4.verticalSpace,
            Text(
              s.exploreOurCompleteRangeOfSolutions,
              style: AppTextStyle.style14W400.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
            16.verticalSpace,

            Expanded(
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return const LoadingWidget();
                  }

                  if (state is ServiceError) {
                    return Center(
                      child: Text(
                        '${s.errorLoadingServices}: ${state.message}',
                      ),
                    );
                  }

                  if (state is ServiceLoaded) {
                    final services = state.services;

                    if (services.isEmpty) {
                      return Center(child: Text(s.noServicesToShow));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: services.length,
                      separatorBuilder: (context, index) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return FullServiceCard(service: service);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullServiceCard extends StatelessWidget {
  const FullServiceCard({required this.service, super.key});
  final Service service;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.thirdColor.withAlpha(33),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: CachedNetworkImage(
                  imageUrl: service.image,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.grey[300],
                    child: const Icon(Icons.business),
                  ),
                  errorWidget: (context, error, stackTrace) => Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.grey[300],
                    child: const Icon(Icons.business),
                  ),
                ),
              ),
              10.horizontalSpace,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: AppTextStyle.style16W700.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      s.enterprise,
                      style: AppTextStyle.style14W400.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.verticalSpace,

          Text(
            service.overview,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.style14W400.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
          10.verticalSpace,

          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (service.keyFeatures.isNotEmpty)
                _buildFeatureTag(service.keyFeatures[0]),
              if (service.keyFeatures.length > 1)
                _buildFeatureTag(service.keyFeatures[1]),

              if (service.keyFeatures.length > 2)
                _buildFeatureTag(s.more, isMore: true),
            ],
          ),
          16.verticalSpace,

          CustomPrimaryButton(
            onPressed: () {
              context.pushNamed(
                AppRoutes.serviceDetailView,
                extra: service.id,
              );
            },
            text: s.learnMore,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTag(String text, {bool isMore = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isMore ? AppColors.secondaryColor.withAlpha(33) : Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: AppColors.secondaryColor.withAlpha(100),
          width: 1,
        ),
      ),
      child: FittedBox(
        child: Text(
          text,
          style: AppTextStyle.style12W400.copyWith(
            color: isMore ? AppColors.secondaryColor : AppColors.forthColor,
          ),
        ),
      ),
    );
  }
}
