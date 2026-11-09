import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CICheckField extends StatefulWidget {
  final String engLabel;
  final String swLabel;
  final Map<String, List<String>> options;
  final Function setOption;
  final String? selectedOption;

  const CICheckField({
    super.key,
    required this.engLabel,
    required this.swLabel,
    required this.options,
    required this.selectedOption,
    required this.setOption,
  });

  @override
  State<CICheckField> createState() => _CICheckFieldState();
}

class _CICheckFieldState extends State<CICheckField> {
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
        color: _isFocused ? Color(0xffe7f3ff) : Color(0xfff5faff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused ? CIColors.secondaryColor : Color(0xffdcefff),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: 0,
            children: [
              ...sentenceToTextWidgets("${widget.engLabel} /", color: CIColors.secondaryColor),
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
    child: SizedBox(
      height: 25,
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: selectedValue,
            onChanged: (String? newValue) {},
            activeColor: CIColors.secondaryColor,
          ),
          Text(
            '${label?[0]} / ',
            style: const TextStyle(
              color: CIColors.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label![1],
            style: const TextStyle(
              color: CIColors.accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
