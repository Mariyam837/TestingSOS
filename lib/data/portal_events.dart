import 'package:flutter/material.dart';

class PortalEvent {
  const PortalEvent({
    required this.title,
    required this.timestamp,
    required this.description,
    required this.category,
    required this.icon,
    required this.accent,
    this.riskScore,
    this.location,
  });

  final String title;
  final DateTime timestamp;
  final String description;
  final String category;
  final IconData icon;
  final Color accent;
  final int? riskScore;
  final String? location;
}

final portalEvents = <PortalEvent>[
  PortalEvent(
    title: 'High Risk Alert',
    riskScore: 9,
    timestamp: DateTime(2026, 10, 12, 21, 42),
    location: 'Front Door',
    description:
        'Unusual activity detected at your door. Please check the snapshot.',
    category: 'Alert',
    icon: Icons.warning_rounded,
    accent: Color(0xFFE86A83),
  ),
  PortalEvent(
    title: 'Activity Detected',
    riskScore: 5,
    timestamp: DateTime(2026, 10, 12, 19, 18),
    location: 'Main Entrance',
    description: 'Motion detected, no immediate threat.',
    category: 'Activity',
    icon: Icons.directions_walk_rounded,
    accent: Color(0xFFE9B64C),
  ),
  PortalEvent(
    title: 'System Update',
    timestamp: DateTime(2026, 10, 11, 11, 5),
    description: 'The app has been updated to version 2.1.0.',
    category: 'System',
    icon: Icons.system_update_alt_rounded,
    accent: Color(0xFF8B7CE8),
  ),
  PortalEvent(
    title: 'Low Risk Alert',
    riskScore: 2,
    timestamp: DateTime(2026, 10, 11, 16, 12),
    location: 'Staircase',
    description: 'Routine activity detected.',
    category: 'Alert',
    icon: Icons.shield_rounded,
    accent: Color(0xFF68B995),
  ),
  PortalEvent(
    title: 'General Message',
    timestamp: DateTime(2026, 10, 10, 9, 20),
    description: 'Welcome to PORTAL AI. Stay safe!',
    category: 'Message',
    icon: Icons.mark_email_unread_rounded,
    accent: Color(0xFF718BE3),
  ),
];
