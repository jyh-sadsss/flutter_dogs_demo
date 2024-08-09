import 'package:flutter/material.dart';

class TipsDialog extends StatelessWidget {
  final String content;
  const TipsDialog({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 200,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Center(
              child: Text(content),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
