import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../components/pagination_buttons.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/format_with_thousands_separator.dart';
import '../../helpers/get_application_status_widget.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class MarketplaceLoanApplicationsScreen extends StatefulWidget {
  const MarketplaceLoanApplicationsScreen({super.key});

  @override
  State<MarketplaceLoanApplicationsScreen> createState() =>
      _MarketplaceLoanApplicationsScreenState();
}

class _MarketplaceLoanApplicationsScreenState
    extends State<MarketplaceLoanApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  String viewFilter = "all";

  bool _isPageLoading = true;
  List<dynamic> _loanApplications = [];
  int indexCounter = 0;

  Future<void> fetchMyApplications() async {
    try {
      final response = await ApiService.get(
          'marketplace-loan-applications&page=$currPage',
          token: apiProvider.authToken);

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
            _loanApplications = response['loan-applications'];
            maxPages = response['max-pages'] ?? 1;
            currPage = response['current-page'] ?? 1;
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

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey("filter")) {
        setState(() {
          viewFilter = args["filter"];
        });
      }
      fetchMyApplications();

      _isInitialized = true;
    }
  }

  Future<void> _handleRefresh() async {
    await fetchMyApplications();
  }

  void _handleNextPrev(bool isNext) async {
    if (isNext) {
      if (currPage < maxPages) {
        setState(() {
          currPage = currPage + 1;
        });
      }
    } else {
      if (currPage > 1) {
        setState(() {
          currPage = currPage - 1;
        });
      }
    }

    setState(() {
      _isPageLoading = true;
      _loanApplications = [];
    });
    await fetchMyApplications();
  }

  int maxPages = 1;
  int currPage = 1;

  @override
  Widget build(BuildContext context) {
    setState(() {
      indexCounter = 0;
    });
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: Column(
        children: [
          MainTopBar(
            scaffoldKey: _scaffoldKey,
            title: "Marketplace Loan Applications",
          ),
          _isPageLoading
              ? Container()
              : _loanApplications.isEmpty
                  ? SizedBox()
                  : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Page $currPage of $maxPages',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
      handleRefresh: _handleRefresh,
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(
                description: "Fetching marketplace \nloan applications.")
            : (_loanApplications.isEmpty
                ? Container(
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
                            'There are currently no marketplace loan applications',
                            style: TextStyle(
                              color: CIColors.textColorAlt,
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.pushNamed(
                        //         context, '/select-employment-loan-application');
                        //   },
                        //   child: Text("Apply for a Loan/Credit"),
                        // )
                      ],
                    ),
                  )
                : Column(
                    spacing: 10,
                    children: [
                      // New list design

                      ..._loanApplications.map((loan) {
                        return Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatWithThousandSeparator(
                                            loan["loan-amount"].toString()),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          height: 1,
                                        ),
                                      ),
                                      Text(
                                        loan["currency"].toString().trim(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: CIColors.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  getApplicationStatusWidget(
                                      loan['status'].toString().trim(), false)
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.fileInvoiceDollar,
                                          color: CIColors.accentColor,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Expanded(
                                          child: Text(
                                            loan["loan-type"].toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: 105
                                      ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                          loan["application-date"].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                      if (maxPages > 1)
                        PaginationButtons(
                          func: _handleNextPrev,
                          showNext: currPage < maxPages,
                          showPrev: currPage > 1,
                        ),
                    ],
                  )),
      ),
    );
  }
}
