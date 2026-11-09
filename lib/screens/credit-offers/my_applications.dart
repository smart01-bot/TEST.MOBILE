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
import '../../helpers/get_time_lapsed_list_widget.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class MyCreditOffersApplicationsScreen extends StatefulWidget {
  const MyCreditOffersApplicationsScreen({super.key});

  @override
  State<MyCreditOffersApplicationsScreen> createState() =>
      _MyCreditOffersApplicationsScreenState();
}

class _MyCreditOffersApplicationsScreenState
    extends State<MyCreditOffersApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;
  String viewFilter = "all";

  bool _isPageLoading = true;
  List<dynamic> _creditOffers = [];
  int indexCounter = 0;

  Future<void> fetchMyApplications() async {
    try {
      final response = await ApiService.get(
          'my-credit-offer-applications&&filter=$viewFilter&page=$currPage',
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
            _creditOffers = response['credit-offer-applications'];
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
      if (mounted) {}
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

  int maxPages = 1;
  int currPage = 1;

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
      _creditOffers = [];
    });
    await fetchMyApplications();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      indexCounter = 0;
    });
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: Column(
        children: [
          MainTopBar(
            scaffoldKey: _scaffoldKey,
            title:
                "${viewFilter == "all" ? "Credit Offer Applications" : ""} ${viewFilter == "approved" ? "Approved Credit Offers" : ""} ${viewFilter == "replied" ? "Replied Credit Offers" : ""}",
          ),
          _isPageLoading
              ? Container()
              : _creditOffers.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 0),
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
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(
                description:
                    "Fetching $viewFilter credit offer \napplications.")
            : (_creditOffers.isEmpty
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
                          color: Color(0xFFc7d3e0),
                          size: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            textAlign: TextAlign.center,
                            'You currently have no ${viewFilter == "approved" ? "approved " : ""}${viewFilter == "replied" ? "replied " : ""}credit offer applications!',
                            style: TextStyle(
                              color: Color(0xff7493b4),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (viewFilter == "all") {
                              Navigator.pushNamed(
                                  context, '/marketplace-credit-offers');
                            } else {
                              Navigator.pushNamed(
                                  context, '/my-credit-offer-applications');
                            }
                          },
                          child: Text(viewFilter == "all"
                              ? "Marketplace Credit Offers"
                              : "View All Applications"),
                        )
                      ],
                    ),
                  )
                : Column(
                    spacing: 10,
                    children: [
                      // New list design

                      ..._creditOffers.map((credit) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/view-credit-offer-application',
                              arguments: {
                                'application-id': credit["id"].toString(),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formatWithThousandSeparator(
                                              credit["desired_amount"]
                                                  .toString()),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            height: 1,
                                          ),
                                        ),
                                        Text(
                                          credit["currency"].toString().trim(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: CIColors.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    getApplicationStatusWidget(
                                        credit['status'].toString().trim(),
                                        false)
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
                                          credit["application_code"].toString(),
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
                                                credit["status-date"]
                                                    .toString())
                                            .take(2),
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
                                              credit["credit_type"].toString(),
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
                                      constraints:
                                          BoxConstraints(maxWidth: 105),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            credit["application-date"]
                                                .toString(),
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
