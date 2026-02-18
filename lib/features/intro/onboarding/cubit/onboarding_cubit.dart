import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);
  int onBoardingIndex = 0;
  void setOnBoardingIndex(int i) {
    onBoardingIndex = i;
    emit(onBoardingIndex);
  }
}
