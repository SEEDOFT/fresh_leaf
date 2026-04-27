import 'package:flutter/material.dart';

class SecuritySwitchTile extends StatefulWidget {
  const SecuritySwitchTile({required this.label, super.key, this.subtitle});

  final String label;
  final String? subtitle;

  @override
  State<SecuritySwitchTile> createState() => _SecuritySwitchTileState();
}

class _SecuritySwitchTileState extends State<SecuritySwitchTile> {
  bool enabled = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: enabled,
            activeThumbColor: scheme.onPrimary,
            activeTrackColor: scheme.primary,
            onChanged: (v) => setState(() => enabled = v),
          ),
        ],
      ),
    );
  }
}
