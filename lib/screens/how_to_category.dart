import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/loading_screen.dart';
import '../components/main_top_bar.dart';
import '../config.dart';
import '../constants/colors.dart';
import '../providers/api_provider.dart';
import '../providers/auth_provider.dart';
import '../components/fullscreen_markdown_dialog.dart';
import '../wrappers/authed_wrapper.dart';

class HowToCategoryScreen extends StatefulWidget {
  const HowToCategoryScreen({super.key});

  @override
  State<HowToCategoryScreen> createState() => _HowToCategoryScreenState();
}

class _HowToCategoryScreenState extends State<HowToCategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  bool _isLoading = true;

  final List<dynamic> _tutorials = [];

  @override
  void initState() {
    super.initState();
    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  bool _isInitialized = false;
  String categoryKey = '';
  String? categoryTitle;
  String? categorySubline;
  String gifName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    apiProvider = Provider.of<APIProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_isInitialized) {
      if (categoryKey.isEmpty) {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

        if (args != null && args.containsKey("category-title")) {
          final String catTitle = args["category-title"];
          setState(() {
            categoryTitle = catTitle;
          });
        }
        if (args != null && args.containsKey("category-subline")) {
          final String catsubline = args["category-subline"];
          setState(() {
            categorySubline = catsubline;
          });
        }
        if (args != null && args.containsKey("category-key")) {
          final String catkey = args["category-key"];
          setState(() {
            categoryKey = catkey;
          });
          // fetchCategoryTutorials(context, catkey);
        }
        if (args != null && args.containsKey("gif")) {
          final String gif = args["gif"];
          setState(() {
            gifName = gif;
          });
          // fetchCategoryTutorials(context, catkey);
          _isLoading = false;
        }
      }
      _isInitialized = true;
    }
  }

  // void fetchCategoryTutorials(BuildContext context, String categoryKey) async {
  //   try {
  //     final response = await ApiService.get(
  //         'get-tutorials-by-category&category=$categoryKey',
  //         token: apiProvider.authToken);

  //     if (response != null) {
  //       if (response.containsKey('error')) {
  //         switch (response['error']) {
  //           case "unauthorized":
  //             if (context.mounted) {
  //               forceLogout(context, mounted);
  //             }
  //             return;

  //           default:
  //         }
  //       } else {
  //         _tutorials = response['tutorials'];
  //       }
  //     }
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     //
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  final Map<String, IconData> faIconMap = {
    'loans': FontAwesomeIcons.fileInvoiceDollar,
    'credits': FontAwesomeIcons.sackDollar,
    'profile': FontAwesomeIcons.solidUser,
    // Add other icons you might use
  };

  getDynamicIcon(String iconName) {
    return faIconMap[iconName] ??
        FontAwesomeIcons.solidCircleQuestion; // fallback if not found
  }

  void showTutorialDialog(BuildContext context, String title, String link) {
    showDialog(
      context: context,
      builder: (context) => FullScreenMarkdownDialog(
        title: title,
        markdownUrl: '${AppConfig.webUrl}$link',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return AuthedWrapper(
        scaffoldKey: _scaffoldKey,
        appBar: MainTopBar(
          scaffoldKey: _scaffoldKey,
          title: categoryTitle ?? "Help Center",
        ),
        child: Center(
          child: _isLoading
              ? LoadingScreen()
              : _tutorials.isEmpty
                  ? Image.network('https://cardinformatics.tz/tutor/$gifName',
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                          child: Column(
                        children: [
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                          Text('Loading...')
                        ],
                      ));
                    })
                  // Text('No tutorial content for now')
                  : SizedBox(
                      width: double.infinity,
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidCircleQuestion,
                                    color: CIColors.accentColor,
                                    size: 26,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    categorySubline ??
                                        "Find quick guides and answers \nto help you use the app with ease.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: CIColors.accentColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          ..._tutorials.map((tutorial) {
                            return GestureDetector(
                              onTap: () {
                                showTutorialDialog(context, tutorial['title'],
                                    tutorial['file_path']);
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CIColors.whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Text(
                                  tutorial['title'],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
        ));
  }
}
