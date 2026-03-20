import 'package:flutter/material.dart';

// ── Reusable Dialog Widgets ───────────────────────────────────────────────────

/// Shows "Confirm Student Session Request?" with Yes/No buttons
class ConfirmSessionDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmSessionDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Confirm Student\nSession Request?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogButton(
                  label: 'Yes',
                  color: const Color(0xff3d6fa5),
                  onPressed: onConfirm,
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'No',
                  color: const Color(0xff3d6fa5),
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows "Session Confirmed!" result
class SessionConfirmedDialog extends StatelessWidget {
  final VoidCallback onOkay;

  const SessionConfirmedDialog({super.key, required this.onOkay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Session Confirmed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff2e7d32), // green
              ),
            ),
            const SizedBox(height: 24),
            _DialogButton(
              label: 'Okay',
              color: const Color(0xff3d6fa5),
              onPressed: onOkay,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows "Decline Student Session Request?" with Yes/No buttons
class DeclineSessionDialog extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onCancel;

  const DeclineSessionDialog({
    super.key,
    required this.onDecline,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Decline Student\nSession Request?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogButton(
                  label: 'Yes',
                  color: const Color(0xff3d6fa5),
                  onPressed: onDecline,
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'No',
                  color: const Color(0xff3d6fa5),
                  onPressed: onCancel,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows "Session Declined!" result
class SessionDeclinedDialog extends StatelessWidget {
  final VoidCallback onOkay;

  const SessionDeclinedDialog({super.key, required this.onOkay});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Session Declined!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffe65100), // orange
              ),
            ),
            const SizedBox(height: 24),
            _DialogButton(
              label: 'Okay',
              color: const Color(0xff3d6fa5),
              onPressed: onOkay,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Button Widget ──────────────────────────────────────────────────────

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Helper Functions (call these to show the dialogs) ────────────────────────

/// Step 1 of confirm flow: show confirm dialog, then on Yes show confirmed result
void showConfirmSessionFlow(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ConfirmSessionDialog(
      onConfirm: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              SessionConfirmedDialog(onOkay: () => Navigator.pop(context)),
        );
      },
      onCancel: () => Navigator.pop(context),
    ),
  );
}

/// Step 1 of decline flow: show decline dialog, then on Yes show declined result
void showDeclineSessionFlow(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => DeclineSessionDialog(
      onDecline: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) =>
              SessionDeclinedDialog(onOkay: () => Navigator.pop(context)),
        );
      },
      onCancel: () => Navigator.pop(context),
    ),
  );
}
