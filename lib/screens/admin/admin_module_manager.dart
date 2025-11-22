import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class AdminModuleManagerScreen extends StatefulWidget {
  const AdminModuleManagerScreen({super.key});

  @override
  State<AdminModuleManagerScreen> createState() =>
      _AdminModuleManagerScreenState();
}

class _AdminModuleManagerScreenState extends State<AdminModuleManagerScreen> {
  Map<String, List<String>> _resources = {};
  final _controller = TextEditingController();
  String _selectedModuleId = kModules.first.id;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await StorageService.loadModuleResources();
    setState(() {
      _resources = res;
    });
  }

  Future<void> _addResource() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _resources[_selectedModuleId] =
        (_resources[_selectedModuleId] ?? [])..add(text);
    await StorageService.saveModuleResources(_resources);
    await StorageService.addNotification(
        'Guru menambahkan materi baru pada modul ${kModules.firstWhere((m) => m.id == _selectedModuleId).title}.');
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final moduleResources = _resources[_selectedModuleId] ?? [];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Kelola Modul',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedModuleId,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0)),
                ),
              ),
              items: kModules
                  .map((m) => DropdownMenuItem(
                        value: m.id,
                        child: Text(m.title),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedModuleId = v ?? _selectedModuleId;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nama file atau link materi (mis. BilanganBulat.pdf)',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_rounded, color: kPrimaryColor),
                  onPressed: _addResource,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Daftar File Modul',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: moduleResources.isEmpty
                  ? Center(
                      child: Text('Belum ada file untuk modul ini.',
                          style: GoogleFonts.poppins()),
                    )
                  : ListView.builder(
                      itemCount: moduleResources.length,
                      itemBuilder: (context, index) {
                        final res = moduleResources[index];
                        return Container(
                          margin:
                              const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFE0E0E0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.insert_drive_file,
                                  color: kPrimaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  res,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent),
                                onPressed: () async {
                                  moduleResources.removeAt(index);
                                  _resources[_selectedModuleId] =
                                      moduleResources;
                                  await StorageService
                                      .saveModuleResources(_resources);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
