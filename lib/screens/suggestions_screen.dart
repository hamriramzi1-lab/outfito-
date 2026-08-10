import 'package:flutter/material.dart';
import '../models/clothing.dart';
import '../services/database_service.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  List<Clothing> _clothes = [];
  final db = DatabaseService();
  String _selectedOccasion = 'quotidien';
  final List<String> occasions = [
    'quotidien',
    'travail',
    'rendez-vous',
    'soirée',
    'sport'
  ];

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  Future<void> _loadClothes() async {
    final clothes = await db.getAllClothing();
    setState(() => _clothes = clothes);
  }

  List<Clothing> _getSuggestions() {
    if (_clothes.isEmpty) return [];
    // Filtre : vêtements disponibles
    final available = _clothes.where((c) => c.isAvailable).toList();
    if (available.length < 3) return available;
    
    // Retourne 3 vêtements suggérés (pour l'instant, on prend les premiers)
    return available.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestions();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Sélection d'occasion
            DropdownButtonFormField<String>(
              value: _selectedOccasion,
              items: occasions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedOccasion = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Occasion',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Suggestions
            if (suggestions.isEmpty)
              const Text('Ajoute des vêtements pour avoir des suggestions'),
            if (suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final item = suggestions[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.checkroom, size: 40),
                        title: Text(item.name),
                        subtitle: Text('${item.color} - ${item.category.name}'),
                        trailing: const Icon(Icons.auto_awesome, color: Colors.blue),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
