import 'package:flutter/material.dart';

class SignInTextFields extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final bool obscureText;
  final VoidCallback? onPressed;
  final Color fillColor;
  final bool suffixIconPresent;
  final String hintText;
  const SignInTextFields({super.key, required this.focusNode, required this.textEditingController, required this.obscureText, this.onPressed, required this.fillColor, required this.suffixIconPresent, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width*0.12,
      child: TextFormField(
        focusNode: focusNode,
        controller: textEditingController,
        obscureText:obscureText,
        validator: (v){
          if(v!.isEmpty){
            return 'Field must not be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          suffixIcon:suffixIconPresent? IconButton(
              onPressed: onPressed,
              icon: obscureText? Icon(Icons.visibility_outlined, color: Colors.grey.shade400,):Icon(Icons.visibility_off_outlined,color: Colors.grey.shade400,)
          ):null,
          filled: true,
          fillColor: fillColor,
          errorStyle: const TextStyle(fontSize: 0.01),
          hintStyle: const TextStyle(
              fontSize: 12.5
          ),
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:  const BorderSide(
                  color: Colors.transparent
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:  const BorderSide(
                  color: Color(0xffD397F8)
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:  const BorderSide(
                  color: Colors.transparent
              )
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.grey.shade400
              )
          ),
        ),
      ),
    );
  }
}
