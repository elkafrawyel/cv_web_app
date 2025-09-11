import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'dart:ui';

class FloatingNavBar extends StatefulWidget {
  final bool showNavBar;
  final GlobalKey aboutKey;
  final GlobalKey skillsKey;
  final GlobalKey workExperienceKey;
  final GlobalKey educationKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;

  const FloatingNavBar({
    super.key,
    required this.showNavBar,
    required this.aboutKey,
    required this.skillsKey,
    required this.workExperienceKey,
    required this.educationKey,
    required this.projectsKey,
    required this.contactKey,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(FloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showNavBar && !oldWidget.showNavBar) {
      _scaleController.forward();
    } else if (!widget.showNavBar && oldWidget.showNavBar) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          top: widget.showNavBar ? 20 : -100,
          left: MediaQuery.of(context).size.width < 600 ? 10 : 20,
          right: MediaQuery.of(context).size.width < 600 ? 10 : 20,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 280,
                maxWidth: MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width < 600 ? 20 : 40),
              ),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode ? const Color(0xFF1F2937).withOpacity(0.95) : Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: themeProvider.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05), width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(themeProvider.isDarkMode ? 0.3 : 0.15), blurRadius: 25, offset: const Offset(0, 8)),
                    BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 15)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        final isSmallScreen = screenWidth < 600;
                        final isVerySmallScreen = screenWidth < 400;

                        if (isVerySmallScreen) {
                          // On very small screens, show only icons with minimal padding
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                              _CompactNavItem(icon: Icons.person, title: 'About', onTap: () => _scrollToSection(widget.aboutKey)),
                              _CompactNavItem(icon: Icons.code, title: 'Skills', onTap: () => _scrollToSection(widget.skillsKey)),
                              _CompactNavItem(icon: Icons.business_center, title: 'Experience', onTap: () => _scrollToSection(widget.workExperienceKey)),
                              _CompactNavItem(icon: Icons.school, title: 'Education', onTap: () => _scrollToSection(widget.educationKey)),
                              _CompactNavItem(icon: Icons.work, title: 'Projects', onTap: () => _scrollToSection(widget.projectsKey)),
                              _CompactNavItem(icon: Icons.email, title: 'Contact', onTap: () => _scrollToSection(widget.contactKey)),
                              _ThemeToggleButton(isCompact: true),
                              ],
                            ),
                          );
                        } else if (isSmallScreen) {
                          // On small screens, show only icons with normal padding
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _CompactNavItem(icon: Icons.person, title: 'About', onTap: () => _scrollToSection(widget.aboutKey)),
                              _CompactNavItem(icon: Icons.code, title: 'Skills', onTap: () => _scrollToSection(widget.skillsKey)),
                              _CompactNavItem(icon: Icons.business_center, title: 'Experience', onTap: () => _scrollToSection(widget.workExperienceKey)),
                              _CompactNavItem(icon: Icons.school, title: 'Education', onTap: () => _scrollToSection(widget.educationKey)),
                              _CompactNavItem(icon: Icons.work, title: 'Projects', onTap: () => _scrollToSection(widget.projectsKey)),
                              _CompactNavItem(icon: Icons.email, title: 'Contact', onTap: () => _scrollToSection(widget.contactKey)),
                              // _ThemeToggleButton(isCompact: true),
                            ],
                          );
                        }

                        // On larger screens, show full text
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _EnhancedNavItem(title: 'About', onTap: () => _scrollToSection(widget.aboutKey)),
                            _EnhancedNavItem(title: 'Skills', onTap: () => _scrollToSection(widget.skillsKey)),
                            _EnhancedNavItem(title: 'Experience', onTap: () => _scrollToSection(widget.workExperienceKey)),
                            _EnhancedNavItem(title: 'Education', onTap: () => _scrollToSection(widget.educationKey)),
                            _EnhancedNavItem(title: 'Projects', onTap: () => _scrollToSection(widget.projectsKey)),
                            _EnhancedNavItem(title: 'Contact', onTap: () => _scrollToSection(widget.contactKey)),
                            // _ThemeToggleButton(),
                          ],
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

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    }
  }
}

class _EnhancedNavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _EnhancedNavItem({required this.title, required this.onTap});

  @override
  State<_EnhancedNavItem> createState() => _EnhancedNavItemState();
}

class _EnhancedNavItemState extends State<_EnhancedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width < 600 ? 12 : 20, vertical: 12),
              decoration: BoxDecoration(
                color: _isHovered ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: _isHovered ? Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)) : null,
              ),
              child: Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  color: _isHovered
                      ? const Color(0xFF6366F1)
                      : themeProvider.isDarkMode
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF374151),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CompactNavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CompactNavItem({required this.icon, required this.title, required this.onTap});

  @override
  State<_CompactNavItem> createState() => _CompactNavItemState();
}

class _CompactNavItemState extends State<_CompactNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Tooltip(
          message: widget.title,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: _isHovered ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: _isHovered ? Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)) : null,
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: _isHovered
                      ? const Color(0xFF6366F1)
                      : themeProvider.isDarkMode
                      ? const Color(0xFFE5E7EB)
                      : const Color(0xFF374151),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ThemeToggleButton extends StatefulWidget {
  final bool isCompact;

  const _ThemeToggleButton({this.isCompact = false});

  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton> with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _iconController;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _iconRotation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _iconController, curve: Curves.elasticOut));
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Tooltip(
          message: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () {
                themeProvider.toggleTheme();
                _iconController.reset();
                _iconController.forward();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: widget.isCompact ? 8 : 12, vertical: 12),
                decoration: BoxDecoration(
                  color: _isHovered ? const Color(0xFF6366F1).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: _isHovered ? Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)) : null,
                ),
                child: AnimatedBuilder(
                  animation: _iconRotation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _iconRotation.value * 2 * 3.14159,
                      child: Icon(
                        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: widget.isCompact ? 18 : 20,
                        color: _isHovered
                            ? const Color(0xFF6366F1)
                            : themeProvider.isDarkMode
                            ? const Color(0xFFE5E7EB)
                            : const Color(0xFF374151),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
