import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasmee3/model/user_model.dart';

class LocalStorageData extends GetxController {
  Future<UserModel> get getUser async {
    try {
      UserModel userModel = await _getUserData();
      if (userModel == null)
        return null;
      else
        return userModel;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel> _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var value = pref.getString('user');
    return UserModel.fromJson(await json.decode(value));
  }

  Future<void> setUser(UserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('user', json.encode(userModel.toJson()));
  }

  Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
