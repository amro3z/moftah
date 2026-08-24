class UserVehicleModel {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String? imageUrl;

  const UserVehicleModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    this.imageUrl,
  });

  String get displayName => '$brand $model $year';

  UserVehicleModel copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? imageUrl,
  }) {
    return UserVehicleModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserVehicleModel.fromJson(Map<String, dynamic> json) {
    return UserVehicleModel(
      id: json['id']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: int.tryParse(json['year']?.toString() ?? '') ?? 0,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'model': model,
        'year': year,
        'imageUrl': imageUrl,
      };
}
