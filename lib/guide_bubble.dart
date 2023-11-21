import 'package:flutter/material.dart';

class GuideBubbleWidget extends StatefulWidget {
  ///要显示的文本
  final Text text;

  ///文本内边距
  final EdgeInsets textPadding;

  ///文本最大宽度
  final double textMaxWidth;

  ///气泡边距
  final double bubbleMargin;

  /// 背景色
  final Color? bgColor;

  ///圆角
  final BorderRadiusGeometry? borderRadius;

  ///向上箭头图片
  final Widget? upImg;

  ///上箭头大小
  final Size upSize;

  ///向下箭头图片
  final Widget? downImg;

  ///下箭头大小
  final Size downSize;

  ///气泡位置：之上、之下、自动
  final BubbleLocation location;

  ///点击回调
  final void Function()? onTap;

  ///自动充满
  final bool autoFull;

  const GuideBubbleWidget({
    super.key,
    this.text = const Text('This is an overlay', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
    this.textPadding = const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
    this.textMaxWidth = 200,
    this.bubbleMargin = 0,
    this.bgColor,
    this.borderRadius,
    this.upImg,
    this.upSize = const Size(14, 7),
    this.downImg,
    this.downSize = const Size(14, 7),
    this.location = BubbleLocation.auto,
    this.onTap,
    this.autoFull = false,
  });

  @override
  GuideBubbleWidgetState createState() => GuideBubbleWidgetState();
}

class GuideBubbleWidgetState extends State<GuideBubbleWidget> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  getWidget(double textLeft, double arrowLeft, BubbleLocation location, double textWidgetWidth, double textWidgetHeight) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (location == BubbleLocation.below && widget.upImg != null) ...{
            Padding(
              padding: EdgeInsetsDirectional.only(start: arrowLeft),
              child: SizedBox(
                width: widget.autoFull ? null : widget.downSize.width,
                height: widget.autoFull ? null : widget.downSize.height,
                child: widget.upImg!,
              ),
            ),
          },
          Container(
            width: textWidgetWidth,
            height: textWidgetHeight,
            padding: widget.textPadding,
            margin: EdgeInsetsDirectional.only(start: textLeft),
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: widget.borderRadius,
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: widget.textMaxWidth),
              child: widget.text,
            ),
          ),
          if (location == BubbleLocation.above && widget.downImg != null) ...{
            Padding(
              padding: EdgeInsetsDirectional.only(start: arrowLeft),
              child: SizedBox(
                width: widget.downSize.width,
                height: widget.downSize.height,
                child: widget.downImg!,
              ),
            ),
          },
        ],
      ),
    );
  }

  GuideBubbleWidgetState showOverlay(GlobalKey dependentViewKey) {
    BuildContext? buildContext = dependentViewKey.currentContext;
    if (buildContext == null || !mounted) {
      return this;
    }

    // 获取按钮在屏幕上的位置
    RenderBox dependentBox = buildContext.findRenderObject() as RenderBox;
    Offset buttonPosition = dependentBox.localToGlobal(Offset.zero);

    double dependentViewLeft = isRtl() ? MediaQuery.of(context).size.width - buttonPosition.dx : buttonPosition.dx;
    double dependentViewTop = buttonPosition.dy;

    //判断buttonPosition 是否超出屏幕
    if (dependentViewLeft < 0) {
      dependentViewLeft = 0;
    } else if (dependentViewLeft + dependentBox.size.width > MediaQuery.of(context).size.width) {
      dependentViewLeft = MediaQuery.of(context).size.width - dependentBox.size.width;
    }
    // 获取 textWidget 的尺寸
    final Size textSize = getTextMetrics();
    double textWidgetWidth = textSize.width + widget.textPadding.left + widget.textPadding.right;
    double textWidgetHeight = textSize.height + widget.textPadding.top + widget.textPadding.bottom;

    double top;
    double textLeft;
    double arrowLeft;

    BubbleLocation location = widget.location;

    if (location == BubbleLocation.auto) {
      // 判断按钮在屏幕上的位置，从而确定气泡的位置
      if (dependentViewTop >= MediaQuery.of(context).size.height / 2) {
        location = BubbleLocation.above;
      } else {
        location = BubbleLocation.below;
      }
    }

    switch (location) {
      case BubbleLocation.above:
        top = dependentViewTop - textWidgetHeight - (widget.downImg == null ? 0 : widget.downSize.height) - widget.bubbleMargin;
        break;
      case BubbleLocation.below:
        top = dependentViewTop + dependentBox.size.height + widget.bubbleMargin;
        break;
      default:
        throw ("not support");
    }

    // 计算箭头位置、 计算文本的位置
    if (isRtl()) {
      arrowLeft = dependentViewLeft - dependentBox.size.width + (dependentBox.size.width - widget.upSize.width) / 2;
      textLeft = dependentViewLeft - dependentBox.size.width + (dependentBox.size.width - textWidgetWidth) / 2;
    } else {
      arrowLeft = dependentViewLeft + (dependentBox.size.width - widget.upSize.width) / 2;
      textLeft = dependentViewLeft + (dependentBox.size.width - textWidgetWidth) / 2;
    }

    // 如果文本超出屏幕边界，则进行调整
    if (textLeft < 0) {
      textLeft = 0;
    } else if (textLeft + textWidgetWidth > MediaQuery.of(context).size.width) {
      textLeft = MediaQuery.of(context).size.width - textWidgetWidth;
    }
    removeView();
    // 创建 OverlayEntry
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: top,
        left: 0,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
              },
              child: getWidget(textLeft, arrowLeft, location, textWidgetWidth, textWidgetHeight)),
        ),
      ),
    );
    // 将 OverlayEntry 插入 Overlay 中
    Overlay.of(context).insert(overlayEntry!);
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    // 移除 OverlayEntry
    removeView();
    super.dispose();
  }

  Size getTextMetrics() {
    TextPainter textPainter = TextPainter(
      text: widget.text.textSpan ??
          TextSpan(
            text: widget.text.data ?? "",
            style: widget.text.style, // You can set your desired text style
          ),
      textDirection: widget.text.textDirection ?? getTextDirection(),
      textAlign: widget.text.textAlign ?? TextAlign.start,
      //textScaleFactor: widget.text.textScaleFactor ?? 1.0,
      maxLines: widget.text.maxLines,
      locale: widget.text.locale,
      strutStyle: widget.text.strutStyle,
      textWidthBasis: widget.text.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: widget.text.textHeightBehavior,
    )..layout(maxWidth: widget.textMaxWidth);
    return Size(textPainter.width, textPainter.height);
  }

  isRtl() {
    TextDirection currentTextDirection = getTextDirection();
    // 判断是否是从右向左的文本布局
    return currentTextDirection == TextDirection.rtl;
  }

  // 获取当前文本的布局方向
  TextDirection getTextDirection() {
    return Directionality.of(context);
  }

  void removeView() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  bool isShow() {
    return overlayEntry != null;
  }

  //是否超出屏幕
  bool isOffScreen(GlobalKey key) {
    BuildContext? buildContext = key.currentContext;
    if (buildContext == null) {
      return false;
    }
    // 获取按钮在屏幕上的位置
    RenderBox dependentBox = buildContext.findRenderObject() as RenderBox;
    Offset buttonPosition = dependentBox.localToGlobal(Offset.zero);

    double dependentViewLeft = buttonPosition.dx;
    double dependentViewTop = buttonPosition.dy;
    //判断buttonPosition 是否超出屏幕
    if (dependentViewLeft < 0 || (dependentViewLeft + dependentBox.size.width > MediaQuery.of(context).size.width)) {
      return true;
    }
    if (dependentViewTop < 0 || (dependentViewTop + dependentBox.size.height > MediaQuery.of(context).size.height)) {
      return true;
    }
    return false;
  }
}

enum BubbleLocation {
  ///自动
  auto,

  ///之上
  above,

  ///之下
  below,
}
