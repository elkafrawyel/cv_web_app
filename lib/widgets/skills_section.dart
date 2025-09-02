import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dart:ui';
import 'dart:math' as math;

class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final skillCategories = {
      'Flutter & Dart': {
        'skills': ['Flutter Framework', 'Dart Language', 'Widget Development', 'Custom Animations', 'Performance Optimization'],
        'levels': [95, 92, 90, 85, 88],
        'icon': Icons.phone_android,
        'colors': [const Color(0xFF0175C2), const Color(0xFF13B9FD)],
        'accentColor': const Color(0xFF0175C2),
      },
      'State Management': {
        'skills': ['Bloc/Cubit', 'Riverpod', 'Provider', 'GetX', 'Redux'],
        'levels': [90, 85, 88, 82, 75],
        'icon': Icons.settings_applications,
        'colors': [const Color(0xFF6C63FF), const Color(0xFF4CAF50)],
        'accentColor': const Color(0xFF6C63FF),
      },
      'Backend Integration': {
        'skills': ['REST APIs', 'GraphQL', 'WebSocket', 'JSON Parsing', 'HTTP Client', 'Authentication'],
        'levels': [92, 80, 85, 90, 88, 87],
        'icon': Icons.cloud_sync,
        'colors': [const Color(0xFF00BCD4), const Color(0xFF009688)],
        'accentColor': const Color(0xFF00BCD4),
      },
      'Firebase & Cloud': {
        'skills': ['Firestore', 'Firebase Auth', 'Cloud Functions', 'Push Notifications', 'Analytics'],
        'levels': [90, 92, 78, 88, 85],
        'icon': Icons.cloud,
        'colors': [const Color(0xFFFF9800), const Color(0xFFFF5722)],
        'accentColor': const Color(0xFFFF9800),
      },
      'Local Storage': {
        'skills': ['SQLite', 'Hive', 'Shared Preferences', 'Secure Storage', 'File System'],
        'levels': [88, 85, 90, 82, 80],
        'icon': Icons.storage,
        'colors': [const Color(0xFF9C27B0), const Color(0xFF673AB7)],
        'accentColor': const Color(0xFF9C27B0),
      },
      'UI/UX & Design': {
        'skills': ['Material Design 3', 'Cupertino Design', 'Responsive UI', 'Theming', 'Accessibility'],
        'levels': [92, 88, 90, 85, 80],
        'icon': Icons.design_services,
        'colors': [const Color(0xFFE91E63), const Color(0xFFF44336)],
        'accentColor': const Color(0xFFE91E63),
      },
      'Testing & DevOps': {
        'skills': ['Unit Testing', 'Widget Testing', 'Git & GitHub', 'CI/CD', 'App Store Deployment'],
        'levels': [85, 80, 95, 82, 88],
        'icon': Icons.bug_report,
        'colors': [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
        'accentColor': const Color(0xFF4CAF50),
      },
      'Native Integration': {
        'skills': ['Platform Channels', 'Native Plugins', 'Android Native', 'iOS Native', 'FFI'],
        'levels': [82, 85, 78, 75, 70],
        'icon': Icons.integration_instructions,
        'colors': [const Color(0xFF795548), const Color(0xFF607D8B)],
        'accentColor': const Color(0xFF795548),
      },
    };

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          key: sectionKey,
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeProvider.isDarkMode
                  ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF334155)]
                  : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), Colors.grey[50]!],
            ),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  // Animated title section
                  _buildAnimatedTitleSection(themeProvider),
                  const SizedBox(height: 60),

                  AnimationLimiter(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = MediaQuery.of(context).size.width > 1024
                            ? 3
                            : MediaQuery.of(context).size.width > 768
                            ? 2
                            : 1;
                        
                        return Wrap(
                          spacing: 30,
                          runSpacing: 30,
                          children: List.generate(
                            skillCategories.length,
                            (index) {
                              final category = skillCategories.keys.elementAt(index);
                              final categoryData = skillCategories[category]!;

                              return Container(
                                width: crossAxisCount == 1
                                    ? constraints.maxWidth
                                    : (constraints.maxWidth - (30 * (crossAxisCount - 1))) / crossAxisCount,
                                child: AnimationConfiguration.staggeredGrid(
                                  position: index,
                                  duration: const Duration(milliseconds: 800),
                                  columnCount: crossAxisCount,
                                  child: SlideAnimation(
                                    verticalOffset: 80,
                                    child: FadeInAnimation(
                                      child: ScaleAnimation(
                                        child: _buildEnhancedSkillCategoryCard(
                                          category,
                                          categoryData,
                                          themeProvider
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitleSection(ThemeProvider themeProvider) {
    return Column(
      children: [
        // Main title with gradient effect
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, animation, child) {
            return Transform.translate(
              offset: Offset(0, (1 - animation) * 50),
              child: Opacity(
                opacity: animation.clamp(0.0, 1.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: themeProvider.isDarkMode
                        ? [const Color(0xFF60A5FA), const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]
                        : [const Color(0xFF6366F1), const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
                  ).createShader(bounds),
                  child: Text(
                    'Skills & Expertise',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Subtitle with animation
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1400),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, animation, child) {
            return Transform.translate(
              offset: Offset(0, (1 - animation) * 30),
              child: Opacity(
                opacity: animation.clamp(0.0, 1.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: themeProvider.isDarkMode
                          ? [const Color(0xFF1E293B).withOpacity(0.8), const Color(0xFF334155).withOpacity(0.6)]
                          : [Colors.white.withOpacity(0.8), Colors.grey[100]!.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: themeProvider.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Text(
                    'Technologies I work with to bring ideas to life',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16,
                      color: themeProvider.isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEnhancedSkillCategoryCard(String category, Map<String, dynamic> categoryData, ThemeProvider themeProvider) {
    final skills = categoryData['skills'] as List<String>;
    final levels = categoryData['levels'] as List<int>;
    final icon = categoryData['icon'] as IconData;
    final colors = categoryData['colors'] as List<Color>;
    final accentColor = categoryData['accentColor'] as Color;

    return _SkillCategoryCard(
      category: category,
      skills: skills,
      levels: levels,
      icon: icon,
      colors: colors,
      accentColor: accentColor,
      themeProvider: themeProvider,
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  final String category;
  final List<String> skills;
  final List<int> levels;
  final IconData icon;
  final List<Color> colors;
  final Color accentColor;
  final ThemeProvider themeProvider;

  const _SkillCategoryCard({
    required this.category,
    required this.skills,
    required this.levels,
    required this.icon,
    required this.colors,
    required this.accentColor,
    required this.themeProvider,
  });

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? _pulseAnimation.value * 0.98 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding: EdgeInsets.all(MediaQuery.of(context).size.width > 768 ? 24 : 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.themeProvider.isDarkMode
                        ? [const Color(0xFF1E293B), const Color(0xFF334155), const Color(0xFF475569)]
                        : [Colors.white, const Color(0xFFFAFAFA), Colors.white],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? widget.accentColor.withOpacity(0.4)
                        : widget.themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.15),
                    width: _isHovered ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withOpacity(_isHovered ? 0.25 : 0.1),
                      blurRadius: _isHovered ? 25 : 15,
                      offset: Offset(0, _isHovered ? 10 : 5),
                    ),
                    if (_isHovered) BoxShadow(color: widget.colors[0].withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 15)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.width > 768 ? 420 : 380, // Fixed height for consistency
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Category header with animated icon
                          _buildCategoryHeader(_isHovered),
                          SizedBox(height: MediaQuery.of(context).size.width > 768 ? 24 : 20),

                          // Skills with levels - using Expanded for consistent height distribution
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.skills.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String skill = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: index == widget.skills.length - 1 ? 0 : 8 // Reduced spacing
                                    ),
                                    child: _buildCompactSkillWithLevel(skill, widget.levels[index], index),
                                  );
                                }).toList(),
                              ),
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
      ),
    );
  }

  Widget _buildCategoryHeader(bool isHovered) {
    return Row(
      children: [
        // Animated icon container
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(isHovered ? 14 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovered ? [widget.colors[0], widget.colors[1], widget.accentColor] : widget.colors,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: widget.accentColor.withOpacity(0.3), blurRadius: isHovered ? 15 : 8, offset: const Offset(0, 4))],
          ),
          child: AnimatedRotation(
            turns: isHovered ? 0.1 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(widget.icon, color: Colors.white, size: isHovered ? 24 : 20),
          ),
        ),
        const SizedBox(width: 16),

        // Category title with gradient effect
        Expanded(
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isHovered
                  ? widget.colors
                  : widget.themeProvider.isDarkMode
                  ? [Colors.white, const Color(0xFFE2E8F0)]
                  : [const Color(0xFF1F2937), const Color(0xFF374151)],
            ).createShader(bounds),
            child: Text(
              widget.category,
              style: GoogleFonts.inter(
                fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16, 
                fontWeight: FontWeight.w700, 
                color: Colors.white, 
                letterSpacing: -0.5
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),

        // Category performance indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.accentColor.withOpacity(0.3), width: 1),
          ),
          child: Text(
            '${(widget.levels.reduce((a, b) => a + b) / widget.levels.length).round()}%',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: widget.accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactSkillWithLevel(String skill, int level, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset((1 - animation) * 30, 0),
          child: Opacity(
            opacity: animation.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 768 ? 12 : 10, 
                vertical: MediaQuery.of(context).size.width > 768 ? 10 : 8
              ),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.themeProvider.isDarkMode
                      ? [const Color(0xFF334155).withOpacity(0.4), const Color(0xFF475569).withOpacity(0.2)]
                      : [Colors.white.withOpacity(0.9), const Color(0xFFF8FAFC).withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: widget.accentColor.withOpacity(0.15), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      skill,
                      style: GoogleFonts.inter(
                        fontSize: MediaQuery.of(context).size.width > 768 ? 13 : 12,
                        fontWeight: FontWeight.w600,
                        color: widget.themeProvider.isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF1F2937),
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Compact progress bar
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.width > 768 ? 6 : 5,
                      decoration: BoxDecoration(
                        color: widget.themeProvider.isDarkMode 
                            ? Colors.white.withOpacity(0.1) 
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 800 + (index * 120)),
                        tween: Tween(begin: 0.0, end: level / 100),
                        curve: Curves.easeOutCubic,
                        builder: (context, progressAnimation, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progressAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [widget.colors[0], widget.colors[1]]
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [BoxShadow(
                                  color: widget.accentColor.withOpacity(0.3), 
                                  blurRadius: 2, 
                                  offset: const Offset(0, 1)
                                )],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Percentage badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width > 768 ? 6 : 5, 
                      vertical: 2
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [widget.colors[0], widget.colors[1]]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$level%',
                      style: GoogleFonts.inter(
                        fontSize: MediaQuery.of(context).size.width > 768 ? 10 : 9, 
                        fontWeight: FontWeight.w700, 
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedSkillWithLevel(String skill, int level, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset((1 - animation) * 50, 0),
          child: Opacity(
            opacity: animation.clamp(0.0, 1.0),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width > 768 ? 16 : 14),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.themeProvider.isDarkMode
                      ? [const Color(0xFF334155).withOpacity(0.5), const Color(0xFF475569).withOpacity(0.3)]
                      : [Colors.white.withOpacity(0.8), const Color(0xFFF8FAFC).withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.accentColor.withOpacity(0.2), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          skill,
                          style: GoogleFonts.inter(
                            fontSize: MediaQuery.of(context).size.width > 768 ? 14 : 13,
                            fontWeight: FontWeight.w600,
                            color: widget.themeProvider.isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF1F2937),
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width > 768 ? 8 : 6, 
                            vertical: 4
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: widget.colors),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$level%',
                            style: GoogleFonts.inter(
                              fontSize: MediaQuery.of(context).size.width > 768 ? 12 : 11, 
                              fontWeight: FontWeight.w700, 
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width > 768 ? 10 : 8),

                  // Animated progress bar
                  Container(
                    height: MediaQuery.of(context).size.width > 768 ? 8 : 6,
                    decoration: BoxDecoration(
                      color: widget.themeProvider.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 1000 + (index * 150)),
                      tween: Tween(begin: 0.0, end: level / 100),
                      curve: Curves.easeOutCubic,
                      builder: (context, progressAnimation, child) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressAnimation,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [widget.colors[0], widget.colors[1], widget.accentColor]),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [BoxShadow(color: widget.accentColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 1))],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
