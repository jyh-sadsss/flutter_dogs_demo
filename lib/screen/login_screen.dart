import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/manager/user_manager.dart';
import 'package:flutter_dogs_demo/model/contant.dart';
import 'package:flutter_dogs_demo/widget/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  String? _email;
  String? _passord;

  Widget _buildTextField(
      {required IconData icon,
      required String placeholder,
      required Function(String) onChanged}) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 6),
            hintText: placeholder,
            prefixIcon: Icon(icon),
            fillColor: Colors.lightBlueAccent,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none),
          ),
          onChanged: onChanged),
    );
  }

  void _showLoading() {
    showDialog(context: context, builder: (context) => const LoadingDialog());
  }

  void _hideLoading() {
    Navigator.pop(context);
  }

  void _login() async {
    _showLoading();
    await Future.delayed(const Duration(seconds: 3));
    _hideLoading();
    final userManager = UserManager();
    userManager.setUserId(user_id);
    if (mounted) {
      Navigator.pop(context, userManager.isLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
          centerTitle: true,
        ),
        body: Center(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max, // 最大大小
            children: [
              const Text(
                '登录',
                style: TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildTextField(
                  icon: Icons.email,
                  placeholder: "邮箱",
                  onChanged: (email) {
                    setState(() {
                      _email = email;
                    });
                  }),
              const SizedBox(height: 15),
              _buildTextField(
                  icon: Icons.lock,
                  placeholder: "密码",
                  onChanged: (password) {
                    setState(() {
                      _passord = password;
                    });
                  }),
              const SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff333333),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed:
                          _email != null && _passord != null ? _login : null,
                      child: const Text('登录'),
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
