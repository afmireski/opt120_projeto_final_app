import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:produto_front/client.dart';
import 'package:produto_front/models/user.dart';

abstract class ProfileChangeState {}

class NotChangedProfile extends ProfileChangeState {}

class ChangingProfile extends ProfileChangeState {}

class ChangedProfile extends ProfileChangeState {}

class NotChangedProfileWithError extends ProfileChangeState {
  final String message;
  NotChangedProfileWithError(this.message);
}

abstract class ProfileChangeEvent {}

class ProfileChange extends ProfileChangeEvent {
  final User profile;
  ProfileChange(this.profile);
}

class ProfileChangeBloc extends Bloc<ProfileChangeEvent, ProfileChangeState> {
  ProfileChangeBloc() : super(NotChangedProfile()) {
    on<ProfileChange>(
      (event, emit) async {
        emit(ChangingProfile());
        print('Perfil recebido pelo BLoC: ${event.profile.toJson()}');
        await Future.delayed(Duration(seconds: 3));
        emit(ChangedProfile());
        /*Response response = (await Client().request(
          endpoint: Endpoint.ProfileChange,
          body: {
            'Profile': event.Profile,
          },
        ))!;
        if (response.statusCode == 200) {
          emit(ChangedProfile());
        } else {
          emit(NotChangedProfileWithError('Não foi possível trocar a senha'));
        }*/
      },
    );
  }
}

abstract class ProfileLoadState {}

class NotLoadedProfile extends ProfileLoadState {}

class LoadingProfile extends ProfileLoadState {}

class LoadedProfile extends ProfileLoadState {
  final User user;
  LoadedProfile(this.user);
}

class NotLoadedProfileWithError extends ProfileLoadState {
  final String message;
  NotLoadedProfileWithError(this.message);
}

abstract class ProfileLoadEvent {}

class ProfileLoad extends ProfileLoadEvent {}

class ProfileLoadBloc extends Bloc<ProfileLoadEvent, ProfileLoadState> {
  ProfileLoadBloc() : super(NotLoadedProfile()) {
    on<ProfileLoad>(
      (event, emit) async {
        emit(LoadingProfile());
        User faux = User(
          email: 'faux@utfpr.edu.br',
          id: 9,
          name: 'Faux Nomine',
          ra: '2135760',
          password: 'password',
        );
        emit(LoadedProfile(faux));

        /*Response response = (await Client().request(
          endpoint: Endpoint.profileLoad,
        ))!;
        if (response.statusCode == 200) {
          emit(LoadedProfile());
        } else {
          emit(NotLoadedProfileWithError('Não foi possível carregar o perfil'));
        }*/
      },
    );
  }
}
