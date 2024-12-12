import 'package:flutter/material.dart';
import '../services/registration-service.dart';
import 'package:provider/provider.dart';
import '../config/config.dart';
import '../stores/user-store.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // CONTROLLERS //
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController raController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegistrationService registrationService = RegistrationService(Config.baseUrl);
  bool isLoading = false;
  String? selectedRole; // "STUDENT" ou "SERVANT"

  void onRegisterPressed() async {
    if (selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione o tipo de usuário.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await registrationService.register(
        name: nameController.text,
        email: emailController.text,
        ra: raController.text,
        password: passwordController.text,
        role: selectedRole,
      );

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/utfpr_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/logo_reservai.png',
                      width: 200,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: raController,
                            decoration: InputDecoration(
                              labelText: 'RA',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          // Radio Buttons para selecionar o tipo de usuário
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text('Aluno'),
                                leading: Radio<String>(
                                  value: 'STUDENT',
                                  groupValue: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Servidor'),
                                leading: Radio<String>(
                                  value: 'SERVANT',
                                  groupValue: selectedRole,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: onRegisterPressed,
                                  child: Text('Registrar'),
                                ),
                          TextButton(
                            onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Usuário criado com sucesso'),
                                  content: const Text('Você será redirecionado para a tela de login.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        // Limpa as informações do usuário e token no UserStore
                                        final userStore = Provider.of<UserStore>(context, listen: false);
                                        userStore.clearUser(); // Limpa o usuário e token

                                        Navigator.of(context).pushReplacementNamed('/login'); // Redireciona para a tela de login
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                            child: Text('Já possui uma conta? Entrar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
