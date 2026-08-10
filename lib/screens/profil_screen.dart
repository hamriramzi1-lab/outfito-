import 'package:flutter/material.dart';
import '../services/database_service.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final db = DatabaseService();
  int _vêtementsCount = 0;
  int _tenuesCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final clothes = await db.getAllClothing();
    final outfits = await db.getAllOutfits();
    setState(() {
      _vêtementsCount = clothes.length;
      _tenuesCount = outfits.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Avatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Utilisateur Outfito',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Statistiques
            Row(
              children: [
                _statCard('👕', '$_vêtementsCount', 'Vêtements'),
                _statCard('👔', '$_tenuesCount', 'Tenues'),
                _statCard('❤️', '0', 'Favoris'),
              ],
            ),

            const SizedBox(height: 30),

            // Préférences
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.palette),
                      title: Text('Couleurs préférées'),
                      trailing: Text('Bleu, Noir, Blanc'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Style préféré'),
                      trailing: Text('Casual'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('Budget'),
                      trailing: Text('Moyen'),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Bouton de déconnexion
            ElevatedButton(
              onPressed: () {
                // Pour l'instant, simple message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion (fonctionnalité à venir)')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String icon, String count, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 30)),
              Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
