import 'dart:convert';
import 'dart:developer';

import 'package:yachid/app/core/rest/rest_client.dart';
import 'package:yachid/app/core/rest/rest_client_response.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/product_model_list.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_dto.dart';
import 'package:yachid/app/features/home/module/products/model/create_product_component_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_stock_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_component_dto.dart';
import 'package:yachid/app/features/home/module/products/model/update_product_nota_fiscal_dto.dart';

class ProductsRepository {
  final RestClient _rest;

  ProductsRepository({required RestClient rest}) : _rest = rest;

  Future<ProductsListResponse> getProducts({
    required String token,
    required String groupId,
    String? search,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _rest.get(
        '/products',
        headers: {'Authorization': 'Bearer $token'},
        queryParameters: {
          ...queryParams,
          'groupId': groupId,
        },
      );

      final products = <ProductModelList>[];
      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['products'] != null) {
        for (final element in data['products'] as List<dynamic>) {
          products.add(
            ProductModelList.fromJson(element as Map<String, dynamic>),
          );
        }
      }

      final total = data?['total'] as int? ?? products.length;
      return ProductsListResponse(products: products, total: total);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> getProductDetails(
    String productId,
    String token,
  ) async {
    try {
      final response = await _rest.get(
        '/products/$productId',
        headers: {'Authorization': 'Bearer $token'},
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createProduct(
    CreateProductDto product,
    String token,
    String groupId,
  ) async {
    try {
      final response = await _rest.post(
        '/products/$groupId',
        data: jsonEncode(product.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateProduct(
    String productId,
    UpdateProductDto updateDto,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/products/$productId',
        data: jsonEncode(updateDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createProductStock(
    String productId,
    CreateProductStockDto stock,
    String token,
  ) async {
    try {
      final response = await _rest.post(
        '/products/$productId/stocks',
        data: jsonEncode(stock.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateProductStock(
    String productId,
    String stockId,
    UpdateProductStockDto updateDto,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/products/$productId/stocks/$stockId',
        data: jsonEncode(updateDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> createProductComponent(
    String productId,
    CreateProductComponentDto component,
    String token,
  ) async {
    try {
      final response = await _rest.post(
        '/products/$productId/components',
        data: jsonEncode(component.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateProductNotaFiscal(
    String productId,
    UpdateProductNotaFiscalDto updateDto,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/products/$productId/nota-fiscal',
        data: jsonEncode(updateDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<RestClientResponse<dynamic>> updateProductComponent(
    String productId,
    String componentId,
    UpdateProductComponentDto updateDto,
    String token,
  ) async {
    try {
      final response = await _rest.patch(
        '/products/$productId/components/$componentId',
        data: jsonEncode(updateDto.toJson()),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

class ProductsListResponse {
  final List<ProductModelList> products;
  final int total;

  ProductsListResponse({required this.products, required this.total});
}
