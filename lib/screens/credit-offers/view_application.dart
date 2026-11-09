import 'dart:async';

import 'package:card_informatics_mobile_app/helpers/format_with_thousands_separator.dart';
import 'package:card_informatics_mobile_app/helpers/get_application_status_widget.dart';
import 'package:card_informatics_mobile_app/helpers/get_time_lapsed_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/detail_container.dart';
import '../../components/doc_container.dart';
import '../../components/input_fields/ci_file.dart';
import '../../components/input_fields/ci_long_field.dart';
import '../../components/input_fields/ci_pass_field.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/format_date.dart';
import '../../helpers/sentence_to_text_widgets.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ViewCreditOfferApplicationScreen extends StatefulWidget {
  const ViewCreditOfferApplicationScreen({super.key});

  @override
  State<ViewCreditOfferApplicationScreen> createState() =>
      _ViewCreditOfferApplicationScreenState();
}

class _ViewCreditOfferApplicationScreenState
    extends State<ViewCreditOfferApplicationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _personalDetailsKey = GlobalKey();
  final GlobalKey _applDetailsKey = GlobalKey();
  final GlobalKey _employmentDetailsKey = GlobalKey();
  final GlobalKey _loanHistoryDetailsKey = GlobalKey();
  final GlobalKey _employmentHistoryDetailsKey = GlobalKey();
  final GlobalKey _employmentHRDetailsKey = GlobalKey();
  final GlobalKey _businessDetailsKey = GlobalKey();
  final GlobalKey _residenceDetailsKey = GlobalKey();
  final GlobalKey _referee1DetailsKey = GlobalKey();
  final GlobalKey _referee2DetailsKey = GlobalKey();
  final GlobalKey _referee3DetailsKey = GlobalKey();
  final GlobalKey _collateralDetailsKey = GlobalKey();
  final GlobalKey _bankDetailsKey = GlobalKey();
  final GlobalKey _incomeDetailsKey = GlobalKey();
  final GlobalKey _applDocsKey = GlobalKey();
  final GlobalKey _bankResponseKey = GlobalKey();

  String _applicationId = "";
  Map<String, dynamic> _applicationData = {};
  Map<String, dynamic>? _employmentInfo = {};
  List<dynamic>? _loanHistoryInfo = [];
  Map<String, dynamic>? _employmentHistoryInfo = {};
  Map<String, dynamic>? _businessDetails = {};
  Map<String, dynamic>? _residenceDetails = {};
  List<dynamic>? _refereeDetails = [];
  Map<String, dynamic>? _collateralDetails = {};
  Map<String, dynamic>? _incomeDetails = {};
  List<dynamic>? _applicationDocs = [];

  String _screenShown = 'personal-details';
  List<Widget> _timeLapsed = [Text('-')];
  late Timer? _timer;

  void _toggleTabShown(String screenId) {
    if (screenId == _screenShown) {
      // setState(() {
      //   _screenShown = '';
      // });
      return;
    }
    setState(() {
      _screenShown = screenId;
    });
  }

  void _scrollToContainer(GlobalKey key) {
    Future.delayed(Duration(milliseconds: 100), () {
      final context = key.currentContext;
      if (context != null) {
        final renderBox = context.findRenderObject() as RenderBox;
        final position =
            renderBox.localToGlobal(Offset.zero); // Get the global position
        _scrollController.animateTo(
          position.dy - 160,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchApplicationData(String applicationId) async {
    try {
      final response = await ApiService.get(
        'get-credit-offer-application&&id=$applicationId',
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
            _applicationData = response['credit-offer-application'];
            _loanHistoryInfo = response['existing-loans'];
            _employmentInfo = response['employment-info'];
            _employmentHistoryInfo = response['employment-history-info'];
            _businessDetails = response['business-details'];
            _residenceDetails = response['residence-details'];
            _refereeDetails = response['referee-details'];
            _collateralDetails = response['collateral-details'];
            _incomeDetails = response['income-details'];
            _applicationDocs = response['application-docs'];
            _timeLapsed =
                getTimeElapsed(_applicationData['dart_ready_status_date']);
          });

          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              _timeLapsed =
                  getTimeElapsed(_applicationData['dart_ready_status_date']);
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
    String? annual = _applicationData['employment_type'] == 'Employed'
        ? _incomeDetails!['annual_salary']
        : _incomeDetails!['business_annual_income'];
    annual =
        annual != null && annual.isNotEmpty ? annual.replaceAll(',', '') : '0';

    String bonus = _incomeDetails!['last_year_bonus'] != null &&
            _incomeDetails!['last_year_bonus'].isNotEmpty
        ? _incomeDetails!['last_year_bonus'].replaceAll(',', '')
        : '0';

    String suppl = _incomeDetails!['annual_suppl_income'] != null &&
            _incomeDetails!['annual_suppl_income'].isNotEmpty
        ? _incomeDetails!['annual_suppl_income'].replaceAll(',', '')
        : '0';

    int total = int.parse(annual) + int.parse(bonus) + int.parse(suppl);

    return formatWithThousandSeparator(total.toString());
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey("application-id")) {
        final String applicationId = args["application-id"];
        setState(() {
          _applicationId = applicationId;
        });
        fetchApplicationData(_applicationId);
      }

      _isInitialized = true;
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

  final _passwordController = TextEditingController();
  String _passwordFieldError = "";

  final _reasonsForRejectionC = TextEditingController();
  String _reasonsForRejectionError = "";

  bool _showApplicationApprovalMessage = true;

  bool isDeletingApplication = false;

  final _reasonsForDeletionC = TextEditingController();
  String _reasonsForDeletionError = "";

  void uploadReplyDocs(context) async {
    setState(() {
      isUploadingReplyDocs = true;
    });
    try {
      final response = await ApiService.post(
        'reply-credit-offer',
        token: apiProvider.authToken,
        data: {
          'application-id': _applicationId,
          'reply-docs': _encodedReplyDocs,
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
                'Your reply has been submitted',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
            fetchApplicationData(_applicationId);
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
        'reject-credit-offer',
        token: apiProvider.authToken,
        data: {
          'application-id': _applicationId,
          'reason': _reasonsForRejectionC.text,
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
                'Bank Response Rejected',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
            fetchApplicationData(_applicationId);
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

  void deleteApplication(context, StateSetter setLocalState) async {
    setState(() {
      isDeletingApplication = true;
    });
    setLocalState(() {});
    try {
      final response = await ApiService.post(
        'delete-credit-offer-application',
        token: apiProvider.authToken,
        data: {
          'application-id': _applicationId,
          'reason': _reasonsForRejectionC.text,
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
              setLocalState(() {});
              break;
            case "password-not-provided":
              setState(() {
                _passwordFieldError = 'Please fill in your password';
              });
              setLocalState(() {});
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
                'Loan Application Deleted',
                style: TextStyle(
                  color: CIColors.successColor,
                ),
              ),
              backgroundColor: CIColors.successBox,
            ));
            fetchApplicationData(_applicationId);

            setState(() {
              _reasonsForDeletionC.text = '';
              _passwordController.text = '';
            });

            Navigator.of(context).pop();
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pop(); // Then pop the screen
            });

            return;
          }
          Navigator.of(context).pop();
        }
      }
      setState(() {
        isDeletingApplication = false;
      });
      setLocalState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occured. Please try again later',
            style: TextStyle(
              color: CIColors.errorColor,
            )),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        isDeletingApplication = false;
      });
      setLocalState(() {});
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
              'Accept Bank Response',
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
                  // Section for uploading reply docs
                  CIFile(
                    engLabel:
                        "Attach Relevant Document(s) according to the reply provided by the bank",
                    swLabel:
                        "Ambatisha Hati Husika kulingana na maelekezo yaliyotolewa na benki",
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
                        if (_encodedReplyDocs == null ||
                            _encodedReplyDocs!.isEmpty) {
                          _setReplyDocsError('Please select a file to upload');
                          setLocalState(() {});
                          return;
                        }
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
                        'Submit',
                        style: TextStyle(
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
              'Reject Bank Response',
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
                  CILongField(
                    inputController: _reasonsForRejectionC,
                    engLabel:
                        "Reasons for rejecting this credit offer application:",
                    swLabel: "Sababu za kukataa ombi hili la mkopo",
                    placeholder: "Enter reasons for rejection",
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
                        if (_reasonsForRejectionC.text.isEmpty) {
                          setState(() {
                            _reasonsForRejectionError =
                                'Please provide a reason';
                          });
                          isValid = false;
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            _passwordFieldError =
                                'Please provide your account password';
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
                        'Submit',
                        style: TextStyle(
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

  void _showDeleteModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setLocalState) {
          return AlertDialog(
            title: Text(
              'Delete Loan Application',
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
                  CILongField(
                    inputController: _reasonsForDeletionC,
                    engLabel: "Reasons for deleting this loan application:",
                    swLabel: "Sababu za kufuta ombi hili la mkopo",
                    placeholder: "Enter reasons for deletion",
                    haveError: (_reasonsForDeletionError != ""),
                  ),
                  if (_reasonsForDeletionError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _reasonsForDeletionError,
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
                        if (_reasonsForDeletionC.text.isEmpty) {
                          setState(() {
                            _reasonsForDeletionError =
                                'Please provide a reason';
                          });
                          isValid = false;
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            _passwordFieldError =
                                'Please provide your account password';
                          });
                          isValid = false;
                        }

                        if (isValid) {
                          setState(() {
                            _reasonsForDeletionError = '';
                            _passwordFieldError = '';
                          });
                          setLocalState(() {});
                          // return;
                          deleteApplication(context, setLocalState);
                        }
                        setLocalState(() {});
                      },
                style: mainButtonStyle,
                child: isDeletingApplication
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Delete',
                        style: TextStyle(
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
    await fetchApplicationData(_applicationId);
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scrollController: _scrollController,
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainTopBar(
            scaffoldKey: _scaffoldKey,
            title: "Credit Offer Candidate",
          ),
          _isPageLoading
              ? Container()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_applicationData.isNotEmpty)
                            getApplicationStatusWidget(
                                _applicationData['latest_status']
                                    .toString()
                                    .trim()),
                          if (_applicationData['latest_status']
                                  .toString()
                                  .trim() !=
                              "HQ_Disbursed")
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [..._timeLapsed],
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showDeleteModal(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Color.fromARGB(102, 248, 204, 204),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidTrashCan,
                              size: 14,
                              color: const Color.fromARGB(255, 200, 85, 85),
                            ),
                          ),
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
      bottomBar: _isPageLoading || _applicationData.isEmpty
          ? SizedBox()
          : SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(),

                  // Reject bank reply
                  if (_applicationData['latest_status'] == 'Sent_To_User')
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
                            child: Text("Reject"),
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
            ? LoadingScreen(
                description: "Fetching credit offer \napplication details.")
            : (_applicationData.isEmpty
                ? Text('Application data unavailable')
                : Column(
                    spacing: 10,
                    children: [
                      // Application approval message
                      if (_applicationData['latest_status'] ==
                              "Bank_Approved" &&
                          _showApplicationApprovalMessage)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CIColors.successBox,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                            border: Border.all(
                              color: CIColors.successText,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 10,
                            children: [
                              Text(
                                "Congratulations, your Application has been successful accepted by ",
                                style: TextStyle(
                                  color: CIColors.successColor,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "${_applicationData['bank_name']}",
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 54, 59, 57),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                "Please keep track of your status notification and reference your email for further updates. This application should be processed in Days.",
                                style: TextStyle(
                                  color: CIColors.successColor,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CIColors.successColor,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showApplicationApprovalMessage = false;
                                  });
                                },
                                child: Text("Close"),
                              ),
                            ],
                          ),
                        ),
                      // Personal Details
                      Container(
                        key: _personalDetailsKey,
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
                                _toggleTabShown('personal-details');
                                _scrollToContainer(_personalDetailsKey);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_screenShown == 'personal-details')
                                    SizedBox(
                                      width: 12,
                                    ),
                                  Expanded(
                                    child: Text(
                                      'Personal Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  FaIcon(
                                    _screenShown == 'personal-details'
                                        ? FontAwesomeIcons.caretUp
                                        : FontAwesomeIcons.caretDown,
                                    size: 15,
                                    color: _screenShown == 'personal-details'
                                        ? CIColors.primaryColor
                                        : CIColors.accentColor,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            if (_screenShown == 'personal-details')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  DetailContainer(
                                    label: "Full Name",
                                    value:
                                        "${_applicationData['f_name']} ${_applicationData['m_name']} ${_applicationData['l_name']}",
                                  ),
                                  DetailContainer(
                                    label: "NIDA Number",
                                    value: _applicationData['nida_no'],
                                  ),
                                  DetailContainer(
                                    label: "Gender",
                                    value: _applicationData['gender'],
                                  ),
                                  DetailContainer(
                                    label: "Marital Status",
                                    value: _applicationData['marital_status'],
                                  ),
                                  DetailContainer(
                                    label: "Date Of Birth",
                                    value: formatDate(
                                        _applicationData['birth_date']),
                                  ),
                                  DetailContainer(
                                    label: "Region",
                                    value: _applicationData['region'],
                                  ),
                                  DetailContainer(
                                    label: "District",
                                    value: _applicationData['district'],
                                  ),
                                  DetailContainer(
                                    label: "Citizenship",
                                    value: _applicationData['citizenship'],
                                  ),
                                  DetailContainer(
                                    label: "Mobile Number",
                                    value: _applicationData['p_number'],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // Credit offer Details
                      Container(
                        key: _applDetailsKey,
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
                                _toggleTabShown('credit-offer-details');
                                _scrollToContainer(_applDetailsKey);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (_screenShown == 'credit-offer-details')
                                    SizedBox(
                                      width: 12,
                                    ),
                                  Expanded(
                                    child: Text(
                                      'Credit Offer Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  FaIcon(
                                    _screenShown == 'credit-offer-details'
                                        ? FontAwesomeIcons.caretUp
                                        : FontAwesomeIcons.caretDown,
                                    size: 15,
                                    color:
                                        _screenShown == 'credit-offer-details'
                                            ? CIColors.primaryColor
                                            : CIColors.accentColor,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            if (_screenShown == 'credit-offer-details')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  DetailContainer(
                                    label: "Type of Financial Institution",
                                    value: _applicationData['institution_type'],
                                  ),
                                  DetailContainer(
                                    label: "Number of Employees",
                                    value:
                                        _applicationData['number_of_employees'],
                                  ),
                                  DetailContainer(
                                    label: "Number of Loans in 3 Yrs",
                                    value: _applicationData['loan_history'],
                                  ),
                                  DetailContainer(
                                    label: "Credit Type",
                                    value: _applicationData['credit_type'],
                                  ),
                                  DetailContainer(
                                    label: "Credit Limit",
                                    value: formatWithThousandSeparator(
                                        _applicationData['credit_limit']),
                                  ),
                                  DetailContainer(
                                    label: "Interest Charge",
                                    value: _applicationData['interest_charge']
                                        .replaceAll(RegExp(r'\s+'), ' ')
                                        .trim(),
                                  ),
                                  DetailContainer(
                                    label: "Annual Fees",
                                    value: _applicationData['annual_fee']
                                        .replaceAll(RegExp(r'\s+'), ' ')
                                        .trim(),
                                  ),
                                  DetailContainer(
                                    label: "Late Payment Fees",
                                    value: _applicationData['late_payment_fee']
                                        .replaceAll(RegExp(r'\s+'), ' ')
                                        .trim(),
                                  ),
                                  if (_applicationData['other_fee'] != null)
                                    DetailContainer(
                                      label: "Other Fees",
                                      value:
                                          "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_applicationData['other_fee'])}",
                                    ),
                                  DetailContainer(
                                    label: "Application Deadline",
                                    value: formatDate(
                                        _applicationData['app_deadline']),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // Loan History Details
                      if (_loanHistoryInfo != null &&
                          _loanHistoryInfo!.isNotEmpty)
                        Container(
                          key: _loanHistoryDetailsKey,
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
                                  _toggleTabShown('loan-history');
                                  _scrollToContainer(_loanHistoryDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'loan-history')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Existing Loans',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'loan-history'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'loan-history'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'loan-history')
                                ..._loanHistoryInfo!.map((loanHistory) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      DetailContainer(
                                        label: "Lending Institution",
                                        value: loanHistory!['saved_bank_name'],
                                      ),
                                      DetailContainer(
                                        label: "Type of Loan",
                                        value:
                                            loanHistory!['existing_loan_type'],
                                      ),
                                      DetailContainer(
                                        label: "Type of Loan",
                                        value:
                                            "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(loanHistory!['existing_loan_balance'])}",
                                      ),
                                    ],
                                  );
                                })
                            ],
                          ),
                        ),

                      // Employment Details
                      if (_applicationData['employment_type'] == 'Employed')
                        Container(
                          key: _employmentDetailsKey,
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
                                  _toggleTabShown('employment-details');
                                  _scrollToContainer(_employmentDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'employment-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Employment Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'employment-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color:
                                          _screenShown == 'employment-details'
                                              ? CIColors.primaryColor
                                              : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'employment-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Current Employer",
                                      value: _employmentInfo!['employer'],
                                    ),
                                    DetailContainer(
                                      label: "Current Designation",
                                      value: _employmentInfo!['designation'],
                                    ),
                                    DetailContainer(
                                      label: "Employed Since",
                                      value: formatDate(
                                          _employmentInfo!['employed_since']),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Employment History Details
                      if (_applicationData['employment_type'] == 'Employed' &&
                          _employmentHistoryInfo != null &&
                          _employmentHistoryInfo!.isNotEmpty)
                        Container(
                          key: _employmentHistoryDetailsKey,
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
                                  _toggleTabShown('employment-history');
                                  _scrollToContainer(
                                      _employmentHistoryDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'employment-history')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Employment History',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'employment-history'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color:
                                          _screenShown == 'employment-history'
                                              ? CIColors.primaryColor
                                              : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'employment-history')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Previous Employer",
                                      value:
                                          _employmentHistoryInfo!['employer'],
                                    ),
                                    DetailContainer(
                                      label: "Previous Designation",
                                      value: _employmentHistoryInfo![
                                          'designation'],
                                    ),
                                    DetailContainer(
                                      label: "Employed From",
                                      value: formatDate(_employmentHistoryInfo![
                                          'employed_from']),
                                    ),
                                    DetailContainer(
                                      label: "Employed To",
                                      value: formatDate(_employmentHistoryInfo![
                                          'employed_to']),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Employment HR Details
                      if (_applicationData['employment_type'] == 'Employed')
                        Container(
                          key: _employmentHRDetailsKey,
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
                                  _toggleTabShown('employment-hr-details');
                                  _scrollToContainer(_employmentHRDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'employment-hr-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Employment HR Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'employment-hr-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown ==
                                              'employment-hr-details'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'employment-hr-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Full Name",
                                      value: _employmentInfo!['hr_fullname'],
                                    ),
                                    DetailContainer(
                                      label: "Email",
                                      value: _employmentInfo!['hr_email'],
                                    ),
                                    DetailContainer(
                                      label: "Phone Number",
                                      value: _employmentInfo!['hr_phone'],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Business Details
                      if (_applicationData['employment_type'] ==
                          'Self_Employed')
                        Container(
                          key: _businessDetailsKey,
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
                                  _toggleTabShown('business-details');
                                  _scrollToContainer(_businessDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'business-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Business Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'business-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'business-details'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'business-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "License Number",
                                      value: _businessDetails![
                                          'business_license_no'],
                                    ),
                                    DetailContainer(
                                      label: "Legal Name",
                                      value: _businessDetails!['business_name'],
                                    ),
                                    DetailContainer(
                                      label: "Type of Business",
                                      value: _businessDetails!['business_type'],
                                    ),
                                    DetailContainer(
                                      label: "Region",
                                      value:
                                          _businessDetails!['business_region'],
                                    ),
                                    DetailContainer(
                                      label: "District",
                                      value: _businessDetails![
                                          'business_district'],
                                    ),
                                    DetailContainer(
                                      label: "Ward",
                                      value: _businessDetails!['business_ward'],
                                    ),
                                    DetailContainer(
                                      label: "Street Name",
                                      value: _businessDetails![
                                          'business_street_name'],
                                    ),
                                    DetailContainer(
                                      label: "Street Number",
                                      value: _businessDetails![
                                          'business_street_number'],
                                    ),
                                    DetailContainer(
                                      label: "Location",
                                      value: _businessDetails![
                                          'business_building_name'],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Residence Details
                      if (_residenceDetails != null &&
                          _residenceDetails!.isNotEmpty)
                        Container(
                          key: _residenceDetailsKey,
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
                                  _toggleTabShown('residence-details');
                                  _scrollToContainer(_residenceDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'residence-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Residence Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'residence-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'residence-details'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'residence-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Residence Status",
                                      value: _residenceDetails!['ownership'],
                                    ),
                                    //
                                    // Mortgaged ...
                                    if (_residenceDetails!['ownership'] ==
                                            "Mortgaged" ||
                                        (_residenceDetails!['ownership'] ==
                                            'Rented') ||
                                        (_residenceDetails!['ownership'] ==
                                                'Owned' &&
                                            _residenceDetails![
                                                    'ownership_luku_no'] !=
                                                ""))
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          DetailContainer(
                                            label: "Utility Bill Type",
                                            value: _residenceDetails![
                                                'mortgaged_bill_type'],
                                          ),
                                          if (_residenceDetails![
                                                  'mortgaged_bill_type'] !=
                                              "None")
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                if (_residenceDetails![
                                                        'mortgaged_bill_type'] ==
                                                    "Water")
                                                  DetailContainer(
                                                    label:
                                                        "Water Supply Authority",
                                                    value: _residenceDetails![
                                                        'water_authority'],
                                                  ),
                                                DetailContainer(
                                                  label:
                                                      "${_residenceDetails!['mortgaged_bill_type'] ?? '-'} Meter Number",
                                                  value: _residenceDetails![
                                                      'mortgage_bill_meter_number'],
                                                ),
                                              ],
                                            ),
                                          if (_residenceDetails![
                                                  'mortgaged_bill_type'] ==
                                              "None")
                                            DetailContainer(
                                              label:
                                                  "Reason for not paying utility bills",
                                              value: _residenceDetails![
                                                  'not_paying_explanation'],
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Referee Details
                      if (_refereeDetails != null &&
                          _refereeDetails!.isNotEmpty)
                        ..._refereeDetails!.map((referee) {
                          int index = _refereeDetails!.indexOf(referee);
                          int count = index + 1;

                          return Container(
                            key: count == 1
                                ? _referee1DetailsKey
                                : (count == 2
                                    ? _referee2DetailsKey
                                    : _referee3DetailsKey),
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
                                    _toggleTabShown('referee-details-$count');
                                    _scrollToContainer(count == 1
                                        ? _referee1DetailsKey
                                        : (count == 2
                                            ? _referee2DetailsKey
                                            : _referee3DetailsKey));
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (_screenShown ==
                                          'referee-details-$count')
                                        SizedBox(
                                          width: 12,
                                        ),
                                      Expanded(
                                        child: Text(
                                          "${_refereeDetails!.length == 1 ? '' : (count == 1 ? 'First ' : (count == 2 ? 'Second ' : (count == 3 ? 'Third ' : '')))}Referee Details",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      FaIcon(
                                        _screenShown == 'referee-details-$count'
                                            ? FontAwesomeIcons.caretUp
                                            : FontAwesomeIcons.caretDown,
                                        size: 15,
                                        color: _screenShown ==
                                                'referee-details-$count'
                                            ? CIColors.primaryColor
                                            : CIColors.accentColor,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                if (_screenShown == 'referee-details-$count')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      DetailContainer(
                                        label: "Full Name",
                                        value: referee['full_name'],
                                      ),
                                      DetailContainer(
                                        label: "NIDA Number",
                                        value: referee['nida_no'],
                                      ),
                                      DetailContainer(
                                        label: "Marital Status",
                                        value: referee['marital_status'],
                                      ),
                                      DetailContainer(
                                        label: "Profession",
                                        value: referee['profession'],
                                      ),
                                      DetailContainer(
                                        label: "E-mail",
                                        value: referee['email'],
                                      ),
                                      DetailContainer(
                                        label: "Date of Birth",
                                        value: formatDate(referee['dob']),
                                      ),
                                      DetailContainer(
                                        label: "Mobile Number",
                                        value: referee['phone'],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        }),

                      // Collateral Details
                      if (_collateralDetails != null &&
                          _collateralDetails!.isNotEmpty)
                        Container(
                          key: _collateralDetailsKey,
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
                                  _toggleTabShown('collateral-details');
                                  _scrollToContainer(_collateralDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'collateral-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Collateral Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'collateral-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color:
                                          _screenShown == 'collateral-details'
                                              ? CIColors.primaryColor
                                              : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'collateral-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Name of Collateral",
                                      value: _collateralDetails![
                                          'collateral_name'],
                                    ),
                                    DetailContainer(
                                      label: "Value of Collateral",
                                      value:
                                          "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_collateralDetails!['collateral_value'])}",
                                    ),
                                    DetailContainer(
                                      label: "Type of Document Attached",
                                      value: _collateralDetails![
                                          'collateral_doc_type'],
                                    ),
                                    if (_collateralDetails![
                                                'collateral_doc_number'] !=
                                            null &&
                                        _collateralDetails![
                                                'collateral_doc_number']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Document Number",
                                        value: _collateralDetails![
                                            'collateral_doc_number'],
                                      ),
                                    DetailContainer(
                                      label: "Recent Marital Status",
                                      value:
                                          _collateralDetails!['marital_status'],
                                    ),
                                    if (_collateralDetails!['marital_status'] ==
                                            'Married' ||
                                        _collateralDetails!['marital_status'] ==
                                            'Divorced' ||
                                        _collateralDetails!['marital_status'] ==
                                            'Widowed')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Text(
                                                "${_collateralDetails!['marital_status'] == 'Married' ? "Spouse" : _collateralDetails!['marital_status'] == 'Divorced' ? "Divorcee" : "Widow"} Information"),
                                          ),
                                          DetailContainer(
                                            label: "Full Name",
                                            value: _collateralDetails![
                                                'spouse_full_name'],
                                          ),
                                          DetailContainer(
                                            label: "NIDA Number",
                                            value: _collateralDetails![
                                                'spouse_nida_no'],
                                          ),
                                          DetailContainer(
                                            label: "Date of Birth",
                                            value: formatDate(
                                                _collateralDetails![
                                                    'spouse_dob']),
                                          ),
                                          if (_collateralDetails![
                                                  'marital_status'] !=
                                              'Widowed')
                                            DetailContainer(
                                              label: "Profession",
                                              value: _collateralDetails![
                                                  'spouse_profession'],
                                            ),
                                          if (_collateralDetails![
                                                  'marital_status'] !=
                                              'Widowed')
                                            DetailContainer(
                                              label: "Email",
                                              value: _collateralDetails![
                                                  'spouse_email'],
                                            ),
                                          if (_collateralDetails![
                                                  'marital_status'] !=
                                              'Widowed')
                                            DetailContainer(
                                              label: "Mobile Number",
                                              value: _collateralDetails![
                                                  'spouse_phone'],
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Employee Bank Details
                      if (_applicationData['employment_type'] == 'Employed' &&
                          _incomeDetails != null &&
                          _incomeDetails!.isNotEmpty)
                        Container(
                          key: _bankDetailsKey,
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
                                  _toggleTabShown('bank-details');
                                  _scrollToContainer(_bankDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'bank-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Employee Bank Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'bank-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'bank-details'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'bank-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DetailContainer(
                                      label: "Bank Account Name",
                                      value: _incomeDetails!['saved_bank_name'],
                                    ),
                                    DetailContainer(
                                      label: "Bank Account Number",
                                      value: _incomeDetails!['bank_account_no'],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Income Details
                      if (_incomeDetails != null && _incomeDetails!.isNotEmpty)
                        Container(
                          key: _incomeDetailsKey,
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
                                  _toggleTabShown('income-details');
                                  _scrollToContainer(_incomeDetailsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'income-details')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Income Details',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'income-details'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'income-details'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'income-details')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    if (_incomeDetails!['annual_salary'] !=
                                            null &&
                                        _incomeDetails!['annual_salary']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Annual Salary",
                                        value:
                                            "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_incomeDetails!['annual_salary'])}",
                                      ),
                                    if (_incomeDetails![
                                                'business_annual_income'] !=
                                            null &&
                                        _incomeDetails![
                                                'business_annual_income']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Annual Income",
                                        value:
                                            "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_incomeDetails!['business_annual_income'])}",
                                      ),
                                    if (_incomeDetails!['last_year_bonus'] !=
                                            null &&
                                        _incomeDetails!['last_year_bonus']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Total Bonus Received",
                                        value:
                                            "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_incomeDetails!['last_year_bonus'])}",
                                      ),
                                    if (_incomeDetails![
                                                'annual_suppl_income'] !=
                                            null &&
                                        _incomeDetails!['annual_suppl_income']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Supplimental Income",
                                        value:
                                            "${_applicationData['currency'].trim()} ${formatWithThousandSeparator(_incomeDetails!['annual_suppl_income'])}",
                                      ),
                                    if (_incomeDetails![
                                                'annual_suppl_income'] !=
                                            null &&
                                        _incomeDetails!['annual_suppl_income']
                                            .isNotEmpty)
                                      DetailContainer(
                                        label: "Supplemental income source",
                                        value: _incomeDetails![
                                            'suppl_income_source'],
                                      ),
                                    DetailContainer(
                                      label: "Calculated Annual Gross Income",
                                      value:
                                          "${_applicationData['currency'].trim()} ${(getTotalIncome())}",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Application Documents
                      if (_incomeDetails != null && _incomeDetails!.isNotEmpty)
                        Container(
                          key: _applDocsKey,
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
                                  _toggleTabShown('application-docs');
                                  _scrollToContainer(_applDocsKey);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (_screenShown == 'application-docs')
                                      SizedBox(
                                        width: 12,
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Attached Documents',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    FaIcon(
                                      _screenShown == 'application-docs'
                                          ? FontAwesomeIcons.caretUp
                                          : FontAwesomeIcons.caretDown,
                                      size: 15,
                                      color: _screenShown == 'application-docs'
                                          ? CIColors.primaryColor
                                          : CIColors.accentColor,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                              if (_screenShown == 'application-docs')
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    ..._applicationDocs!
                                        .map((doc) => DocContainer(
                                              label: doc['document'],
                                            ))
                                  ],
                                ),
                            ],
                          ),
                        ),

                      // Bank Response
                      if (_applicationData['add_valuers'] == 1)
                        Container(
                          key: _bankResponseKey,
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
                                  _scrollToContainer(_bankResponseKey);
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
                                      value: _applicationData['first_valuer'],
                                    ),
                                    DetailContainer(
                                      label: "Valuer Contacts",
                                      value: _applicationData[
                                          'first_valuer_contact'],
                                    ),
                                    if (_applicationData[
                                            'add_recommendation'] ==
                                        1)
                                      DetailContainer(
                                        label: "Recommendations",
                                        value:
                                            _applicationData['recommendations'],
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
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
