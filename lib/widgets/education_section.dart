import 'package:cv_web_app/models/education_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/education.dart';

class EducationSection extends StatefulWidget {
  final GlobalKey sectionKey;
  final Animation<double> educationAnimation;

  const EducationSection({super.key, required this.sectionKey, required this.educationAnimation});

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  List<Education> educationList = jsonEducation.map((element) => Education.fromJson(element)).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.sectionKey,
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.width > 768 ? 100 : 60, 
        horizontal: MediaQuery.of(context).size.width > 768 ? 40 : 20
      ),
      decoration: const BoxDecoration(
        color: Colors.white, // White background to differentiate from other sections
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Education',
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
                'Academic background and continuous learning journey', 
                style: GoogleFonts.inter(
                  fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 16, 
                  color: const Color(0xFF6B7280)
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.width > 768 ? 60 : 40),

              FadeTransition(
                opacity: widget.educationAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(widget.educationAnimation),
                  child: Column(
                    children: List.generate(
                      educationList.length,
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
                                  child: EducationCard(
                                    education: educationList[index],
                                    isLast: index == educationList.length - 1,
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
            ],
          ),
        ),
      ),
    );
  }
}

class EducationCard extends StatefulWidget {
  final Education education;
  final bool isLast;

  const EducationCard({super.key, required this.education, this.isLast = false});

  @override
  State<EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  bool _isHovered = false;
  bool _showAchievements = false;
  bool _showCourses = false;

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
                        widget.education.color.withOpacity(0.6),
                        widget.education.color.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),

            // Main card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline dot and institution icon
                Column(
                  children: [
                    Container(
                      width: isDesktop ? 80 : 60,
                      height: isDesktop ? 80 : 60,
                      decoration: BoxDecoration(
                        color: widget.education.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.education.color.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.education.color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          widget.education.icon,
                          size: isDesktop ? 32 : 24,
                          color: widget.education.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Timeline dot
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: widget.education.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.education.color.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 24),

                // Education details
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
                          // Header with institution and education type
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: widget.education.institutionUrl != null 
                                          ? () => _launchURL(widget.education.institutionUrl!)
                                          : null,
                                      child: Text(
                                        widget.education.institution,
                                        style: GoogleFonts.inter(
                                          fontSize: isDesktop ? 22 : 18,
                                          fontWeight: FontWeight.w700,
                                          color: widget.education.institutionUrl != null 
                                              ? widget.education.color
                                              : const Color(0xFF1F2937),
                                          decoration: widget.education.institutionUrl != null 
                                              ? TextDecoration.underline
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.education.degree} - ${widget.education.fieldOfStudy}',
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
                                  color: widget.education.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: widget.education.color.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  widget.education.educationType,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: widget.education.color,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Duration, location, and GPA
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: const Color(0xFF6B7280),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.education.duration,
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
                                  widget.education.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              if (widget.education.gpa != null) ...[
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: widget.education.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'GPA: ${widget.education.gpa}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: widget.education.color,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            widget.education.description,
                            style: GoogleFonts.inter(
                              fontSize: isDesktop ? 15 : 14,
                              color: const Color(0xFF374151),
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Achievements (collapsible)
                          _buildAchievements(),

                          const SizedBox(height: 16),

                          // Relevant Courses (collapsible)
                          _buildRelevantCourses(),
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

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Key Achievements',
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
                  _showAchievements = !_showAchievements;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showAchievements ? '(Show Less)' : '(Show All)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: widget.education.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _showAchievements ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: widget.education.color,
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
            children: widget.education.achievements
                .take(_showAchievements ? widget.education.achievements.length : 2)
                .map(
                  (achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: widget.education.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            achievement,
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

  Widget _buildRelevantCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Relevant Courses',
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
                  _showCourses = !_showCourses;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _showCourses ? '(Show Less)' : '(Show All)',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: widget.education.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedRotation(
                    turns: _showCourses ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: widget.education.color,
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
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.education.relevantCourses
                .take(_showCourses ? widget.education.relevantCourses.length : 4)
                .map(
                  (course) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.education.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.education.color.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      course,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.education.color,
                      ),
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
