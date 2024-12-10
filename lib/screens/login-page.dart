import 'package:flutter/material.dart';
import '../config/config.dart';
import '../services/auth-service.dart';
import '../stores/user-store.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final AuthService authService = AuthService(Config.baseUrl);

  bool isLoading = false;

  void onLoginPressed() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String loginInput = loginController.text;

      // Determina se o login é email ou RA
      final bool isEmail = loginInput.contains('@');
      final loginData = await authService.login(
        email: isEmail ? loginInput : null,
        ra: isEmail ? null : loginInput,
        senha: senhaController.text,
      );

      // Buscando informações completas do usuário pelo ID
      final userData = await authService.fetchUserById(loginData['id']);
      final user = User.fromJson(userData);

      // Atualizando o UserStore
      final userStore = Provider.of<UserStore>(context, listen: false);
      userStore.setUser(user);

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/home');
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
          // Fundo com imagem
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../images/utfpr_background.PNG'),
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
                    // Logo acima do formulário
                    Image.asset(
                      '../images/logo_reservai.png',
                      width: 200,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    // Container com o formulário de login
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
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
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: loginController,
                              decoration: InputDecoration(
                                labelText: 'Email ou RA',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: senhaController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 20),
                            isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: onLoginPressed,
                                    child: Text('Login'),
                                  ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: Text('Não tem uma conta? Cadastre-se'),
                            ),
                          ],
                        ),
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
