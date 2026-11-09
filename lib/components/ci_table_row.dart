import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CITableRow extends StatefulWidget {
  final List<Widget> children;
  final String viewRoute;
  final Map<String, dynamic> viewRouteArgs;
  final double width;
  final List<String> shownButtons;

  const CITableRow({
    super.key,
    required this.viewRoute,
    required this.viewRouteArgs,
    required this.children,
    this.width = 900,
    this.shownButtons = const [],
  });

  @override
  State<CITableRow> createState() => _CITableRowState();
}

class _CITableRowState extends State<CITableRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              _isPressed = true; // Change state on press down
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false; // Change state on release
            });
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false; // Reset state if the tap is canceled
            });
          },
          onTap: () {
            Navigator.pushNamed(
              context,
              widget.viewRoute,
              arguments: widget.viewRouteArgs,
            );
          },
          child: Container(
            width: widget.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: widget.shownButtons.isNotEmpty
                ? EdgeInsets.all(0)
                : EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: _isPressed ? CIColors.inputFocusFillColor : CIColors.whiteColor,
              border: Border.all(
                color: _isPressed ? Color(0x692878D0) : CIColors.whiteColor,
                width: 1,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Row(
              spacing: 10,
              children: widget.children,
            ),
          ),
        ),
        if (widget.shownButtons.isNotEmpty &&
            widget.shownButtons.contains('view_fee_tables'))
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextButton(
                style: TextButton.styleFrom(
                    minimumSize: const Size(60, 20),
                    maximumSize: const Size(300, 25),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    foregroundColor: CIColors.textColor,
                    backgroundColor: const Color.fromARGB(255, 204, 226, 248)),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/fee-tables',
                    arguments: {
                      'loan-id': widget.viewRouteArgs['application-id'],
                    },
                  );
                },
                child: Text(
                  'View Submitted Fee Tables',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ])
      ],
    );
  }
}
