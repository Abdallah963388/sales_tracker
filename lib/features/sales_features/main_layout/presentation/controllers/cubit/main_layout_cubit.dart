import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sit/core/shared_controllers/safe_cubit.dart';

import '/../features/main_layout/data/models/tab_item_model.dart';

part 'main_layout_state.dart';

class SalesMainLayoutCubit extends SafeCubit<SalesMainLayoutState> {
  SalesMainLayoutCubit()
    : super(
        const SalesMainLayoutState(
          currentIndex: 0,
          tabs: [],
        ),
      );

  void setTabs(List<TabItemModel> tabs) {
    emit(state.copyWith(tabs: tabs));
  }

  int backPressCount = 0;

  void resetBackPress() {
    backPressCount = 0;
  }

  PageController? controller;
  Future<void> gotoPage(int index) async {
    if (index == state.currentIndex) return;
    resetBackPress();

    emit(state.copyWith(currentIndex: index));

    if (controller != null && controller!.hasClients) {
      controller!.jumpToPage(index);
    }
  }

  void reset() {
    backPressCount = 0;
    controller = PageController(initialPage: 0);
    emit(const SalesMainLayoutState(currentIndex: 0, tabs: []));
  }
}
