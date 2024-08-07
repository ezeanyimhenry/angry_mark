import 'package:angry_mark/mythems/theme.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField(
      {super.key,
      this.passwordController,
      required this.onPressed,
      required this.isVisible});

  final TextEditingController? passwordController;
  final VoidCallback onPressed;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: AppColors.textLigth,
        fontSize: 13,
      ),
      obscureText: isVisible,
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.key,
          color: AppColors.iconLight,
        ),
        suffixIcon: IconButton(
          onPressed: onPressed,
          icon: Icon(
            isVisible ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
            color: AppColors.iconLight,
          ),
          // icon: SvgPicture.asset(
          //   width: 18,
          //   height: 18,
          //   // colorFilter: const ColorFilter.mode(lighterBlack, BlendMode.srcIn),
          //   isVisible ? 'assets/eye.svg' : 'assets/eye_hidden.svg',
          //   fit: BoxFit.scaleDown,
          // ),
        ),
        label: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Password',
            style: TextStyle(color: AppColors.textLigth, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
