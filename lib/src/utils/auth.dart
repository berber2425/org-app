import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:org_data/org_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  AuthController._();

  static final _instance = AuthController._();

  factory AuthController() => _instance;

  bool initialized = false;

  String? _token;

  String get token {
    assert(isAuthenticated, "check if user is authenticated");
    return _token!;
  }

  bool get isAuthenticated => _token != null;

  bool get hasUser => _user != null;

  bool get hasVerificationSession => _authInfo?.v_session != null;

  bool get isAdmin {
    return _admin != null;
  }

  Fragment$PublicUser? _user;

  Fragment$PublicUser get user {
    assert(isAuthenticated, "check if user is authenticated");
    return _user!;
  }

  Fragment$MeAdmin? _admin;

  Fragment$MeAdmin get admin {
    assert(isAuthenticated, "check if user is authenticated");
    assert(isAdmin, "check if user is admin");
    return _admin!;
  }

  Fragment$AuthInfo? _authInfo;

  Fragment$AuthInfo get authInfo {
    assert(isAuthenticated, "check if user is authenticated");
    return _authInfo!;
  }

  bool get emailVerified {
    assert(isAuthenticated, "check if user is authenticated");
    return _authInfo!.verified;
  }

  String? get verificationSession {
    assert(hasVerificationSession, "check if user is authenticated");
    return _authInfo!.v_session;
  }

  Future<bool> ensureAuthenticated(
    BuildContext context,
    FutureOr<void> Function() onAuthenticated,
  ) async {
    if (!isAuthenticated) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => const Text("TO SIGN UP")));
      if (!isAuthenticated) {
        return false;
      }
    }
    final res = onAuthenticated();

    if (res is Future) {
      await res;
    }

    return true;
  }

  Future<String?> getLocalToken() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString('token');
  }

  Future<void> setLocalToken(String token) async {
    _token = token;
    final instance = await SharedPreferences.getInstance();
    await instance.setString('token', token);
  }

  Future<void> removeLocalToken() async {
    _token = null;
    _admin = null;
    _user = null;
    final instance = await SharedPreferences.getInstance();
    await instance.remove('token');
    notifyListeners();
  }

  // Future<void> updateProfile(Map<String, String> data,
  //     [Map<String, MediaInputValue>? imgs]) async {
  //   final res = await API().auth.updateProfile(data, imgs);
  //   await UserRepository().update(res.id);
  //   await fetchMe();
  // }

  Future<void> init([String? token]) async {
    if (token != null) {
      _token = token;
    } else {
      _token ??= await getLocalToken();
    }

    if (_token != null) {
      try {
        GlobalClient().additionalHeaders["authorization"] = "Bearer $_token";

        await fetchMe();

        if (_token != null) {
          await setLocalToken(_token!);
          await onAuthenticated(_token!);
        }
      } catch (e, s) {
        _token = null;
        if (kDebugMode) {
          print("Error: $e, $s");
        }
      }
    }
    initialized = true;
    notifyListeners();
  }

  Future<void> fetchMe() async {
    try {
      final res = await Api.auth.query.me();
      _user = res.user;
      _admin = res.admin;
      // _authInfo = res.info;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Auth Error: $e");
      }
      _user = null;
      _admin = null;
      _authInfo = null;
      notifyListeners();
    }
  }

  Future<void> onAuthenticated(String token) async {}

  Future<void> onUnauthenticated() async {}

  Future<void> forgotPassword(String email) async {
    // final res = await API().auth.forgotPassword(email);
    // _authInfo = AuthInfo(verified: true, verificationSession: res);
    notifyListeners();
  }

  String? pwdUsage;

  Future<void> verifyForgotPassword(String code) async {
    // assert(hasVerificationSession, "check if user has verification session");
    // final res = await API().auth.verifyPwd(verificationSession!, code);
    // pwdUsage = res;
    notifyListeners();
  }

  Future<void> setNewPwd(String password) async {
    // assert(pwdUsage != null, "check if password usage is set");
    // final res =
    //     await API().auth.setNewPwd(pwdUsage!, verificationSession!, password);

    // _authInfo = res.info;
    // _user = res.user;
    // _admin = res.admin;
    // if (isAdmin) {
    //   await AdminLocalizationManager().init();
    // }
    // await setLocalToken(res.info.token!);
    // await onAuthenticated(res.info.token!);
    notifyListeners();
  }

  Future<void> signUpWithEmail(
    String email,
    String password, [
    String? userName,
  ]) async {
    // final res = await API().auth.registerPwd(email, password, userName);
    // _authInfo = res.info;
    // _user = res.user;

    // notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    final data = await Api.auth.mutations.loginEmail(email, password);
    _authInfo = data.auth;
    _user = data.user;
    _admin = data.admin;

    if (_authInfo!.verified) {
      await setLocalToken(_authInfo!.token!);
      await onAuthenticated(_authInfo!.token!);
    }
    notifyListeners();
  }

  Future<void> verifyEmail(String code) async {
    // assert(hasVerificationSession, "check if user has verification session");
    // final res = await API().auth.verify(verificationSession!, code);
    // _authInfo = res.info;
    // _user = res.user;
    // _admin = res.admin;
    // if (isAdmin) {
    //   await AdminLocalizationManager().init();
    // }
    // await setLocalToken(res.info.token!);
    // await onAuthenticated(res.info.token!);
    // notifyListeners();
  }

  Future<void> logout() async {
    // await API().auth.logout();
    // _token = null;
    // _user = null;
    // _admin = null;

    // await removeLocalToken();
    // await onUnauthenticated();
  }

  Future<void> refreshAdmin() async {
    // final res = await API().auth.me();
    // _admin = res.admin;
    // if (isAdmin) {
    //   await AdminLocalizationManager().init();
    // }
    // notifyListeners();
  }
}
