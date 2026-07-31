// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const CART = _Paths.CART;
  static const ORDER_TRACKING = _Paths.ORDER_TRACKING;
  static const ADMIN_DASHBOARD = _Paths.ADMIN_DASHBOARD;
  static const CHECKOUT = _Paths.CHECKOUT;
  static const SERVICE_DETAIL = _Paths.SERVICE_DETAIL;
  static const SERVICES = _Paths.SERVICES;
  static const ORDER_HISTORY = _Paths.ORDER_HISTORY;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const CART = '/cart';
  static const ORDER_TRACKING = '/order-tracking';
  static const ADMIN_DASHBOARD = '/admin-dashboard';
  static const CHECKOUT = '/checkout';
  static const SERVICE_DETAIL = '/service-detail';
  static const SERVICES = '/services';
  static const ORDER_HISTORY = '/order-history';
  static const EDIT_PROFILE = '/edit-profile';
}
