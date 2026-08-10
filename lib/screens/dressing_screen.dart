import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/clothing.dart';
import '../services/database_service.dart';

class DressingScreen extends StatefulWidget {
  const DressingScreen({super.key});

  @override
  State<DressingScreen> createState() => _DressingScreenState();
}

class _DressingScreenState extends State<DressingScreen> {
  List<Clothing> _clothes = [];
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  Future<void> _loadClothes() async {
    final clothes = await db.getAllClothing();
    setState(() => _clothes = clothes);
  }

  Future<void> _addClothing() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Pour l'instant, ajout fictif avec une image simulée
      final newClothing = Clothing(
        id: DateTime.now().toString(),
        name: 'Nouveau vêtement',
        imagePath: image.path,
        category: ClothingCategory.top,
        color: 'Bleu',
        seasons: [Season.all],
        isAvailable: true,
        isFavorite: false,
      );
      await db.insertClothing(newClothing);
      await _loadClothes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _clothes.isEmpty
          ? const Center(
              child: Text(
                '👕 Ton dressing est vide\nAjoute des vêtements !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _clothes.length,
              itemBuilder: (context, index) {
                final item = _clothes[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Icon(Icons.checkroom, size: 60, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        item.color,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClothing,
        child: const Icon(Icons.add),
      ),
    );
  }
}
