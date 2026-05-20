import 'package:flutter/material.dart';
import '../domain/login_use_case.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginViewModel({required this.loginUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final success = await loginUseCase.execute(email, password);

    if (!success) {
      _errorMessage = 'Credenciales incorrectas';
    }
    
    _isLoading = false;
    notifyListeners();
    return success;
  }
}
