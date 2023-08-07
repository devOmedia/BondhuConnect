import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    required this.inputType,
    this.isPassword = false,
    this.inputAction = TextInputAction.next,
    this.onChanged,
  }) : super(key: key);
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final bool isPassword;
  final TextInputAction inputAction;
  final Function(String)? onChanged;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      obscureText: widget.isPassword ? !isVisible : isVisible,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: isVisible
                    ? const Icon(
                        Icons.visibility,
                        color: KColors.secondaryColor,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: KColors.secondaryColor,
                      ),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              )
            : const SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: KColors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: KColors.grey,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: KColors.grey),
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
    );
  }
}
