import 'package:flutter/material.dart';
import 'package:tutophia/models/student-model/session-material_data.dart';

class SessionMaterialCard extends StatelessWidget {
  final SessionMaterialData data;
  final VoidCallback? onDownload;

  const SessionMaterialCard({super.key, required this.data, this.onDownload});

  // ── File type icon helper ──
  IconData _fileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'docx':
      case 'doc':
        return Icons.description_rounded;
      case 'pptx':
      case 'ppt':
        return Icons.slideshow_rounded;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff4a24c),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + file type icon
          Row(
            children: [
              Icon(_fileIcon(data.fileType), color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            "Uploaded by: ${data.uploaderName}",
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 4),

          Text(
            "Uploaded: ${_formatDate(data.uploadedAt)}",
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download_rounded, size: 16),
              label: const Text(
                "Download File",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3d6fa5),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/"
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
