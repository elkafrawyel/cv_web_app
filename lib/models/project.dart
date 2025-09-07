import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Project {
  final String name;
  final String description;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final String? githubUrl;
  final String? androidLiveUrl;
  final String? iosLiveUrl;
  final List<String> techStack;
  final String status;

  Project({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.color,
    this.githubUrl,
    this.androidLiveUrl,
    this.iosLiveUrl,
    required this.techStack,
    required this.status,
  });


  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      icon: _parseIconData(json['icon'] as String),
      color: _parseColor(json['color'] as String),
      githubUrl: json['githubUrl'] as String?,
      androidLiveUrl: json['androidLiveUrl'] as String?,
      iosLiveUrl: json['iosLiveUrl'] as String?,
      techStack: List<String>.from(json['techStack'] as List),
      status: json['status'] as String,
    );
  }

// Helper function to parse FontAwesomeIcons
  static IconData _parseIconData(String iconString) {
    switch (iconString) {
      case 'FontAwesomeIcons.gears': return FontAwesomeIcons.gears;
      case 'FontAwesomeIcons.bookOpen': return FontAwesomeIcons.bookOpen;
      case 'FontAwesomeIcons.bolt': return FontAwesomeIcons.bolt;
      case 'FontAwesomeIcons.graduationCap': return FontAwesomeIcons.graduationCap;
      case 'FontAwesomeIcons.userCheck': return FontAwesomeIcons.userCheck;
      case 'FontAwesomeIcons.palette': return FontAwesomeIcons.palette;
      case 'FontAwesomeIcons.stethoscope': return FontAwesomeIcons.stethoscope;
      case 'FontAwesomeIcons.hospital': return FontAwesomeIcons.hospital;
      case 'FontAwesomeIcons.utensils': return FontAwesomeIcons.utensils;
      case 'FontAwesomeIcons.gem': return FontAwesomeIcons.gem;
      case 'FontAwesomeIcons.building': return FontAwesomeIcons.building;
      case 'FontAwesomeIcons.water': return FontAwesomeIcons.water;
      case 'FontAwesomeIcons.handsHelping': return FontAwesomeIcons.handsHelping;
      case 'FontAwesomeIcons.futbol': return FontAwesomeIcons.futbol;
      case 'FontAwesomeIcons.cheese': return FontAwesomeIcons.cheese;
      case 'FontAwesomeIcons.server': return FontAwesomeIcons.server;
      case 'FontAwesomeIcons.music': return FontAwesomeIcons.music;
      case 'FontAwesomeIcons.house': return FontAwesomeIcons.house;
      case 'FontAwesomeIcons.box': return FontAwesomeIcons.box;
      case 'FontAwesomeIcons.spider': return FontAwesomeIcons.spider;
      default: return FontAwesomeIcons.question; // default icon
    }
  }

// Helper function to parse color from hex string
  static Color _parseColor(String hexString) {
    return Color(int.parse(hexString.substring(1), radix: 16));
  }
}

