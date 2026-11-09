import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_date_picker.dart';
import '../../components/main_top_bar.dart';
import '../../constants/button_style_main.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/authed_wrapper.dart';

class ChangeBirthdateScreen extends StatefulWidget {
  const ChangeBirthdateScreen({super.key});

  @override
  State<ChangeBirthdateScreen> createState() => _ChangeBirthdateScreenState();
}

class _ChangeBirthdateScreenState extends State<ChangeBirthdateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  DateTime? _newBirthDate;
  String _currentBirthDate = '';
  bool _isLoading = false;
  bool _isFetchingProfile = true;
  String _dateError = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      _fetchCurrentBirthdate();
    });
  }

  Future<void> _fetchCurrentBirthdate() async {
    try {
      final response = await ApiService.get(
        'profile',
        token: apiProvider.authToken,
      );
      if (response != null && response['profile-data'] != null) {
        final dob = response['profile-data']['dob'];
        if (dob != null && dob.toString().isNotEmpty) {
          setState(() {
            _currentBirthDate = dob.toString();
          });
        }
      }
    } catch (e) {
      // fail silently
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: 'Change Birthdate',
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Select your new birth date below to update it',
              ),
            ),
            const SizedBox(height: 8),

            // Current birthdate display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: CIColors.inputFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CIColors.inputBorderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        'Your Current Birth Date / ',
                        style: TextStyle(
                          color: CIColors.secondaryColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Tarehe ya Sasa ya Kuzaliwa',
                        style: TextStyle(
                          color: CIColors.textColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _isFetchingProfile
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: CIColors.primaryColor,
                          ),
                        )
                      : Text(
                          _currentBirthDate.isNotEmpty
                              ? _currentBirthDate
                              : '—',
                          style: TextStyle(
                            color: CIColors.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // New birthdate picker
            CIDatePicker(
              dateState: _newBirthDate,
              setDateState: (DateTime picked) {
                setState(() {
                  _newBirthDate = picked;
                  _dateError = '';
                });
              },
              engLabel: 'Your New Birth Date',
              swLabel: 'Tarehe ya Mpya ya Kuzaliwa',
              placeholder: 'Pick your new birthdate',
              isBirthDate: true,
              haveError: _dateError.isNotEmpty,
            ),

            if (_dateError.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _dateError,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: CIColors.errorText,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_isFormValid()) {
                            _handleChangeBirthdate(context);
                          }
                        },
                  style: mainButtonStyle,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Update Your Birth Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    setState(() {
      _dateError = '';
    });
    if (_newBirthDate == null) {
      setState(() {
        _dateError = 'Please select your new birth date';
      });
      return false;
    }
    return true;
  }

  void _handleChangeBirthdate(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final apiProvider = Provider.of<APIProvider>(context, listen: false);

    final data = {
      'dob': DateFormat('dd MMMM y').format(_newBirthDate!),
    };

    try {
      final response = await ApiService.post(
        'change-birthdate',
        token: apiProvider.authToken,
        data: data,
      );

      if (!mounted) return;

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case 'unauthorized':
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case 'dob-not-provided':
              setState(() {
                _dateError = 'Please select a birth date';
              });
              break;
            case 'invalid-dob':
              setState(() {
                _dateError = 'The selected birth date is invalid';
              });
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'An error occurred. Please try again later',
                    style: TextStyle(color: CIColors.errorColor),
                  ),
                  backgroundColor: CIColors.errorBox,
                ),
              );
          }
        } else if (response.containsKey('success')) {
          setState(() {
            _currentBirthDate = DateFormat('dd MMMM y').format(_newBirthDate!);
            _newBirthDate = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Your birth date has been updated successfully',
                style: TextStyle(color: CIColors.successColor),
              ),
              backgroundColor: CIColors.successBox,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please try again',
              style: TextStyle(color: CIColors.errorColor),
            ),
            backgroundColor: CIColors.errorBox,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please try again later',
              style: TextStyle(color: CIColors.errorColor),
            ),
            backgroundColor: CIColors.errorBox,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}