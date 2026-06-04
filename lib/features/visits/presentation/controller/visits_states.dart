import 'package:equatable/equatable.dart';
import 'package:sit/features/visits/data/model/visits_model.dart';

enum VisitStatus {
  initial,
  loading,
  success,
  failure,
  downloadLoading,
  downloadSuccess,
  addLoading,
  addSuccess,
  deleteLoading,
  deleteSuccess,
  adminDeleteLoading,
  adminDeleteSuccess,
  singleLoading,
  singleSuccess,
  allLoading,
  allSuccess,
  clientVisitsLoading,
  clientVisitsSuccess,
  repVisitsLoading,
  repVisitsSuccess,
}

class VisitState extends Equatable {
  const VisitState({
    this.status = VisitStatus.initial,
    this.visits,
    this.allVisits,
    this.clientVisits,
    this.repVisits,
    this.singleVisit,
    this.message,
    this.error,
  });

  final VisitStatus status;

  final List<VisitsResponse>? visits;
  final List<VisitsResponse>? allVisits;
  final List<Visit>? clientVisits;
  final List<Visit>? repVisits;

  final Visit? singleVisit;

  final String? message;
  final String? error;

  VisitState copyWith({
    VisitStatus? status,
    List<VisitsResponse>? visits,
    List<VisitsResponse>? allVisits,
    List<Visit>? clientVisits,
    List<Visit>? repVisits, 
    Visit? singleVisit,
    String? message,
    String? error,
  }) {
    return VisitState(
      status: status ?? this.status,
      visits: visits ?? this.visits,
      allVisits: allVisits ?? this.allVisits,
      clientVisits: clientVisits ?? this.clientVisits,
      repVisits: repVisits ?? this.repVisits, 
      singleVisit: singleVisit ?? this.singleVisit,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    visits,
    allVisits,
    clientVisits,
    repVisits, 
    singleVisit,
    message,
    error,
  ];
}
