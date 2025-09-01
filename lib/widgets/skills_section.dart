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
      'Mobile Development': {
        'skills': ['Flutter', 'Dart', 'Swift', 'Kotlin', 'Java', 'Objective-C'],
        'levels': [95, 95, 85, 80, 75, 70],
        'icon': Icons.phone_android,
        'colors': [const Color(0xFF42A5F5), const Color(0xFF1E88E5)],
        'accentColor': const Color(0xFF1976D2),
      },
      'State Management': {
        'skills': ['GetX', 'Provider', 'Bloc'],
        'levels': [98, 85, 80],
        'icon': Icons.settings,
        'colors': [const Color(0xFFAB47BC), const Color(0xFF8E24AA)],
        'accentColor': const Color(0xFF7B1FA2),
      },
      'Backend & Cloud': {
        'skills': ['Firebase', 'Google Cloud', 'REST APIs','Push Notifications'],
        'levels': [90, 80, 85, 88],
        'icon': Icons.cloud,
        'colors': [const Color(0xFF66BB6A), const Color(0xFF43A047)],
        'accentColor': const Color(0xFF388E3C),
      },
      'Databases': {
        'skills': ['SQLite', 'Hive', 'ObjectBox', 'Shared Preferences', 'Firebase Firestore', 'Realtime Database',],
        'levels': [90, 85, 80, 75, 85, 80],
        'icon': Icons.storage,
        'colors': [const Color(0xFFFF7043), const Color(0xFFFF5722)],
        'accentColor': const Color(0xFFE64A19),
      },
      'Tools & DevOps': {
        'skills': ['Git', 'GitHub Actions', 'CI/CD'],
        'levels': [95, 85, 80],
        'icon': Icons.build,
        'colors': [const Color(0xFF26A69A), const Color(0xFF00897B)],
        'accentColor': const Color(0xFF00695C),
      },
      'UI/UX Design': {
        'skills': ['Material Design', 'Cupertino', 'Responsive Design', 'Animations'],
        'levels': [90, 85, 90, 88],
        'icon': Icons.design_services,
        'colors': [const Color(0xFFEF5350), const Color(0xFFE53935)],
        'accentColor': const Color(0xFFD32F2F),
      },
      'Communication & Soft Skills': {
        'skills': ['Team Collaboration', 'Problem Solving', 'Client Communication', 'Technical Writing', 'Time Management'],
        'levels': [95, 90, 92, 85, 88],
        'icon': Icons.person,
        'colors': [const Color(0xFFFFA726), const Color(0xFFFF9800)],
        'accentColor': const Color(0xFFF57C00),
      },
    };

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          key: sectionKey,
          padding: EdgeInsets.symmetric(
            vertical: 100, 
            horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 20,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeProvider.isDarkMode
                  ? [
                      const Color(0xFF0F172A),
                      const Color(0xFF1E293B),
                      const Color(0xFF334155),
                    ]
                  : [
                      const Color(0xFFF8FAFC),
                      const Color(0xFFE2E8F0),
                      Colors.grey[50]!,
                    ],
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
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1024 ? 3 : 
                                       MediaQuery.of(context).size.width > 768 ? 2 : 1,
                        childAspectRatio: MediaQuery.of(context).size.width > 768 ? 1.1 : 1.3,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                      ),
                      itemCount: skillCategories.length,
                      itemBuilder: (context, index) {
                        final category = skillCategories.keys.elementAt(index);
                        final categoryData = skillCategories[category]!;
                        
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 800),
                          columnCount: MediaQuery.of(context).size.width > 1024 ? 3 : 
                                     MediaQuery.of(context).size.width > 768 ? 2 : 1,
                          child: SlideAnimation(
                            verticalOffset: 80,
                            child: FadeInAnimation(
                              child: ScaleAnimation(
                                child: _buildEnhancedSkillCategoryCard(
                                  category, 
                                  categoryData, 
                                  themeProvider,
                                ),
                              ),
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
                        ? [
                            const Color(0xFF60A5FA),
                            const Color(0xFF3B82F6),
                            const Color(0xFF1D4ED8),
                          ]
                        : [
                            const Color(0xFF6366F1),
                            const Color(0xFF8B5CF6),
                            const Color(0xFFEC4899),
                          ],
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
                          ? [
                              const Color(0xFF1E293B).withOpacity(0.8),
                              const Color(0xFF334155).withOpacity(0.6),
                            ]
                          : [
                              Colors.white.withOpacity(0.8),
                              Colors.grey[100]!.withOpacity(0.6),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: themeProvider.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    'Technologies I work with to bring ideas to life',
                    style: GoogleFonts.inter(
                      fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16,
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF6B7280),
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

  Widget _buildEnhancedSkillCategoryCard(
    String category, 
    Map<String, dynamic> categoryData, 
    ThemeProvider themeProvider,
  ) {
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
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.themeProvider.isDarkMode
                      ? [
                          const Color(0xFF1E293B),
                          const Color(0xFF334155),
                          const Color(0xFF475569),
                        ]
                      : [
                          Colors.white,
                          const Color(0xFFFAFAFA),
                          Colors.white,
                        ],
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
                  if (_isHovered)
                    BoxShadow(
                      color: widget.colors[0].withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category header with animated icon
                      _buildCategoryHeader(_isHovered),
                      const SizedBox(height: 24),
            
                      // Skills with levels
                      Expanded(
                        child: ListView(
                          children: List.generate(widget.skills.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _buildEnhancedSkillWithLevel(
                                widget.skills[index], 
                                widget.levels[index],
                                index,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
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
          padding:  EdgeInsets.all(isHovered ? 14 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovered 
                  ? [
                      widget.colors[0],
                      widget.colors[1],
                      widget.accentColor,
                    ]
                  : widget.colors,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withOpacity(0.3),
                blurRadius: isHovered ? 15 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedRotation(
            turns: isHovered ? 0.1 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: isHovered ? 24 : 20,
            ),
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
        
        // Category performance indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            '${(widget.levels.reduce((a, b) => a + b) / widget.levels.length).round()}%',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: widget.accentColor,
            ),
          ),
        ),
      ],
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.themeProvider.isDarkMode
                      ? [
                          const Color(0xFF334155).withOpacity(0.5),
                          const Color(0xFF475569).withOpacity(0.3),
                        ]
                      : [
                          Colors.white.withOpacity(0.8),
                          const Color(0xFFF8FAFC).withOpacity(0.6),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.accentColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          skill,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.themeProvider.isDarkMode
                                ? const Color(0xFFE2E8F0)
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: widget.colors),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$level%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Animated progress bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.themeProvider.isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.2),
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
                              gradient: LinearGradient(
                                colors: [
                                  widget.colors[0],
                                  widget.colors[1],
                                  widget.accentColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.accentColor.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
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
