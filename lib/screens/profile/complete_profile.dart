import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
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

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
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

  void fetchProfileData(context) async {
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

          setState(() {});
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
      fetchProfileData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Complete Registration",
        showActions: false,
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
                                            'Save Info',style: TextStyle(
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

    String wardValue = _wardController.text;
    String streetValue = _streetNameController.text;
    String streetNoValue = _streetNumberController.text;
    String addressValue = _addressController.text;

    if (_selectedRegion == null || _selectedRegion!.isEmpty) {
      setState(() {
        _regionFieldError = "Please select your region";
      });
      isValid = false;
    }

    if (_selectedDistrict == null || _selectedDistrict!.isEmpty) {
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

    return isValid;
  }

  void _handleUpdateProfile(context) async {
    _clearErrors();

    setState(() {
      _isLoading = true;
    });

    final updateProfileData = {
      "region": _selectedRegion,
      "district": _selectedDistrict,
      "ward": _wardController.text,
      "street": _streetNameController.text,
      "street_no": _streetNumberController.text,
      "address": _addressController.text,
    };

    try {
      final response = await ApiService.post(
        'complete-profile',
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
                'Registration completed successfully',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));

            Future.delayed(Duration(milliseconds: 50), () {
              Navigator.pushReplacementNamed(context, '/dashboard');
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
    });
  }
}
