import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/map/map.dart';
import 'package:latlong/latlong.dart' hide Path; // conflict with Path from UI

class CircleLayerOptions extends LayerOptions {
  final List<CircleMarker> circles;
  CircleLayerOptions({this.circles = const [], rebuild})
      : super(rebuild: rebuild);
}

class CircleMarker {
  final LatLng point;
  final double radius;
  final Color color;
  final double borderStrokeWidth;
  final Color borderColor;
  Offset offset = Offset.zero;
  CircleMarker({
    this.point,
    this.radius,
    this.color = const Color(0xFF00FF00),
    this.borderStrokeWidth = 0.0,
    this.borderColor = const Color(0xFFFFFF00),
  });
}

class CircleLayer extends StatelessWidget {
  final CircleLayerOptions circleOpts;
  final MapState map;
  final Stream<Null> stream;
  CircleLayer(this.circleOpts, this.map, this.stream);

  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (BuildContext context, BoxConstraints bc) {
        final size = new Size(bc.maxWidth, bc.maxHeight);
        return _build(context, size);
      },
    );
  }

  Widget _build(BuildContext context, Size size) {
    return new StreamBuilder<int>(
      stream: stream, // a Stream<int> or null
      builder: (BuildContext context, _) {
        var circleWidgets = <Widget>[];
        for (var circle in circleOpts.circles) {

          circle.offset = map.latlngToOffset(circle.point);

          circleWidgets.add(
            new CustomPaint(
              painter: new CirclePainter(circle),
              size: size,
            ),
          );
        }

        return new Container(
          child: new Stack(
            children: circleWidgets,
          ),
        );
      },
    );
  }
}

class CirclePainter extends CustomPainter {
  final CircleMarker circle;
  CirclePainter(this.circle);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.clipRect(rect);
    final paint = new Paint()
      ..style = PaintingStyle.fill
      ..color = circle.color;

    final borderPaint = circle.borderStrokeWidth > 0.0
        ? (new Paint()
          ..color = circle.borderColor
          ..strokeWidth = circle.borderStrokeWidth)
        : null;

    _paintCircle(canvas, circle.offset, circle.radius, paint);
  }

  void _paintCircle(Canvas canvas, Offset offset, double radius, Paint paint) {
    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(CirclePainter other) => false;
}
