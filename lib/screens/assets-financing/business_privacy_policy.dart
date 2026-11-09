import 'package:flutter/material.dart';

import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../wrappers/authed_wrapper.dart';

class BusinessPrivacyPolicyScreen extends StatefulWidget {
  const BusinessPrivacyPolicyScreen({super.key});

  @override
  State<BusinessPrivacyPolicyScreen> createState() =>
      _BusinessPrivacyPolicyScreenState();
}

class _BusinessPrivacyPolicyScreenState
    extends State<BusinessPrivacyPolicyScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
      
        title: "Privacy Policy",
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CIColors.whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CIColors.textColor,
              ),
            ),
            SizedBox(height: 16),
            _bodyText(
              'Your privacy is important to us. This privacy statement explains the personal data C.A.R.D. Informatics Ltd. (The Company) may possess, how The Company processes it, and for what purposes. The Company offers a wide range of services, including server solutions used for the delivery of those solutions.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Personal Data We Collect'),
            SizedBox(height: 8),
            _bodyText(
              'The Company collects data from you, through its interactions with you and through the provision of our solutions. You provide some of this data directly, and we get some of it by collecting data about your interactions, use, and experiences with our services. The data we collect depends on the context of your interactions with The Company and the choices you make, including your privacy settings (if any) and the services and features you use. We may also obtain data about you from third parties.',
            ),
            SizedBox(height: 12),
            _bodyText(
              'You have choices when it comes to the technology you use and the data you share. When we ask you to provide personal data, you can decline. Many of our solutions require some personal data to provide you with a service. If you choose not to provide data required to provide you with a solution or feature, you cannot get that solution or feature. Likewise, where we need to collect personal data by law or to enter into or carry out an agreement with you, and you do not provide the data, we will not be able to enter into the contract; or where this relates to an existing service, we may have to suspend or cancel it. We will notify you if this is the case at the time.',
            ),
            SizedBox(height: 20),
            _sectionTitle('How We Use Personal Data'),
            SizedBox(height: 8),
            _bodyText(
              'The Company uses the data we collect to provide you with rich, interactive experiences. In particular, we use data to provide, operate, and improve our services and solutions.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Reasons We Share Personal Data'),
            SizedBox(height: 8),
            _bodyText(
              'We share your personal data with your consent to complete any transaction or provide services and solutions you have requested or authorized. We also share data with affiliates (if any); to protect our customers and to protect the rights and property of The Company and its clients.',
            ),
            SizedBox(height: 20),
            _sectionTitle('How to Access and Control Your Personal Data'),
            SizedBox(height: 8),
            _bodyText(
              'You can make choices about the collection and use of your data by The Company. You can control your personal data that The Company has obtained, and exercise your data protection rights, by contacting The Company. In some cases, your ability to access or control your personal data may be limited, as required by the company, or as permitted by applicable law. How you can access or control your personal data will also depend on which services and solutions you use.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Cookies and Similar Technologies'),
            SizedBox(height: 8),
            _bodyText(
              'Cookies are small text files placed on your device to store data that can be recalled by a web server in the domain that placed the cookie. We may use cookies and similar technologies for storing and honoring your preferences and settings, enabling you to sign in, providing (if any) interest-based advertising, combating fraud, analyzing how our solutions are of value-add, and fulfilling other legitimate purposes. You have a variety of tools to control the data collected by cookies, web beacons, and similar technologies. For example, you can use controls in your internet browser to limit how the websites you visit are able to use cookies and to altogether withdraw your consent by clearing or blocking cookies.',
            ),
            SizedBox(height: 20),
            _sectionTitle('The Company Account'),
            SizedBox(height: 8),
            _bodyText(
              'When you have an account with The Company, you can sign in to access Company solutions, as well as those from select Company partners. Personal data associated with your Company account includes credentials, name and contact data, and usage data, and other information about your account activities. Signing in to your Company account enables personalization and consistent experiences across our platform services. There are three types of Company accounts:',
            ),
            SizedBox(height: 8),
            _numberedText(1, 'When you create your own Company account tied to your personal email address, we refer to that account as a personal account.'),
            _numberedText(2, 'When you or your organization (such as an employer or your school) creates a Company account tied to an email address provided by that organization, we refer to that account as a work or school account.'),
            _numberedText(3, 'When you or your service provider (such as an internet service provider) creates a Company account tied to your email address with your service provider domain, we refer to that account as a third-party account.'),
            SizedBox(height: 8),
            _bodyText(
              'If you sign into a service offered by a third party with your Company account, you will share with that third party the account data required by that service.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Our Commitment to Privacy'),
            SizedBox(height: 8),
            _bodyText(
              'At The Company, our mission is to empower every person and every entity in Tanzania, public or private, to achieve more. This starts with making sure you get meaningful choices when you share data with us. It also means we are committed to transparent communication about why we ask for your data, and how we use the data you share in order to provide the most streamlined solutions and services. We are working to earn your trust every day by focusing on five key privacy principles:',
            ),
            SizedBox(height: 8),
            _numberedText(1, 'Control: We will put you in control of your privacy with easy-to-use tools and clear choices.'),
            _numberedText(2, 'Transparency: We will be transparent about data collection so you can make informed decisions.'),
            _numberedText(3, 'Security: We will protect the data you entrust to us through strong security and encryption.'),
            _numberedText(4, 'Respectful protection: We will respect privacy laws and ensure above-board protections on your privacy.'),
            _numberedText(5, 'Benefits to you: When we collect data, we will use it to benefit you and to make your experiences better.'),
            SizedBox(height: 12),
            _bodyText(
              'These principles form the foundation of The Company approach to privacy and will continue to shape the way we build our service offering.',
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: CIColors.secondaryColor,
      ),
    );
  }

  Widget _bodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: CIColors.textColor,
        height: 1.6,
      ),
    );
  }

  Widget _numberedText(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number.',
              style: TextStyle(
                fontSize: 14,
                color: CIColors.textColor,
                height: 1.6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: CIColors.textColor,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: CIColors.textColor,
              height: 1.6,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: CIColors.textColor,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}