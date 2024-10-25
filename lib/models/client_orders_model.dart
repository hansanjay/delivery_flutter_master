import 'dart:convert';

class RouteOrders {
  final DateTime date;
  final int routeId;
  final String routeTitle;
  final List<Order> orders;

  RouteOrders({
    required this.date,
    required this.routeId,
    required this.routeTitle,
    required this.orders,
  });

  factory RouteOrders.fromJson(Map<String, dynamic> json) {
    return RouteOrders(
      date: DateTime.parse(json['date']),
      routeId: json['route_id'],
      routeTitle: json['route_title'],
      orders: (json['orders'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'route_id': routeId,
      'route_title': routeTitle,
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}

class Order {
  final int id;
  final int customerId;
  final int distributorId;
  final String customer_phone;
  final Address address;
  final String status;
  final List<OrderLine> lines;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.customerId,
    required this.distributorId,
    required this.customer_phone,
    required this.address,
    required this.status,
    required this.lines,
    required this.orderDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      distributorId: json['distributor_id'],
      customer_phone: json['customer_phone'],
      address: Address.fromJson(json['address']),
      status: json['status'],
      lines: (json['lines'] as List)
          .map((lineJson) => OrderLine.fromJson(lineJson))
          .toList(),
      orderDate: DateTime.parse(json['orderDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'distributor_id': distributorId,
      'customer_phone': customer_phone,
      'address': address.toJson(),
      'status': status,
      'lines': lines.map((line) => line.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
    };
  }
}

class Address {
  final int id;
  final int customerId;
  final String line1;
  final String? line2;
  final String? line3;
  final String pinCode;
  final String stateName;
  final String country;
  final String city;
  final String shortName;
  final dynamic geoTag;
  final bool verified;
  final bool isDefault;

  Address({
    required this.id,
    required this.customerId,
    required this.line1,
    this.line2,
    this.line3,
    required this.pinCode,
    required this.stateName,
    required this.country,
    required this.city,
    required this.shortName,
    this.geoTag,
    required this.verified,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      customerId: json['customer_id'],
      line1: json['line1'],
      line2: json['line2'],
      line3: json['line3'] ?? " ",
      pinCode: json['pin_code'],
      stateName: json['state_name'],
      country: json['country'],
      city: json['city'],
      shortName: json['short_name'],
      geoTag: json['geo_tag'] ??  " ",
      verified: json['verified'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'line1': line1,
      'line2': line2,
      'line3': line3,
      'pin_code': pinCode,
      'state_name': stateName,
      'country': country,
      'city': city,
      'short_name': shortName,
      'geo_tag': geoTag,
      'verified': verified,
      'is_default': isDefault,
    };
  }
}

class OrderLine {
  final int id;
  final int productId;
  final int quantity;
  final int orderId;
  final int subscriptionId;
  final double unitPrice;
  final Product product;

  OrderLine({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.orderId,
    required this.subscriptionId,
    required this.unitPrice,
    required this.product,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      orderId: json['order_id'],
      subscriptionId: json['subscription_id'],
      unitPrice: json['unit_price'].toDouble(),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'order_id': orderId,
      'subscription_id': subscriptionId,
      'unit_price': unitPrice,
      'product': product.toJson(),
    };
  }
}

class Product {
  final int id;
  final String title;
  final String unitDisplay;
  final String imageUrl;
  final String category;
  final String brand;
  final int brandId;

  Product({
    required this.id,
    required this.title,
    required this.unitDisplay,
    required this.imageUrl,
    required this.category,
    required this.brand,
    required this.brandId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      unitDisplay: json['unitDisplay'],
      imageUrl: json['image_url'],
      category: json['category'],
      brand: json['brand'],
      brandId: json['brandId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'unitDisplay': unitDisplay,
      'image_url': imageUrl,
      'category': category,
      'brand': brand,
      'brandId': brandId,
    };
  }
}
