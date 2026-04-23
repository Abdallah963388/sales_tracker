part of 'main_layout_cubit.dart';

class SalesMainLayoutState extends Equatable {
  const SalesMainLayoutState({
    required this.currentIndex,
    required this.tabs,
  });
  final int currentIndex;
  final List<TabItemModel> tabs;

  SalesMainLayoutState copyWith({
    int? currentIndex,
    List<TabItemModel>? tabs,
  }) {
    return SalesMainLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      tabs: tabs ?? this.tabs,
    );
  }

  @override
  List<Object?> get props => [currentIndex, tabs];
}
