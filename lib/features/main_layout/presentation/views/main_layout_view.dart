import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:sit/core/cache_helper/cache_helper.dart';
import 'package:sit/core/localization/s.dart';
import 'package:sit/core/responsive/responsive_config.dart';
import 'package:sit/core/theme/app_colors.dart';
import 'package:sit/core/theme/app_text_style.dart';
import 'package:sit/features/main_layout/data/models/tab_item_model.dart';
import 'package:sit/features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/controllers/service_bloc.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/home/presentation/views/home_view.dart';
import 'package:sit/features/main_layout/presentation/views/tabs/services/services_view.dart';
import 'package:sit/features/sales_features/my_app/controller/localization_cubit/localization_cubit.dart';

class MainLayoutView extends StatefulWidget {
  const MainLayoutView({super.key});

  @override
  State<MainLayoutView> createState() => _MainLayoutViewState();
}

class _MainLayoutViewState extends State<MainLayoutView> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    context.read<ServiceBloc>().add(const FetchServicesEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        final localizationCubit = context.read<LocalizationCubit>();
        Future.microtask(() {
          final s = S.of(context)!;
          context.read<MainLayoutCubit>().setTabs([
            TabItemModel(
              label: s.home,
              icon: IconlyBroken.home,
              page: HomeView(
                onPageChanged: context.read<MainLayoutCubit>().onPageChanged,
                pageController: _pageController,
              ),
            ),
            TabItemModel(
              label: s.services,
              icon: IconlyBroken.category,
              page: const ServicesView(),
            ),
          ]);
        });
        return BlocBuilder<MainLayoutCubit, MainLayoutState>(
          builder: (context, state) {
            final cubit = context.read<MainLayoutCubit>();

            if (state.tabs.isEmpty) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 70.h,
                shape: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 0.7,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
                ),
                centerTitle: true,
                title: Text(
                  'Sales Tracker',
                  style: AppTextStyle.style18W700.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final newLang = CacheHelper.getLanguage() == 'ar'
                          ? 'en'
                          : 'ar';
                      await localizationCubit.changeLanguage(
                        Locale(newLang),
                      );
                      context.read<ServiceBloc>().add(
                        const FetchServicesEvent(),
                      );
                    },
                    icon: Icon(
                      size: 30.r,
                      Icons.language_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
              body: PageView(
                controller: _pageController,
                onPageChanged: cubit.onPageChanged,
                children: state.tabs.map((t) => t.page).toList(),
              ),
              bottomNavigationBar: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 0.8,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: state.currentIndex,
                  onTap: (index) => cubit.goToPage(index, _pageController),
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.blackColor.withAlpha(150),
                  type: BottomNavigationBarType.fixed,
                  items: state.tabs.map((tab) {
                    final isActive =
                        state.tabs.indexOf(tab) == state.currentIndex;
                    return BottomNavigationBarItem(
                      icon: isActive
                          ? Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(320.r),
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                tab.icon,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : Icon(
                              tab.icon,
                              color: AppColors.blackColor.withAlpha(150),
                            ),
                      label: tab.label,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
