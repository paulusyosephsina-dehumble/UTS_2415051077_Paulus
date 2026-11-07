import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kos_model.dart';
import '../providers/saved_kos_provider.dart';
import 'status_badge_widget.dart';
import 'rating_stars_widget.dart';

class KosCardWidget extends StatelessWidget {
  final KosModel kos;
  final VoidCallback onTap;

  const KosCardWidget({
    super.key,
    required this.kos,
    required this.onTap,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Stack with Badges & Bookmark button
            Stack(
              children: [
                Image.network(
                  kos.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey.shade200,
                    child: Center(
                      child: Icon(Icons.home_work_outlined,
                          size: 48, color: Colors.grey.shade400),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 140,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                ),
                // Type & Availability Badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      StatusBadgeWidget(
                        text: kos.type,
                        color: _getTypeColor(kos.type),
                      ),
                      const SizedBox(width: 4),
                      StatusBadgeWidget(
                        text: kos.isAvailable ? 'Tersedia' : 'Penuh',
                        color: kos.isAvailable ? Colors.green : Colors.red,
                        icon: kos.isAvailable ? Icons.check_circle : Icons.cancel,
                      ),
                    ],
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Consumer<SavedKosProvider>(
                    builder: (context, savedProvider, _) {
                      final isSaved = savedProvider.isSaved(kos.id);
                      return CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 20,
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? Colors.red : Colors.grey.shade700,
                          ),
                          onPressed: () async {
                            final success =
                                await savedProvider.toggleSaveKos(kos);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isSaved
                                        ? '${kos.name} dihapus dari Favorit.'
                                        : '${kos.name} disimpan ke Favorit!',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor:
                                      isSaved ? Colors.grey[800] : Colors.teal,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Content Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          kos.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RatingStarsWidget(rating: kos.rating, size: 14),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          kos.address,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        kos.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 12, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
