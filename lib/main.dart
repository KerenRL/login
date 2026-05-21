import 'package:flutter/material.dart';
import 'features/auth/domain/login_use_case.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/login_view_model.dart';
import 'features/auth/presentation/login_screen.dart';
import 'core/security/location_security_service.dart';

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
      home: SafeCheckWrapper(
        child: LoginScreen(viewModel: loginViewModel),
      ),
    );
  }
}

class SafeCheckWrapper extends StatefulWidget {
  final Widget child;
  const SafeCheckWrapper({super.key, required this.child});

  @override
  State<SafeCheckWrapper> createState() => _SafeCheckWrapperState();
}

class _SafeCheckWrapperState extends State<SafeCheckWrapper> {
  bool _isChecking = true;
  bool _isFakeGpsDetected = false;

  @override
  void initState() {
    super.initState();
    _checkSecurity();
  }

  Future<void> _checkSecurity() async {
    setState(() => _isChecking = true);
    
    // Pequeño delay para asegurar que la UI se renderice antes de la comprobación
    await Future.delayed(const Duration(milliseconds: 500));
    final isMock = await LocationSecurityService.isMockLocationDetected();
    
    setState(() {
      _isFakeGpsDetected = isMock;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Verificando seguridad del dispositivo..."),
            ],
          ),
        ),
      );
    }

    if (_isFakeGpsDetected) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_disabled, size: 100, color: Colors.redAccent),
              const SizedBox(height: 30),
              const Text(
                'Fake GPS Detectado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                'Se ha detectado el uso de una aplicación para simular la ubicación. Por motivos de seguridad, debes desactivarla para poder utilizar esta aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _checkSecurity,
                  child: const Text('Reintentar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}
