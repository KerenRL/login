import 'package:flutter/material.dart';
import 'features/auth/domain/login_use_case.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/login_view_model.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  final authRepository = AuthRepositoryImpl();
  final loginUseCase = LoginUseCase(authRepository);
  final loginViewModel = LoginViewModel(loginUseCase: loginUseCase);

  runApp(MyApp(loginViewModel: loginViewModel));
}

class MyApp extends StatelessWidget {
  final LoginViewModel loginViewModel;
  
  const MyApp({super.key, required this.loginViewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Clean Architecture',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LoginScreen(viewModel: loginViewModel),
    );
  }
}
