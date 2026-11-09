import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../wrappers/authed_wrapper.dart';

class FinancingSolutionsCreditLineApplicationsScreen extends StatefulWidget {
  const FinancingSolutionsCreditLineApplicationsScreen({super.key});

  @override
  State<FinancingSolutionsCreditLineApplicationsScreen> createState() =>
      _FinancingSolutionsCreditLineApplicationsScreenState();
}

class _FinancingSolutionsCreditLineApplicationsScreenState
    extends State<FinancingSolutionsCreditLineApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(scaffoldKey: _scaffoldKey, title: "Credit Line Applications"),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _OptionTile(
            icon: FontAwesomeIcons.moneyBill,
            title: 'LPO/Contract Applications',
            onTap: () => Navigator.pushNamed(context, '/business/financing/lpo-applications'),
          ),
          const SizedBox(height: 12),
          _OptionTile(
            icon: FontAwesomeIcons.fileInvoice,
            title: 'Invoice Discounting Applications',
            onTap: () => Navigator.pushNamed(context, '/business/financing/invoice-applications'),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x2e47688b), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFFe8f2fb), borderRadius: BorderRadius.circular(10)),
              child: Center(child: FaIcon(icon, size: 18, color: const Color(0xFF47688b))),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: CIColors.textColor))),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: CIColors.accentColor),
          ],
        ),
      ),
    );
  }
}