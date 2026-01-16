class Candi {
  final int? id;
  final String name;
  final String location;
  final String description;
  final String built;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;
  final String visitingHours;
  final int sumFavorite;

  Candi({
    this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.built,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
    required this.visitingHours,
    required this.sumFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'built': built,
      'type': type,
      'imageAsset': imageAsset,
      'imageUrls': imageUrls.join(','),
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Candi.fromMap(Map<String, dynamic> map) {
    return Candi(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      description: map['description'],
      built: map['built'],
      type: map['type'],
      imageAsset: map['imageAsset'],
      imageUrls: map['imageUrls'].split(','),
      isFavorite: map['isFavorite'] == 1,
      visitingHours: '-',
      sumFavorite: 0,
    );
  }
}
