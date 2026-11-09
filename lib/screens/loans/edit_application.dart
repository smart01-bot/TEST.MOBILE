import 'package:card_informatics_mobile_app/components/input_fields/ci_file.dart';
import 'package:card_informatics_mobile_app/helpers/format_with_thousands_separator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/allowed_currecies.dart';
import '../../constants/colors.dart';
import '../../constants/loan_facilities.dart';
import '../../helpers/force_logout.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class EditApplicationScreen extends StatefulWidget {
  const EditApplicationScreen({super.key});

  @override
  State<EditApplicationScreen> createState() => _EditApplicationScreenState();
}

class _EditApplicationScreenState extends State<EditApplicationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;

  String _applicationId = "";
  Map<String, dynamic> _applicationData = {};

  String? _selectedRegion;
  String? _selectedDistrict;
  final Map<String, dynamic> _profileData = {};

  DateTime? _birthDate;
  String? _selectedMaritalStatus;

  bool _isLoading = false;

  Map<String, String>? _encodedDoc;
  String _docError = "";
  String? _docFileName;
  void _setdocFilename(String value) => setState(() {
        _docFileName = value;
      });
  void _selectdocEncoded(Map<String, String> value) => setState(() {
        _encodedDoc = value;
      });

  void _selectdocFileError(String value) => setState(() {
        _docError = value;
      });

  String? _selectedCurrency;

  final _loanFacilityController = TextEditingController();
  String _loanFacilityError = "";
  String? _selectedLoanFacility;
  void _selectLoanFacility(String value) => setState(() {
        _selectedLoanFacility = value;
      });

  final _loanCurrencyController = TextEditingController();
  String _loanCurrencyError = "";

  void _selectCurrency(String value) => setState(() {
        _selectedCurrency = value;
      });

  final _loanAmountController = TextEditingController();
  String _loanAmountError = "";

  final _loanPurposeC = TextEditingController();
  String _loanPurposeError = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (_applicationId.isEmpty) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey("loan-id")) {
          final String applicationId = args["loan-id"];
          setState(() {
            _applicationId = applicationId;
          });
          fetchApplicationData(_applicationId);
          _isInitialized = true;
        }
      }
    }
  }

  void fetchApplicationData(String applicationId) async {
    try {
      final response = await ApiService.get(
        'get-loan-application-for-editing&&id=$applicationId',
        token: apiProvider.authToken,
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "application-not-found":
              break;

            default:
          }
        } else {
          setState(() {
            _applicationData = response['loan-application'];

            if (allowedCurrencies
                .contains(_applicationData['loan_currency'].trim())) {
              _selectCurrency(_applicationData['loan_currency'].trim());
            }
            if (ciLoanTypes.contains(_applicationData['loan_type'])) {
              _selectLoanFacility(_applicationData['loan_type']);
            }

            _loanAmountController.text =
                formatWithThousandSeparator(_applicationData['loan_amount']);

            _loanPurposeC.text = _applicationData['loan_purpose'];
          });
        }
      }
      setState(() {
        _isPageLoading = false;
      });
    } catch (e) {
      // Request not sent
      if (mounted) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Edit Loan Application",
      ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(
                description: "Fetching loan details.",
              )
            : (_applicationData.isEmpty
                ? Text('Loan application details are not available')
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
                                      'Application Details',
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

                              // Loan Facility
                              CISelectField(
                                inputController: _loanFacilityController,
                                engLabel: "Loan Facility Requested",
                                swLabel: "Aina ya Mkopo Unaoomba",
                                placeholder: "Select Loan Facility",
                                options: ciLoanTypes,
                                selectOption: _selectLoanFacility,
                                selectedOption: _selectedLoanFacility,
                                haveError: (_loanFacilityError != ""),
                              ),
                              if (_loanFacilityError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _loanFacilityError,
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
                              const SizedBox(height: 8),

                              // Loan Currency
                              CISelectField(
                                inputController: _loanCurrencyController,
                                engLabel: "Select Your Income Currency",
                                swLabel: "Chagua aina ya sarafu",
                                placeholder: "Select Currency",
                                options: allowedCurrencies,
                                selectOption: _selectCurrency,
                                selectedOption: _selectedCurrency,
                                haveError: (_loanCurrencyError != ""),
                              ),
                              if (_loanCurrencyError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _loanCurrencyError,
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
                              const SizedBox(height: 8),

                              // Loan amount
                              CIField(
                                inputController: _loanAmountController,
                                engLabel: "Value of Loan Requested ",
                                swLabel: "Thamani ya Mkopo Unaoomba",
                                placeholder: "Enter amount",
                                haveError: (_loanAmountError != ""),
                                onlyDigits: true,
                                isMoney: true,
                                prefix: _selectedCurrency ?? '',
                              ),
                              if (_loanAmountError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _loanAmountError,
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
                              const SizedBox(height: 8),

                              // Loan purpose
                              CILongField(
                                inputController: _loanPurposeC,
                                engLabel: "Purpose for this loan",
                                swLabel: "Kusudi la Mkopo",
                                placeholder: "Short and clear answer",
                                haveError: (_loanPurposeError != ""),
                              ),
                              const SizedBox(height: 8),
                              CIFile(
                                  engLabel: "Attach documents",
                                  swLabel: 'Ambatanisha Nyaraka',
                                  fileName: _docFileName,
                                  setFileName: _setdocFilename,
                                  setFileEncoded: _selectdocEncoded,
                                  setError: _selectdocFileError),
                              if (_loanPurposeError != "")
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _loanPurposeError,
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
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 24),
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () {
                                            if (_isFormValid(context)) {
                                              _handleEditLoan(context);
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
    super.dispose();
  }

  void _handleEditLoan(context) async {
    _clearErrors();

    setState(() {
      _isLoading = true;
    });

    final editLoanData = {
      "application-id": _applicationId,
      "loan-amount": _loanAmountController.text,
      "loan-currency": _selectedCurrency,
      "loan-type": _selectedLoanFacility,
      "loan-purpose": _loanPurposeC.text,
      "attachment-doc": _encodedDoc
    };

    try {
      final response = await ApiService.post(
        'update-loan-application',
        token: apiProvider.authToken,
        data: editLoanData,
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              forceLogout(context, mounted);
              return;
            case "missing-fields":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Please fill in all fields',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;
            case "application-not-editable":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'This application can no longer be edited',
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
                'Application details updated successfully',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));

            Future.delayed(Duration(milliseconds: 50), () {
              Navigator.pushNamed(
                context,
                '/view-loan-application',
                arguments: {
                  'application-id': _applicationId,
                },
              );
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

  bool _isFormValid(context) {
    _clearErrors();
    bool isValid = true;

    if (_loanAmountController.text.isEmpty) {
      setState(() {
        _loanAmountError = "Please enter loan amount";
      });
      isValid = false;
    }

    if (_loanPurposeC.text.isEmpty) {
      setState(() {
        _loanPurposeError = "Please enter the purpose for this loan";
      });
      isValid = false;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please fill out all fields',
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
    }

    return isValid;
  }

  void _clearErrors() {
    setState(() {
      _loanPurposeError = '';
      _loanAmountError = '';
      _loanCurrencyError = '';
      _loanFacilityError = '';
    });
  }
}
