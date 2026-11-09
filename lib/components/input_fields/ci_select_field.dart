import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CISelectField extends StatefulWidget {
  final TextEditingController inputController;
  final String engLabel;
  final String swLabel;
  final String placeholder;
  final List<String> options;
  final Map<String, String>? optionValues;
  final String? selectedOption;
  final Function selectOption;
  final bool haveError;

  const CISelectField({
    super.key,
    required this.inputController,
    required this.engLabel,
    required this.swLabel,
    required this.placeholder,
    required this.options,
    required this.selectedOption,
    required this.selectOption,
    this.optionValues,
    this.haveError = false,
  });

  @override
  State<CISelectField> createState() => _CISelectFieldState();
}

class _CISelectFieldState extends State<CISelectField> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  String selectedValue = 'Option 1';

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
            SizedBox(
              height: 25,
              child: DropdownButtonFormField<String>(
                hint: Text(
                  '- - ${widget.placeholder} - -',
                  style: TextStyle(
                    color: widget.haveError
                        ? CIColors.errorText
                        : CIColors.hintColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.normal,
                    overflow: TextOverflow.ellipsis,
                    fontFamily: 'Inter',
                    fontSize: 16,
                  ),
                ),
                focusNode: _focusNode,
                value: widget.selectedOption,
                icon: FaIcon(
                  FontAwesomeIcons.caretDown,
                  size: 14,
                  color: CIColors.accentColor,
                ),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: CIColors.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter',
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                onChanged: (newValue) {
                  widget.selectOption(newValue!);
                },
                validator: (value) => value == null ? widget.placeholder : null,
                selectedItemBuilder: (BuildContext context) {
                  return widget.options.map((String option) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width - 95,
                      child: Text(
                        widget.optionValues != null
                            ? widget.optionValues![option] ?? option
                            : option,
                        overflow: TextOverflow
                            .ellipsis, // Handling overflow with ellipsis
                        maxLines: 1, // Prevent text from wrapping to a new line
                      ),
                    );
                  }).toList();
                },
                items: widget.options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      widget.optionValues != null
                          ? widget.optionValues![option] ?? option
                          : option,
                    ),
                  );
                }).toList(),
              ),
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
