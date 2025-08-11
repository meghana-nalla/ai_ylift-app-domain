import 'package:flutter/material.dart';

class Activity {
  final String time;
  final String description;

  const Activity(this.time, this.description);
}

class EventRundown extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? description;
  final List<Activity> activities;

  const EventRundown({
    super.key,
    this.leading = const Icon(Icons.calendar_today, color: Colors.white),
    required this.title,
    this.description,
    this.activities = const <Activity>[],
  });

  static const _radius = Radius.circular(16);
  static const _borderSide = BorderSide(color: Colors.black, width: 2);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Title
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(topLeft: _radius, topRight: _radius),
            ),
            width: double.infinity,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 16,
                  child: leading,
                ),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))
              ],
            ),
          ),

          // Rundown
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: _radius,
                bottomRight: _radius,
              ),
              border: Border(left: _borderSide, right: _borderSide, bottom: _borderSide),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                if (description != null) ...[
                  Text(description!, textAlign: TextAlign.center),
                  const Divider(height: 40),
                ],
                for (final activity in activities)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(activity.time),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Text(activity.description),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
