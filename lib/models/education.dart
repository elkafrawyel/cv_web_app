import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Education {
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final String duration;
  final String location;
  final String description;
  final List<String> achievements;
  final List<String> relevantCourses;
  final String? gpa;
  final IconData icon;
  final Color color;
  final String? institutionUrl;
  final String educationType;

  Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.duration,
    required this.location,
    required this.description,
    required this.achievements,
    required this.relevantCourses,
    this.gpa,
    required this.icon,
    required this.color,
    this.institutionUrl,
    required this.educationType,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String,
      duration: json['duration'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      achievements: List<String>.from(json['achievements'] as List),
      relevantCourses: List<String>.from(json['relevantCourses'] as List),
      gpa: json['gpa'] as String?,
      icon: _parseIconData(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      institutionUrl: (json['institutionUrl'] as String).isEmpty ? null : json['institutionUrl'] as String?,
      educationType: json['educationType'] as String,
    );
  }

  // Helper function to parse FontAwesome icons
  static IconData _parseIconData(String iconString) {
    switch (iconString) {
      case 'FontAwesomeIcons.graduationCap': return FontAwesomeIcons.graduationCap;
      case 'FontAwesomeIcons.university': return FontAwesomeIcons.buildingColumns;
      case 'FontAwesomeIcons.school': return FontAwesomeIcons.school;
      case 'FontAwesomeIcons.bookOpen': return FontAwesomeIcons.bookOpen;
      case 'FontAwesomeIcons.certificate': return FontAwesomeIcons.certificate;
      case 'FontAwesomeIcons.award': return FontAwesomeIcons.award;
      case 'FontAwesomeIcons.medal': return FontAwesomeIcons.medal;
      case 'FontAwesomeIcons.star': return FontAwesomeIcons.star;
      case 'FontAwesomeIcons.laptop': return FontAwesomeIcons.laptop;
      case 'FontAwesomeIcons.globe': return FontAwesomeIcons.globe;
      default: return FontAwesomeIcons.graduationCap; // default icon
    }
  }

  // Helper function to parse color from hex string
  static Color _parseColor(String hexString) {
    try {
      // Remove the # if present
      String cleanHex = hexString.startsWith('#') ? hexString.substring(1) : hexString;
      // Add alpha channel if not present (assuming fully opaque)
      if (cleanHex.length == 6) {
        cleanHex = 'FF' + cleanHex;
      }
      return Color(int.parse(cleanHex, radix: 16));
    } catch (e) {
      // Return a default color if parsing fails
      return const Color(0xFF6366F1);
    }
  }
}
