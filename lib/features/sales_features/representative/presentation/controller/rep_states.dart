

import 'package:sit/features/sales_features/representative/data/model/rep_model.dart';
import 'package:sit/features/sales_features/representative/data/model/single_rep_model.dart';

enum RepStatus {
  initial,
  loading,
  success,
  failure,
  addLoading,
  addSuccess,
  deleteLoading,
  deleteSuccess,
  updateLoading,
  updateSuccess,
  singleLoading,
  singleSuccess,
}

class RepState {
  const RepState({
    this.status = RepStatus.initial,
    this.reps,
    this.singleRep,
    this.message,
    this.error,
  });

  final RepStatus status;
  final List<RepsResponse>? reps;
  final SingleRepData? singleRep;
  final String? message;
  final String? error;

  RepState copyWith({
    RepStatus? status,
    List<RepsResponse>? reps,
    SingleRepData? singleRep,
    String? message,
    String? error,
  }) {
    return RepState(
      status: status ?? this.status,
      reps: reps ?? this.reps,
      singleRep: singleRep ?? this.singleRep,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}
