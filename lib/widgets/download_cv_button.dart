import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class DownloadCVView extends StatelessWidget {
  const DownloadCVView({super.key});

  void _downloadCV() {
    final anchor = web.HTMLAnchorElement();
    anchor.href = "assets/cv.pdf"; // Path inside web/assets or hosting
    anchor.download = "Mahmoud_Ashraf_CV.pdf"; // Force download name
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // 👆 Changes cursor to hand on hover
      child: ElevatedButton.icon(
        onPressed: _downloadCV,
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text("Save My CV", style: TextStyle(color: Colors.white)),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return const Color(0xFF6366F1).withOpacity(0.2); // hover tint
            }
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFF6366F1).withOpacity(0.4); // pressed tint
            }
            return Colors.transparent; // default
          }),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          elevation: WidgetStateProperty.all<double>(0),
        ),
      ),
    );
  }
}
