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
import '../../wrappers/authed_wrapper.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;
  Map<String, dynamic> _profileData = {};

  Future<void> fetchProfileData() async {
    try {
      final response = await ApiService.get('business/profile',
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
            _profileData = response['profile-data'];
          });
        }
      }
      setState(() {
        _isPageLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again',
            style: TextStyle(color: CIColors.errorColor)),
        backgroundColor: CIColors.errorBox,
      ));
    }
  }

  Future<void> _handleRefresh() async {
    await fetchProfileData();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchProfileData();
    });
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: CIColors.textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
     appBar: MainTopBar(scaffoldKey: _scaffoldKey,  title: "Profile"),
      child: _isPageLoading
          ? const LoadingScreen()
          : _profileData.isEmpty
              ? const Center(child: Text('Profile data unavailable'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // ── Your Profile (personal) ──────────────────────────────
                    if (_profileData['nida_no'] != null)
                      _section(
                        title: 'Your Profile',
                        children: [
                          DetailContainer(
                              label: "NIDA Number",
                              value: _profileData['nida_no']),
                          DetailContainer(
                              label: "Full Name",
                              value: _profileData['full_name']),
                          DetailContainer(
                              label: "Personal TIN Number",
                              value: _profileData['personal_tin_no']),
                          DetailContainer(
                              label: "Gender",
                              value: _profileData['gender']),
                          DetailContainer(
                              label: "Place of Birth",
                              value: _profileData['place_of_birth']),
                          DetailContainer(
                              label: "Marital Status",
                              value: _profileData['marital_status']),
                          DetailContainer(
                              label: "Email",
                              value: _profileData['email']),
                          DetailContainer(
                              label: "Telephone",
                              value: _profileData['phone']),
                        ],
                      ),

                    const SizedBox(height: 10),

                    // ── Your Company Profile ─────────────────────────────────
                    _section(
                      title: 'Your Company Profile',
                      showEdit: true,
                      onEdit: () => Navigator.pushNamed(
                          context, '/business/edit-profile'),
                      children: [
                        DetailContainer(
                            label: "Entity Type",
                            value: _profileData['entity_type']),
                        DetailContainer(
                            label: "Business Registration Number",
                            value: _profileData['business_reg_no']),
                        DetailContainer(
                            label: "Full Business Name",
                            value: _profileData['business_name']),
                        DetailContainer(
                            label: "Business TIN Number",
                            value: _profileData['business_tin_no']),
                        DetailContainer(
                            label: "Business License Number",
                            value: _profileData['business_license_no']),
                        DetailContainer(
                            label: "Business VAT Number",
                            value: _profileData['business_vat_no']),
                        DetailContainer(
                            label: "Business Category",
                            value: _profileData['business_category']),
                        DetailContainer(
                            label: "Business Subcategory",
                            value: _profileData['business_subcategory']),
                        DetailContainer(
                            label: "Description",
                            value: _profileData['description']),
                        DetailContainer(
                            label: "Business Region",
                            value: _profileData['region']),
                        DetailContainer(
                            label: "Business District",
                            value: _profileData['district']),
                        DetailContainer(
                            label: "Business Ward",
                            value: _profileData['ward']),
                        DetailContainer(
                            label: "Business Street",
                            value: _profileData['street']),
                        DetailContainer(
                            label: "Business Street Number",
                            value: _profileData['street_no']),
                        DetailContainer(
                            label: "Building Name",
                            value: _profileData['building_name']),
                        DetailContainer(
                            label: "Business Email",
                            value: _profileData['business_email']),
                        DetailContainer(
                            label: "Business Telephone",
                            value: _profileData['business_phone']),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
    bool showEdit = false,
    VoidCallback? onEdit,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CIColors.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              if (showEdit)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(110, 183, 237, 255),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: const [
                        FaIcon(FontAwesomeIcons.pencil,
                            size: 12, color: CIColors.secondaryColor),
                        SizedBox(width: 6),
                        Text('Edit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: CIColors.secondaryColor)),
                        SizedBox(width: 2),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}