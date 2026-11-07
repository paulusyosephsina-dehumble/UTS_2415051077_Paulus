import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/saved_kos_provider.dart';
import '../widgets/rating_stars_widget.dart';
import '../widgets/custom_button_widget.dart';

class AddSavedKosScreen extends StatefulWidget {
  const AddSavedKosScreen({super.key});

  @override
  State<AddSavedKosScreen> createState() => _AddSavedKosScreenState();
}

class _AddSavedKosScreenState extends State<AddSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedType = 'Campur';
  double _rating = 5.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<SavedKosProvider>(context, listen: false);
    final newItem = SavedKosModel(
      studentId: '2415051077',
      kosId: DateTime.now().millisecondsSinceEpoch % 100000,
      kosName: _nameController.text.trim(),
      address: _addressController.text.trim(),
      price: int.tryParse(_priceController.text.replaceAll('.', '').trim()) ?? 0,
      type: _selectedType,
      note: _noteController.text.trim(),
      rating: _rating,
      createdAt: DateTime.now().toIso8601String(),
    );

    final success = await provider.addSavedKos(newItem);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data kos berhasil disimpan ke database SQLite!'),
            backgroundColor: Colors.teal,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage.isNotEmpty
                ? provider.errorMessage
                : 'Gagal menyimpan data kos.'),
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
        title: const Text('Tambah Catatan Kos (Create)'),
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
              // Card Petunjuk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigo.shade100),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.indigo),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Form ini menyimpan data kos baru beserta catatan pribadi ke database SQLite.',
                        style: TextStyle(fontSize: 12, color: Colors.indigo),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Nama Kos Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos *',
                  hintText: 'Misal: Kos Singaraja Melati',
                  prefixIcon: Icon(Icons.apartment),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama kos wajib diisi';
                  }
                  if (val.trim().length < 3) {
                    return 'Nama kos minimal 3 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Alamat Field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat / Lokasi Kos *',
                  hintText: 'Misal: Jl. Udayana No. 10, Singaraja',
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

              // Harga & Tipe Row
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga / Bulan (Rp) *',
                        hintText: '750000',
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

              // Catatan Pribadi Field
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Pribadi Mahasiswa *',
                  hintText: 'Tuliskan review, fasilitas unik, nomor telepon, atau hasil survey Anda...',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Catatan wajib diisi';
                  }
                  if (val.trim().length < 5) {
                    return 'Catatan minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: CustomButtonWidget(
                  label: 'Simpan ke Database',
                  icon: Icons.save,
                  isLoading: _isLoading,
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
