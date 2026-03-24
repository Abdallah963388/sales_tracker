import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_tracker/core/services/loading.dart';
import 'package:sales_tracker/features/visits/data/model/visits_model.dart';
import 'package:sales_tracker/features/visits/data/repo/visits_repo.dart';
import 'package:sales_tracker/features/visits/presentation/controller/visits_states.dart';

class VisitsCubit extends Cubit<VisitState> {
  VisitsCubit(this.repo) : super(const VisitState());

  final VisitsRepo repo;

  final detailsController = TextEditingController();
  final locationNameController = TextEditingController();
  final addressNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final visitDetailsController = TextEditingController();

  double? latitude;
  double? longitude;
  int? selectedClientId;

  PlatformFile? attachmentFile;

  Future<void> getVisits() async {
    try {
      showLoading();

      emit(state.copyWith(status: VisitStatus.loading));

      final response = await repo.getVisits();

      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.success,
          visits: response,
        ),
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> addVisit() async {
    if (selectedClientId == null ||
        visitDetailsController.text.isEmpty ||
        locationNameController.text.isEmpty) {
      emit(state.copyWith(error: 'يرجى ملء جميع البيانات المطلوبة'));
      return;
    }

    if (latitude == null || longitude == null) {
      emit(state.copyWith(error: 'يرجى تحديد الموقع'));
      return;
    }

    try {
      emit(state.copyWith(status: VisitStatus.addLoading));
      showLoading();

      final result = await repo.addVisit(
        clientId: selectedClientId.toString(),
        details: visitDetailsController.text,
        latitude: latitude!.toString(),
        longitude: longitude!.toString(),
        location: locationNameController.text,
        attachment: attachmentFile?.path ?? '',
      );

      result.fold(
        (failure) {
          hideLoading();
          emit(
            state.copyWith(
              status: VisitStatus.failure,
              error: failure.errMessage,
            ),
          );
        },
        (message) async {
          hideLoading();
          resetForm();
          await getVisits();

          emit(
            state.copyWith(
              status: VisitStatus.addSuccess,
              message: message,
            ),
          );
        },
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> getSingleVisit(int visitId) async {
    try {
      emit(state.copyWith(status: VisitStatus.singleLoading));

      showLoading();

      final result = await repo.getSingleVisit(visitId);

      result.fold(
        (failure) {
          hideLoading();

          emit(
            state.copyWith(
              status: VisitStatus.failure,
              error: failure.errMessage,
            ),
          );
        },
        (visit) {
          hideLoading();

          emit(
            state.copyWith(
              status: VisitStatus.singleSuccess,
              singleVisit: visit,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteVisit(int visitId) async {
    emit(state.copyWith(status: VisitStatus.deleteLoading));

    final result = await repo.deleteVisit(visitId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: failure.errMessage,
        ),
      ),
      (message) async {
        await getVisits();

        emit(
          state.copyWith(
            status: VisitStatus.deleteSuccess,
            message: message,
          ),
        );
      },
    );
  }

  Future<void> getAllVisits() async {
    try {
      showLoading();

      emit(state.copyWith(status: VisitStatus.allLoading));

      final response = await repo.getAllVisits();

      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.allSuccess,
          allVisits: response,
        ),
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> adminDeleteVisit(int visitId) async {
    showLoading();
    emit(state.copyWith(status: VisitStatus.adminDeleteLoading));

    final result = await repo.adminDeleteVisit(visitId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: failure.errMessage,
        ),
      ),
      (message) async {
        await getVisits();

        emit(
          state.copyWith(
            status: VisitStatus.adminDeleteSuccess,
            message: message,
          ),
        );
      },
    );
  }

  Future<void> getClientVisits(int clientId) async {
    try {
      emit(state.copyWith(status: VisitStatus.clientVisitsLoading));

      // showLoading();

      final result = await repo.getClienVisits(clientId);

      result.fold(
        (failure) {
          // hideLoading();

          emit(
            state.copyWith(
              status: VisitStatus.failure,
              error: failure.errMessage,
            ),
          );
        },
        (visits) {
          // hideLoading();

          emit(
            state.copyWith(
              status: VisitStatus.clientVisitsSuccess,
              clientVisits: visits,
            ),
          );
        },
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void resetForm() {
    detailsController.clear();
    locationNameController.clear();
    phoneController.clear();
    emailController.clear();
    visitDetailsController.clear();
    addressNameController.clear();

    latitude = null;
    longitude = null;
    selectedClientId = null;
    attachmentFile = null;
  }

  Future<void> downloadAttachment(String url) async {
    emit(state.copyWith(status: VisitStatus.downloadLoading));

    final result = await repo.downloadAttachment(url);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: VisitStatus.failure,
            error: failure.errMessage,
          ),
        );
      },
      (path) {
        emit(
          state.copyWith(
            status: VisitStatus.downloadSuccess,
            message: 'تم تحميل الملف بنجاح',
          ),
        );
      },
    );
  }

  List<Visit>? repVisits;

  Future<void> getVisitsByRep(int repId) async {
    emit(state.copyWith(status: VisitStatus.repVisitsLoading));
    try {
      final response = await repo.getAllVisits(); 

      repVisits = response
          .expand((element) => element.data?.visits ?? []) 
          .whereType<Visit>() 
          .where((visit) => visit.repId == repId) 
          .toList();

      emit(
        state.copyWith(
          status: VisitStatus.repVisitsSuccess,
          repVisits: repVisits,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VisitStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
