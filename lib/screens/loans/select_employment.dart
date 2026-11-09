import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../wrappers/authed_wrapper.dart';

class SelectEmploymentScreen extends StatefulWidget {
  const SelectEmploymentScreen({super.key});

  @override
  State<SelectEmploymentScreen> createState() => _SelectEmploymentScreenState();
}

class _SelectEmploymentScreenState extends State<SelectEmploymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Apply for a Loan/Credit",
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/apply-for-loan-employed',
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CIColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    FaIcon(
                      FontAwesomeIcons.briefcase,
                      color: CIColors.textColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Employed Applicants",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Waombaji Walioajiriwa",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: CIColors.secondaryColor),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/apply-for-loan-self-employed',
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CIColors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    FaIcon(
                      FontAwesomeIcons.store,
                      color: CIColors.textColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Self-Employed Applicants",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Waombaji Waliojiajiri",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: CIColors.secondaryColor),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
