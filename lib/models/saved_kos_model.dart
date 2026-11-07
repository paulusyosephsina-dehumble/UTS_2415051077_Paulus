class SavedKosModel {
  final int? id;
  final String studentId; // Paulus NIM: 2415051077
  final int kosId;
  final String kosName;
  final String address;
  final int price;
  final String type;
  final String note;
  final double rating;
  final String createdAt;

  SavedKosModel({
    this.id,
    required this.studentId,
    required this.kosId,
    required this.kosName,
    required this.address,
    required this.price,
    required this.type,
    required this.note,
    required this.rating,
    required this.createdAt,
  });

  factory SavedKosModel.fromMap(Map<String, dynamic> map) {
    return SavedKosModel(
      id: map['id'] as int?,
      studentId: map['student_id'] as String? ?? '2415051077',
      kosId: map['kos_id'] as int? ?? 0,
      kosName: map['kos_name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      price: map['price'] as int? ?? 0,
      type: map['type'] as String? ?? 'Campur',
      note: map['note'] as String? ?? '',
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 5.0,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'student_id': studentId,
      'kos_id': kosId,
      'kos_name': kosName,
      'address': address,
      'price': price,
      'type': type,
      'note': note,
      'rating': rating,
      'created_at': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  SavedKosModel copyWith({
    int? id,
    String? studentId,
    int? kosId,
    String? kosName,
    String? address,
    int? price,
    String? type,
    String? note,
    double? rating,
    String? createdAt,
  }) {
    return SavedKosModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      kosId: kosId ?? this.kosId,
      kosName: kosName ?? this.kosName,
      address: address ?? this.address,
      price: price ?? this.price,
      type: type ?? this.type,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
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
