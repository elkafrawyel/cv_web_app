import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkExperience {
  final String company;
  final String position;
  final String duration;
  final String location;
  final String description;
  final List<String> responsibilities;
  final List<String> technologies;
  final IconData icon;
  final Color color;
  final String? companyUrl;
  final String employmentType;

  WorkExperience({
    required this.company,
    required this.position,
    required this.duration,
    required this.location,
    required this.description,
    required this.responsibilities,
    required this.technologies,
    required this.icon,
    required this.color,
    this.companyUrl,
    required this.employmentType,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      company: json['company'] as String,
      position: json['position'] as String,
      duration: json['duration'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      responsibilities: List<String>.from(json['responsibilities'] as List),
      technologies: List<String>.from(json['technologies'] as List),
      icon: _parseIconData(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      companyUrl: (json['companyUrl'] as String).isEmpty ? null : json['companyUrl'] as String?,
      employmentType: json['employmentType'] as String,
    );
  }

  // Helper function to parse FontAwesome icons
  static IconData _parseIconData(String iconString) {
    switch (iconString) {
      case 'FontAwesomeIcons.building': return FontAwesomeIcons.building;
      case 'FontAwesomeIcons.code': return FontAwesomeIcons.code;
      case 'FontAwesomeIcons.mobile': return FontAwesomeIcons.mobile;
      case 'FontAwesomeIcons.mobileAlt': return FontAwesomeIcons.mobile;
      case 'FontAwesomeIcons.globe': return FontAwesomeIcons.globe;
      case 'FontAwesomeIcons.server': return FontAwesomeIcons.server;
      case 'FontAwesomeIcons.laptop': return FontAwesomeIcons.laptop;
      case 'FontAwesomeIcons.laptopCode': return FontAwesomeIcons.laptopCode;
      case 'FontAwesomeIcons.chart': return FontAwesomeIcons.chartLine;
      case 'FontAwesomeIcons.users': return FontAwesomeIcons.users;
      case 'FontAwesomeIcons.rocket': return FontAwesomeIcons.rocket;
      case 'FontAwesomeIcons.cogs': return FontAwesomeIcons.gears;
      case 'FontAwesomeIcons.codeBranch': return FontAwesomeIcons.codeBranch;
      case 'FontAwesomeIcons.layerGroup': return FontAwesomeIcons.layerGroup;
      case 'FontAwesomeIcons.paintBrush': return FontAwesomeIcons.paintbrush;
      case 'FontAwesomeIcons.android': return FontAwesomeIcons.android;
      default: return FontAwesomeIcons.briefcase; // default icon
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
