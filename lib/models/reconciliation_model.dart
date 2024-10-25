class Product {
  final int productId;
  final String prdTitle;
  final String imageUrl;
  final String category;
  final String subCategory;
  final String brand;
  final int brandId;
  final int pendingQty;

  Product({
    required this.productId,
    required this.prdTitle,
    required this.imageUrl,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.brandId,
    required this.pendingQty,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      prdTitle: json['prd_title'],
      imageUrl: json['image_url'],
      category: json['category'],
      subCategory: json['sub_category'] ?? '',
      brand: json['brand'],
      brandId: json['brand_id'],
      pendingQty: json['pending_qty'],
    );
  }
}

class DailyItems {
  final String date;
  final List<Product> items;

  DailyItems({
    required this.date,
    required this.items,
  });

  factory DailyItems.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Product> productList = itemsList.map((i) => Product.fromJson(i)).toList();

    return DailyItems(
      date: json['date'],
      items: productList,
    );
  }
}
