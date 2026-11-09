import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';

class CIDatePicker extends StatefulWidget {
  final DateTime? dateState;
  final Function setDateState;
  final String engLabel;
  final String swLabel;
  final String placeholder;
  final bool isBirthDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool haveError;

  const CIDatePicker({
    super.key,
    required this.dateState,
    required this.setDateState,
    required this.engLabel,
    required this.swLabel,
    required this.placeholder,
    this.isBirthDate = false,
    this.startDate,
    this.endDate,
    this.haveError = false,
  });

  @override
  State<CIDatePicker> createState() => _CIDatePickerState();
}

class _CIDatePickerState extends State<CIDatePicker> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime endDate = DateTime.now();

    if (widget.isBirthDate) {
      endDate = DateTime(endDate.year - 18, endDate.month, endDate.day,
          endDate.hour, endDate.minute, endDate.second);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: widget.placeholder,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      locale: const Locale('en', 'GB'),
      initialDate: widget.dateState ??
          (widget.isBirthDate ? (endDate) : widget.endDate ?? DateTime.now()),
      firstDate: widget.startDate ?? DateTime(1900),
      lastDate: widget.endDate ?? endDate,
    );

    if (picked != null && picked != widget.dateState) {
      widget.setDateState(picked);
    }
  }

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
        _selectDate(context);
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
              height: 4,
            ),
            TextButton(
              focusNode: _focusNode,
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                minimumSize: Size(double.infinity, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => _selectDate(context),
              child: Text(
                widget.dateState == null
                    ? widget.placeholder
                    : DateFormat('dd MMMM y').format(widget.dateState!),
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontStyle: widget.dateState == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                  color: widget.dateState == null
                      ? CIColors.hintColor
                      : CIColors.primaryColor,
                  fontWeight: widget.dateState == null
                      ? FontWeight.w400
                      : FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
