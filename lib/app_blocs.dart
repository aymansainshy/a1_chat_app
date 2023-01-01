class AppBlocs {

  
  static void dispose() {}

  ///Singleton factory
  static final AppBlocs _instance = AppBlocs._internal();

  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();
}
