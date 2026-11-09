import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CIEmailField extends StatefulWidget {
  final TextEditingController inputController;
  final String engLabel;
  final String swLabel;
  final String placeholder;
  final bool haveError;

  const CIEmailField({
    super.key,
    required this.inputController,
    required this.engLabel,
    required this.swLabel,
    required this.placeholder,
    this.haveError = false,
  });

  @override
  State<CIEmailField> createState() => _CIEmailFieldState();
}

class _CIEmailFieldState extends State<CIEmailField> {
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
            SizedBox(
              child: TextField(
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