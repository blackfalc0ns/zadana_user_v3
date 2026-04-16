import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:zadana_user_v3/core/network/network_constants.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/add_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/customer_address_item_dto.dart';
import 'package:zadana_user_v3/feature/addresses/data/models/update_customer_address_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/request/forget_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/forget_password/data/models/response/forget_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/login_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/login/data/models/login_response_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/logout/data/models/request/logout_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/request/register_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/register/data/models/response/register_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/request/reset_password_request_dto.dart';
import 'package:zadana_user_v3/feature/auth/reset_password/data/models/response/reset_password_response_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_request_model_dto.dart';
import 'package:zadana_user_v3/feature/auth/verify_otp/data/models/verify_otp_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/brand/data/models/brand_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/cart_vendors_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/add_cart_item_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/request/update_cart_item_quantity_request_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/add_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/clear_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/get_cart_response_dto.dart';
import 'package:zadana_user_v3/feature/cart/data/models/response/remove_cart_item_response_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_filters_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_products_response_model_dto.dart';
import 'package:zadana_user_v3/feature/category/data/models/category_subcategory_item_dto.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_request_model.dart';
import 'package:zadana_user_v3/feature/delivery_verification/data/models/delivery_otp_response_model.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_request_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/add_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/clear_favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/favorites_response_dto.dart';
import 'package:zadana_user_v3/feature/favorites/data/models/remove_favorite_response_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/app_bar/home_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/banner/home_banner_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/best_selling/home_best_selling_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/brands/home_brands_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/categories/home_categories_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/explore_more/home_explore_more_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/featured/home_featured_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/recommended/home_recommended_response_model_dto.dart';
import 'package:zadana_user_v3/feature/home/data/models/special_offers/home_special_offers_response_model_dto.dart';
import 'package:zadana_user_v3/feature/location/data/models/location_search_dto.dart';
import 'package:zadana_user_v3/feature/product_details/data/models/product_details_response_model_dto.dart';
import 'package:zadana_user_v3/feature/profile/data/models/profile_response_model_dto.dart';
import 'package:zadana_user_v3/feature/profile/data/models/update_profile_request_dto.dart';
import 'package:zadana_user_v3/feature/search/data/models/product_search_response_dto.dart';

part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @GET(EndPoints.home)
  Future<HomeAppBarModelDto> getHomeAppBar();

  @GET(EndPoints.homeBanners)
  Future<HomeBannerResponseModelDto> getHomeBanners();

  @GET(EndPoints.homeCategories)
  Future<HomeCategoriesResponseModelDto> getHomeCategories();

  @GET(EndPoints.homeBestSelling)
  Future<HomeBestSellingResponseModelDto> getHomeBestSelling(
    @Query('take') int? take,
  );

  @GET(EndPoints.homeBrands)
  Future<HomeBrandsResponseModelDto> getHomeBrands(@Query('take') int? take);

  @GET(EndPoints.homeRecommended)
  Future<HomeRecommendedResponseModelDto> getHomeRecommended(
    @Query('take') int? take,
  );

  @GET(EndPoints.homeFeaturedProducts)
  Future<HomeFeaturedResponseModelDto> getHomeFeaturedProducts();

  @GET(EndPoints.homeSpecialOffers)
  Future<HomeSpecialOffersResponseModelDto> getHomeSpecialOffers(
    @Query('take') int? take,
  );

  @GET(EndPoints.homeExploreMore)
  Future<List<HomeExploreMoreResponseModelDto>> getHomeExploreMore();

  @GET(EndPoints.brandProducts)
  Future<BrandProductsResponseModelDto> getBrandProducts(
    @Path('brandId') String brandId,
    @Query('category_id') String? categoryId,
    @Query('subcategory_id') String? subcategoryId,
    @Query('unit_id') String? unitId,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('sort') String? sort,
  );

  @GET(EndPoints.brandFilters)
  Future<BrandFiltersResponseModelDto> getBrandFilters(
    @Path('brandId') String brandId,
  );

  @GET(EndPoints.categorySubcategories)
  Future<List<CategorySubcategoryItemDto>> getCategorySubcategories(
    @Path('categoryId') String categoryId,
  );

  @GET(EndPoints.categoryFilters)
  Future<CategoryFiltersResponseModelDto> getCategoryFilters(
    @Path('categoryId') String categoryId,
  );

  @GET(EndPoints.categoryProducts)
  Future<CategoryProductsResponseModelDto> getCategoryProducts(
    @Path('categoryId') String categoryId,
    @Query('subcategory_id') String? subcategoryId,
    @Query('product_type_id') String? productTypeId,
    @Query('part_id') String? partId,
    @Query('quantity_id') String? quantityId,
    @Query('brand_id') String? brandId,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('sort') String? sort,
  );

  @GET(EndPoints.shoppingProducts)
  Future<CategoryProductsResponseModelDto> getShoppingProducts(
    @Query('categoryId') String? categoryId,
    @Query('product_type_id') String? productTypeId,
    @Query('part_id') String? partId,
    @Query('quantity_id') String? quantityId,
    @Query('brand_id') String? brandId,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('sort') String? sort,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  );

  @GET(EndPoints.productsSearch)
  Future<ProductSearchResponseDto> searchProducts(
    @Query('query') String query,
    @Query('category_id') String? categoryId,
    @Query('brand_id') String? brandId,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('sort') String? sort,
    @Query('page') int? page,
    @Query('per_page') int? perPage,
  );

  @GET(EndPoints.productDetails)
  Future<ProductDetailsResponseModelDto> getProductDetails(
    @Path('productId') String productId,
  );

  @POST(EndPoints.register)
  Future<RegisterResponseDto> registerUser(
    @Body() RegisterRequestDto requestDto,
  );

  @POST(EndPoints.login)
  Future<LoginResponseModelDto> login(@Body() LoginRequestModelDto request);

  @POST(EndPoints.logout)
  Future<void> logout(@Body() LogoutRequestDto request);

  @POST(EndPoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgetPassword(
    @Body() ForgetPasswordRequestDto request,
  );

  @POST(EndPoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  @POST(EndPoints.verifyOtp)
  Future<VerifyOtpResponseModelDto> verifyOtp(
    @Body() VerifyOtpRequestModelDto request,
  );

  @GET(EndPoints.getProfile)
  Future<ProfileResponseModelDto> getProfile();

  @PUT(EndPoints.updateProfile)
  Future<ProfileResponseModelDto> updateProfile(
    @Body() UpdateProfileRequestDto request,
  );

  @GET(EndPoints.customerAddresses)
  Future<List<CustomerAddressItemDto>> getCustomerAddresses();

  @POST(EndPoints.customerAddresses)
  Future<CustomerAddressItemDto> addCustomerAddress(
    @Body() AddCustomerAddressRequestDto request,
  );

  @PUT('${EndPoints.customerAddresses}/{addressId}')
  Future<void> updateCustomerAddress(
    @Path('addressId') String addressId,
    @Body() UpdateCustomerAddressRequestDto request,
  );

  @PATCH('${EndPoints.customerAddresses}/{addressId}/default')
  Future<void> setCustomerAddressAsDefault(@Path('addressId') String addressId);

  @DELETE('${EndPoints.customerAddresses}/{addressId}')
  Future<void> deleteCustomerAddress(@Path('addressId') String addressId);

  @GET(EndPoints.searchLocations)
  Future<List<LocationSearchDto>> searchLocations(@Query('query') String query);

  @POST(EndPoints.sendDeliveryOtp)
  Future<void> sendDeliveryOtp(@Body() DeliveryOtpRequestModel request);

  @POST(EndPoints.verifyDeliveryOtp)
  Future<DeliveryOtpResponseModel> verifyDeliveryOtp(
    @Body() DeliveryOtpRequestModel request,
  );

  @POST(EndPoints.resendDeliveryOtp)
  Future<void> resendDeliveryOtp(@Body() DeliveryOtpRequestModel request);

  @GET(EndPoints.favorites)
  Future<FavoritesResponseDto> getFavorites();

  @POST(EndPoints.favorites)
  Future<AddFavoriteResponseDto> addFavorite(
    @Body() AddFavoriteRequestDto request,
  );

  @DELETE(EndPoints.favorites)
  Future<ClearFavoritesResponseDto> clearFavorites();

  @DELETE('${EndPoints.favorites}/{productId}')
  Future<RemoveFavoriteResponseDto> removeFavorite(
    @Path('productId') String productId,
  );

  @GET(EndPoints.cartVendors)
  Future<CartVendorsResponseDto> getCartVendors();

  @POST(EndPoints.cartItems)
  Future<AddCartItemResponseDto> addCartItem(
    @Body() AddCartItemRequestDto request,
  );

  @GET(EndPoints.cart)
  Future<GetCartResponseDto> getCart(@Query('vendor_id') String? vendorId);

  @DELETE(EndPoints.cart)
  Future<ClearCartResponseDto> clearCart();

  @DELETE('${EndPoints.cartItems}/{itemId}')
  Future<RemoveCartItemResponseDto> removeCartItem(
    @Path('itemId') String itemId,
  );

  @PATCH('${EndPoints.cartItems}/{itemId}')
  Future<AddCartItemResponseDto> updateCartItemQuantity(
    @Path('itemId') String itemId,
    @Query('vendor_id') String? vendorId,
    @Body() UpdateCartItemQuantityRequestDto request,
  );
}
