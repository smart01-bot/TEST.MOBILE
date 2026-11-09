import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/format_with_thousands_separator.dart';
import '../../helpers/get_application_status_widget.dart';
import '../../helpers/get_time_lapsed_list_widget.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class FeeTablesScreen extends StatefulWidget {
  const FeeTablesScreen({super.key});

  @override
  State<FeeTablesScreen> createState() => _FeeTablesScreenState();
}

class _FeeTablesScreenState extends State<FeeTablesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  String viewFilter = "all";
  String loanId = "";

  bool _isPageLoading = true;
  List<dynamic> _feeTables = [];
  int indexCounter = 0;

  Future<void> fetchFeeTables(String loanId) async {
    try {
      final response = await ApiService.get('get-fee-tables&&loan-id=$loanId',
          token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "missing-loan-id":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(
                    context, "/my-loan-applications");
              });
              return;

            default:
          }
        } else {
          setState(() {
            _feeTables = response['fee-tables'];
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
  }

  bool _isInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (loanId.isEmpty) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey("loan-id")) {
          setState(() {
            loanId = args["loan-id"];
          });
        }
        fetchFeeTables(loanId);
      }
      _isInitialized = true;
    }
  }

  Future<void> _handleRefresh() async {
    await fetchFeeTables(loanId);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      indexCounter = 0;
    });
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Received Fee Tables",
      ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(description: "Fetching received \nfee tables.")
            : (_feeTables.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.circleExclamation,
                          color: CIColors.hintColor,
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            textAlign: TextAlign.center,
                            'You currently have no Received Fee Tables',
                            style: TextStyle(
                              color: CIColors.textColorAlt,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/my-loan-applications');
                          },
                          child: Text("View Loan Applications"),
                        )
                      ],
                    ),
                  )
                : Column(
                    spacing: 10,
                    children: [
                      ..._feeTables.map(
                        (feeTable) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/view-fee-table',
                                arguments: {
                                  'fee-table-id': feeTable["id"].toString(),
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formatWithThousandSeparator(
                                                feeTable["amount"].toString()),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            feeTable["currency"]
                                                .toString()
                                                .trim(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.secondaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      getApplicationStatusWidget(
                                          feeTable['status'].toString().trim())
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.tag,
                                            color: CIColors.accentColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            feeTable["interest-charge"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: CIColors.accentColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidClock,
                                            color: CIColors.accentColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          ...getTimeElapsedList(
                                              feeTable["status-date"]
                                                  .toString()).take(2),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.fileInvoiceDollar,
                                            color: CIColors.accentColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            feeTable["payback-period"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: CIColors.accentColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidCalendar,
                                            color: CIColors.accentColor,
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            feeTable["interest-rate-date"]
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: CIColors.accentColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
      ),
    );
  }
}
