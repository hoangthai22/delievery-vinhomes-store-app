import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:store_app/models/buildingModel.dart';
import 'package:store_app/models/categoryModel.dart';
import 'package:store_app/models/menuDetailModel.dart';
import 'package:store_app/models/menuModel.dart';
import 'package:store_app/models/orderDetailModel.dart';
import 'package:store_app/models/orderModel.dart';
import 'package:store_app/models/productMenuModel.dart';
import 'package:store_app/models/productModel.dart';
import 'package:store_app/models/storeModel.dart';
import 'package:store_app/widgets/modals/menu_modal.dart';

class ApiServices {
  static const baseURL = 'https://deliveryvhgp-webapi.azurewebsites.net/api/v1';
  static const PRODUCT = "products";
  static const MENU = "menus";
  static const STORE = "stores";
  static const ORDER = "orders";
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

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/orders/stores/byStoreId?storeId=s4&pageIndex=1&pageSize=29
  static Future<dynamic> getListOrder(String storeId, page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${ORDER}/${STORE}/byStoreId?storeId=${storeId}&pageIndex=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<OrderModel> orders =
            body.map((dynamic item) => OrderModel.fromJson(item)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/orders/stores/byStoreId/status/ByStatusId?statusId=3&storeId=s4&pageIndex=1&pageSize=20
  static Future<dynamic> getListOrderByStatus(
      String storeId, String statusId, page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${ORDER}/${STORE}/byStoreId/status/ByStatusId?statusId=${statusId}&storeId=${storeId}&pageIndex=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<OrderModel> orders =
            body.map((dynamic item) => OrderModel.fromJson(item)).toList();
        return orders;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/orders/16238d15-1a4a-40be-a37e-080077bd2e92
  static Future<dynamic> getOrderDetail(
    String orderId,
  ) async {
    var orderDetailModel = Completer<OrderDetailModel>();
    var body;
    print(orderId);
    try {
      var response =
          await http.get(Uri.parse('${baseURL}/${ORDER}/${orderId}'));
      body = convert.jsonDecode(response.body);
      orderDetailModel.complete(OrderDetailModel.fromJson(body['data']));
    } catch (_) {
      orderDetailModel.complete(OrderDetailModel.fromJson(body));
    }
    return orderDetailModel.future;
  }

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
        print("body: " + body);
        return body;
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/store-management/stores/storeId?storeId=store2%40gmail.com
  static Future<dynamic> getStoreById(
    String id,
  ) async {
    var store = Completer<StoreModel>();
    var body;
    try {
      var response = await http.get(Uri.parse(
          '${baseURL}/${"store-management"}/${STORE}/storeId?storeId=${id}'));
      body = convert.jsonDecode(response.body);
      store.complete(StoreModel.fromJson(body['data']));
    } catch (_) {
      store.complete(StoreModel.fromJson(body));
    }
    return store.future;
  }

//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/store-management/stores/1?imgUpdate=true
  static Future<dynamic> putStore(StoreModel store, String id, password) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.put(
          Uri.parse(
              '${baseURL}/${"store-management"}/${STORE}/${id}?imgUpdate=true'),
          headers: headers,
          body: convert.jsonEncode({
            "id": store.id,
            "name": store.name,
            "buildingId": store.buildingId,
            "brandId": store.brandId,
            "rate": store.rate,
            "closeTime": store.closeTime,
            "openTime": store.openTime,
            "image": store.image,
            "storeCategoryId": store.storeCategoryId,
            "slogan": store.slogan,
            "phone": store.phone,
            "status": store.status,
            "password": password
          }));

      if (response.statusCode == 200) {
        var body;

        Completer<StoreModel> store = Completer<StoreModel>();
        body = convert.jsonDecode(response.body);
        store.complete(StoreModel.fromJson(body));

        return store.future;
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/menus/1/products/join
  static Future<dynamic> postJoinMenu(List<CheckedItem> product, menuId) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    print({"${baseURL}/${MENU}/${menuId}/${PRODUCT}/join"});
    if (product.isNotEmpty) {
      for (var element in product) {
        print(element.price);
      }
    }
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.post(
          Uri.parse(
            '${baseURL}/${MENU}/${menuId}/${PRODUCT}/join',
          ),
          headers: headers,
          body: convert.jsonEncode({"menuId": menuId, "products": product}));

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

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/menus/byMode?modeId=1
  static Future<dynamic> getListMenuByMode(modeId) async {
    try {
      var response = await http.get(
        Uri.parse('${baseURL}/${MENU}/byMode?modeId=${modeId}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<MenuModel> menus =
            body.map((dynamic item) => MenuModel.fromJson(item)).toList();
        return menus;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/menus/1/filter?storeId=s4&page=1&pageSize=20
  static Future<dynamic> getListProductByMenu(
      menuId, storeId, page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${MENU}/${menuId}/filter?storeId=${storeId}&page=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<MenuDetailModel> menus =
            body.map((dynamic item) => MenuDetailModel.fromJson(item)).toList();
        return menus;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/menus/1/not-products/filter?storeId=s4&page=1&pageSize=20
  static Future<dynamic> getListProductOutOfMenu(
      menuId, storeId, page, size) async {
    try {
      var response = await http.get(
        Uri.parse(
            '${baseURL}/${MENU}/${menuId}/not-products/filter?storeId=${storeId}&page=${page}&pageSize=${size}'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<ProductMenuModel> menus = body
            .map((dynamic item) => ProductMenuModel.fromJson(item))
            .toList();
        return menus;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

  //https://deliveryvhgp-webapi.azurewebsites.net/api/v1/buildings?pageIndex=1&pageSize=100
  static Future<dynamic> getListBuilding() async {
    try {
      var response = await http.get(
        Uri.parse('${baseURL}/buildings?pageIndex=1&pageSize=100'),
      );
      if (response.statusCode == 200) {
        List<dynamic> body = convert.jsonDecode(response.body);
        List<BuildingModel> buildings =
            body.map((dynamic item) => BuildingModel.fromJson(item)).toList();
        return buildings;
      } else if (response.statusCode == 404) {
        return [];
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/store-management/stores/status/1
  static Future<dynamic> putUpdateStatusStore(
      String storeId, bool status) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.put(
          Uri.parse('${baseURL}/store-management/${STORE}/status/${storeId}'),
          headers: headers,
          body: convert.jsonEncode({
            "id": storeId,
            "status": status,
          }));

      print(response.statusCode);
      if (response.statusCode == 200) {
        Map valueMap = convert.jsonDecode(response.body);
        return valueMap;
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }

//https://deliveryvhgp-webapi.azurewebsites.net/api/v1/products/d2f80d6c-7948-42a9-91a9-6460a85ec909
  static Future<dynamic> deleteProduct(String id) async {
    //12c9cd48-8cb7-4145-8fd9-323e20b329dd
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var response = await http.delete(
        Uri.parse(
          '${baseURL}/${PRODUCT}/${id}',
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        Map valueMap = convert.jsonDecode(response.body);
        return valueMap["message"];
      } else if (response.statusCode == 404 || response.statusCode == 409) {
        return null;
      }
    } catch (e) {
      print('Error with status code: ${e}');
    }
  }
}
