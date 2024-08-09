import 'package:flutter_dogs_demo/model/dog_img.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vote_image.g.dart';

@JsonSerializable()
class VoteImage {
  final int id;
  final int value;
  final DogImg image;

  VoteImage({required this.id, required this.value, required this.image});

  factory VoteImage.fromJson(Map<String, dynamic> json) =>
      _$VoteImageFromJson(json);
  Map<String, dynamic> toJson() => _$VoteImageToJson(this);
}
