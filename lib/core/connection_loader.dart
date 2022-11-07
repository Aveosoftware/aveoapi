part of 'package:avio/avio.dart';

///Keeps check on internect connection and loading overlay
class CLStatus {
  CLStatus._instance();
  static CLStatus get instance => CLStatus._instance();

  factory CLStatus() {
    instance.setinitialConnectivity();
    instance.addStreams();
    return instance;
  }

  late StreamSubscription<ConnectivityResult> _subscription;
  late StreamSubscription<InternetConnectionStatus> _listener;

  static final ValueNotifier<bool> _loader = ValueNotifier(false);

  @protected
  static final ValueNotifier<bool> _connected = ValueNotifier(true);

  ///Bool value to show or hide Loading overlay
  set isLoading(ValueNotifier<bool> value) => _loader.value = value.value;

  ///Bool value to show or hide Loading overlay
  ValueNotifier<bool> get isLoading => _loader;

  ///Bool value to check intenet connection status.
  ///Do not set this varibale as it might result in undesired behaviour
  ValueListenable<bool> get isConnected => _connected;

  void addStreams() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _connected.value = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
      if (!_connected.value && _loader.value) {
        _loader.value = false;
      }
    });
    _listener = InternetConnectionCheckerPlus().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            _connected.value = true;
            break;
          case InternetConnectionStatus.disconnected:
            _connected.value = false;
            break;
        }
      },
    );
  }

  void setinitialConnectivity() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        dio_obj.Response result = await Dio().get('google.com');

        if (result.data.isNotEmpty) {
          _connected.value = true;
        }
      } on DioError catch (_) {
        _loader.value = false;
        _connected.value = false;
      }
    }
  }

  void dispose() {
    _subscription.cancel();
    _listener.cancel();
  }
}
