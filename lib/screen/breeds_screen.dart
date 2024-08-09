import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/http/network_repository.dart';
import 'package:flutter_dogs_demo/model/api.dart';
import 'package:flutter_dogs_demo/model/breed.dart';
import 'package:flutter_dogs_demo/screen/breed_detail_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _BreedsScreen();
}

class _BreedsScreen extends State<BreedsScreen> {
  int page = 1;
  int size = 20;
  final List<Breed> _breeds = [];
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  final ScrollController _controller = ScrollController();

  Future<void> _loadMore() async {
    if (_isRefreshing || _isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    final reponsitory = NetworkRepository();
    List<Breed> breeds =
        await reponsitory.getBreeds(page: page + 1, size: size);
    setState(() {
      _breeds.addAll(breeds);
      page++;
      _isLoading = false;
      if (breeds.length < size) {
        _hasMore = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _init();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _init() async {
    final repository = NetworkRepository();
    List<Breed> list = await repository.getBreeds(page: page, size: size);
    setState(() {
      _breeds.addAll(list);
    });
  }

  Future<void> _onRefresh() async {
    // 是否正在加载更多或者正在刷新
    if (_isLoading || _isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });
    final repository = NetworkRepository();
    List<Breed> breeds = await repository.getBreeds(size: size, page: 1);
    setState(() {
      _breeds.clear();
      _breeds.addAll(breeds);
      _isRefreshing = false;
      page = 1;
    });
  }

  Widget _buildItem(Breed breed) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BreedDetailScreen(breed: breed);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(children: [
                Image.network(
                  breed.image.url.replaceAll(imgBaseUrl, imgTargetUrl),
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 20,
                    color: Colors.white,
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                )
              ]),
            ),
            const SizedBox(height: 5),
            Text(
              breed.name,
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(breed.bredFor ?? '属性占位')
          ],
        ),
      ),
    );
  }

  Widget _buildTips() {
    print('加载完成loading: $_isLoading page: $page');
    if (_isLoading || !_hasMore) {
      return Container(
          height: 50,
          alignment: Alignment.center,
          child: Text(_isLoading ? '加载中...' : '已加载全部'));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('品种'),
        ),
        // 下拉刷新
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: [
              Expanded(
                child: MasonryGridView.count(
                    controller: _controller,
                    itemCount: _breeds.length, // 要设置这个，不然会报错
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    itemBuilder: (BuildContext context, int index) =>
                        _buildItem(_breeds[index])),
              ),
              _buildTips()
            ],
          ),
        ));
  }
}
