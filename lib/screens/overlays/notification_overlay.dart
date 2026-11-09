import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../handlers/notification_content.dart';
import '../../handlers/open_notification_handler.dart';
import '../../providers/notification_provider.dart';
import '../../providers/overlay_controller.dart';
import '../../services/navigator_service.dart';

class NotificationOverlay extends StatelessWidget {
  const NotificationOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final overlayController = Provider.of<OverlayProvider>(context);
    final notifProvider = Provider.of<NotificationProvider>(context);

    return ValueListenableBuilder<bool>(
      valueListenable: overlayController.isShownNotificationOverlay,
      builder: (context, isVisible, _) {
        if (!isVisible) return SizedBox.shrink();

        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CIColors.canvasBGColor,
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          overlayController.hideNotificationOverlay();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: CIColors.primaryColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height *
                            0.5, // 50% of screen height
                        maxHeight: MediaQuery.of(context).size.height *
                            0.8, // 90% of screen height
                      ),
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            // If there are no notifications
                            if (notifProvider.notifications.isEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: CIColors.whiteColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "You currently have no notifications!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.accentColor,
                                  ),
                                ),
                              ),

                            // If there are notifications
                            if (notifProvider.notifications.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 10,
                                children: [
                                  ...notifProvider.notifications.map((notif) {
                                    final notifContent = getNotifContent(notif);
                                    return GestureDetector(
                                      onTap: () {
                                        notifProvider.removeNotification(
                                            notif["notifID"]);
                                        openNotificationHandler(context, notif,
                                            navigatorKey: navigatorKey);
                                        overlayController
                                            .hideNotificationOverlay();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 12,
                                          top: 16,
                                          bottom: 16,
                                          right: 16,
                                        ),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: CIColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 30,
                                              height: 40,
                                              child: Center(
                                                child: FaIcon(
                                                  notifContent['icon'],
                                                  size: 20,
                                                  color: CIColors.accentColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    notifContent['title'],
                                                    style: TextStyle(
                                                      color: CIColors.textColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    notifContent['message'],
                                                    style: TextStyle(
                                                      color: CIColors.textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
