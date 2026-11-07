class KosModel {
  final int id;
  final String name;
  final String type; // 'Putra', 'Putri', 'Campur'
  final int price;
  final String address;
  final List<String> facilities;
  final String imageUrl;
  final double rating;
  final bool isAvailable;
  final String description;
  final String phoneContact;

  KosModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.address,
    required this.facilities,
    required this.imageUrl,
    required this.rating,
    required this.isAvailable,
    required this.description,
    required this.phoneContact,
  });

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'Campur',
      price: json['price'] as int? ?? 0,
      address: json['address'] as String? ?? '',
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: json['imageUrl'] as String? ?? '',
      rating:
          (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.5,
      isAvailable: json['isAvailable'] as bool? ?? true,
      description: json['description'] as String? ?? '',
      phoneContact: json['phoneContact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'address': address,
      'facilities': facilities,
      'imageUrl': imageUrl,
      'rating': rating,
      'isAvailable': isAvailable,
      'description': description,
      'phoneContact': phoneContact,
    };
  }

  String get formattedPrice {
    final chars = price.toString().split('').reversed.toList();
    final parts = <String>[];
    for (int i = 0; i < chars.length; i += 3) {
      final end = (i + 3 < chars.length) ? i + 3 : chars.length;
      parts.add(chars.sublist(i, end).reversed.join());
    }
    return 'Rp ${parts.reversed.join('.')}/bln';
  }
}
