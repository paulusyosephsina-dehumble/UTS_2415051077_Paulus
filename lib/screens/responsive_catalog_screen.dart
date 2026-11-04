import 'package:flutter/material.dart';

class ResponsiveCatalogScreen extends StatelessWidget {
  const ResponsiveCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data contoh item (misalnya katalog kos / item lainnya)
    final List> items = List.generate(
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
      // LayoutBuilder mendeteksi lebar layar secara dinamis (Responsive Layout)
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Kondisi Wide / Expanded (misal lebar layar > 600 piksel, contoh: Tablet/Desktop)
          if (constraints.maxWidth > 600) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom untuk layar lebar
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
                    leading: Image.network(item['image']!, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['subtitle']!, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      // Aksi klik ke detail
                    },
                  ),
                );
              },
            );
          } 
          
          // Kondisi Compact (misal layar HP standar <= 600 piksel)
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(item['image']!, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['subtitle']!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    // Aksi klik ke detail
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}