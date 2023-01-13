import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:twsl_flutter/src/model/firebase/fcm.dart';
import 'package:twsl_flutter/src/model/preferences/preferences.dart';
import 'package:twsl_flutter/src/model/repository/repository.dart';
import 'package:twsl_flutter/src/model/repository/repository_impl.dart';
import 'package:twsl_flutter/src/model/services/tracker_position_model.dart';
import 'package:twsl_flutter/src/model/utils/extensions.dart';
import 'package:twsl_flutter/src/model/web_apis/web_api.dart';
import 'package:twsl_flutter/src/model/web_apis/web_api_impl.dart';
import 'package:twsl_flutter/src/ui/camera_screen/camera_model.dart';
import 'package:twsl_flutter/src/ui/chat/chat_screen.dart';
import 'package:twsl_flutter/src/ui/customer/delivery_status/delivery_status_screen.dart';
import 'package:twsl_flutter/src/ui/customer/feedback/feedback_model.dart';
import 'package:twsl_flutter/src/ui/customer/feedback/issue_feedback_screen.dart';
import 'package:twsl_flutter/src/ui/customer/feedback/message_feedback_screen.dart';
import 'package:twsl_flutter/src/ui/customer/type_track_screen.dart';
import 'package:twsl_flutter/src/ui/drive/auth/forgot_password/enter_new_pass_model.dart';
import 'package:twsl_flutter/src/ui/drive/auth/forgot_password/enter_new_password.dart';
import 'package:twsl_flutter/src/ui/drive/auth/forgot_password/reastore_pass_screen.dart';
import 'package:twsl_flutter/src/ui/drive/auth/login_screen.dart';
import 'package:twsl_flutter/src/ui/drive/auth/registartion/registartion_screen.dart';
import 'package:twsl_flutter/src/ui/drive/auth/user_model.dart';
import 'package:twsl_flutter/src/ui/drive/auth/verification_code_model.dart';
import 'package:twsl_flutter/src/ui/drive/auth/verification_code_screen.dart';
import 'package:twsl_flutter/src/ui/drive/home/details/driver_delivery_details_screen.dart';
import 'package:twsl_flutter/src/ui/drive/home/driver_home_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/change_pass/change_pass_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/change_phone/change_phone_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/delivery_details/delivery_details_model.dart';
import 'package:twsl_flutter/src/ui/drive/profile/delivery_details/delivery_details_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/driver_profile_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/edit_profile/edit_profile_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/payment_history/payment_day_details/payment_day_details_model.dart';
import 'package:twsl_flutter/src/ui/drive/profile/payment_history/payment_day_details/payment_day_details_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/payment_history/payment_history_screen.dart';
import 'package:twsl_flutter/src/ui/drive/profile/trip_history/trip_history_model.dart';
import 'package:twsl_flutter/src/ui/drive/profile/trip_history/trip_history_screen.dart';
import 'package:twsl_flutter/src/ui/splash/splash_screen.dart';

import 'model/base_constants.dart';
import 'model/preferences/preferences_impl.dart';
import 'ui/camera_screen/camera_screen.dart';
import 'ui/splash/splash_model.dart';
import 'ui/ui_utils.dart';

class App extends StatefulWidget {
  final FlutterI18nDelegate _flutterI18nDelegate;

  App(this._flutterI18nDelegate, {Key? key}) : super(key: key);

  @override
  _App createState() => _App();
}

EventBus eventBus = EventBus();

class _App extends State<App> {
  Preferences? _prefs;
  Dio? _client;
  Repository? _repository;
  WebApi? _webApi;
  Directory? _applicationDirectory;
  FirebaseMessaging? _firebaseMessaging;

  @override
  void initState() {
    _prepare();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    preloadImages(context);
    _prepareSync();
    return ChangeNotifierProvider(
      create: (_) => UserModel(_prefs, _repository),
      child: MultiProvider(
        providers: [
          Provider.value(value: _repository),
          Provider.value(value: _prefs),
          Provider.value(value: _firebaseMessaging),
          ChangeNotifierProvider(create: (ctx) => SplashModel(_prefs)),
          ChangeNotifierProvider(
            create: (_) => VerificationCodeModel(_repository),
          ),
          ChangeNotifierProvider(create: (_) => EnterNewPassModel(_repository)),
          ChangeNotifierProvider(
              create: (_) => CameraModel(_applicationDirectory)),
          ChangeNotifierProvider(
              create: (_) => FeedbackModel(_repository, _prefs)),
          ChangeNotifierProvider(create: (_) => PaymentDayDetailsModel()),
          ChangeNotifierProvider(create: (_) => DeliveryDetailsModel()),
          ChangeNotifierProvider(create: (_) => TripHistoryModel(_repository)),
          ChangeNotifierProvider(
            create: (_) => TrackerPositionModel(_repository, _prefs!),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primaryColor: getColorFromHex("BC2954"),
            scaffoldBackgroundColor: getColorFromHex("F3F3F3"),
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: getColorFromHex("454F63"),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                color: "90959DAD".getColor(),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme.apply(
                      bodyColor: "454F63".getColor(),
                      displayColor: "454F63".getColor(),
                    )),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: getColorFromHex("BC2954")),
          ),
          localizationsDelegates: [
            widget._flutterI18nDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
            // DefaultCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale("en"), Locale("ar")],
          builder: FlutterI18n.rootAppBuilder(),
          locale: widget._flutterI18nDelegate.currentLocale,
          initialRoute: Routes.SPLASH,
          routes: {
            Routes.SPLASH: (_) => SplashScreen(),
            Routes.DRIVER_AUTH: (_) => LoginScreen(),
            Routes.FORGOT_PASS: (_) => RestorePassScreen(),
            Routes.ENTER_NEW_PASS: (_) => EnterNewPassword(),
            Routes.REGISTRATION: (_) => RegistrationScreen(),
            Routes.VERIFICATION: (_) => VerificationCodeScreen(),
            Routes.DRIVER_HOME: (_) => DriverHomeScreen(),
            Routes.DRIVER_DELIVERY_DETAILS: (_) =>
                DriverDeliveryDetailsScreen(),
            Routes.DRIVER_PROFILE: (_) => DriverProfileScreen(),
            Routes.EDIT_DRIVER_PROFILE: (_) => EditDriverProfileScreen(),
            Routes.CHANGE_PHONE: (_) => ChangePhoneScreen(),
            Routes.CHANGE_PASS: (_) => ChangePassScreen(),
            // Routes.NAVIGATE: (_) => NavigateScreen(),
            Routes.CAMERA: (_) => CameraView(),
            Routes.TYPE_TRACK: (_) => TypeTrackScreen(),
            Routes.DELIVERY_STATUS: (_) => DeliveryStatusScreen(),
            Routes.ISSUE_FEEDBACK: (_) => IssueFeedbackScreen(),
            Routes.MESSAGE_FEEDBACK: (_) => MessageFeedbackScreen(),
            Routes.PAYMENT_HISTORY: (_) => PaymentHistoryScreen(),
            Routes.PAYMENT_DAY_DETAILS: (_) => PaymentDayDetailsScreen(),
            Routes.DELIVERY_DETAILS: (_) => DeliveryDetailsScreen(),
            Routes.TRIP_HISTORY: (_) => TripHistoryScreen(),
            Routes.CHAT: (_) => ChatScreen(),
          },
        ),
      ),
    );
  }

  preloadImages(BuildContext context) {
    precacheImage(Image.asset("assets/images/im_splash.png").image, context);
    precacheImage(AssetImage("assets/images/im_england.png"), context);
    precacheImage(AssetImage("assets/images/arabia.png"), context);
    precacheImage(Image.asset("assets/images/im_bags.png").image, context);
    precachePicture(
        SvgPicture.asset("assets/icons/ic_user.svg").pictureProvider, context);
    precachePicture(
        SvgPicture.asset("assets/icons/ic_truck.svg").pictureProvider, context);
  }

  _prepareSync() {
    _prefs = PreferencesImpl();
    _client = getClient();
    _webApi = WebApiImpl(_client, _prefs);
    _repository = RepositoryImpl(_webApi);
    _firebaseMessaging = FirebaseMessaging.instance;
    // firebaseMessagingInit(_firebaseMessaging as FirebaseMessaging);
  }

  Future<bool> _prepare() async {
    try {
      _applicationDirectory = await getApplicationDocumentsDirectory();
      return true;
    } catch (e) {
      showToast("Init error = $e");
      print("Init error = $e");
      return false;
    }
  }

  Dio getClient() {
    BaseOptions options = new BaseOptions(
      baseUrl: "https://twslapi.azurewebsites.net",
    );
    var client = Dio(options);
    client.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
    return client;
  }
}
