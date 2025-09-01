import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ContactSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1F2937), Color(0xFF111827)]),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text(
                'Let\'s Work Together',
                style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Ready to bring your ideas to life? Let\'s create something amazing together.',
                style: GoogleFonts.inter(fontSize: 18, color: Colors.white.withOpacity(0.8), height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),

              // Contact cards
              Row(
                children: [
                  _buildContactCard(
                    FontAwesomeIcons.envelope,
                    'Email',
                    'Email me with your ideas.',
                    'mailto:mahmoud.ashraf.elkafrawy@email.com',
                    const Color(0xFFEA4335),
                  ),
                  const SizedBox(width: 30),
                  _buildContactCard(
                    FontAwesomeIcons.whatsapp,
                    'WhatsApp',
                    'Quick chat on WhatsApp.',
                    'https://wa.me/201019744661',
                    const Color(0xFF25D366),
                  ),
                  const SizedBox(width: 30),
                  _buildContactCard(
                    FontAwesomeIcons.linkedin,
                    'LinkedIn',
                    'Connect with me.',
                    'https://www.linkedin.com/in/mahmoud-ashraf-42730a11b/',
                    const Color(0xFF0077B5),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // CTA Button
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: ElevatedButton(
                  onPressed: () => _launchURL('mailto:mahmoud.ashraf.elkafrawy@email.com'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.paperPlane, size: 16),
                      const SizedBox(width: 12),
                      Text('Start a Conversation', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, String url, Color accentColor) {
    return Flexible(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchURL(url),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03), accentColor.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
              boxShadow: [
                BoxShadow(color: accentColor.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor.withOpacity(0.8), accentColor.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: FaIcon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.7), height: 1.3),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
