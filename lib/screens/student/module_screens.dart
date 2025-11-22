import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';

class ModuleListScreen extends StatelessWidget {
  const ModuleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Modul Pembelajaran',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: kPrimaryColor,
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Cari Modul Pembelajaran',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: kModules.length,
              itemBuilder: (context, index) {
                final m = kModules[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleDetailScreen(module: m),
                        ),
                      );
                    },
                    child: Container(
                      height: 96,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book_rounded,
                              color: Colors.white, size: 40),
                          const SizedBox(width: 16),
                          Text(
                            m.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleDetailScreen extends StatefulWidget {
  final ModuleData module;
  const ModuleDetailScreen({super.key, required this.module});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  Map<String, List<String>> _resources = {};

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

  @override
  Widget build(BuildContext context) {
    final moduleResources = _resources[widget.module.id] ?? [];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.module.title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: kTextColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: kPrimaryColor,
                  child: Icon(Icons.menu_book_rounded, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.module.title,
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      Text(widget.module.subtitle,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Penjelasan Modul',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.module.description,
                  style:
                      GoogleFonts.poppins(fontSize: 13, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (moduleResources.isNotEmpty) ...[
              Text('File dari Guru',
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: moduleResources.length,
                  itemBuilder: (context, index) {
                    final res = moduleResources[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12, top: 4),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.insert_drive_file,
                              color: kPrimaryColor),
                          const SizedBox(height: 8),
                          Text(
                            res,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
