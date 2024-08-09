// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteImage _$VoteImageFromJson(Map<String, dynamic> json) => VoteImage(
      id: (json['id'] as num).toInt(),
      value: (json['value'] as num).toInt(),
      image: DogImg.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoteImageToJson(VoteImage instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'image': instance.image,
    };
