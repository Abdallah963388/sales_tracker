import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_tracker/core/services/loading.dart';
import 'package:sales_tracker/features/clients/data/repo/client_repo.dart';
import 'package:sales_tracker/features/clients/presentation/controller/client_state.dart';
import 'package:sales_tracker/features/visits/data/repo/visits_repo.dart';

// class ClientCubit extends Cubit<List<ClientModel>> {
//   ClientCubit(this.local) : super([]);
//   final LocalDataSource local;

//   Future<void> getClients() async {
//     final clients = await local.getClients();
//     emit(clients);
//   }

//   Future<void> addClient(ClientModel client) async {
//     await local.addClient(client);
//     await getClients();
//   }
// }

class ClientCubit extends Cubit<ClientState> {
  ClientCubit(this.repo, this.visitsrepo) : super(const ClientState());
  final ClientRepo repo;
  final VisitsRepo visitsrepo;
  final clientNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessDetailsController = TextEditingController();
  final regionController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final visitDetailsController = TextEditingController();
  double? latitude;
  double? longitude;
  ////
  // List<ClientsResponse>? clients;
  Future<void> getClients() async {
    try {
      showLoading();

      emit(state.copyWith(status: ClientStatus.loading));

      final response = await repo.getClients();

      hideLoading();

      emit(
        state.copyWith(
          status: ClientStatus.success,
          clients: response,
        ),
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: ClientStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> addClient() async {
    if (clientNameController.text.isEmpty || phoneController.text.isEmpty) {
      emit(state.copyWith(error: 'حدث خطأ'));
      return;
    }

    emit(state.copyWith(status: ClientStatus.addLoading));
    showLoading();

    final result = await repo.addClient(
      clientName: clientNameController.text,
      businessName: businessNameController.text,
      businessDetails: businessDetailsController.text,
      region: regionController.text,
      location: locationController.text,
      latitude: latitude.toString(),
      longitude: longitude.toString(),
      phone: phoneController.text,
      email: emailController.text,
    );

    result.fold(
      (failure) {
        hideLoading();
        emit(state.copyWith(error: failure.errMessage));
      },
      (clientId) async {
        await visitsrepo.addVisit(
          clientId: clientId.toString(),
          details: visitDetailsController.text,
          latitude: latitude!.toString(),
          longitude: longitude!.toString(),
          location: locationController.text,
          attachment: null,
        );
        hideLoading();
        resetForm();
        await getClients();

        emit(
          state.copyWith(
            status: ClientStatus.addSuccess,
            // message: message,
          ),
        );
      },
    );
  }

  // Client? singleClient;

  Future<void> getSingleClient(int clientId) async {
    emit(state.copyWith(status: ClientStatus.loading));
    showLoading();

    final result = await repo.getSingleClient(clientId);

    return result.fold(
      (failure) {
        hideLoading();
        emit(state.copyWith(error: failure.errMessage));
        // throw Exception(failure.errMessage);
      },
      (client) {
        hideLoading();

        emit(
          state.copyWith(
            status: ClientStatus.success,
            singleClient: client,
          ),
        );
        // return client;
      },
    );
  }

  Future<void> deleteClient(int clientId) async {
    emit(state.copyWith(status: ClientStatus.deleteLoading));

    final result = await repo.deleteClient(clientId);

    result.fold(
      (failure) => emit(state.copyWith(error: failure.errMessage)),
      (message) async {
        final response = await repo.getClients();
        final allResponse = await repo.getAllClients();

        emit(
          state.copyWith(
            message: message,
            status: ClientStatus.deleteSuccess,
            clients: response,
            allClients: allResponse,
          ),
        );
      },
    );
  }

  Future<void> updateClient(int clientId) async {
    emit(state.copyWith(status: ClientStatus.updateLoading));
    showLoading();

    final result = await repo.updateClient(
      clientId: clientId,
      data: {
        'client_name': clientNameController.text,
        'business_name': businessNameController.text,
        'business_details': businessDetailsController.text,
        'region': regionController.text,
        'location': locationController.text,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phoneController.text,
        'email': emailController.text,
      },
    );

    result.fold(
      (failure) {
        hideLoading();
        emit(state.copyWith(error: failure.errMessage));
      },
      (message) async {
        hideLoading();
        // final client = (await getSingleClient(clientId)) as Client?;
        final response = await repo.getClients();
        final allResponse = await repo.getAllClients();
        resetForm();
        emit(
          state.copyWith(
            message: message,
            // singleClient: client,
            clients: response,
            allClients: allResponse,
            status: ClientStatus.updateSuccess,
          ),
        );
      },
    );
  }

  Future<void> getAllClients() async {
    try {
      showLoading();

      emit(
        state.copyWith(
          status: ClientStatus.loading,
        ),
      );

      final response = await repo.getAllClients();

      hideLoading();

      emit(
        state.copyWith(
          status: ClientStatus.success,
          allClients: response,
        ),
      );
    } catch (e) {
      hideLoading();

      emit(
        state.copyWith(
          status: ClientStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void resetForm() {
    clientNameController.clear();
    businessNameController.clear();
    businessDetailsController.clear();
    regionController.clear();
    locationController.clear();
    phoneController.clear();
    emailController.clear();
    visitDetailsController.clear();

    latitude = null;
    longitude = null;
  }
}
