import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/core/constants.dart';
import 'package:sit/core/localization/s.dart';
// import '/../core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/shared_widgets/custom_progress_indicator.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/sales_features/auth/presentation/controllers/auth_cubit.dart';
import 'package:sit/features/sales_features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/sales_features/profile/data/model/profile_model.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_cubit.dart';
import 'package:sit/features/sales_features/profile/presentation/controller/profile_states.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.watch<ProfileCubit>();
        final profile = cubit.profile;

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: LoadingWidget()),
          );
        }

        return Scaffold(
          // appBar: CustomAppBar(
          //   // title: 'الملف الشخصي',
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         context.pushNamed(AppRoutes.editProfileScreen);
          //       },
          //       icon: Icon(
          //         Icons.edit,
          //         size: 24.sp,
          //         color: AppColors.primaryColor,
          //       ),
          //     ),
          //   ],
          // ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                20.verticalSpace,

                /// Account Info
                _AccountHeaderCard(profile: profile),

                20.verticalSpace,

                _statCard(
                  title: s.sitServices,
                  subTitle: s.sitServicesDescription,
                  icon: Icons.miscellaneous_services,
                  onTap: () {
                    context.read<SalesMainLayoutCubit>().reset();

                    context.pop();
                  },
                ),

                // 25.verticalSpace,
                // _buildSectionTitle(s.appSettings),
                // const _SettingsCard(),
                25.verticalSpace,
                // _buildSectionTitle(s.supportAndHelp),

                // // const _SupportAndActionsCard(),
                // 25.verticalSpace,0
                const _LogoutCard(),

                30.verticalSpace,
                // const PoweredByWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _buildSectionTitle(String title) {
  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 10.h, right: 5.w, left: 5.w),
  //     child: Align(
  //       alignment: AlignmentDirectional.centerStart,
  //       child: Text(
  //         title,
  //         style: AppTextStyle.style14W600.copyWith(color: Colors.grey),
  //       ),
  //     ),
  //   );
  // }

  Widget _statCard({
    required String title,
    required String subTitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80.h,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.r),
          // gradient: const LinearGradient(
          //   colors: [
          //     AppColors.primaryColor,
          //     AppColors.forthColor,
          //   ],
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                4.horizontalSpace,
                // const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            4.verticalSpace,
            Text(
              subTitle,
              style: TextStyle(fontSize: 13.sp, color: AppColors.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountHeaderCard extends StatelessWidget {
  const _AccountHeaderCard({this.profile});

  final UserProfileData? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(radius),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.secondaryColor.withAlpha(100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35.r,
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              Icons.person,
              size: 40.r,
              color: AppColors.scaffoldBackgroundLightColor,
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profile?.name ?? '',
                      style: AppTextStyle.style16Bold.copyWith(
                        color: AppColors.forthColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.editProfileScreen);
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 24.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),

                5.verticalSpace,

                Text(
                  profile?.email ?? '',
                  style: AppTextStyle.style12W400.copyWith(
                    color: AppColors.forthColor.withAlpha(180),
                  ),
                ),

                5.verticalSpace,

                Text(
                  profile?.phone ?? '',
                  style: AppTextStyle.style12W400.copyWith(
                    color: AppColors.forthColor.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _SettingsCard extends StatelessWidget {
//   const _SettingsCard();

//   @override
//   Widget build(BuildContext context) {
//     final s = S.of(context)!;
//     return BlocBuilder<LocalizationCubit, LocalizationState>(
//       builder: (context, state) {
//         final currentLangLabel = state.locale.languageCode == 'ar'
//             ? 'العربية'
//             : 'English';

//         return _ProfileListContainer(
//           children: [
//             _ProfileTile(
//               icon: Icons.language,
//               title: s.appLanguage,
//               trailing: Text(
//                 currentLangLabel,
//                 style: AppTextStyle.style12W400.copyWith(
//                   color: AppColors.primaryColor,
//                 ),
//               ),
//               onTap: () {
//                 // context.push(AppRoutes.appSettingsView);
//               },
//             ),
//             // _ProfileTile(
//             //   icon: Icons.notifications_none,
//             //   title: s.notifications,
//             //   onTap: () {},
//             // ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _SupportAndActionsCard extends StatelessWidget {
//   const _SupportAndActionsCard();

//   @override
//   Widget build(BuildContext context) {
//     final s = S.of(context)!;

//     return _ProfileListContainer(
//       children: [
//         _ProfileTile(
//           icon: Icons.info_outline,
//           title: s.aboutUs,
//           onTap: () async {
//             // final lang = CacheHelper.getLanguage();
//             // final url = 'https://safedcare.com/$lang';
//             // await context.pushNamed(
//             //   AppRoutes.webViewPage,
//             //   extra: {
//             //     'url': url,
//             //     'title': s.aboutUs,
//             //     'isPrint': false,
//             //   },
//             // );
//           },
//         ),
//         _ProfileTile(
//           icon: Icons.privacy_tip_outlined,
//           title: s.privacyPolicy,
//           onTap: () async {
//             // const url = 'https://flourishing-pie-a27432.netlify.app/';
//             // await context.pushNamed(
//             //   AppRoutes.webViewPage,
//             //   extra: {
//             //     'url': url,
//             //     'title': s.privacyPolicy,
//             //     'isPrint': false,
//             //   },
//             // );
//           },
//         ),
//         _ProfileTile(
//           icon: Icons.headset_mic_outlined,
//           title: s.callUs,
//           onTap: () async {
//             const url = 'https://wa.me/966548250999';
//             await launchURL(url);
//           },
//         ),
//       ],
//     );
//   }
// }

class _LogoutCard extends StatelessWidget {
  const _LogoutCard();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;

    return _ProfileListContainer(
      children: [
        BlocConsumer<LoginCubit, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccessState) {
              context.read<SalesMainLayoutCubit>().reset();
              context.pop();
            } else if (state is LogoutFailedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is LogoutLoadingState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: const LoadingWidget(),
                ),
              );
            }

            return _ProfileTile(
              icon: Icons.logout,
              title: s.logOut,
              titleColor: AppColors.errorColor,
              iconColor: AppColors.errorColor,
              showChevron: false,
              onTap: () async {
                // إظهار حوار تأكيد قبل الخروج
                await showDialog<dynamic>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(
                      s.logOut,
                      style: AppTextStyle.style14W500.copyWith(
                        color: AppColors.forthColor,
                      ),
                    ),
                    titleTextStyle: AppTextStyle.style14Bold.copyWith(
                      color: AppColors.blackColor.withAlpha(200),
                    ),
                    content: Text(
                      s.areYouSureLogout,
                      style: AppTextStyle.style12W500,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          s.cancel,
                          style: AppTextStyle.style12W500.copyWith(
                            color: Colors.black.withAlpha(150),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.read<LoginCubit>().logout();
                        },
                        child: Text(
                          s.confirm,
                          style: AppTextStyle.style12W500.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ProfileListContainer extends StatelessWidget {
  const _ProfileListContainer({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBackgroundLightColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.secondaryColor.withAlpha(100)),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.titleColor,
    this.iconColor,
    this.showChevron = true, // this.trailing,
  });
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  // final Widget? trailing;
  final Color? titleColor;
  final Color? iconColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.primaryColor),
      title: Text(
        title,
        style: AppTextStyle.style12W400.copyWith(
          color: titleColor ?? AppColors.forthColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      // trailing:
      //     trailing ??
      //     (showChevron ? Icon(Icons.chevron_right, size: 20.r) : null),
    );
  }
}
