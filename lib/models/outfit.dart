class Outfit {
  final String id;
  final String name;
  final List<String> clothingIds;
  final String? occasion;
  final bool isFavorite;
  final DateTime dateCreated;

  Outfit({
    required this.id,
    required this.name,
    required this.clothingIds,
    this.occasion,
    this.isFavorite = false,
    required this.dateCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'clothingIds': clothingIds,
      'occasion': occasion,
      'isFavorite': isFavorite ? 1 : 0,
      'dateCreated': dateCreated.toIso8601String(),
    };
  }

  factory Outfit.fromMap(Map<String, dynamic> map) {
    return Outfit(
      id: map['id'],
      name: map['name'],
      clothingIds: List<String>.from(map['clothingIds']),
      occasion: map['occasion'],
      isFavorite: map['isFavorite'] == 1,
      dateCreated: DateTime.parse(map['dateCreated']),
    );
  }
}
