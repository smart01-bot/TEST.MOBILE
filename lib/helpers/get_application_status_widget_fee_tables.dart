import 'package:flutter/material.dart';

import '../components/ci_pill.dart';

Widget getApplicationStatusWidgetFeeTables(String status) {
  switch (status) {
    case "Active":
      return CiPill(
        "Active",
        colorTheme: "yellow-green",
      );
    case "Inactive":
      return CiPill("Inactive");
    case "User_Submitted":
      return CiPill(
        "Pending Review",
      );
    case "User_Deleted":
    case "Bank_Deleted":
      return CiPill(
        "Deleted",
        colorTheme: "rejected",
      );
    case "Reviewed":
      return CiPill(
        "Pending User Reply",
        colorTheme: "yellow-green",
      );
    case "Bank_Submitted":
      return CiPill(
        "Bank Reviewed",
        colorTheme: "yellow-green",
      );
    case "Reply_Reviewed":
      return CiPill(
        "Fee Table Accepted",
        colorTheme: "yellow-green",
      );
    case "Bank_Reply_Rejected":
    case "Reply_Rejected":
    case "Rejected":
      return CiPill(
        "Rejected",
        colorTheme: "rejected",
      );
    case "User_Declined":
    case "Bank_Declined":
      return CiPill(
        "Declined",
        colorTheme: "rejected",
      );
    case "Sent_To_User":
      return CiPill(
        "Awaiting Applicant Response",
        colorTheme: "blue",
      );
    case "Bank_Replied":
      return CiPill(
        "Bank Reviewed",
        colorTheme: "yellow-green",
      );
    case "User_Replied":
      return CiPill(
        "User Replied",
        colorTheme: "yellow-green",
      );
    case "Bank_Approved":
    case "Approved":
      return CiPill(
        "Application Accepted",
        colorTheme: "success",
      );
    default:
      return CiPill("Pending");
  }
}
