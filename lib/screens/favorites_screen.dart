import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/saved_kos_provider.dart';
import '../widgets/saved_kos_card_widget.dart';
import 'add_saved_kos_screen.dart';
import 'edit_saved_kos_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const FavoritesScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _filterType = 'Semua';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavedKosProvider>(context, listen: false).loadSavedKos();
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, SavedKosProvider provider, SavedKosModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus data "${item.kosName}" dari database tersimpan?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              if (item.id != null) {
                final success =
                    await provider.deleteSavedKos(item.id!, item.kosId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Data "${item.kosName}" berhasil dihapus dari database.'
                          : 'Gagal menghapus data kos.'),
                      backgroundColor:
                          success ? Colors.grey[800] : Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kos Tersimpan (Database)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Kos Manual',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSavedKosScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSavedKosScreen(),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Catatan Kos'),
      ),
      body: Consumer<SavedKosProvider>(
        builder: (context, provider, _) {
          // Loading State
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error State
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadSavedKos(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Filter data
          final allItems = provider.savedKosList;
          final items = _filterType == 'Semua'
              ? allItems
              : allItems.where((k) => k.type == _filterType).toList();

          // Empty State
          if (allItems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border,
                        size: 72, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum Ada Kos Tersimpan',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Simpan kos favorit dari katalog atau tambahkan catatan kos secara manual ke database SQLite.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    if (widget.onNavigateToTab != null)
                      ElevatedButton.icon(
                        onPressed: () => widget.onNavigateToTab!(1),
                        icon: const Icon(Icons.search),
                        label: const Text('Buka Katalog Kos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          // Data State
          return RefreshIndicator(
            onRefresh: () => provider.loadSavedKos(),
            child: Column(
              children: [
                // Info Bar & Filter
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Tersimpan: ${allItems.length} Data',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      DropdownButton<String>(
                        value: _filterType,
                        underline: const SizedBox(),
                        style: const TextStyle(
                            fontSize: 13, color: Colors.indigo),
                        items: const [
                          DropdownMenuItem(
                              value: 'Semua', child: Text('Semua Tipe')),
                          DropdownMenuItem(
                              value: 'Putra', child: Text('Putra')),
                          DropdownMenuItem(
                              value: 'Putri', child: Text('Putri')),
                          DropdownMenuItem(
                              value: 'Campur', child: Text('Campur')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _filterType = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SavedKosCardWidget(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditSavedKosScreen(item: item),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditSavedKosScreen(item: item),
                            ),
                          );
                        },
                        onDelete: () => _showDeleteConfirmationDialog(
                            context, provider, item),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
