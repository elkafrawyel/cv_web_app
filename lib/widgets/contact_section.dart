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
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width > 768 ? 100 : 60,
        horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 20,
      ),
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
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32, 
                  fontWeight: FontWeight.w700, 
                  color: Colors.white, 
                  letterSpacing: -1
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 768 ? 16 : 12),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 768 ? 0 : 20,
                ),
                child: Text(
                  'Ready to bring your ideas to life? Let\'s create something amazing together.',
                  style: GoogleFonts.inter(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16, 
                    color: Colors.white.withOpacity(0.8), 
                    height: 1.6
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 768 ? 50 : 40),

              // Contact cards with responsive layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final isSmallScreen = screenWidth < 768;
                  
                  if (isSmallScreen) {
                    // Stack cards vertically on small screens
                    return Column(
                      children: [
                        _buildContactCard(
                          FontAwesomeIcons.envelope,
                          'Email',
                          'Email me with your ideas.',
                          'mailto:mahmoud.ashraf.elkafrawy@email.com',
                          const Color(0xFFEA4335),
                          context,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          FontAwesomeIcons.whatsapp,
                          'WhatsApp',
                          'Quick chat on WhatsApp.',
                          'https://wa.me/201019744661',
                          const Color(0xFF25D366),
                          context,
                        ),
                        const SizedBox(height: 20),
                        _buildContactCard(
                          FontAwesomeIcons.linkedin,
                          'LinkedIn',
                          'Connect with me professionally.',
                          'https://www.linkedin.com/in/mahmoud-ashraf-42730a11b/',
                          const Color(0xFF0077B5),
                          context,
                        ),
                      ],
                    );
                  }
                  
                  // Show cards in a row on larger screens
                  return Wrap(
                    spacing: screenWidth > 1024 ? 30 : 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildContactCard(
                        FontAwesomeIcons.envelope,
                        'Email',
                        'Email me with your ideas.',
                        'mailto:mahmoud.ashraf.elkafrawy@email.com',
                        const Color(0xFFEA4335),
                        context,
                      ),
                      _buildContactCard(
                        FontAwesomeIcons.whatsapp,
                        'WhatsApp',
                        'Quick chat on WhatsApp.',
                        'https://wa.me/201019744661',
                        const Color(0xFF25D366),
                        context,
                      ),
                      _buildContactCard(
                        FontAwesomeIcons.linkedin,
                        'LinkedIn',
                        'Connect with me professionally.',
                        'https://www.linkedin.com/in/mahmoud-ashraf-42730a11b/',
                        const Color(0xFF0077B5),
                        context,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 768 ? 40 : 30),

              // CTA Button
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width > 768 ? 400 : double.infinity,
                ),
                child: Container(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width > 768 ? 48 : 32, 
                        vertical: MediaQuery.of(context).size.width > 768 ? 20 : 16
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      minimumSize: Size(double.infinity, 0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.paperPlane, size: MediaQuery.of(context).size.width > 768 ? 16 : 14),
                        SizedBox(width: MediaQuery.of(context).size.width > 768 ? 12 : 8),
                        Flexible(
                          child: Text(
                            'Start a Conversation', 
                            style: GoogleFonts.inter(
                              fontSize: MediaQuery.of(context).size.width > 768 ? 16 : 14, 
                              fontWeight: FontWeight.w600
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle, String url, Color accentColor, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isSmallScreen ? double.infinity : 240,
        minWidth: isSmallScreen ? double.infinity : 200,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchURL(url),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accentColor.withOpacity(0.8), accentColor.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: FaIcon(icon, color: Colors.white, size: isSmallScreen ? 20 : 24),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 14 : 16, 
                    fontWeight: FontWeight.w600, 
                    color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: isSmallScreen ? 12 : 14, 
                    color: Colors.white.withOpacity(0.7), 
                    height: 1.3
                  ),
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
