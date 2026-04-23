part of 'maintenance_cubit.dart';

abstract class MaintenanceState {}

class MaintenanceInitial extends MaintenanceState {}

class MaintenanceLoading extends MaintenanceState {}

class MaintenanceResolved extends MaintenanceState {}

class MaintenanceStillActive extends MaintenanceState {
  MaintenanceStillActive(this.message);
  final String message;
}
