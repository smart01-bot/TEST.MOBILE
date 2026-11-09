import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/main_top_bar.dart';
import '../constants/colors.dart';
import '../providers/auth_provider.dart';
import '../wrappers/authed_wrapper.dart';

class HowToApplyScreen extends StatefulWidget {
  const HowToApplyScreen({super.key});

  @override
  State<HowToApplyScreen> createState() => _HowToApplyScreenState();
}

class _HowToApplyScreenState extends State<HowToApplyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "How To Apply",
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CIColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ndugu ${authProvider.userData['name']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
                'Jinsi ya kujaza fomu ya maombi ya mkopo, tafadhali fanya kama ifuatavyo:'),
            SizedBox(height: 16),
            Text(
              'MAOMBI YA MKOPO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Ingia kwenye machaguo na chagua Loan Application'),
                  SizedBox(height: 8),
                  Text('2. Chagua Apply for a Loan/Credit'),
                  SizedBox(height: 8),
                  Text(
                      '3. Soma taarifa fupi ya mahitaji muhimu ya kuzingatia kwa uhitimu wa mikopo kisha bofya Next itakuja kwa lugha ya kiingereza.'),
                  SizedBox(height: 8),
                  Text('4. Bofya Next na ujaze fomu ya maombi ya mkopo'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tafadhali Zingatia Mahitaji haya Muhimu kwa Uhitimu wa Mikopo:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CIColors.green,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'a. Tunakuhimiza sana kuandikisha dhamana ili kuongeza thamani ya maombi yako'),
                  SizedBox(height: 8),
                  Text(
                      'b. Mkopaji lazima aambatishe nakala za PDF za hati halali zifuatazo wakati wa kuwasilisha maombi yao kwa uchunguzi wa mapema wa taasisi ya kifedha:'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Kwa Wakopaji Walioajiriwa'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'i. Kadi ya NIDA, au Leseni ya Udereva ya Tanzania, au Pasipoti'),
                  SizedBox(height: 8),
                  Text('ii. Cheti cha TIN Yako'),
                  SizedBox(height: 8),
                  Text('iii. Barua ya Ajira kutoka kwa Mwajiri'),
                  SizedBox(height: 8),
                  Text('iv. Salary Slip/Paycheck Stub (Miezi 6)'),
                  SizedBox(height: 8),
                  Text('v. Taarifa ya Benki (Miezi 6)'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Kwa Wakopaji Waliojiajiri'),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'i. Kadi ya NIDA, au Leseni ya Udereva ya Tanzania, au Pasipoti'),
                  SizedBox(height: 8),
                  Text('ii. Leseni ya Biashara'),
                  SizedBox(height: 8),
                  Text('iii. Cheti cha TIN ya Biashara'),
                  SizedBox(height: 8),
                  Text(
                      'iv. Taarifa ya Benki (Miezi 6) au Taarifa ya Pesa kwa Simu ya Mkononi (Miezi 6)'),
                  SizedBox(height: 8),
                  Text('v. Anwani ya Biashara'),
                  SizedBox(height: 8),
                  Text('v. Uthibitisho wa Mapato'),
                  SizedBox(height: 8),
                  Text('v. Hati ya Dhamana'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
                'Kwa mtumiaji wa simu, tengeneza hati zako za PDF kwa kutumia programu ifuatayo:'),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CIColors.softBlueColor,
                  foregroundColor: CIColors.primaryColor,
                ),
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.intsig.camscanner&hl=en_US&gl=US'),
                  );
                },
                icon: FaIcon(
                  FontAwesomeIcons.googlePlay,
                  size: 16,
                  color: CIColors.primaryColor,
                ),
                label: Text(
                  'PDF Scanner kwa simu za Android',
                  style: TextStyle(fontSize: 14),
                ), // Button label
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CIColors.softBlueColor,
                  foregroundColor: CIColors.primaryColor,
                ),
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://apps.apple.com/us/app/camscanner-pdf-scanner-app/id388627783'),
                  );
                },
                icon: FaIcon(
                  FontAwesomeIcons.appStoreIos,
                  size: 16,
                  color: CIColors.primaryColor,
                ),
                label: Text(
                  'PDF Scanner kwa simu za iOS',
                  style: TextStyle(fontSize: 14),
                ), // Button label
              ),
            ),
            SizedBox(height: 16),
            Text(
                'Baadhi ya Taasisi za Fedha zinaweza kukuhitaji kufungua akaunti nao kabla ya kukupa mkopo. Kwa maelezo zaidi, tafadhali wasiliana moja kwa moja na Taasisi ya Fedha husika.'),
            SizedBox(height: 16),
            Text('Tunakutakia siku njema,'),
            SizedBox(height: 0),
            Text('Timu ya TEST!'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
