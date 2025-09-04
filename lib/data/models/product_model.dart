import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class ProductModel extends Equatable {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final double price;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String category;
  
  @HiveField(5)
  final String image;
  
  @HiveField(6)
  final RatingModel rating;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        price,
        description,
        category,
        image,
        rating,
      ];
}

@HiveType(typeId: 2)
@JsonSerializable()
class RatingModel extends Equatable {
  @HiveField(0)
  final double rate;
  
  @HiveField(1)
  final int count;

  const RatingModel({
    required this.rate,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);

  @override
  List<Object?> get props => [rate, count];
}
