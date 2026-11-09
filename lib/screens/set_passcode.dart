import 'package:test_mobile/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';

class SetPasscodeScreen extends StatefulWidget {
  const SetPasscodeScreen({super.key});

  @override
  SetPasscodeScreenState createState() => SetPasscodeScreenState();
}

class SetPasscodeScreenState extends State<SetPasscodeScreen>
    with TickerProviderStateMixin {
  late AuthProvider authProvider;

  late AnimationController _controller;
  late Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// Call this to trigger shake
  void _triggerShake() {
    _controller.forward(from: 0.0);
  }

  String _step = "entering";

  String _enteredPasscode = "";
  String _confirmPasscode = "";
  String _passCodeError = "";

  void _enterPINValue(String value, BuildContext context) {
    setState(() {
      _passCodeError = "";
    });
    if (_step == "entering" && _enteredPasscode.length < 4) {
      setState(() {
        _enteredPasscode = _enteredPasscode + value;
      });
      if (_enteredPasscode.length == 4) _goNext(context);
      return;
    }
    if (_step == "confirming" && _confirmPasscode.length < 4) {
      setState(() {
        _confirmPasscode = _confirmPasscode + value;
      });
      if (_confirmPasscode.length == 4) _goNext(context);
      return;
    }
  }

  void _deleteLastPINValue() {
    if (_step == "entering" && _enteredPasscode.isNotEmpty) {
      setState(() {
        _passCodeError = "";
        _enteredPasscode =
            _enteredPasscode.substring(0, _enteredPasscode.length - 1);
      });
      return;
    }
    if (_step == "confirming" && _confirmPasscode.isNotEmpty) {
      setState(() {
        _passCodeError = "";
        _confirmPasscode =
            _confirmPasscode.substring(0, _confirmPasscode.length - 1);
      });
      return;
    }
  }

  void _reenterCode() {
    setState(() {
      _passCodeError = "";
      _enteredPasscode = "";
      _confirmPasscode = "";
      _step = "entering";
    });
  }

  void _goNext(context) async {
    if (_step == "entering" && _enteredPasscode.length == 4) {
      setState(() {
        _step = "confirming";
      });
      return;
    }

    if (_step == "confirming" && _confirmPasscode != _enteredPasscode) {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          _passCodeError = "PINs do not match, Try again.";
          _confirmPasscode = "";
        });
        HapticFeedback.vibrate();
        _triggerShake();
        return;
      });
    }

    if (_step == "confirming" &&
        _enteredPasscode.length == 4 &&
        _enteredPasscode == _confirmPasscode) {
      final storage = StorageService();

      await storage.set("app_pass_code", _enteredPasscode);
      await storage.set("failed_times", '0');
      Navigator.pushReplacementNamed(
        context,
        '/enter-pass-code',
        arguments: {
          "set-success": true,
        },
      );

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
                        SizedBox(height: 40),
                        if (_step == "entering")
                          Text(
                            "Create new PIN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (_step == "confirming")
                          Text(
                            "Confirm PIN",
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
                                "You will use this PIN to access \nthe app in the future.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
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
                                      color: (_step == "entering" &&
                                                  _enteredPasscode.isNotEmpty ||
                                              _step == "confirming" &&
                                                  _confirmPasscode.isNotEmpty)
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: (_step == "entering" &&
                                                    _enteredPasscode.length >
                                                        1 ||
                                                _step == "confirming" &&
                                                    _confirmPasscode.length > 1)
                                            ? CIColors.primaryColor
                                            : CIColors.accentColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: (_step == "entering" &&
                                                    _enteredPasscode.length >
                                                        2 ||
                                                _step == "confirming" &&
                                                    _confirmPasscode.length > 2)
                                            ? CIColors.primaryColor
                                            : CIColors.accentColor,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                        color: (_step == "entering" &&
                                                    _enteredPasscode.length >
                                                        3 ||
                                                _step == "confirming" &&
                                                    _confirmPasscode.length > 3)
                                            ? CIColors.primaryColor
                                            : CIColors.accentColor,
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
                          height: 24,
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
                              if (_step == "entering")
                                Container(
                                  height: 70,
                                  width: 70,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: CIColors.transparentColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              if (_step == "confirming")
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    _reenterCode();
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
                                            FontAwesomeIcons.rotateLeft,
                                            color: CIColors.secondaryColor,
                                            size: 15,
                                          ),
                                          Text(
                                            "Re-enter",
                                            style: TextStyle(
                                              color: CIColors.secondaryColor,
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
                              if ((_step == "entering" &&
                                      _enteredPasscode.isNotEmpty) ||
                                  (_step == "confirming" &&
                                      _confirmPasscode.isNotEmpty))
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
                              if ((_step == "entering" &&
                                      _enteredPasscode.isEmpty) ||
                                  (_step == "confirming" &&
                                      _confirmPasscode.isEmpty))
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
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
