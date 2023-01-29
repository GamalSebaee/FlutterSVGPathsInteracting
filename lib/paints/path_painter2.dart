import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import '../SelectedPathModel.dart';
import '../parser/parser.dart';

class PathPainter2 extends CustomPainter {
  final BuildContext context;
  final List<PathSegment> paths;
  final List<SelectedPathModel> curPath;
  final double height;
  final double width;
  final Function(PathSegment curPath) onPressed;
  PathPainter2(
      {required this.context,
      required this.paths,
  required this.curPath,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final double xScale = size.width / width;
    final double yScale = size.height / height;
    final double scale = xScale < yScale ? xScale : yScale;

    // scale each path to match canvas size
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(scale, scale);

    // calculate the scaled svg image width and height in order to get right offset
    double scaledSvgWidth = width * scale;
    double scaledSvgHeight = height * scale;
    // calculate offset to center the svg image
    double offsetX = (size.width - scaledSvgWidth) / 2;
    double offsetY = (size.height - scaledSvgHeight) / 2;

    final TouchyCanvas touchCanvas = TouchyCanvas(context, canvas);

    // your paint
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0;

    for (var path in paths) {
      // Here: archive our target, select one path/state, just change the paint's style to fill

      var selectedCurPath=curPath.where((element) => (element.pathName == path.pathId)).toList();
      var selectedPathModel=(selectedCurPath.isNotEmpty) ? selectedCurPath.first:null;
      paint.style = (selectedPathModel != null) ? PaintingStyle.fill : PaintingStyle.stroke;
      paint.color =selectedPathModel?.pathColor ?? Colors.blueAccent;
      if(path.path != null){
        touchCanvas.drawPath(
          path.path!.transform(matrix4.storage).shift(Offset(offsetX, offsetY)),
          paint,
          onTapDown: (details) {
            // notify select change and redraw
            onPressed(path);
          },
        );
      }

    }
  }

  @override
  bool shouldRepaint(PathPainter2 oldDelegate) => true;
}
