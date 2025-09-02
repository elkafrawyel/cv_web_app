import 'package:cv_web_app/models/work_experience_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/work_experience.dart';

class WorkExperienceSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final Animation<double> workExperienceAnimation;

  const WorkExperienceSection({super.key, required this.sectionKey, required this.workExperienceAnimation});

  @override
  State<WorkExperienceSection> createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  int _displayedExperiences = 3; // Start with 3 experiences

  List<WorkExperience> workExperiences = jsonWorkExperiences.map((element) => WorkExperience.fromJson(element)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width > 768 ? 100 : 60, 
        horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 20
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Light gray background to differentiate from projects
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Work Experience',
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width > 768 ? 48 : 32, 
                  fontWeight: FontWeight.w700, 
                  color: const Color(0xFF1F2937), 
                  letterSpacing: -1
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'My professional journey and career highlights', 
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16, 
                  color: const Color(0xFF6B7280)
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 768 ? 60 : 40),

              FadeTransition(
                opacity: widget.workExperienceAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(widget.workExperienceAnimation),
                  child: Column(
                    children: List.generate(
                      _displayedExperiences.clamp(0, workExperiences.length),
                      (index) {
                        return RepaintBoundary(
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: FadeInAnimation(
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  child: WorkExperienceCard(
                                    workExperience: workExperiences[index],
                                    isLast: index == _displayedExperiences - 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Show More button if there are more experiences
              if (_displayedExperiences < workExperiences.length) ...[
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _displayedExperiences = (_displayedExperiences + 2).clamp(0, workExperiences.length);
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
                      'Show More Experience (${workExperiences.length - _displayedExperiences} remaining)',
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

class WorkExperienceCard extends StatefulWidget {
  final WorkExperience workExperience;
  final bool isLast;

  const WorkExperienceCard({super.key, required this.workExperience, this.isLast = false});

  @override
  State<WorkExperienceCard> createState() => _WorkExperienceCardState();
}

class _WorkExperienceCardState extends State<WorkExperienceCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
          children: [
            // Timeline line
            if (!widget.isLast)
              Positioned(
                left: isDesktop ? 75 : 35,
                top: isDesktop ? 140 : 120,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.workExperience.color.withOpacity(0.6),
                        widget.workExperience.color.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),

            // Main card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dot and company icon
                Column(
                  children: [
                    Container(
                      width: isDesktop ? 80 : 60,
                      height: isDesktop ? 80 : 60,
                      decoration: BoxDecoration(
                        color: widget.workExperience.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.workExperience.color.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.workExperience.color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          widget.workExperience.icon,
                          size: isDesktop ? 32 : 24,
                          color: widget.workExperience.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Timeline dot
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: widget.workExperience.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.workExperience.color.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 24),

                // Experience details
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(_isHovered ? 1.01 : 1.0),
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
                    child: Padding(
                      padding: EdgeInsets.all(isDesktop ? 24 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with company and employment type
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: widget.workExperience.companyUrl != null 
                                          ? () => _launchURL(widget.workExperience.companyUrl!)
                                          : null,
                                      child: Text(
                                        widget.workExperience.company,
                                        style: GoogleFonts.inter(
                                          fontSize: isDesktop ? 22 : 18,
                                          fontWeight: FontWeight.w700,
                                          color: widget.workExperience.companyUrl != null 
                                              ? widget.workExperience.color
                                              : const Color(0xFF1F2937),
                                          decoration: widget.workExperience.companyUrl != null 
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.workExperience.position,
                                      style: GoogleFonts.inter(
                                        fontSize: isDesktop ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF374151),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: widget.workExperience.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: widget.workExperience.color.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  widget.workExperience.employmentType,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: widget.workExperience.color,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Duration and location
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: const Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.workExperience.duration,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: const Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.workExperience.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            widget.workExperience.description,
                            style: GoogleFonts.inter(
                              fontSize: isDesktop ? 15 : 14,
                              color: const Color(0xFF374151),
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Responsibilities (collapsible)
                          _buildResponsibilities(),

                          const SizedBox(height: 16),

                          // Technologies
                          Text(
                            'Technologies Used',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.workExperience.technologies
                                .map(
                                  (tech) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: widget.workExperience.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: widget.workExperience.color.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: widget.workExperience.color,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsibilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Key Responsibilities',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isExpanded ? '(Show Less)' : '(Show All)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: widget.workExperience.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: widget.workExperience.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Column(
            children: widget.workExperience.responsibilities
                .take(_isExpanded ? widget.workExperience.responsibilities.length : 3)
                .map(
                  (responsibility) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.workExperience.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            responsibility,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
