import 'package:flutter/material.dart';

class TarixEkran extends StatelessWidget {
  final List<String> tarix;
  final VoidCallback onTozalash;

  const TarixEkran({
    super.key,
    required this.tarix,
    required this.onTozalash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisoblar tarixi'),
        actions: [
          if (tarix.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Tarixni tozalash',
              onPressed: () {
                onTozalash();
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: tarix.isEmpty
          ? const Center(
              child: Text(
                'Hozircha hisoblar tarixi bo\'sh',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: tarix.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(
                    tarix[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
    );
  }
}
