import 'package:finamp/services/feedback_helper.dart';
import 'package:flutter/material.dart';

class HomeScreenQuickActionButton extends StatelessWidget {
  final String text;
  final String? label;
  final IconData icon;
  final double width;
  final bool vertical;
  final void Function() onPressed;
  final void Function()? onSecondaryPressed;
  final bool disabled;

  const HomeScreenQuickActionButton({
    super.key,
    required this.text,
    this.label,
    required this.icon,
    required this.width,
    this.vertical = false,
    required this.onPressed,
    this.onSecondaryPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = disabled ? ColorScheme.of(context).primary.withOpacity(0.5) : ColorScheme.of(context).primary;

    final buttonContent = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accentColor.withOpacity(0.65), accentColor.withOpacity(0.22)],
            ),
          ),
          child: Icon(icon, size: 21, color: Colors.white, weight: 1.0, applyTextScaling: true),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(disabled ? 0.5 : 1.0),
              fontSize: 13,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );

    return Semantics(
      label: text,
      tooltip: label,
      button: true,
      focusable: true,
      onLongPressHint: label,
      excludeSemantics: true, // replace child semantics with custom semantics
      container: true,
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onLongPress: disabled || onSecondaryPressed == null
              ? null
              : () {
                  FeedbackHelper.feedback(FeedbackType.selection);
                  onSecondaryPressed!();
                },
          onSecondaryTap: disabled || onSecondaryPressed == null
              ? null
              : () {
                  FeedbackHelper.feedback(FeedbackType.selection);
                  onSecondaryPressed!();
                },
          child: FilledButton(
            onPressed: disabled
                ? null
                : () {
                    FeedbackHelper.feedback(FeedbackType.selection);
                    onPressed();
                  },

            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color(0xFF282828).withOpacity(disabled ? 0.5 : 1.0),
              ),
            ),
            child: buttonContent,
          ),
        ),
      ),
    );
  }
}
