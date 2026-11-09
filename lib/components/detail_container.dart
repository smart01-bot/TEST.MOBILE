import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DetailContainer extends StatelessWidget {
  final String label;
  final String? value;

  const DetailContainer({
    required this.label,
    this.value = '-',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0x6CF6F9FD),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 0,
            children: [
              Text(label,
                  style: TextStyle(
                    color: CIColors.textColorAlt,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  )),
              Text(
                value ?? '-',
                style: TextStyle(
                  color: CIColors.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CIColors.detaiBorderColor // Color of the dashed border
      ..strokeWidth = 1.0 // Width of the border
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0; // Width of each dash
    const dashSpace = 5.0; // Space between dashes
    const radius = 8.0; // Match the border radius of the container

    // Create a rounded rectangle path
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    // Draw dashed border along the rounded path
    _drawDashedPath(canvas, paint, path, dashWidth, dashSpace);
  }

  void _drawDashedPath(Canvas canvas, Paint paint, Path path, double dashWidth,
      double dashSpace) {
    final metrics = path.computeMetrics().first;
    double distance = 0;
    final totalLength = metrics.length;

    while (distance < totalLength) {
      final extract = metrics.extractPath(distance, distance + dashWidth);
      canvas.drawPath(extract, paint);
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
