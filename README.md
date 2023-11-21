description: Leveraging subtle bubble prompts upon the user's initial installation, it introduces a delightful new feature effortlessly. Through a design that is both simple and efficient, we offer users a warm first impression, quietly guiding them to explore the exciting world within the application


## Features

List what your package can do. Maybe include images, gifs, or videos.
![img.png](img.png)
![img_1.png](img_1.png)
## Getting started

dart pub add guide_bubble

## Usage

```dart
GuideBubbleWidget(
    key: bubbleKey,
    textPadding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 8),
    bubbleMargin: 5,
    text: const Text(
        'This is an overlay, This is an overlay, This is an overlay,This is an overlay,This is an overlay,This is an overlay,',
        style: TextStyle(color: Colors.white),
    ),
    bgColor: const Color(0xFF7F5EFF),
    borderRadius: BorderRadius.circular(12),
    downImg: Image.asset(
        'assets/images/lm_arrow_down.png',
        fit: BoxFit.fill,
    ),
    upImg: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationX(180 * 3.1415927 / 180), // 180度，也可以使用pi
        child: Image.asset('assets/images/lm_arrow_down.png', fit: BoxFit.fill)),
        location: BubbleLocation.auto,
    onTap: () {
        GuideBubbleWidgetState status = bubbleKey.currentState! as GuideBubbleWidgetState;
        status.removeView();
    },
),
```