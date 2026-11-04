
import 'package:flutter/material.dart';

class ResponsiveCatalogScreen extends StatelessWidget {
  const ResponsiveCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = List.generate(
      10,
      (index) => {
        'title': 'Item / Properti ke-${index + 1}',
        'subtitle': 'Lokasi strategis, fasilitas lengkap, harga terjangkau.',
        'image': 'https://picsum.photos/200?random=$index',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Responsif'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Image.network(
                      item['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      item['subtitle']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 8,
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item['image']!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    item['subtitle']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
