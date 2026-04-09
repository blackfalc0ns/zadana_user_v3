import 'package:zadana_user_v3/feature/product_details/data/models/product_details_response_model_dto.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<ProductDetailsResponseModelDto> getProductDetails(String productId);
}
