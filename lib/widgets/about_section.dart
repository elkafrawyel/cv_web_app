import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class AboutSection extends StatefulWidget {
  final GlobalKey sectionKey;
  
  const AboutSection({super.key, required this.sectionKey});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAFAFA), Colors.white],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isMobile = constraints.maxWidth < 768;
              
              if (isMobile) {
                return Column(
                  children: [
                    _buildTextContent(),
                    const SizedBox(height: 40),
                    _buildVisualElement(),
                  ],
                );
              }
              
              return Row(
                children: [
                  // Left side - Text content
                  Expanded(
                    flex: 3,
                    child: _buildTextContent(),
                  ),
                  const SizedBox(width: 60),
                  // Right side - Visual element
                  Expanded(
                    flex: 2,
                    child: _buildVisualElement(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: GoogleFonts.inter(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'I am a passionate Mobile Developer with expertise in mobile and web development. '
          'I love creating beautiful, functional applications that solve real-world problems.',
          style: GoogleFonts.inter(
            fontSize: 20,
            height: 1.6,
            color: const Color(0xFF4B5563),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'With experience in Flutter and various other technologies, '
          'I bring ideas to life through clean, efficient code and stunning user experiences.',
          style: GoogleFonts.inter(
            fontSize: 18,
            height: 1.6,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 30,
          runSpacing: 20,
          children: [
            _buildStatCard('8+', 'Years\nExperience'),
            _buildStatCard('30+', 'Projects\nCompleted'),
            _buildStatCard('20+', 'Happy\nClients'),
          ],
        ),
      ],
    );
  }

  Widget _buildVisualElement() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Reduced animated geometric shapes for better performance
            ...List.generate(3, (index) => _buildGeometricShape(index)),
            Center(
              child: Icon(
                FontAwesomeIcons.code,
                size: 80,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF6B7280),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGeometricShape(int index) {
    final random = math.Random(index);
    final size = random.nextDouble() * 60 + 20;
    final left = random.nextDouble() * 300;
    final top = random.nextDouble() * 300;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          left: left + math.sin(_animationController.value * 2 * math.pi + index) * 20,
          top: top + math.cos(_animationController.value * 2 * math.pi + index) * 20,
          child: RepaintBoundary(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08), // Reduced opacity for better performance
                borderRadius: BorderRadius.circular(index % 2 == 0 ? size / 2 : 8),
              ),
            ),
          ),
        );
      },
    );
  }
}
