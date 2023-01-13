class Routes {
  static const SPLASH = "/";
  static const AUTHENTICATION = "/authentication";

  static const VERIFICATION = "/verification";

  static const DRIVER_AUTH = "/driver/auth";
  static const FORGOT_PASS = "/driver/auth/forgot_pass";
  static const ENTER_NEW_PASS = "driver/auth/forgot_pass/enter_new_pass";
  static const REGISTRATION = "/driver/registration";
  static const SECOND_REGISTRATION = "/driver/registration/second_registration";
  static const DRIVER_HOME = "/driver/home";
  static const DRIVER_DELIVERY_DETAILS = "/drive/home/delivery_details";
  static const DRIVER_PROFILE = "/driver/home/profile";
  static const EDIT_DRIVER_PROFILE = "/driver/home/profile/edit";
  static const CHANGE_PHONE = "/driver/home/profile/change_phone";
  static const CHANGE_PASS = "/driver/home/profile/change_pass";
  static const PAYMENT_HISTORY = "/driver/home/profile/payment_history";
  static const PAYMENT_DAY_DETAILS =
      "/driver/home/profile/payment_history/payment_day_details";
  static const DELIVERY_DETAILS = "/driver/home/profile/delivery_details";
  static const TRIP_HISTORY = "/driver/home/profile/trip_history";
  static const NAVIGATE = "/driver/navigate";

  static const TYPE_TRACK = "/customer/type_track";
  static const DELIVERY_STATUS = "/customer/delivery_status";
  static const ISSUE_FEEDBACK = "/customer/delivery_status/issue_feedback";
  static const MESSAGE_FEEDBACK =
      "/customer/delivery_status/issue_feedback/message_feedback";

  static const CHAT = "/home/delivery_details/chat";
  static const CAMERA = "/camera";
}

enum WayToVerification { phone, email }

class WayVerifyResource {
  static String getName(WayToVerification? wayToVerification) {
    switch (wayToVerification) {
      case WayToVerification.phone:
        return "Phone";
      case WayToVerification.email:
        return "Email";
      default:
        return "Email";
    }
  }
}

class LocalPaths {
  static const DIR_PICTURES = "/pictures";
}

const PROFILE_PHOTO_NAME = "profile_photo.jpg";
