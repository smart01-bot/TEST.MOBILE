import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/input_fields/ci_file.dart';
import '../../components/loading_screen.dart';
import '../../components/main_top_bar.dart';
import '../../constants/button_style_main.dart';
import '../../constants/colors.dart';
import '../../helpers/force_logout.dart';
import '../../providers/api_provider.dart';
import '../../services/api_service.dart';
import '../../wrappers/authed_wrapper.dart';

class FinancingSolutionsUtilizationRequestScreen extends StatefulWidget {
  const FinancingSolutionsUtilizationRequestScreen({super.key});

  @override
  State<FinancingSolutionsUtilizationRequestScreen> createState() =>
      _FinancingSolutionsUtilizationRequestScreenState();
}

class _FinancingSolutionsUtilizationRequestScreenState
    extends State<FinancingSolutionsUtilizationRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _fileName;
  Map<String, String>? _encodedFile;
  String _fileError = '';
  bool _isSubmitting = false;

  void _setFileName(String v) => setState(() => _fileName = v);
  void _setFileEncoded(Map<String, String> v) => setState(() => _encodedFile = v);
  void _setFileError(String v) => setState(() => _fileError = v);

  Future<void> _submit() async {
    if (_encodedFile == null) {
      setState(() => _fileError = 'Please attach the utilization request letter');
      return;
    }
    setState(() { _isSubmitting = true; _fileError = ''; });

    try {
      final apiProvider = Provider.of<APIProvider>(context, listen: false);
      final response = await ApiService.post(
        'business/utilization-request',
        token: apiProvider.authToken,
        data: {
          'file': _encodedFile!['data'],
          'ext': _encodedFile!['ext'],
        },
      );

      if (response != null) {
        if (response.containsKey('error')) {
          switch (response['error']) {
            case 'unauthorized':
              WidgetsBinding.instance.addPostFrameCallback((_) {
                forceLogout(context, mounted);
              });
              return;
            default:
              setState(() => _fileError = 'Submission failed. Please try again.');
          }
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/business/financing/references');
          }
        }
      }
    } catch (e) {
      setState(() => _fileError = 'An error occurred. Please try again.');
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthedWrapper(
      scaffoldKey: _scaffoldKey,
      appBar: MainTopBar(scaffoldKey: _scaffoldKey, title: "Utilization Request"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x2e47688b), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Credit Line Utilization Request',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CIColors.textColor),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: CIColors.textColor, fontSize: 14),
                    children: [
                      TextSpan(text: 'NOTE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'before proceeding follow these instructions.'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _step('Click on the template below to download the utilization request letter.'),
                _step('Open the document, fill in all the required information, and sign where indicated.'),
                _step('Scan the completed and signed document and save it on your device.'),
                _step('Return to your account and upload the scanned copy on the upload section provided.'),
                const SizedBox(height: 16),
                const Text('Download below:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: CIColors.textColor)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The request-letter template is not included in this standalone TEST build.'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFb9e5fa),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        FaIcon(FontAwesomeIcons.filePdf, size: 14, color: Color(0xFF3d4485)),
                        SizedBox(width: 8),
                        Text('Utilization Request Letter',
                            style: TextStyle(color: Color(0xFF3d4485), fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('After filling the document upload it here:',
                    style: TextStyle(fontSize: 14, color: CIColors.textColor)),
                const SizedBox(height: 10),
                CIFile(
                  engLabel: 'Upload utilization request letter',
                  swLabel: 'Pakia barua ya ombi la matumizi',
                  setFileEncoded: _setFileEncoded,
                  fileName: _fileName,
                  setFileName: _setFileName,
                  haveError: _fileError.isNotEmpty,
                  setError: _setFileError,
                  allowedExtensions: const ['pdf'],
                  allowedExtensionsError: 'Only PDF files are allowed',
                ),
                if (_fileError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(_fileError,
                        style: const TextStyle(color: CIColors.errorText, fontSize: 13, fontStyle: FontStyle.italic)),
                  ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: mainButtonStyle,
                    child: _isSubmitting
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Next', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _step(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: CIColors.textColor, fontSize: 14)),
          Expanded(child: Text(text, style: const TextStyle(color: CIColors.textColor, fontSize: 14))),
        ],
      ),
    );
  }
}