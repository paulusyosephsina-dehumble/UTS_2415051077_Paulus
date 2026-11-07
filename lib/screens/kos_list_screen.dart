import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/kos_provider.dart';
import '../widgets/kos_card_widget.dart';
import 'kos_detail_screen.dart';

class KosListScreen extends StatefulWidget {
  const KosListScreen({super.key});

  @override
  State<KosListScreen> createState() => _KosListScreenState();
}

class _KosListScreenState extends State<KosListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load catalog if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<KosProvider>(context, listen: false);
      if (provider.kosList.isEmpty) {
        provider.fetchKosCatalog();
      }
      _searchController.text = provider.searchQuery;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Kos Singaraja'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Consumer<KosProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari nama kos, lokasi, fasilitas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) {
                    provider.setSearchQuery(val);
                    setState(() {});
                  },
                ),
              ),

              // Filter Chips (Semua, Putra, Putri, Campur)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    _buildFilterChip(provider, 'Semua'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Putra'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Putri'),
                    const SizedBox(width: 8),
                    _buildFilterChip(provider, 'Campur'),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Main Body: Responsive List/Grid with States
              Expanded(
                child: _buildBodyContent(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(KosProvider provider, String category) {
    final isSelected = provider.selectedCategory == category;
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (_) => provider.setCategory(category),
      selectedColor: Colors.indigo.shade100,
      checkmarkColor: Colors.indigo,
      labelStyle: TextStyle(
        color: isSelected ? Colors.indigo.shade900 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, KosProvider provider) {
    // 1. Loading State
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.indigo),
            SizedBox(height: 14),
            Text(
              'Mengambil data dari REST API...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // 2. Error State
    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                'Terjadi Kesalahan Jaringan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => provider.fetchKosCatalog(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
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

    final items = provider.filteredKosList;

    // 3. Empty State
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text(
                'Kos Tidak Ditemukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tidak ada kos yang cocok dengan kriteria "${provider.selectedCategory}" atau pencarian "${provider.searchQuery}".',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  provider.clearSearch();
                  setState(() {});
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset Pencarian'),
              ),
            ],
          ),
        ),
      );
    }

    // 4. Data State: Responsive Layout (Compact: List; Wide: Grid)
    return RefreshIndicator(
      onRefresh: () => provider.fetchKosCatalog(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Wide / Expanded condition (tablet, desktop, landscape > 600px)
          if (constraints.maxWidth > 600) {
            final int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final kos = items[index];
                return KosCardWidget(
                  kos: kos,
                  onTap: () => _navigateToDetail(context, kos),
                );
              },
            );
          }

          // Compact condition (mobile portrait <= 600px)
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final kos = items[index];
              return KosCardWidget(
                kos: kos,
                onTap: () => _navigateToDetail(context, kos),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, KosModel kos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KosDetailScreen(kos: kos),
      ),
    );
  }
}
