import 'dart:async';

import 'package:test_mobile/components/input_fields/ci_field.dart';
import 'package:test_mobile/helpers/get_time_lapsed_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/detail_container.dart';
import '../../components/input_fields/ci_file.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/get_application_status_widget_fee_tables.dart';
import '../../helpers/sentence_to_text_widgets.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ViewFeeTableScreen extends StatefulWidget {
  const ViewFeeTableScreen({super.key});

  @override
  State<ViewFeeTableScreen> createState() => _ViewFeeTableScreenState();
}

class _ViewFeeTableScreenState extends State<ViewFeeTableScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;

  String _feeTableId = "";
  Map<String, dynamic> _feeTableData = {};
  final Map<String, dynamic> _employmentInfo = {};
  final Map<String, dynamic> _employmentHistoryInfo = {};
  final Map<String, dynamic> _businessDetails = {};
  final Map<String, dynamic> _residenceDetails = {};
  final List<dynamic> _refereeDetails = [];
  final Map<String, dynamic> _collateralDetails = {};
  final Map<String, dynamic> _incomeDetails = {};
  final List<dynamic> _applicationDocs = [];

  String _screenShown = 'fee-table-details';
  List<Widget> _timeLapsed = [Text('-')];
  late Timer _timer;

  void _toggleTabShown(String screenId) {
    if (screenId == _screenShown) {
      setState(() {
        _screenShown = '';
      });
      return;
    }
    setState(() {
      _screenShown = screenId;
    });
  }

  Future<void> fetchFeeTableData(String feeTableId) async {
    try {
      final response = await ApiService.get(
        'get-fee-table&&id=$feeTableId',
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
            case "fee-table-not-found":
              break;

            default:
          }
        } else {
          setState(() {
            _feeTableData = response['fee-table'];
            _timeLapsed =
                getTimeElapsed(_feeTableData['dart_ready_status_date']);
          });

          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              _timeLapsed =
                  getTimeElapsed(_feeTableData['dart_ready_status_date']);
            });
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

  String getTotalIncome() {
    String? annual = _feeTableData['employment_type'] == 'Employed'
        ? _incomeDetails['annual_salary']
        : _incomeDetails['business_annual_income'];
    annual =
        annual != null && annual.isNotEmpty ? annual.replaceAll(',', '') : '0';

    String bonus = _incomeDetails['last_year_bonus'] != null &&
            _incomeDetails['last_year_bonus'].isNotEmpty
        ? _incomeDetails['last_year_bonus'].replaceAll(',', '')
        : '0';

    String suppl = _incomeDetails['annual_suppl_income'] != null &&
            _incomeDetails['annual_suppl_income'].isNotEmpty
        ? _incomeDetails['annual_suppl_income'].replaceAll(',', '')
        : '0';

    int total = int.parse(annual) + int.parse(bonus) + int.parse(suppl);

    return total.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (_feeTableId.isEmpty) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey("fee-table-id")) {
        final String applicationId = args["fee-table-id"];
        setState(() {
          _feeTableId = applicationId;
        });
        fetchFeeTableData(_feeTableId);
      }
    }
  }

  bool isUploadingReplyDocs = false;
  Map<String, String>? _encodedReplyDoc;
  List<Map<String, String>>? _encodedReplyDocs;
  String _replyDocsError = "";

  void _setReplyDocEncoded(Map<String, String> value) => setState(() {
        _encodedReplyDoc = value;
      });
  void _setReplyDocsEncoded(List<Map<String, String>> value) => setState(() {
        _encodedReplyDocs = value;
      });

  void _setReplyDocsError(String value) => setState(() {
        _replyDocsError = value;
      });
  String? _replyDocFileName;
  void _setReplyDocFilename(String value) => setState(() {
        _replyDocFileName = value;
      });

  final _newAmountController = TextEditingController();
  String _newAmountFieldError = "";

  final _passwordController = TextEditingController();
  String _passwordFieldError = "";

  final _reasonsForRejectionC = TextEditingController();
  String _reasonsForRejectionError = "";

  final bool _showApplicationApprovalMessage = true;

  final reasonC = TextEditingController();
  String? _selectedReason;
  void _selectReason(String value) => setState(() {
        _selectedReason = value;
      });
  String _reasonError = "";
  void _setReasonError(String value) => setState(() {
        _reasonError = value;
      });

  void uploadReplyDocs(context) async {
    setState(() {
      isUploadingReplyDocs = true;
    });
    try {
      final response = await ApiService.post(
        'reply-fee-table',
        token: apiProvider.authToken,
        data: {
          'fee-table-id': _feeTableId,
          'reply-docs': _encodedReplyDocs,
          'new-amount': _newAmountController.text,
        },
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed! Please try again later',
                    style: TextStyle(
                      color: CIColors.errorColor,
                    )),
                backgroundColor: CIColors.errorBox,
              ));
              return;
          }
        } else {
          if (response.containsKey('success')) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Fee Table Accepted',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
            fetchFeeTableData(_feeTableId);
          }
          Navigator.of(context).pop();
        }
      }
      setState(() {
        isUploadingReplyDocs = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occured. Please try again later',
            style: TextStyle(
              color: CIColors.errorColor,
            )),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        isUploadingReplyDocs = false;
      });
    }
  }

  void rejectOffer(context) async {
    setState(() {
      isUploadingReplyDocs = true;
    });
    try {
      final response = await ApiService.post(
        'reject-fee-table',
        token: apiProvider.authToken,
        data: {
          'rate-id': _feeTableId,
          'reason': _selectedReason,
          // 'reasons-for-rejection': _reasonsForRejectionC.text,
          'password': _passwordController.text,
        },
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "incorrect-password":
              setState(() {
                _passwordFieldError = 'Incorrect password';
              });
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed! Please try again later',
                    style: TextStyle(
                      color: CIColors.errorColor,
                    )),
                backgroundColor: CIColors.errorBox,
              ));
              return;
          }
        } else {
          if (response.containsKey('success')) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Fee Table Rejected',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
            fetchFeeTableData(_feeTableId);
          }
          Navigator.of(context).pop();
        }
      }
      setState(() {
        isUploadingReplyDocs = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occured. Please try again later',
            style: TextStyle(
              color: CIColors.errorColor,
            )),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        isUploadingReplyDocs = false;
      });
    }
  }

  void _showAcceptReplyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setLocalState) {
          return AlertDialog(
            title: Text(
              'Accept Fee Table',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CIColors.textColor,
              ),
            ),
            content: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        ...sentenceToTextWidgets(
                            "The fee table amount proposed is",
                            color: CIColors.secondaryColor),
                        Text(
                          "${_feeTableData['loan_currency']} ",
                          style: TextStyle(
                            color: CIColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_feeTableData['amount']}. ",
                          style: TextStyle(
                            color: CIColors.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...sentenceToTextWidgets(
                            "You can only accept upto the proposed amount.",
                            color: CIColors.secondaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      children: [
                        ...sentenceToTextWidgets(
                            "Kiwango kilichopendekezwa na taasisi ya fedha ni",
                            color: CIColors.textColor),
                        Text(
                          "${_feeTableData['loan_currency']} ",
                          style: TextStyle(
                            color: CIColors.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${_feeTableData['amount']}. ",
                          style: TextStyle(
                            color: CIColors.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...sentenceToTextWidgets(
                            "Hiki ndo kikomo cha kiwango unachoweza kukubali.",
                            color: CIColors.textColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Section for uploading reply docs
                  CIField(
                    inputController: _newAmountController,
                    engLabel: "Fee table amount",
                    swLabel: "Thamani ya Mkopo iliyopendekezwa",
                    placeholder: "Enter new amount",
                    haveError: (_newAmountFieldError != ""),
                    onlyDigits: true,
                  ),
                  if (_newAmountFieldError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _newAmountFieldError,
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

                  const SizedBox(height: 16),

                  // Section for uploading reply docs
                  CIFile(
                    engLabel:
                        "Please Attach the Valuation Report of Your Collateral",
                    swLabel: "Ambatanisha Ripoti ya Thamani ya Dhamana Yako",
                    setFileEncoded: _setReplyDocEncoded,
                    setFilesEncoded: _setReplyDocsEncoded,
                    fileName: _replyDocFileName,
                    setFileName: _setReplyDocFilename,
                    haveError: (_replyDocsError != ""),
                    setError: (String value) {
                      _setReplyDocsError(value);
                      setLocalState(() {});
                    },
                    allowMultipleFiles: true,
                  ),

                  if (_replyDocsError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _replyDocsError,
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
                  if (_replyDocFileName != null &&
                      _replyDocFileName!.split(',').length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected Files:",
                            style: TextStyle(
                              color: CIColors.secondaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ..._replyDocFileName!.split(',').map(
                                (e) => Text(
                                  " - ${e.trim()}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
              ElevatedButton(
                onPressed: isUploadingReplyDocs
                    ? null
                    : () {
                        if (_newAmountController.text.isEmpty) {
                          setState(() {
                            _newAmountFieldError =
                                'Please provide a new amount';
                          });
                          setLocalState(() {});
                          return;
                        } else if (int.parse(_newAmountController.text) >
                            int.parse(
                                _feeTableData['amount'].replaceAll(',', ''))) {
                          setState(() {
                            _newAmountFieldError =
                                'New amount cannot exceed the proposed amount';
                          });
                          return;
                        }
                        if (_encodedReplyDocs == null ||
                            _encodedReplyDocs!.isEmpty) {
                          _setReplyDocsError('Please select a file to upload');
                          setLocalState(() {});
                          return;
                        }

                        setState(() {
                          _newAmountFieldError = '';
                        });
                        _setReplyDocsError('');
                        uploadReplyDocs(context);
                      },
                style: mainButtonStyle,
                child: isUploadingReplyDocs
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Submit',style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                      ),
              )
            ],
          );
        });
      },
    );
  }

  void _showRejectReplyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setLocalState) {
          return AlertDialog(
            title: Text(
              'Decline Fee Table',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CIColors.textColor,
              ),
            ),
            content: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reasons
                  CISelectField(
                    inputController: reasonC,
                    engLabel:
                        "Please tell us why you are declining this fee table",
                    swLabel: "Tafadhali tuambie ni kwa nini unakataa",
                    placeholder: "Select Reason",
                    options: [
                      "Interest is Too High",
                      "Received Better Interest Rate Elsewhere",
                      "Not the Best General Loan Terms",
                      "Credit/Loan No Longer Needed",
                      "Terms for 'Other Fees' Not Acceptable",
                      "Approval Time Too Long",
                      "I've Already Commited To Too Many Offers",
                      "Interest Rate is Not Competitive Enough",
                      "Too Many Additional Conditions",
                      "Other",
                    ],
                    selectOption: _selectReason,
                    selectedOption: _selectedReason,
                    haveError: (_reasonError != ""),
                  ),
                  if (_reasonError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 8),

                  if (_selectedReason != null && _selectedReason == "Othetrr")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CILongField(
                          inputController: _reasonsForRejectionC,
                          engLabel: "Enter Other Reason",
                          swLabel: "Weka Sababu Nyingine",
                          placeholder: "Limit 320 characters...",
                          haveError: (_reasonsForRejectionError != ""),
                        ),
                        if (_reasonsForRejectionError != "")
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _reasonsForRejectionError,
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
                      ],
                    ),

                  // Password Field
                  CIPassField(
                    inputController: _passwordController,
                    engLabel: "Account Password",
                    swLabel: "Neno la Siri la Akaunti",
                    placeholder: "Enter your password",
                    haveError: (_passwordFieldError != ""),
                  ),
                  if (_passwordFieldError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _passwordFieldError,
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

                  const SizedBox(height: 16),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
              ElevatedButton(
                onPressed: isUploadingReplyDocs
                    ? null
                    : () {
                        bool isValid = true;
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            _passwordFieldError =
                                'Please provide your account password';
                          });
                          isValid = false;
                        }
                        if (_selectedReason == null) {
                          setState(() {
                            _reasonError = 'Please select a reason';
                          });
                          isValid = false;
                        }
                        if (isValid) {
                          setState(() {
                            _reasonsForRejectionError = '';
                            _passwordFieldError = '';
                          });
                          rejectOffer(context);
                        }
                      },
                style: mainButtonStyle,
                child: isUploadingReplyDocs
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Submit',style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                      ),
              )
            ],
          );
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    await fetchFeeTableData(_feeTableId);
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainTopBar(
            scaffoldKey: _scaffoldKey,
            title: "Received Fee Table",
          ),
          _isPageLoading
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_feeTableData.isNotEmpty)
                        getApplicationStatusWidgetFeeTables(
                            _feeTableData['status'].toString().trim()),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [..._timeLapsed],
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 4,
          )
        ],
      ),
      bottomBar: _isPageLoading || _feeTableData.isEmpty
          ? SizedBox()
          : SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(),

                  // Reject bank reply
                  if (_feeTableData['status'] == 'Reviewed')
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _showRejectReplyModal(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CIColors.errorColor,
                            ),
                            child: Text("Decline"),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              _showAcceptReplyModal(context);
                            },
                            child: Text("Accept"),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(description: "Fetching fee table details.")
            : (_feeTableData.isEmpty
                ? Text('Fee table data unavailable')
                : Column(
                    spacing: 10,
                    children: [
                      // Credit offer Details
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
                            GestureDetector(
                              onTap: () {
                                _toggleTabShown('fee-table-details');
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_screenShown == 'fee-table-details')
                                    SizedBox(
                                      width: 12,
                                    ),
                                  Expanded(
                                    child: Text(
                                      'Fee Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  FaIcon(
                                    _screenShown == 'fee-table-details'
                                        ? FontAwesomeIcons.caretUp
                                        : FontAwesomeIcons.caretDown,
                                    size: 15,
                                    color: _screenShown == 'fee-table-details'
                                        ? CIColors.primaryColor
                                        : CIColors.accentColor,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            if (_screenShown == 'fee-table-details')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  DetailContainer(
                                    label: "Proposed Loan Amount",
                                    value:
                                        "${_feeTableData['loan_currency']} ${_feeTableData['amount']}",
                                  ),
                                  DetailContainer(
                                    label: "Interest Charge",
                                    value: _feeTableData['interest_charge'],
                                  ),
                                  DetailContainer(
                                    label: "Annual Fee",
                                    value: _feeTableData['annual_fee'],
                                  ),
                                  DetailContainer(
                                    label: "Late Payment Fee",
                                    value: _feeTableData['late_payment_fee'],
                                  ),
                                  DetailContainer(
                                    label: "Payback Period",
                                    value: _feeTableData['payback_period'],
                                  ),
                                  DetailContainer(
                                    label: "Other Fees",
                                    value: _feeTableData['other_fees'],
                                  ),
                                  DetailContainer(
                                    label: "Details of 'Other Fees'",
                                    value:
                                        _feeTableData['other_fees_explanation'],
                                  ),
                                  DetailContainer(
                                    label: "Payback Period",
                                    value: _feeTableData['payback_period'],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // Bank Response
                      if (_feeTableData['first_valuer'] != null &&
                          _feeTableData['first_valuer'].toString().isNotEmpty)
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
                              GestureDetector(
                                onTap: () {
                                  _toggleTabShown('bank-reply-details');
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'bank-reply-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Bank Response',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'bank-reply-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color:
                                          _screenShown == 'bank-reply-details'
                                              ? CIColors.primaryColor
                                              : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'bank-reply-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Wrap(
                                        runSpacing: 0,
                                        children: [
                                          ...sentenceToTextWidgets(
                                            "Contact Valuer Below to Obtain an Official Valuation of Your Collateral /",
                                            color: CIColors.secondaryColor,
                                          ),
                                          ...sentenceToTextWidgets(
                                            "Wasiliana na Mthamini Hapo Chini Ili Kupata Thamani Rasmi ya Dhamana Yako",
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    DetailContainer(
                                      label: "Valuer",
                                      value: _feeTableData['first_valuer'],
                                    ),
                                    DetailContainer(
                                      label: "Valuer Contacts",
                                      value:
                                          _feeTableData['first_valuer_contact'],
                                    ),
                                    if (_feeTableData['recommendations'] !=
                                            null &&
                                        _feeTableData['recommendations']
                                            .toString()
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Recommendations",
                                        value: _feeTableData['recommendations'],
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                    ],
                  )),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer.cancel();
    });
    super.dispose();
  }
}
