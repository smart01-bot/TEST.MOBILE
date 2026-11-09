import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/overlay_controller.dart';

class DrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final bool isRed;
  final Function() onPressed;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isActive = false,
    this.isRed = false,
  });

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    final overlayControllerProvider = Provider.of<OverlayProvider>(context);

    return GestureDetector(
      onTap: () {
        widget.onPressed();
        overlayControllerProvider.hideDrawerOverlay();
      },
      onTapDown: (_) {
        setState(() {
          isTapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isTapped = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
            color: widget.isActive
                ? const Color.fromARGB(85, 174, 201, 230)
                : isTapped
                    ? const Color.fromARGB(35, 174, 201, 230)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: Center(
                child: FaIcon(
                  widget.icon,
                  size: 16,
                  color: widget.isRed ? CIColors.errorText : CIColors.textColor,
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                color: widget.isRed ? CIColors.errorText : CIColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
