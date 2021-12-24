import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EventButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.0,
      width: 108.0,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              'see more',
              style: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}
