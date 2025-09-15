import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';

import 'download_cv_button.dart';

class HeaderSection extends StatefulWidget {
  final VoidCallback? onScrollToWork;

  const HeaderSection({super.key, this.onScrollToWork});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _floatingAnimationController;
  late AnimationController _typewriterController;
  late AnimationController _orbitController;
  late Animation<double> _headerAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _typewriterAnimation;
  late Animation<double> _orbitAnimation;

  final List<String> _titles = ['Senior Mobile Developer', 'Flutter Expert', 'Full-Stack Developer', 'UI/UX Enthusiast'];
  int _currentTitleIndex = 0;

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(duration: const Duration(milliseconds: 3000), vsync: this);
    _floatingAnimationController = AnimationController(duration: const Duration(seconds: 4), vsync: this);
    _typewriterController = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _orbitController = AnimationController(duration: const Duration(seconds: 8), vsync: this);

    _headerAnimation = CurvedAnimation(parent: _headerAnimationController, curve: Curves.elasticOut);
    _floatingAnimation = Tween<double>(begin: -15, end: 15).animate(CurvedAnimation(parent: _floatingAnimationController, curve: Curves.easeInOut));
    _typewriterAnimation = CurvedAnimation(parent: _typewriterController, curve: Curves.easeInOut);
    _orbitAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(CurvedAnimation(parent: _orbitController, curve: Curves.linear));

    _headerAnimationController.forward();
    _floatingAnimationController.repeat(reverse: true);
    _orbitController.repeat();
    _startTypewriterEffect();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _floatingAnimationController.dispose();
    _typewriterController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  void _startTypewriterEffect() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      _typewriterController.forward();

      Timer.periodic(const Duration(seconds: 4), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        _typewriterController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _currentTitleIndex = (_currentTitleIndex + 1) % _titles.length;
            });
            _typewriterController.forward();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Semantics(
      label: 'Header section with profile information',
      child: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F23), Color(0xFF1A1A3E), Color(0xFF2D1B69), Color(0xFF6366F1)],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(screenWidth, screenHeight, isMobile),
            
            // Floating particles
            ...List.generate(isMobile ? 3 : 6, (index) => _buildFloatingParticle(index, screenWidth, screenHeight)),
            
            // Mesh gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, -0.6),
                  radius: 1.5,
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            
            //Theme toggle button in top-right corner
            SafeArea(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: DownloadCVView(),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 40,
                      vertical: isMobile ? 40 : 60,
                    ),
                    child: FadeTransition(
                      opacity: _headerAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Profile section
                          _buildProfileSection(isMobile, isTablet),
                          
                          SizedBox(height: isMobile ? 30 : 40),
                          
                          // Name with enhanced typography
                          _buildNameSection(isMobile, isTablet),
                          
                          SizedBox(height: isMobile ? 16 : 20),
                          
                          // Animated typewriter title
                          _buildTypewriterTitle(isMobile),

                          SizedBox(height: isMobile ? 30 : 40),

                          // Contact and location
                          _buildContactAndLocation(isMobile),

                          SizedBox(height: isMobile ? 30 : 40),
                          
                          // Social section
                          _buildSocialSection(isMobile),
                          
                          SizedBox(height: isMobile ? 30 : 40),
                          
                          // Scroll indicator
                          _buildScrollIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(bool isMobile, bool isTablet) {
    final profileSize = isMobile ? 120.0 : (isTablet ? 200.0 : 220.0);

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.5),
          child: Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.1)],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20)),
                BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 60, offset: const Offset(0, 30)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(profileSize / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.jpg',
                      width: profileSize,
                      height: profileSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to icon if image fails to load
                        return Icon(
                          Icons.person_rounded,
                          size: profileSize * 0.5,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameSection(bool isMobile, bool isTablet) {
    return Column(
      children: [
        // Greeting text
        Text(
          'Hello, I\'m',
          style: GoogleFonts.inter(fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.8), letterSpacing: 2),
        ),
        const SizedBox(height: 8),

        // Name with enhanced gradient effect
        ShaderMask(
          shaderCallback: (bounds) =>
              const LinearGradient(colors: [Colors.white, Color(0xFFE0E7FF), Colors.white], stops: [0.0, 0.5, 1.0]).createShader(bounds),
          child: Text(
            'Mahmoud ElKafrawy',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 42 : (isTablet ? 56 : 68),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -2,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTypewriterTitle(bool isMobile) {
    return SizedBox(
      height: isMobile ? 45 : 55,
      child: Center(
        child: AnimatedBuilder(
          animation: _typewriterAnimation,
          builder: (context, child) {
            final currentTitle = _titles[_currentTitleIndex];
            final visibleLength = (_typewriterAnimation.value * currentTitle.length).round();
            final displayText = currentTitle.substring(0, visibleLength.clamp(0, currentTitle.length));

            return Container(
              constraints: BoxConstraints(minWidth: isMobile ? 200 : 250),
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24, vertical: isMobile ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayText.isNotEmpty ? displayText : currentTitle,
                    style: GoogleFonts.inter(fontSize: isMobile ? 14 : 18, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
                  ),
                  if (_typewriterAnimation.value > 0 && _typewriterAnimation.value < 1.0)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      width: 2,
                      height: isMobile ? 16 : 20,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactAndLocation(bool isMobile) {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (_headerAnimation.value * 0.2),
          child: Container(
            padding: EdgeInsets.all(isMobile ? 24 : 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.12)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15)),
                BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 40, offset: const Offset(0, 20)),
                BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Column(
                  children: [
                    // Section title
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [const Color(0xFF6366F1).withOpacity(0.3), const Color(0xFF8B5CF6).withOpacity(0.3)]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Text(
                        'Contact Information',
                        style: GoogleFonts.inter(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
                      ),
                    ),
                    SizedBox(height: isMobile ? 20 : 24),

                    // Contact items
                    isMobile
                        ? Column(
                            children: [
                              _buildEnhancedContactItem(
                                FontAwesomeIcons.envelope,
                                'Email',
                                'mahmoud.ashraf.elkafrawy@email.com',
                                null,
                                const Color(0xFFEA4335),
                                isMobile,
                                0,
                              ),
                              const SizedBox(height: 16),
                              _buildEnhancedContactItem(
                                FontAwesomeIcons.phone,
                                'Phone',
                                '+20 101 974 4661',
                                null,
                                const Color(0xFF34D399),
                                isMobile,
                                1,
                              ),

                              const SizedBox(height: 16),
                              _buildEnhancedContactItem(
                                FontAwesomeIcons.locationDot,
                                'Location',
                                'Cairo, Egypt',
                                null,
                                const Color(0xFFF59E0B),
                                isMobile,
                                3,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _buildEnhancedContactItem(
                                  FontAwesomeIcons.envelope,
                                  'Email',
                                  'mahmoud.ashraf.elkafrawy@email.com',
                                  null,
                                  const Color(0xFFEA4335),
                                  isMobile,
                                  0,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildEnhancedContactItem(
                                  FontAwesomeIcons.phone,
                                  'Phone',
                                  '+20 101 974 4661',
                                  null,
                                  const Color(0xFF34D399),
                                  isMobile,
                                  1,
                                ),
                              ),

                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildEnhancedContactItem(
                                  FontAwesomeIcons.locationDot,
                                  'Location',
                                  'Cairo, Egypt',
                                  null,
                                  const Color(0xFFF59E0B),
                                  isMobile,
                                  3,
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedContactItem(IconData icon, String label, String value, String? url, Color accentColor, bool isMobile, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset(0, (1 - animation) * 30),
          child: Opacity(
            opacity: animation.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 16 : 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.04),
                    accentColor.withOpacity(0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: accentColor.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon with subtle background
                      Container(
                        width: isMobile ? 32 : 36,
                        height: isMobile ? 32 : 36,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: isMobile ? 16 : 18,
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 12),
                      
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 11 : 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              value,
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 10 : 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.7),
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSocialSection(bool isMobile) {
    return Column(
      children: [
        Text(
          'Let\'s Connect',
          style: GoogleFonts.inter(fontSize: isMobile ? 16 : 20, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9), letterSpacing: 1),
        ),
        SizedBox(height: isMobile ? 20 : 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModernSocialButton(FontAwesomeIcons.github, 'https://github.com/elkafrawyel', 'GitHub', const Color(0xFF333333)),
            SizedBox(width: isMobile ? 16 : 20),
            _buildModernSocialButton(
              FontAwesomeIcons.linkedin,
              'https://www.linkedin.com/in/elkafrawel/',
              'LinkedIn',
              const Color(0xFF0077B5),
            ),
            SizedBox(width: isMobile ? 16 : 20),
            _buildModernSocialButton(
              FontAwesomeIcons.whatsapp,
              'https://wa.me/201019744661',
              'WhatsApp',
              const Color(0xFF25D366),
            ),
            SizedBox(width: isMobile ? 16 : 20),
            _buildModernSocialButton(FontAwesomeIcons.envelope, 'mailto:mahmoud.ashraf.elkafrawy@email.com', 'Email', const Color(0xFFEA4335)),
          ],
        ),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value * 0.3),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.onScrollToWork,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Discover my work',
                      style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.keyboard_double_arrow_down, color: Colors.white.withOpacity(0.8), size: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernSocialButton(IconData icon, String url, String tooltip, Color brandColor) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _launchURL(url),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [brandColor.withOpacity(0.8), brandColor.withOpacity(0.6)],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: brandColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground(double screenWidth, double screenHeight, bool isMobile) {
    return Stack(
      children: [
        // Pulsing orbs
        ...List.generate(isMobile ? 2 : 4, (index) => _buildPulsingOrb(index, screenWidth, screenHeight)),
        
        // Rotating geometric shapes
        ...List.generate(isMobile ? 1 : 3, (index) => _buildRotatingShape(index, screenWidth, screenHeight)),
        
        // Floating geometric elements
        ...List.generate(isMobile ? 2 : 5, (index) => _buildFloatingGeometry(index, screenWidth, screenHeight)),
        
        // Animated grid pattern
        _buildAnimatedGrid(screenWidth, screenHeight),
      ],
    );
  }
  
  Widget _buildPulsingOrb(int index, double screenWidth, double screenHeight) {
    final random = math.Random(index + 100);
    final size = random.nextDouble() * 100 + 80;
    final left = random.nextDouble() * screenWidth;
    final top = random.nextDouble() * screenHeight;
    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
    ];
    
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        final pulseScale = 0.8 + (math.sin(_orbitController.value * 2 * math.pi + index) * 0.3);
        final opacity = 0.1 + (math.sin(_orbitController.value * 2 * math.pi + index + 1) * 0.05);
        
        return Positioned(
          left: left,
          top: top,
          child: Transform.scale(
            scale: pulseScale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    colors[index % colors.length].withOpacity(opacity),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildRotatingShape(int index, double screenWidth, double screenHeight) {
    final random = math.Random(index + 200);
    final size = random.nextDouble() * 60 + 40;
    final left = random.nextDouble() * screenWidth;
    final top = random.nextDouble() * screenHeight;
    
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        final rotation = _orbitController.value * 2 * math.pi + (index * math.pi / 2);
        
        return Positioned(
          left: left,
          top: top,
          child: Transform.rotate(
            angle: rotation,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.1),
                    const Color(0xFF6366F1).withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(size / 4),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildFloatingGeometry(int index, double screenWidth, double screenHeight) {
    final random = math.Random(index + 300);
    final size = random.nextDouble() * 30 + 20;
    final initialLeft = random.nextDouble() * screenWidth;
    final initialTop = random.nextDouble() * screenHeight;
    
    return AnimatedBuilder(
      animation: _floatingAnimationController,
      builder: (context, child) {
        final progress = (_floatingAnimationController.value + (index * 0.3)) % 1.0;
        final left = initialLeft + (math.sin(progress * 2 * math.pi) * 20);
        final top = initialTop + (math.cos(progress * 2 * math.pi) * 15);
        
        return Positioned(
          left: left,
          top: top,
          child: Transform.rotate(
            angle: progress * 2 * math.pi,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: index % 2 == 0 ? null : BorderRadius.circular(size / 6),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildAnimatedGrid(double screenWidth, double screenHeight) {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(screenWidth, screenHeight),
          painter: AnimatedGridPainter(
            animationValue: _orbitController.value,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index, double screenWidth, double screenHeight) {
    final random = math.Random(index);
    final size = random.nextDouble() * 4 + 2;
    final left = random.nextDouble() * screenWidth;

    return AnimatedBuilder(
      animation: _floatingAnimationController,
      builder: (context, child) {
        // Cache calculations to reduce computational load
        final progress = (_floatingAnimationController.value + (index * 0.2)) % 1.0;
        final top = screenHeight * progress;

        return Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08), // Reduced opacity for better performance
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderThemeToggle(bool isMobile) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, animation, child) {
            return Transform.scale(
              scale: animation,
              child: Tooltip(
                message: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => themeProvider.toggleTheme(),
                    child: Container(
                      width: isMobile ? 48 : 56,
                      height: isMobile ? 48 : 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, animation) {
                              return RotationTransition(
                                turns: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                              key: ValueKey(themeProvider.isDarkMode),
                              color: Colors.white,
                              size: isMobile ? 20 : 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class AnimatedGridPainter extends CustomPainter {
  final double animationValue;
  final double screenWidth;
  final double screenHeight;
  
  AnimatedGridPainter({
    required this.animationValue,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final gridSize = 80.0;
    final offset = animationValue * gridSize;
    
    // Draw vertical lines
    for (double x = -gridSize + offset; x < screenWidth + gridSize; x += gridSize) {
      final path = Path();
      path.moveTo(x, 0);
      path.lineTo(x, screenHeight);
      canvas.drawPath(path, paint);
    }
    
    // Draw horizontal lines
    for (double y = -gridSize + offset; y < screenHeight + gridSize; y += gridSize) {
      final path = Path();
      path.moveTo(0, y);
      path.lineTo(screenWidth, y);
      canvas.drawPath(path, paint);
    }
    
    // Draw some animated connection lines
    final connectionPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < 3; i++) {
      final startX = (screenWidth * 0.2) + (math.sin(animationValue * 2 * math.pi + i) * 100);
      final startY = (screenHeight * 0.3) + (math.cos(animationValue * 2 * math.pi + i) * 80);
      final endX = (screenWidth * 0.8) + (math.sin(animationValue * 2 * math.pi + i + 1) * 120);
      final endY = (screenHeight * 0.7) + (math.cos(animationValue * 2 * math.pi + i + 1) * 100);
      
      final path = Path();
      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        (startX + endX) / 2 + (math.sin(animationValue * 4 * math.pi) * 50),
        (startY + endY) / 2,
        endX,
        endY,
      );
      canvas.drawPath(path, connectionPaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
