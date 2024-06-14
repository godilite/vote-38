import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const AttachmentButton({
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: context.moonColors!.bulma),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          color: context.moonColors!.bulma,
          size: 15,
        ),
      ),
    );
  }
}
