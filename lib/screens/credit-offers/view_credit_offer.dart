import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/detail_container.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ViewCreditOfferScreen extends StatefulWidget {
  const ViewCreditOfferScreen({super.key});

  @override
  State<ViewCreditOfferScreen> createState() => _ViewCreditOfferScreenState();
}

class _ViewCreditOfferScreenState extends State<ViewCreditOfferScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;
  Map<String, dynamic> _creditOffer = {};

  String _creditOfferId = "";

  Future<void> fetchCreditOffer(String id) async {
    try {
      final response = await ApiService.get('get-credit-offer&&id=$id',
          token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "missing-id":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(
                    context, '/marketplace-credit-offers');
              });

            default:
          }
        } else {
          if (response.containsKey('credit-offer')) {
            setState(() {
              _creditOffer = response['credit-offer'];
            });
          }
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

      if (_creditOfferId.isEmpty) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args.containsKey("credit-offer-id")) {
          final String creditOfferId = args["credit-offer-id"];
          setState(() {
            _creditOfferId = creditOfferId;
          });
          fetchCreditOffer(creditOfferId);
        }
      }

      _isInitialized = true;
    }
  }

  Future<void> _handleRefresh() async {
    await fetchCreditOffer(_creditOfferId);
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Credit Offer Details",
      ),
      bottomBar: _isPageLoading
          ? SizedBox()
          : Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Apply Now button
                  if (!_creditOffer['already_applied'])
                    ElevatedButton(
                      style: mainButtonStyle,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/apply-for-credit-offer',
                          arguments: {
                            'credit-offer-id': _creditOfferId,
                          },
                        );
                      },
                      child: Text(
                        "Apply for Offer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  // Already Applied
                  if (_creditOffer['already_applied'])
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidCircleCheck,
                          color: CIColors.successText,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Already Applied",
                          style: TextStyle(
                            color: CIColors.successText,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen(description: "Fetching credit offer \n details.")
            : (_creditOffer.isEmpty
                ? Text('Credit offer not available')
                : Column(
                    spacing: 20,
                    children: [
                      // Financial Institution
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
                                    'Financial Institution',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DetailContainer(
                              label: "Institution Code",
                              value: _creditOffer['bank_id'].toString(),
                            ),
                            DetailContainer(
                              label: "Type of Financial Institution",
                              value:
                                  _creditOffer['institution_type'].toString(),
                            ),
                            DetailContainer(
                              label: "Number of Employees",
                              value: _creditOffer['number_of_employees']
                                  .toString(),
                            ),
                            DetailContainer(
                              label: "Loans Disbursed in 3 yrs",
                              value: _creditOffer['loan_history'].toString(),
                            ),
                          ],
                        ),
                      ),

                      // Credit Facility
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
                                    'Credit Facility',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DetailContainer(
                              label: "Credit Type",
                              value: _creditOffer['credit_type'].toString(),
                            ),
                            DetailContainer(
                              label: "Credit Product",
                              value: _creditOffer['credit_product'].toString(),
                            ),
                          ],
                        ),
                      ),

                      // Facility Specifications
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
                                    'Facility Specifications',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DetailContainer(
                              label: "Credit Line",
                              value:
                                  "${_creditOffer['currency']} ${_creditOffer['credit_limit']}"
                                      .replaceAll(RegExp(r'\s+'), ' ')
                                      .trim(),
                            ),
                            DetailContainer(
                              label: "Interest Charge",
                              value: _creditOffer['interest_charge']
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .trim(),
                            ),
                            DetailContainer(
                              label: "Annual Fee",
                              value: _creditOffer['annual_fee']
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .trim(),
                            ),
                            DetailContainer(
                              label: "Late Payment Fee",
                              value: _creditOffer['late_payment_fee']
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .trim(),
                            ),
                            DetailContainer(
                              label: "Other Fees",
                              value:
                                  "${_creditOffer['currency']} ${_creditOffer['other_fee']}"
                                      .replaceAll(RegExp(r'\s+'), ' ')
                                      .trim(),
                            ),
                          ],
                        ),
                      ),

                      // Additional Information
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
                                    'Additional Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            DetailContainer(
                              label: "Payback Period",
                              value: _creditOffer['payback_periods']
                                  .replaceAll(RegExp(r'\s+'), ' ')
                                  .trim(),
                            ),
                            DetailContainer(
                              label: "Application Deadline",
                              value: _creditOffer['app_deadline'].toString(),
                            ),
                            DetailContainer(
                              label: "Product Promotional Content",
                              value: _creditOffer['additional_info'].toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
