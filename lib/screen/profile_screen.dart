import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/http/network_repository.dart';
import 'package:flutter_dogs_demo/manager/user_manager.dart';
import 'package:flutter_dogs_demo/model/api.dart';
import 'package:flutter_dogs_demo/model/favorite_image.dart';
import 'package:flutter_dogs_demo/model/vote_image.dart';
import 'package:flutter_dogs_demo/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

enum ProfileTab { favorites, likes }

class _ProfileScreen extends State<ProfileScreen> {
  ProfileTab _currentTab = ProfileTab.favorites;
  final List<FavoriteImage> _favoriteImages = [];
  final List<VoteImage> _voteImages = [];
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _init();
  }

  void _init() async {
    // initState里面可以不使用setState，本身initState会在UI初始渲染后执行
    final reponsitory = NetworkRepository();
    List<FavoriteImage> flist = await reponsitory.getFavoriteIamges();
    List<VoteImage> vlist = await reponsitory.getVoteImages();
    final isLogin = await UserManager().isLogin;
    setState(() {
      _isLogin = isLogin;
    });
    if (!mounted) return;
    setState(() {
      _favoriteImages.addAll(flist);
      _voteImages.addAll(vlist);
    });
  }

  Widget _buildUserItemView({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
              color: Colors.green, fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: const Color(0xfff5f5f5),
        child: Row(
          children: [
            _buildTabBarItem(
                text: "收藏 121",
                isSelected: _currentTab == ProfileTab.favorites,
                onTap: () {
                  setState(() {
                    _currentTab = ProfileTab.favorites;
                  });
                }),
            _buildTabBarItem(
                text: "喜欢 231",
                isSelected: _currentTab == ProfileTab.likes,
                onTap: () {
                  setState(() {
                    _currentTab = ProfileTab.likes;
                  });
                })
          ],
        ));
  }

  Widget _buildTabBarItem(
      {required String text,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? Colors.green : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildImageItemView(dynamic image, int space) {
    return Container(
      margin: EdgeInsets.only(top: space.toDouble()),
      child: Image.network(
        image.image.url.replaceAll(imgBaseUrl, imgTargetUrl),
        height: 300,
        width: double.infinity, // 无限大
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVoteImagesView() {
    return ListView.builder(
        itemCount: _voteImages.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildImageItemView(_voteImages[index], index == 0 ? 0 : 15);
        });
  }

  Widget _buildFavoriteImagesView() {
    return ListView.builder(
        itemCount: _favoriteImages.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildImageItemView(
              _favoriteImages[index], index == 0 ? 0 : 15);
        });
  }

  void _login() async {
    final loginState =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginScreen();
    }));
    setState(() {
      _isLogin = loginState as bool;
    });
  }

  void _logout() async {
    final userManager = UserManager();
    userManager.logout();
    setState(() {
      _isLogin = false;
    });
  }

  // 未登录状态，展示登录按钮
  Widget _buildAnonView() {
    return Center(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff333333),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 圆角
          ),
        ),
        onPressed: _login,
        child: const Text(
          '登录',
          style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w500),
        ),
      ),
    ));
  }

  Widget _buildMyInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 30),
        const Center(
          child: CircleAvatar(
            radius: 30, // 半径
            backgroundImage: AssetImage("images/avatar.png"),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUserItemView(label: '图片', value: "121"),
            _buildUserItemView(label: '粉丝', value: "1.2k"),
            _buildUserItemView(label: '关注', value: "402")
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        _buildTabBar(),
        Expanded(
            // 无限长，注意组件的优先级顺序
            child: IndexedStack(
          index: _currentTab.index,
          children: [_buildFavoriteImagesView(), _buildVoteImagesView()],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('profile登录状态2: $_isLogin');
    return Scaffold(
        appBar: AppBar(
          title: const Text('我的'),
          actions: [
            if (_isLogin) // 满足登录条件，插入一个Widget
              TextButton(onPressed: _logout, child: const Text("退出登录"))
          ],
        ),
        body: _isLogin ? _buildMyInfo() : _buildAnonView());
  }
}
