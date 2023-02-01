import 'package:flutter/material.dart';
import 'package:tech_media/res/color.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
      {super.key,
      required this.myController,
      required this.focusNode,
      required this.onFiledSubmittedValue,
      required this.keyBoardType,
      required this.obscureText,
      required this.hint,
      this.enable = true,
      required this.onValidator,
      this.autofocus = false});

  final TextEditingController myController;
  final FocusNode focusNode;
  final FormFieldSetter onFiledSubmittedValue;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final String hint;
  final bool obscureText;
  final bool enable, autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: myController,
        focusNode: focusNode,
        obscureText: obscureText,
        cursorColor: AppColors.primaryTextTextColor,
        onFieldSubmitted: onFiledSubmittedValue,
        validator: onValidator,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 19),
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          enabled: enable,
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: AppColors.primaryTextTextColor.withOpacity(0.8),
              ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.textFieldDefaultFocus),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondaryColor),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.alertColor),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors.textFieldDefaultBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
