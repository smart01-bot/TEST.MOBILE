import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../helpers/sentence_to_text_widgets.dart';
import '../../providers/overlay_controller.dart';

const List<String> defaultAllowedExtensions = ['pdf'];
const String defaultAllowedExtensionsError = 'Only .pdf files allowed';

class CIFile extends StatefulWidget {
  final String engLabel;
  final String swLabel;
  final bool haveError;
  final String? fileName;
  final Function setFileName;
  final Function setFileEncoded;
  final Function setError;
  final List<String> allowedExtensions;
  final String allowedExtensionsError;
  final bool allowMultipleFiles;
  final Function? setFilesEncoded;

  const CIFile({
    super.key,
    required this.engLabel,
    required this.swLabel,
    required this.fileName,
    required this.setFileName,
    required this.setFileEncoded,
    required this.setError,
    this.allowedExtensions = defaultAllowedExtensions,
    this.allowedExtensionsError = defaultAllowedExtensionsError,
    this.haveError = false,
    this.allowMultipleFiles = false,
    this.setFilesEncoded,
  });

  @override
  State<CIFile> createState() => _CIFileState();
}

class _CIFileState extends State<CIFile> {
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;
  String _fileName = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    setState(() {
      _fileName = widget.fileName ?? '';
    });
  }

  Future<void> pickFile(context) async {
    widget.setError('');

    List<String> allowedExtensions = widget.allowedExtensions;
    String allowedExtensionsError = widget.allowedExtensionsError;

    final overlayProvider =
        Provider.of<OverlayProvider>(context, listen: false);

    overlayProvider.pauseAppLocking();
    // Allow multiple files if specified
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: widget.allowMultipleFiles, // Handle multiple files
    );

    overlayProvider.resumeAppLocking();

    if (result != null) {
      // If multiple files are selected
      if (widget.allowMultipleFiles) {
        List<String> fileNames = [];
        List<Map<String, String>> filesEncoded = [];
        bool isError = false;

        for (var file in result.files) {
          File selectedFile = File(file.path!);
          String extension = file.extension ?? '';
          String fileName = file.name;

          // Check for allowed extension
          if (!allowedExtensions.contains(extension.toLowerCase())) {
            widget.setError(allowedExtensionsError);
            isError = true;
            break;
          }

          // Check for file size
          if (selectedFile.lengthSync() > 5 * 1024 * 1024) {
            widget.setError('File is too large. Maximum size is 5MB.');
            isError = true;
            break;
          }

          // Read file and encode to base64
          List<int> fileBytes = await selectedFile.readAsBytes();
          String base64File = base64Encode(fileBytes);

          fileNames.add(fileName);
          filesEncoded.add({"data": base64File, "ext": extension});
        }

        // Only update if no error occurred
        if (!isError) {
          // After picking multiple files, set the encoded files and filenames
          widget.setFilesEncoded!(filesEncoded);
          widget.setFileName(fileNames.join(", ")); // Join multiple file names

          setState(() {
            _fileName = fileNames.length > 1
                ? "${fileNames.length} files selected"
                : fileNames.first;
          });
        }
      } else {
        // Original single file selection functionality
        File file = File(result.files.single.path!);
        String extension = result.files.single.extension ?? '';
        String fileName = result.files.single.name;

        if (!allowedExtensions.contains(extension.toLowerCase())) {
          widget.setError(allowedExtensionsError);
          return;
        }

        if (file.lengthSync() > 5 * 1024 * 1024) {
          widget.setError('File is too large. Maximum size is 5MB.');
          return;
        }

        List<int> fileBytes = await file.readAsBytes();
        String base64File = base64Encode(fileBytes);

        widget.setFileEncoded({
          "data": base64File,
          "ext": extension,
        });
        widget.setFileName(fileName);

        setState(() {
          _fileName = result.files.single.name;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
        pickFile(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: _isFocused ? CIColors.inputFocusFillColor : CIColors.inputFillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.haveError
                ? CIColors.errorBorder
                : (_isFocused ? CIColors.secondaryColor : CIColors.inputBorderColor),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              runSpacing: 0,
              children: [
                ...sentenceToTextWidgets("${widget.engLabel} /",
                    color: CIColors.secondaryColor),
                ...sentenceToTextWidgets(widget.swLabel),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickFile(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    alignment: Alignment.center,
                    constraints: BoxConstraints(maxWidth: 70),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                        color: CIColors.secondaryColor,
                        borderRadius: BorderRadius.circular(16)),
                    child: Text(
                      _fileName.isEmpty ? 'Choose' : 'Change',
                      style: TextStyle(
                        fontSize: 12,
                        color: CIColors.whiteColor,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    _fileName.isNotEmpty
                        ? (widget.allowMultipleFiles
                            ? (_fileName.split(',').length > 1
                                ? "${_fileName.split(',').length} files selected"
                                : _fileName)
                            : _fileName)
                        : 'No file chosen',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}