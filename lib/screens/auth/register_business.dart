import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../constants/regions_and_districts.dart';
import '../../components/input_fields/ci_email_field.dart';
import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_file.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../components/input_fields/ci_phone_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../constants/colors.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/non_authed_wrapper.dart';

class RegisterBusinessScreen extends StatefulWidget {
  const RegisterBusinessScreen({super.key});

  @override
  RegisterBusinessScreenState createState() => RegisterBusinessScreenState();
}

class RegisterBusinessScreenState extends State<RegisterBusinessScreen> {
  int _currPage = 1;

  final _entityC = TextEditingController();
  final _licenseC = TextEditingController();
  final _licenseNoC = TextEditingController();
  final _bizTypeC = TextEditingController();
  final _tinC = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessRegionController = TextEditingController();
  final _businessDistrictController = TextEditingController();
  final _businessWardController = TextEditingController();
  final _businessStreetNameController = TextEditingController();
  final _businessStreetNumberController = TextEditingController();
  final _businessBuildingController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _cPassC = TextEditingController();

  bool _termsChecked = false;
  bool _privacyChecked = false;

  String? _selectedRegion;
  String? _selectedDistrict;
  Map<String, String>? _encodedLicense;

  final List<String> _districtsToShow = [];

  bool _isLoading = false;

  String _formError = "";
  String _entityFieldError = "";
  String _businessNameFieldError = "";
  String _emailFieldError = "";
  String _bizTypeError = "";
  String _licenseFieldError = "";
  String _regionFieldError = "";
  final String _districtFieldError = "";
  final String _wardFieldError = "";
  final String _streetNameFieldError = "";
  final String _streetNumberFieldError = "";
  final String _buildingFieldError = "";
  final String _phoneFieldError = "";
  String _licenseFileError = "";
  String _licenseNoError = "";
  String _tinFieldError = "";
  String _passFieldError = "";
  String _cPassFieldError = "";
  String _termsFieldError = "";

  String? _licenseDocFileName;
  void _setLicenseDocFilename(String value) => setState(() {
        _licenseDocFileName = value;
      });

  void _selectLicenceEncoded(Map<String, String> value) => setState(() {
        _encodedLicense = value;
      });

  void _selectLicenseFileError(String value) => setState(() {
        _licenseFileError = value;
      });

  void _selectRegion(String value) => setState(() {
        _selectedDistrict = null;
        _selectedRegion = value;
      });

  void _selectDistrict(String value) => setState(() {
        _selectedDistrict = value;
      });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NonAuthedWrapper(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: CIColors.canvasBGColor,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      // Logo
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset(
                            'assets/card_logo.png', // Add your logo asset
                            fit: BoxFit.contain,
                            width: 180,
                            height: 90,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Form error
                      if (_formError != "")
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFFCE0E0),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _formError,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CIColors.errorColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      if (_formError != "") const SizedBox(height: 12),

                      // Form COntainer
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0x66afcbe8), // Border color
                            width: 1.0,
                            // Border width
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  textBaseline: TextBaseline.alphabetic,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Asset Financing',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CIColors.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Business Name
                            if (_currPage == 1)
                              CIField(
                                inputController: _businessNameController,
                                engLabel: "Legal Name of your Business",
                                swLabel: "Jina la Kisheria la Biashara Yako",
                                placeholder: "Enter name on business license",
                                haveError: (_businessNameFieldError != ""),
                              ),
                            if (_currPage == 1 && _businessNameFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _businessNameFieldError,
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
                            if (_currPage == 1) const SizedBox(height: 12),

                            // TIN Number Field
                            if (_currPage == 1)
                              CIField(
                                inputController: _tinC,
                                engLabel: "Business TIN Number",
                                swLabel: "Nambari ya TIN ya Biashara",
                                placeholder: "Enter business TIN number",
                                haveError: (_tinFieldError != ""),
                                onlyDigits: true,
                              ),
                            if (_currPage == 1 && _tinFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tinFieldError,
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
                            if (_currPage == 1) const SizedBox(height: 12),

                            // License NO. Field
                            if (_currPage == 1)
                              CIField(
                                inputController: _licenseNoC,
                                engLabel: "Business License No.",
                                swLabel: "Leseni Namba ya Biashara",
                                placeholder: "Enter Business License No.",
                                haveError: (_licenseNoError != ""),
                                onlyDigits: true,
                              ),
                            if (_currPage == 1 && _licenseNoError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _licenseNoError,
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
                            if (_currPage == 1) const SizedBox(height: 12),

                            // Type of Business
                            if (_currPage == 1)
                              CILongField(
                                inputController: _bizTypeC,
                                engLabel: "Type of Business ",
                                swLabel: "Aina ya Biashara",
                                placeholder:
                                    "Explain the nature of your business",
                                haveError: (_bizTypeError != ""),
                              ),
                            if (_currPage == 1 && _bizTypeError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _bizTypeError,
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
                            if (_currPage == 1) const SizedBox(height: 12),

                            // License File
                            if (_currPage == 1)
                              CIFile(
                                  engLabel: "Business License Copy",
                                  swLabel: "Nakala ya Leseni ya Biashara",
                                  setFileEncoded: _selectLicenceEncoded,
                                  fileName: _licenseDocFileName,
                                  setFileName: _setLicenseDocFilename,
                                  haveError: (_licenseFileError != ""),
                                  setError: _selectLicenseFileError),
                            if (_currPage == 1 && _licenseFileError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _licenseFileError,
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
                            if (_currPage == 1) const SizedBox(height: 12),

                            // PAGE TWO   =====================================

                            // Business Region
                            if (_currPage == 2)
                              CISelectField(
                                inputController: _businessRegionController,
                                engLabel: "Business Location (Region)",
                                swLabel: "Mkoa Biashara Ilipo",
                                placeholder: "Select Region",
                                options: regionsAndDistrictsList.keys.toList(),
                                selectOption: _selectRegion,
                                selectedOption: _selectedRegion,
                                haveError: (_regionFieldError != ""),
                              ),
                            if (_currPage == 2 && _regionFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // Business District
                            if (_currPage == 2)
                              CISelectField(
                                inputController: _businessDistrictController,
                                engLabel: "Business Location (District)",
                                swLabel: "Wilaya Biashara Ilipo",
                                placeholder: "Select District",
                                options:
                                    regionsAndDistrictsList[_selectedRegion] ??
                                        [],
                                selectOption: _selectDistrict,
                                selectedOption: _selectedDistrict,
                                haveError: (_districtFieldError != ""),
                              ),
                            if (_currPage == 2 && _districtFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // Business Ward
                            if (_currPage == 2)
                              CIField(
                                inputController: _businessWardController,
                                engLabel: "Business Location (Ward)",
                                swLabel: "Kata Biashara Ilipo",
                                placeholder: "Enter business ward",
                                haveError: (_wardFieldError != ""),
                              ),
                            if (_currPage == 2 && _wardFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // Business Street Name
                            if (_currPage == 2)
                              CIField(
                                inputController: _businessStreetNameController,
                                engLabel: "Business Location (Street Name)",
                                swLabel: "Jina la Mtaa Biashara Ilipo",
                                placeholder: "Enter business street name",
                                haveError: (_streetNameFieldError != ""),
                              ),
                            if (_currPage == 2 && _streetNameFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // Business Street Number
                            if (_currPage == 2)
                              CIField(
                                inputController:
                                    _businessStreetNumberController,
                                engLabel: "Business Location (Street Number)",
                                swLabel: "Nambari ya Jengo Biashara Ilipo",
                                placeholder: "Enter business street number",
                                haveError: (_streetNumberFieldError != ""),
                              ),
                            if (_currPage == 2 && _streetNumberFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // Business Building Name
                            if (_currPage == 2)
                              CIField(
                                inputController: _businessBuildingController,
                                engLabel: "Building Name",
                                swLabel: "Jina la Jengo",
                                placeholder: "Enter building name",
                                haveError: (_buildingFieldError != ""),
                              ),
                            if (_currPage == 2 && _buildingFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _buildingFieldError,
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
                            if (_currPage == 2) const SizedBox(height: 12),

                            // PAGE THREE =====================================
                            // Phone Number
                            if (_currPage == 3)
                              CIPhoneField(
                                inputController: _businessPhoneController,
                                engLabel: "Business Mobile No.",
                                swLabel: "Namba ya Simu ya Biashara",
                                placeholder: "e.g. 789 123 456",
                                haveError: (_phoneFieldError != ""),
                              ),
                            if (_currPage == 3 && _phoneFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            // Email Address
                            if (_currPage == 3)
                              CIEmailField(
                                inputController: _emailC,
                                engLabel: "Business Email Address",
                                swLabel: "Barua Pepe ya biashara",
                                placeholder: "Enter email address",
                                haveError: (_emailFieldError != ""),
                              ),
                            if (_currPage == 3 && _emailFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _emailFieldError,
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            // Business License Type Field
                            // if (_currPage == 1)
                            //   CISelectField(
                            //     inputController: _licenseC,
                            //     engLabel: "Business License Type",
                            //     swLabel: "Aina ya Leseni Biashara",
                            //     placeholder: "Select License Type",
                            //     options: [
                            //       "Certificate of Registration",
                            //       "Permanent Licenses",
                            //       "Temporary Licenses",
                            //     ],
                            //     selectedOption: _selectedLicense,
                            //     selectOption: _selectLicense,
                            //     haveError: (_licenseFieldError != ""),
                            //   ),
                            // if (_currPage == 1 && _licenseFieldError != "")
                            //   Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.symmetric(horizontal: 16),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           _licenseFieldError,
                            //           textAlign: TextAlign.start,
                            //           style: TextStyle(
                            //             color: CIColors.errorText,
                            //             fontSize: 14,
                            //             fontStyle: FontStyle.italic,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),

                            // if (_currPage == 1) const SizedBox(height: 12),

                            // password
                            if (_currPage == 3)
                              CIPassField(
                                inputController: _passC,
                                engLabel: "Password",
                                swLabel: "Neno Siri",
                                placeholder: "Enter password",
                                haveError: (_passFieldError != ""),
                              ),
                            if (_currPage == 3 && _passFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _passFieldError,
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            // confirm password
                            if (_currPage == 3)
                              CIPassField(
                                inputController: _cPassC,
                                engLabel: "Confirm Password",
                                swLabel: "Thibitisha Neno Siri",
                                placeholder: "Confirm password",
                                haveError: (_cPassFieldError != ""),
                              ),
                            if (_currPage == 3 && _cPassFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _cPassFieldError,
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            if (_currPage == 3)
                              Wrap(
                                runSpacing: 0,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Checkbox(
                                    value: _termsChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _termsChecked = !_termsChecked;
                                      });
                                    },
                                    activeColor: CIColors.secondaryColor,
                                  ),
                                  Text(
                                    "I have read and accept the ",
                                    style: const TextStyle(
                                      color: CIColors.accentColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchUrl(
                                        Uri.parse(
                                            '${AppConfig.serverUrl}/terms/terms_condition.php'),
                                      );
                                    },
                                    child: Text(
                                      'Terms and Conditions',
                                      style: const TextStyle(
                                        color: CIColors.secondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            if (_currPage == 3) const SizedBox(height: 4),

                            if (_currPage == 3)
                              Wrap(
                                runSpacing: 0,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _privacyChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _privacyChecked = !_privacyChecked;
                                      });
                                    },
                                    activeColor: CIColors.secondaryColor,
                                  ),
                                  Text(
                                    "I have read and understand the ",
                                    style: const TextStyle(
                                      color: CIColors.accentColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchUrl(
                                        Uri.parse(
                                            '${AppConfig.serverUrl}/terms/Privacy_Statement_fin.php'),
                                      );
                                    },
                                    child: Text(
                                      'Privacy Policy',
                                      style: const TextStyle(
                                        color: CIColors.secondaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                            if (_currPage == 3 && _termsFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _termsFieldError,
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

                            if (_currPage == 3) const SizedBox(height: 8),

                            //========================================================================
                            //============================ SUBMIT BUTTONS ============================
                            //========================================================================
                            const SizedBox(height: 4),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_currPage == 1) Spacer(),
                                  if (_currPage > 1)
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _currPage = 1;
                                        });
                                      },
                                      style: mainButtonStyle,
                                      child: Text(
                                        'Back',
                                        style: TextStyle(
                                          color: Colors.white,
                                         fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  if (_currPage < 3)
                                    ElevatedButton(
                                      onPressed: () {
                                        // if (_isFormValid()) {
                                        setState(() {
                                          if (_isFormValid() && _currPage < 3) {
                                            _currPage = _currPage + 1;
                                          }
                                        });
                                        // }
                                      },
                                      style: mainButtonStyle,
                                      child: Text(
                                        'Next',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  if (_currPage == 3)
                                    ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : () {
                                              if (_isFormValid()) {
                                                _handleRegister(context);
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
                                              'Register',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                    ),
                                ]),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // TextButton.icon(
                                //   style: TextButton.styleFrom(
                                //     padding: EdgeInsets.zero,
                                //     minimumSize: Size.zero,
                                //     tapTargetSize:
                                //         MaterialTapTargetSize.shrinkWrap,
                                //   ),
                                //   onPressed: () {
                                //     Navigator.pushReplacementNamed(
                                //         context, '/account-chooser');
                                //   },
                                //   icon: const Icon(
                                //     Icons.arrow_back,
                                //     color: CIColors.secondaryColor,
                                //   ),
                                //   label: Text(
                                //     'Account Type',
                                //     style: TextStyle(
                                //       color: CIColors.secondaryColor,
                                //       fontSize: 11,
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(width: 24),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/login-business');
                                  },
                                  child: Text(
                                    'Login instead',
                                    style: TextStyle(
                                      color: CIColors.secondaryColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            '©${DateTime.now().year} C.A.R.D. Informatics Ltd.\nAll Rights Reserved',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CIColors.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _licenseNoC.dispose();
    _tinC.dispose();
    _businessNameController.dispose();
    _emailC.dispose();
    _passC.dispose();
    _cPassC.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    _clearErrors();
    bool isValid = true;

    String bizName = _businessNameController.text;
    String bizRegion = _businessRegionController.text;
    String bizDistrict = _businessDistrictController.text;
    String bizWard = _businessWardController.text;
    String bizStreetName = _businessStreetNameController.text;
    String bizStreetNumber = _businessStreetNumberController.text;
    String bizBuilding = _businessBuildingController.text;
    String licenseNoValue = _licenseNoC.text;
    String bizTypeValue = _bizTypeC.text;
    String tinValue = _tinC.text;
    String phoneValue = _businessPhoneController.text;
    String emailValue = _emailC.text;
    String passwordValue = _passC.text;
    String passwordCValue = _cPassC.text;

    if (_currPage == 1) {
      if (bizName.isEmpty) {
        setState(() {
          _businessNameFieldError = "Please fill in business name";
        });
        isValid = false;
      }

      if (tinValue.isEmpty) {
        setState(() {
          _tinFieldError = "Please fill in business TIN number";
        });
        isValid = false;
      }

      if (licenseNoValue.isEmpty) {
        setState(() {
          _licenseNoError = "Please fill in business license number";
        });
        isValid = false;
      }

      if (bizTypeValue.isEmpty) {
        setState(() {
          _bizTypeError = "Please explain the nature of your business";
        });
        isValid = false;
      }

      if (_encodedLicense == null || _encodedLicense!.isEmpty) {
        setState(() {
          _licenseFileError = "Please attach you business licence file";
        });
        isValid = false;
      }
    }

    if (_currPage == 2) {
      if (_selectedRegion == null) {
        setState(() {
          _regionFieldError = "Please select business region";
        });
        isValid = false;
      }

      if (phoneValue.isEmpty) {
        setState(() {
          _businessNameFieldError = "Please enter your business mobile number";
        });
        isValid = false;
      }

      if (emailValue.isEmpty) {
        setState(() {
          _emailFieldError = "Please enter your business email address";
        });
        isValid = false;
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(emailValue)) {
        setState(() {
          _emailFieldError = "Please provide a valid email address";
        });
        isValid = false;
      }

      if (licenseNoValue.isEmpty) {
        setState(() {
          _licenseNoError = "Please enter your business license number";
        });
        isValid = false;
      }

      if (tinValue.isEmpty) {
        setState(() {
          _tinFieldError = "Please enter your business TIN number";
        });
        isValid = false;
      } else if (tinValue.length != 9) {
        setState(() {
          _tinFieldError = "Please provide a valid TIN number";
        });
        isValid = false;
      }
    }

    if (_currPage == 2) {
      if (passwordValue.isEmpty) {
        setState(() {
          _passFieldError = "Please enter password";
        });
        isValid = false;
      } else if (passwordValue.length < 8) {
        setState(() {
          _passFieldError = "Password must be at least 8 characters long";
        });
        isValid = false;
      }

      if (passwordCValue.isEmpty) {
        setState(() {
          _cPassFieldError = "Please confirm password";
        });
        isValid = false;
      } else if (passwordCValue != passwordValue) {
        setState(() {
          _cPassFieldError = "Passwords do not match";
        });
        isValid = false;
      }

      if (!_termsChecked && !_privacyChecked) {
        setState(() {
          _termsFieldError =
              "Please accept terms and conditions and privacy policy";
        });
        isValid = false;
      } else if (!_termsChecked) {
        setState(() {
          _termsFieldError = "Please accept terms and conditions";
        });
        isValid = false;
      } else if (!_privacyChecked) {
        setState(() {
          _termsFieldError = "Please accept the privacy policy";
        });
        isValid = false;
      }
    }

    return isValid;
  }

  void _handleRegister(context) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final registrationData = {
      "business_name": _businessNameController.text,
      'business_tin_no': _tinC.text,
      'business_license_no': _licenseNoC.text,
      'business_type': _bizTypeC.text,
      'business_region': _businessRegionController.text,
      'business_district': 2,
      'business_ward': 2,
      'business_street': 2,
      'business_street_no': "Tanzania",
      'business_location': 2,
      'business_phone': 2,
      'security_answer': 2,
      'business_email': _passC.text,
      'password': _cPassC.text,
    };

    try {
      final response = await ApiService.post(
        'register',
        data: registrationData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "already-logged-in":
              Navigator.pushNamed(context, '/dashboard');
              return;
            case "invalid-email-address":
              setState(() {
                _formError = "Please provide a valid email address";
              });
              break;
            case "email-address-already-used":
              setState(() {
                _formError = "The provided email address is already in use";
              });
              break;
            case "nida-number-already-used":
              setState(() {
                _formError = "The provided NIDA number is already in use";
                _currPage = 1;
              });
              break;
            case "phone-number-already-used":
              setState(() {
                _formError = "The provided mobile number is already in use";
                _currPage = 1;
              });
              break;
            case "password-not-provided":
              setState(() {
                _passFieldError = "Please provide a password";
              });
              break;
            case "invalid-password":
              setState(() {
                _passFieldError = "Password must be at least 8 characters long";
              });
              break;
            case "password-not-confirmed":
              setState(() {
                _cPassFieldError = "Please confirm password";
              });
              break;
            case "passwords-do-not-match":
              setState(() {
                _cPassFieldError = "Passwords do not match";
              });
              break;

            default:
              setState(() {
                _formError = "An error occured. Please try again later";
              });
          }
        } else {
          apiProvider.authToken = response["auth-token"];
          authProvider.login();
          switch (response['success']) {
            case "email-verification-required":
              Navigator.pushNamed(
                context,
                '/verify-account',
                arguments: {'prefix': response['prefix']},
              );
              return;
          }
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        //
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _formError = "An error occured. Please try again.";
      });
    }
  }

  void _clearErrors() {
    setState(() {
      _emailFieldError = "";
      _entityFieldError = "";
      _businessNameFieldError = "";
      _licenseFieldError = "";
      _licenseNoError = "";
      _tinFieldError = "";
      _passFieldError = "";
      _cPassFieldError = "";
      _termsFieldError = "";
      _formError = "";
    });
  }
}
