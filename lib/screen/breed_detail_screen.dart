import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dogs_demo/http/network_repository.dart';
import 'package:flutter_dogs_demo/model/api.dart';
import 'package:flutter_dogs_demo/model/breed.dart';
import 'package:flutter_dogs_demo/model/dog_img.dart';

class BreedDetailScreen extends StatefulWidget {
  final Breed breed; // 这里不允许下划线命名
  const BreedDetailScreen({super.key, required this.breed});

  @override
  State<StatefulWidget> createState() => _BreedDetailScreen();
}

class _BreedDetailScreen extends State<BreedDetailScreen> {
  final List<DogImg> _images = [];

  @override
  initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final repository = NetworkRepository();
    final list =
        await repository.searchImage(limit: 10, breedId: widget.breed.id);
    setState(() {
      _images.addAll(list);
    });
  }

  Widget _buildImageItem(DogImg image) {
    return Image.network(
      image.url.replaceAll(imgBaseUrl, imgTargetUrl),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 300,
    );
  }

  Widget _buildImagesView() {
    return PageView(
      children: _images.map((image) => _buildImageItem(image)).toList(),
    );
  }

  Widget _buildBreedTitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildBreedInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15),
      child: Text(text,
          style: const TextStyle(fontSize: 14, color: Color(0xff333333))),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      height: 40,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white),
        child: const Text(
          '了解更多',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildBreedBottomPanel() {
    final breed = widget.breed;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.only(top: 15),
        width: double.infinity,
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreedTitle(breed.name),
            _buildBreedInfoItem("性格"),
            _buildBreedInfoItem(breed.temperament ?? '性格暂无'),
            _buildBreedInfoItem("寿命"),
            _buildBreedInfoItem(breed.lifeSpan),
            _buildBreedInfoItem("用途"),
            _buildBreedInfoItem(breed.bredFor ?? '用途暂无'),
            const Spacer(),
            _buildBottomButton(),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('品种详情'),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 300,
            child: _buildImagesView(),
          ),
          _buildBreedBottomPanel(),
        ],
      ),
    );
  }
}
