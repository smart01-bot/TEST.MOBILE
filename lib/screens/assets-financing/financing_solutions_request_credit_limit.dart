import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../wrappers/authed_wrapper.dart';

class FinancingSolutionsRequestCreditLimitScreen extends StatefulWidget {
  const FinancingSolutionsRequestCreditLimitScreen({super.key});

  @override
  State<FinancingSolutionsRequestCreditLimitScreen> createState() =>
      _FinancingSolutionsRequestCreditLimitScreenState();
}

class _FinancingSolutionsRequestCreditLimitScreenState
    extends State<FinancingSolutionsRequestCreditLimitScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(scaffoldKey: _scaffoldKey, title: "Request Credit Limit"),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _OptionTile(
            icon: FontAwesomeIcons.moneyBill,
            title: 'LPO/Contract Financing',
            subtitle: 'Ufadhili wa Mkataba',
            onTap: () => Navigator.pushNamed(context, '/business/financing/lpo-contract'),
          ),
          const SizedBox(height: 12),
          _OptionTile(
            icon: FontAwesomeIcons.fileInvoice,
            title: 'Invoice Discounting',
            subtitle: 'Ufadhili wa Lipa za Ankara',
            onTap: () => Navigator.pushNamed(context, '/business/financing/invoice-discounting'),
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.title, this.subtitle, required this.onTap});

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: CIColors.textColor)),
                  if (subtitle != null)
                    Text(subtitle!, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: CIColors.secondaryColor)),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: CIColors.accentColor),
          ],
        ),
      ),
    );
  }
}