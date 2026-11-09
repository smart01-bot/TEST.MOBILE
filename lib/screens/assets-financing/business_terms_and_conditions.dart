import 'package:flutter/material.dart';

import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../wrappers/authed_wrapper.dart';

class BusinessTermsAndConditionsScreen extends StatefulWidget {
  const BusinessTermsAndConditionsScreen({super.key});

  @override
  State<BusinessTermsAndConditionsScreen> createState() =>
      _BusinessTermsAndConditionsScreenState();
}

class _BusinessTermsAndConditionsScreenState
    extends State<BusinessTermsAndConditionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        
        title: "Terms and Conditions",
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
              'Terms and Condition',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: CIColors.textColor,
              ),
            ),
            SizedBox(height: 16),
            _bodyText(
              'This document contains the Terms of Reference ("Terms") for C.A.R.D. Informatics Ltd. ("The Company") online electronic system accessed using established portals, such as the DiondBongo access page, or its successor(s). You should read these Terms in their entirety and acknowledge that by creating an account or accessing or attempting to access systems and services available online through DiondBongo, or its successor(s), that you have read, understand, and agree to comply with these Terms in order to access and use any or all of these systems. The Terms apply to every individual and user, including accredited representatives acting on behalf of a business, corporation, limited partnership, limited liability company, or other legal entity, and any employees of such entities, who accesses, uses, or creates an online account in The Company\'s electronic system and information technology resource, which may include the network, application, managed access developer portal, external drives that upload, process, store, receive or transmit information.',
            ),
            SizedBox(height: 12),
            _bodyText(
              'The Company\'s electronic system is an online, account-based system that allows users to submit requests for certain services, as well as view certain applications, petitions, and requests; receive electronic notification of notices and decisions; receive real-time status updates on pending applications; and use defined roles to access certain technical specifications within designated interface portals. The Company\'s electronic system allows individuals, financial institutions, accredited representatives, and other authorized users to conveniently and securely set up and manage online accounts; electronically submit certain applications, registrations, petitions or requests, and supporting documents; receive and respond to notices, requests for evidence, and decisions electronically; and where necessary, pay associated fees. Periodically, The Company may release additional functionality that will allow individuals, financial institutions, and accredited representatives to perform additional functions online, which may include paying service and processing fees, filing motions to reopen or reconsider, submitting content inquiries, engaging in technical integration capabilities with programming interfaces, exposed data, and content management systems, paying administrative appeal fees, and requesting fee waivers online. These Terms require that you use this system only to perform lawful -related functions. The Terms detail the laws, policies, and procedures you must abide by when using the system to submit any application, petition, registration, or request to The Company, submit technical programming interface data, access exposed data content, or communicate with Regulatory Authorities and/or The Company. The Terms also detail what actions are prohibited when using the system and the penalties for misuse.',
            ),
            SizedBox(height: 12),
            _bodyText(
              'By accessing or using the system, you are legally bound by the document Terms stated herein. If you do not agree with any provision of these Terms then you may not access The Company\'s online electronic system for any purpose including, but not limited to, creating an account, filing an application, petition or request, registration, checking an application status online; and requesting assistance with access, use or technical issues associated with The Company\'s online electronic system, engaging in technical integration with: programming interfaces, exposed data, and content management systems. Any violation of these Terms may result in immediate suspension or termination of any access provided to The Company\'s online electronic system and may result in administrative or civil actions as allowed by law, or criminal prosecution.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Governing Laws'),
            SizedBox(height: 8),
            _bodyText(
              'These Terms are governed and construed in accordance with the laws of The United Republic of Tanzania ("URT"). Any failure by The Company, or any other relevant authority, to enforce any provision in these Terms shall not be considered a waiver of any privileges, immunities, or profits provided under applicable URT law. These Terms do not create any right or benefit, substantive or procedural, for any individual or entity. If any provision of these Terms is held to be invalid or unenforceable by a URT court of law, the remaining provisions of these Terms shall be severable from the invalid or unenforceable provision and will remain in effect. To the extent permitted by law, The Company disclaims all warranties whether expressed or implied, including the implied warranties of merchantability, fitness, for a particular purpose, title, and non-infringement. Accordingly, our liability shall be limited to the fullest extent permitted by applicable law, and under no circumstance will we be liable to participants or others for any lost profits, revenues, information, or data, or consequential, special, indirect, exemplary, punitive, or incidental damages arising out of or related to participation and use of the services accessed online using DiondBongo, or its successors.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Servicemarks and Logos'),
            SizedBox(height: 8),
            _bodyText(
              'The Company is the Servicemark owner and the authorized owner of the CARD Informatics name and logo, and owner of the name(s) and logo(s) of the various systems accessible from this portal. Users may not use these Servicemarked items without the prior written consent from The Company.',
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
            _sectionTitle('Rules of Behavior'),
            SizedBox(height: 8),
            _bodyText(
              'The Rules of Behavior ("RoB") noted below are consistent with the purpose and use of The Company\'s online electronic system. I understand that any access granted to me by The Company for use of the online electronic system, is based on my need to perform specific online tasks and activities related to the managed technical access to the portal, or other specifically permitted access, preparation and filing of requests for services (such as, applications, petitions or requests, and registrations).',
            ),
            SizedBox(height: 12),
            _bodyText('I agree to the following:'),
            SizedBox(height: 8),
            _numberedText(1, 'I will only use The Company\'s online electronic system as designed and to perform authorized Company-related functions.'),
            _numberedText(2, 'I will not create an online account unless I am at least 18 years of age.'),
            _numberedText(3, 'I will only use The Company\'s online electronic system for related communications, notices, responses, or correspondence in relation to any application, petition or request, registration, access to the portal; or for authorized review and configuration of technical programming interface products.'),
            _numberedText(4, 'I will abide by all applicable laws, rules, and regulations that pertain to the submission of an application, petition, registration, petition or request to The Company.'),
            _numberedText(5, 'I will submit any application under penalty of perjury and with a certification that I understand the contents of the filing and supporting documents submitted with any filing.'),
            _numberedText(6, 'I will abide by all applicable laws, rules, and regulations related to the access and use of any related computer system, including The Company\'s online electronic system, designated for the filing, adjudication, communication on any application, petition or requests, registration; or for authorized review and configuration of technical programming interface products.'),
            _numberedText(7, 'I understand that BOT or any other applicable Government Regulatory Authority reserves the right to monitor usage and activity on The Company\'s online electronic system.'),
            _numberedText(8, 'I understand that I must create, provide, and maintain the security of my unique online account, account password, authentication codes, other log-in and account creation features and requirements, as well as the answers to security questions for password reset.'),
            _numberedText(9, 'I understand that to access or use The Company\'s online electronic system, I must use valid credentials to access the account I am authorized to access by The Company.'),
            SizedBox(height: 20),
            _sectionTitle('Online Account Holders'),
            SizedBox(height: 8),
            _bodyText('If I am an individual seeking to file an application, petition or request, or registration through The Company\'s online electronic system, I agree that I will not:'),
            SizedBox(height: 8),
            _numberedText(1, 'Access any user accounts, data stores, systems, applications, form types, backend data, or technical programming interfaces to which I have not been granted access and that are not expressly authorized for access, or create any online accounts if I am under the age of 18.'),
            _numberedText(2, 'Use anyone else\'s online account, secure account password, authentication credentials or answers to security questions for password reset to access or use The Company\'s online electronic system.'),
            _numberedText(3, 'Share my email address, username, secure account password, online access code, or any other user identification or authentication credential used to access The Company\'s online electronic system with anyone else for their own use.'),
            _numberedText(4, 'Authorize another person to log into, access, or use my online electronic system account.'),
            _numberedText(5, 'Allow or permit another person or legal entity to electronically sign any application, petition or request, or registration for me.'),
            SizedBox(height: 20),
            _sectionTitle('Incident Reporting'),
            SizedBox(height: 8),
            _bodyText(
              'I will cooperate willingly with The Company and any applicable Government Regulatory Authorities on any investigation of any privacy, security, or cyber incidents and, if directed by any of these, I will voluntarily relinquish all access to, and use of, The Company\'s online electronic system during the period of investigation and/or law enforcement action. If my online account has been compromised in any way, I will notify The Company immediately through its designated customer-support channel.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Penalties for Misuse'),
            SizedBox(height: 8),
            _bodyText(
              'I understand that any violation of these Terms may subject me to administrative, civil, or criminal actions as allowed by law. I agree that I may be held accountable for my actions or inactions that result in any breach of The Company online electronic system. This includes the possibility of immediate suspension or termination of my access to The Company online electronic system.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Termination of Access'),
            SizedBox(height: 8),
            _bodyText(
              'The Company, at its sole discretion, may suspend or terminate account access and use of The Company online electronic system immediately and without prior notice. The Company also will suspend or terminate service if The Company determines there has been a privacy or security breach, misuse of the system, or breach of the Terms by any user.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Links to Other Web Sites'),
            SizedBox(height: 8),
            _bodyText(
              'The Company\'s online electronic system may contain links to third party web sites or services that are not owned or controlled by The Company. The Company has no control over, and assumes no responsibility for the content, privacy policies, or practices of any third party web sites or services.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Changes to these Terms'),
            SizedBox(height: 8),
            _bodyText(
              'The Company reserves the right, at its sole discretion, to modify or replace these Terms at any time. By continuing to access or use The Company\'s online electronic system after updated revisions become effective, you agree to be bound by the revised Terms.',
            ),
            SizedBox(height: 20),
            _sectionTitle('Acknowledgment'),
            SizedBox(height: 8),
            _bodyText(
              'By using this application, you acknowledge that you have read these Terms which you understand and will comply with them. You agree to abide by the Terms and understand that if you do not accept the Terms, you are not eligible to access or use The Company online electronic system.',
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