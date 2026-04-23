
import 'package:sit/features/sales_features/admin_home/data/model/admin_home_model.dart';

abstract class AdminHomeStates {}

class AdminHomeInitial extends AdminHomeStates {}

class AdminHomeLoading extends AdminHomeStates {}

class AdminHomeSuccess extends AdminHomeStates {
  AdminHomeSuccess(this.dashboard);
  final AdminHomeModel dashboard;
}

class AdminHomeFailed extends AdminHomeStates {
  AdminHomeFailed(this.error);
  final String error;
}
