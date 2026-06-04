import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/cache_helper/cache_values.dart';
import 'package:sit/core/functions/user_role.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/routing/app_routes.dart';
import 'package:sit/core/services/loading.dart';
import 'package:sit/core/shared_widgets/custom_app_bar.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sit/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sit/features/visits/data/model/visits_model.dart';
import 'package:sit/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sit/features/visits/presentation/controller/visits_states.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitsDetailsScreen extends StatefulWidget {
  const VisitsDetailsScreen({
    required this.visit,
    super.key,
  });
  final Visit visit;

  @override
  State<VisitsDetailsScreen> createState() => _VisitsDetailsScreenState();
}

class _VisitsDetailsScreenState extends State<VisitsDetailsScreen> {
  final role = CacheHelper.get<String>(CacheKeys.userRole)?.toString();

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+
        final statusImages = await Permission.photos.request();
        final statusVideo = await Permission.videos.request();
        return statusImages.isGranted && statusVideo.isGranted;
      } else {
        // Android < 13
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true; // iOS
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context)!;
    return BlocListener<VisitsCubit, VisitState>(
      listener: (context, state) {
        if (state.status == VisitStatus.deleteLoading ||
            state.status == VisitStatus.adminDeleteLoading) {
          showLoading();
        }

        if (state.status == VisitStatus.deleteSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? ''),
                backgroundColor: Colors.green,
              ),
            );
            if (role == UserRole.admin) {
              await context.read<AdminHomeCubit>().fetchAdminHome();
            }
            if (role == UserRole.rep) {
              await context.read<RepHomeCubit>().fetchRepHome();
            }
          });
          context.pop();
        }

        if (state.status == VisitStatus.adminDeleteSuccess) {
          hideLoading();

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? ''),
                backgroundColor: Colors.green,
              ),
            );

            await context.read<AdminHomeCubit>().fetchAdminHome();

            if (role == UserRole.admin) {
              await context.pushNamed(AppRoutes.allVisitsScreen);
            } else if (role == UserRole.rep) {
              await context.pushNamed(AppRoutes.visitsScreen);
            }
          });
        }

        if (state.status == VisitStatus.failure && state.error != null) {
          hideLoading();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }

        if (state.status == VisitStatus.downloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? ''),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: s.visitDetails,
          actions: [
            PopupMenuButton<String>(
              color: AppColors.whiteColor,
              icon: const Icon(
                Icons.more_vert,
                size: 30,
                color: AppColors.primaryDarkColor,
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteDialog(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(s.delete),
                ),
              ],
            ),
          ],
          canBack: true,
        ),
        body: BlocBuilder<VisitsCubit, VisitState>(
          builder: (context, state) {
            // if (state.status == VisitStatus.singleLoading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            // if (state.status == VisitStatus.failure) {
            //   return Center(child: Text(state.error ?? 'حدث خطأ'));
            // }

            final visit = widget.visit;

            // if (visit == null) {
            //   return const SizedBox.shrink();
            // }

            return SingleChildScrollView(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTime(visit, context),

                  8.verticalSpace,

                  _buildSectionCard(
                    title: s.clientInformation,
                    children: [
                      _item(
                        title: s.clientName,
                        value: visit.client?.clientName ?? '',
                      ),
                      _item(
                        title: s.businessName,
                        value: visit.client?.businessName ?? '',
                      ),
                      if (visit.client?.region == null) ...[
                        const SizedBox.shrink(),
                      ] else
                        _item(
                          title: s.region,
                          value: visit.client?.region ?? '',
                        ),
                      _item(
                        title: s.phone,
                        value: visit.client?.phone ?? '',
                        icon: Icons.phone,
                        onTap: () async {
                          final phone = visit.client?.phone ?? '';
                          if (phone.isNotEmpty) {
                            final url = Uri(scheme: 'tel', path: phone);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode
                                    .externalApplication, // مهم للـ iOS
                              );
                            }
                          }
                        },
                      ),
                      _item(
                        title: s.email,
                        value: visit.client?.email ?? '',
                        icon: Icons.email,
                        onTap: () async {
                          final email = visit.client?.email ?? '';
                          if (email.isNotEmpty) {
                            final url = Uri(scheme: 'mailto', path: email);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),

                  if (visit.locationName != null) ...[
                    12.verticalSpace,
                    _buildSectionCard(
                      title: s.location,
                      children: [
                        InkWell(
                          onTap: () async {
                            final location = visit.locationName ?? '';
                            if (location.isNotEmpty) {
                              final url = Uri.parse(
                                'https://www.google.com/maps/search/?api=1&query=$location',
                              );
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }
                          },
                          child: _item(
                            // title: 'الموقع',
                            value: visit.locationName ?? '',
                            icon: Icons.location_on_outlined,
                            onTap: () async {
                              final location = visit.locationName ?? '';
                              if (location.isNotEmpty) {
                                final url = Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=$location',
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(
                                    url,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (visit.details != null && visit.details!.isNotEmpty) ...[
                    12.verticalSpace,
                    _buildSectionCard(
                      title: s.visitDetails,
                      children: [
                        _item(value: visit.details ?? ''),
                      ],
                    ),
                  ],

                  // 12.verticalSpace,
                  // _buildSectionCard(
                  //   title: 'التاريخ والوقت',
                  //   children: [
                  //     _item(
                  //       title: 'التاريخ',
                  //       value: visit.createdAt != null
                  //           ? visit.createdAt!.substring(0, 10)
                  //           : '',
                  //     ),
                  //     _item(
                  //       title: 'الوقت',
                  //       value: visit.createdAt != null
                  //           ? visit.createdAt!.substring(11, 16)
                  //           : '',
                  //     ),
                  //   ],
                  // ),
                  12.verticalSpace,
                  if (visit.attachment != null && visit.attachment != '') ...[
                    12.verticalSpace,
                    _buildSectionCard(
                      onDownload: () async {
                        final granted = await requestStoragePermission();
                        if (granted) {
                          await context.read<VisitsCubit>().downloadAttachment(
                            visit.attachment!,
                          );
                        }
                      },
                      icon: Icons.download,
                      title: s.attachment,
                      children: [
                        _buildAttachmentItem(visit.attachment!, context),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTime(Visit visit, BuildContext context) {
    var formattedDateTime = '';

    if (visit.createdAt != null && visit.createdAt!.isNotEmpty) {
      final dateTime = DateTime.parse(visit.createdAt!);

      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');

      final isAm = hour < 12;
      final displayHour = hour % 12 == 0 ? 12 : hour % 12;

      final period = isAm ? S.of(context)!.am : S.of(context)!.pm;

      final date =
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';

      formattedDateTime = '$displayHour:$minute $period - $date';
    }

    return
    //  Column(
    //   crossAxisAlignment: CrossAxisAlignment.end,
    //   children: [
    Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryDarkColor,
          ],
        ),
      ),
      child: Text(
        textAlign: TextAlign.end,
        formattedDateTime,
        style: AppTextStyle.style12W800.copyWith(
          color: AppColors.whiteColor,
        ),
      ),
    ); //,
    // 12.verticalSpace,
    // Container(
    //   width: double.infinity,
    //   padding: EdgeInsets.all(14.r),
    //   decoration: BoxDecoration(
    //     color: AppColors.primaryColor.withAlpha(20),
    //     borderRadius: BorderRadius.circular(12.r),
    //   ),
    //   child: Text(
    //     visit.client?.clientName ?? '',
    //     style: AppTextStyle.style16W800.copyWith(
    //       color: AppColors.primaryDarkColor,
    //     ),
    //   ),
    // ),
    // ],
    // );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
    VoidCallback? onDownload,
  }) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyle.style14W800.copyWith(
                    color: AppColors.primaryDarkColor,
                  ),
                ),
                IconButton(
                  onPressed: onDownload,
                  icon: Icon(
                    icon,
                    color: AppColors.primaryDarkColor,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _item({
    String? title,
    String? value,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.r),
      child: Row(
        children: [
          if (title != null)
            Text(
              '$title : ',
              style: AppTextStyle.style12W800.copyWith(
                color: AppColors.primaryDarkColor,
              ),
            ),
          Expanded(
            child: Text(
              value ?? '',
              style: AppTextStyle.style12W500,
            ),
          ),
          if (icon != null && onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                icon,
                size: 20,
                color: AppColors.primaryDarkColor,
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context)!.confirmDelete),
        titleTextStyle: AppTextStyle.style14Bold.copyWith(
          color: AppColors.blackColor.withAlpha(200),
        ),
        content: Text(S.of(context)!.areYouSureYouWantToDeleteThisVisit),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              S.of(context)!.close,
              style: AppTextStyle.style14W500.copyWith(
                color: AppColors.blackColor.withAlpha(150),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (role == UserRole.rep) {
                await context.read<VisitsCubit>().deleteVisit(widget.visit.id!);
              }
              if (role == UserRole.admin) {
                await context.read<VisitsCubit>().adminDeleteVisit(
                  widget.visit.id!,
                );
              }
              context.pop();
            },
            child: Text(
              S.of(context)!.delete,
              style: AppTextStyle.style14W500.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(String urlOrPath, BuildContext context) {
    final isImage =
        urlOrPath.endsWith('.jpg') ||
        urlOrPath.endsWith('.jpeg') ||
        urlOrPath.endsWith('.png') ||
        urlOrPath.endsWith('.gif');

    if (isImage) {
      return GestureDetector(
        onTap: () {
          // ignore: inference_failure_on_function_invocation
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.black,
              child: InteractiveViewer(
                child: Image.network(
                  urlOrPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
        child: Image.network(
          urlOrPath,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Text(S.of(context)!.imageCanNotBeDownloaded);
          },
        ),
      );
    } else {
      return Row(
        children: [
          const Icon(Icons.attach_file, size: 30),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              urlOrPath.split('/').last,
              style: AppTextStyle.style12W500.copyWith(
                color: AppColors.primaryDarkColor,
              ),
            ),
          ),
        ],
      );
    }
  }
}
