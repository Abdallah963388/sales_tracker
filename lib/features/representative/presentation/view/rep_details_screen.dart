import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_tracker/core/responsive/responsive_config.dart';
import 'package:sales_tracker/core/routing/app_routes.dart';
import 'package:sales_tracker/core/shared_widgets/custom_app_bar.dart';
import 'package:sales_tracker/core/theme/app_colors.dart';
import 'package:sales_tracker/core/theme/app_text_style.dart';
import 'package:sales_tracker/features/representative/data/model/single_rep_model.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_cubit.dart';
import 'package:sales_tracker/features/representative/presentation/controller/rep_states.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_cubit.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_states.dart';
import 'package:url_launcher/url_launcher.dart';

class RepDetailsScreen extends StatefulWidget {
  const RepDetailsScreen({required this.repId, super.key});
  final int repId;

  @override
  State<RepDetailsScreen> createState() => _RepDetailsScreenState();
}

class _RepDetailsScreenState extends State<RepDetailsScreen> {
  final bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    if (context.mounted) {
      context.read<RepCubit>().getSingleRep(widget.repId);
      context.read<VisitsCubit>().getVisitsByRep(widget.repId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepCubit, RepState>(
      listener: (context, state) {
        if (state.status == RepStatus.failure && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        if (state.status == RepStatus.loading ||
            state.status == RepStatus.singleLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final rep = state.singleRep;
        if (rep == null) {
          return const Scaffold(
            body: Center(child: Text('لا توجد بيانات')),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: 'تفاصيل المندوب',
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
                    context.pushNamed(AppRoutes.addRepScreen, extra: rep);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
            canBack: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(rep),
                12.verticalSpace,
                _buildSectionCard(
                  title: 'البيانات الأساسية',
                  children: [
                    _item(title: 'الاسم', value: rep.name ?? ''),
                    _item(
                      title: 'رقم الهاتف',
                      value: rep.phone ?? '',
                      icon: Icons.phone,
                      onTap: () async {
                        final phone = rep.phone ?? '';
                        if (phone.isNotEmpty) {
                          final url = Uri(scheme: 'tel', path: phone);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        }
                      },
                    ),
                    _item(
                      title: 'البريد الإلكتروني',
                      value: rep.email ?? '',
                      icon: Icons.email,
                      onTap: () async {
                        final email = rep.email ?? '';
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
                  title: 'زيارات المندوب',
                  children: [
                    BlocBuilder<VisitsCubit, VisitState>(
                      builder: (context, state) {
                        if (state.status == VisitStatus.repVisitsLoading) {
                          return const LinearProgressIndicator();
                        }

                        final visits = state.repVisits ?? [];
                        if (visits.isEmpty) {
                          return const Text('لا توجد زيارات');
                        }

                        return Column(
                          children: visits.map((visit) {
                            return ListTile(
                              title: Text(visit.client?.clientName ?? ''),
                              subtitle: Text(
                                'الموقع: ${visit.client?.region ?? ''}\nالتاريخ: ${visit.createdAt?.substring(0, 10) ?? ''}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: AppColors.primaryDarkColor,
                                ),
                                onPressed: () {
                                  context.pushNamed(
                                    AppRoutes.visitsDetailsScreen,
                                    extra: visit,
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(SingleRepData rep) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Text(
              (rep.name ?? 'R')[0],
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
                  rep.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
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
          Expanded(child: Text(value ?? '', style: AppTextStyle.style12W500)),
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
        content: const Text('هل أنت متأكد أنك تريد حذف هذا المندوب؟'),
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
            onPressed: () {
              Navigator.pop(context);
              context.read<RepCubit>().deleteRep(widget.repId);
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
