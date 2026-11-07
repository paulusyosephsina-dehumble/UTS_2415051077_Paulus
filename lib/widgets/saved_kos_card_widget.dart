import 'package:flutter/material.dart';
import '../models/saved_kos_model.dart';
import 'status_badge_widget.dart';
import 'rating_stars_widget.dart';

class SavedKosCardWidget extends StatelessWidget {
  final SavedKosModel item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SavedKosCardWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Type Badge, Kos Name, Action Icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadgeWidget(
                    text: item.type,
                    color: _getTypeColor(item.type),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.kosName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Edit Action Button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 20, color: Colors.orange),
                    tooltip: 'Edit Catatan',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    onPressed: onEdit,
                  ),
                  // Delete Action Button
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        size: 20, color: Colors.red),
                    tooltip: 'Hapus Favorit',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    onPressed: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 6),
              // Address & Price
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.address,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    item.formattedPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Personal Note Box
              if (item.note.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.edit_note,
                          size: 16, color: Colors.amber.shade800),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.note,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.brown.shade800,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Footer: User Rating & Saved Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Rating: ',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      RatingStarsWidget(rating: item.rating, size: 14),
                    ],
                  ),
                  Text(
                    'NIM: ${item.studentId}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
