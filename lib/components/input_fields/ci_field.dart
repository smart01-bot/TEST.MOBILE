import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';
import '../../helpers/format_with_thousands_separator.dart';

class CIField extends StatefulWidget {
  final TextEditingController inputController;
  final String engLabel;
  final String swLabel;
  final String placeholder;
  final bool onlyDigits;
  final bool haveError;
  final int maxNumber;
  final int maxChars;
  final bool isMoney;
  final Function? onChange;
  final bool readOnly;
  final String prefix;

  const CIField({
    super.key,
    required this.inputController,
    required this.engLabel,
    required this.swLabel,
    required this.placeholder,
    this.onlyDigits = false,
    this.haveError = false,
    this.maxNumber = 0,
    this.onChange,
    this.maxChars = 0,
    this.isMoney = false,
    this.readOnly = false,
    this.prefix = '',
  });

  @override
  State<CIField> createState() => _CIFieldState();
}

class _CIFieldState extends State<CIField> {
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
          color: _isFocused ? CIColors.inputFocusFillColor : CIColors.inputFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.haveError
                ? CIColors.errorBorder
                : (_isFocused ? CIColors.secondaryColor : CIColors.inputBorderColor),
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
                if (widget.prefix.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          widget.prefix,
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
                      SizedBox(width: 8),
                    ],
                  ),
                Expanded(
                  child: SizedBox(
                    child: TextField(
                      readOnly: widget.readOnly,
                      keyboardType: widget.onlyDigits
                          ? TextInputType.number
                          : TextInputType.text,
                      inputFormatters: widget.onlyDigits
                          ? widget.isMoney
                              ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  ThousandSeparatorInputFormatter(),
                                ]
                              : [FilteringTextInputFormatter.digitsOnly]
                          : [FilteringTextInputFormatter.allow(RegExp(r'.*'))],
                      onChanged: (value) {
                        if (widget.onlyDigits && widget.maxNumber > 0) {
                          // Enforce a maximum number
                          int? number = int.tryParse(value.replaceAll(',', ''));

                          if (number != null && number > widget.maxNumber) {
                            // Reset to maximum value if the number exceeds max
                            value = formatWithThousandSeparator(
                                widget.maxNumber.toString());
                          }
                          widget.inputController.value =
                              widget.inputController.value.copyWith(
                            text: value,
                            selection: TextSelection.collapsed(
                                offset: value.length), // Cursor at end
                          );
                        }

                        if (widget.onlyDigits && widget.maxChars > 0) {
                          // Enforce a maximum chars

                          if (value.length > widget.maxChars) {
                            widget.inputController.value =
                                widget.inputController.value.copyWith(
                              text: value.substring(0, widget.maxChars),
                              selection: TextSelection.collapsed(
                                  offset: value
                                      .substring(0, widget.maxChars)
                                      .length), // Cursor at end
                            );
                          }
                        }
                        if (widget.onChange != null) {
                          widget.onChange!(widget.inputController.value);
                        }
                      },
                      focusNode: _focusNode,
                      textAlignVertical: TextAlignVertical.center,
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
                        hintText:
                            "${widget.placeholder} ${widget.onlyDigits && widget.maxNumber > 0 ? "(max: ${formatWithThousandSeparator(widget.maxNumber.toString())})" : ""}",
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

// Thousands separator for money inputs
class ThousandSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return it with the cursor at the start (end of empty string)
    if (newValue.text.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Get the raw digits from the new value (remove non-digits)
    String newDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the number with thousand separators
    String formattedText = formatWithThousandSeparator(newDigits);

    // Always place the cursor at the end of the formatted text
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
