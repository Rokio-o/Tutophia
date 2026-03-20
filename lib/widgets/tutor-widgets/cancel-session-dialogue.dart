import 'package:flutter/material.dart';

// ── Shared private button ─────────────────────────────────────────────────────

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

// ── Step 1: Cancel Session? ───────────────────────────────────────────────────

class CancelSessionDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const CancelSessionDialog({
    super.key,
    required this.onYes,
    required this.onNo,
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
              'Cancel Session?',
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
                  onPressed: onYes,
                ),
                const SizedBox(width: 12),
                _DialogButton(
                  label: 'No',
                  color: const Color(0xff3d6fa5),
                  onPressed: onNo,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Provide Reason for Cancellation ───────────────────────────────────

class CancelReasonDialog extends StatefulWidget {
  final void Function(String reason) onCancelSession;
  final VoidCallback onDismiss;

  const CancelReasonDialog({
    super.key,
    required this.onCancelSession,
    required this.onDismiss,
  });

  @override
  State<CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<CancelReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Provide Reason for Cancellation',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Reason text field
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'e.g., Schedule conflict',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xff3d6fa5),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cancel Session button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () =>
                    widget.onCancelSession(_reasonController.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 28, 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel Session',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 3: Session Cancelled! ────────────────────────────────────────────────

class SessionCancelledDialog extends StatelessWidget {
  final VoidCallback onOkay;

  const SessionCancelledDialog({super.key, required this.onOkay});

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
              'Session Cancelled!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffe65100),
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

// ── Flow Helper ───────────────────────────────────────────────────────────────

/// Full 3-step cancel flow:
/// Step 1 → Cancel Session? (Yes/No)
/// Step 2 → Provide Reason + Cancel Session button
/// Step 3 → Session Cancelled! (Okay)
void showCancelSessionFlow(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CancelSessionDialog(
      onNo: () => Navigator.pop(context),
      onYes: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => CancelReasonDialog(
            onDismiss: () => Navigator.pop(context),
            onCancelSession: (reason) {
              Navigator.pop(context);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SessionCancelledDialog(
                  onOkay: () => Navigator.pop(context),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
