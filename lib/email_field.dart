import 'package:angry_mark/mythems/theme.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key, this.emailController});

  final TextEditingController? emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.mail,
          color: AppColors.iconLight,
        ),
        label: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Email',
            style: TextStyle(color: AppColors.textLigth, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
