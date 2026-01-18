import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';
import 'package:wisata_candi/helpers/database_helper.dart';

class EditCandiScreen extends StatefulWidget {
  final Candi candi;

  const EditCandiScreen({super.key, required this.candi});

  @override
  State<EditCandiScreen> createState() => _EditCandiScreenState();
}

class _EditCandiScreenState extends State<EditCandiScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _builtController;
  late TextEditingController _typeController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.candi.name);
    _locationController = TextEditingController(text: widget.candi.location);
    _descriptionController = TextEditingController(
      text: widget.candi.description,
    );
    _builtController = TextEditingController(text: widget.candi.built);
    _typeController = TextEditingController(text: widget.candi.type);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _builtController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final updatedCandi = Candi(
          id: widget.candi.id,
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
          built: _builtController.text.trim(),
          type: _typeController.text.trim(),
          imageAsset: widget.candi.imageAsset,
          imageUrls: widget.candi.imageUrls,
          isFavorite: widget.candi.isFavorite,
          visitingHours: widget.candi.visitingHours,
          sumFavorite: widget.candi.sumFavorite,
        );

        print('🔄 Updating candi with ID: ${widget.candi.id}');
        print('📝 New name: ${updatedCandi.name}');

        final result = await _dbHelper.updateCandi(updatedCandi);

        print('✅ Update result: $result rows affected');

        setState(() {
          _isSaving = false;
        });

        if (!mounted) return;

        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data berhasil diupdate ($result row)'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, updatedCandi);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengupdate data (ID: ${widget.candi.id})'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isSaving = false;
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Candi'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isSaving ? null : _saveChanges,
            tooltip: 'Simpan Perubahan',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.candi.imageAsset,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),

            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Candi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.temple_buddhist),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama candi tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Deskripsi tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _builtController,
              decoration: InputDecoration(
                labelText: 'Tahun Dibangun',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tahun dibangun tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),

            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Tipe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Tipe tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveChanges,
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.save),
              label: Text(_isSaving ? 'Menyimpan...' : 'Simpan Perubahan'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
