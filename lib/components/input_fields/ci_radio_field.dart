import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CIRadioField extends StatefulWidget {
  final String engLabel;
  final String swLabel;
  final Map<String, List<String>> options;
  final Function setOption;
  final String? selectedOption;
  final bool haveError;

  const CIRadioField({
    super.key,
    required this.engLabel,
    required this.swLabel,
    required this.options,
    required this.selectedOption,
    required this.setOption,
    this.haveError = false,
  });

  @override
  State<CIRadioField> createState() => _CIRadioFieldState();
}

class _CIRadioFieldState extends State<CIRadioField> {
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
    return Container(
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
            height: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.options.keys.map((option) {
              return _buildRadioButton(
                widget.options[option],
                option,
                widget.selectedOption ?? "",
                widget.setOption,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

Widget _buildRadioButton(List<String>? label, String value,
    String? selectedValue, Function setSelectedValue) {
  return GestureDetector(
    onTap: () => setSelectedValue(value),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Radio<String>(
              value: value,
              groupValue: selectedValue,
              onChanged: null,
              activeColor: CIColors.secondaryColor,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return CIColors.secondaryColor;
                  }
                  return CIColors.hintColor;
                },
              ),
              autofocus: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  '${label?[0]} / ',
                  style: TextStyle(
                    color: CIColors.secondaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label![1],
                  style: TextStyle(
                    color: CIColors.accentColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}