import 'package:flutter/material.dart';


class CustomEdit extends StatefulWidget {
  final String hint;
  final TextEditingController textEditingController;
  final IconData iconData;
  final bool isPass;

  CustomEdit({
    super.key,
    required this.hint,
    required this.textEditingController,
    required this.iconData,
    this.isPass = false, // Provide a default value here
  });

  @override
  State<CustomEdit> createState() => _CustomEditState();
}

class _CustomEditState extends State<CustomEdit> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPass; // Initialize _obscureText with isPass
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textEditingController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        prefixIcon: Icon(widget.iconData),
        suffixIcon: widget.isPass
            ? IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        )
            : const SizedBox(width: 20, height: 20),
        hintText: widget.hint,
      ),
    );
  }
}
