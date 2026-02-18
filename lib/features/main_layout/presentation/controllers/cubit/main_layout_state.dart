part of 'main_layout_cubit.dart';

class MainLayoutState extends Equatable {
  const MainLayoutState({
    required this.currentIndex,
    required this.tabs,
  });
  final int currentIndex;
  final List<TabItemModel> tabs;

  MainLayoutState copyWith({
    int? currentIndex,
    List<TabItemModel>? tabs,
  }) {
    return MainLayoutState(
      currentIndex: currentIndex ?? this.currentIndex,
      tabs: tabs ?? this.tabs,
    );
  }

  @override
  List<Object?> get props => [currentIndex, tabs];
}
