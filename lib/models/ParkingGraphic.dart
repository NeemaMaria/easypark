import 'package:flutter/material.dart';

class ParkingGraphic extends StatelessWidget {
  final double height;
  ParkingGraphic({super.key, required this.height});

  Color left_color = Color.fromARGB(166, 141, 255, 175);
  Color right_color = Color.fromARGB(148, 99, 99, 99);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: RhombusClipper(),
          child: Container(
            decoration: BoxDecoration(
              color: right_color,
            ),
            height: 0.2 * height,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 1 * (0.1 * height)),
          child: ClipPath(
            clipper: RhombusClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: right_color,
              ),
              height: 0.2 * height,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2 * (0.1 * height)),
          child: ClipPath(
            clipper: RhombusClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: right_color,
              ),
              height: 0.2 * height,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 3 * (0.1 * height)),
          child: ClipPath(
            clipper: RhombusClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: left_color,
              ),
              height: 0.2 * height,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4 * (0.1 * height)),
          child: ClipPath(
            clipper: RhombusClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: right_color,
              ),
              height: 0.2 * height,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5 * (0.1 * height)),
          child: ClipPath(
            clipper: RhombusClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: right_color,
              ),
              height: 0.2 * height,
            ),
          ),
        ),
      ],
    );
  }
}

class RhombusClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.75 * size.width, 0);
    path.lineTo(size.width, 0.5 * size.height);
    path.lineTo(0.25 * size.width, size.height);
    path.lineTo(0, 0.5 * size.height);
    path.lineTo(0.75 * size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SlotRhombusClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0.75 * size.width, 0);
    path.lineTo(size.width, 0.5 * size.height);
    path.lineTo(0.25 * size.width, size.height);
    path.lineTo(0, 0.5 * size.height);
    path.lineTo(0.75 * size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}