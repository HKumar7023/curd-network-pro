import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import 'product_model.dart';
import 'cart_item_model.dart';

extension ProductModelMapper on ProductModel {
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toEntity(),
    );
  }
}

extension ProductMapper on Product {
  ProductModel toModel() {
    return ProductModel(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating.toModel(),
    );
  }
}

extension RatingModelMapper on RatingModel {
  Rating toEntity() {
    return Rating(
      rate: rate,
      count: count,
    );
  }
}

extension RatingMapper on Rating {
  RatingModel toModel() {
    return RatingModel(
      rate: rate,
      count: count,
    );
  }
}

extension CartItemModelMapper on CartItemModel {
  CartItem toEntity() {
    return CartItem(
      product: product.toEntity(),
      quantity: quantity,
    );
  }
}

extension CartItemMapper on CartItem {
  CartItemModel toModel() {
    return CartItemModel(
      product: product.toModel(),
      quantity: quantity,
    );
  }
}
