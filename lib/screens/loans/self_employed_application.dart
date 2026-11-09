// ignore_for_file: prefer_final_fields

import 'package:test_mobile/constants/water_supply_authorities.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/input_fields/ci_long_field.dart';
import '../../components/main_top_bar.dart';
import '../../constants/allowed_currecies.dart';
import '../../constants/loan_facilities.dart';
import '../../components/input_fields/ci_date_picker.dart';
import '../../components/input_fields/ci_email_field.dart';
import '../../components/input_fields/ci_field.dart';
import '../../components/input_fields/ci_file.dart';
import '../../components/input_fields/ci_phone_field.dart';
import '../../components/input_fields/ci_radio_field.dart';
import '../../components/input_fields/ci_select_field.dart';
import '../../components/loading_screen.dart';
import '../../constants/colors.dart';
import '../../constants/regions_and_districts.dart';
import '../../helpers/force_logout.dart';
import '../../providers/overlay_controller.dart';
import '../../services/api_service.dart';
import '../../providers/api_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/button_style_main.dart';
import '../../wrappers/authed_wrapper.dart';

class SelfEmployedLoanApplicationScreen extends StatefulWidget {
  const SelfEmployedLoanApplicationScreen({super.key});

  @override
  State<SelfEmployedLoanApplicationScreen> createState() =>
      _SelfEmployedLoanApplicationScreenState();
}

class _SelfEmployedLoanApplicationScreenState
    extends State<SelfEmployedLoanApplicationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AuthProvider authProvider;
  late APIProvider apiProvider;

  // to controll scroll on next and back
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 200), // Duration for animation
      curve: Curves.ease, // Animation curve
    );
  }

  int _currPage = 1;
  int _pagesCount = 10;

  bool _isPageLoading = true;
  bool _isLoading = false;
  bool _alreadyApplied = false;
  bool _isRemovingProfileImage = false;
  bool _isUploadImageLoading = false;
  Map<String, dynamic> _creditOffer = {};

  Map<String, dynamic> _profileData = {};

  Map<String, String> _banks = {};

  int _totalAnnualSalary = 0;

  // INPUT FIELDS
  final _fullNameController = TextEditingController();
  String _fullNameError = "";
  // ==============================
  final _maritalStatusController = TextEditingController();
  // ==============================
  final _dobController = TextEditingController();
  String _dobError = "";
  // ==============================
  final _genderController = TextEditingController();
  String _genderError = "";
  // ==============================
  final _citizenshipController = TextEditingController();
  String _citizenshipError = "";
  // ==============================
  final _creditLimitController = TextEditingController();
  String _creditLimitError = "";
  // ==============================
  final _previousEmployerController = TextEditingController();
  String _previousEmployerError = "";
  // ==============================
  final _loanAmountController = TextEditingController();
  String _loanAmountError = "";
  // ==============================
  final _employmentController = TextEditingController();
  String _employmentType = "";
  String _employmentError = "";
  void _setEmploymentType(String type) {
    setState(() {
      _employmentType = type;
    });
  }

  // ==============================
  // ==============================
  final _bizLicenseController = TextEditingController();
  String _bizLicenseError = "";
  // ==============================
  final _bizNameController = TextEditingController();
  String _bizNameError = "";
  // ==============================
  final _loanFacilityController = TextEditingController();
  String _loanFacilityError = "";

  String? _selectedLoanFacility;
  String? _selectedCurrency;

  void _selectLoanFacility(String value) => setState(() {
        _selectedLoanFacility = value;
      });

  void _selectCurrency(String value) => setState(() {
        _selectedCurrency = value;
      });
  // ==============================
  final _loanCurrencyController = TextEditingController();
  String _loanCurrencyError = "";
  // ==============================

  String _loanPurposeError = "";

  final _businessNameController = TextEditingController();
  final _businessRegionController = TextEditingController();
  final _businessDistrictController = TextEditingController();
  final _businessWardController = TextEditingController();
  final _businessStreetNameController = TextEditingController();
  final _businessStreetNumberController = TextEditingController();
  final _businessBuildingController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _bizTypeC = TextEditingController();

  String? _selectedRegion;
  String? _selectedDistrict;

  String _regionFieldError = "";
  String _districtFieldError = "";
  String _wardFieldError = "";
  String _streetNameFieldError = "";
  String _streetNumberFieldError = "";
  String _buildingFieldError = "";
  String _phoneFieldError = "";
  String _bizTypeError = "";

  void _selectRegion(String value) => setState(() {
        _selectedDistrict = null;
        _selectedRegion = value;
      });

  void _selectDistrict(String value) => setState(() {
        _selectedDistrict = value;
      });
  // ==============================
  String _prevEmployer = "";
  void _setPrevEmployer(String val) {
    setState(() {
      _prevEmployer = val;
    });
  }

  String _prevEmployerError = "";
  // ==============================
  String _existingLoanOne = "";
  void _setExistingLoanOne(String val) {
    setState(() {
      _existingLoanOne = val;
    });
  }

  String _existingLoanOneError = "";
  // ==============================
  String _existingLoanTwo = "";
  void _setExistingLoanTwo(String val) {
    setState(() {
      _existingLoanTwo = val;
    });
  }

  String _existingLoanTwoError = "";
  // ==============================
  String _existingLoanThree = "";
  void _setExistingLoanThree(String val) {
    setState(() {
      _existingLoanThree = val;
    });
  }

  String _existingLoanThreeError = "";
  // ==============================
  DateTime? _employedSinceDate;

  void _setEmployedSinceDate(DateTime picked) => setState(() {
        _employedSinceDate = picked;
      });
  String _employedSinceError = "";
  // ==============================
  DateTime? _previousEmployedSinceDate;
  DateTime? _previousEmployedToDate;
  void _setPreviousEmployedSinceDate(DateTime picked) => setState(() {
        _previousEmployedSinceDate = picked;
        _previousEmployedToDate = null;
      });
  void _setPreviousEmployedToDate(DateTime picked) => setState(() {
        _previousEmployedToDate = picked;
      });
  String _previousEmployedSinceError = "";
  String _previousEmployedToError = "";
  // ==============================
  final _loanPurposeC = TextEditingController();

  // ==============================
  final _employerController = TextEditingController();
  String _employerError = "";
  // ==============================
  final _designationController = TextEditingController();
  String _designationError = "";
  // ==============================
  final _previousDesignationController = TextEditingController();
  String _previousDesignationError = "";
  // ==============================
  final _hrController = TextEditingController();
  String _hrError = "";
  // ==============================
  final _hrEmailController = TextEditingController();
  String _hrEmailError = "";
  // ==============================
  final _hrPhoneController = TextEditingController();
  String _hrPhoneError = "";
  // ==============================
  final _prevLoanBalanceOneController = TextEditingController();
  String _prevLoanBalanceOneError = "";
  // ==============================
  final _prevLoanBalanceTwoController = TextEditingController();
  String _prevLoanBalanceTwoError = "";
  // ==============================
  final _prevLoanBalanceThreeController = TextEditingController();
  String _prevLoanBalanceThreeError = "";
  // ==============================
  // EXISTING LOAN ISSUING DATES
  DateTime? _issuingDateOne;
  String _issuingDateOneError = "";
  void _setIssuingDateOne(DateTime picked) => setState(() { _issuingDateOne = picked; _issuingDateOneError = ""; });
  DateTime? _issuingDateTwo;
  String _issuingDateTwoError = "";
  void _setIssuingDateTwo(DateTime picked) => setState(() { _issuingDateTwo = picked; _issuingDateTwoError = ""; });
  DateTime? _issuingDateThree;
  String _issuingDateThreeError = "";
  void _setIssuingDateThree(DateTime picked) => setState(() { _issuingDateThree = picked; _issuingDateThreeError = ""; });
  // ==============================
  // EXISTING LOAN CURRENCIES
  final _existingLoanCurrencyOneController = TextEditingController();
  String? _existingLoanCurrencyOne;
  String _existingLoanCurrencyOneError = "";
  void _selectExistingLoanCurrencyOne(String v) => setState(() { _existingLoanCurrencyOne = v; _existingLoanCurrencyOneError = ""; });
  final _existingLoanCurrencyTwoController = TextEditingController();
  String? _existingLoanCurrencyTwo;
  String _existingLoanCurrencyTwoError = "";
  void _selectExistingLoanCurrencyTwo(String v) => setState(() { _existingLoanCurrencyTwo = v; _existingLoanCurrencyTwoError = ""; });
  final _existingLoanCurrencyThreeController = TextEditingController();
  String? _existingLoanCurrencyThree;
  String _existingLoanCurrencyThreeError = "";
  void _selectExistingLoanCurrencyThree(String v) => setState(() { _existingLoanCurrencyThree = v; _existingLoanCurrencyThreeError = ""; });
  // ==============================
  // EXISTING LOAN CREDITED AMOUNTS
  final _creditedAmountOneController = TextEditingController();
  String _creditedAmountOneError = "";
  final _creditedAmountTwoController = TextEditingController();
  String _creditedAmountTwoError = "";
  final _creditedAmountThreeController = TextEditingController();
  String _creditedAmountThreeError = "";
  // ==============================
  // EXISTING LOAN FACILITY TYPES
  String _loanFacilityTypeOne = "";
  String _loanFacilityTypeOneError = "";
  void _setLoanFacilityTypeOne(String v) => setState(() { _loanFacilityTypeOne = v; _loanFacilityTypeOneError = ""; });
  String _loanFacilityTypeTwo = "";
  String _loanFacilityTypeTwoError = "";
  void _setLoanFacilityTypeTwo(String v) => setState(() { _loanFacilityTypeTwo = v; _loanFacilityTypeTwoError = ""; });
  String _loanFacilityTypeThree = "";
  String _loanFacilityTypeThreeError = "";
  void _setLoanFacilityTypeThree(String v) => setState(() { _loanFacilityTypeThree = v; _loanFacilityTypeThreeError = ""; });
  // ==============================

  final _institutionOneController = TextEditingController();
  String? _institutionOne;
  void _selectInstitutionOne(String value) => setState(() {
        _institutionOne = value;
      });
  String _institutionOneError = "";
  // ==============================

  final _institutionTwoController = TextEditingController();
  String? _institutionTwo;
  void _selectInstitutionTwo(String value) => setState(() {
        _institutionTwo = value;
      });
  String _institutionTwoError = "";
  // ==============================

  final _institutionThreeController = TextEditingController();
  String? _institutionThree;
  void _selectInstitutionThree(String value) => setState(() {
        _institutionThree = value;
      });
  String _institutionThreeError = "";
  // ==============================

  final _loanTypeOneController = TextEditingController();
  String? _loanTypeOne;
  void _selectLoanTypeOne(String value) => setState(() { _loanTypeOne = value; _loanTypeOneError = ""; });
  String _loanTypeOneError = "";
  final _otherFacilityOneController = TextEditingController();
  // ==============================

  final _loanTypeTwoController = TextEditingController();
  String? _loanTypeTwo;
  void _selectLoanTypeTwo(String value) => setState(() { _loanTypeTwo = value; _loanTypeTwoError = ""; });
  String _loanTypeTwoError = "";
  final _otherFacilityTwoController = TextEditingController();
  // ==============================

  final _loanTypeThreeController = TextEditingController();
  String? _loanTypeThree;
  void _selectLoanTypeThree(String value) => setState(() { _loanTypeThree = value; _loanTypeThreeError = ""; });
  String _loanTypeThreeError = "";
  final _otherFacilityThreeController = TextEditingController();
  // ==============================

  String _premiseType = "";
  String _premiseError = "";
  void _setPremiseType(String type) {
    setState(() {
      _premiseType = type;
    });
  }
  // ==============================

  String _premiseBillType = "";
  String _premiseBillError = "";
  void _setPremiseBillType(String type) {
    setState(() {
      _premiseBillType = type;
    });
  }

  // ==============================
  final _meterNumberController = TextEditingController();
  String _meterNumberError = "";
  // ==============================
  final _noBillsReasonController = TextEditingController();
  String _noBillsReasonError = "";
  // ==============================
  final _waterAuthorityController = TextEditingController();
  String? _waterAuthority;
  void _selectWaterAuthority(String value) => setState(() {
        _waterAuthority = value;
      });
  String _waterAuthorityError = "";
  // ==============================
  final _otherAuthorityController = TextEditingController();
  String _otherAuthorityError = "";
  // ==============================
  String _addCollateral = "";
  String _addCollateralError = "";
  void _setAddCollateralType(String type) {
    setState(() {
      _addCollateral = type;
    });
  }

  // ==============================
  String _maritalStatus = "";
  String _maritalStatusError = "";
  void _setMaritalStatusType(String type) {
    setState(() {
      _maritalStatus = type;
    });
  }

  // ==============================
  final _spouseNIDAController = TextEditingController();
  String _spouseNIDAError = "";
  // ==============================
  final _spouseFullNameController = TextEditingController();
  String _spouseFullNameError = "";
  // ==============================
  DateTime? _spouseDOBToDate;
  void _setspouseDOBToDate(DateTime picked) => setState(() {
        _spouseDOBToDate = picked;
      });
  String _spouseDOBToError = "";
  // ==============================
  final _spouseProfessionController = TextEditingController();
  String _spouseProfessionError = "";
  // ==============================
  final _spouseEmailController = TextEditingController();
  String _spouseEmailError = "";
  // ==============================
  final _spousePhoneController = TextEditingController();
  String _spousePhoneError = "";
  // ==============================

  // ==============================
  final _divorceeNIDAController = TextEditingController();
  String _divorceeNIDAError = "";
  final _widowNIDAController = TextEditingController();
  String _widowNIDAError = "";
  // ==============================
  final _divorceeFullNameController = TextEditingController();
  String _divorceeFullNameError = "";
  final _widowFullNameController = TextEditingController();
  String _widowFullNameError = "";
  // ==============================
  DateTime? _divorceeDOBToDate;
  void _setdivorceeDOBToDate(DateTime picked) => setState(() {
        _divorceeDOBToDate = picked;
      });
  String _divorceeDOBToError = "";
  String _widowDOBToError = "";
  DateTime? _widowDOBToDate;
  void _setwidowDOBToDate(DateTime picked) => setState(() {
        _widowDOBToDate = picked;
      });
  // ==============================
  final _divorceeProfessionController = TextEditingController();
  String _divorceeProfessionError = "";
  // ==============================
  final _divorceeEmailController = TextEditingController();
  String _divorceeEmailError = "";
  // ==============================
  final _divorceePhoneController = TextEditingController();
  String _divorceePhoneError = "";
  // ==============================
  final _collateralNameController = TextEditingController();
  String _collateralNameError = "";
  // ==============================
  final _collateralValueController = TextEditingController();
  String _collateralValueError = "";
  // ==============================

  final _collateralDocTypeController = TextEditingController();
  String? _selectedCollateralDocType;
  void _selectCollateralDocType(String value) => setState(() {
        _selectedCollateralDocType = value;
      });
  String _collateralDocTypeError = "";
  // ==============================
  final _collateralInvestDocTypeController = TextEditingController();
  String? _selectedCollateralInvestDocType;
  void _selectCollateralInvestDocType(String value) => setState(() {
        _selectedCollateralInvestDocType = value;
      });
  String _collateralInvestDocTypeError = "";
  // ==============================

  final _otherDocTypeNameController = TextEditingController();
  String _otherDocTypeNameError = "";
  // ==============================
  final _collateralDocNumberController = TextEditingController();
  String _collateralDocNumberError = "";
  // ==============================

  Map<String, String>? _encodedCollateralDoc;
  String _collateralDocError = "";
  String? _collateralDocFileName;
  void _setCollateralDocFilename(String value) => setState(() {
        _collateralDocFileName = value;
      });
  void _selectCollateralDocEncoded(Map<String, String> value) => setState(() {
        _encodedCollateralDoc = value;
      });

  void _selectCollateralDocFileError(String value) => setState(() {
        _collateralDocError = value;
      });
  // ==============================

  Map<String, String>? _encodeddeathCertDoc;
  String _deathCertDocError = "";
  String? _deathCertDocFileName;
  void _setdeathCertDocFilename(String value) => setState(() {
        _deathCertDocFileName = value;
      });
  void _selectdeathCertDocEncoded(Map<String, String> value) => setState(() {
        _encodeddeathCertDoc = value;
      });

  void _selectdeathCertDocFileError(String value) => setState(() {
        _deathCertDocError = value;
      });
  // ==============================
  Map<String, String>? _encodeddivCertDoc;
  String _divCertDocError = "";
  String? _divCertDocFileName;
  void _setdivCertDocFilename(String value) => setState(() {
        _divCertDocFileName = value;
      });
  void _selectdivCertDocEncoded(Map<String, String> value) => setState(() {
        _encodeddivCertDoc = value;
      });

  void _selectdivCertDocFileError(String value) => setState(() {
        _divCertDocError = value;
      });
  // ==============================
  Map<String, String>? _encodedbizLicenseDoc;
  String _bizLicenseDocError = "";
  String? _bizLicenseDocFileName;
  void _setbizLicenseDocFilename(String value) => setState(() {
        _bizLicenseDocFileName = value;
      });
  void _selectbizLicenseEncoded(Map<String, String> value) => setState(() {
        _encodedbizLicenseDoc = value;
      });

  void _selectbizLicenseDocFileError(String value) => setState(() {
        _bizLicenseDocError = value;
      });
// ==============================
  // ==============================
  final _addRefOneController = TextEditingController();
  String _addRefOne = "";
  String _addRefOneError = "";
  void _setaddRefOne(String type) {
    setState(() {
      _addRefOne = type;
    });
  }

  // ==============================
  final _refOneNIDAController = TextEditingController();
  String _refOneNIDAError = "";
  // ==============================
  final _refOneFullNameController = TextEditingController();
  String _refOneFullNameError = "";
  // ==============================
  DateTime? _refOneDobDate;
  void _setRefOneDobDate(DateTime picked) => setState(() {
        _refOneDobDate = picked;
      });
  String _refOneDobError = "";
  // ==============================
  String _refOneMaritalStatus = "";
  String _refOneMaritalStatusError = "";
  void _setRefOneMaritalStatusType(String type) {
    setState(() {
      _refOneMaritalStatus = type;
    });
  }

  // ==============================
  final _refOneProfessionController = TextEditingController();
  String _refOneProfessionError = "";
  // ==============================
  final _refOneEmailController = TextEditingController();
  String _refOneEmailError = "";
  // ==============================
  final _refOnePhoneController = TextEditingController();
  String _refOnePhoneError = "";
  // ==============================
  final _addRefTwoController = TextEditingController();
  String _addRefTwo = "";
  String _addRefTwoError = "";
  void _setaddRefTwo(String type) {
    setState(() {
      _addRefTwo = type;
    });
  }

  // ==============================
  final _refTwoNIDAController = TextEditingController();
  String _refTwoNIDAError = "";
  // ==============================
  final _refTwoFullNameController = TextEditingController();
  String _refTwoFullNameError = "";
  // ==============================
  DateTime? _refTwoDobDate;
  void _setRefTwoDobDate(DateTime picked) => setState(() {
        _refTwoDobDate = picked;
      });
  String _refTwoDobError = "";
  // ==============================
  String _refTwoMaritalStatus = "";
  String _refTwoMaritalStatusError = "";
  void _setRefTwoMaritalStatusType(String type) {
    setState(() {
      _refTwoMaritalStatus = type;
    });
  }

  // ==============================
  final _refTwoProfessionController = TextEditingController();
  String _refTwoProfessionError = "";
  // ==============================
  final _refTwoEmailController = TextEditingController();
  String _refTwoEmailError = "";
  // ==============================
  final _refTwoPhoneController = TextEditingController();
  String _refTwoPhoneError = "";
  // ==============================
  final _addRefThreeController = TextEditingController();
  String _addRefThree = "";
  String _addRefThreeError = "";
  void _setaddRefThree(String type) {
    setState(() {
      _addRefThree = type;
    });
  }

  // ==============================
  final _refThreeNIDAController = TextEditingController();
  String _refThreeNIDAError = "";
  // ==============================
  final _refThreeFullNameController = TextEditingController();
  String _refThreeFullNameError = "";
  // ==============================
  DateTime? _refThreeDobDate;
  void _setRefThreeDobDate(DateTime picked) => setState(() {
        _refThreeDobDate = picked;
      });
  String _refThreeDobError = "";
  // ==============================
  String _refThreeMaritalStatus = "";
  String _refThreeMaritalStatusError = "";
  void _setRefThreeMaritalStatusType(String type) {
    setState(() {
      _refThreeMaritalStatus = type;
    });
  }

  // ==============================
  final _refThreeProfessionController = TextEditingController();
  String _refThreeProfessionError = "";
  // ==============================
  final _refThreeEmailController = TextEditingController();
  String _refThreeEmailError = "";
  // ==============================
  final _refThreePhoneController = TextEditingController();
  String _refThreePhoneError = "";
  // ==============================

  Map<String, String>? _encodedNIDADoc;
  String _nidaDocError = "";
  String? _nidaDocFileName;
  void _setNIDADocFilename(String value) => setState(() {
        _nidaDocFileName = value;
      });
  void _selectNIDADocEncoded(Map<String, String> value) => setState(() {
        _encodedNIDADoc = value;
      });

  void _selectNIDADocFileError(String value) => setState(() {
        _nidaDocError = value;
      });

  // ==============================

  Map<String, String>? _encodedOtherDoc;
  List<Map<String, String>>? _encodedOtherDocs;
  String _otherDocError = "";
  String? _otherDocFileName;
  void _setOtherDocFilename(String value) => setState(() {
        _otherDocFileName = value;
      });
  void _selectOtherDocEncoded(Map<String, String> value) => setState(() {
        _encodedOtherDoc = value;
      });
  void _selectOtherDocsEncoded(List<Map<String, String>> value) => setState(() {
        _encodedOtherDocs = value;
      });

  void _selectOtherDocFileError(String value) => setState(() {
        _otherDocError = value;
      });

  // ==============================
  String _addMobileStmt = "";
  String _addMobileStmtError = "";
  void _setAddMobileStmtType(String type) {
    setState(() {
      _addMobileStmt = type;
    });
  }

  // ==============================
  Map<String, String>? _encodedmobStmtDoc;
  String _mobStmtDocError = "";
  String? _mobStmtDocFileName;
  void _setMobStmtDocFilename(String value) => setState(() {
        _mobStmtDocFileName = value;
      });
  void _selectmobStmtDocEncoded(Map<String, String> value) => setState(() {
        _encodedmobStmtDoc = value;
      });

  void _selectmobStmtDocFileError(String value) => setState(() {
        _mobStmtDocError = value;
      });
// ==============================
  String _addSupplIncome = "";
  String _addSupplIncomeError = "";
  void _setAddSupplIncomeType(String type) {
    setState(() {
      _addSupplIncome = type;
    });
  }

  String _addBankStatement = "";
  String _addBankStatementError = "";
  void _setBankStatementType(String type) {
    setState(() {
      _addBankStatement = type;
    });
  }

  String _addBankStatement2 = "";
  String _addBankStatementError2 = "";
  void _setBankStatementType2(String type) {
    setState(() {
      _addBankStatement2 = type;
    });
  }

  // ==============================
  final _supplSourceController = TextEditingController();
  String _supplSourceError = "";
  // ==============================
  final _supplTotalController = TextEditingController();
  String _supplTotalError = "";
  // ==============================
  final _bizAnnualIncomeController = TextEditingController();
  String _bizAnnualIncomeError = "";
  // ==============================

  final _salaryBankController = TextEditingController();
  String? _salaryBank;
  void _selectsalaryBank(String value) => setState(() {
        _salaryBank = value;
      });
  String _salaryBankError = "";
  // ==============================
  final _bankAccountNumberController = TextEditingController();
  String _bankAccountNumberError = "";
  // ==============================
  final _monthlySalaryController = TextEditingController();
  String _monthlySalaryError = "";
  // ==============================
  final _yearlyBonusController = TextEditingController();
  String _yearlyBonusError = "";
  // ==============================

  Map<String, String>? _encodedBankStmtDoc;
  
  String _bankStmtDocError = "";
  String? _bankStmtFileName;
  
  void _setBankStmtFilename(String value) => setState(() {
        _bankStmtFileName = value;
      });
  void _selectBankStmtDocEncoded(Map<String, String> value) => setState(() {
        _encodedBankStmtDoc = value;
      });

  void _selectBankStmtDocFileError(String value) => setState(() {
        _bankStmtDocError = value;
      });

  Map<String, String>? _encodedBankStmtDoc2;
  String _bankStmtDocError2 = "";
  String? _bankStmtFileName2;
  void _setBankStmtFilename2(String value) => setState(() {
        _bankStmtFileName2 = value;
      });
  void _selectBankStmtDocEncoded2(Map<String, String> value) => setState(() {
        _encodedBankStmtDoc2 = value;
      });

  void _selectBankStmtDocFileError2(String value) => setState(() {
        _bankStmtDocError = value;
      });

  Map<String, String>? _encodedBankStmtDoc3;
  String _bankStmtDocError3 = "";
  String? _bankStmtFileName3;
  void _setBankStmtFilename3(String value) => setState(() {
        _bankStmtFileName2 = value;
      });
  void _selectBankStmtDocEncoded3(Map<String, String> value) => setState(() {
        _encodedBankStmtDoc3 = value;
      });

  void _selectBankStmtDocFileError3(String value) => setState(() {
        _bankStmtDocError = value;
      });
  // ==============================

  // INPUT FIELDS

  final String _formError = "";

  String _creditOfferId = "";

  void fetchProfileData() async {
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
            _maritalStatusController.text = _profileData['marital_status'];
            _fullNameController.text = _profileData['full_name'];
            _dobController.text = _profileData['dob'];
            _genderController.text = _profileData['gender'];
            _citizenshipController.text = _profileData['citizenship'];
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

  void fetchBanks() async {
    try {
      final response =
          await ApiService.get('get-banks', token: apiProvider.authToken);

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
          dynamic banks = response['banks'];
          for (var bank in banks) {
            setState(() {
              _banks[bank['bank_id'].toString()] = bank['bank_name'];
            });
          }
        }
      }
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

  bool isDataFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isDataFetched) {
      apiProvider = Provider.of<APIProvider>(context, listen: false);
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      fetchProfileData();
      fetchBanks();
      isDataFetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return AuthedWrapper(
      scrollController: _scrollController,
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(
        scaffoldKey: _scaffoldKey,
        title: "Self-Employed Loan Application",
      ),
      bottomBar: SizedBox(),
      child: Center(
        child: _isPageLoading
            ? LoadingScreen()
            : (_profileData.isEmpty
                ? Text('Profile data not available')
                : Column(
                    spacing: 20,
                    children: [
                      Column(
                        children: [
                          Container(
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Form error
                                    if (_formError != "")
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: CIColors.errorBox,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _formError,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: CIColors.errorColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    if (_formError != "")
                                      const SizedBox(height: 8),

                                    // Success message
                                    if (args != null &&
                                        args.containsKey("success-message"))
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(8),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: CIColors.successBox,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          args['success-message'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: CIColors.successColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    if (args != null &&
                                        args.containsKey("success-message"))
                                      const SizedBox(height: 8),

                                    // Credit offer application form
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Step One: Introduction (SWAHILI)
                                          if (_currPage == 1)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tafadhali Zingatia Mahitaji haya Muhimu kwa Uhitimu wa Mikopo:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: CIColors.green,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    '1. Tunakuhimiza sana kuandikisha dhamana ili kuongeza thamani ya maombi yako'),
                                                SizedBox(height: 8),
                                                Text(
                                                    '2. Mkopaji lazima aambatishe nakala za PDF za hati zifuatazo wakati wa kuwasilisha maombi yao kwa uchunguzi wa mapema wa taasisi ya kifedha:'),
                                                SizedBox(height: 16),
                                                Text(
                                                    'Kwa Wakopaji Waliojiajiri'),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'a. Kadi ya NIDA, au Leseni ya Udereva ya Tanzania, au Pasipoti'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'b. Leseni ya Biashara'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'c. Cheti cha TIN cha Biashara'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'd. Taarifa ya Benki (miezi 6) au Taarifa ya Pesa kwa Simu ya Mkononi (miezi 6)'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'e. Anwani ya Biashara'),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                    'Kwa mtumiaji wa simu, tengeneza hati zako za PDF kwa kutumia programu ifuatayo:'),
                                                SizedBox(height: 12),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          launchUrl(
                                                            Uri.parse(
                                                                'https://play.google.com/store/apps/details?id=com.intsig.camscanner&hl=en_US&gl=US'),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 16,
                                                            vertical: 6,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  110,
                                                                  183,
                                                                  237,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Row(
                                                            spacing: 6,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .googlePlay,
                                                                size: 12,
                                                                color: CIColors
                                                                    .secondaryColor,
                                                              ),
                                                              Text(
                                                                'PDF Scanner kwa simu za Android',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: CIColors
                                                                      .secondaryColor,
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
                                                ),
                                                SizedBox(height: 16),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          launchUrl(
                                                            Uri.parse(
                                                                'https://apps.apple.com/us/app/camscanner-pdf-scanner-app/id388627783'),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 16,
                                                            vertical: 6,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  110,
                                                                  183,
                                                                  237,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Row(
                                                            spacing: 6,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .appStoreIos,
                                                                size: 12,
                                                                color: CIColors
                                                                    .secondaryColor,
                                                              ),
                                                              Text(
                                                                'PDF Scanner kwa simu za iOS',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: CIColors
                                                                      .secondaryColor,
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
                                                ),
                                                SizedBox(height: 32),
                                              ],
                                            ),

                                          // Step Two: Introduction (ENGLISH)
                                          if (_currPage == 2)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Please Note these Key Requirements for Credit Qualification:',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: CIColors.green,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    '1. We strongly recommend you enlist a collateral in order to increase your chance to get a loan'),
                                                SizedBox(height: 8),
                                                Text(
                                                    '2. The borrower must attach PDF copies of the following documents for financial institution prescreening:'),
                                                SizedBox(height: 16),
                                                Text(
                                                    'For Self Employed Borrowers'),
                                                SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'a. NIDA Card, Tanzanian Driver’s License, or Passport'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'b. Business License'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'c. Business TIN Certificate'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'd. Bank Statement (6 months) or Mobile Money Statement (6 months)'),
                                                      SizedBox(height: 8),
                                                      Text(
                                                          'e. Business Address'),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                    'For Mobile Phone users, you can scan PDF documents by downloading the following App from the Play Store or App Store:'),
                                                SizedBox(height: 12),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          launchUrl(
                                                            Uri.parse(
                                                                'https://play.google.com/store/apps/details?id=com.intsig.camscanner&hl=en_US&gl=US'),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 16,
                                                            vertical: 6,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  110,
                                                                  183,
                                                                  237,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Row(
                                                            spacing: 6,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .googlePlay,
                                                                size: 12,
                                                                color: CIColors
                                                                    .secondaryColor,
                                                              ),
                                                              Text(
                                                                'PDF Scanner for Android',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: CIColors
                                                                      .secondaryColor,
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
                                                ),
                                                SizedBox(height: 16),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 16),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          launchUrl(
                                                            Uri.parse(
                                                                'https://apps.apple.com/us/app/camscanner-pdf-scanner-app/id388627783'),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 16,
                                                            vertical: 6,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  110,
                                                                  183,
                                                                  237,
                                                                  255),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Row(
                                                            spacing: 6,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .appStoreIos,
                                                                size: 12,
                                                                color: CIColors
                                                                    .secondaryColor,
                                                              ),
                                                              Text(
                                                                'PDF Scanner for iOS',
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14,
                                                                  color: CIColors
                                                                      .secondaryColor,
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
                                                ),
                                                SizedBox(height: 32),
                                              ],
                                            ),

                                          // Step THREE: Introduction (USER INFO)
                                          if (_currPage == 3)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Full Name
                                                CIField(
                                                  readOnly: true,
                                                  inputController:
                                                      _fullNameController,
                                                  engLabel: "Full Name",
                                                  swLabel: "Jina Kamili",
                                                  placeholder:
                                                      "Enter full name",
                                                  haveError:
                                                      (_fullNameError != ""),
                                                ),
                                                const SizedBox(height: 8),

                                                // Date of Birth
                                                CIField(
                                                  readOnly: true,
                                                  inputController:
                                                      _dobController,
                                                  engLabel: "Date of Birth",
                                                  swLabel: "Tarehe ya Kuzaliwa",
                                                  placeholder:
                                                      "Enter date of birth",
                                                  haveError: (_dobError != ""),
                                                ),
                                                const SizedBox(height: 8),

                                                // Marital Status
                                                CIField(
                                                  readOnly: true,
                                                  inputController:
                                                      _maritalStatusController,
                                                  engLabel: "Marital Status",
                                                  swLabel: "Hali ya Ndoa",
                                                  placeholder:
                                                      "Enter marital status",
                                                  haveError: (false),
                                                ),
                                                const SizedBox(height: 8),

                                                // Gender
                                                CIField(
                                                  readOnly: true,
                                                  inputController:
                                                      _genderController,
                                                  engLabel: "Gender",
                                                  swLabel: "Jinsia",
                                                  placeholder: "Enter gender",
                                                  haveError:
                                                      (_genderError != ""),
                                                ),
                                                const SizedBox(height: 8),

                                                // Citizenship
                                                CIField(
                                                  readOnly: true,
                                                  inputController:
                                                      _citizenshipController,
                                                  engLabel: "Citizenship",
                                                  swLabel: "Uraia",
                                                  placeholder:
                                                      "Enter citizenship",
                                                  haveError:
                                                      (_citizenshipError != ""),
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),

                                          // Step FOUR: Loan Details
                                          if (_currPage == 4)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Loan Facility
                                                CISelectField(
                                                  inputController:
                                                      _loanFacilityController,
                                                  engLabel:
                                                      "Loan Facility Requested",
                                                  swLabel:
                                                      "Aina ya Mkopo Unaoomba",
                                                  placeholder:
                                                      "Select Loan Facility",
                                                  options: ciLoanTypes,
                                                  selectOption:
                                                      _selectLoanFacility,
                                                  selectedOption:
                                                      _selectedLoanFacility,
                                                  haveError:
                                                      (_loanFacilityError !=
                                                          ""),
                                                ),
                                                if (_loanFacilityError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _loanFacilityError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // Loan Currency
                                                CISelectField(
                                                  inputController:
                                                      _loanCurrencyController,
                                                  engLabel:
                                                      "Select Your Income Currency",
                                                  swLabel:
                                                      "Chagua aina ya sarafu",
                                                  placeholder:
                                                      "Select Currency",
                                                  options: allowedCurrencies,
                                                  selectOption: _selectCurrency,
                                                  selectedOption:
                                                      _selectedCurrency,
                                                  haveError:
                                                      (_loanCurrencyError !=
                                                          ""),
                                                ),
                                                if (_loanCurrencyError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _loanCurrencyError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // Loan amount
                                                CIField(
                                                  inputController:
                                                      _loanAmountController,
                                                  engLabel:
                                                      "Value of Loan Requested ",
                                                  swLabel:
                                                      "Thamani ya Mkopo Unaoomba",
                                                  placeholder: "Enter amount",
                                                  haveError:
                                                      (_loanAmountError != ""),
                                                  onlyDigits: true,
                                                  isMoney: true,
                                                  prefix:
                                                      _selectedCurrency ?? '',
                                                ),
                                                if (_loanAmountError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _loanAmountError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // Loan purpose
                                                CILongField(
                                                  inputController:
                                                      _loanPurposeC,
                                                  engLabel:
                                                      "Purpose for this loan",
                                                  swLabel: "Kusudi la Mkopo",
                                                  placeholder:
                                                      "Short and clear answer",
                                                  haveError:
                                                      (_loanPurposeError != ""),
                                                ),
                                                if (_loanPurposeError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _loanPurposeError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // First Existing loan*
                                                CIRadioField(
                                                  engLabel:
                                                      "Do You have any Existing Loans?",
                                                  swLabel:
                                                      "Je, Una Mikopo Yeyote?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption:
                                                      _setExistingLoanOne,
                                                  selectedOption:
                                                      _existingLoanOne,
                                                  haveError:
                                                      (_existingLoanOneError !=
                                                          ""),
                                                ),
                                                if (_existingLoanOneError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _existingLoanOneError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_existingLoanOne == "Yes")
                                                  Column(
                                                    children: [
                                                      // Institution One
                                                      CISelectField(
                                                        inputController:
                                                            _institutionOneController,
                                                        engLabel:
                                                            "Which Financial Institution Gave you this Loan?",
                                                        swLabel:
                                                            "Orodhesha Taasisi Iliyokupa huu Mkopo",
                                                        placeholder:
                                                            "Select Institution",
                                                        options: _banks.keys
                                                            .toList(),
                                                        optionValues: _banks,
                                                        selectOption:
                                                            _selectInstitutionOne,
                                                        selectedOption:
                                                            _institutionOne,
                                                        haveError:
                                                            (_institutionOneError !=
                                                                ""),
                                                      ),
                                                      if (_institutionOneError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _institutionOneError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // Loan Facility Type One (radio)
                                                      CIRadioField(
                                                        engLabel: "What Type of Credit Facility were you Awarded?",
                                                        swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                        options: {
                                                          "Installment": ["Installment", "Mkopo wa Malipo ya Awamu"],
                                                          "Revolving": ["Revolving", "Mkopo wa Mzunguko"],
                                                          "Other": ["Other", "Mkopo Mwingine"],
                                                        },
                                                        setOption: _setLoanFacilityTypeOne,
                                                        selectedOption: _loanFacilityTypeOne,
                                                        haveError: (_loanFacilityTypeOneError != ""),
                                                      ),
                                                      if (_loanFacilityTypeOneError != "")
                                                        Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanFacilityTypeOneError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                      const SizedBox(height: 8),

                                                      // Loan Type One - conditional
                                                      if (_loanFacilityTypeOne == "Installment")
                                                        CISelectField(
                                                          inputController: _loanTypeOneController,
                                                          engLabel: "What Type of Loan were you Issued?",
                                                          swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                          placeholder: "Select Installment Loan Type",
                                                          options: ["Mobile Money / Digital Loan", "Mortgage Loan", "Motorized Vehicle Loan", "Personal Loan", "Business Loan", "Education Loan"],
                                                          selectOption: _selectLoanTypeOne,
                                                          selectedOption: _loanTypeOne,
                                                          haveError: (_loanTypeOneError != ""),
                                                        ),
                                                      if (_loanFacilityTypeOne == "Revolving")
                                                        CISelectField(
                                                          inputController: _loanTypeOneController,
                                                          engLabel: "What Type of Loan were you Issued?",
                                                          swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                          placeholder: "Select Revolving Loan Type",
                                                          options: ["Credit Card Revolving Loan", "Secured / Collateralized Loan", "Account Overdraft"],
                                                          selectOption: _selectLoanTypeOne,
                                                          selectedOption: _loanTypeOne,
                                                          haveError: (_loanTypeOneError != ""),
                                                        ),
                                                      if (_loanFacilityTypeOne == "Other")
                                                        CIField(
                                                          inputController: _otherFacilityOneController,
                                                          engLabel: "Other Credit Facility",
                                                          swLabel: "Aina Nyingine ya Mkopo",
                                                          placeholder: "Enter other credit facility",
                                                          haveError: (_loanTypeOneError != ""),
                                                        ),
                                                      if (_loanTypeOneError != "")
                                                        Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanTypeOneError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                      if (_loanFacilityTypeOne.isNotEmpty) const SizedBox(height: 8),

                                                      // Loan Issuing Date One
                                                      CIDatePicker(
                                                        dateState: _issuingDateOne,
                                                        setDateState: _setIssuingDateOne,
                                                        engLabel: "Loan issuing date",
                                                        swLabel: "Tarehe ya Kupata mkopo",
                                                        placeholder: "Pick loan issuing date",
                                                        haveError: (_issuingDateOneError != ""),
                                                      ),
                                                      if (_issuingDateOneError != "")
                                                        Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_issuingDateOneError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                      const SizedBox(height: 8),

                                                      // Existing Loan Currency One
                                                      CISelectField(
                                                        inputController: _existingLoanCurrencyOneController,
                                                        engLabel: "Select Your Loan Currency",
                                                        swLabel: "Chagua aina ya Sarafu ya mkopo",
                                                        placeholder: "Select Currency",
                                                        options: allowedCurrencies,
                                                        selectOption: _selectExistingLoanCurrencyOne,
                                                        selectedOption: _existingLoanCurrencyOne,
                                                        haveError: (_existingLoanCurrencyOneError != ""),
                                                      ),
                                                      if (_existingLoanCurrencyOneError != "")
                                                        Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_existingLoanCurrencyOneError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                      const SizedBox(height: 8),

                                                      // Credited Amount One
                                                      CIField(
                                                        inputController: _creditedAmountOneController,
                                                        engLabel: "State the Credited Amount of This Existing Facility?",
                                                        swLabel: "Jumla ya Kiwango Cha Mkopo Huu",
                                                        placeholder: "Enter amount",
                                                        haveError: (_creditedAmountOneError != ""),
                                                        onlyDigits: true,
                                                        isMoney: true,
                                                        prefix: _existingLoanCurrencyOne ?? '',
                                                      ),
                                                      if (_creditedAmountOneError != "")
                                                        Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_creditedAmountOneError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                      const SizedBox(height: 8),

                                                      // Current Balance One
                                                      CIField(
                                                        inputController:
                                                            _prevLoanBalanceOneController,
                                                        engLabel:
                                                            "Current Balance of this Existing Loan",
                                                        swLabel:
                                                            "Usawa wa sasa uliopo wa mkopo huu",
                                                        placeholder:
                                                            "Enter current balance",
                                                        haveError:
                                                            (_prevLoanBalanceOneError !=
                                                                ""),
                                                        onlyDigits: true,
                                                        isMoney: true,
                                                        prefix:
                                                            _selectedCurrency ??
                                                                '',
                                                      ),
                                                      if (_prevLoanBalanceOneError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _prevLoanBalanceOneError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // Second Existing loan*
                                                      CIRadioField(
                                                        engLabel:
                                                            "Do You have any other Existing Loans?",
                                                        swLabel:
                                                            "Je, Una Mkopo Mwingine Wowote?",
                                                        options: {
                                                          "Yes": [
                                                            "Yes",
                                                            "Ndio"
                                                          ],
                                                          "No": [
                                                            "No",
                                                            "Hapana"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setExistingLoanTwo,
                                                        selectedOption:
                                                            _existingLoanTwo,
                                                        haveError:
                                                            (_existingLoanTwoError !=
                                                                ""),
                                                      ),
                                                      if (_existingLoanTwoError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _existingLoanTwoError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      if (_existingLoanTwo ==
                                                          "Yes")
                                                        Column(
                                                          children: [
                                                            // Institution Two
                                                            CISelectField(
                                                              inputController:
                                                                  _institutionTwoController,
                                                              engLabel:
                                                                  "Which Financial Institution Gave you this Loan?",
                                                              swLabel:
                                                                  "Orodhesha Taasisi Iliyokupa huu Mkopo",
                                                              placeholder:
                                                                  "Select Institution",
                                                              options: _banks
                                                                  .keys
                                                                  .toList(),
                                                              optionValues:
                                                                  _banks,
                                                              selectOption:
                                                                  _selectInstitutionTwo,
                                                              selectedOption:
                                                                  _institutionTwo,
                                                              haveError:
                                                                  (_institutionTwoError !=
                                                                      ""),
                                                            ),
                                                            if (_institutionTwoError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _institutionTwoError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Loan Facility Type Two (radio)
                                                            CIRadioField(
                                                              engLabel: "What Type of Credit Facility were you Awarded?",
                                                              swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                              options: {
                                                                "Installment": ["Installment", "Mkopo wa Malipo ya Awamu"],
                                                                "Revolving": ["Revolving", "Mkopo wa Mzunguko"],
                                                                "Other": ["Other", "Mkopo Mwingine"],
                                                              },
                                                              setOption: _setLoanFacilityTypeTwo,
                                                              selectedOption: _loanFacilityTypeTwo,
                                                              haveError: (_loanFacilityTypeTwoError != ""),
                                                            ),
                                                            if (_loanFacilityTypeTwoError != "")
                                                              Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanFacilityTypeTwoError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                            const SizedBox(height: 8),

                                                            // Loan Type Two - conditional
                                                            if (_loanFacilityTypeTwo == "Installment")
                                                              CISelectField(
                                                                inputController: _loanTypeTwoController,
                                                                engLabel: "What Type of Loan were you Issued?",
                                                                swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                                placeholder: "Select Installment Loan Type",
                                                                options: ["Mobile Money / Digital Loan", "Mortgage Loan", "Motorized Vehicle Loan", "Personal Loan", "Business Loan", "Education Loan"],
                                                                selectOption: _selectLoanTypeTwo,
                                                                selectedOption: _loanTypeTwo,
                                                                haveError: (_loanTypeTwoError != ""),
                                                              ),
                                                            if (_loanFacilityTypeTwo == "Revolving")
                                                              CISelectField(
                                                                inputController: _loanTypeTwoController,
                                                                engLabel: "What Type of Loan were you Issued?",
                                                                swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                                placeholder: "Select Revolving Loan Type",
                                                                options: ["Credit Card Revolving Loan", "Secured / Collateralized Loan", "Account Overdraft"],
                                                                selectOption: _selectLoanTypeTwo,
                                                                selectedOption: _loanTypeTwo,
                                                                haveError: (_loanTypeTwoError != ""),
                                                              ),
                                                            if (_loanFacilityTypeTwo == "Other")
                                                              CIField(
                                                                inputController: _otherFacilityTwoController,
                                                                engLabel: "Other Credit Facility",
                                                                swLabel: "Aina Nyingine ya Mkopo",
                                                                placeholder: "Enter other credit facility",
                                                                haveError: (_loanTypeTwoError != ""),
                                                              ),
                                                            if (_loanTypeTwoError != "")
                                                              Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanTypeTwoError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                            if (_loanFacilityTypeTwo.isNotEmpty) const SizedBox(height: 8),

                                                            // Loan Issuing Date Two
                                                            CIDatePicker(
                                                              dateState: _issuingDateTwo,
                                                              setDateState: _setIssuingDateTwo,
                                                              engLabel: "Loan issuing date",
                                                              swLabel: "Tarehe ya Kupata mkopo",
                                                              placeholder: "Pick loan issuing date",
                                                              haveError: (_issuingDateTwoError != ""),
                                                            ),
                                                            if (_issuingDateTwoError != "")
                                                              Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_issuingDateTwoError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                            const SizedBox(height: 8),

                                                            // Existing Loan Currency Two
                                                            CISelectField(
                                                              inputController: _existingLoanCurrencyTwoController,
                                                              engLabel: "Select Your Loan Currency",
                                                              swLabel: "Chagua aina ya Sarafu ya mkopo",
                                                              placeholder: "Select Currency",
                                                              options: allowedCurrencies,
                                                              selectOption: _selectExistingLoanCurrencyTwo,
                                                              selectedOption: _existingLoanCurrencyTwo,
                                                              haveError: (_existingLoanCurrencyTwoError != ""),
                                                            ),
                                                            if (_existingLoanCurrencyTwoError != "")
                                                              Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_existingLoanCurrencyTwoError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                            const SizedBox(height: 8),

                                                            // Credited Amount Two
                                                            CIField(
                                                              inputController: _creditedAmountTwoController,
                                                              engLabel: "State the Credited Amount of This Existing Facility?",
                                                              swLabel: "Jumla ya Kiwango Cha Mkopo Huu",
                                                              placeholder: "Enter amount",
                                                              haveError: (_creditedAmountTwoError != ""),
                                                              onlyDigits: true,
                                                              isMoney: true,
                                                              prefix: _existingLoanCurrencyTwo ?? '',
                                                            ),
                                                            if (_creditedAmountTwoError != "")
                                                              Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_creditedAmountTwoError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                            const SizedBox(height: 8),

                                                            // Current Balance Two
                                                            CIField(
                                                              inputController:
                                                                  _prevLoanBalanceTwoController,
                                                              engLabel:
                                                                  "Current Balance of this Existing Loan",
                                                              swLabel:
                                                                  "Usawa wa sasa uliopo wa mkopo huu",
                                                              placeholder:
                                                                  "Enter current balance",
                                                              haveError:
                                                                  (_prevLoanBalanceTwoError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              isMoney: true,
                                                              prefix:
                                                                  _selectedCurrency ??
                                                                      '',
                                                            ),
                                                            if (_prevLoanBalanceTwoError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _prevLoanBalanceTwoError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Third Existing loan*
                                                            CIRadioField(
                                                              engLabel:
                                                                  "Do You have any other Existing Loans?",
                                                              swLabel:
                                                                  "Je, Una Mkopo Mwingine Wowote?",
                                                              options: {
                                                                "Yes": [
                                                                  "Yes",
                                                                  "Ndio"
                                                                ],
                                                                "No": [
                                                                  "No",
                                                                  "Hapana"
                                                                ],
                                                              },
                                                              setOption:
                                                                  _setExistingLoanThree,
                                                              selectedOption:
                                                                  _existingLoanThree,
                                                              haveError:
                                                                  (_existingLoanThreeError !=
                                                                      ""),
                                                            ),
                                                            if (_existingLoanThreeError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _existingLoanThreeError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            if (_existingLoanThree ==
                                                                "Yes")
                                                              Column(
                                                                children: [
                                                                  // Institution Three
                                                                  CISelectField(
                                                                    inputController:
                                                                        _institutionThreeController,
                                                                    engLabel:
                                                                        "Which Financial Institution Gave you this Loan?",
                                                                    swLabel:
                                                                        "Orodhesha Taasisi Iliyokupa huu Mkopo",
                                                                    placeholder:
                                                                        "Select Institution",
                                                                    options: _banks
                                                                        .keys
                                                                        .toList(),
                                                                    optionValues:
                                                                        _banks,
                                                                    selectOption:
                                                                        _selectInstitutionThree,
                                                                    selectedOption:
                                                                        _institutionThree,
                                                                    haveError:
                                                                        (_institutionThreeError !=
                                                                            ""),
                                                                  ),
                                                                  if (_institutionThreeError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _institutionThreeError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Loan Facility Type Three (radio)
                                                                  CIRadioField(
                                                                    engLabel: "What Type of Credit Facility were you Awarded?",
                                                                    swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                                    options: {
                                                                      "Installment": ["Installment", "Mkopo wa Malipo ya Awamu"],
                                                                      "Revolving": ["Revolving", "Mkopo wa Mzunguko"],
                                                                      "Other": ["Other", "Mkopo Mwingine"],
                                                                    },
                                                                    setOption: _setLoanFacilityTypeThree,
                                                                    selectedOption: _loanFacilityTypeThree,
                                                                    haveError: (_loanFacilityTypeThreeError != ""),
                                                                  ),
                                                                  if (_loanFacilityTypeThreeError != "")
                                                                    Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanFacilityTypeThreeError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                                  const SizedBox(height: 8),

                                                                  // Loan Type Three - conditional
                                                                  if (_loanFacilityTypeThree == "Installment")
                                                                    CISelectField(
                                                                      inputController: _loanTypeThreeController,
                                                                      engLabel: "What Type of Loan were you Issued?",
                                                                      swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                                      placeholder: "Select Installment Loan Type",
                                                                      options: ["Mobile Money / Digital Loan", "Mortgage Loan", "Motorized Vehicle Loan", "Personal Loan", "Business Loan", "Education Loan"],
                                                                      selectOption: _selectLoanTypeThree,
                                                                      selectedOption: _loanTypeThree,
                                                                      haveError: (_loanTypeThreeError != ""),
                                                                    ),
                                                                  if (_loanFacilityTypeThree == "Revolving")
                                                                    CISelectField(
                                                                      inputController: _loanTypeThreeController,
                                                                      engLabel: "What Type of Loan were you Issued?",
                                                                      swLabel: "Ulipewa Mkopo wa Aina Gani?",
                                                                      placeholder: "Select Revolving Loan Type",
                                                                      options: ["Credit Card Revolving Loan", "Secured / Collateralized Loan", "Account Overdraft"],
                                                                      selectOption: _selectLoanTypeThree,
                                                                      selectedOption: _loanTypeThree,
                                                                      haveError: (_loanTypeThreeError != ""),
                                                                    ),
                                                                  if (_loanFacilityTypeThree == "Other")
                                                                    CIField(
                                                                      inputController: _otherFacilityThreeController,
                                                                      engLabel: "Other Credit Facility",
                                                                      swLabel: "Aina Nyingine ya Mkopo",
                                                                      placeholder: "Enter other credit facility",
                                                                      haveError: (_loanTypeThreeError != ""),
                                                                    ),
                                                                  if (_loanTypeThreeError != "")
                                                                    Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_loanTypeThreeError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                                  if (_loanFacilityTypeThree.isNotEmpty) const SizedBox(height: 8),

                                                                  // Loan Issuing Date Three
                                                                  CIDatePicker(
                                                                    dateState: _issuingDateThree,
                                                                    setDateState: _setIssuingDateThree,
                                                                    engLabel: "Loan issuing date",
                                                                    swLabel: "Tarehe ya Kupata mkopo",
                                                                    placeholder: "Pick loan issuing date",
                                                                    haveError: (_issuingDateThreeError != ""),
                                                                  ),
                                                                  if (_issuingDateThreeError != "")
                                                                    Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_issuingDateThreeError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                                  const SizedBox(height: 8),

                                                                  // Existing Loan Currency Three
                                                                  CISelectField(
                                                                    inputController: _existingLoanCurrencyThreeController,
                                                                    engLabel: "Select Your Loan Currency",
                                                                    swLabel: "Chagua aina ya Sarafu ya mkopo",
                                                                    placeholder: "Select Currency",
                                                                    options: allowedCurrencies,
                                                                    selectOption: _selectExistingLoanCurrencyThree,
                                                                    selectedOption: _existingLoanCurrencyThree,
                                                                    haveError: (_existingLoanCurrencyThreeError != ""),
                                                                  ),
                                                                  if (_existingLoanCurrencyThreeError != "")
                                                                    Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_existingLoanCurrencyThreeError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                                  const SizedBox(height: 8),

                                                                  // Credited Amount Three
                                                                  CIField(
                                                                    inputController: _creditedAmountThreeController,
                                                                    engLabel: "State the Credited Amount of This Existing Facility?",
                                                                    swLabel: "Jumla ya Kiwango Cha Mkopo Huu",
                                                                    placeholder: "Enter amount",
                                                                    haveError: (_creditedAmountThreeError != ""),
                                                                    onlyDigits: true,
                                                                    isMoney: true,
                                                                    prefix: _existingLoanCurrencyThree ?? '',
                                                                  ),
                                                                  if (_creditedAmountThreeError != "")
                                                                    Container(width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 16), child: Text(_creditedAmountThreeError, style: TextStyle(color: CIColors.errorText, fontSize: 14, fontStyle: FontStyle.italic))),
                                                                  const SizedBox(height: 8),

                                                                  // Current Balance Three
                                                                  CIField(
                                                                    inputController:
                                                                        _prevLoanBalanceThreeController,
                                                                    engLabel:
                                                                        "Current Balance of this Existing Loan",
                                                                    swLabel:
                                                                        "Usawa wa sasa uliopo wa mkopo huu",
                                                                    placeholder:
                                                                        "Enter current balance",
                                                                    haveError:
                                                                        (_prevLoanBalanceThreeError !=
                                                                            ""),
                                                                    onlyDigits:
                                                                        true,
                                                                    isMoney:
                                                                        true,
                                                                    prefix:
                                                                        _selectedCurrency ??
                                                                            '',
                                                                  ),
                                                                  if (_prevLoanBalanceThreeError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _prevLoanBalanceThreeError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                              ],
                                            ),

                                          // Step FIVE: Self employment
                                          if (_currPage == 5)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    // Business License Number
                                                    CIField(
                                                      inputController:
                                                          _bizLicenseController,
                                                      engLabel:
                                                          "Business License Number",
                                                      swLabel:
                                                          "Nambari ya Leseni ya Biashara",
                                                      placeholder:
                                                          "Enter your business license number",
                                                      haveError:
                                                          (_bizLicenseError !=
                                                              ""),
                                                      onlyDigits: true,
                                                      maxChars: 11,
                                                    ),
                                                    if (_bizLicenseError != "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _bizLicenseError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Name
                                                    CIField(
                                                      inputController:
                                                          _bizNameController,
                                                      engLabel:
                                                          "Legal Name of your Business",
                                                      swLabel:
                                                          "Jina la Kisheria la Biashara Yako",
                                                      placeholder:
                                                          "Enter the name on business license",
                                                      haveError:
                                                          (_bizNameError != ""),
                                                    ),
                                                    if (_bizNameError != "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _bizNameError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Region
                                                    CISelectField(
                                                      inputController:
                                                          _businessRegionController,
                                                      engLabel:
                                                          "Business Location (Region)",
                                                      swLabel:
                                                          "Mkoa Biashara Ilipo",
                                                      placeholder:
                                                          "Select Region",
                                                      options:
                                                          regionsAndDistrictsList
                                                              .keys
                                                              .toList(),
                                                      selectOption:
                                                          _selectRegion,
                                                      selectedOption:
                                                          _selectedRegion,
                                                      haveError:
                                                          (_regionFieldError !=
                                                              ""),
                                                    ),
                                                    if (_regionFieldError != "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _regionFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business District
                                                    CISelectField(
                                                      inputController:
                                                          _businessDistrictController,
                                                      engLabel:
                                                          "Business Location (District)",
                                                      swLabel:
                                                          "Wilaya Biashara Ilipo",
                                                      placeholder:
                                                          "Select District",
                                                      options:
                                                          regionsAndDistrictsList[
                                                                  _selectedRegion] ??
                                                              [],
                                                      selectOption:
                                                          _selectDistrict,
                                                      selectedOption:
                                                          _selectedDistrict,
                                                      haveError:
                                                          (_districtFieldError !=
                                                              ""),
                                                    ),
                                                    if (_districtFieldError !=
                                                        "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _districtFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Ward
                                                    CIField(
                                                      inputController:
                                                          _businessWardController,
                                                      engLabel:
                                                          "Business Location (Ward)",
                                                      swLabel:
                                                          "Kata Biashara Ilipo",
                                                      placeholder:
                                                          "Enter business ward",
                                                      haveError:
                                                          (_wardFieldError !=
                                                              ""),
                                                    ),
                                                    if (_wardFieldError != "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _wardFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Street Name
                                                    CIField(
                                                      inputController:
                                                          _businessStreetNameController,
                                                      engLabel:
                                                          "Business Location (Street Name)",
                                                      swLabel:
                                                          "Jina la Mtaa Biashara Ilipo",
                                                      placeholder:
                                                          "Enter business street name",
                                                      haveError:
                                                          (_streetNameFieldError !=
                                                              ""),
                                                    ),
                                                    if (_streetNameFieldError !=
                                                        "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _streetNameFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Street Number
                                                    CIField(
                                                      inputController:
                                                          _businessStreetNumberController,
                                                      engLabel:
                                                          "Business Location (Street Number)",
                                                      swLabel:
                                                          "Nambari ya Jengo Biashara Ilipo",
                                                      placeholder:
                                                          "Enter business street number",
                                                      haveError:
                                                          (_streetNumberFieldError !=
                                                              ""),
                                                    ),
                                                    if (_streetNumberFieldError !=
                                                        "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _streetNumberFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Building Name
                                                    CIField(
                                                      inputController:
                                                          _businessBuildingController,
                                                      engLabel: "Building Name",
                                                      swLabel: "Jina la Jengo",
                                                      placeholder:
                                                          "Enter building name",
                                                      haveError:
                                                          (_buildingFieldError !=
                                                              ""),
                                                    ),
                                                    if (_buildingFieldError !=
                                                        "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _buildingFieldError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Type
                                                    CILongField(
                                                      inputController:
                                                          _bizTypeC,
                                                      engLabel:
                                                          "Type of Business ",
                                                      swLabel:
                                                          "Aina ya Biashara",
                                                      placeholder:
                                                          "Explain the nature of your business",
                                                      haveError:
                                                          (_bizTypeError != ""),
                                                    ),
                                                    if (_bizTypeError != "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _bizTypeError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),

                                                    // Business Letter
                                                    CIFile(
                                                        engLabel:
                                                            "Please attach a copy of your Business License",
                                                        swLabel:
                                                            "Tafadhali ambatisha nakala ya Leseni ya Biashara yako",
                                                        setFileEncoded:
                                                            _selectbizLicenseEncoded,
                                                        fileName:
                                                            _mobStmtDocFileName,
                                                        setFileName:
                                                            _setbizLicenseDocFilename,
                                                        haveError:
                                                            (_bizLicenseDocError !=
                                                                ""),
                                                        setError:
                                                            _selectbizLicenseDocFileError),
                                                    if (_bizLicenseDocError !=
                                                        "")
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              _bizLicenseDocError,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                color: CIColors
                                                                    .errorText,
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              ],
                                            ),

                                          // Step SIX: Collateral
                                          if (_currPage == 6)
                                            Column(
                                              children: [
                                                // Choose premise type
                                                CIRadioField(
                                                  engLabel:
                                                      "Are your Business Premises Owned, Mortgaged, or Rented?",
                                                  swLabel:
                                                      "Je, Unamiliki au Kukodisha Jengo lako la Biashara?",
                                                  options: {
                                                    "Owned": [
                                                      "Fully Owned",
                                                      "Ninaimiliki"
                                                    ],
                                                    "Mortgaged": [
                                                      "Mortgaged",
                                                      "Rehaniwa"
                                                    ],
                                                    "Rented": [
                                                      "Rented",
                                                      "Nimeikodisha"
                                                    ],
                                                    "None": ["Neither", "Wala"],
                                                  },
                                                  setOption: _setPremiseType,
                                                  selectedOption: _premiseType,
                                                  haveError:
                                                      (_premiseError != ""),
                                                ),
                                                if (_premiseError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _premiseError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_premiseType == 'Owned' ||
                                                    _premiseType ==
                                                        'Mortgaged' ||
                                                    _premiseType == 'Rented')
                                                  Column(
                                                    children: [
                                                      // Bill
                                                      CIRadioField(
                                                        engLabel:
                                                            "Select One of the Bills that is in Your Name",
                                                        swLabel:
                                                            "Chagua Bili Moja Ambayo Ipo Kwenye Jina Lako",
                                                        options: {
                                                          "Electricity": [
                                                            "Electricity Bill",
                                                            "Bili ya Umeme"
                                                          ],
                                                          "Water": [
                                                            "Water Bill",
                                                            "Bili ya Maji"
                                                          ],
                                                          "None": [
                                                            "Neither",
                                                            "Wala"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setPremiseBillType,
                                                        selectedOption:
                                                            _premiseBillType,
                                                        haveError:
                                                            (_premiseBillError !=
                                                                ""),
                                                      ),
                                                      if (_premiseBillError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _premiseBillError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      if (_premiseBillType ==
                                                              'Electricity' ||
                                                          _premiseBillType ==
                                                              'Water')
                                                        Column(
                                                          children: [
                                                            if (_premiseBillType ==
                                                                'Water')
                                                              Column(children: [
                                                                // Water supply Authority
                                                                CISelectField(
                                                                  inputController:
                                                                      _waterAuthorityController,
                                                                  engLabel:
                                                                      "Select Your Water Supply Authority",
                                                                  swLabel:
                                                                      "Chagua Mamlaka ya Maji",
                                                                  placeholder:
                                                                      "Select Authority",
                                                                  options:
                                                                      ci_water_supply_authorities_list
                                                                          .keys
                                                                          .toList(),
                                                                  optionValues:
                                                                      ci_water_supply_authorities_list,
                                                                  selectOption:
                                                                      _selectWaterAuthority,
                                                                  selectedOption:
                                                                      _waterAuthority,
                                                                  haveError:
                                                                      (_waterAuthorityError !=
                                                                          ""),
                                                                ),
                                                                if (_waterAuthorityError !=
                                                                    "")
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          _waterAuthorityError,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                CIColors.errorText,
                                                                            fontSize:
                                                                                12,
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                const SizedBox(
                                                                    height: 8),

                                                                if (_waterAuthority ==
                                                                    "Other")
                                                                  Column(
                                                                    children: [
                                                                      // Other authority
                                                                      CIField(
                                                                        inputController:
                                                                            _otherAuthorityController,
                                                                        engLabel:
                                                                            "Enter your Water Supply Authority",
                                                                        swLabel:
                                                                            "Jaza Mamlaka Yako ya Maji",
                                                                        placeholder:
                                                                            "Enter your other authority",
                                                                        haveError:
                                                                            (_otherAuthorityError !=
                                                                                ""),
                                                                      ),
                                                                      if (_otherAuthorityError !=
                                                                          "")
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 16),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                _otherAuthorityError,
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
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                    ],
                                                                  ),
                                                              ]),

                                                            // Meter number
                                                            CIField(
                                                              inputController:
                                                                  _meterNumberController,
                                                              engLabel:
                                                                  "Enter Your Meter Number",
                                                              swLabel:
                                                                  "Ingiza Namba ya Mita yako",
                                                              placeholder:
                                                                  "Enter your meter number",
                                                              haveError:
                                                                  (_meterNumberError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              maxChars:
                                                                  _premiseBillType ==
                                                                          'Electricity'
                                                                      ? 11
                                                                      : 0,
                                                            ),
                                                            if (_meterNumberError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _meterNumberError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      // No bills explanation
                                                      if (_premiseBillType ==
                                                          'None')
                                                        Column(
                                                          children: [
                                                            CILongField(
                                                              inputController:
                                                                  _noBillsReasonController,
                                                              engLabel:
                                                                  "Explain in Detail Why You Don't Pay Any Utility Bills?",
                                                              swLabel:
                                                                  "Tueleze Kwa Kina Kwa Nini Haulipi Bili Yeyote?",
                                                              placeholder:
                                                                  "Explain in depth",
                                                              haveError:
                                                                  (_noBillsReasonError !=
                                                                      ""),
                                                            ),
                                                            if (_noBillsReasonError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _noBillsReasonError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),
                                                    ],
                                                  ),

                                                const SizedBox(height: 8),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Adding a Collateral to this Application May Significantly Increase your Chances of being Approved',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .secondaryColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Kuambatanisha Dhamana pamoja na hili Ombi inaweza Kuongeza kwa kiasi Kikubwa Ombi Lako Kupitishwa',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .textColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),

                                                // Collateral
                                                CIRadioField(
                                                  engLabel:
                                                      "Would You Like to Attach a Collateral with your Application? Adding a Collateral to this Application May Significantly Increase your Chances of being Approved.",
                                                  swLabel:
                                                      "Je, Ungependa Kuambatanisha Dhamana Pamoja na Ombi Lako?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption:
                                                      _setAddCollateralType,
                                                  selectedOption:
                                                      _addCollateral,
                                                  haveError:
                                                      (_addCollateralError !=
                                                          ""),
                                                ),
                                                if (_addCollateralError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _addCollateralError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_addCollateral == "Yes")
                                                  Column(
                                                    children: [
                                                      // Marital Status
                                                      CIRadioField(
                                                        engLabel:
                                                            "Marital Status",
                                                        swLabel: "Hali ya Ndoa",
                                                        options: {
                                                          "Single": [
                                                            "Single",
                                                            "Sina Ndoa"
                                                          ],
                                                          "Married": [
                                                            "Married",
                                                            "Nina Ndoa"
                                                          ],
                                                          "Divorced": [
                                                            "Divorced",
                                                            "Nina Talaka"
                                                          ],
                                                          "Widowed": [
                                                            "Widowed",
                                                            "Mgane au Mjane"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setMaritalStatusType,
                                                        selectedOption:
                                                            _maritalStatus,
                                                        haveError:
                                                            (_maritalStatusError !=
                                                                ""),
                                                      ),
                                                      if (_maritalStatusError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _maritalStatusError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      if (_maritalStatus ==
                                                          "Married")
                                                        Column(
                                                          children: [
                                                            // Spouse NIDA
                                                            CIField(
                                                              inputController:
                                                                  _spouseNIDAController,
                                                              engLabel:
                                                                  "Spouse's NIDA Number",
                                                              swLabel:
                                                                  "Nambari ya NIDA ya Mume/Mke",
                                                              placeholder:
                                                                  "Enter NIDA number",
                                                              haveError:
                                                                  (_spouseNIDAError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              maxChars: 20,
                                                            ),
                                                            if (_spouseNIDAError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spouseNIDAError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Full Name
                                                            CIField(
                                                              inputController:
                                                                  _spouseFullNameController,
                                                              engLabel:
                                                                  "Spouse's Full Name",
                                                              swLabel:
                                                                  "Jina Kamili la Mume/Mke",
                                                              placeholder:
                                                                  "Enter Full Name",
                                                              haveError:
                                                                  (_spouseFullNameError !=
                                                                      ""),
                                                            ),
                                                            if (_spouseFullNameError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spouseFullNameError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Birth Date
                                                            CIDatePicker(
                                                              dateState:
                                                                  _spouseDOBToDate,
                                                              setDateState:
                                                                  _setspouseDOBToDate,
                                                              engLabel:
                                                                  "Spouse's Date of Birth",
                                                              swLabel:
                                                                  "Tarehe ya Kuzaliwa Mume/Mke",
                                                              placeholder:
                                                                  "Pick spouse's birthdate",
                                                              isBirthDate: true,
                                                              haveError:
                                                                  (_spouseDOBToError !=
                                                                      ""),
                                                            ),
                                                            if (_spouseDOBToError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spouseDOBToError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Profession
                                                            CIField(
                                                              inputController:
                                                                  _spouseProfessionController,
                                                              engLabel:
                                                                  "Spouse's Profession",
                                                              swLabel:
                                                                  "Taaluma ya Mume/Mke",
                                                              placeholder:
                                                                  "Enter Profession",
                                                              haveError:
                                                                  (_spouseProfessionError !=
                                                                      ""),
                                                            ),
                                                            if (_spouseProfessionError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spouseProfessionError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Email
                                                            CIEmailField(
                                                              inputController:
                                                                  _spouseEmailController,
                                                              engLabel:
                                                                  "Spouse's Email",
                                                              swLabel:
                                                                  "Barua Pepe ya Mume/Mke",
                                                              placeholder:
                                                                  "Enter Email",
                                                              haveError:
                                                                  (_spouseEmailError !=
                                                                      ""),
                                                            ),
                                                            if (_spouseEmailError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spouseEmailError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Phone Number
                                                            CIPhoneField(
                                                              inputController:
                                                                  _spousePhoneController,
                                                              engLabel:
                                                                  "Spouse's Mobile Number",
                                                              swLabel:
                                                                  "Taaluma ya Mume/Mke",
                                                              haveError:
                                                                  (_spousePhoneError !=
                                                                      ""),
                                                            ),
                                                            if (_spousePhoneError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _spousePhoneError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      if (_maritalStatus ==
                                                          "Divorced")
                                                        Column(
                                                          children: [
                                                            // Divorcee NIDA
                                                            CIField(
                                                              inputController:
                                                                  _divorceeNIDAController,
                                                              engLabel:
                                                                  "Divorcee's NIDA Number",
                                                              swLabel:
                                                                  "Nambari ya NIDA ya Mtalaka/Mtalakiwa",
                                                              placeholder:
                                                                  "Enter NIDA number",
                                                              haveError:
                                                                  (_divorceeNIDAError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              maxChars: 20,
                                                            ),
                                                            if (_divorceeNIDAError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceeNIDAError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Full Name
                                                            CIField(
                                                              inputController:
                                                                  _divorceeFullNameController,
                                                              engLabel:
                                                                  "Divorcee's Full Name",
                                                              swLabel:
                                                                  "Jina Kamili la Mtalaka/Mtalakiwa",
                                                              placeholder:
                                                                  "Enter Full Name",
                                                              haveError:
                                                                  (_divorceeFullNameError !=
                                                                      ""),
                                                            ),
                                                            if (_divorceeFullNameError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceeFullNameError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Birth Date
                                                            CIDatePicker(
                                                              dateState:
                                                                  _divorceeDOBToDate,
                                                              setDateState:
                                                                  _setdivorceeDOBToDate,
                                                              engLabel:
                                                                  "Divorcee's Date of Birth",
                                                              swLabel:
                                                                  "Tarehe ya Kuzaliwa Mtalaka/Mtalakiwa",
                                                              placeholder:
                                                                  "Pick Divorcee's birthdate",
                                                              isBirthDate: true,
                                                              haveError:
                                                                  (_divorceeDOBToError !=
                                                                      ""),
                                                            ),
                                                            if (_divorceeDOBToError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceeDOBToError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Profession
                                                            CIField(
                                                              inputController:
                                                                  _divorceeProfessionController,
                                                              engLabel:
                                                                  "Divorcee's Profession",
                                                              swLabel:
                                                                  "Taaluma ya Mtalaka/Mtalakiwa",
                                                              placeholder:
                                                                  "Enter Profession",
                                                              haveError:
                                                                  (_divorceeProfessionError !=
                                                                      ""),
                                                            ),
                                                            if (_divorceeProfessionError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceeProfessionError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Email
                                                            CIEmailField(
                                                              inputController:
                                                                  _divorceeEmailController,
                                                              engLabel:
                                                                  "Divorcee's Email",
                                                              swLabel:
                                                                  "Barua Pepe ya Mtalaka/Mtalakiwa",
                                                              placeholder:
                                                                  "Enter Email",
                                                              haveError:
                                                                  (_divorceeEmailError !=
                                                                      ""),
                                                            ),
                                                            if (_divorceeEmailError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceeEmailError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Spouse Phone Number
                                                            CIPhoneField(
                                                              inputController:
                                                                  _divorceePhoneController,
                                                              engLabel:
                                                                  "Divorcee's Mobile Number",
                                                              swLabel:
                                                                  "Taaluma ya Mtalaka/Mtalakiwa",
                                                              haveError:
                                                                  (_divorceePhoneError !=
                                                                      ""),
                                                            ),
                                                            if (_divorceePhoneError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divorceePhoneError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Divorce Certificate File
                                                            CIFile(
                                                              engLabel:
                                                                  "Please attach the divorce certificate",
                                                              swLabel:
                                                                  "Tafadhali ambatisha cheti cha talaka",
                                                              setFileEncoded:
                                                                  _selectdivCertDocEncoded,
                                                              fileName:
                                                                  _divCertDocFileName,
                                                              setFileName:
                                                                  _setdivCertDocFilename,
                                                              haveError:
                                                                  (_divCertDocError !=
                                                                      ""),
                                                              setError:
                                                                  _selectdivCertDocFileError,
                                                            ),
                                                            if (_divCertDocError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _divCertDocError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            14,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      if (_maritalStatus ==
                                                          "Widowed")
                                                        Column(
                                                          children: [
                                                            // Widowed NIDA
                                                            CIField(
                                                              inputController:
                                                                  _widowNIDAController,
                                                              engLabel:
                                                                  "NIDA Number of the Deceased",
                                                              swLabel:
                                                                  "Nambari ya NIDA ya Aliyefariki",
                                                              placeholder:
                                                                  "Enter NIDA number",
                                                              haveError:
                                                                  (_widowNIDAError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              maxChars: 20,
                                                            ),
                                                            if (_widowNIDAError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _widowNIDAError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // deceased Full Name
                                                            CIField(
                                                              inputController:
                                                                  _widowFullNameController,
                                                              engLabel:
                                                                  "Full Name of the Deceased",
                                                              swLabel:
                                                                  "Jina Kamili la Aliyefariki",
                                                              placeholder:
                                                                  "Enter Full Name",
                                                              haveError:
                                                                  (_widowFullNameError !=
                                                                      ""),
                                                            ),
                                                            if (_widowFullNameError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _widowFullNameError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // deceased Birth Date
                                                            CIDatePicker(
                                                              dateState:
                                                                  _widowDOBToDate,
                                                              setDateState:
                                                                  _setwidowDOBToDate,
                                                              engLabel:
                                                                  "Date of Birth of the Deceased",
                                                              swLabel:
                                                                  "Tarehe ya Kuzaliwa Aliyefariki",
                                                              placeholder:
                                                                  "Pick the birthdate of the Deceased",
                                                              isBirthDate: true,
                                                              haveError:
                                                                  (_widowDOBToError !=
                                                                      ""),
                                                            ),
                                                            if (_widowDOBToError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _widowDOBToError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Death Certificate File
                                                            CIFile(
                                                              engLabel:
                                                                  "Please attach the death certificate of the deceased",
                                                              swLabel:
                                                                  "Tafadhali ambatisha cheti cha kifo cha aliyefariki",
                                                              setFileEncoded:
                                                                  _selectdeathCertDocEncoded,
                                                              fileName:
                                                                  _deathCertDocFileName,
                                                              setFileName:
                                                                  _setdeathCertDocFilename,
                                                              haveError:
                                                                  (_deathCertDocError !=
                                                                      ""),
                                                              setError:
                                                                  _selectdeathCertDocFileError,
                                                            ),
                                                            if (_deathCertDocError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _deathCertDocError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            14,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      // Collateral Name
                                                      CIField(
                                                        inputController:
                                                            _collateralNameController,
                                                        engLabel:
                                                            "What Collateral would you like to attach?",
                                                        swLabel:
                                                            "Ungependa kuambatanisha Dhamana gani?",
                                                        placeholder:
                                                            "Enter collateral name",
                                                        haveError:
                                                            (_collateralNameError !=
                                                                ""),
                                                      ),
                                                      if (_collateralNameError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _collateralNameError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // Collateral Value
                                                      CIField(
                                                        inputController:
                                                            _collateralValueController,
                                                        engLabel:
                                                            "Tell us the Value of your Collateral",
                                                        swLabel:
                                                            "Tuambie Thamani ya Dhamana",
                                                        placeholder:
                                                            "Enter collateral value",
                                                        haveError:
                                                            (_collateralValueError !=
                                                                ""),
                                                        onlyDigits: true,
                                                        isMoney: true,
                                                        prefix:
                                                            _selectedCurrency ??
                                                                '',
                                                      ),
                                                      if (_collateralValueError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _collateralValueError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      const SizedBox(height: 8),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 16,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                              'Government-Issued Collateral Documents that are Required / Nyaraka za Dhamana Zinazotolewa na Serikali Ambazo Zinahitajika',
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal: 16,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                children: [
                                                                  Text(
                                                                      '1. Land Title Deed / Hati Miliki ya Ardhi'),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                      '2. Motor Vehicle Registration Card / Kadi ya Usajili wa Magari'),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                      '3. Other Relevant Governement-Issued Documents / Nyaraka nyingine husika zilizotolewa na Serikali'),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                'Non-Government Issued Collateral Documents Include Stock Exchange Securities / Nyaraka zisizo za serikali zilizotolewa za dhamana ni pamoja na dhamana za ubadilishaji wa hisa'),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),

                                                      // Collateral Doc Type
                                                      CISelectField(
                                                        inputController:
                                                            _collateralDocTypeController,
                                                        engLabel:
                                                            "Select the Document you wish to Attach",
                                                        swLabel:
                                                            "Chagua Nyaraka Unayotaka Kuambatisha",
                                                        placeholder:
                                                            "Select Document Type",
                                                        options: const [
                                                          "Land Title Deed / Hati Miliki ya Ardhi",
                                                          "Motor Vehicle Registration Card",
                                                          "Investments Certificate",
                                                          "Other",
                                                        ],
                                                        selectOption:
                                                            _selectCollateralDocType,
                                                        selectedOption:
                                                            _selectedCollateralDocType,
                                                        haveError:
                                                            (_collateralDocTypeError !=
                                                                ""),
                                                      ),
                                                      if (_collateralDocTypeError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _collateralDocTypeError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      if (_selectedCollateralDocType ==
                                                          "Investments Certificate")
                                                        Column(
                                                          children: [
                                                            CISelectField(
                                                              inputController:
                                                                  _collateralInvestDocTypeController,
                                                              engLabel:
                                                                  "Select the type of Investments Certificate",
                                                              swLabel:
                                                                  "Chagua Aina ya Nyaraka ya Uwekezaji Unayotaka Kuambatisha",
                                                              placeholder:
                                                                  "Select Investmets Certificate Type",
                                                              options: const [
                                                                "Government Bonds",
                                                                "Company Stock Certificate",
                                                                "Treasury Bills",
                                                              ],
                                                              selectOption:
                                                                  _selectCollateralInvestDocType,
                                                              selectedOption:
                                                                  _selectedCollateralInvestDocType,
                                                              haveError:
                                                                  (_collateralInvestDocTypeError !=
                                                                      ""),
                                                            ),
                                                            if (_collateralInvestDocTypeError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _collateralInvestDocTypeError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      if (_selectedCollateralDocType ==
                                                          "Other")
                                                        Column(
                                                          children: [
                                                            // Other Doctype Name
                                                            CIField(
                                                              inputController:
                                                                  _otherDocTypeNameController,
                                                              engLabel:
                                                                  "What Type of Document Do You Wish to Attach?",
                                                              swLabel:
                                                                  "Unataka Kuambatisha Hati ya Aina Gani?",
                                                              placeholder:
                                                                  "Enter the document here",
                                                              haveError:
                                                                  (_otherDocTypeNameError !=
                                                                      ""),
                                                            ),
                                                            if (_otherDocTypeNameError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _otherDocTypeNameError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),

                                                      // Collateral Doc Number
                                                      CIField(
                                                        inputController:
                                                            _collateralDocNumberController,
                                                        engLabel:
                                                            "Document Number",
                                                        swLabel:
                                                            "Nambari ya Nyaraka",
                                                        placeholder:
                                                            "Enter document number",
                                                        haveError:
                                                            (_collateralDocNumberError !=
                                                                ""),
                                                        onlyDigits: true,
                                                      ),
                                                      if (_collateralDocNumberError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _collateralDocNumberError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        child: Text(
                                                          "Note: Document Number is Crucial for Identification Purposes, usually found on the top of an Official Document.",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Color(
                                                              0xff598974,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),

                                                      // Collateral File
                                                      CIFile(
                                                          engLabel:
                                                              "Attach the above-listed Collateral Document ",
                                                          swLabel:
                                                              "Tafadhali Ambatisha Waraka wa Dhamana hapo juu",
                                                          setFileEncoded:
                                                              _selectCollateralDocEncoded,
                                                          fileName:
                                                              _collateralDocFileName,
                                                          setFileName:
                                                              _setCollateralDocFilename,
                                                          haveError:
                                                              (_collateralDocError !=
                                                                  ""),
                                                          setError:
                                                              _selectCollateralDocFileError),
                                                      if (_collateralDocError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _collateralDocError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),
                                              ],
                                            ),

                                          // Step SEVEN: Referees
                                          if (_currPage == 7)
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Adding a Referee to this Application May Significantly Increase your Chances of being Approved',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .secondaryColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Kumuandikisha Mrejelewa pamoja na hili Ombi inaweza Kuongeza kwa kiasi Kikubwa Ombi Lako Kupitishwa.',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .textColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),

                                                // Add First Referee
                                                CIRadioField(
                                                  engLabel:
                                                      "Would You Like to Add a Referee to your Application?",
                                                  swLabel:
                                                      "Je, Ungependa Kuongeza Mrejelewa Pamoja na hili Ombi Lako?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption: _setaddRefOne,
                                                  selectedOption: _addRefOne,
                                                  haveError:
                                                      (_addRefOneError != ""),
                                                ),
                                                if (_addRefOneError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _addRefOneError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_addRefOne == "Yes")
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        padding: EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xffe8f5ee),
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: const Color(0xff598974), width: 1),
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Note: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff598974))),
                                                            Expanded(child: Text("Your Referee MUST NOT be a Relative / Mrejelewa Wako HATAKIWI kuwa Ndugu Yako.", style: TextStyle(fontSize: 14, color: Color(0xff598974)))),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),

                                                      // First referee NIDA
                                                      CIField(
                                                        inputController:
                                                            _refOneNIDAController,
                                                        engLabel:
                                                            "Referee's NIDA Number",
                                                        swLabel:
                                                            "Nambari ya NIDA ya Mrejelewa",
                                                        placeholder:
                                                            "Enter referee's NIDA number",
                                                        haveError:
                                                            (_refOneNIDAError !=
                                                                ""),
                                                        onlyDigits: true,
                                                        maxChars: 20,
                                                      ),
                                                      if (_refOneNIDAError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneNIDAError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee full name
                                                      CIField(
                                                        inputController:
                                                            _refOneFullNameController,
                                                        engLabel:
                                                            "Referee's Full Name",
                                                        swLabel:
                                                            "Jina Kamili la Mrejelewa",
                                                        placeholder:
                                                            "Enter referee's full name",
                                                        haveError:
                                                            (_refOneFullNameError !=
                                                                ""),
                                                      ),
                                                      if (_refOneFullNameError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneFullNameError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee DOB
                                                      CIDatePicker(
                                                        dateState:
                                                            _refOneDobDate,
                                                        setDateState:
                                                            _setRefOneDobDate,
                                                        engLabel:
                                                            "Referee's Date of Birth",
                                                        swLabel:
                                                            "Tarehe ya Kuzaliwa Mrejelewa",
                                                        placeholder:
                                                            "Pick referee's birthdate",
                                                        haveError:
                                                            (_refOneDobError !=
                                                                ""),
                                                        isBirthDate: true,
                                                      ),
                                                      if (_refOneDobError != "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneDobError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee Marital Status
                                                      CIRadioField(
                                                        engLabel:
                                                            "Marital Status",
                                                        swLabel: "Hali ya Ndoa",
                                                        options: {
                                                          "Single": [
                                                            "Single",
                                                            "Sina Ndoa"
                                                          ],
                                                          "Married": [
                                                            "Married",
                                                            "Nina Ndoa"
                                                          ],
                                                          "Divorced": [
                                                            "Divorced",
                                                            "Nina Talaka"
                                                          ],
                                                          "Widowed": [
                                                            "Widowed",
                                                            "Mgane au Mjane"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setRefOneMaritalStatusType,
                                                        selectedOption:
                                                            _refOneMaritalStatus,
                                                        haveError:
                                                            (_refOneMaritalStatusError !=
                                                                ""),
                                                      ),
                                                      if (_refOneMaritalStatusError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneMaritalStatusError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee profession
                                                      CIField(
                                                        inputController:
                                                            _refOneProfessionController,
                                                        engLabel:
                                                            "Referee's Profession",
                                                        swLabel:
                                                            "Taaluma ya Mrejelewa",
                                                        placeholder:
                                                            "Enter referee's profession",
                                                        haveError:
                                                            (_refOneProfessionError !=
                                                                ""),
                                                      ),
                                                      if (_refOneProfessionError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneProfessionError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee email
                                                      CIField(
                                                        inputController:
                                                            _refOneEmailController,
                                                        engLabel:
                                                            "Referee's Email",
                                                        swLabel:
                                                            "Barua Pepe ya Mrejelewa",
                                                        placeholder:
                                                            "Enter referee's email",
                                                        haveError:
                                                            (_refOneEmailError !=
                                                                ""),
                                                      ),
                                                      if (_refOneEmailError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOneEmailError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // First referee phone
                                                      CIPhoneField(
                                                        inputController:
                                                            _refOnePhoneController,
                                                        engLabel:
                                                            "Referee's Mobile Number ",
                                                        swLabel:
                                                            "Nambari ya Simu ya Mrejelewa",
                                                        haveError:
                                                            (_refOnePhoneError !=
                                                                ""),
                                                      ),
                                                      if (_refOnePhoneError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _refOnePhoneError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // Add Second Referee
                                                      CIRadioField(
                                                        engLabel:
                                                            "Would You Like to Add a Second Referee to your Application?",
                                                        swLabel:
                                                            "Je, Ungependa Kuongeza Mrejelewa wa Pili Pamoja kwenye hili Ombi Lako?",
                                                        options: {
                                                          "Yes": [
                                                            "Yes",
                                                            "Hapana"
                                                          ],
                                                          "No": [
                                                            "No",
                                                            "Hapana"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setaddRefTwo,
                                                        selectedOption:
                                                            _addRefTwo,
                                                        haveError:
                                                            (_addRefTwoError !=
                                                                ""),
                                                      ),
                                                      if (_addRefTwoError != "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _addRefTwoError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      if (_addRefTwo == "Yes")
                                                        Column(
                                                          children: [
                                                            Container(
                                                              width: double.infinity,
                                                              padding: EdgeInsets.all(12),
                                                              decoration: BoxDecoration(
                                                                color: const Color(0xffe8f5ee),
                                                                borderRadius: BorderRadius.circular(10),
                                                                border: Border.all(color: const Color(0xff598974), width: 1),
                                                              ),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Note: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff598974))),
                                                                  Expanded(child: Text("Your Second Referee MUST NOT be a Relative / Mrejelewa Wako wa Pili HATAKIWI kuwa Ndugu Yako.", style: TextStyle(fontSize: 14, color: Color(0xff598974)))),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee NIDA
                                                            CIField(
                                                              inputController:
                                                                  _refTwoNIDAController,
                                                              engLabel:
                                                                  "Referee's NIDA Number",
                                                              swLabel:
                                                                  "Nambari ya NIDA ya Mrejelewa",
                                                              placeholder:
                                                                  "Enter referee's NIDA number",
                                                              haveError:
                                                                  (_refTwoNIDAError !=
                                                                      ""),
                                                              onlyDigits: true,
                                                              maxChars: 20,
                                                            ),
                                                            if (_refTwoNIDAError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoNIDAError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee full name
                                                            CIField(
                                                              inputController:
                                                                  _refTwoFullNameController,
                                                              engLabel:
                                                                  "Referee's Full Name",
                                                              swLabel:
                                                                  "Jina Kamili la Mrejelewa",
                                                              placeholder:
                                                                  "Enter referee's full name",
                                                              haveError:
                                                                  (_refTwoFullNameError !=
                                                                      ""),
                                                            ),
                                                            if (_refTwoFullNameError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoFullNameError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee DOB
                                                            CIDatePicker(
                                                              dateState:
                                                                  _refTwoDobDate,
                                                              setDateState:
                                                                  _setRefTwoDobDate,
                                                              engLabel:
                                                                  "Referee's Date of Birth",
                                                              swLabel:
                                                                  "Tarehe ya Kuzaliwa Mrejelewa",
                                                              placeholder:
                                                                  "Pick referee's birthdate",
                                                              haveError:
                                                                  (_refTwoDobError !=
                                                                      ""),
                                                              isBirthDate: true,
                                                            ),
                                                            if (_refTwoDobError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoDobError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee Marital Status
                                                            CIRadioField(
                                                              engLabel:
                                                                  "Marital Status",
                                                              swLabel:
                                                                  "Hali ya Ndoa",
                                                              options: {
                                                                "Single": [
                                                                  "Single",
                                                                  "Sina Ndoa"
                                                                ],
                                                                "Married": [
                                                                  "Married",
                                                                  "Nina Ndoa"
                                                                ],
                                                                "Divorced": [
                                                                  "Divorced",
                                                                  "Nina Talaka"
                                                                ],
                                                                "Widowed": [
                                                                  "Widowed",
                                                                  "Mgane au Mjane"
                                                                ],
                                                              },
                                                              setOption:
                                                                  _setRefTwoMaritalStatusType,
                                                              selectedOption:
                                                                  _refTwoMaritalStatus,
                                                              haveError:
                                                                  (_refTwoMaritalStatusError !=
                                                                      ""),
                                                            ),
                                                            if (_refTwoMaritalStatusError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoMaritalStatusError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee profession
                                                            CIField(
                                                              inputController:
                                                                  _refTwoProfessionController,
                                                              engLabel:
                                                                  "Referee's Profession",
                                                              swLabel:
                                                                  "Taaluma ya Mrejelewa",
                                                              placeholder:
                                                                  "Enter referee's profession",
                                                              haveError:
                                                                  (_refTwoProfessionError !=
                                                                      ""),
                                                            ),
                                                            if (_refTwoProfessionError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoProfessionError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee email
                                                            CIField(
                                                              inputController:
                                                                  _refTwoEmailController,
                                                              engLabel:
                                                                  "Referee's Email",
                                                              swLabel:
                                                                  "Barua Pepe ya Mrejelewa",
                                                              placeholder:
                                                                  "Enter referee's email",
                                                              haveError:
                                                                  (_refTwoEmailError !=
                                                                      ""),
                                                            ),
                                                            if (_refTwoEmailError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoEmailError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Second referee phone
                                                            CIPhoneField(
                                                              inputController:
                                                                  _refTwoPhoneController,
                                                              engLabel:
                                                                  "Referee's Mobile Number ",
                                                              swLabel:
                                                                  "Nambari ya Simu ya Mrejelewa",
                                                              haveError:
                                                                  (_refTwoPhoneError !=
                                                                      ""),
                                                            ),
                                                            if (_refTwoPhoneError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _refTwoPhoneError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            // Add Third Referee
                                                            CIRadioField(
                                                              engLabel:
                                                                  "Would You Like to Add a Third Referee to your Application?",
                                                              swLabel:
                                                                  "Je, Ungependa Kuongeza Mrejelewa wa Tatu Pamoja kwenye hili Ombi Lako?",
                                                              options: {
                                                                "Yes": [
                                                                  "Yes",
                                                                  "Hapana"
                                                                ],
                                                                "No": [
                                                                  "No",
                                                                  "Hapana"
                                                                ],
                                                              },
                                                              setOption:
                                                                  _setaddRefThree,
                                                              selectedOption:
                                                                  _addRefThree,
                                                              haveError:
                                                                  (_addRefThreeError !=
                                                                      ""),
                                                            ),
                                                            if (_addRefThreeError !=
                                                                "")
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      _addRefThreeError,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: CIColors
                                                                            .errorText,
                                                                        fontSize:
                                                                            12,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            const SizedBox(
                                                                height: 8),

                                                            if (_addRefThree ==
                                                                "Yes")
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    width: double.infinity,
                                                                    padding: EdgeInsets.all(12),
                                                                    decoration: BoxDecoration(
                                                                      color: const Color(0xffe8f5ee),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      border: Border.all(color: const Color(0xff598974), width: 1),
                                                                    ),
                                                                    child: Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text("Note: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff598974))),
                                                                        Expanded(child: Text("Your Third Referee MUST NOT be a Relative / Mrejelewa Wako wa Tatu HATAKIWI kuwa Ndugu Yako.", style: TextStyle(fontSize: 14, color: Color(0xff598974)))),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee NIDA
                                                                  CIField(
                                                                    inputController:
                                                                        _refThreeNIDAController,
                                                                    engLabel:
                                                                        "Referee's NIDA Number",
                                                                    swLabel:
                                                                        "Nambari ya NIDA ya Mrejelewa",
                                                                    placeholder:
                                                                        "Enter referee's NIDA number",
                                                                    haveError:
                                                                        (_refThreeNIDAError !=
                                                                            ""),
                                                                    onlyDigits:
                                                                        true,
                                                                    maxChars:
                                                                        20,
                                                                  ),
                                                                  if (_refThreeNIDAError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeNIDAError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee full name
                                                                  CIField(
                                                                    inputController:
                                                                        _refThreeFullNameController,
                                                                    engLabel:
                                                                        "Referee's Full Name",
                                                                    swLabel:
                                                                        "Jina Kamili la Mrejelewa",
                                                                    placeholder:
                                                                        "Enter referee's full name",
                                                                    haveError:
                                                                        (_refThreeFullNameError !=
                                                                            ""),
                                                                  ),
                                                                  if (_refThreeFullNameError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeFullNameError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee DOB
                                                                  CIDatePicker(
                                                                    dateState:
                                                                        _refThreeDobDate,
                                                                    setDateState:
                                                                        _setRefThreeDobDate,
                                                                    engLabel:
                                                                        "Referee's Date of Birth",
                                                                    swLabel:
                                                                        "Tarehe ya Kuzaliwa Mrejelewa",
                                                                    placeholder:
                                                                        "Pick referee's birthdate",
                                                                    haveError:
                                                                        (_refThreeDobError !=
                                                                            ""),
                                                                    isBirthDate:
                                                                        true,
                                                                  ),
                                                                  if (_refThreeDobError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeDobError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee Marital Status
                                                                  CIRadioField(
                                                                    engLabel:
                                                                        "Marital Status",
                                                                    swLabel:
                                                                        "Hali ya Ndoa",
                                                                    options: {
                                                                      "Single":
                                                                          [
                                                                        "Single",
                                                                        "Sina Ndoa"
                                                                      ],
                                                                      "Married":
                                                                          [
                                                                        "Married",
                                                                        "Nina Ndoa"
                                                                      ],
                                                                      "Divorced":
                                                                          [
                                                                        "Divorced",
                                                                        "Nina Talaka"
                                                                      ],
                                                                      "Widowed":
                                                                          [
                                                                        "Widowed",
                                                                        "Mgane au Mjane"
                                                                      ],
                                                                    },
                                                                    setOption:
                                                                        _setRefThreeMaritalStatusType,
                                                                    selectedOption:
                                                                        _refThreeMaritalStatus,
                                                                    haveError:
                                                                        (_refThreeMaritalStatusError !=
                                                                            ""),
                                                                  ),
                                                                  if (_refThreeMaritalStatusError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeMaritalStatusError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee profession
                                                                  CIField(
                                                                    inputController:
                                                                        _refThreeProfessionController,
                                                                    engLabel:
                                                                        "Referee's Profession",
                                                                    swLabel:
                                                                        "Taaluma ya Mrejelewa",
                                                                    placeholder:
                                                                        "Enter referee's profession",
                                                                    haveError:
                                                                        (_refThreeProfessionError !=
                                                                            ""),
                                                                  ),
                                                                  if (_refThreeProfessionError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeProfessionError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee email
                                                                  CIField(
                                                                    inputController:
                                                                        _refThreeEmailController,
                                                                    engLabel:
                                                                        "Referee's Email",
                                                                    swLabel:
                                                                        "Barua Pepe ya Mrejelewa",
                                                                    placeholder:
                                                                        "Enter referee's email",
                                                                    haveError:
                                                                        (_refThreeEmailError !=
                                                                            ""),
                                                                  ),
                                                                  if (_refThreeEmailError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreeEmailError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),

                                                                  // Third referee phone
                                                                  CIPhoneField(
                                                                    inputController:
                                                                        _refThreePhoneController,
                                                                    engLabel:
                                                                        "Referee's Mobile Number ",
                                                                    swLabel:
                                                                        "Nambari ya Simu ya Mrejelewa",
                                                                    haveError:
                                                                        (_refThreePhoneError !=
                                                                            ""),
                                                                  ),
                                                                  if (_refThreePhoneError !=
                                                                      "")
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            _refThreePhoneError,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style:
                                                                                TextStyle(
                                                                              color: CIColors.errorText,
                                                                              fontSize: 14,
                                                                              fontStyle: FontStyle.italic,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          8),
                                                                ],
                                                              ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                              ],
                                            ),

                                          // Step EIGHT: Income
                                          if (_currPage == 8)
                                            Column(
                                              children: [
                                                // Annual income
                                                CIField(
                                                  inputController:
                                                      _bizAnnualIncomeController,
                                                  engLabel:
                                                      "What is your total ANNUAL income for you business?",
                                                  swLabel:
                                                      "Jumla ya mapato yako ya MWAKA kutoka kwa biashara yako ni kiasi gani?",
                                                  placeholder:
                                                      "Enter total annual income",
                                                  haveError:
                                                      (_bizAnnualIncomeError !=
                                                          ""),
                                                  onlyDigits: true,
                                                  isMoney: true,
                                                  prefix:
                                                      _selectedCurrency ?? '',
                                                ),
                                                if (_bizAnnualIncomeError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _bizAnnualIncomeError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // Show supplimental income?
                                                CIRadioField(
                                                  engLabel:
                                                      "Do You have a Supplemental Income from any Other Business or Venture?",
                                                  swLabel:
                                                      "Je, una Mapato ya ziada Kutoka Mradi au Biashara Nyingine?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption:
                                                      _setAddSupplIncomeType,
                                                  selectedOption:
                                                      _addSupplIncome,
                                                  haveError:
                                                      (_addSupplIncomeError !=
                                                          ""),
                                                ),
                                                if (_addSupplIncomeError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _addSupplIncomeError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_addSupplIncome == "Yes")
                                                  Column(
                                                    children: [
                                                      // Supplimental Income Source
                                                      CIField(
                                                        inputController:
                                                            _supplSourceController,
                                                        engLabel:
                                                            "List the Source of your Supplemental Income, if any.",
                                                        swLabel:
                                                            "Tafadhali Orodhesha Chanzo cha Mapato yako ya ziada, ikiwa yapo",
                                                        placeholder:
                                                            "Enter source of supplimental income",
                                                        haveError:
                                                            (_supplSourceError !=
                                                                ""),
                                                      ),
                                                      if (_supplSourceError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _supplSourceError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),

                                                      // Supplimental Income Source
                                                      CIField(
                                                        inputController:
                                                            _supplTotalController,
                                                        engLabel:
                                                            "What is your total ANNUAL Supplemental NET Income from any Other Business or Venture?",
                                                        swLabel:
                                                            "Jumla ya Mapato Yako ya MWAKA kutoka Biashara au Mradi Wowote ni Kiasi Gani?",
                                                        placeholder:
                                                            "Enter total net annual supplimental income",
                                                        haveError:
                                                            (_supplTotalError !=
                                                                ""),
                                                        onlyDigits: true,
                                                        isMoney: true,
                                                        prefix:
                                                            _selectedCurrency ??
                                                                '',
                                                      ),
                                                      if (_supplTotalError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _supplTotalError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),

                                                // Bank statement File
                                                CIFile(
                                                    engLabel:
                                                        "Attach a copy of your Bank Statement (6 months)",
                                                    swLabel:
                                                        "Tafadhali ambatisha nakala ya Taarifa ya Benki (miezi 6)",
                                                    setFileEncoded:
                                                        _selectBankStmtDocEncoded,
                                                    fileName: _bankStmtFileName,
                                                    setFileName:
                                                        _setBankStmtFilename,
                                                    haveError:
                                                        (_bankStmtDocError !=
                                                            ""),
                                                    setError:
                                                        _selectBankStmtDocFileError),
                                                if (_bankStmtDocError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _bankStmtDocError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),
//added here
                                                CIRadioField(
                                                  engLabel:
                                                      "Would you like to add another Bank statement?",
                                                  swLabel:
                                                      "Je, ungependa kuongeza nakala ya taarifa ya benki?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption:
                                                      _setBankStatementType,
                                                  selectedOption:
                                                      _addBankStatement,
                                                  haveError:
                                                      (_addBankStatementError !=
                                                          ""),
                                                ),
                                                if (_addBankStatement == "Yes")
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      CIFile(
                                                          engLabel:
                                                              "Attach a copy of your Bank Statement (6 months)",
                                                          swLabel:
                                                              "Tafadhali ambatisha nakala ya Taarifa ya Benki (miezi 6)",
                                                          setFileEncoded:
                                                              _selectBankStmtDocEncoded2,
                                                          fileName:
                                                              _bankStmtFileName2,
                                                          setFileName:
                                                              _setBankStmtFilename2,
                                                          haveError:
                                                              (_bankStmtDocError2 !=
                                                                  ""),
                                                          setError:
                                                              _selectBankStmtDocFileError2),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      CIRadioField(
                                                        engLabel:
                                                            "Would you like to add another Bank statement?",
                                                        swLabel:
                                                            "Je, ungependa kuongeza nakala ya taarifa ya benki?",
                                                        options: {
                                                          "Yes": [
                                                            "Yes",
                                                            "Ndio"
                                                          ],
                                                          "No": [
                                                            "No",
                                                            "Hapana"
                                                          ],
                                                        },
                                                        setOption:
                                                            _setBankStatementType2,
                                                        selectedOption:
                                                            _addBankStatement2,
                                                        haveError:
                                                            (_addBankStatementError2 !=
                                                                ""),
                                                      ),
                                                    ],
                                                  ),

                                                //to here
                                                SizedBox(
                                                  height: 8,
                                                )
                                              ],
                                            ),
                                          if (_addBankStatement2 == "Yes")
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                CIFile(
                                                    engLabel:
                                                        "Attach a copy of your Bank Statement (6 months)",
                                                    swLabel:
                                                        "Tafadhali ambatisha nakala ya Taarifa ya Benki (miezi 6)",
                                                    setFileEncoded:
                                                        _selectBankStmtDocEncoded3,
                                                    fileName:
                                                        _bankStmtFileName3,
                                                    setFileName:
                                                        _setBankStmtFilename3,
                                                    haveError:
                                                        (_bankStmtDocError3 !=
                                                            ""),
                                                    setError:
                                                        _selectBankStmtDocFileError3),
                                                SizedBox(
                                                  height: 8,
                                                ),

                                                //to here
                                                SizedBox(
                                                  height: 8,
                                                )
                                              ],
                                            ),

                                          // Step NINE: Mobile Statement
                                          if (_currPage == 9)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'Adding a Mobile Money Statement to this Application may Significantly Contribute to your Chances of being Approved',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .secondaryColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Kuambatisha taarifa hizo pamoja na hili Ombi inaweza Kuongeza kwa kiasi Kikubwa Ombi Lako Kupitishwa.',
                                                        style: TextStyle(
                                                          color: CIColors
                                                              .textColor,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),

                                                // Show mobile statement?
                                                CIRadioField(
                                                  engLabel:
                                                      "Would You Like to Add your Mobile Money Statement that shows Transactions over the Past 6 Months?",
                                                  swLabel:
                                                      "Je, Ungependa Kutoa Taarifa yako ya Muamala za Simu ya Mkononi kwa kipindi cha miezi 6 iliyopita?",
                                                  options: {
                                                    "Yes": ["Yes", "Ndio"],
                                                    "No": ["No", "Hapana"],
                                                  },
                                                  setOption:
                                                      _setAddMobileStmtType,
                                                  selectedOption:
                                                      _addMobileStmt,
                                                  haveError:
                                                      (_addMobileStmtError !=
                                                          ""),
                                                ),
                                                if (_addMobileStmtError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _addMobileStmtError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                if (_addMobileStmt == "Yes")
                                                  Column(
                                                    children: [
                                                      // Mobile STMT File
                                                      CIFile(
                                                          engLabel:
                                                              "Attach a copy of your Mobile Money Statement (6 months)",
                                                          swLabel:
                                                              "Tafadhali ambatisha nakala ya Taarifa ya Simu Pesa (miezi 6)",
                                                          setFileEncoded:
                                                              _selectmobStmtDocEncoded,
                                                          fileName:
                                                              _mobStmtDocFileName,
                                                          setFileName:
                                                              _setMobStmtDocFilename,
                                                          haveError:
                                                              (_mobStmtDocError !=
                                                                  ""),
                                                          setError:
                                                              _selectmobStmtDocFileError),
                                                      if (_mobStmtDocError !=
                                                          "")
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                _mobStmtDocError,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style:
                                                                    TextStyle(
                                                                  color: CIColors
                                                                      .errorText,
                                                                  fontSize: 14,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      const SizedBox(height: 8),
                                                    ],
                                                  ),
                                              ],
                                            ),

                                          // Step TEN: NIDA and other files
                                          if (_currPage == 10)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // NIDA File
                                                CIFile(
                                                    engLabel:
                                                        "Attach a copy of your NIDA Card",
                                                    swLabel:
                                                        "Tafadhali Ambatisha Nakala ya Kitambulisho Chako cha NIDA",
                                                    setFileEncoded:
                                                        _selectNIDADocEncoded,
                                                    fileName: _nidaDocFileName,
                                                    setFileName:
                                                        _setNIDADocFilename,
                                                    haveError:
                                                        (_nidaDocError != ""),
                                                    setError:
                                                        _selectNIDADocFileError),
                                                if (_nidaDocError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _nidaDocError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),

                                                // Other File
                                                CIFile(
                                                    engLabel:
                                                        "OPTIONAL: Please Attach any other Relevant Documents that could Enhance Your Application",
                                                    swLabel:
                                                        "HIARI: Tafadhali Ambatisha Nyaraka Nyinginezo Ambazo Zinaweza Kuboresha Ombi Yako",
                                                    setFileEncoded:
                                                        _selectOtherDocEncoded,
                                                    setFilesEncoded:
                                                        _selectOtherDocsEncoded,
                                                    fileName: _otherDocFileName,
                                                    setFileName:
                                                        _setOtherDocFilename,
                                                    allowMultipleFiles: true,
                                                    haveError:
                                                        (_otherDocError != ""),
                                                    setError:
                                                        _selectOtherDocFileError),
                                                if (_otherDocFileName != null &&
                                                    _otherDocFileName!
                                                            .split(',')
                                                            .length >
                                                        1)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Selected Files:",
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .secondaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        ..._otherDocFileName!
                                                            .split(',')
                                                            .map(
                                                              (e) => Text(
                                                                " - ${e.trim()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .italic,
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                  ),
                                                if (_otherDocError != "")
                                                  Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _otherDocError,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: CIColors
                                                                .errorText,
                                                            fontSize: 14,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),

                                          SizedBox(height: 8),

                                          // Action buttons
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (_currPage == 1) Spacer(),
                                              if (_currPage > 1)
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      if (_currPage > 1) {
                                                        _currPage =
                                                            _currPage - 1;
                                                      }
                                                    });
                                                    _scrollToTop();
                                                  },
                                                  style: mainButtonStyle,
                                                  child: Text(
                                                    'Back',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              if (_currPage < _pagesCount)
                                                ElevatedButton(
                                                  onPressed: () {
                                                    if (_isFormValid(context)) {
                                                      setState(() {
                                                        if (_currPage <
                                                            _pagesCount) {
                                                          _currPage =
                                                              _currPage + 1;
                                                        }
                                                      });
                                                      _scrollToTop();
                                                    }
                                                  },
                                                  style: mainButtonStyle,
                                                  child: Text(
                                                    'Next',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              if (_currPage == _pagesCount)
                                                ElevatedButton(
                                                  onPressed: _isLoading
                                                      ? null
                                                      : () {
                                                          if (_isFormValid(
                                                              context)) {
                                                            _handleSubmit(
                                                                context);
                                                          }
                                                        },
                                                  style: mainButtonStyle,
                                                  child: _isLoading
                                                      ? SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      : Text(
                                                          'Submit',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      // Page 4
      _loanAmountError = "";
      _loanCurrencyError = "";
      _loanFacilityError = "";
      _loanPurposeError = "";
      _bizLicenseError = "";
      _bizNameError = "";
      _regionFieldError = "";
      _districtFieldError = "";
      _wardFieldError = "";
      _streetNameFieldError = "";
      _streetNumberFieldError = "";
      _buildingFieldError = "";
      _bizTypeError = "";
      _bizLicenseDocError = "";

      _institutionOneError = "";
      _loanTypeOneError = "";
      _prevLoanBalanceOneError = "";
      _existingLoanTwoError = "";
      _institutionTwoError = "";
      _loanTypeTwoError = "";
      _prevLoanBalanceTwoError = "";
      _existingLoanThreeError = "";
      _institutionThreeError = "";
      _loanTypeThreeError = "";
      _prevLoanBalanceThreeError = "";
      // Page 5
      _premiseError = "";
      _premiseBillError = "";
      _waterAuthorityError = "";
      _meterNumberError = "";
      _noBillsReasonError = "";
      _otherAuthorityError = "";
      _addCollateralError = "";
      _maritalStatusError = "";
      _spouseNIDAError = "";
      _spouseFullNameError = "";
      _spouseDOBToError = "";
      _spouseProfessionError = "";
      _spouseEmailError = "";
      _spousePhoneError = "";
      _divorceeNIDAError = "";
      _divorceeFullNameError = "";
      _divorceeDOBToError = "";
      _divorceeProfessionError = "";
      _divorceeEmailError = "";
      _divorceePhoneError = "";
      _widowNIDAError = "";
      _widowFullNameError = "";
      _widowDOBToError = "";
      _collateralNameError = "";
      _collateralValueError = "";
      _collateralDocTypeError = "";
      _otherDocTypeNameError = "";
      _collateralDocNumberError = "";
      _collateralDocError = "";
      _deathCertDocError = "";
      _divCertDocError = "";
      // Page 6
      _addRefOneError = "";
      _refOneNIDAError = "";
      _refOneFullNameError = "";
      _refOneDobError = "";
      _refOneMaritalStatusError = "";
      _refOneProfessionError = "";
      _refOneEmailError = "";
      _refOnePhoneError = "";
      _addRefTwoError = "";
      _refTwoNIDAError = "";
      _refTwoFullNameError = "";
      _refTwoDobError = "";
      _refTwoMaritalStatusError = "";
      _refTwoProfessionError = "";
      _refTwoEmailError = "";
      _refTwoPhoneError = "";
      _addRefThreeError = "";
      _refThreeNIDAError = "";
      _refThreeFullNameError = "";
      _refThreeDobError = "";
      _refThreeMaritalStatusError = "";
      _refThreeProfessionError = "";
      _refThreeEmailError = "";
      _refThreePhoneError = "";
      // Page 7
      _bizAnnualIncomeError = "";
      _addSupplIncomeError = "";
      _supplSourceError = "";
      _supplTotalError = "";
      _monthlySalaryError = "";
      _yearlyBonusError = "";
      _salaryBankError = "";
      _bankAccountNumberError = "";
      _bankStmtDocError = "";
      // Page 8
      _addMobileStmtError = "";
      _mobStmtDocError = "";
      // Page 9
      _nidaDocError = "";
    });
  }

  bool _startsWith19or20(String str) {
    return str.startsWith('19') || str.startsWith('20');
  }

  bool _isFormValid(context) {
    _clearErrors();
    bool isValid = true;

    if (_currPage >= 4) {
      // Loan facility
      if (_selectedLoanFacility == null) {
        setState(() {
          _loanFacilityError = "Please select loan facility";
        });
        isValid = false;
      }

      // Currency
      if (_selectedCurrency == null) {
        setState(() {
          _loanCurrencyError = "Please choose currency";
        });
        isValid = false;
      }

      // Purpose
      if (_loanPurposeC.text.isEmpty) {
        setState(() {
          _loanPurposeError = "Please enter purpose";
        });
        isValid = false;
      }

      // Amount
      if (_loanAmountController.text.isEmpty || _loanAmountController.text.length < 8 ) {
        setState(() {
          _loanAmountError = "Please enter amount of atleast 1M TZS";
        });
        isValid = false;
      }

      // Existing loans one
      if (_existingLoanOne.isEmpty) {
        setState(() {
          _existingLoanOneError = "Please choose if you have existing loans";
        });
        isValid = false;
      } else if (_existingLoanOne == "Yes") {
        // Institution one
        if (_institutionOne == null) {
          setState(() {
            _institutionOneError = "Please choose loan institution";
          });
          isValid = false;
        }
        // loan facility type one
        if (_loanFacilityTypeOne.isEmpty) {
          setState(() { _loanFacilityTypeOneError = "Please choose credit facility type"; });
          isValid = false;
        }
        // loan type one
        if (_loanFacilityTypeOne == "Other") {
          if (_otherFacilityOneController.text.isEmpty) {
            setState(() { _loanTypeOneError = "Please enter the other credit facility"; });
            isValid = false;
          }
        } else if (_loanTypeOne == null) {
          setState(() { _loanTypeOneError = "Please choose loan type"; });
          isValid = false;
        }
        // Loan balance
        if (_prevLoanBalanceOneController.text.isEmpty) {
          setState(() {
            _prevLoanBalanceOneError = "Please enter loan balance";
          });
          isValid = false;
        }
        // Second Existing loans?
        if (_existingLoanTwo.isEmpty) {
          setState(() {
            _existingLoanTwoError =
                "Please choose if you have any other existing loans";
          });
          isValid = false;
        } else if (_existingLoanTwo == "Yes") {
          // Institution Two
          if (_institutionTwo == null) {
            setState(() {
              _institutionTwoError = "Please choose loan institution";
            });
            isValid = false;
          }
          // loan facility type two
          if (_loanFacilityTypeTwo.isEmpty) {
            setState(() { _loanFacilityTypeTwoError = "Please choose credit facility type"; });
            isValid = false;
          }
          // loan type two
          if (_loanFacilityTypeTwo == "Other") {
            if (_otherFacilityTwoController.text.isEmpty) {
              setState(() { _loanTypeTwoError = "Please enter the other credit facility"; });
              isValid = false;
            }
          } else if (_loanTypeTwo == null) {
            setState(() { _loanTypeTwoError = "Please choose loan type"; });
            isValid = false;
          }
          // Loan balance
          if (_prevLoanBalanceTwoController.text.isEmpty) {
            setState(() {
              _prevLoanBalanceTwoError = "Please enter loan balance";
            });
            isValid = false;
          }
          // Third Existing loans?
          if (_existingLoanThree.isEmpty) {
            setState(() {
              _existingLoanThreeError =
                  "Please choose if you have any other existing loans";
            });
            isValid = false;
          } else if (_existingLoanThree == "Yes") {
            // Institution Three
            if (_institutionThree == null) {
              setState(() {
                _institutionThreeError = "Please choose loan institution";
              });
              isValid = false;
            }
            // loan facility type three
            if (_loanFacilityTypeThree.isEmpty) {
              setState(() { _loanFacilityTypeThreeError = "Please choose credit facility type"; });
              isValid = false;
            }
            // loan type three
            if (_loanFacilityTypeThree == "Other") {
              if (_otherFacilityThreeController.text.isEmpty) {
                setState(() { _loanTypeThreeError = "Please enter the other credit facility"; });
                isValid = false;
              }
            } else if (_loanTypeThree == null) {
              setState(() { _loanTypeThreeError = "Please choose loan type"; });
              isValid = false;
            }
            // Loan balance
            if (_prevLoanBalanceThreeController.text.isEmpty) {
              setState(() {
                _prevLoanBalanceThreeError = "Please enter loan balance";
              });
              isValid = false;
            }
          }
        }
      }
    }

    if (_currPage >= 5) {
      // Biz license number
      if (_bizLicenseController.text.isEmpty) {
        setState(() {
          _bizLicenseError = "Please enter your business license number";
        });
        isValid = false;
      }
      // Biz name
      if (_bizNameController.text.isEmpty) {
        setState(() {
          _bizNameError = "Please enter your business legal name";
        });
        isValid = false;
      }
      // Biz region
      if (_selectedRegion == null) {
        setState(() {
          _regionFieldError = "Please select your business region";
        });
        isValid = false;
      }
      // Biz district
      if (_selectedDistrict == null) {
        setState(() {
          _districtFieldError = "Please select your business district";
        });
        isValid = false;
      }
      // Biz ward
      if (_businessWardController.text.isEmpty) {
        setState(() {
          _wardFieldError = "Please enter your business ward";
        });
        isValid = false;
      }
      // Biz street name
      if (_businessStreetNameController.text.isEmpty) {
        setState(() {
          _streetNameFieldError = "Please enter your business street name";
        });
        isValid = false;
      }
      // Biz street number
      if (_businessStreetNumberController.text.isEmpty) {
        setState(() {
          _streetNumberFieldError = "Please enter your business street number";
        });
        isValid = false;
      }
      // Biz building
      if (_businessBuildingController.text.isEmpty) {
        setState(() {
          _buildingFieldError = "Please enter building name";
        });
        isValid = false;
      }
      // Biz type
      if (_bizTypeC.text.isEmpty) {
        setState(() {
          _bizTypeError = "Please enter type of business";
        });
        isValid = false;
      }

      // employment letter doc
      if (_encodedbizLicenseDoc == null) {
        setState(() {
          _bizLicenseDocError = "Please attach your business license document";
        });
        isValid = false;
      }
    }

    if (_currPage >= 6) {
      // premises ownership
      if (_premiseType.isEmpty) {
        setState(() {
          _premiseError = "Please choose one option";
        });
        isValid = false;
      } else if (_premiseType != "None") {
        // bill type
        if (_premiseBillType.isEmpty) {
          setState(() {
            _premiseBillError = "Please choose one option";
          });
          isValid = false;
        } else if (_premiseBillType != "None") {
          if (_premiseBillType == "Water") {
            // water authoriry
            if (_waterAuthority == null) {
              setState(() {
                _waterAuthorityError = "Please choose water supply authority";
              });
              isValid = false;
            }

            // other water authoriry
            if (_waterAuthority == "Other") {
              if (_otherAuthorityController.text.isEmpty) {
                setState(() {
                  _otherAuthorityError =
                      "Please enter your water supply authority";
                });
                isValid = false;
              }
            }
          }

          // meter number
          if (_meterNumberController.text.isEmpty) {
            setState(() {
              _meterNumberError = "Please enter meter number";
            });
            isValid = false;
          }
        } else {
          //is none
          // no bils reason
          if (_noBillsReasonController.text.isEmpty) {
            setState(() {
              _noBillsReasonError = "Please enter explanation";
            });
            isValid = false;
          }
        }
      }

      // adding collateral
      if (_addCollateral.isEmpty) {
        setState(() {
          _addCollateralError = "Please choose if your want to add collateral";
        });
        isValid = false;
      } else if (_addCollateral == "Yes") {
        // marital status
        if (_maritalStatus.isEmpty) {
          setState(() {
            _maritalStatusError = "Please select you marital status";
          });
          isValid = false;
        } else if (_maritalStatus == "Married") {
          // spouse nida
          if (_spouseNIDAController.text.isEmpty) {
            setState(() {
              _spouseNIDAError = "Please enter spouse's NIDA number";
            });
            isValid = false;
          } else if (_spouseNIDAController.text.length != 20 ||
              !_startsWith19or20(_spouseNIDAController.text)) {
            setState(() {
              _spouseNIDAError = "Please enter a valid NIDA number";
            });
            isValid = false;
          }
          // spouse full name
          if (_spouseFullNameController.text.isEmpty) {
            setState(() {
              _spouseFullNameError = "Please enter spouse's full name";
            });
            isValid = false;
          }
          // spouse birthdate
          if (_spouseDOBToDate == null) {
            setState(() {
              _spouseDOBToError = "Please pick spouse's birthdate";
            });
            isValid = false;
          }
          // spouse profession
          if (_spouseProfessionController.text.isEmpty) {
            setState(() {
              _spouseProfessionError = "Please enter spouse's profession";
            });
            isValid = false;
          }
          // spouse email
          if (_spouseEmailController.text.isEmpty) {
            setState(() {
              _spouseEmailError = "Please enter spouse's email";
            });
            isValid = false;
          } else if (!RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
              .hasMatch(_spouseEmailController.text)) {
            setState(() {
              _spouseEmailError =
                  "Please provide a valid spouse's email address";
            });
            isValid = false;
          }
          // spouse profession
          if (_spousePhoneController.text.isEmpty) {
            setState(() {
              _spousePhoneError = "Please enter spouse's mobile number";
            });
            isValid = false;
          }
        } else if (_maritalStatus == "Divorced") {
          // divorcee nida
          if (_divorceeNIDAController.text.isEmpty) {
            setState(() {
              _divorceeNIDAError = "Please enter divorcee's NIDA number";
            });
            isValid = false;
          } else if (_divorceeNIDAController.text.length != 20 ||
              !_startsWith19or20(_divorceeNIDAController.text)) {
            setState(() {
              _divorceeNIDAError = "Please enter a valid NIDA number";
            });
            isValid = false;
          }
          // divorcee full name
          if (_divorceeFullNameController.text.isEmpty) {
            setState(() {
              _divorceeFullNameError = "Please enter divorcee's full name";
            });
            isValid = false;
          }
          // divorcee birthdate
          if (_divorceeDOBToDate == null) {
            setState(() {
              _divorceeDOBToError = "Please pick divorcee's birthdate";
            });
            isValid = false;
          }
          // divorcee profession
          if (_divorceeProfessionController.text.isEmpty) {
            setState(() {
              _divorceeProfessionError = "Please enter divorcee's profession";
            });
            isValid = false;
          }
          // divorcee email
          if (_divorceeEmailController.text.isEmpty) {
            setState(() {
              _divorceeEmailError = "Please enter divorcee's email";
            });
            isValid = false;
          } else if (!RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
              .hasMatch(_divorceeEmailController.text)) {
            setState(() {
              _divorceeEmailError =
                  "Please provide a valid divorcee's email address";
            });
            isValid = false;
          }
          // divorcee profession
          if (_divorceePhoneController.text.isEmpty) {
            setState(() {
              _divorceePhoneError = "Please enter divorcee's mobile number";
            });
            isValid = false;
          }

          // divorce cert doc type
          if (_encodeddivCertDoc == null) {
            setState(() {
              _divCertDocError = "Please attach divorce certificate document";
            });
            isValid = false;
          }
        } else if (_maritalStatus == "Widowed") {
          // deceased nida
          if (_widowNIDAController.text.isEmpty) {
            setState(() {
              _widowNIDAError = "Please enter NIDA number of the deceased";
            });
            isValid = false;
          } else if (_widowNIDAController.text.length != 20 ||
              !_startsWith19or20(_widowNIDAController.text)) {
            setState(() {
              _widowNIDAError = "Please enter a valid NIDA number";
            });
            isValid = false;
          }
          // deceased full name
          if (_widowFullNameController.text.isEmpty) {
            setState(() {
              _widowFullNameError = "Please enter full name of the deceased";
            });
            isValid = false;
          }
          // deceased birthdate
          if (_widowDOBToDate == null) {
            setState(() {
              _widowDOBToError = "Please pick the birthdate of the deceased";
            });
            isValid = false;
          }

          // death cert doc type
          if (_encodeddeathCertDoc == null) {
            setState(() {
              _deathCertDocError = "Please attach death certificate document";
            });
            isValid = false;
          }
        }

        // collateral name
        if (_collateralNameController.text.isEmpty) {
          setState(() {
            _collateralNameError = "Please enter collateral name";
          });
          isValid = false;
        }
        // collateral value
        if (_collateralValueController.text.isEmpty) {
          setState(() {
            _collateralValueError = "Please enter collateral value";
          });
          isValid = false;
        }
        // collateral doc type
        if (_selectedCollateralDocType == null) {
          setState(() {
            _collateralDocTypeError = "Please select document type";
          });
          isValid = false;
        } else if (_selectedCollateralDocType == "Other") {
          // other collateral doc type
          if (_otherDocTypeNameController.text.isEmpty) {
            setState(() {
              _otherDocTypeNameError = "Please enter document type";
            });
            isValid = false;
          }
        } else if (_selectedCollateralDocType == "Investments Certificate") {
          // Investmentss collateral doc type
          if (_selectedCollateralInvestDocType == null) {
            setState(() {
              _collateralInvestDocTypeError =
                  "Please select investments certificate type";
            });
            isValid = false;
          }
        }
        // collateral doc number
        if (_collateralDocNumberController.text.isEmpty) {
          setState(() {
            _collateralDocNumberError = "Please enter document number";
          });
          isValid = false;
        }
        // collateral doc type
        if (_encodedCollateralDoc == null) {
          setState(() {
            _collateralDocError = "Please attach collateral document";
          });
          isValid = false;
        }
      }
    }

    if (_currPage >= 7) {
      // add referee one
      if (_addRefOne.isEmpty) {
        setState(() {
          _addRefOneError = "Please choose if you would like to add a referee";
        });
        isValid = false;
      } else if (_addRefOne == "Yes") {
        // referee one nida
        if (_refOneNIDAController.text.isEmpty) {
          setState(() {
            _refOneNIDAError = "Please enter referee's NIDA number";
          });
          isValid = false;
        } else if (_refOneNIDAController.text.length != 20 ||
            !_startsWith19or20(_refOneNIDAController.text)) {
          setState(() {
            _refOneNIDAError = "Please enter a valid NIDA number";
          });
          isValid = false;
        } else if (_refOneNIDAController.text == authProvider.userData['nida-no']) {
          setState(() {
            _refOneNIDAError = "You cannot use your own NIDA number as a referee";
          });
          isValid = false;
        }
        // referee one fullname
        if (_refOneFullNameController.text.isEmpty) {
          setState(() {
            _refOneFullNameError = "Please enter referee's full name";
          });
          isValid = false;
        }
        // referee one birthdate
        if (_refOneDobDate == null) {
          setState(() {
            _refOneDobError = "Please pick referee's birthdate";
          });
          isValid = false;
        }
        // referee one birthdate
        if (_refOneMaritalStatus.isEmpty) {
          setState(() {
            _refOneMaritalStatusError =
                "Please choose referee's marital status";
          });
          isValid = false;
        }
        // referee one birthdate
        if (_refOneProfessionController.text.isEmpty) {
          setState(() {
            _refOneProfessionError = "Please enter referee's profession";
          });
          isValid = false;
        }
        // referee one birthdate
        if (_refOneEmailController.text.isEmpty) {
          setState(() {
            _refOneEmailError = "Please enter referee's email";
          });
          isValid = false;
        } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
            .hasMatch(_refOneEmailController.text)) {
          setState(() {
            _refOneEmailError =
                "Please provide a valid referee's email address";
          });
          isValid = false;
        }
        // referee one phone
        if (_refOnePhoneController.text.isEmpty) {
          setState(() {
            _refOnePhoneError = "Please enter referee's mobile number";
          });
          isValid = false;
        }

        // add referee two
        if (_addRefTwo.isEmpty) {
          setState(() {
            _addRefTwoError =
                "Please choose if you would like to add a referee";
          });
          isValid = false;
        } else if (_addRefTwo == "Yes") {
          // referee two nida
          if (_refTwoNIDAController.text.isEmpty) {
            setState(() {
              _refTwoNIDAError = "Please enter referee's NIDA number";
            });
            isValid = false;
          } else if (_refTwoNIDAController.text.length != 20 ||
              !_startsWith19or20(_refTwoNIDAController.text)) {
            setState(() {
              _refTwoNIDAError = "Please enter a valid NIDA number";
            });
            isValid = false;
          }
          // referee two fullname
          if (_refTwoFullNameController.text.isEmpty) {
            setState(() {
              _refTwoFullNameError = "Please enter referee's full name";
            });
            isValid = false;
          }
          // referee two birthdate
          if (_refTwoDobDate == null) {
            setState(() {
              _refTwoDobError = "Please pick referee's birthdate";
            });
            isValid = false;
          }
          // referee two birthdate
          if (_refTwoMaritalStatus.isEmpty) {
            setState(() {
              _refTwoMaritalStatusError =
                  "Please choose referee's marital status";
            });
            isValid = false;
          }
          // referee two birthdate
          if (_refTwoProfessionController.text.isEmpty) {
            setState(() {
              _refTwoProfessionError = "Please enter referee's profession";
            });
            isValid = false;
          }
          // referee two birthdate
          if (_refTwoEmailController.text.isEmpty) {
            setState(() {
              _refTwoEmailError = "Please enter referee's email";
            });
            isValid = false;
          } else if (!RegExp(
                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
              .hasMatch(_refTwoEmailController.text)) {
            setState(() {
              _refTwoEmailError =
                  "Please provide a valid referee's email address";
            });
            isValid = false;
          }
          // referee two phone
          if (_refTwoProfessionController.text.isEmpty) {
            setState(() {
              _refTwoPhoneError = "Please enter referee's mobile number";
            });
            isValid = false;
          }

          // add referee three
          if (_addRefThree.isEmpty) {
            setState(() {
              _addRefThreeError =
                  "Please choose if you would like to add a referee";
            });
            isValid = false;
          } else if (_addRefThree == "Yes") {
            // referee three nida
            if (_refThreeNIDAController.text.isEmpty) {
              setState(() {
                _refThreeNIDAError = "Please enter referee's NIDA number";
              });
              isValid = false;
            } else if (_refThreeNIDAController.text.length != 20 ||
                !_startsWith19or20(_refThreeNIDAController.text)) {
              setState(() {
                _refThreeNIDAError = "Please enter a valid NIDA number";
              });
              isValid = false;
            }
            // referee three fullname
            if (_refThreeFullNameController.text.isEmpty) {
              setState(() {
                _refThreeFullNameError = "Please enter referee's full name";
              });
              isValid = false;
            }
            // referee three birthdate
            if (_refThreeDobDate == null) {
              setState(() {
                _refThreeDobError = "Please pick referee's birthdate";
              });
              isValid = false;
            }
            // referee three birthdate
            if (_refThreeMaritalStatus.isEmpty) {
              setState(() {
                _refThreeMaritalStatusError =
                    "Please choose referee's marital status";
              });
              isValid = false;
            }
            // referee three birthdate
            if (_refThreeProfessionController.text.isEmpty) {
              setState(() {
                _refThreeProfessionError = "Please enter referee's profession";
              });
              isValid = false;
            }
            // referee three birthdate
            if (_refThreeEmailController.text.isEmpty) {
              setState(() {
                _refThreeEmailError = "Please enter referee's email";
              });
              isValid = false;
            } else if (!RegExp(
                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(_refThreeEmailController.text)) {
              setState(() {
                _refThreeEmailError =
                    "Please provide a valid referee's email address";
              });
              isValid = false;
            }
            // referee three phone
            if (_refThreeProfessionController.text.isEmpty) {
              setState(() {
                _refThreePhoneError = "Please enter referee's mobile number";
              });
              isValid = false;
            }
          }
        }
      }
    }

    if (_currPage >= 8) {
      // annual biz income
      if (_bizAnnualIncomeController.text.isEmpty) {
        setState(() {
          _bizAnnualIncomeError = "Please enter total annual income";
        });
        isValid = false;
      }

      // have suppl income?
      if (_addSupplIncome.isEmpty) {
        setState(() {
          _addSupplIncomeError =
              "Please choose if you have supplimental income";
        });
        isValid = false;
      } else if (_addSupplIncome == "Yes") {
        // annual suppl income
        if (_supplSourceController.text.isEmpty) {
          setState(() {
            _supplSourceError = "Please enter supplimetary income source";
          });
          isValid = false;
        }
        // annual supply total income
        if (_supplTotalController.text.isEmpty) {
          setState(() {
            _supplTotalError = "Please enter total annual supplimetary income";
          });
          isValid = false;
        }
      }

      // bank statement doc
      if (_encodedBankStmtDoc == null) {
        setState(() {
          _bankStmtDocError = "Please attach a copy of your bank statement";
        });
        isValid = false;
      }
    }

    if (_currPage >= 9) {
      // add mobile statement?
      if (_addMobileStmt.isEmpty) {
        setState(() {
          _addMobileStmtError =
              "Please choose if you would like to add mobile money statement";
        });
        isValid = false;
      } else if (_addMobileStmt == "Yes") {
        // mobile money statement doc
        if (_encodedmobStmtDoc == null) {
          setState(() {
            _mobStmtDocError =
                "Please attach a copy of your moblie money statement";
          });
          isValid = false;
        }
      }
    }

    if (_currPage >= 10) {
      // NIDA doc copy
      if (_encodedNIDADoc == null) {
        setState(() {
          _nidaDocError = "Please attach a copy of your NIDA card";
        });
        isValid = false;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please fill out all fields',
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
    }

    return isValid;
  }

  void _handleSubmit(context) async {
    _clearErrors();

    final apiProvider = Provider.of<APIProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final applicationData = {
      "employment-type": "Self-Employed",
      "loan-facility": _selectedLoanFacility,
      "loan-currency": _selectedCurrency,
      "loan-purpose": _loanPurposeC.text,
      "loan-amount": _loanAmountController.text,
      "existing_loan": _existingLoanOne,
      "loan_facility": _loanFacilityTypeOne,
      "type_of_loan": _loanFacilityTypeOne == "Other" ? _otherFacilityOneController.text : _loanTypeOne,
      "lender": _institutionOne ?? 0,
      "issuing_date1": _issuingDateOne != null ? DateFormat('dd MMMM y').format(_issuingDateOne!) : '',
      "currency1": _existingLoanCurrencyOne ?? '',
      "total_existing_loan_credited": _creditedAmountOneController.text,
      "total_existing_loan": _prevLoanBalanceOneController.text,
      "existing_loanii": _existingLoanTwo,
      "loan_facilityii": _loanFacilityTypeTwo,
      "type_of_loanii": _loanFacilityTypeTwo == "Other" ? _otherFacilityTwoController.text : _loanTypeTwo,
      "lenderii": _institutionTwo ?? 0,
      "issuing_date2": _issuingDateTwo != null ? DateFormat('dd MMMM y').format(_issuingDateTwo!) : '',
      "currency2": _existingLoanCurrencyTwo ?? '',
      "total_existing_loan_credited2": _creditedAmountTwoController.text,
      "total_existing_loanii": _prevLoanBalanceTwoController.text,
      "existing_loaniii": _existingLoanThree,
      "loan_facilityiii": _loanFacilityTypeThree,
      "type_of_loaniii": _loanFacilityTypeThree == "Other" ? _otherFacilityThreeController.text : _loanTypeThree,
      "lenderiii": _institutionThree ?? 0,
      "issuing_date3": _issuingDateThree != null ? DateFormat('dd MMMM y').format(_issuingDateThree!) : '',
      "currency3": _existingLoanCurrencyThree ?? '',
      "total_existing_loan_credited3": _creditedAmountThreeController.text,
      "total_existing_loaniii": _prevLoanBalanceThreeController.text,
      "current-employer": "",
      "current-designation": "",
      "currently-employed-from": "",
      "hr-name": "",
      "hr-email": "",
      "hr-phone": "",
      "previously-employed": "",
      "previous-employer": "",
      "previous-designation": "",
      "previously-employed-from": "",
      "previously-employed-to": "",
      "business-license-no": _bizLicenseController.text,
      "business-name": _bizNameController.text,
      "business-type": _bizTypeC.text,
      "business-region": _selectedRegion ?? '',
      "business-district": _selectedDistrict ?? '',
      "business-ward": _businessWardController.text,
      "business-street": _businessStreetNameController.text,
      "business-street-no": _businessStreetNumberController.text,
      "business-location": _businessBuildingController.text,
      "premises-ownership": _premiseType,
      "bill-type": _premiseBillType,
      "meter-number": _meterNumberController.text,
      "water-supply-authority": _waterAuthority ?? '',
      "other-water-supply-authority": _otherAuthorityController.text,
      "no-bills-explanation": _noBillsReasonController.text,
      "add-collateral": _addCollateral,
      "my-marital-status": _maritalStatus,
      "spouse-nida": _maritalStatus == "Married"
          ? _spouseNIDAController.text
          : _maritalStatus == "Divorced"
              ? _divorceeNIDAController.text
              : _widowNIDAController.text,
      "spouse-name": _maritalStatus == "Married"
          ? _spouseFullNameController.text
          : _maritalStatus == "Divorced"
              ? _divorceeFullNameController.text
              : _widowFullNameController.text,
      "spouse-dob": _maritalStatus == "Married"
          ? DateFormat('dd MMMM y').format(_spouseDOBToDate ?? DateTime.now())
          : _maritalStatus == "Divorced"
              ? DateFormat('dd MMMM y')
                  .format(_divorceeDOBToDate ?? DateTime.now())
              : DateFormat('dd MMMM y')
                  .format(_widowDOBToDate ?? DateTime.now()),
      "spouse-profession": _maritalStatus == "Married"
          ? _spouseProfessionController.text
          : _divorceeProfessionController.text,
      "spouse-email": _maritalStatus == "Married"
          ? _spouseEmailController.text
          : _divorceeEmailController.text,
      "spouse-phone": _maritalStatus == "Married"
          ? "+255 ${_spousePhoneController.text}"
          : _divorceePhoneController.text,
      "collateral-name": _collateralNameController.text,
      "collateral-value": _collateralValueController.text,
      "collateral-doc-number": _collateralDocNumberController.text,
      "collateral-doc-type": _selectedCollateralDocType ?? '',
      "investment-doc-type": _selectedCollateralInvestDocType ?? '',
      "other-collateral-doc-type": _otherDocTypeNameController.text,
      "add-referee": _addRefOne,
      "referee-nida": _refOneNIDAController.text,
      "referee-name": _refOneFullNameController.text,
      "referee-dob":
          DateFormat('dd MMMM y').format(_refOneDobDate ?? DateTime.now()),
      "referee-marital-status": _refOneMaritalStatus,
      "referee-profession": _refOneProfessionController.text,
      "referee-email": _refOneEmailController.text,
      "referee-phone": "+255 ${_refOnePhoneController.text}",
      "add-referee2": _addRefTwo,
      "referee-nida2": _refTwoNIDAController.text,
      "referee-name2": _refTwoFullNameController.text,
      "referee-dob2":
          DateFormat('dd MMMM y').format(_refTwoDobDate ?? DateTime.now()),
      "referee-marital-status2": _refTwoMaritalStatus,
      "referee-profession2": _refTwoProfessionController.text,
      "referee-email2": _refTwoEmailController.text,
      "referee-phone2": _refTwoProfessionController.text,
      "add-referee3": _addRefThree,
      "referee-nida3": _refThreeNIDAController.text,
      "referee-name3": _refThreeFullNameController.text,
      "referee-dob3":
          DateFormat('dd MMMM y').format(_refThreeDobDate ?? DateTime.now()),
      "referee-marital-status3": _refThreeMaritalStatus,
      "referee-profession3": _refThreeProfessionController.text,
      "referee-email3": _refThreeEmailController.text,
      "referee-phone3": "+255 ${_refThreePhoneController.text}",
      "annual-salary": _totalAnnualSalary.toString(),
      "yearly-bonus": _yearlyBonusController.text,
      "annual-business-income": _bizAnnualIncomeController.text,
      "add-supplimentary-income": _addSupplIncome,
      "supplimentary-income-source": _supplSourceController.text,
      "supplimentary-income-amount": _supplTotalController.text,
      "salary-bank-name": _salaryBank ?? 0,
      "salary-bank-account-no": _bankAccountNumberController.text,
      "add-mobile-stmt": _addMobileStmt,
      "nida-document": _encodedNIDADoc,
      "bank-stmt-doc": _encodedBankStmtDoc,
      "bank-stmt-doc2": _encodedBankStmtDoc2,
      "bank-stmt-doc3": _encodedBankStmtDoc3,
      "mobile-stmt-doc": _encodedmobStmtDoc,
      "collateral-doc": _encodedCollateralDoc,
      "deceased-cert-doc": _encodeddeathCertDoc,
      "divorce-cert-doc": _encodeddivCertDoc,
      "employment-doc": "",
      "business-license-doc": _encodedbizLicenseDoc,
      "other-relevant-docs": _encodedOtherDocs
    };

    final controller = Provider.of<OverlayProvider>(context, listen: false);
    try {
      controller.showLoadingOverlay();
      final response = await ApiService.post(
        'submit-loan-application',
        token: apiProvider.authToken,
        data: applicationData,
      );
      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case "unauthorized":
            case "user-not-found":
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;

            case "already-applied":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'You have already applied to this credit offer.',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;

            case "credit-offer-not-found":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Error: Credit offer was not found.',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;

            case "credit-offer-expired":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Error: Credit offer has already expired.',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;

            case "nida-number-collision":
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'You cannot use your NIDA number on this application.',
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
              break;

            default:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Failed! Please try again later.",
                  style: TextStyle(
                    color: CIColors.errorColor,
                  ),
                ),
                backgroundColor: CIColors.errorBox,
              ));
          }
        } else {
          if (response.containsKey('success')) {
            if (response.containsKey('application-id')) {
              String applicationId = response['application-id'];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Application Submitted',
                  style: TextStyle(
                    color: CIColors.successColor,
                  ),
                ),
                backgroundColor: CIColors.successBox,
              ));
              Future.delayed(Duration(milliseconds: 50), () {
                controller.hideLoadingOverlay();
                Navigator.pushReplacementNamed(
                  context,
                  '/view-loan-application',
                  arguments: {
                    'application-id': applicationId.toString(),
                  },
                );
              });
            }
          }
          return;
        }
      } else {
        //
      }
      setState(() {
        _isLoading = false;
      });
      controller.hideLoadingOverlay();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      controller.hideLoadingOverlay();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed! Please try again later.",
          style: TextStyle(
            color: CIColors.errorColor,
          ),
        ),
        backgroundColor: CIColors.errorBox,
      ));
    }
  }
}