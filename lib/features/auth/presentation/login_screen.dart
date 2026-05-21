import 'package:flutter/material.dart';
import 'login_view_model.dart';
import '../../../core/security/security_service.dart';

class LoginScreen extends StatefulWidget {
  final LoginViewModel viewModel;
  const LoginScreen({super.key, required this.viewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SecurityService.setSecureMode(true);
  }

  @override
  void dispose() {
    SecurityService.setSecureMode(false);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Clean Architecture')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email (admin@mail.com)'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password (123456)'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (widget.viewModel.errorMessage.isNotEmpty)
                  Text(widget.viewModel.errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                widget.viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final success = await widget.viewModel.login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (success) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Login Exitoso')),
                            );
                          }
                        },
                        child: const Text('Entrar'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
