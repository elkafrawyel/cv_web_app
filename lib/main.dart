import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/header_section.dart';
import 'widgets/about_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/work_experience_section.dart';
import 'widgets/education_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/contact_section.dart';
import 'widgets/floating_nav_bar.dart';
import 'providers/theme_provider.dart';
import 'utils/performance_utils.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(), child: const CVApp()));
}

class CVApp extends StatelessWidget {
  const CVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Mahmoud ElKafrawy - Portfolio',
          theme: themeProvider.lightTheme.copyWith(textTheme: GoogleFonts.interTextTheme(themeProvider.lightTheme.textTheme)),
          darkTheme: themeProvider.darkTheme.copyWith(textTheme: GoogleFonts.interTextTheme(themeProvider.darkTheme.textTheme)),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const CVHomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class CVHomePage extends StatefulWidget {
  const CVHomePage({super.key});

  @override
  State<CVHomePage> createState() => _CVHomePageState();
}

class _CVHomePageState extends State<CVHomePage> with TickerProviderStateMixin {
  late AnimationController _projectsAnimationController;
  late Animation<double> _projectsAnimation;
  late AnimationController _workExperienceAnimationController;
  late Animation<double> _workExperienceAnimation;
  late AnimationController _educationAnimationController;
  late Animation<double> _educationAnimation;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _workExperienceKey = GlobalKey();
  final GlobalKey _educationKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  bool _showNavBar = false;
  late Function _throttledScrollUpdate;

  @override
  void initState() {
    super.initState();
    _projectsAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _projectsAnimation = CurvedAnimation(parent: _projectsAnimationController, curve: Curves.easeInOut);

    _workExperienceAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _workExperienceAnimation = CurvedAnimation(parent: _workExperienceAnimationController, curve: Curves.easeInOut);

    _educationAnimationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _educationAnimation = CurvedAnimation(parent: _educationAnimationController, curve: Curves.easeInOut);

    // Use throttled scroll updates for better performance
    _throttledScrollUpdate = PerformanceUtils.throttle(
      _handleScrollUpdate,
      const Duration(milliseconds: 16), // ~60 FPS
    );

    _scrollController.addListener(() => _throttledScrollUpdate());
  }

  void _handleScrollUpdate() {
    if (mounted) {
      setState(() {
        _showNavBar = _scrollController.offset > 100;
      });

      if (_scrollController.offset > 200) {
        _workExperienceAnimationController.forward();
      }
      
      if (_scrollController.offset > 400) {
        _educationAnimationController.forward();
      }
      
      if (_scrollController.offset > 600) {
        _projectsAnimationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _projectsAnimationController.dispose();
    _workExperienceAnimationController.dispose();
    _educationAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Optimized SingleChildScrollView with better physics
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: RepaintBoundary(
              child: Column(
                children: [
                  RepaintBoundary(child: HeaderSection(onScrollToWork: () => _scrollToSection(_aboutKey))),
                  RepaintBoundary(child: AboutSection(sectionKey: _aboutKey)),
                  RepaintBoundary(child: SkillsSection(sectionKey: _skillsKey)),
                  RepaintBoundary(
                    child: WorkExperienceSection(sectionKey: _workExperienceKey, workExperienceAnimation: _workExperienceAnimation),
                  ),
                  RepaintBoundary(
                    child: EducationSection(sectionKey: _educationKey, educationAnimation: _educationAnimation),
                  ),

                  RepaintBoundary(
                    child: ProjectsSection(sectionKey: _projectsKey, projectsAnimation: _projectsAnimation),
                  ),
                  RepaintBoundary(child: ContactSection(sectionKey: _contactKey)),
                ],
              ),
            ),
          ),
          FloatingNavBar(
            showNavBar: _showNavBar,
            aboutKey: _aboutKey,
            skillsKey: _skillsKey,
            workExperienceKey: _workExperienceKey,
            educationKey: _educationKey,
            projectsKey: _projectsKey,
            contactKey: _contactKey,
          ),
        ],
      ),
    );
  }
}
