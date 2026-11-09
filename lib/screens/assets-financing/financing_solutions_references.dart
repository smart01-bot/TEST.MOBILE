import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/detail_container.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/api_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/authed_wrapper.dart';

class FinancingSolutionsReferencesScreen extends StatefulWidget {
  const FinancingSolutionsReferencesScreen({super.key});

  @override
  State<FinancingSolutionsReferencesScreen> createState() =>
      _FinancingSolutionsReferencesScreenState();
}

class _FinancingSolutionsReferencesScreenState
    extends State<FinancingSolutionsReferencesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  Map<String, dynamic> _data = {};

  Future<void> _fetchData() async {
    try {
      final apiProvider = Provider.of<APIProvider>(context, listen: false);
      final response = await ApiService.get('business/references',
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
          setState(() => _data = response);
        }
      }
    } catch (_) {}
    setState(() => _isLoading = false);
  }

  Future<void> _handleRefresh() async => _fetchData();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
     appBar: MainTopBar(scaffoldKey: _scaffoldKey, title: "References"),
      child: _isLoading
          ? const LoadingScreen()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ── Company Information ──────────────────────────────────
                _section(
                  title: 'Company Informations',
                  children: [
                    DetailContainer(label: 'Business Name', value: _data['business_name']),
                    DetailContainer(label: 'Business Registration Number', value: _data['business_license_no']),
                    DetailContainer(label: 'Nature of Business', value: _data['business_nature']),
                    DetailContainer(label: 'Region', value: _data['business_region']),
                    DetailContainer(label: 'Business Registration Number', value: _data['business_reg_no']),
                    DetailContainer(label: 'Business TIN Number', value: _data['business_tin_no']),
                    DetailContainer(label: 'District', value: _data['business_district']),
                    DetailContainer(label: 'Ward', value: _data['business_ward']),
                    DetailContainer(label: 'Street Name', value: _data['business_street_name']),
                    DetailContainer(label: 'Street Number', value: _data['business_street_number']),
                    DetailContainer(label: 'Building Name', value: _data['business_building_name']),
                    DetailContainer(label: 'Business Email', value: _data['business_email']),
                    DetailContainer(label: 'Building Name', value: _data['business_phone']),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Utilization Details ──────────────────────────────────
                _section(
                  title: 'Utilization Details',
                  children: [
                    DetailContainer(label: 'Amount Requested', value: _data['amount_requested']),
                    DetailContainer(label: 'Purpose', value: _data['purpose']),
                    DetailContainer(label: 'Expected Date of Use', value: _data['expected_date_of_use']),
                  ],
                ),

                const SizedBox(height: 10),

                // ── Attached Documents ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 12),
                        child: Text('Attached Documents',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      if ((_data['documents'] as List?)?.isEmpty ?? true)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('No documents found',
                              style: TextStyle(color: CIColors.accentColor, fontSize: 14)),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final doc in (_data['documents'] as List))
                              GestureDetector(
                                onTap: () {
                                  // open doc viewer
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFe8f5ef),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: const Color(0xFFb2d8c8), width: 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const FaIcon(FontAwesomeIcons.filePdf,
                                          size: 12,
                                          color: Color(0xFF3d7a5a)),
                                      const SizedBox(width: 6),
                                      Text(
                                        _truncate(doc.toString()),
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF3d7a5a),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
    );
  }

  String _truncate(String name) {
    if (name.length > 22) {
      return '${name.substring(0, 15)}...${name.substring(name.length - 7)}';
    }
    return name;
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...children,
        ],
      ),
    );
  }
}