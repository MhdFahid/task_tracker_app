import 'package:flutter/material.dart';

class CustomTextFieldWithButton extends StatefulWidget {
  const CustomTextFieldWithButton({
    super.key,
    required this.hint,
    required this.icon,
    this.icon1,
    this.validator,
    this.onChanged,
    this.controller,
    this.obscureText,
  });
  final String hint;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  final IconData icon;
  final IconData? icon1;
  final TextEditingController? controller;
  final bool? obscureText;

  @override
  State<CustomTextFieldWithButton> createState() =>
      _CustomTextFieldWithButtonState();
}

class _CustomTextFieldWithButtonState extends State<CustomTextFieldWithButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // color: AppColorsConstants.textFieldColor,
      ),
      child: TextFormField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        validator: widget.validator,
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
            hintText: widget.hint,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
    );
  }
}
