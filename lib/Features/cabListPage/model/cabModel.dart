class CabModel {
  final int id;
  final String name;
  final String image;
  final double pricePerKm;
  final int seats;
  final bool isAc;
  final String acLabel;

  CabModel({
    required this.id,
    required this.name,
    required this.image,
    required this.pricePerKm,
    required this.seats,
    required this.isAc,
    required this.acLabel,
  });

  factory CabModel.fromJson(Map<String, dynamic> json) {
    return CabModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      pricePerKm: (json['price_per_km'] ?? 0).toDouble(),
      seats: json['seats'] ?? 0,
      isAc: json['is_ac'] ?? false,
      acLabel: json['ac_label'] ?? '',
    );
  }
}
