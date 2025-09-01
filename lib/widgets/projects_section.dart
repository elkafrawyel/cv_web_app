import 'package:cv_web_app/models/projects_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/project.dart';

class ProjectsSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final Animation<double> projectsAnimation;

  const ProjectsSection({super.key, required this.sectionKey, required this.projectsAnimation});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  int _displayedProjects = 6; // Start with 6 projects

  List<Project> projects = jsonProjects.map((element) => Project.fromJson(element)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Featured Projects',
                style: GoogleFonts.inter(fontSize: 48, fontWeight: FontWeight.w700, color: const Color(0xFF1F2937), letterSpacing: -1),
              ),
              const SizedBox(height: 16),
              Text('Some of the projects I\'ve worked on recently', style: GoogleFonts.inter(fontSize: 18, color: const Color(0xFF6B7280))),
              const SizedBox(height: 60),

              FadeTransition(
                opacity: widget.projectsAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(widget.projectsAnimation),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1200
                          ? 3
                          : constraints.maxWidth > 800
                          ? 2
                          : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                        ),
                        itemCount: _displayedProjects.clamp(0, projects.length),
                        itemBuilder: (context, index) {
                          return RepaintBoundary(
                            child: AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 400), // Reduced duration
                              columnCount: crossAxisCount,
                              child: FadeInAnimation(child: ProjectCard(project: projects[index])),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Show More button if there are more projects
              if (_displayedProjects < projects.length) ...[
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _displayedProjects = (_displayedProjects + 6).clamp(0, projects.length);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Show More Projects (${projects.length - _displayedProjects} remaining)',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150), // Reduced duration for snappier feel
          transform: Matrix4.identity()..scale(_isHovered ? 1.01 : 1.0), // Reduced scale for better performance
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.08),
                blurRadius: _isHovered ? 25 : 20,
                offset: Offset(0, _isHovered ? 12 : 8),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project icon section with gradient background
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.project.color.withOpacity(0.1), widget.project.color.withOpacity(0.05)],
                  ),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.project.color.withOpacity(_isHovered ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FaIcon(widget.project.icon, size: 40, color: widget.project.color),
                  ),
                ),
              ),

              // Project details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ListView(
                    children: [
                      // Project header with status
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.project.name,
                              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.project.status == 'Completed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.project.status == 'Completed' ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              widget.project.status,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: widget.project.status == 'Completed' ? Colors.green[700] : Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        widget.project.description,
                        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6B7280), height: 1.5),
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),

                      // Tech stack
                      Text(
                        'Tech Stack',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF374151)),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: widget.project.techStack
                            .map(
                              (tech) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: widget.project.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: widget.project.color.withOpacity(0.2)),
                                ),
                                child: Text(
                                  tech,
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: widget.project.color),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),

                      // Action buttons
                      Row(
                        children: [
                          if (widget.project.liveUrl != null)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _launchURL(widget.project.liveUrl!),
                                icon: const FaIcon(FontAwesomeIcons.globe, size: 14),
                                label: Text('Live Demo', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: widget.project.color,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          if (widget.project.liveUrl != null && widget.project.githubUrl != null) const SizedBox(width: 8),
                          if (widget.project.githubUrl != null)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _launchURL(widget.project.githubUrl!),
                                icon: const FaIcon(FontAwesomeIcons.github, size: 14),
                                label: Text('GitHub', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: widget.project.color,
                                  side: BorderSide(color: widget.project.color.withOpacity(0.3)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                        ],
                      ),
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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
