import 'package:card_informatics_mobile_app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/auth_provider.dart';
import '../providers/overlay_controller.dart';
import '../services/inactivity_timer.dart';
import '../services/navigator_service.dart';

class EnterPasscodeScreen extends StatefulWidget {
  const EnterPasscodeScreen({super.key});

  @override
  EnterPasscodeScreenState createState() => EnterPasscodeScreenState();
}

class EnterPasscodeScreenState extends State<EnterPasscodeScreen>
    with TickerProviderStateMixin {
  late AuthProvider authProvider;

  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(_controller);
  }

  void checkFailedTimes() async {
    final storage = StorageService();
    String failedTimes = await storage.get("failed_times") ?? '0';

    if (int.parse(failedTimes) >= 5) {
      if (mounted) forceLogout(context, mounted, userLoggedOut: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// Call this to trigger shake
  void _triggerShake() {
    _controller.forward(from: 0.0);
  }

  bool _setSuccess = false;
  String _enteredPasscode = "";
  String _passCodeError = "";

  void _enterPINValue(String value, BuildContext context) {
    setState(() {
      _passCodeError = "";
    });
    if (_enteredPasscode.length < 4) {
      setState(() {
        _enteredPasscode = _enteredPasscode + value;
      });
      if (_enteredPasscode.length == 4) _goNext(context);
      return;
    }
  }

  void _deleteLastPINValue() {
    if (_enteredPasscode.isNotEmpty) {
      setState(() {
        _passCodeError = "";
        _enteredPasscode =
            _enteredPasscode.substring(0, _enteredPasscode.length - 1);
      });
      return;
    }
  }

  void _goNext(context) async {
    if (_enteredPasscode.length == 4) {
      // check validity
      final storage = StorageService();
      String storedPasscode = await storage.get("app_pass_code") ?? '';

      if (storedPasscode != _enteredPasscode) {
        String failedTimes = await storage.get("failed_times") ?? '0';

        // if failed 5 times
        if ((int.parse(failedTimes) + 1) >= 5) {
          if (mounted) forceLogout(context, mounted, userLoggedOut: true);
          return;
        }

        await storage.set(
            "failed_times", (int.parse(failedTimes) + 1).toString());


        Future.delayed(Duration(milliseconds: 200), () {
          setState(() {
            _passCodeError =
                "Incorrect PIN, Try again.\n${((int.parse(failedTimes) + 1) >= 3) ? '(${(5 - (int.parse(failedTimes) + 1)).toString()} tr${5 - (int.parse(failedTimes) + 1) > 1 ? 'ies' : 'y'} remaining)' : ''}";
            _enteredPasscode = "";
          });
          HapticFeedback.vibrate();
          _triggerShake();
        });
      } else {
        await storage.set("failed_times", '0');
        final controllerProvider =
            Provider.of<OverlayProvider>(context, listen: false);
        // if was locked after inactivity time out
        if (controllerProvider.isTimeoutLocked) {
          controllerProvider.isTimeoutLocked = false;
          controllerProvider.hideAppLockOverlay();
          InactivityTimer().reset();
          return;
        }

        // If there is a pending route go to it
        if (authProvider.pendingRoute != "") {
          String pendingRoute = authProvider.pendingRoute;
          Map<String, dynamic> pendingRouteParams =
              authProvider.pendingRouteParams;

          authProvider.pendingRoute = "";
          authProvider.pendingRouteParams = {};

          navigatorKey.currentState?.pushReplacementNamed(pendingRoute,
              arguments: pendingRouteParams);
          controllerProvider.hideAppLockOverlay();
          return;
        }

        // If app lock activated by background app state (Screen Lock, User switched apps)

        if (controllerProvider.screenPaused) {
          controllerProvider.screenPaused = false;
          InactivityTimer().start();
          controllerProvider.hideAppLockOverlay();
          return;
        }

        // otherwise go to dashboard
        navigatorKey.currentState?.pushReplacementNamed('/dashboard');
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey("set-success")) {
      setState(() {
        _setSuccess = true;
      });
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                color: CIColors.canvasBGColor,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_setSuccess)
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: CIColors.successBox,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          36, 86, 180, 153),
                                    ),
                                  ),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        color: CIColors.successText,
                                        size: 14,
                                      ),
                                      Text(
                                        "PIN set successfully. Use it below.",
                                        style: TextStyle(
                                          color: CIColors.successText,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        Text(
                          "Enter your PIN",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 92,
                          child: Column(
                            children: [
                              Text(
                                "To proceed, enter the 4-digit PIN \nyou previously set for this app.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              if (_passCodeError.isNotEmpty)
                                SizedBox(
                                  height: 6,
                                ),
                              if (_passCodeError.isNotEmpty)
                                Text(
                                  _passCodeError,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CIColors.errorText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _offsetAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_offsetAnimation.value, 0),
                              child: Row(
                                spacing: 20,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _enteredPasscode.isNotEmpty
                                          ? CIColors.primaryColor
                                          : const Color(0xFFB4C5D8),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: _enteredPasscode.length > 1
                                            ? CIColors.primaryColor
                                            : const Color(0xFFB4C5D8),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: _enteredPasscode.length > 2
                                            ? CIColors.primaryColor
                                            : const Color(0xFFB4C5D8),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: _enteredPasscode.length > 3
                                            ? CIColors.primaryColor
                                            : const Color(0xFFB4C5D8),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PINButton(
                                number: "1",
                                setValue: () {
                                  _enterPINValue("1", context);
                                },
                              ),
                              PINButton(
                                number: "2",
                                setValue: () {
                                  _enterPINValue("2", context);
                                },
                              ),
                              PINButton(
                                number: "3",
                                setValue: () {
                                  _enterPINValue("3", context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PINButton(
                                number: "4",
                                setValue: () {
                                  _enterPINValue("4", context);
                                },
                              ),
                              PINButton(
                                number: "5",
                                setValue: () {
                                  _enterPINValue("5", context);
                                },
                              ),
                              PINButton(
                                number: "6",
                                setValue: () {
                                  _enterPINValue("6", context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PINButton(
                                number: "7",
                                setValue: () {
                                  _enterPINValue("7", context);
                                },
                              ),
                              PINButton(
                                number: "8",
                                setValue: () {
                                  _enterPINValue("8", context);
                                },
                              ),
                              PINButton(
                                number: "9",
                                setValue: () {
                                  _enterPINValue("9", context);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Row(
                            spacing: 20,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  forceLogout(context, mounted,
                                      userLoggedOut: true);
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons
                                              .arrowRightFromBracket,
                                          color: CIColors.errorText,
                                          size: 15,
                                        ),
                                        Text(
                                          "Log out",
                                          style: TextStyle(
                                            color: CIColors.errorText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              PINButton(
                                number: "0",
                                setValue: () {
                                  _enterPINValue("0", context);
                                },
                              ),
                              if (_enteredPasscode.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _deleteLastPINValue();
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: CIColors.transparentColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.deleteLeft,
                                      color: CIColors.accentColor,
                                    ),
                                  ),
                                ),
                              if (_enteredPasscode.isEmpty)
                                SizedBox(
                                  height: 70,
                                  width: 70,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PINButton extends StatelessWidget {
  final String number;
  final Function setValue;

  const PINButton({
    super.key,
    required this.number,
    required this.setValue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setValue();
      },
      child: Container(
        height: 70,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CIColors.whiteColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color.fromARGB(23, 5, 79, 139),
          ),
        ),
        child: Text(
          number,
          style: TextStyle(
            color: CIColors.primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
