import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class DownloadCVView extends StatelessWidget {
  const DownloadCVView({super.key});

  final String _cvUrl =
      // "https://1drv.ms/w/c/c1e5830f36b75553/ERmE--T2SlZKnwS-a6TvQuIBMbAbrbCGUWOdpEspKRcMDw?e=1nACC9";
      "https://drive.google.com/file/d/1rPVeK-YpOJ33lpOY9e0FKH3pRE3bf_CH/view?usp=drive_link";

  void _downloadCV() {
    web.window.open(_cvUrl, "_blank");
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
