import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/screen/breeds_screen.dart';
import 'package:flutter_dogs_demo/screen/dogs_screen.dart';
import 'package:flutter_dogs_demo/screen/profile_screen.dart';
import 'package:flutter_dogs_demo/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum HomeTab { dogs, breeds, profile }

// 底部按钮排列的两中方式，设置Row mainAxisAlignment 或者 使用Expanded

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _selectedTab = HomeTab.dogs;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _selectedTab.index, keepPage: true);
  }

  void _switchTab(HomeTab tab) {
    if (tab != _selectedTab) {
      setState(() {
        _selectedTab = tab;
      });
      _pageController.animateToPage(tab.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.bounceInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedTab = HomeTab.values[index];
          });
        },
        children: const [DogsScreen(), BreedsScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            _HomeTabButton(
              icon: 'home.png',
              label: '首页',
              groupValue: HomeTab.dogs,
              value: _selectedTab,
              onTap: () {
                setState(() {
                  _switchTab(HomeTab.dogs);
                });
              },
            ),
            _HomeTabButton(
              icon: 'widgets.png',
              label: '品种',
              groupValue: HomeTab.breeds,
              value: _selectedTab,
              onTap: () {
                _switchTab(HomeTab.breeds);
              },
            ),
            _HomeTabButton(
              icon: 'person.png',
              label: '我的',
              groupValue: HomeTab.profile,
              value: _selectedTab,
              onTap: () {
                _switchTab(HomeTab.profile);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  final String icon;
  final String label;
  final HomeTab groupValue;
  final HomeTab value;
  final VoidCallback onTap;

  const _HomeTabButton(
      {required this.icon,
      required this.label,
      required this.groupValue,
      required this.value,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSeleted = value == groupValue;
    final color = isSeleted ? tabActiveColor : tabInactiveColor;
    return Expanded(
        child: GestureDetector(
            onTap: onTap,
            child: Column(children: [
              Image.asset(
                'images/icons/$icon',
                width: 25,
                height: 25,
                color: color,
              ),
              Text(
                label,
                style: TextStyle(color: color, fontSize: 14),
              )
            ])));
  }
}
