import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SpotifyBottomNavigation extends StatelessWidget {
  const SpotifyBottomNavigation({
    super.key,
    required this.homeSelected,
    required this.searchSelected,
    required this.librarySelected,
    required this.onHome,
    required this.onSearch,
    required this.onLibrary,
  });

  final bool homeSelected;
  final bool searchSelected;
  final bool librarySelected;
  final VoidCallback onHome;
  final VoidCallback onSearch;
  final VoidCallback onLibrary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xF2181818), Color(0xFF090909)],
        ),
        border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
          child: Row(
            children: [
              Expanded(
                child: _NavigationDestination(
                  label: l10n.home,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  selected: homeSelected,
                  onTap: onHome,
                ),
              ),
              Expanded(
                child: _NavigationDestination(
                  label: l10n.search,
                  icon: Icons.search_rounded,
                  selectedIcon: Icons.search_rounded,
                  selected: searchSelected,
                  onTap: onSearch,
                ),
              ),
              Expanded(
                child: _NavigationDestination(
                  label: l10n.library,
                  icon: Icons.library_music_outlined,
                  selectedIcon: Icons.library_music_rounded,
                  selected: librarySelected,
                  onTap: onLibrary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination extends StatelessWidget {
  const _NavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF1ED760);
    final foreground = selected ? selectedColor : const Color(0xFFB3B3B3);
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 32,
        highlightShape: BoxShape.rectangle,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 160),
                scale: selected ? 1.06 : 1,
                child: Icon(selected ? selectedIcon : icon, color: foreground, size: 27),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 11,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
