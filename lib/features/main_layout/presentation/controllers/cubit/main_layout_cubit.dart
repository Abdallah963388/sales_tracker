import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/../features/main_layout/data/models/tab_item_model.dart';

part 'main_layout_state.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit()
    : super(
        const MainLayoutState(
          currentIndex: 0,
          tabs: [],
        ),
      );

  void setTabs(List<TabItemModel> tabs) {
    emit(state.copyWith(tabs: tabs));
  }

  Future<void> goToPage(int index, PageController? controller) async {
    if (index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: index));

    if (controller != null && controller.hasClients) {
      await controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    if (index == state.currentIndex) return;
    emit(state.copyWith(currentIndex: index));
  }
}
