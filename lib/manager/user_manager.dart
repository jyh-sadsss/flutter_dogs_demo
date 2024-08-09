import 'package:shared_preferences/shared_preferences.dart'; // 持久化存储

class UserManager {
  static final UserManager _instance =
      UserManager._internal(); // 单例模式，这里才是真正的在调用，只调用了一次

  factory UserManager() => _instance; // 创建类的实例的时候，会执行这个构造函数

  UserManager._internal(); // 定义私有构造函数，这里只是在定义，没有调用，这个构造函数中没有实现内容

  SharedPreferences? _pref;

  static const _userIdKey = "userId";

  Future<String?> getUserId() async {
    // 实例方法
    _pref ??= await SharedPreferences.getInstance();
    return _pref!.getString(_userIdKey); // 获取持久化数据
  }

  Future<bool> setUserId(String value) async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref!.setString(_userIdKey, value); // 非空，存储持久化数据
  }

  // 判断是否已经登录
  Future<bool> get isLogin async {
    String? userId = await getUserId();
    return userId != null;
  }

  Future<void> logout() async {
    _pref ??= await SharedPreferences.getInstance();
    _pref!.clear(); // 清空全部
  }

  // 退出登录
}
