import 'package:flutter/material.dart';

import '../helpers/force_logout.dart';

enum ApiErrorType { unauthorized, forbiden, serverError, ipRestricted, other }

ApiErrorType handleCommonApiErrors(
    BuildContext context, mounted, String responseCode) {
  switch (responseCode) {
    case "unauthorized":
      if (context.mounted) {
        forceLogout(context, mounted);
      }
      return ApiErrorType.unauthorized;
    case "forbidden":
      return ApiErrorType.forbiden;
    case "server-error":
      return ApiErrorType.serverError;
    case "ip-restricted":
      return ApiErrorType.ipRestricted;
    default:
      return ApiErrorType.other;
  }
}
