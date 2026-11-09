import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../components/pagination_buttons.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../helpers/format_with_thousands_separator.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class MarketplaceCreditOffersScreen extends StatefulWidget {
  const MarketplaceCreditOffersScreen({super.key});

  @override
  State<MarketplaceCreditOffersScreen> createState() =>
      _MarketplaceCreditOffersScreenState();
}

class _MarketplaceCreditOffersScreenState
    extends State<MarketplaceCreditOffersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;
  List<dynamic> _creditOffers = [];
  int indexCounter = 0;

  int maxPages = 1;
  int currPage = 1;

  Future<void> fetchMarketPlaceOffers() async {
    try {
      final response = await ApiService.get('credit-offers&page=$currPage',
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
            _creditOffers = response['credit-offers'];
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchMarketPlaceOffers();
    });
  }

  Future<void> _handleRefresh() async {
    await fetchMarketPlaceOffers();
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
    await fetchMarketPlaceOffers();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MainTopBar(
            scaffoldKey: _scaffoldKey,
            title: "Marketplace Credit Offers",
          ),
          _isPageLoading
              ? Container()
              : _creditOffers.isEmpty
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
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(
                description: "Fetching market place \ncredit offers.")
            : (_creditOffers.isEmpty
                ? Text('There are no marketplace credit offers at the moment.')
                : Column(
                    spacing: 10,
                    children: [
                      // New list design

                      ..._creditOffers.map((credit) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/view-credit-offer',
                              arguments: {
                                'credit-offer-id': credit["id"].toString(),
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
                                              credit["credit_limit"]
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
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.solidClock,
                                          color: CIColors.successText,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          credit["app_deadline"].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.successText,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
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
                                          credit["promotion_code"].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.percent,
                                          color: CIColors.accentColor,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          credit["interest_charge"]
                                              .toString()
                                              .trim()
                                              .replaceAll(RegExp(r'\s+'), ' '),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor),
                                        ),
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
                                          credit["credit_type"].toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: CIColors.accentColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.buildingColumns,
                                          color: CIColors.accentColor,
                                          size: 12,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          credit["bank_id"].toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: CIColors.accentColor,
                                          ),
                                        ),
                                      ],
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
