import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dogs_demo/model/api.dart';
import 'package:flutter_dogs_demo/model/breed.dart';
import 'package:flutter_dogs_demo/model/contant.dart';
import 'package:flutter_dogs_demo/model/dog_img.dart';
import 'package:flutter_dogs_demo/model/favorite_image.dart';
import 'package:flutter_dogs_demo/model/vote_image.dart';

class NetworkRepository {
  final Dio _dio;
  // 定义私有成员变量
  static final _instance = NetworkRepository._();

  NetworkRepository._() : _dio = Dio() {
    // 直接初始化_dio实例，{} 后面对_dio进一步配置
    _dio.options = BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 300),
        sendTimeout: const Duration(seconds: 300),
        receiveTimeout: const Duration(seconds: 300));
  }

  factory NetworkRepository() => _instance;

  Future<List<DogImg>> searchImage({required int limit, int? breedId}) async {
    final response = await _dio.get(apiSearch,
        queryParameters: {"limit": limit, 'breedId': breedId},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) {
      final List<dynamic> list = response.data ?? [];
      return list
          .map((e) => DogImg.fromJson(e as Map<String, dynamic>))
          .toList(); // 转换成实例
    }
    return [];
  }

  Future<bool> addToFaviortes({required String imageId}) async {
    final response = await _dio.post(apiFaviorites,
        data: {"image_id": imageId},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<bool> voteImage({required String imageId, required bool value}) async {
    final response = await _dio.post(apiVotes,
        data: {"image_id": imageId, "value": value ? 1 : 0},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));

    return response.statusCode == 201;
  }

  Future<List<Breed>> getBreeds({required int size, required int page}) async {
    final response = await _dio.get(apiBreeds,
        queryParameters: {"limit": size, "page": page},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) {
      List<dynamic> list = response.data ?? [];
      return list
          .map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList(); // map 和 toList联合使用
    }
    return [];
  }

  Future<List<FavoriteImage>> getFavoriteIamges() async {
    final response = await _dio.get(apiFaviorites,
        queryParameters: {"sub_id": sub_id},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) {
      List<dynamic> list = response.data ?? [];
      return list
          .map((e) => FavoriteImage.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<VoteImage>> getVoteImages() async {
    final response = await _dio.get(apiVotes,
        queryParameters: {"sub_id": sub_id},
        options: Options(headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json'
        }));
    if (response.statusCode == 200) {
      List<dynamic> list = response.data ?? [];
      return list
          .where((e) => e is Map<String, dynamic> && (e['value'] as int) == 1)
          .map((e) => VoteImage.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
