part of 'package:avio/avio.dart';

class AvioWrapper extends StatefulWidget {
  final Widget child;
  final Widget? loader;
  final String? onlineText;
  final String? offlineText;
  final Color? onlineColor;
  final Color? offlineColor;
  final TextStyle? onlineTextStyle;
  final TextStyle? offlineTextStyle;
  final BoxDecoration? overlayDecoration;

  ///This wrapper widget is to show internet connectivity status and enable and
  ///disable loading overlay. It is recommended to wrap the child of
  ///
  ///MaterialApp/GetMaterialApp/CupertinoApp/WidgetApp builder with this widget.
  ///You need to initialize [Avio.init] before using this widget.
  const AvioWrapper(
      {Key? key,
      required this.child,
      this.loader,
      this.overlayDecoration,
      this.onlineText,
      this.offlineText,
      this.onlineColor,
      this.offlineColor,
      this.onlineTextStyle,
      this.offlineTextStyle})
      : super(key: key);

  @override
  State<AvioWrapper> createState() => _AvioWrapperState();
}

class _AvioWrapperState extends State<AvioWrapper> {
  late Size size;
  CLStatus controller = CLStatus.instance;
  final TextStyle defaultTextStyle = const TextStyle(
    fontFamily: '',
    fontSize: 9,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    color: Colors.white,
  );

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        widget.child,
        ValueListenableBuilder<bool>(
          valueListenable: controller.isLoading,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: DecoratedBox(
                  decoration: widget.overlayDecoration ??
                      BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                  child: Center(
                    child: widget.loader ?? const CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          },
        ),
        ValueListenableBuilder<bool>(
            valueListenable: controller.isConnected(),
            builder: (context, value, child) {
              return kIsWeb
                  ? AnimatedPositioned(
                      top: value ? -50 : 20,
                      curve: Curves.bounceInOut,
                      duration: const Duration(seconds: 1),
                      child: SizedBox(
                        width: 200,
                        child: Material(
                          color: Colors.transparent,
                          child: Chip(
                            backgroundColor: value
                                ? widget.onlineColor ?? Colors.green
                                : widget.offlineColor ??
                                    Theme.of(context).errorColor,
                            avatar: Icon(
                              Icons.info,
                              color: (value
                                      ? widget.onlineTextStyle?.color ??
                                          defaultTextStyle.color
                                      : widget.offlineTextStyle?.color ??
                                          defaultTextStyle.color)!
                                  .withOpacity(.7),
                            ),
                            label: Text(
                              value
                                  ? (widget.onlineText ?? 'Back online')
                                  : (widget.offlineText ?? 'OFFLINE'),
                              style: value
                                  ? widget.onlineTextStyle ?? defaultTextStyle
                                  : widget.offlineTextStyle ?? defaultTextStyle,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 0,
                      child: Material(
                        color: value
                            ? widget.onlineColor ?? Colors.green
                            : widget.offlineColor ??
                                Theme.of(context).errorColor,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn,
                          height: value ? 0 : 20,
                          child: SizedBox(
                            width: size.width,
                            child: Center(
                              child: Text(
                                value
                                    ? (widget.onlineText ?? 'Back online')
                                    : (widget.offlineText ?? 'OFFLINE'),
                                style: value
                                    ? widget.onlineTextStyle ?? defaultTextStyle
                                    : widget.offlineTextStyle ??
                                        defaultTextStyle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
            }),
      ],
    );
  }
}
