import 'package:flutter/material.dart';
import 'package:guide_bubble/guide_bubble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey dependentViewKey = GlobalKey();
  final GlobalKey bubbleKey = GlobalKey();

  OverlayEntry? entry;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 100,
              left: 0,
            ),
            child: Container(
              key: dependentViewKey,
              padding: const EdgeInsets.all(8.0),
              color: Colors.blue,
              child: GestureDetector(
                  onTap: () {
                    GuideBubbleWidgetState status = bubbleKey.currentState! as GuideBubbleWidgetState;
                    if (status.isShow()) {
                      status.removeView();
                      return;
                    } else {
                      status.showOverlay(dependentViewKey);
                    }
                  },
                  child: const Text(
                    'Show Overlay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )),
            ),
          ),
          GuideBubbleWidget(
            key: bubbleKey,
            textPadding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
            bubbleMargin: 5,
            text: const Text(
              'This is an overlay.\n This is an overlay.',
              style: TextStyle(color: Colors.white),
            ),
            bgColor: const Color(0xFF7F5EFF),
            borderRadius: BorderRadius.circular(12),
            downImg: Image.asset(
              'assets/images/lm_arrow.png',
              fit: BoxFit.fill,
            ),
            upImg: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(180 * 3.1415927 / 180), // 180度，也可以使用pi
                child: Image.asset('assets/images/lm_arrow.png', fit: BoxFit.fill)),
            location: BubbleLocation.auto,
            onTap: () {
              GuideBubbleWidgetState status = bubbleKey.currentState! as GuideBubbleWidgetState;
              status.removeView();
            },
          ),
        ],
      ),
    );
  }
}
