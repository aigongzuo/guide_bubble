description: We introduce a delightful new feature with subtle bubble prompts during the user's initial installation.


## Features

<img src="https://raw.githubusercontent.com/aigongzuo/guide_bubble/main/img_0.webp" width="240px" height="426px"/>
<img src="https://raw.githubusercontent.com/aigongzuo/guide_bubble/main/img_1.webp" width="240px" height="426px"/>

## Getting started

dart pub add guide_bubble

## Usage

```dart
GuideBubbleWidget
(
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
)
,
```

[//]: # (-----------------------------)
[//]: # ()
[//]: # (####  1.0.0)
[//]: # (upload demo )

