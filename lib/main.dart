import 'package:test_mobile/screens/auth/device_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


import 'constants/colors.dart';
import 'providers/api_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/overlay_controller.dart';
import 'screens/auth/incompatible_versions.dart';
import 'screens/auth/ip_restricted.dart';
import 'screens/auth/onboarding.dart';
import 'screens/enter_passcode.dart';
import 'screens/how_to.dart';
import 'screens/how_to_category.dart';
import 'screens/loans/edit_application.dart';
import 'screens/loans/marketplace_applications.dart';
import 'screens/overlays/app_lock_overlay.dart';
import 'screens/overlays/backdrop_overlay.dart';
import 'screens/overlays/doc_viewer_overlay.dart';
import 'screens/overlays/drawer_overlay.dart';
import 'screens/overlays/business_drawer_overlay.dart';
import 'screens/assets-financing/business_dashboard.dart';
import 'screens/assets-financing/business_profile.dart';
import 'screens/assets-financing/business_terms_and_conditions.dart';
import 'screens/assets-financing/business_privacy_policy.dart';
import 'screens/assets-financing/financing_solutions_request_credit_limit.dart';
import 'screens/assets-financing/financing_solutions_credit_line_applications.dart';
import 'screens/assets-financing/financing_solutions_utilization_request.dart';
import 'screens/assets-financing/financing_solutions_references.dart';
import 'screens/assets-financing/business_loan_new.dart';
import 'screens/assets-financing/business_loan_applications.dart';
import 'screens/overlays/loading_overlay.dart';
import 'screens/overlays/no_internert_overlay.dart';
import 'screens/overlays/notification_overlay.dart';
import 'screens/set_passcode.dart';
import 'screens/loans/fee_tables.dart';
import 'screens/credit-offers/apply_for_credit_offer.dart';
import 'screens/credit-offers/my_applications.dart';
import 'screens/credit-offers/view_application.dart';
import 'screens/credit-offers/view_credit_offer.dart';
import 'screens/credit-offers/marketplace.dart';
import 'screens/loans/employed_application.dart';
import 'screens/loans/my_applications.dart';
import 'screens/loans/select_employment.dart';
import 'screens/loans/self_employed_application.dart';
import 'screens/loans/view_application.dart';
import 'screens/loans/view_fee_table.dart';
import 'screens/profile/change_birthdate.dart';
import 'screens/profile/change_password.dart';
import 'screens/profile/change_security_question.dart';
import 'screens/profile/complete_profile.dart';
import 'screens/profile/edit_profile.dart';
import 'screens/how_to_apply.dart';
import 'screens/auth/account_chooser.dart';
import 'screens/auth/account_verification.dart';
import 'screens/auth/login_business.dart';
import 'screens/auth/register_business.dart';
import 'screens/auth/register_chooser_personal.dart';
import 'screens/auth/register_personal_foreigner.dart';
import 'screens/auth/reset_password.dart';
import 'screens/auth/reset_password_business.dart';
import 'screens/auth/reset_password_business_verification.dart';
import 'screens/auth/reset_password_verification.dart';
import 'screens/auth/set_new_password.dart';
import 'screens/auth/set_new_password_business.dart';
import 'screens/dashboard.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register_personal_tanzanian.dart';
import 'screens/profile/profile.dart';
import 'screens/settings.dart';
import 'services/connectivity_service.dart';
import 'services/inactivity_timer.dart';
import 'services/navigator_service.dart';
import 'services/route_observer.dart';
import 'wrappers/decider_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CIColors.canvasBGColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => APIProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => OverlayProvider()),
      ],
      child: const MainApp(),
    ),
  );
}
class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  late ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final overlayProvider =
          Provider.of<OverlayProvider>(context, listen: false);
      InactivityTimer().onTimeout = () {
        overlayProvider.showAppLockOverlay();
        overlayProvider.isTimeoutLocked = true;
      };
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // If background app state (Screen Lock, User switched apps)
      final controllerProvider =
          Provider.of<OverlayProvider>(context, listen: false);
      if (controllerProvider.inLocableScreen &&
          !controllerProvider.screenPaused &&
          !controllerProvider.isAppLockingPaused) {
        controllerProvider.screenPaused = true;
        InactivityTimer().cancel();
        controllerProvider.showAppLockOverlay();
      }
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
    }
  }

  @override
  Widget build(BuildContext context) {
    final overlayController =
        Provider.of<OverlayProvider>(context, listen: false);

    // final internet = context.watch<InternetProvider>();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primaryColor: CIColors.primaryColor, // Primary color
          scaffoldBackgroundColor: CIColors.canvasBGColor, // Background color
          appBarTheme: AppBarTheme(
            backgroundColor:
                const Color.fromARGB(255, 255, 255, 255), // App bar color
            elevation: 0,
            iconTheme: IconThemeData(color: CIColors.primaryColor),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: CIColors.primaryColor,
            brightness: Brightness.light,
          ).copyWith(
            primary: CIColors.primaryColor,
            onPrimary: CIColors.whiteColor,
            secondary: CIColors.secondaryColor,
            onSecondary: CIColors.whiteColor,
            tertiary: CIColors.amberColor,
            onTertiary: CIColors.primaryColor,
            surface: CIColors.whiteColor,
            onSurface: CIColors.textColor,
            error: CIColors.errorColor,
            onError: CIColors.whiteColor,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              color: CIColors.textColor,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              color: CIColors.textColor,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: CIColors.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent, // Background color
              foregroundColor: CIColors.secondaryColor, // Background color
              padding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
              textStyle: TextStyle(
                fontSize: 16, // Font size
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold, // Font weight
              ),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // rounded corners
            ),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return CIColors.secondaryColor; // checked color
              }
              return Colors.transparent; // unchecked background
            }),
            checkColor:
                WidgetStateProperty.all(Colors.white), // check icon color
            side: const BorderSide(
              color: CIColors.accentColor, // border color when not selected
              width: 2,
            ),
            visualDensity: VisualDensity.compact, // smaller checkboxes
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // tighter tap area
          ),
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hoverColor: CIColors.canvasBGColor,
            ),
          ),
        ),
        navigatorObservers: [
          RouteObserverWithCallback((routeName, routeArgs) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (routeArgs != null && routeArgs['filter'] != null) {
                overlayController.currentRouteFilter =
                    routeArgs['filter'] ?? '';
              } else {
                overlayController.currentRouteFilter = '';
              }
              overlayController.currentRoute = routeName ?? '';
            });
          }),
        ],
        // home: DeciderWrapper(),
        routes: {
          '/': (context) => DeciderWrapper(),
          '/ip-restricted': (context) => IpRestrictedScreen(),
          '/incompatible-version': (context) => IncompatibleVersionScreen(),

          // Auth routes =========================================================
          '/account-chooser': (context) => AccountChooser(),
          '/onboarding': (context) => OnboardingScreen(),
          '/login': (context) => LoginScreen(),
          '/login-business': (context) => LoginBusinessScreen(),

          '/register-chooser-personal': (context) =>
              RegisterChooserPersonalScreen(),
          '/register-personal-tanzanian': (context) =>
              RegisterPersonalTanzanianScreen(),
          '/register-personal-foreigner': (context) =>
              RegisterPersonalForeignerScreen(),
          '/register-business': (context) => RegisterBusinessScreen(),

          '/verify-account': (context) => AccountVerificationScreen(),
          '/verify-device': (context) => DeviceVerificationScreen(),

          '/reset-password': (context) => ResetPasswordScreen(),
          '/reset-password-verification': (context) =>
              ResetPasswordVerificationScreen(),
          '/reset-password-business': (context) =>
              ResetPasswordBusinessScreen(),
          '/reset-password-business-verification': (context) =>
              ResetPasswordBusinessVerificationScreen(),

          '/set-new-password': (context) => SetNewPasswordScreen(),
          '/set-new-password-business': (context) =>
              SetNewPasswordBusinessScreen(),

          '/set-pass-code': (context) => SetPasscodeScreen(),
          '/enter-pass-code': (context) => EnterPasscodeScreen(),

          // Inner routes ========================================================
          '/dashboard': (context) => DashboardScreen(),
          '/business/dashboard': (context) => BusinessDashboardScreen(),
          '/business/profile': (context) => BusinessProfileScreen(),
          '/business/financing/request-credit-limit': (context) => FinancingSolutionsRequestCreditLimitScreen(),
          '/business/financing/credit-line-applications': (context) => FinancingSolutionsCreditLineApplicationsScreen(),
          '/business/financing/utilization-request': (context) => FinancingSolutionsUtilizationRequestScreen(),
          '/business/financing/references': (context) => FinancingSolutionsReferencesScreen(),
          '/business/loan/new': (context) => BusinessLoanNewScreen(),
          '/business/loan/applications': (context) => BusinessLoanApplicationsScreen(),
          '/business/terms-and-conditions': (context) => BusinessTermsAndConditionsScreen(),
          '/business/privacy-policy': (context) => BusinessPrivacyPolicyScreen(),
          '/how-to-apply': (context) => HowToApplyScreen(),
          '/how-to': (context) => HowToScreen(),
          '/how-to-category': (context) => HowToCategoryScreen(),

          // profile
          '/profile': (context) => ProfileScreen(),
          '/complete-profile': (context) => CompleteProfileScreen(),
          '/edit-profile': (context) => EditProfileScreen(),
          '/change-password': (context) => ChangePasswordScreen(),
          '/change-security-question': (context) =>
              ChangeSecurityQuestionScreen(),
          '/change-birthdate': (context) => ChangeBirthdateScreen(),


          // credit offers
          '/marketplace-credit-offers': (context) =>
              MarketplaceCreditOffersScreen(),
          '/view-credit-offer': (context) => ViewCreditOfferScreen(),
          '/apply-for-credit-offer': (context) => ApplyForCreditOfferScreen(),
          '/my-credit-offer-applications': (context) =>
              MyCreditOffersApplicationsScreen(),
          '/view-credit-offer-application': (context) =>
              ViewCreditOfferApplicationScreen(),

          // loans
          '/select-employment-loan-application': (context) =>
              SelectEmploymentScreen(),
          '/apply-for-loan-employed': (context) =>
              EmployedLoanApplicationScreen(),
          '/apply-for-loan-self-employed': (context) =>
              SelfEmployedLoanApplicationScreen(),
          '/my-loan-applications': (context) => MyLoanApplicationsScreen(),
          '/marketplace-loan-applications': (context) =>
              MarketplaceLoanApplicationsScreen(),
          '/view-loan-application': (context) => ViewLoanApplicationScreen(),
          '/edit-loan-application': (context) => EditApplicationScreen(),
          '/fee-tables': (context) => FeeTablesScreen(),
          '/view-fee-table': (context) => ViewFeeTableScreen(),

          '/settings': (context) => SettingsScreen(),
        },
        builder: (context, child) {
          // child is the currently routed to screen
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: const TextScaler.linear(1.0), // LOCK text scale
            ),
            child: StreamBuilder<bool>(
                stream: _connectivityService.connectivityStream,
                initialData: true,
                builder: (context, snapshot) {
                  final isOnline = snapshot.data ?? true;
                  return Stack(
                    children: [
                      child!,
                      // Document viewer overlay
                      DocViewerOverlay(),

                      // Web viewer overlay
                      // WebViewerOverlay(),

                      // Notification Panel
                      NotificationOverlay(),

                      // For blurred backgounds in overlays
                      BackdropOverlay(),

                      // Menu Drawer
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) {
                          return auth.accountType == 'business'
                              ? BusinessDrawerOverlay()
                              : DrawerOverlay();
                        },
                      ),

                      // Loading screen
                      LoadingOverlay(),

                      // No internet screen
                      // if (!internet.hasInternet) NoInternetOverlay(),
                      if (!isOnline)
                        NoInternetOverlay(retryFunction: () {
                          _connectivityService.checkInternetConnection();
                        }),

                      // Applock screen
                      AppLockOverlay(),
                    ],
                  );
                }),
          );
        },
      ),
    );
  }
}