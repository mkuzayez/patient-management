class AppEndPoint {
  const AppEndPoint._();

  static const home = Home();
  static const auth = Auth();
  static const meals = Meals();
  static const workouts = Workouts();
  static const tracking = Tracking();
  static const profile = Profile();
  static const plans = Plans();
}

class Home {
  const Home();

  final String refreshToken = '/auth/refresh';
  final String getNotification = '/client/notifications';
  final String markNotificationAsRead = '/client/notifications/mark-as-read';

}

class Auth {
  const Auth();

  final String login = '/auth/login';
  final String postCode = '/auth/verify-email';
  final String signup = '/onboarding/step-one';
  final String logout = '/auth/logout';
  final String updateProfile = '/auth/profile/update';
  final String forgotPassword = 'auth/password/forget_request';
  final String submitPassword = '/auth/password/confirm_reset';
}

class Meals {
  const Meals();

  final String getUserMeals = '/client/meals';
  final String getAllMeals = '/client/all-meals';
  final String checkMeal = '/client/check-meal';
  final String changeMeal = '/client/change-meal';
}

class Workouts {
  const Workouts();

  final String getUserWorkouts = '/client/workouts';
  final String updateWorkout = '/client/edit-workout-details';
}

class Tracking {
  const Tracking();

  final String getChartData = '/client/weight-tracker-chart';
  final String updateProgress = '/client/progress';
}

class Profile {
  const Profile();

  final String getNumber = '/client/setting/contact-us';
  final String getPrivacyPolicy = '/client/setting/privacy-policy';
}

class Plans {
  const Plans();

  final String getPlans = '/client/plans';
  final String postPayment = '/client/subscribe';
}
