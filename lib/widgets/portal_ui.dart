import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart' as neo;
import 'package:inner_shadow_flutter/inner_shadow_flutter.dart';

class PortalColors {
  static const background = Color(0xFFF0F4FC);
  static const surface = Color(0xFFF8FAFF);
  static const navy = Color(0xFF202B4C);
  static const muted = Color(0xFF818BA5);
  static const purple = Color(0xFF8374E8);
  static const lavender = Color(0xFFB6A7F2);
  static const shadow = Color(0xFFBAC5DA);
  static const pink = Color(0xFFEF7890);
}

class PortalBackground extends StatelessWidget {
  const PortalBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FAFF),
            Color(0xFFF0F3FC),
            Color(0xFFF2EEFF),
          ],
        ),
      ),
      child: child,
    );
  }
}

class PortalPanel extends StatelessWidget {
  const PortalPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return neo.Neumorphic(
      style: neo.NeumorphicStyle(
        shape: neo.NeumorphicShape.flat,
        boxShape: neo.NeumorphicBoxShape.roundRect(
          BorderRadius.circular(radius),
        ),
        depth: 5,
        intensity: 0.7,
        lightSource: neo.LightSource.topLeft,
        color: PortalColors.surface,
        shadowLightColor: Colors.white,
        shadowDarkColor: PortalColors.shadow.withOpacity(0.55),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class PortalInset extends StatelessWidget {
  const PortalInset({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.radius = 14,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return InnerShadow(
      blur: 7,
      color: PortalColors.shadow.withOpacity(0.28),
      offset: const Offset(2, 2),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: PortalColors.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}

class PortalLogo extends StatelessWidget {
  const PortalLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 39,
          height: compact ? 34 : 39,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [PortalColors.lavender, PortalColors.purple],
            ),
            boxShadow: [
              BoxShadow(
                color: PortalColors.purple.withOpacity(0.24),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(
            Icons.shield_rounded,
            size: compact ? 21 : 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 9),
        Text(
          'PortalAI',
          style: TextStyle(
            color: PortalColors.navy,
            fontSize: compact ? 19 : 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}

class PortalHeader extends StatelessWidget {
  const PortalHeader({
    super.key,
    required this.onMenu,
    this.showActions = false,
  });

  final VoidCallback onMenu;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: onMenu,
              icon: const Icon(Icons.menu_rounded),
              color: PortalColors.navy,
              tooltip: 'Open menu',
            ),
          ),
          const PortalLogo(compact: true),
          if (showActions)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Search',
                    icon: const Icon(Icons.search_rounded),
                    color: PortalColors.navy,
                  ),
                  IconButton(
                    onPressed: () {},
                    tooltip: 'Profile',
                    icon: const Icon(Icons.account_circle_outlined),
                    color: PortalColors.navy,
                  ),
                ],
              ),
            )
          else
            const Align(
              alignment: Alignment.centerRight,
              child: SizedBox(width: 48),
            ),
        ],
      ),
    );
  }
}

class PortalSectionTitle extends StatelessWidget {
  const PortalSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: PortalColors.navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: PortalColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

Widget portalGradientButton({
  required String label,
  required IconData icon,
  required VoidCallback onPressed,
  bool emergency = false,
}) {
  return DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: emergency
            ? const [Color(0xFFEF7C91), Color(0xFFE85778)]
            : const [Color(0xFF9A87F2), Color(0xFF7665DD)],
      ),
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: (emergency ? PortalColors.pink : PortalColors.purple)
              .withOpacity(0.24),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
