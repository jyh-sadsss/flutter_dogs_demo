import 'package:flutter_dogs_demo/model/dog_img.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_image.g.dart';

@JsonSerializable()
class FavoriteImage {
  final int id;
  final DogImg image;

  FavoriteImage({required this.id, required this.image});

  factory FavoriteImage.fromJson(Map<String, dynamic> json) =>
      _$FavoriteImageFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteImageToJson(this);
}
