import 'package:flutter/material.dart';

/// Shared row chrome for [SettingsTile]/[SettingsSwitchTile]/
/// [SettingsCategoryTile] — flat, bordered-on-focus, no colored icon
/// circle. Mirrors the selection/focus idiom already used by the desktop
/// shell's own rail (`_DeckRailIcon` in app_shell.dart) and command palette
/// (`_PaletteRow`): a plain icon that only picks up the accent color on
/// selection or keyboard focus, and a visible focus ring — rather than a
/// per-row colored circle background, which read as mobile-app chrome
/// bolted onto the desktop shell and gave every settings row an
/// unrelated, arbitrary hue.
class SettingsRow extends StatefulWidget {
  final IconData? icon;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool autofocus;

  const SettingsRow({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.autofocus = false,
  });

  @override
  State<SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlighted = widget.selected || _focused;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          if (focused != _focused) setState(() => _focused = focused);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: highlighted ? theme.colorScheme.primary.withAlpha(22) : null,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _focused
                  ? theme.colorScheme.primary.withAlpha(160)
                  : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 19,
                  color: highlighted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextStyle.merge(
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                      child: widget.title,
                    ),
                    if (widget.subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          child: widget.subtitle!,
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
