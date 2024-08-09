import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/http/network_repository.dart';
import 'package:flutter_dogs_demo/manager/user_manager.dart';
import 'package:flutter_dogs_demo/model/api.dart';
import 'package:flutter_dogs_demo/model/dog_img.dart';
import 'package:flutter_dogs_demo/screen/profile_screen.dart';
import 'package:flutter_dogs_demo/widget/loading_dialog.dart';
import 'package:flutter_dogs_demo/widget/tips_dialog.dart';

class DogsScreen extends StatefulWidget {
  const DogsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DogsScreen();
}

class _DogsScreen extends State<DogsScreen> {
  // 定义一个可能为空的变量
  DogImg? _currentUrl;

  @override
  void initState() {
    // 获取一张图片
    super.initState();
    // 判断页面是否已经销毁，已经销毁则不能再发起请求·
    if (mounted) {
      _getRandomDogImage();
    }
  }

  void _showLoading() {
    showDialog(context: context, builder: (context) => const LoadingDialog());
  }

  void _hideLoading() {
    Navigator.of(context).pop();
  }

  void _showTips(String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) => TipsDialog(content: content));
  }

  void _getRandomDogImage() async {
    final reponsitory = NetworkRepository();
    final images = await reponsitory.searchImage(limit: 1);
    if (images.isNotEmpty) {
      setState(() {
        _currentUrl = images.first;
      });
    }
  }

  void _switchNextImage() async {
    final reponsitory = NetworkRepository();
    _showLoading();
    final images = await reponsitory.searchImage(limit: 1);
    _hideLoading();
    if (images.isNotEmpty) {
      setState(() {
        _currentUrl = images.first;
      });
    }
  }

  Future<bool> _isLogin() async {
    final login = await UserManager().isLogin;
    print('登录状态: $login');
    if (login == false) {
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ProfileScreen();
        }));
      }
      return false;
    }
    return true;
  }

  void _addToFavorites(String id) async {
    if (!await _isLogin()) return;
    final reponsitory = NetworkRepository();
    _showLoading();
    final result = await reponsitory.addToFaviortes(imageId: id);
    _hideLoading();
    if (result) {
      _showTips('已成功添加“喜欢”');
      // 切换下一张
      _switchNextImage();
    } else {
      _showTips('操作失败');
    }
  }

  void _voteImage(String id, bool value) async {
    if (!await _isLogin()) return;
    final reponsitory = NetworkRepository();
    _showLoading();
    final result = await reponsitory.voteImage(imageId: id, value: value);
    _hideLoading();
    if (result) {
      _showTips(value ? '已点赞' : '已取消点赞');
      _switchNextImage();
    } else {
      _showTips('操作失败');
    }
  }

  // 返回一个widget
  Widget _buildImage(String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url.replaceAll(imgBaseUrl, imgTargetUrl),
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            print('Failed to load image: $exception');
            return const Text('Failed to load image');
          },
        ),
      ),
    );
  }

  Widget _buildButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    double size = 25;
    return IconButton(
      color: const Color(0xff999999),
      icon: Image.asset(
        'images/icons/$icon',
        width: size,
        height: size,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('首页'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentUrl != null) _buildImage(_currentUrl!.url),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                _buildButton(
                    icon: 'favorite.png',
                    onPressed: () {
                      if (_currentUrl != null) {
                        _addToFavorites(_currentUrl!.id);
                      }
                    }),
                const Spacer(),
                _buildButton(
                    icon: 'thumb_up.png',
                    onPressed: () {
                      if (_currentUrl != null) {
                        _voteImage(_currentUrl!.id, true);
                      }
                    }),
                _buildButton(
                    icon: 'thumb_down.png',
                    onPressed: () {
                      if (_currentUrl != null) {
                        _voteImage(_currentUrl!.id, false);
                      }
                    }),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ));
  }
}
