import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_radio_field.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/button_style_main.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/authed_wrapper.dart';

class BusinessLoanNewScreen extends StatefulWidget {
  const BusinessLoanNewScreen({super.key});

  @override
  State<BusinessLoanNewScreen> createState() => _BusinessLoanNewScreenState();
}

class _BusinessLoanNewScreenState extends State<BusinessLoanNewScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late APIProvider apiProvider;
  late AuthProvider authProvider;

  bool _isPageLoading = true;
  bool _isSubmitting = false;
  int _currPage = 1;
  String _formError = '';

  // Pre-filled from profile
  Map<String, dynamic> _profileData = {};

  // Entity type is pre-filled from profile — not selectable
  String? _entityType;
  String? _sourceOfFunding;

  String _amountError = '';
  String _purposeError = '';

  // Form controllers
  final _desiredAmountC = TextEditingController();
  final _purposeC = TextEditingController();
  final _yearsInOpC = TextEditingController();

  Future<void> _fetchProfile() async {
    try {
      final response = await ApiService.get('business/profile',
          token: apiProvider.authToken);
      if (response != null) {
        if (response.containsKey('error')) {
          if (response['error'] == 'unauthorized') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              forceLogout(context, mounted);
            });
            return;
          }
        } else {
          setState(() {
            _profileData = response['profile-data'];
            // Pre-set entity type from registration — read-only on form
            _entityType = response['profile-data']['entity_type'];
          });
        }
      }
    } catch (_) {}
    setState(() => _isPageLoading = false);
  }

  void _selectSourceOfFunding(String v) => setState(() => _sourceOfFunding = v);

  bool _isFormValid() {
    _clearErrors();
    bool valid = true;
    if (_currPage == 2) {
      if (_desiredAmountC.text.isEmpty) {
        setState(() => _amountError = 'Please enter desired amount');
        valid = false;
      }
      if (_purposeC.text.isEmpty) {
        setState(() => _purposeError = 'Please enter purpose of loan');
        valid = false;
      }
    }
    return valid;
  }

  void _clearErrors() {
    setState(() {
      _amountError = '';
      _purposeError = '';
      _formError = '';
    });
  }

  Future<void> _handleSubmit() async {
    if (!_isFormValid()) return;
    setState(() => _isSubmitting = true);

    try {
      final response = await ApiService.post(
        'business/loan/new',
        token: apiProvider.authToken,
        data: {
          'entity_type': _entityType,
          'desired_amount': _desiredAmountC.text.replaceAll(',', ''),
          'purpose_of_loan': _purposeC.text,
          'years_in_operation': _yearsInOpC.text,
          'source_of_funding': _sourceOfFunding,
        },
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case 'unauthorized':
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            default:
              setState(() => _formError = 'An error occurred. Please try again.');
          }
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/business/loan/applications');
          }
        }
      }
    } catch (_) {
      setState(() => _formError = 'An error occurred. Please try again.');
    }
    setState(() => _isSubmitting = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      _fetchProfile();
    });
  }

  @override
  void dispose() {
    _desiredAmountC.dispose();
    _purposeC.dispose();
    _yearsInOpC.dispose();
    super.dispose();
  }

  Widget _readonlyField(String label, String? value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xfff5faff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffdcefff), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: CIColors.secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value ?? '-',
              style: const TextStyle(
                  color: CIColors.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(scaffoldKey: _scaffoldKey, title: "Business Loan Application"),
      child: _isPageLoading
          ? const LoadingScreen()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x2e47688b), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Business Loan Application',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      if (_formError.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: CIColors.errorBox,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(_formError,
                              style: TextStyle(
                                  color: CIColors.errorColor, fontSize: 13)),
                        ),

                      // ── Page 1 — Business basics (all pre-filled) ──
                      if (_currPage == 1) ...[
                        _readonlyField(
                            'Business Name / Jina la Biashara',
                            _profileData['business_name']),
                        // Type of Entity — shows all options but locked to registration choice
                        IgnorePointer(
                          child: SizedBox(
                            width: double.infinity,
                            child: CIRadioField(
                              engLabel: 'Type of Entity',
                              swLabel: 'Aina ya Shirika',
                              options: const {
                                'Sole Proprietorship': ['Sole Proprietorship', 'Biashara Binafsi'],
                                'SME': ['SME', 'Biashara Ndogo na za Kati'],
                                'Company': ['Company', 'Kampuni'],
                              },
                              setOption: (_) {},
                              selectedOption: _entityType,
                              haveError: false,
                            ),
                          ),
                        ),
                        _readonlyField(
                            'Nature of Business / Aina ya Biashara',
                            _profileData['description'] ??
                                _profileData['business_nature']),
                        _readonlyField(
                            'NIDA Number / Nambari ya NIDA',
                            _profileData['nida_no']),
                        _readonlyField(
                            'Business Registration Number / Nambari ya Usajili wa Biashara',
                            _profileData['business_reg_no']),
                        _readonlyField(
                            'TIN Number / Nambari ya TIN',
                            _profileData['business_tin_no']),
                      ],

                      // ── Page 2 — Loan details ──
                      if (_currPage == 2) ...[
                        CIField(
                          inputController: _desiredAmountC,
                          engLabel: 'Desired Amount',
                          swLabel: 'Kiasi Kinachohitajika',
                          placeholder: 'Enter desired loan amount',
                          onlyDigits: false,
                          haveError: _amountError.isNotEmpty,
                        ),
                        if (_amountError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(_amountError,
                                style: const TextStyle(
                                    color: CIColors.errorText,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic)),
                          ),
                        const SizedBox(height: 12),
                        CILongField(
                          inputController: _purposeC,
                          engLabel: 'Purpose of Loan',
                          swLabel: 'Lengo la Mkopo',
                          placeholder: 'Describe the purpose of the loan',
                          haveError: _purposeError.isNotEmpty,
                        ),
                        if (_purposeError.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 4),
                            child: Text(_purposeError,
                                style: const TextStyle(
                                    color: CIColors.errorText,
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic)),
                          ),
                        const SizedBox(height: 12),
                        CIField(
                          inputController: _yearsInOpC,
                          engLabel: 'Years in Operation',
                          swLabel: 'Miaka ya Uendeshaji',
                          placeholder: 'e.g. 5',
                          onlyDigits: true,
                          haveError: false,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: CIRadioField(
                            engLabel: 'Source of Funding',
                            swLabel: 'Chanzo cha Fedha',
                            options: const {
                              'Sales': ['Sales', 'Mauzo'],
                              'Investments': ['Investments', 'Uwekezaji'],
                              'Donations': ['Donations', 'Michango'],
                              'Other': ['Other', 'Nyingine'],
                            },
                            setOption: _selectSourceOfFunding,
                            selectedOption: _sourceOfFunding,
                            haveError: false,
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // ── Navigation buttons ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currPage > 1)
                            ElevatedButton(
                              onPressed: () => setState(() => _currPage--),
                              style: mainButtonStyle,
                              child: const Text('Back',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            )
                          else
                            const SizedBox.shrink(),
                          if (_currPage < 2)
                            ElevatedButton(
                              onPressed: () {
                                if (_isFormValid()) setState(() => _currPage++);
                              },
                              style: mainButtonStyle,
                              child: const Text('Next',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            )
                          else
                            ElevatedButton(
                              onPressed: _isSubmitting ? null : _handleSubmit,
                              style: mainButtonStyle,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white))
                                  : const Text('Submit',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}