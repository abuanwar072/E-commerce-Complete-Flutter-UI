import 'package:flutter/material.dart';

import '../../../components/buy_full_ui_kit.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyFullKit(images: [
      "assets/screens/Forgot_password.png",
      "assets/screens/Forgot password 6.png",
      "assets/screens/Enter verification code.png",
      "assets/screens/Verificaition code.png",
      "assets/screens/Reset password.png",
    ]);
  }
}
