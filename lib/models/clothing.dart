enum ClothingCategory {
  top,
  bottom,
  shoes,
  accessory,
  outerwear,
  dress,
}

enum Season {
  spring,
  summer,
  autumn,
  winter,
  all,
}

class Clothing {
  final String id;
  final String name;
  final String imagePath;
  final ClothingCategory category;
  final String color;
  final List<Season> seasons;
  final bool isAvailable;
  final bool isFavorite;

  Clothing({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    required this.color,
    this.seasons = const [],
    this.isAvailable = true,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category.name,
      'color': color,
      'seasons': seasons.map((e) => e.name).toList(),
      'isAvailable': isAvailable ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Clothing.fromMap(Map<String, dynamic> map) {
    return Clothing(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      category: ClothingCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => ClothingCategory.top,
      ),
      color: map['color'],
      seasons: (map['seasons'] as List).map(
        (e) => Season.values.firstWhere(
          (s) => s.name == e,
          orElse: () => Season.all,
        )
      ).toList(),
      isAvailable: map['isAvailable'] == 1,
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
