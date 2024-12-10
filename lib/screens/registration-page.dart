import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  // CONTROLLERS //
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController ra = TextEditingController();
  final TextEditingController password = TextEditingController();

  void onSubmit(BuildContext context) {
    print('Name: ${name.text}');
    print('Email: ${email.text}');
    print('RA: ${ra.text}');
    print('Senha: ${password.text}');
    
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com image
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
                      '../images/logo_reservai.png', // Certifique-se de que o caminho está correto
                      width: 200,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    // Container com o formulário de registro
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
                            controller: name,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: ra,
                            decoration: InputDecoration(
                              labelText: 'RA',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: password,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => onSubmit(context),
                            child: Text('Registrar'),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
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
