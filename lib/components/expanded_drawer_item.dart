import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/overlay_controller.dart';

class ExpandableDrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<List> items;
  final bool isActive;

  const ExpandableDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    this.isActive = false,
  });

  @override
  State<ExpandableDrawerItem> createState() => _ExpandableDrawerItemState();
}

class _ExpandableDrawerItemState extends State<ExpandableDrawerItem> {
  bool isExpanded = false;
  bool isForceClosed = false;

  @override
  Widget build(BuildContext context) {
    final overlayControllerProvider = Provider.of<OverlayProvider>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          if (!isExpanded) isForceClosed = true;
        });
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: widget.isActive || isExpanded
                ? const Color.fromARGB(85, 174, 201, 230)
                : CIColors.transparentColor,
            borderRadius: BorderRadius.circular(24)),
        child: Column(
          children: [
            // Title
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 4,
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: Center(
                      child: FaIcon(
                        widget.icon,
                        size: 16,
                        color: CIColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: CIColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  FaIcon(
                    isExpanded
                        ? FontAwesomeIcons.caretUp
                        : FontAwesomeIcons.caretDown,
                    size: 12,
                    color: const Color.fromARGB(255, 101, 129, 159),
                  ),
                ],
              ),
            ),
            // Items
            if (isExpanded || (widget.isActive && !isForceClosed))
              Column(
                children: [
                  ...widget.items.map(
                    (item) => DrawerSubItem(
                        onPressed: () {
                          isForceClosed = false;
                          item[2]();
                          overlayControllerProvider.hideDrawerOverlay();
                        },
                        title: item[0],
                        isActive: item.length >= 4
                            ? overlayControllerProvider.currentRoute ==
                                    item[1] &&
                                overlayControllerProvider.currentRouteFilter ==
                                    item[3]
                            : overlayControllerProvider.currentRoute ==
                                item[1]),
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 8,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerSubItem extends StatefulWidget {
  final String title;
  final bool isActive;

  final Function() onPressed;

  const DrawerSubItem({
    super.key,
    required this.title,
    required this.isActive,
    required this.onPressed,
  });

  @override
  State<DrawerSubItem> createState() => _DrawerSubItemState();
}

class _DrawerSubItemState extends State<DrawerSubItem> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
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
        color: widget.isActive
            ? const Color.fromARGB(67, 130, 153, 178)
            : isTapped
                ? const Color.fromARGB(32, 130, 153, 178)
                : CIColors.transparentColor,
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: widget.isActive
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: FaIcon(
                        FontAwesomeIcons.solidCircle,
                        size: 6,
                        color: CIColors.textColor,
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                color: CIColors.textColor,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
