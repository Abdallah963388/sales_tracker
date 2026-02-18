import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '/../core/localization/s.dart';
import '/../core/responsive/responsive_config.dart';
import '/../core/theme/app_colors.dart';
import '/../features/main_layout/data/models/tab_item_model.dart';
import '/../features/main_layout/presentation/controllers/cubit/main_layout_cubit.dart';
import '/../features/my_app/controller/localization_cubit/localization_cubit.dart';

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
        Future.microtask(() {
          final s = S.of(context)!;
          context.read<MainLayoutCubit>().setTabs([
            TabItemModel(
              label: s.home,
              icon: IconlyBroken.home,
              page: const SizedBox(),
            ),
            TabItemModel(
              label: s.services,
              icon: IconlyBroken.category,
              page: const SizedBox(),
            ),
            TabItemModel(
              label: s.profile,
              icon: IconlyBroken.work,
              page: const SizedBox(),
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
                // title: Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                //   child: Image.asset(
                //     AppImages.appLogoWhithoutBg,
                //     width: 50.w,
                //     fit: BoxFit.fitWidth,
                //   ),
                // ),
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
                  unselectedItemColor: DefaultSelectionStyle.defaultColor,
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
                              color: DefaultSelectionStyle.defaultColor,
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
