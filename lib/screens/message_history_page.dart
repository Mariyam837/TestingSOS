import 'package:flutter/material.dart';

import '../data/portal_events.dart';
import '../widgets/portal_ui.dart';

class MessageHistoryPage extends StatefulWidget {
  const MessageHistoryPage({super.key});

  @override
  State<MessageHistoryPage> createState() => _MessageHistoryPageState();
}

class _MessageHistoryPageState extends State<MessageHistoryPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTab = 'All';

  List<PortalEvent> get _visibleEvents {
    switch (_selectedTab) {
      case 'High Risk':
        return portalEvents
            .where((event) => (event.riskScore ?? 0) >= 8)
            .toList();
      case 'Other':
        return portalEvents
            .where((event) => (event.riskScore ?? 0) < 8)
            .toList();
      default:
        return portalEvents;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: PortalColors.background,
      drawer: _buildDrawer(),
      body: PortalBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PortalHeader(
                  onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 920),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                      children: [
                        _buildHeading(),
                        const SizedBox(height: 22),
                        _buildTabs(),
                        const SizedBox(height: 16),
                        for (final event in _visibleEvents) ...[
                          _EventCard(event: event),
                          const SizedBox(height: 12),
                        ],
                        if (_visibleEvents.isEmpty)
                          const PortalPanel(
                            child: Center(
                              child: Text(
                                'No messages in this category.',
                                style: TextStyle(color: PortalColors.muted),
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: PortalColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 22, 22, 28),
              child: PortalLogo(),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_rounded),
              title: const Text('Routine Activity'),
              onTap: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mark_email_unread_rounded),
              title: const Text('Message History'),
              selected: true,
              selectedColor: PortalColors.purple,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back_rounded),
          color: PortalColors.navy,
          style: IconButton.styleFrom(
            backgroundColor: PortalColors.surface,
            elevation: 2,
            shadowColor: PortalColors.shadow.withOpacity(0.5),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message History',
                  style: TextStyle(
                    color: PortalColors.navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'View your received alerts and messages.',
                  style: TextStyle(color: PortalColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE9E5FF),
            boxShadow: [
              BoxShadow(
                color: PortalColors.shadow.withOpacity(0.38),
                blurRadius: 10,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.mark_email_unread_rounded,
            color: PortalColors.purple,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return PortalPanel(
      padding: const EdgeInsets.all(5),
      radius: 18,
      child: Row(
        children: [
          for (final tab in ['All', 'High Risk', 'Other'])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Material(
                  color: _selectedTab == tab
                      ? PortalColors.purple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(13),
                    onTap: () => setState(() => _selectedTab = tab),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Text(
                        tab,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedTab == tab
                              ? Colors.white
                              : PortalColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final PortalEvent event;

  @override
  Widget build(BuildContext context) {
    final time = _formatTimestamp(event.timestamp);
    final dotColor = event.accent;
    return PortalPanel(
      padding: const EdgeInsets.all(14),
      radius: 21,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 58,
            decoration: BoxDecoration(
              color: event.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(event.icon, color: event.accent, size: 25),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: PortalColors.navy,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (event.riskScore != null)
                      _RiskBadge(
                        score: event.riskScore!,
                        color: event.accent,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _MetadataLabel(
                      icon: Icons.schedule_rounded,
                      label: time,
                    ),
                    if (event.location != null)
                      _MetadataLabel(
                        icon: Icons.location_on_rounded,
                        label: event.location!,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  event.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: PortalColors.navy,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 8, color: dotColor),
              const SizedBox(height: 12),
              const Icon(
                Icons.chevron_right_rounded,
                color: PortalColors.muted,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({
    required this.score,
    required this.color,
  });

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$score/10',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetadataLabel extends StatelessWidget {
  const _MetadataLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: PortalColors.muted.withOpacity(0.85),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: PortalColors.muted, fontSize: 10),
        ),
      ],
    );
  }
}
