import 'package:json_annotation/json_annotation.dart';

part "dog_img.g.dart";

@JsonSerializable()
class DogImg {
  final String id;
  final String url;

  DogImg({required this.id, required this.url});

  factory DogImg.fromJson(Map<String, dynamic> json) => _$DogImgFromJson(json);

  Map<String, dynamic> toJson() => _$DogImgToJson(this);
}
