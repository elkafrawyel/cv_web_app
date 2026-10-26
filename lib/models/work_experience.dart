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

  bool get isCurrent => duration.toLowerCase().contains('present');

  // Human readable tenure, e.g. "1 yr 3 mos", computed from the duration string
  String? get tenure {
    final parts = duration.split('-').map((e) => e.trim()).toList();
    if (parts.length != 2) return null;
    final start = _parseDate(parts[0]);
    final end = isCurrent ? DateTime.now() : _parseDate(parts[1]);
    if (start == null || end == null) return null;

    final months = ((end.year - start.year) * 12 + end.month - start.month).clamp(1, 1200);
    final years = months ~/ 12;
    final remaining = months % 12;
    return [
      if (years > 0) '$years yr${years > 1 ? 's' : ''}',
      if (remaining > 0) '$remaining mo${remaining > 1 ? 's' : ''}',
    ].join(' ');
  }

  int? get startYear => _parseDate(duration.split('-').first.trim())?.year;

  // Supports "MM/YYYY" and "YYYY"
  static DateTime? _parseDate(String value) {
    final segments = value.split('/');
    if (segments.length == 2) {
      final month = int.tryParse(segments[0]);
      final year = int.tryParse(segments[1]);
      if (month != null && year != null) return DateTime(year, month);
    }
    final year = int.tryParse(value);
    return year != null ? DateTime(year) : null;
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
      case 'FontAwesomeIcons.cashRegister': return FontAwesomeIcons.cashRegister;
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
