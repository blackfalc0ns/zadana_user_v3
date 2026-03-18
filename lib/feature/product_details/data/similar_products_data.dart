import 'package:zadana_user_v3/feature/home/domain/entities/product_model.dart';

class SimilarProductsData {
  static List<ProductModel> getSimilarProducts() {
    return [
      const ProductModel(
        id: '1',
        name: 'طماطم طازجة',
        store: 'متجر الخضار',
        price: 15.0,
        oldPrice: 20.0,
        imageUrl: '',
        emoji: '🍅',
        rating: 4.5,
        reviewCount: 120,
      ),
      const ProductModel(
        id: '2',
        name: 'خيار أخضر',
        store: 'متجر الخضار',
        price: 12.0,
        imageUrl: '',
        emoji: '🥒',
        rating: 4.2,
        reviewCount: 85,
      ),
      const ProductModel(
        id: '3',
        name: 'جزر طازج',
        store: 'متجر الخضار',
        price: 18.0,
        oldPrice: 22.0,
        imageUrl: '',
        emoji: '🥕',
        rating: 4.7,
        reviewCount: 95,
      ),
      const ProductModel(
        id: '4',
        name: 'فلفل أحمر',
        store: 'متجر الخضار',
        price: 25.0,
        imageUrl: '',
        emoji: '🌶️',
        rating: 4.3,
        reviewCount: 67,
      ),
      const ProductModel(
        id: '5',
        name: 'بصل أبيض',
        store: 'متجر الخضار',
        price: 10.0,
        imageUrl: '',
        emoji: '🧅',
        rating: 4.1,
        reviewCount: 78,
      ),
      const ProductModel(
        id: '6',
        name: 'باذنجان أسود',
        store: 'متجر الخضار',
        price: 20.0,
        oldPrice: 25.0,
        imageUrl: '',
        emoji: '🍆',
        rating: 4.4,
        reviewCount: 92,
      ),
    ];
  }
}