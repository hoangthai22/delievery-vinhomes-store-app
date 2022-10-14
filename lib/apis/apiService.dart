import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/productModel.dart';

class ApiServices {
  static const baseURL = 'https://deliveryvhgp-webapi.azurewebsites.net/api/v1';
  static const PRODUCT = "products";
  static const CATEGORY = "category-management";
//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/products/s4/products?pageIndex=1&pageSize=20

  static Future<dynamic> getListProduct(String storeId, page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${PRODUCT}/${storeId}/${PRODUCT}?pageIndex=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<ProductModel> products =
            body.map((dynamic item) => ProductModel.fromJson(item)).toList();
        return products;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }
  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/products/399f3942-32ef-4e5a-a4be-e63745897d1a
  // static Future<dynamic> getListProduct(String storeId, page, size) async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse(
  //           '${baseURL}/${PRODUCT}/${storeId}/${PRODUCT}?pageIndex=${page}&pageSize=${size}'),
  //     );
  //     if (response.statusCode == 200) {
  //       List<dynamic> body = convert.jsonDecode(response.body);
  //       List<ProductModel> products =
  //           body.map((dynamic item) => ProductModel.fromJson(item)).toList();
  //       return products;
  //     } else if (response.statusCode == 404) {
  //       return [];
  //     }
  //   } catch (e) {
  //     print('Error with status code: ${e}');
  //   }
  // }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/category-management/categories?pageIndex=1&pageSize=20
  static Future<dynamic> getListCategory(page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${CATEGORY}/categories?pageIndex=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<CategoryModel> categories =
            body.map((dynamic item) => CategoryModel.fromJson(item)).toList();
        return categories;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/products
  static Future<dynamic> postCreateProduct(
    ProductModel product,
  ) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.post(
          Uri.parse(
            '${baseURL}/${PRODUCT}',
          ),
          headers: headers,
          body: convert.jsonEncode({
            "name": product.name,
            "image": product.image,
            "unit": product.unit,
            "pricePerPack": product.pricePerPack,
            "packNetWeight": product.packNetWeight,
            "packDescription": product.packDescription,
            "maximumQuantity": product.maximumQuantity,
            "minimumQuantity": product.minimumQuantity,
            "minimumDeIn": product.minimumDeIn,
            "storeId": product.storeId,
            "categoryId": product.categoryId,
            "rate": product.rate,
            "description": product.description
          }));

      if (response.statusCode == 200) {
        String body = response.body;

        return body;
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  static Future<dynamic> putUpdateProduct(
      ProductModel product, String id) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.put(
          Uri.parse(
            '${baseURL}/${PRODUCT}/${id}',
          ),
          headers: headers,
          body: convert.jsonEncode({
            "id": id,
            "name": product.name,
            "image": product.image,
            "unit": product.unit,
            "pricePerPack": product.pricePerPack,
            "packNetWeight": product.packNetWeight,
            "packDescription": product.packDescription,
            "maximumQuantity": product.maximumQuantity,
            "minimumQuantity": product.minimumQuantity,
            "minimumDeIn": product.minimumDeIn,
            "storeId": product.storeId,
            "categoryId": product.categoryId,
            "rate": product.rate,
            "description": product.description
          }));

      if (response.statusCode == 200) {
        String body = response.body;

        return body;
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  // static Future<dynamic> putAcceptRequestMeetup(
  //     String meetupId, String memberId) async {
  //   //12c9cd48-8cb7-4145-8fd9-323e20b329dd
  //   try {
  //     Map<String, String> headers = {"Content-type": "application/json"};
  //     var response = await http.put(
  //       Uri.parse(
  //         '${baseURL}/session-management/${meetupId}/members/${memberId}/accept',
  //       ),
  //       headers: headers,
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       String body = "Successfull";

  //       return body;
  //     } else if (response.statusCode == 404 || response.statusCode == 409) {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error with status code: ${e}');
  //   }
  // }

  // static Future<dynamic> deleteRejectRequestMeetup(
  //     String meetupId, String memberId) async {
  //   //12c9cd48-8cb7-4145-8fd9-323e20b329dd
  //   try {
  //     Map<String, String> headers = {"Content-type": "application/json"};
  //     var response = await http.delete(
  //       Uri.parse(
  //         '${baseURL}/session-management/${meetupId}/members/${memberId}/reject',
  //       ),
  //       headers: headers,
  //     );
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       String body = "Successfull";

  //       return body;
  //     } else if (response.statusCode == 404 || response.statusCode == 409) {
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error with status code: ${e}');
  //   }
  // }
}
