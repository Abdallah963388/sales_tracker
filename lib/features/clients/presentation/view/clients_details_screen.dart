import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/cache_helper/cache_helper.dart';
import 'package:sales_tracker/core/cache_helper/cache_values.dart';
import 'package:sales_tracker/core/cache_helper/user_role.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/admin_home/presentation/controller/admin_home_cubit.dart';
import 'package:sales_tracker/features/clients/data/model/client_model.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_cubit.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_state.dart';
import 'package:sales_tracker/features/home/presentation/controller/rep_home_cubit.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_states.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientsDetailsScreen extends StatefulWidget {
  const ClientsDetailsScreen({
    required this.client,
    super.key,
  });
  final Client client;

  @override
  State<ClientsDetailsScreen> createState() => _ClientsDetailsScreenState();
}

class _ClientsDetailsScreenState extends State<ClientsDetailsScreen> {
  final bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      // context.read<ClientCubit>().getSingleClient(widget.client);
      context.read<VisitsCubit>().getClientVisits(widget.client.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = CacheHelper.getData(key: CacheKeys.userRole);
    return BlocBuilder<ClientCubit, ClientState>(
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: 'تفاصيل العميل',
            actions: [
              PopupMenuButton<String>(
                color: AppColors.whiteColor,
                icon: const Icon(
                  Icons.more_vert,
                  size: 30,
                  color: AppColors.primaryColor,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    context.pushNamed(
                      AppRoutes.addClientsScreen,
                      extra: widget.client,
                    );
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('تعديل'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('حذف'),
                  ),
                ],
              ),
            ],
            canBack: true,
          ),

          body: BlocConsumer<ClientCubit, ClientState>(
            listener: (context, state) {
              if (state.status == ClientStatus.deleteSuccess) {
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

              if (state.status == ClientStatus.failure && state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error!),
                  ),
                );
              }
            },
            builder: (context, state) {
              // if (state.status == ClientStatus.loading) {
              //   return const Center(child: CircularProgressIndicator());
              // }

              // if (state.status == ClientStatus.failure) {
              //   return Center(child: Text(state.error ?? 'حدث خطأ'));
              // }

              // final client = state.singleClient;

              // if (client == null) {
              //   return const Center(child: Text('لا توجد بيانات'));
              // }

              return SingleChildScrollView(
                padding: EdgeInsets.all(12.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(widget.client),

                    12.verticalSpace,

                    _buildSectionCard(
                      title: 'البيانات الأساسية',
                      children: [
                        _item(
                          title: 'اسم المكان',
                          value: widget.client.businessName ?? '',
                        ),
                        _item(
                          title: 'المنطقة',
                          value: widget.client.region ?? '',
                        ),
                      ],
                    ),

                    12.verticalSpace,

                    _buildSectionCard(
                      title: 'بيانات التواصل',
                      children: [
                        _item(
                          title: 'الهاتف',
                          value: widget.client.phone ?? '',
                          icon: Icons.phone,
                          onTap: () async {
                            final phone = widget.client.phone ?? '';
                            if (phone.isNotEmpty) {
                              final url = Uri(scheme: 'tel', path: phone);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            }
                          },
                        ),
                        if (widget.client.email == null ||
                            widget.client.email!.isEmpty) ...[
                          const SizedBox.shrink(),
                        ] else
                          _item(
                            title: 'البريد',
                            value: widget.client.email ?? '',
                            icon: Icons.email,
                            onTap: () async {
                              final email = widget.client.email ?? '';
                              if (email.isNotEmpty) {
                                final url = Uri(scheme: 'mailto', path: email);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              }
                            },
                          ),
                      ],
                    ),

                    12.verticalSpace,

                    _buildSectionCard(
                      title: 'زيارات العميل',
                      children: [
                        BlocBuilder<VisitsCubit, VisitState>(
                          builder: (context, state) {
                            if (state.status ==
                                VisitStatus.clientVisitsLoading) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h),
                                child: const LinearProgressIndicator(),
                              );
                            }

                            if (state.status == VisitStatus.failure &&
                                state.error != null) {
                              return Center(child: Text(state.error!));
                            }

                            if (state.status ==
                                    VisitStatus.clientVisitsSuccess &&
                                state.clientVisits != null) {
                              final visits = state.clientVisits!;

                              if (visits.isEmpty) {
                                return const Text('لا توجد زيارات');
                              }

                              return Column(
                                children: visits.map((visit) {
                                  return ListTile(
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 24,
                                        color: AppColors.primaryDarkColor,
                                      ),
                                      onPressed: () {
                                        context.pushNamed(
                                          AppRoutes.visitsDetailsScreen,
                                          extra: visit,
                                        );
                                      },
                                    ),
                                    title: Text(visit.details ?? ''),
                                    subtitle: Text(
                                      'الموقع: ${visit.locationName ?? ''}\n'
                                      'التاريخ: ${visit.createdAt?.substring(0, 10) ?? ''}',
                                    ),
                                    // trailing: visit.attachment != null
                                    //     ? IconButton(
                                    //         icon: const Icon(Icons.photo),
                                    //         onPressed: () {
                                    //           // هنا يمكن إضافة فتح الملف أو الصورة
                                    //         },
                                    //       )
                                    //     : null,
                                  );
                                }).toList(),
                              );
                            }

                            // return const SizedBox.shrink();
                            return const Text(
                              'لا نستطيع الوصول للزيارات حاليا',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(Client client) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryDarkColor,
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Text(
              (client.clientName ?? 'A')[0],
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.clientName ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  client.region ?? '',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
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
            Text(
              title,
              style: AppTextStyle.style14W800.copyWith(
                color: AppColors.primaryDarkColor,
              ),
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
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا العميل؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTextStyle.style14W500.copyWith(
                color: AppColors.blackColor.withAlpha(150),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ClientCubit>().deleteClient(widget.client.id!);
              context.pop();
            },
            child: Text(
              'حذف',
              style: AppTextStyle.style14W500.copyWith(
                color: AppColors.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
