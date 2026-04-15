import 'package:injectable/injectable.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/product_details/data/data_source/product_details_remote_data_source.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/product_details_response_model_dto.dart';

@Injectable(as: ProductDetailsRemoteDataSource)
class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  const ProductDetailsRemoteDataSourceImpl(this._apiServices);
  final ApiServices _apiServices;

  @override
  Future<ProductDetailsResponseModelDto> getProductDetails(String productId) {
    return _apiServices.getProductDetails(productId);
  }
}
