import 'package:flutter/material.dart';
import 'dart:math' as math;

class TriangleChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges;

  const TriangleChallengesWidget({Key? key, required this.challenges})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract values safely
    final int? d1 = challenges['Desafio1'];
    final int? d2 = challenges['Desafio2'];
    final int? d3 = challenges['Desafio3'];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate dynamic font sizes similar to other widgets
        double availableWidth = constraints.maxWidth;
        // Basic responsiveness logic - INCREASED SIZES
        double fontSize = (availableWidth / 18).clamp(12.0, 20.0);
        double titleFontSize = fontSize * 1.4;
        double padding = 8.0;

        // Size for the triangle area
        // We substract padding and title height estimation safely
        // Ensure we have non-negative available height
        double availableHeight =
            constraints.maxHeight - (titleFontSize * 2) - (padding * 2);
        if (availableHeight < 0) availableHeight = 0;

        double size = math.min(availableWidth, availableHeight);
        final double actualSize = size > 0 ? size : 200.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title at the top, black color (harmonious)
              Text(
                'Desafiaments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: actualSize,
                    height: actualSize,
                    child: CustomPaint(
                      painter: TrianglePainter(),
                      child: Stack(
                        children: [
                          // Top Left Vertex (Desafio 1) - REQUESTED POSITION
                          _buildPositionedItem(
                            alignment: Alignment.topLeft,
                            label: 'Desafio 1',
                            value: d1,
                            padding: EdgeInsets.only(left: 0, top: 0),
                            fontSize: fontSize,
                          ),

                          // Top Right Vertex (Desafio 2) - REQUESTED POSITION
                          _buildPositionedItem(
                            alignment: Alignment.topRight,
                            label: 'Desafio 2',
                            value: d2,
                            padding: EdgeInsets.only(right: 0, top: 0),
                            fontSize: fontSize,
                          ),

                          // Bottom Center Vertex (Desafio 3) - REQUESTED POSITION (POINT DOWN)
                          _buildPositionedItem(
                            alignment: Alignment.bottomCenter,
                            label: 'Desafio 3',
                            value: d3,
                            padding: EdgeInsets.only(bottom: 0),
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionedItem({
    required Alignment alignment,
    required String label,
    required int? value,
    required EdgeInsets padding,
    required double fontSize,
  }) {
    // Adjust label font size relative to main font size
    double labelSize = fontSize * 0.8;
    // Increased value size multiplier
    double valueSize = fontSize * 1.5;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(fontSize * 0.5), // Slightly more padding
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                value?.toString() ?? '?',
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Insetting the triangle slightly to look better inside the square area
    double inset = size.width * 0.1; // 10% inset

    // Inverted Triangle Coordinates

    // Top Left
    final double topLeftX = inset;
    final double topLeftY = inset;

    // Top Right
    final double topRightX = size.width - inset;
    final double topRightY = inset;

    // Bottom Center (Point Down)
    final double bottomCenterX = size.width * 0.5;
    final double bottomCenterY = size.height - inset;

    final path = Path()
      ..moveTo(topLeftX, topLeftY)
      ..lineTo(topRightX, topRightY)
      ..lineTo(bottomCenterX, bottomCenterY)
      ..close();

    canvas.drawPath(path, paint);

    // Optional: Fill
    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
