import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/config.dart';
import '../services/registration-service.dart';
import '../stores/user-store.dart';
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserStore>(context).currentUser;

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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Icon(
                Icons.person,
                size: 100, // Ícone menor
              ),
            ),
            const SizedBox(height: 20),
            if (user != null) ...[
              Text('Nome: ${user.nome}', style: TextStyle(fontSize: 16)),
              Text('Email: ${user.email}', style: TextStyle(fontSize: 16)),
              Text('RA: ${user.ra}', style: TextStyle(fontSize: 16)),
              Text('Role: ${user.role}', style: TextStyle(fontSize: 16)),
            ] else
              const Text('Usuário não encontrado.'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const ChangeProfileForm(),
                );
              },
              child: const Text('Editar perfil'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeProfileForm extends StatefulWidget {
  const ChangeProfileForm({super.key});

  @override
  State<ChangeProfileForm> createState() => _ChangeProfileFormState();
}

class _ChangeProfileFormState extends State<ChangeProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _raController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserStore>(context, listen: false).currentUser;

    if (user != null) {
      _nameController.text = user.nome;
      _emailController.text = user.email;
      _raController.text = user.ra ?? '';
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      try {
        final user = Provider.of<UserStore>(context, listen: false).currentUser;
        final registrationService = RegistrationService(Config.baseUrl);

        if (user != null) {
          await registrationService.alter(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            role: user.role, // Sempre envia o role atual do usuário
          );

          // Atualiza o UserStore
          Provider.of<UserStore>(context, listen: false).setUser(
            User(
              nome: _nameController.text,
              email: _emailController.text,
              ra: _raController.text,
              role: user.role, // Role permanece o mesmo
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso.')),
          );

          Navigator.of(context).pushReplacementNamed('/home'); 
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Editar perfil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe um nome'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe um email'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _raController,
                decoration: const InputDecoration(
                  labelText: 'RA',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe uma senha'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
      SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: 10), // Espaçamento entre os botões
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading ? null : _submitForm,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Salvar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}