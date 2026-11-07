import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../models/saved_kos_model.dart';
import '../providers/saved_kos_provider.dart';
import '../widgets/status_badge_widget.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';
import 'edit_saved_kos_screen.dart';

class KosDetailScreen extends StatelessWidget {
  final KosModel kos;

  const KosDetailScreen({
    super.key,
    required this.kos,
  });

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'putra':
        return Colors.blue;
      case 'putri':
        return Colors.pink;
      default:
        return Colors.deepPurple;
    }
  }

  void _showContactOwnerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: Colors.teal),
            const SizedBox(width: 8),
            Text('Hubungi Pemilik', style: TextStyle(color: Colors.teal.shade900)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kos.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Nomor Telepon / WhatsApp: ${kos.phoneContact}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pastikan untuk menanyakan ketersediaan kamar dan jadwal survey lokasi terlebih dahulu.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menghubungkan ke ${kos.phoneContact}...'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
            icon: const Icon(Icons.chat),
            label: const Text('Kirim Pesan'),
          ),
        ],
      ),
    );
  }

  void _showSaveNoteBottomSheet(BuildContext context) {
    final noteController = TextEditingController();
    double currentRating = 5.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Simpan Kos ke Database',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan catatan dan rating pribadi Anda untuk ${kos.name}:',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text('Beri Rating: ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  RatingStarsWidget(
                    rating: currentRating,
                    size: 24,
                    isInteractive: true,
                    onRatingChanged: (newRating) {
                      setSheetState(() {
                        currentRating = newRating;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text('$currentRating / 5.0',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Pribadi',
                  hintText: 'Contoh: Sudah survey kamar, ibu kos baik, listrik token.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan ke Database SQLite',
                  icon: Icons.save,
                  onPressed: () async {
                    final savedProvider =
                        Provider.of<SavedKosProvider>(context, listen: false);
                    final newItem = SavedKosModel(
                      studentId: '2415051077',
                      kosId: kos.id,
                      kosName: kos.name,
                      address: kos.address,
                      price: kos.price,
                      type: kos.type,
                      note: noteController.text.trim().isEmpty
                          ? 'Disimpan dari detail kos.'
                          : noteController.text.trim(),
                      rating: currentRating,
                      createdAt: DateTime.now().toIso8601String(),
                    );
                    final success = await savedProvider.addSavedKos(newItem);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? 'Berhasil menyimpan ${kos.name} ke database!'
                              : 'Gagal menyimpan kos.'),
                          backgroundColor:
                              success ? Colors.teal : Colors.redAccent,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image Header with AppBar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    kos.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.home_work,
                            size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black45,
                          Colors.transparent,
                          Colors.black87,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StatusBadgeWidget(
                              text: kos.type,
                              color: _getTypeColor(kos.type),
                            ),
                            const SizedBox(width: 8),
                            StatusBadgeWidget(
                              text: kos.isAvailable ? 'Kamar Tersedia' : 'Penuh',
                              color: kos.isAvailable ? Colors.green : Colors.red,
                              icon: kos.isAvailable
                                  ? Icons.check_circle
                                  : Icons.cancel,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          kos.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<SavedKosProvider>(
                builder: (context, savedProvider, _) {
                  final isSaved = savedProvider.isSaved(kos.id);
                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.redAccent : Colors.white,
                    ),
                    tooltip: isSaved ? 'Hapus Favorit' : 'Simpan Favorit',
                    onPressed: () async {
                      if (isSaved) {
                        final success = await savedProvider.toggleSaveKos(kos);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kos dihapus dari daftar favorit.'),
                            ),
                          );
                        }
                      } else {
                        _showSaveNoteBottomSheet(context);
                      }
                    },
                  );
                },
              ),
            ],
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Harga Sewa',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            kos.formattedPrice,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          children: [
                            RatingStarsWidget(rating: kos.rating, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '${kos.rating}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Alamat Lokasi
                  const Text(
                    'Lokasi Kos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kos.address,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Fasilitas Kos (Chips)
                  const Text(
                    'Fasilitas Termasuk',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: kos.facilities.map((f) {
                      return Chip(
                        avatar: const Icon(Icons.check_circle_outline,
                            size: 16, color: Colors.teal),
                        label: Text(f),
                        backgroundColor: Colors.teal.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.teal.shade200),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Deskripsi Kos
                  const Text(
                    'Deskripsi & Aturan Kos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kos.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Saved Kos Indicator Card if Already Saved
                  Consumer<SavedKosProvider>(
                    builder: (context, savedProvider, _) {
                      final isSaved = savedProvider.isSaved(kos.id);
                      if (!isSaved) return const SizedBox.shrink();

                      final savedItem = savedProvider.savedKosList
                          .firstWhere((element) => element.kosId == kos.id);

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.bookmark_added,
                                        color: Colors.blue),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Tersimpan di Database',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditSavedKosScreen(item: savedItem),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit Catatan'),
                                ),
                              ],
                            ),
                            Text(
                              'Catatan Anda: "${savedItem.note}"',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Bottom Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          label: 'Hubungi Pemilik',
                          icon: Icons.chat,
                          color: Colors.teal,
                          onPressed: () => _showContactOwnerDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Consumer<SavedKosProvider>(
                          builder: (context, savedProvider, _) {
                            final isSaved = savedProvider.isSaved(kos.id);
                            return CustomButtonWidget(
                              label: isSaved ? 'Tersimpan' : 'Simpan Kos',
                              icon: isSaved
                                  ? Icons.bookmark_added
                                  : Icons.bookmark_add_outlined,
                              color: isSaved ? Colors.grey.shade700 : Colors.indigo,
                              onPressed: () {
                                if (isSaved) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Kos ini sudah ada dalam daftar favorit database Anda.'),
                                    ),
                                  );
                                } else {
                                  _showSaveNoteBottomSheet(context);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
