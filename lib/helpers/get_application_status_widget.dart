import 'package:flutter/material.dart';

import '../components/ci_pill.dart';

Widget getApplicationStatusWidget(String status, [bool bolder = true]) {
  switch (status) {
    case "Active":
      return CiPill(
        "Active",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "Inactive":
      return CiPill(
        "Inactive",
        bolder: bolder,
      );
    case "User_Submitted":
      return CiPill(
        "Pending Review",
        bolder: bolder,
      );
    case "User_Deleted":
    case "Bank_Deleted":
      return CiPill(
        "Deleted",
        colorTheme: "rejected",
        bolder: bolder,
      );
    case "Reviewed":
      return CiPill(
        "Application Cleared",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "Reply_Reviewed":
      return CiPill(
        "Awaiting Bank Response",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "Bank_Reply_Rejected":
    case "Reply_Rejected":
    case "Rejected":
      return CiPill(
        "Rejected",
        colorTheme: "rejected",
        bolder: bolder,
      );
    case "User_Declined":
    case "Bank_Declined":
      return CiPill(
        "Declined",
        colorTheme: "rejected",
        bolder: bolder,
      );
    case "Sent_To_User":
      return CiPill(
        "Awaiting Applicant Response",
        colorTheme: "blue",
        bolder: bolder,
      );
    case "Bank_Replied":
      return CiPill(
        "Bank Reviewed",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "User_Replied":
      return CiPill(
        "User Replied",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "Bank_Approved":
    case "Approved":
      return CiPill(
        "Application Accepted",
        colorTheme: "success",
        bolder: bolder,
      );
    case "HQ_Approved":
      return CiPill(
        "Loan Approved",
        colorTheme: "success",
        bolder: bolder,
      );
    case "HQ_Pending_Approval":
      return CiPill(
        "Pending Approval",
        colorTheme: "blue",
        bolder: bolder,
      );
    case "HQ_Disbursed":
      return CiPill(
        "Funds Disbursed",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "HQ_Withdrawn":
      return CiPill(
        "Funds Withdrawn",
        colorTheme: "yellow-green",
        bolder: bolder,
      );
    case "HQ_Rejected":
      return CiPill(
        "Application Rejected",
        colorTheme: "rejected",
        bolder: bolder,
      );
    case "HQ_Closed_Obligations_Met":
      return CiPill(
        "Closed",
        bolder: bolder,
      );
    default:
      return CiPill(
        "Pending",
        bolder: bolder,
      );
  }
}
