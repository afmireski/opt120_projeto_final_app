import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:produto_front/blocs/user_profile_blocs.dart';
import 'package:produto_front/models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileLoadBloc>(
      create: (context) => ProfileLoadBloc()..add(ProfileLoad()),
      child: BlocConsumer<ProfileLoadBloc, ProfileLoadState>(
          listener: (context, state) {
        if (state is LoadedProfile) {
          print('O perfil foi carregado.');
        }
      }, builder: (context, state) {
        List<Widget> profileDisplay = [];
        if (state is LoadingProfile) {
          profileDisplay = [const CircularProgressIndicator()];
        } else if (state is LoadedProfile) {
          profileDisplay = [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Icon(
                  Icons.person,
                  size: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('RA: ${state.user.ra}'),
            const SizedBox(
              height: 5,
            ),
            Text('Nome: ${state.user.name}'),
            const SizedBox(
              height: 5,
            ),
            Text('Email: ${state.user.email}'),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  bool changed = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            ChangeProfileForm(profile: state.user),
                      ) ??
                      false;
                  if (changed) {
                    context.read<ProfileLoadBloc>().add(ProfileLoad());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Perfil alterado com sucesso.')));
                  }
                },
                child: const Text('Editar perfil'),
              ),
            ),
          ];
        } else if (state is NotLoadedProfileWithError) {
          profileDisplay = [Text(state.message)];
        }
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...profileDisplay,
              ],
            ),
          ),
        );
      }),
    );
  }
}

class ChangeProfileForm extends StatefulWidget {
  final User profile;

  const ChangeProfileForm({super.key, required this.profile});

  @override
  State<ChangeProfileForm> createState() => _ChangeProfileFormState();
}

class _ChangeProfileFormState extends State<ChangeProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe uma senha';
    }
    if (value.length < 5) {
      return 'Senha muito curta';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe uma nome';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe um email';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Informe um email inválido';
    }
    return null;
  }

  @override
  void initState() {
    _nameController.text = widget.profile.name;
    _emailController.text = widget.profile.email;
    _passwordController.text = widget.profile.password;
    super.initState();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileChangeBloc>().add(
            ProfileChange(
              User(
                id: widget.profile.id,
                name: _nameController.text,
                email: _emailController.text,
                password: _passwordController.text,
                ra: widget.profile.ra,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileChangeBloc>(
      create: (context) => ProfileChangeBloc(),
      child: BlocConsumer<ProfileChangeBloc, ProfileChangeState>(
        builder: (context, state) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Editar perfil'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      enabled: (state is! ChangingProfile),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: (state is! ChangingProfile),
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      enabled: (state is! ChangingProfile),
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      validator: _validatePassword,
                    ),
                    _errorMessage(context, state),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: (state is ChangingProfile)
                    ? null
                    : () {
                        Navigator.of(context).pop(false);
                      },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: (state is ChangingProfile)
                    ? null
                    : () => _submitForm(context),
                child: (state is ChangingProfile)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Salvar'),
              ),
            ],
          );
        },
        listener: (BuildContext context, ProfileChangeState state) {
          if (state is ChangedProfile) {
            print('O perfil foi salvo.');
            Navigator.of(context).pop(true);
          }
        },
      ),
    );
  }

  Widget _errorMessage(BuildContext context, ProfileChangeState state) {
    if (state is NotChangedProfileWithError) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            state.message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
