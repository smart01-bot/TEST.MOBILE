import 'dart:convert';
import 'dart:io';

import 'package:test_mobile/components/account_deletion_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;

import '../../components/detail_container.dart';
import '../../components/input_fields/ci_file.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/overlay_controller.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isPageLoading = true;
  bool _isRemovingProfileImage = false;
  bool _isUploadImageLoading = false;
  Map<String, dynamic> _profileData = {};

  final bool _showUploadProfileImage = false;
  Map<String, String>? _encodedProfileImage;
  String _profileImageError = "";

  String? _profilePicFileName;
  void _setProfilePicFilename(String value) => setState(() {
        _profilePicFileName = value;
      });

  void _setProfileImageEncoded(Map<String, String> value) => setState(() {
        _encodedProfileImage = value;
      });

  void _setProfileImageError(String value) => setState(() {
        _profileImageError = value;
      });

  Future<void> fetchProfileData() async {
    try {
      final response =
          await ApiService.get('profile', token: apiProvider.authToken);

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
      // Request not sent
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

  void removeProfileImage(context) async {
    setState(() {
      _isRemovingProfileImage = true;
    });
    try {
      final response = await ApiService.get('remove-profile-image',
          token: apiProvider.authToken);

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "failed":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Failed to remove profile image',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              return;

            default:
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Profile Image Removed',
              style: TextStyle(
                color: CIColors.successColor,
              ),
            ),
            backgroundColor: CIColors.successBox,
          ));
          if (response.containsKey('success')) {
            setState(() {
              _profileData['image'] = response['success'];
            });
          }
        }
      }
      setState(() {
        _isRemovingProfileImage = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occured. Please try again later',
            style: TextStyle(
              color: CIColors.errorColor,
            )),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        _isRemovingProfileImage = false;
      });
    }
  }

  void updateProfileImage(context, [bool shouldPop = true]) async {
    setState(() {
      _isUploadImageLoading = true;
    });
    try {
      final response = await ApiService.post(
        'change-profile-image',
        token: apiProvider.authToken,
        data: {
          'image': _encodedProfileImage!['data'],
          'ext': _encodedProfileImage!['ext'],
        },
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            case "failed":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to upload profile image',
                    style: TextStyle(
                      color: CIColors.errorColor,
                    )),
                backgroundColor: CIColors.errorBox,
              ));
              return;

            default:
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Profile Image Updated',
              style: TextStyle(
                color: CIColors.successColor,
              ),
            ),
            backgroundColor: CIColors.successBox,
          ));
          if (response.containsKey('success')) {
            setState(() {
              _profileData['image'] = response['success'];
            });
            authProvider.updateProfileImage(response['success']);
          }
          if (shouldPop) {
            setState(() {
              _profilePicFileName = null;
              _encodedProfileImage = null;
            });
            Navigator.of(context).pop();
          }
        }
      }
      setState(() {
        _isUploadImageLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occured. Please try again later',
            style: TextStyle(
              color: CIColors.errorColor,
            )),
        backgroundColor: CIColors.errorBox,
      ));
      setState(() {
        _isUploadImageLoading = false;
      });
    }
  }

  // camera
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(context) async {
    final overlayProvider =
        Provider.of<OverlayProvider>(context, listen: false);

    overlayProvider.pauseAppLocking();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File toFile = File(pickedFile.path);
      List<int> fileBytes = await toFile.readAsBytes();
      String base64File = base64Encode(fileBytes);
      String extension = p.extension(pickedFile.path);

      setState(() {
        _encodedProfileImage = {
          "data": base64File,
          "ext": extension,
        };
      });
      overlayProvider.resumeAppLocking();

      updateProfileImage(context, false);
    }
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

  void _showImageUploadModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setLocalState) {
          return AlertDialog(
            title: Text(
              'Upload New Profile Image',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: CIColors.textColor,
              ),
            ),
            content: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Section for uploading profile image
                  CIFile(
                    engLabel: "Profile Image",
                    swLabel: "Picha ya Profaili",
                    setFileEncoded: _setProfileImageEncoded,
                    fileName: _profilePicFileName,
                    setFileName: _setProfilePicFilename,
                    haveError: (_profileImageError != ""),
                    setError: (String value) {
                      _setProfileImageError(value);
                      setLocalState(() {});
                    },
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
                    allowedExtensionsError:
                        'Only JPG, JPEG and PNG files are allowed',
                  ),

                  if (_profileImageError != "")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileImageError,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: CIColors.errorText,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal
                },
              ),
              ElevatedButton(
                onPressed: _isUploadImageLoading
                    ? null
                    : () {
                        if (_encodedProfileImage == null ||
                            _encodedProfileImage!.isEmpty) {
                          _setProfileImageError(
                              'Please select a file to upload');
                          setLocalState(() {});
                          return;
                        }
                        _setProfileImageError('');
                        updateProfileImage(context);
                      },
                style: mainButtonStyle,
                child: _isUploadImageLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Upload',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
              )
            ],
          );
        });
      },
    );
  }

  Future<void> _handleRefresh() async {
    await fetchProfileData();
  }

  void showAccountDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AccountDeletionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      handleRefresh: _handleRefresh,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Profile",
      ),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen()
            : (_profileData.isEmpty
                ? Text('Profile data unavailable')
                : Column(
                    spacing: 0,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          // color: CIColors.whiteColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                _profileData['image'],
                                width: 150,
                                height: 150,
                                fit: BoxFit
                                    .cover, // Controls how the image fits the box (e.g., cover, contain, fill)
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 208, 221, 235),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _pickImage(context);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color:
                                            Color.fromARGB(141, 204, 226, 248),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.camera,
                                          size: 14,
                                          color: CIColors.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _encodedProfileImage = null;
                                        _profileImageError = "";
                                      });
                                      _showImageUploadModal(context);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color:
                                            Color.fromARGB(141, 168, 236, 211),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.upload,
                                          size: 14,
                                          color: const Color.fromARGB(
                                              255, 71, 139, 105),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      removeProfileImage(context);
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color:
                                            Color.fromARGB(102, 248, 204, 204),
                                      ),
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.solidTrashCan,
                                          size: 14,
                                          color: const Color.fromARGB(
                                              255, 200, 85, 85),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    'Profile Details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/edit-profile');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            110, 183, 237, 255),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      spacing: 6,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.pencil,
                                          size: 12,
                                          color: CIColors.secondaryColor,
                                        ),
                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: CIColors.secondaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            DetailContainer(
                              label: "Full Name",
                              value: _profileData['full_name'],
                            ),
                            DetailContainer(
                              label: "NIDA Number",
                              value: _profileData['nida'],
                            ),
                            DetailContainer(
                              label: "Gender",
                              value: _profileData['gender'],
                            ),
                            DetailContainer(
                              label: "Date of Birth",
                              value: _profileData['dob'],
                            ),
                            DetailContainer(
                              label: "Citizenship",
                              value: _profileData['citizenship'],
                            ),
                            DetailContainer(
                              label: "Marital Status",
                              value: _profileData['marital_status'],
                            ),
                            DetailContainer(
                              label: "Email Address",
                              value: _profileData['email'],
                            ),
                            DetailContainer(
                              label: "Phone Number",
                              value: _profileData['phone'],
                            ),
                            DetailContainer(
                              label: "Region",
                              value: _profileData['region'],
                            ),
                            DetailContainer(
                              label: "District",
                              value: _profileData['district'],
                            ),
                            DetailContainer(
                              label: "Ward",
                              value: _profileData['ward'],
                            ),
                            DetailContainer(
                              label: "Street Name",
                              value: _profileData['street'],
                            ),
                            DetailContainer(
                              label: "Street Number",
                              value: _profileData['street_no'],
                            ),
                            DetailContainer(
                              label: "Postal Address",
                              value: _profileData['address'],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showAccountDeletionDialog(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CIColors.whiteColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              FaIcon(
                                FontAwesomeIcons.solidTrashCan,
                                color: CIColors.errorText,
                                size: 20,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  "Delete My Account",
                                  style: TextStyle(
                                    color: CIColors.errorText,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.caretRight,
                                color: CIColors.errorText,
                                size: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
      ),
    );
  }
}
