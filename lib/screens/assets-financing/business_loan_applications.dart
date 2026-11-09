import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';

import '../../providers/api_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/authed_wrapper.dart';

class BusinessLoanApplicationsScreen extends StatefulWidget {
  const BusinessLoanApplicationsScreen({super.key});

  @override
  State<BusinessLoanApplicationsScreen> createState() =>
      _BusinessLoanApplicationsScreenState();
}

class _BusinessLoanApplicationsScreenState
    extends State<BusinessLoanApplicationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  List<dynamic> _applications = [];

  Future<void> _fetchApplications() async {
    try {
      final apiProvider = Provider.of<APIProvider>(context, listen: false);
      final response = await ApiService.get('business/loan/applications',
          token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          if (response['error'] == 'unauthorized') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              forceLogout(context, mounted);
            });
            return;
          }
        } else {
          setState(() => _applications = response['applications'] ?? []);
        }
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _handleRefresh() async => _fetchApplications();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchApplications());
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'application accepted':
        return const Color(0xFF2e7d32);
      case 'fee table accepted':
        return CIColors.secondaryColor;
      case 'pending':
        return const Color(0xFF795548);
      case 'declined':
        return CIColors.errorText;
      default:
        return CIColors.accentColor;
    }
  }

  Color _statusBg(String status) {
    switch (status.toLowerCase()) {
      case 'application accepted':
        return const Color(0xFFe8f5e9);
      case 'fee table accepted':
        return CIColors.softBlueColor;
      case 'pending':
        return const Color(0xFFefebe9);
      case 'declined':
        return CIColors.errorBox;
      default:
        return const Color(0xFFF0F0F0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
     appBar: MainTopBar(scaffoldKey: _scaffoldKey,  title: "Business Loan Applications"),
      child: _isLoading
          ? const LoadingScreen()
          : _applications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.fileCircleXmark,
                          size: 40, color: CIColors.accentColor),
                      const SizedBox(height: 12),
                      const Text('No applications yet',
                          style: TextStyle(color: CIColors.accentColor, fontSize: 15)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 8),
                    // Header row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: CIColors.softBlueColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 24),
                          Expanded(flex: 3, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CIColors.secondaryColor))),
                          Expanded(flex: 3, child: Text('Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CIColors.secondaryColor))),
                          Expanded(flex: 2, child: Text('Has Loan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CIColors.secondaryColor))),
                          Expanded(flex: 3, child: Text('Amount (TZS)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: CIColors.secondaryColor))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    for (int i = 0; i < _applications.length; i++)
                      _AppRow(app: _applications[i], index: i + 1,
                          statusColor: _statusColor(_applications[i]['status'] ?? ''),
                          statusBg: _statusBg(_applications[i]['status'] ?? '')),
                    const SizedBox(height: 20),
                  ],
                ),
    );
  }
}

class _AppRow extends StatelessWidget {
  final Map<String, dynamic> app;
  final int index;
  final Color statusColor;
  final Color statusBg;

  const _AppRow({
    required this.app,
    required this.index,
    required this.statusColor,
    required this.statusBg,
  });

  @override
  Widget build(BuildContext context) {
    final status = app['status'] ?? '-';
    final amount = app['amount']?.toString() ?? '0';
    final hasLoan = app['existing_loan'] ?? 'No';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x1547688b), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: CIColors.softBlueColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(child: Text('$index', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: CIColors.secondaryColor))),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(app['application_date'] ?? '-',
                    style: const TextStyle(fontSize: 13, color: CIColors.textColor)),
              ),
              Expanded(
                child: Text(app['app_code'] ?? '-',
                    style: const TextStyle(fontSize: 13, color: CIColors.textColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 32),
              Expanded(
                child: Text(
                  'TZS ${_formatAmount(amount)}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: CIColors.textColor),
                ),
              ),
              Text(
                hasLoan,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: hasLoan == 'Yes' ? const Color(0xFF2e7d32) : CIColors.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
              ),
              if (app['created_at'] != null)
                Text(app['created_at'] ?? '', style: const TextStyle(fontSize: 11, color: CIColors.accentColor)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    try {
      final n = int.parse(amount.replaceAll(',', ''));
      final s = n.toString();
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return buf.toString();
    } catch (_) {
      return amount;
    }
  }
}