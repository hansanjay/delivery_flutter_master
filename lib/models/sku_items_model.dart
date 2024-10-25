class Quantity {
  final int? ordered;
  final int? collected;
  final int? delivered;

  Quantity({
    required this.ordered,
    required this.collected,
    required this.delivered,
  });

  factory Quantity.fromJson(Map<String, dynamic> json) {
    return Quantity(
      ordered: json['ordered'] ?? 0,
      collected: json['collected'] ?? 0,
      delivered: json['delivered'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ordered': ordered,
      'collected': collected,
      'delivered': delivered,
    };
  }
}

class Product {
  final int? id;
  final String? title;
  final String? unitDisplay;
  final String? imageUrl;
  final String? category;
  final String? brand;
  final int? brandId;

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
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      unitDisplay: json['unitDisplay'] ?? '',
      imageUrl: json['image_url'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      brandId: json['brandId'] ?? 0,
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

class ProductDetail {
  final Product? product;
  final Quantity? quantity;

  ProductDetail({
    required this.product,
    required this.quantity,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      product: Product.fromJson(json['product']),
      quantity: Quantity.fromJson(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'quantity': quantity?.toJson(),
    };
  }
}

class SKUSummary {
  final String? date;
  final int? routeId;
  final String? routeTitle;
  final String? status;
  final List<ProductDetail>? products;

  SKUSummary({
    required this.date,
    required this.routeId,
    required this.routeTitle,
    required this.status,
    required this.products,
  });

  factory SKUSummary.fromJson(Map<String, dynamic> json) {
    var productsList = json['products'] as List;
    List<ProductDetail> products = productsList.map((i) => ProductDetail.fromJson(i)).toList();

    return SKUSummary(
      date: json['date'] ?? '',
      routeId: json['route_id'] ?? 0,
      routeTitle: json['route_title'] ?? '',
      status: json['status'] ?? '',
      products: products,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'route_id': routeId,
      'route_title': routeTitle,
      'status' : status,
      'products': products?.map((product) => product.toJson()).toList(),
    };
  }
}
