import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/portal_events.dart';
import '../widgets/portal_ui.dart';
import 'message_history_page.dart';

class RoutineActivityPage extends StatefulWidget {
  const RoutineActivityPage({super.key});

  @override
  State<RoutineActivityPage> createState() => _RoutineActivityPageState();
}

class _RoutineActivityPageState extends State<RoutineActivityPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  DateTime _fromDate = DateTime(2026, 10, 10);
  DateTime _toDate = DateTime(2026, 10, 12);
  String _eventType = 'All events';
  int _minimumScore = 1;
  int? _matchingEvents;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required bool isFrom}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2027, 12, 31),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: PortalColors.purple,
            surface: PortalColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = selected;
      } else {
        _toDate = selected;
      }
      _matchingEvents = null;
    });
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    final from = DateTime(_fromDate.year, _fromDate.month, _fromDate.day);
    final beforeTo = DateTime(_toDate.year, _toDate.month, _toDate.day + 1);
    final count = portalEvents.where((event) {
      final text = '${event.title} ${event.location ?? ''} '
              '${event.description} ${event.category}'
          .toLowerCase();
      return !event.timestamp.isBefore(from) &&
          event.timestamp.isBefore(beforeTo) &&
          (_eventType == 'All events' || event.category == _eventType) &&
          (event.riskScore ?? 0) >= _minimumScore &&
          (query.isEmpty || text.contains(query));
    }).length;
    setState(() => _matchingEvents = count);
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
                  showActions: true,
                  onMenu: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                      children: [
                        portalGradientButton(
                          label: 'Emergency SOS',
                          icon: Icons.phone_in_talk_rounded,
                          emergency: true,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 20),
                        _buildHeatmap(),
                        const SizedBox(height: 18),
                        _buildFilters(),
                        const SizedBox(height: 18),
                        _buildStatistics(),
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
              selected: true,
              selectedColor: PortalColors.purple,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.mark_email_unread_rounded),
              title: const Text('Message History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const MessageHistoryPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap() {
    const hours = [
      '12AM',
      '3AM',
      '6AM',
      '9AM',
      '12PM',
      '3PM',
      '6PM',
      '9PM',
    ];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const values = [
      [0, 0, 1, 1, 0, 1, 2, 0],
      [0, 0, 1, 2, 1, 2, 3, 1],
      [0, 1, 1, 2, 1, 1, 2, 1],
      [0, 0, 1, 1, 2, 2, 3, 1],
      [0, 0, 1, 2, 2, 1, 2, 1],
      [0, 1, 2, 2, 1, 2, 3, 2],
      [0, 0, 1, 1, 1, 2, 2, 1],
    ];
    const cellColors = [
      Color(0xFFE3F4EA),
      Color(0xFFBFE6D0),
      Color(0xFFF6E7A7),
      Color(0xFFF4C28F),
      Color(0xFFEEA3B1),
    ];
    return PortalPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PortalSectionTitle(
            title: 'Routine Activity Heatmap',
            subtitle: 'Weekly activity by time of day',
            trailing: Icon(
              Icons.more_horiz_rounded,
              color: PortalColors.muted,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final gridWidth = math.max(690.0, constraints.maxWidth);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: gridWidth,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 44),
                          for (final hour in hours)
                            Expanded(
                              child: Center(
                                child: Text(
                                  hour,
                                  style: const TextStyle(
                                    color: PortalColors.muted,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      for (var day = 0; day < days.length; day++) ...[
                        Row(
                          children: [
                            SizedBox(
                              width: 44,
                              child: Text(
                                days[day],
                                style: const TextStyle(
                                  color: PortalColors.muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            for (var hour = 0; hour < hours.length; hour++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: cellColors[values[day][hour]],
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Activity intensity',
                style: TextStyle(color: PortalColors.muted, fontSize: 11),
              ),
              for (final color in cellColors)
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              const Text(
                'Low',
                style: TextStyle(color: PortalColors.muted, fontSize: 10),
              ),
              const Text(
                'High',
                style: TextStyle(color: PortalColors.muted, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return PortalPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PortalSectionTitle(
            title: 'Advanced Event Filters',
            subtitle: 'Narrow down activity from your home',
          ),
          const SizedBox(height: 18),
          PortalInset(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _applyFilters(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search events, locations...',
                hintStyle: TextStyle(color: PortalColors.muted, fontSize: 13),
                icon: Icon(Icons.search_rounded, color: PortalColors.muted),
              ),
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;
              final dateRow = Row(
                children: [
                  Expanded(
                    child: _DateSelector(
                      label: 'From',
                      date: _fromDate,
                      onPressed: () => _selectDate(isFrom: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _DateSelector(
                      label: 'To',
                      date: _toDate,
                      onPressed: () => _selectDate(isFrom: false),
                    ),
                  ),
                ],
              );
              final selectors = Row(
                children: [
                  Expanded(
                    child: _FilterDropdown(
                      label: 'Event Type',
                      value: _eventType,
                      options: const [
                        'All events',
                        'Alert',
                        'Activity',
                        'System',
                        'Message',
                      ],
                      onChanged: (value) => setState(() {
                        _eventType = value!;
                        _matchingEvents = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FilterDropdown(
                      label: 'Min Score',
                      value: '$_minimumScore',
                      options: List.generate(10, (index) => '${index + 1}'),
                      onChanged: (value) => setState(() {
                        _minimumScore = int.parse(value!);
                        _matchingEvents = null;
                      }),
                    ),
                  ),
                ],
              );
              if (compact) {
                return Column(
                  children: [
                    dateRow,
                    const SizedBox(height: 12),
                    selectors,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: dateRow),
                  const SizedBox(width: 14),
                  Expanded(child: selectors),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          portalGradientButton(
            label: 'Search Events',
            icon: Icons.filter_alt_rounded,
            onPressed: _applyFilters,
          ),
          if (_matchingEvents != null) ...[
            const SizedBox(height: 12),
            Text(
              '$_matchingEvents matching ${_matchingEvents == 1 ? 'event' : 'events'}',
              style: const TextStyle(
                color: PortalColors.purple,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    const stats = [
      _StatData(
        'Total Events',
        '124',
        '+12.8%',
        Icons.notifications_active_rounded,
        Color(0xFF8374E8),
      ),
      _StatData(
        'High Risk Events',
        '18',
        '-4.2%',
        Icons.warning_rounded,
        Color(0xFFE86A83),
      ),
      _StatData(
        'Avg. Risk Score',
        '3.2',
        '-0.6%',
        Icons.speed_rounded,
        Color(0xFF55A987),
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
        final gap = 12.0;
        final width = (constraints.maxWidth - (columns - 1) * gap) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in stats)
              SizedBox(
                width: width,
                child: PortalPanel(
                  padding: const EdgeInsets.all(16),
                  radius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item.icon, color: item.color, size: 20),
                          const Spacer(),
                          Text(
                            item.change,
                            style: TextStyle(
                              color: item.change.startsWith('-')
                                  ? const Color(0xFF57A987)
                                  : item.color,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.value,
                        style: const TextStyle(
                          color: PortalColors.navy,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: PortalColors.muted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector({
    required this.label,
    required this.date,
    required this.onPressed,
  });

  final String label;
  final DateTime date;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: PortalColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PortalInset(
          padding: EdgeInsets.zero,
          child: TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(
              Icons.calendar_month_rounded,
              size: 15,
              color: PortalColors.purple,
            ),
            label: Text(
              formatted,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: PortalColors.navy,
                fontSize: 11,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(43),
              padding: const EdgeInsets.symmetric(horizontal: 7),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 3, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: PortalColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PortalInset(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: PortalColors.purple,
              ),
              style: const TextStyle(
                color: PortalColors.navy,
                fontSize: 12,
              ),
              items: options
                  .map(
                    (option) => DropdownMenuItem(
                      value: option,
                      child: Text(option, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatData {
  const _StatData(this.label, this.value, this.change, this.icon, this.color);

  final String label;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
}
