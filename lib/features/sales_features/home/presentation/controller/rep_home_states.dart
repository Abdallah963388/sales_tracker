part of 'rep_home_cubit.dart'; // هذا السطر فقط في الأعلى


abstract class RepHomeState {}

class RepHomeInitial extends RepHomeState {}

class RepHomeLoading extends RepHomeState {}

class RepHomeSuccess extends RepHomeState {
  RepHomeSuccess(this.dashboard);
  final RepHomeModel dashboard;
}

class RepHomeFailed extends RepHomeState {
  RepHomeFailed(this.error);
  final String error;
}