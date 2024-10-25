class Routes {
  final int id;
  final String title;
  final String desc;
  final Deliveries deliveries;

  Routes({
    required this.id,
    required this.title,
    required this.desc,
    required this.deliveries,
  });

  factory Routes.fromJson(Map<String, dynamic> json) {
    return Routes(
      id: json['id'],
      title: json['title'],
      desc: json['desc'],
      deliveries: Deliveries.fromJson(json['deliveries']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'deliveries': deliveries.toJson(),
    };
  }
}

class Deliveries {
  final int total;
  final int delivered;

  Deliveries({
    required this.total,
    required this.delivered,
  });

  factory Deliveries.fromJson(Map<String, dynamic> json) {
    return Deliveries(
      total: json['total'],
      delivered: json['delivered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'delivered': delivered,
    };
  }
}
