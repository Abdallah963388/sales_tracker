abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {}

class ProfileFailed extends ProfileState {
  ProfileFailed(this.message);
  final String message;
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  ProfileUpdateSuccess(this.message);
  final String message;
}

class ProfileUpdateFailed extends ProfileState {
  ProfileUpdateFailed(this.message);
  final String message;
}
