import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../constants/colors.dart';
import '../../constants/countries.dart';
import '../../components/input_fields/ci_date_picker.dart';
import '../../components/input_fields/ci_email_field.dart';
import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../components/input_fields/ci_phone_field.dart';
import '../../components/input_fields/ci_radio_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../constants/button_style_main.dart';
import '../../components/fullscreen_markdown_dialog.dart';
import '../../wrappers/non_authed_wrapper.dart';

class RegisterPersonalForeignerScreen extends StatefulWidget {
  const RegisterPersonalForeignerScreen({super.key});

  @override
  RegisterPersonalForeignerScreenState createState() =>
      RegisterPersonalForeignerScreenState();
}

class RegisterPersonalForeignerScreenState
    extends State<RegisterPersonalForeignerScreen> {
  int _currPage = 1;

  final _nidaC = TextEditingController();
  final _passPC = TextEditingController();
  final _tinC = TextEditingController();
  final _fNameC = TextEditingController();
  final _mNameC = TextEditingController();
  final _lNameC = TextEditingController();
  final _phoneC = TextEditingController();
  final _citizenC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _cPassC = TextEditingController();
  final _secQC = TextEditingController();
  final _secAC = TextEditingController();

  bool _termsChecked = false;
  bool _privacyChecked = false;

  DateTime? _birthDate;
  String? _selectedCountry;
  String? _selectedGender;
  String? _selectedMaritalStatus;

  void _setBirthDate(DateTime picked) => setState(() {
        _birthDate = picked;
      });

  void _selectCountry(String value) => setState(() {
        _selectedCountry = value;
      });

  void _selectGender(String value) => setState(() {
        _selectedGender = value;
      });

  void _selectMaritalStatus(String value) => setState(() {
        _selectedMaritalStatus = value;
      });

  bool _isLoading = false;

  String _formError = "";

  // Error fields
  String _nidaError = "";
  String _passportError = "";
  String _tinError = "";
  String _citizenshipError = "";
  String _fNameError = "";
  String _mNameError = "";
  String _lNameError = "";
  String _dateError = "";
  String _maritalError = "";
  String _emailError = "";
  String _phoneError = "";
  String _genderError = "";
  String _passFieldError = "";
  String _cPassFieldError = "";
  String _secQFieldError = "";
  String _secAFieldError = "";
  String _termsFieldError = "";

  void showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FullScreenMarkdownDialog(
        title: 'Terms & Conditions',
        markdownUrl: '${AppConfig.webUrl}/terms.md',
      ),
    );
  }

  void showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FullScreenMarkdownDialog(
        title: 'Privacy Policy',
        markdownUrl: '${AppConfig.webUrl}/privacy.md',
      ),
    );
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
                  padding: EdgeInsets.all(8.0),
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
                      const SizedBox(height: 16),

                      // Form error
                      if (_formError != "")
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(horizontal: 16),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Personal Account Registration',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Foreigner',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CIColors.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // NIDA Field
                            if (_currPage == 1)
                              CIField(
                                inputController: _nidaC,
                                engLabel: "NIDA Number",
                                swLabel: "Kitambulisho cha Mkazi au Mkimbizi",
                                placeholder:
                                    "Resident/Refugee Identity Card Number",
                                onlyDigits: true,
                                haveError: (_nidaError != ""),
                              ),
                            if (_currPage == 1 && _nidaError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _nidaError,
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

                            // Passport Field
                            if (_currPage == 1)
                              CIField(
                                inputController: _passPC,
                                engLabel: "Passport Number",
                                swLabel: "Namba ya Pasipoti",
                                placeholder: "Enter full passport number",
                                haveError: (_passportError != ""),
                              ),
                            if (_currPage == 1 && _passportError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _passportError,
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
                                engLabel: "TIN Number",
                                swLabel: "Namba ya TIN",
                                placeholder: "Enter full TIN number",
                                onlyDigits: true,
                                haveError: (_tinError != ""),
                              ),
                            if (_currPage == 1 && _tinError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tinError,
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

                            // Citizenship Field
                            if (_currPage == 1)
                              CISelectField(
                                inputController: _citizenC,
                                engLabel: "Citizenship",
                                swLabel: "Uraia",
                                placeholder: "Select your citizenship",
                                options: ci_countries_list,
                                selectedOption: _selectedCountry,
                                selectOption: _selectCountry,
                                haveError: (_citizenshipError != ""),
                              ),
                            if (_currPage == 1 && _citizenshipError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _citizenshipError,
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

                            // First Name Field
                            if (_currPage == 2)
                              CIField(
                                inputController: _fNameC,
                                engLabel: "First Name",
                                swLabel: "Jina la Kwanza",
                                placeholder: "Enter first name",
                                haveError: (_fNameError != ""),
                              ),
                            if (_currPage == 2 && _fNameError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _fNameError,
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

                            // Middle Name Field
                            if (_currPage == 2)
                              CIField(
                                inputController: _mNameC,
                                engLabel: "Middle Name",
                                swLabel: "Jina la Kati",
                                placeholder: "Enter middle name",
                                haveError: (_mNameError != ""),
                              ),
                            if (_currPage == 2 && _mNameError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _mNameError,
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

                            // Last Name Field
                            if (_currPage == 2)
                              CIField(
                                inputController: _lNameC,
                                engLabel: "Last Name",
                                swLabel: "Jina la Mwisho",
                                placeholder: "Enter last name",
                                haveError: (_lNameError != ""),
                              ),
                            if (_currPage == 2 && _lNameError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _lNameError,
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

                            // Date Field
                            if (_currPage == 2)
                              CIDatePicker(
                                dateState: _birthDate,
                                setDateState: _setBirthDate,
                                engLabel: "Date of Birth",
                                swLabel: "Tarehe ya Kuzaliwa",
                                placeholder: "Pick your birthdate",
                                isBirthDate: true,
                                haveError: _dateError != "",
                              ),
                            if (_currPage == 2 && _dateError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                            if (_currPage == 2) const SizedBox(height: 12),

                            // Last Name Field
                            if (_currPage == 2)
                              CIRadioField(
                                engLabel: "Gender",
                                swLabel: "Jinsia",
                                options: {
                                  "Male": ["Male", "Mwanaume"],
                                  "Female": ["Female", "Mwanamke"],
                                },
                                setOption: _selectGender,
                                selectedOption: _selectedGender,
                                haveError: _genderError != "",
                              ),
                            if (_currPage == 2 && _genderError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _genderError,
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

                            // Marital Status
                            if (_currPage == 3)
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
                            if (_currPage == 3 && _maritalError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            // Phone Number
                            if (_currPage == 3)
                              CIPhoneField(
                                inputController: _phoneC,
                                engLabel: "Mobile Number",
                                swLabel: "Namba ya simu ya mkononi",
                                placeholder: "e.g. 789 123 456",
                                haveError: (_phoneError != ""),
                              ),
                            if (_currPage == 3 && _phoneError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _phoneError,
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
                                engLabel: "Email Address",
                                swLabel: "Barua Pepe",
                                placeholder: "Enter email address",
                                haveError: (_emailError != ""),
                              ),
                            if (_currPage == 3 && _emailError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _emailError,
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

                            // confirm password
                            if (_currPage == 3)
                              CIField(
                                inputController: _secQC,
                                engLabel: "Security Question",
                                swLabel: "Swali La Usalama",
                                placeholder: "Question for password recovery",
                                haveError: (_secQFieldError != ""),
                              ),
                            if (_currPage == 3 && _secQFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _secQFieldError,
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
                              CIField(
                                inputController: _secAC,
                                engLabel: "Security Answer",
                                swLabel: "Jibu La Swali",
                                placeholder: "Answer for you question",
                                haveError: (_secAFieldError != ""),
                              ),
                            if (_currPage == 3 && _secAFieldError != "")
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _secAFieldError,
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
                              SizedBox(
                                height: 4,
                              ),
                            if (_currPage == 3)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _termsChecked = !_termsChecked;
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _termsChecked,
                                          onChanged: null,
                                          activeColor: CIColors.secondaryColor,
                                          fillColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return CIColors.secondaryColor;
                                              }
                                              return CIColors.transparentColor;
                                            },
                                          ),
                                          checkColor:
                                              Colors.white, // Inside tick color
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap, // Removes padding
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Wrap(
                                          runSpacing: 0,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              "I have read and accepted the ",
                                              style: const TextStyle(
                                                color: CIColors.accentColor,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showTermsDialog(context);
                                              },
                                              child: Text(
                                                'Terms ',
                                                style: const TextStyle(
                                                  color: CIColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showTermsDialog(context);
                                              },
                                              child: Text(
                                                'and ',
                                                style: const TextStyle(
                                                  color: CIColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showTermsDialog(context);
                                              },
                                              child: Text(
                                                'Conditions',
                                                style: const TextStyle(
                                                  color: CIColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            if (_currPage == 3) const SizedBox(height: 8),

                            if (_currPage == 3)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _privacyChecked = !_privacyChecked;
                                }),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Checkbox(
                                          value: _privacyChecked,
                                          onChanged: null,

                                          activeColor: CIColors.secondaryColor,
                                          fillColor: WidgetStateProperty
                                              .resolveWith<Color>(
                                            (Set<WidgetState> states) {
                                              if (states.contains(
                                                  WidgetState.selected)) {
                                                return CIColors.secondaryColor;
                                              }
                                              return CIColors.transparentColor;
                                            },
                                          ),
                                          checkColor:
                                              Colors.white, // Inside tick color
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap, // Removes padding
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Wrap(
                                          runSpacing: 0,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              "I have read and understood the ",
                                              style: const TextStyle(
                                                color: CIColors.accentColor,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showPrivacyDialog(context);
                                              },
                                              child: Text(
                                                'Privacy ',
                                                style: const TextStyle(
                                                  color: CIColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showPrivacyDialog(context);
                                              },
                                              child: Text(
                                                'Policy',
                                                style: const TextStyle(
                                                  color: CIColors.textColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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

                            if (_currPage == 3) const SizedBox(height: 12),

                            //========================================================================
                            //============================ SUBMIT BUTTONS ============================
                            //========================================================================
                            const SizedBox(height: 4),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (_currPage == 1) Spacer(),
                                  if (_currPage == 2 || _currPage == 3)
                                    ElevatedButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        setState(() {
                                          _currPage =
                                              _currPage > 1 ? _currPage - 1 : 1;
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
                                  if (_currPage == 1 || _currPage == 2)
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (await _isFormValid()) {
                                          FocusScope.of(context).unfocus();
                                          setState(() {
                                            _currPage = _currPage < 3
                                                ? _currPage + 1
                                                : 3;
                                          });
                                        }
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
                                          : () async {
                                              if (await _isFormValid()) {
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

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/register-chooser-personal');
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: CIColors.secondaryColor,
                                  ),
                                  label: Text(
                                    'Choose Nationality',
                                    style: TextStyle(
                                        color: CIColors.secondaryColor),
                                  ),
                                ),
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
                                        context, '/login');
                                  },
                                  child: Text(
                                    'Login instead',
                                    style: TextStyle(
                                        color: CIColors.secondaryColor),
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
                            '©2025 C.A.R.D. Informatics Ltd.\n All Rights Reserved',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CIColors.accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
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
    _fNameC.dispose();
    _mNameC.dispose();
    _lNameC.dispose();
    _nidaC.dispose();
    _phoneC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _cPassC.dispose();
    _secQC.dispose();
    _secAC.dispose();
    super.dispose();
  }

  bool _startsWith19or20(String str) {
    return str.startsWith('19') || str.startsWith('20');
  }

  String CapLizer(String value) {
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  Future<bool> _isFormValid() async {
    _clearErrors();
    bool isValid = true;

    String nidaValue = _nidaC.text;
    String tinValue = _tinC.text;
    String passPValue = _passPC.text;
    String fnameValue = _fNameC.text;
    String mnameValue = _mNameC.text;
    String lnameValue = _lNameC.text;
    String phoneValue = _phoneC.text;
    String emailValue = _emailC.text;
    String passwordValue = _passC.text;
    String passwordCValue = _cPassC.text;
    String secQValue = _secQC.text;
    String secACValue = _secAC.text;

    if (_currPage == 1) {
      if (nidaValue.isEmpty) {
        setState(() {
          _nidaError = "Please enter your NIDA number";
        });
        isValid = false;
      } else if (nidaValue.length != 20 || !_startsWith19or20(nidaValue)) {
        setState(() {
          _nidaError = "Please enter a valid NIDA number";
        });
        isValid = false;
      }

      if (isValid && nidaValue.length == 20) {
        if (!await _validateNida(nidaValue)) {
          setState(() {
            _nidaError = "Please enter a valid NIDA number";
          });
          isValid = false;
        }
      }

      if (passPValue.isEmpty) {
        setState(() {
          _passportError = "Please enter your passport number";
        });
        isValid = false;
      }

      if (_selectedCountry == null) {
        setState(() {
          _citizenshipError = "Please your country of origin";
        });
        isValid = false;
      }

      if (tinValue.isEmpty) {
        setState(() {
          _tinError = "Please enter business TIN";
        });
        isValid = false;
      } else if (tinValue.length != 9) {
        setState(() {
          _tinError = "Please provide a valid TIN number";
        });
        isValid = false;
      }
    }

    if (_currPage == 2) {
      if (fnameValue.isEmpty) {
        setState(() {
          _fNameError = "Please enter your first name";
        });
        isValid = false;
      }

      if (mnameValue.isEmpty) {
        setState(() {
          _mNameError = "Please enter your middle name";
        });
        isValid = false;
      }

      if (lnameValue.isEmpty) {
        setState(() {
          _lNameError = "Please enter your last name";
        });
        isValid = false;
      }

      if (_birthDate == null) {
        setState(() {
          _dateError = "Please choose your birthdate";
        });
        isValid = false;
      }

      if (_selectedGender == null) {
        setState(() {
          _genderError = "Please choose your gender";
        });
        isValid = false;
      }
    }

    if (_currPage == 3) {
      if (_selectedMaritalStatus == null) {
        setState(() {
          _maritalError = "Please choose your marital status";
        });
        isValid = false;
      }

      if (phoneValue.isEmpty) {
        setState(() {
          _phoneError = "Please enter your mobile number";
        });
        isValid = false;
      }

      if (emailValue.isEmpty) {
        setState(() {
          _emailError = "Please enter your business email address";
        });
        isValid = false;
      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(emailValue)) {
        setState(() {
          _emailError = "Please provide a valid email address";
        });
        isValid = false;
      }

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

      if (secQValue.isEmpty) {
        setState(() {
          _secQFieldError = "Please enter security question";
        });
        isValid = false;
      }

      if (secACValue.isEmpty) {
        setState(() {
          _secAFieldError = "Please enter security answer";
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

  Future<bool> _validateNida(String NIN) async {
    if (NIN.length == 20) {
      setState(() {
        _isLoading = true;
      });

      try {
        final url = 'https://ors.brela.go.tz/um/load/load_nida/$NIN';

        final headers = {
          'Content-Length': '0',
          'Content-Type': 'application/json',
        };

        final response = await http.post(Uri.parse(url), headers: headers);

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          final result = body['obj']['result'];
          return result != null;
        } else {
          return false;
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        return false;
      }
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }

  void _handleRegister(context) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final registrationData = {
      "nida_number": _nidaC.text,
      'first_name': CapLizer(_fNameC.text),
      'passport_no': _passPC.text,
      'tin_no': _tinC.text,
      'middle_name': CapLizer(_mNameC.text),
      'last_name': CapLizer(_lNameC.text),
      'birth_date': DateFormat('dd MMMM y').format(_birthDate!),
      'gender': _selectedGender,
      'marital_status': _selectedMaritalStatus,
      'phone_number': _phoneC.text,
      'citizenship': _selectedCountry,
      'email': _emailC.text,
      'security_question': _secQC.text,
      'security_answer': _secAC.text,
      'password': _passC.text,
      'confirm_password': _cPassC.text,
    };

    String userEmail = _emailC.text;

    try {
      final response = await ApiService.post(
        'register',
        data: registrationData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "already-logged-in":
              Navigator.pushReplacementNamed(context, '/dashboard');
              return;
            case "invalid-email-address":
              setState(() {
                _emailError = "Please provide a valid email address";
              });
              break;
            case "email-address-already-used":
              setState(() {
                _emailError = "The provided email address is already in use";
              });
              break;
            case "nida-number-already-used":
              setState(() {
                _nidaError = "The provided NIDA number is already in use";
                _currPage = 1;
              });
              break;
            case "invalid-nida-number":
              setState(() {
                _nidaError = "The provided NIDA number is invalid";
                _currPage = 1;
              });
              break;
            case "phone-number-already-used":
              setState(() {
                _phoneError = "The provided mobile number is already in use";
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
          // apiProvider.authToken = response["auth-token"];
          // authProvider.login();
          switch (response['success']) {
            case "email-verification-required":
              Navigator.pushReplacementNamed(
                context,
                '/verify-account',
                arguments: {
                  'prefix': response['prefix'],
                  'email': userEmail,
                },
              );
              return;
          }
          Navigator.pushReplacementNamed(context, '/login');
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
      _nidaError = "";
      _passportError = "";
      _tinError = "";
      _citizenshipError = "";
      _fNameError = "";
      _mNameError = "";
      _lNameError = "";
      _dateError = "";
      _maritalError = "";
      _emailError = "";
      _phoneError = "";
      _genderError = "";
      _passFieldError = "";
      _cPassFieldError = "";
      _secQFieldError = "";
      _secAFieldError = "";
      _termsFieldError = "";
      _formError = "";
    });
  }
}