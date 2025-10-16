import 'package:flutter/material.dart';
import '../View/onboarding_screen/onboarding_screen.dart';
import '../View/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splashScreen = '/SplashScreen';
  static const String onBoardingScreen = '/Onloadingscreen';
  static const String loginScreen = '/Loginscreen';
  static const String otpVerificationScreen = '/otpVerificationScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String createPasswordScreen = '/createPasswordScreen';
  static const String signInScreen = '/signInScreen';
  static const String homeScreen = '/HomeScreen';
  static const String categorieScreen = '/categorieScreen';
  static const String productListScreen = '/ProductListScreen';
  static const String aseelCapitalscreen = '/AseelCapitalscreen';
  static const String aseelMapscreen = '/AseelMapscreen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String myOrderScreen = '/myOrderScreen';
  static const String myPaymentsAScreen = '/MyPaymentsAScreen';
  static const String shoppingScreen = '/ShoppingScreen';
  static const String couponApplyScreen = '/CouponApplyScreen';
  static const String couponSuccsessSCreen = '/CouponSuccsessSCreen';
  static const String emptyShoppingScreen = '/EmptyShoppingScreen';
  static const String addressScreen = '/AddressScreen';
  static const String newAddressScreen = '/NewAddressScreen';
  static const String checkoutScreen = '/CheckoutScreen';
  static const String profileScreen = '/ProfileScreen';
  static const String settingScreen = '/SettingScreen';
  static const String editProfileScreen = '/EditProfileScreen';
  static const String productDetailScreen = '/ProductDetailScreen';
  static const String favouriteScreen = '/FavouriteScreen';
  static const String paymentScreen = '/PaymentScreen';
  static const String changePasswordScreen = '/ChangePasswordScreen';
  static const String deleteAccountScreen = '/DeleteAccountScreen';
  static const String searchScreen = '/SearchScreen';
  static const String forgotVerification = '/ForgotVerification';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    onBoardingScreen: (context) => const OnBoardingScreen(),
    // loginScreen: (context) => const LoginScreen(popOnSuccess: false),
  };
}
