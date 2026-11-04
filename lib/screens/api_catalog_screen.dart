import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class ApiCatalogScreen extends StatefulWidget {
  const ApiCatalogScreen({Key? key}) : super(key: key);

  @override
  State<ApiCatalogScreen> createState() => _ApiCatalogScreenState();
}

class _ApiCatalogScreenState extends State<ApiCatalogScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil API saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog REST API & Provider'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          // 1. Loading State
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Error State
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => provider.loadPosts(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Empty State
          if (provider.posts.isEmpty) {
            return const Center(
              child: Text('Tidak ada data tersedia.'),
            );
          }

          // 4. Data State (Tampil dalam ListView yang responsif)
          return ListView.builder(
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    child: Text('${post.id}'),
                  ),
                  title: Text(
                    post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {
                    // Aksi ketika item diklik menuju Detail Screen
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