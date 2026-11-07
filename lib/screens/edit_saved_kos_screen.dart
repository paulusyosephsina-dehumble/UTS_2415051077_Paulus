import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/saved_kos_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class EditSavedKosScreen extends StatefulWidget {
  final SavedKosModel item;

  const EditSavedKosScreen({
    super.key,
    required this.item,
  });

  @override
  State<EditSavedKosScreen> createState() => _EditSavedKosScreenState();
}

class _EditSavedKosScreenState extends State<EditSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;
  late TextEditingController _noteController;

  late String _selectedType;
  late double _rating;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.kosName);
    _addressController = TextEditingController(text: widget.item.address);
    _priceController =
        TextEditingController(text: widget.item.price.toString());
    _noteController = TextEditingController(text: widget.item.note);
    _selectedType = widget.item.type;
    _rating = widget.item.rating;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<SavedKosProvider>(context, listen: false);
    final updatedItem = widget.item.copyWith(
      kosName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      price: int.tryParse(_priceController.text.replaceAll('.', '').trim()) ??
          widget.item.price,
      type: _selectedType,
      note: _noteController.text.trim(),
      rating: _rating,
    );

    final success = await provider.updateSavedKos(updatedItem);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data kos berhasil diperbarui di database!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal memperbarui data kos.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan Kos (Update)'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header ID Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note, color: Colors.amber.shade900),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mengedit Data ID #${widget.item.id} • Dibuat oleh NIM ${widget.item.studentId}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.brown.shade800),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Nama Kos
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos *',
                  prefixIcon: Icon(Icons.apartment),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama kos wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Alamat
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat / Lokasi *',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Alamat kos wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Harga & Tipe
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga / Bulan (Rp) *',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Harga wajib diisi';
                        }
                        if (int.tryParse(val.replaceAll('.', '').trim()) ==
                            null) {
                          return 'Harus berupa angka valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Kos',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
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
                            _selectedType = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rating Interaktif
              const Text(
                'Rating Kos (1 - 5 Bintang)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  RatingStarsWidget(
                    rating: _rating,
                    size: 28,
                    isInteractive: true,
                    onRatingChanged: (newRating) {
                      setState(() {
                        _rating = newRating;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$_rating / 5.0',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Catatan Pribadi
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Pribadi Mahasiswa *',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan Perubahan',
                  icon: Icons.update,
                  isLoading: _isLoading,
                  color: Colors.indigo,
                  onPressed: _updateForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
