import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_date_picker.dart';
import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_phone_field.dart';
import '../../components/input_fields/ci_radio_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../constants/regions_and_districts.dart';
import '../../helpers/force_logout.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;
  String? _selectedRegion;
  String? _selectedDistrict;
  Map<String, dynamic> _profileData = {};

  final _phoneController = TextEditingController();
  final _regionController = TextEditingController();
  final _districtController = TextEditingController();
  final _wardController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _reasonController = TextEditingController();

  DateTime? _birthDate;
  String? _selectedMaritalStatus;

  void _setBirthDate(DateTime picked) => setState(() {
        _birthDate = picked;
      });

  void _selectMaritalStatus(String value) => setState(() {
        _selectedMaritalStatus = value;
      });

  void _selectRegion(String value) => setState(() {
        _selectedDistrict = null;
        _selectedRegion = value;
      });

  void _selectDistrict(String value) => setState(() {
        _selectedDistrict = value;
      });

  bool _isLoading = false;

  String _regionFieldError = "";
  String _districtFieldError = "";
  String _wardFieldError = "";
  String _streetNameFieldError = "";
  String _streetNumberFieldError = "";
  String _addressFieldError = "";
  String _reasonError = "";
  String _phoneFieldError = "";
  String _dateError = "";
  String _maritalError = "";

  String formatTanzanianPhoneNumber(String input) {
    // Remove all non-digit characters
    String digitsOnly = input.replaceAll(RegExp(r'\D'), '');

    String? lastNine;

    if (digitsOnly.startsWith('255') && digitsOnly.length == 12) {
      lastNine = digitsOnly.substring(3); // strip country code
    } else if (digitsOnly.startsWith('0') && digitsOnly.length == 10) {
      lastNine = digitsOnly.substring(1); // strip leading zero
    } else if (digitsOnly.length == 9) {
      lastNine = digitsOnly;
    } else {
      return '-'; // Invalid format
    }

    // Format into groups of 3
    return '${lastNine.substring(0, 3)} ${lastNine.substring(3, 6)} ${lastNine.substring(6, 9)}';
  }

  void fetchProfileData() async {
    try {
      final response =
          await ApiService.get('profile', token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;

            default:
          }
        } else {
          setState(() {
            _profileData = response['profile-data'];
          });

          setState(() {
            _phoneController.text = _profileData['phone'];
            _selectedMaritalStatus = _profileData['marital_status'];

            _wardController.text = _profileData['ward'];
            _streetNameController.text = _profileData['street'];
            _streetNumberController.text = _profileData['street_no'];
            _addressController.text = _profileData['address'];

            String phoneNumber = _profileData['phone'];
            _phoneController.text = formatTanzanianPhoneNumber(phoneNumber);

            try {
              DateFormat dateFormat = DateFormat("d MMMM yyyy");
              _birthDate = dateFormat.parse(_profileData['dob']);
            } catch (e) {
              _birthDate = null;
            }

            if (regionsAndDistrictsList.containsKey(_profileData['region'])) {
              _selectRegion(_profileData['region']);
              if (regionsAndDistrictsList[_profileData['region']]!
                  .contains(_profileData['district'])) {
                _selectDistrict(_profileData['district']);
              }
            }
          });
        }
      }
      setState(() {
        _isPageLoading = false;
      });
    } catch (e) {
      // Request not sent
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An error occured. Please try again',
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
    }
    setState(() {
      _isPageLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Edit Profile",
      ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen()
            : (_profileData.isEmpty
                ? Text('Profile data unavailable')
                : Column(
                    spacing: 20,
                    children: [
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CIColors.whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Profile Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              // Phone Number

                              CIPhoneField(
                                inputController: _phoneController,
                                engLabel: "Mobile No.",
                                swLabel: "Namba ya Simu",
                                placeholder: "e.g. 789 123 456",
                                haveError: (_phoneFieldError != ""),
                              ),
                              if (_phoneFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _phoneFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              // Date of birth
                              CIDatePicker(
                                dateState: _birthDate,
                                setDateState: _setBirthDate,
                                engLabel: "Date of Birth",
                                swLabel: "Tarehe ya Kuzaliwa",
                                placeholder: "Pick your birthdate",
                                isBirthDate: true,
                                haveError: (_dateError != ""),
                              ),
                              if (_dateError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _dateError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 12),

                              // Marital Status
                              CIRadioField(
                                engLabel: "Martial Status",
                                swLabel: "Hali ya Ndoa",
                                options: {
                                  "Single": ["Single", "Sina Ndoa"],
                                  "Married": ["Married", "Nina Ndoa"],
                                  "Divorced": ["Divorced", "Nina Talaka"],
                                  "Widowed": ["Widowed", "Mgane au Mjane"],
                                },
                                setOption: _selectMaritalStatus,
                                selectedOption: _selectedMaritalStatus,
                                haveError: (_maritalError != ""),
                              ),
                              if (_maritalError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _maritalError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              const SizedBox(height: 12),

                              //  Region

                              CISelectField(
                                inputController: _regionController,
                                engLabel: "Region",
                                swLabel: "Mkoa",
                                placeholder: "Select Region",
                                options: regionsAndDistrictsList.keys.toList(),
                                selectOption: _selectRegion,
                                selectedOption: _selectedRegion,
                                haveError: (_regionFieldError != ""),
                              ),
                              if (_regionFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _regionFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              //  District

                              CISelectField(
                                inputController: _districtController,
                                engLabel: "District",
                                swLabel: "Wilaya",
                                placeholder: "Select District",
                                options:
                                    regionsAndDistrictsList[_selectedRegion] ??
                                        [],
                                selectOption: _selectDistrict,
                                selectedOption: _selectedDistrict,
                                haveError: (_districtFieldError != ""),
                              ),
                              if (_districtFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _districtFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              //  Ward

                              CIField(
                                inputController: _wardController,
                                engLabel: "Ward",
                                swLabel: "Kata",
                                placeholder: "Enter ward",
                                haveError: (_wardFieldError != ""),
                              ),
                              if (_wardFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _wardFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              //  Street Name

                              CIField(
                                inputController: _streetNameController,
                                engLabel: "Street Name",
                                swLabel: "Jina la Mtaa",
                                placeholder: "Enter street name",
                                haveError: (_streetNameFieldError != ""),
                              ),
                              if (_streetNameFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _streetNameFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              //  Street Number

                              CIField(
                                inputController: _streetNumberController,
                                engLabel: "Street Number",
                                swLabel: "Nambari ya Mtaa",
                                placeholder: "Enter street number",
                                haveError: (_streetNumberFieldError != ""),
                              ),
                              if (_streetNumberFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _streetNumberFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              //  Postal Address

                              CIField(
                                inputController: _addressController,
                                engLabel: "Postal Address",
                                swLabel: "Sanduku la Posta",
                                placeholder: "Enter postal address",
                                haveError: (_addressFieldError != ""),
                              ),
                              if (_addressFieldError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _addressFieldError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              CILongField(
                                inputController: _reasonController,
                                engLabel: "Reason for Editing Your Information",
                                swLabel: "Sababu ya Kuhariri Taarifa Zako",
                                placeholder: "Explain the reason",
                                haveError: (_reasonError != ""),
                              ),
                              if (_reasonError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _reasonError,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: CIColors.errorText,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 24),
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_isFormValid()) {
                                              _handleUpdateProfile(context);
                                            }
                                          },
                                    style: mainButtonStyle,
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            'Update Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                  )
                                ],
                              ),
                            ],
                          ))
                    ],
                  )),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _regionController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _streetNameController.dispose();
    _streetNumberController.dispose();
    _addressController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String phoneValue = _phoneController.text;
    String wardValue = _wardController.text;
    String streetValue = _streetNameController.text;
    String streetNoValue = _streetNumberController.text;
    String addressValue = _addressController.text;
    String reasonValue = _reasonController.text;

    if (phoneValue.isEmpty) {
      setState(() {
        _phoneFieldError = "Please enter your mobile number";
      });
      isValid = false;
    }

    if (_selectedRegion!.isEmpty) {
      setState(() {
        _regionFieldError = "Please select your region";
      });
      isValid = false;
    }

    if (_selectedDistrict!.isEmpty) {
      setState(() {
        _districtFieldError = "Please select you district";
      });
      isValid = false;
    }

    if (wardValue.isEmpty) {
      setState(() {
        _wardFieldError = "Please enter your ward";
      });
      isValid = false;
    }

    if (streetValue.isEmpty) {
      setState(() {
        _streetNameFieldError = "Please enter your street name";
      });
      isValid = false;
    }

    if (streetNoValue.isEmpty) {
      setState(() {
        _streetNumberFieldError = "Please enter your street number";
      });
      isValid = false;
    }

    if (addressValue.isEmpty) {
      setState(() {
        _addressFieldError = "Please enter your postal address";
      });
      isValid = false;
    }

    if (reasonValue.isEmpty) {
      setState(() {
        _reasonError = "Please enter reason for editing information";
      });
      isValid = false;
    }

    if (_selectedMaritalStatus!.isEmpty) {
      setState(() {
        _maritalError = "Please select your marital status";
      });
      isValid = false;
    }

    if (_birthDate == null) {
      setState(() {
        _dateError = "Please select your birth date";
      });
      isValid = false;
    }

    return isValid;
  }

  void _handleUpdateProfile(context) async {
    _clearErrors();

    setState(() {
      _isLoading = true;
    });

    final updateProfileData = {
      "phone": "+255 ${_phoneController.text}",
      "marital_status": _selectedMaritalStatus,
      "dob": DateFormat('dd MMMM y').format(_birthDate!),
      "region": _selectedRegion,
      "district": _selectedDistrict,
      "ward": _wardController.text,
      "street": _streetNameController.text,
      "street_no": _streetNumberController.text,
      "address": _addressController.text,
      "reason": _reasonController.text,
    };

    try {
      final response = await ApiService.post(
        'profile',
        token: apiProvider.authToken,
        data: updateProfileData,
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "missing-fields":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'All fields must be filled',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'An error occured. Please try again later',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
          }
        } else {
          if (response.containsKey('success')) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Profile details updated successfully',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));

            Future.delayed(Duration(milliseconds: 50), () {
              Navigator.pushReplacementNamed(context, '/profile');
            });
          }
        }
      } else {
        // Request not sent
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'An error occured. Please try again',
            style: TextStyle(
              color: CIColors.errorColor,
            ),
          ),
          backgroundColor: CIColors.errorBox,
        ));
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An error occured. Please try again later',
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearErrors() {
    setState(() {
      _regionFieldError = "";
      _districtFieldError = "";
      _wardFieldError = "";
      _streetNameFieldError = "";
      _streetNumberFieldError = "";
      _addressFieldError = "";
      _reasonError = "";
      _phoneFieldError = "";
      _dateError = "";
      _maritalError = "";
    });
  }
}
