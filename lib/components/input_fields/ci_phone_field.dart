import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CIPhoneField extends StatefulWidget {
  final TextEditingController inputController;
  final String engLabel;
  final String swLabel;
  final String placeholder;
  final bool haveError;

  const CIPhoneField({
    super.key,
    required this.inputController,
    required this.engLabel,
    required this.swLabel,
    this.placeholder = "e.g. 789 123 456",
    this.haveError = false,
  });

  @override
  State<CIPhoneField> createState() => _CIPhoneFieldState();
}

class _CIPhoneFieldState extends State<CIPhoneField> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: _isFocused ? Color(0xffe7f3ff) : Color(0xfff5faff),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.haveError
                ? CIColors.errorBorder
                : (_isFocused ? CIColors.secondaryColor : Color(0xffdcefff)),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              runSpacing: 0,
              children: [
                ...sentenceToTextWidgets("${widget.engLabel} /",
                    color: CIColors.secondaryColor),
                ...sentenceToTextWidgets(widget.swLabel),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    "+255",
                    style: TextStyle(
                      color: widget.haveError
                          ? CIColors.errorColor
                          : CIColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      onChanged: _validateInput,
                      focusNode: _focusNode,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        color: widget.haveError
                            ? CIColors.errorColor
                            : CIColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      controller: widget.inputController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintStyle: TextStyle(
                          color: CIColors.hintColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        hintText: widget.placeholder,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validateInput(String input) {
    String formattedInput =
        input.replaceAll(' ', ''); // Remove spaces for validation

    // Remove any characters except for digits
    formattedInput = formattedInput.replaceAll(RegExp(r'[^0-9]'), '');

    // Remove the first group if it starts with 255 or 0
    if (formattedInput.length > 9) {
      formattedInput =
          formattedInput.substring(0, 9); // Remove the first three characters
    }
    // Remove the first group if it starts with 255 or 0
    if (formattedInput.startsWith('255')) {
      formattedInput =
          formattedInput.substring(3); // Remove the first three characters
    }

    if (formattedInput.startsWith('0')) {
      formattedInput =
          formattedInput.substring(1); // Remove the first three characters
    }

    // Check if input has nine digits
    if (formattedInput.length == 9 &&
        RegExp(r'^\d{9}$').hasMatch(formattedInput)) {
      // Format the string to the desired output
      formattedInput = formattedInput.replaceAllMapped(
          RegExp(r'(\d{3})(?=\d)'), (Match m) => "${m[1]} ");
      formattedInput =
          formattedInput.trim(); // Trim to remove any trailing spaces
    }

    // Update the controller's text and move cursor to the end
    widget.inputController.text = formattedInput;
    widget.inputController.selection =
        TextSelection.fromPosition(TextPosition(offset: formattedInput.length));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
