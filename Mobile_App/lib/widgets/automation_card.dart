import 'package:flutter/material.dart';

class AutomationCard extends StatefulWidget {
  final IconData icon;
  final IconData outlinedIcon;
  final String title;
  final String isScheduled;
  final String owner;
  final String? frequency;
  final String pillTextOn;
  final String pillTextOff;
  final bool switchValue;
  final DateTime? startDate;
  final Function(bool) onSwitchChanged;

  const AutomationCard({
    super.key,
    required this.icon,
    required this.outlinedIcon,
    required this.title,
    required this.isScheduled,
    this.startDate,
    this.frequency,
    required this.owner,
    required this.pillTextOn,
    required this.pillTextOff,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  @override
  AutomationCardState createState() => AutomationCardState();
}

class AutomationCardState extends State<AutomationCard> {
  late bool _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.switchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  // widget.icon,
                  _switchValue ? widget.icon : widget.outlinedIcon,
                  size: 40,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: _switchValue ? Colors.teal : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _switchValue ? widget.pillTextOn : widget.pillTextOff,
                    style: TextStyle(
                      color: _switchValue
                          ? Colors.white
                          : Colors.black, // You can change the text color
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: SizedBox(
                          width: 250,
                          child: Text(
                            widget.title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.isScheduled,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.owner,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                    widget.onSwitchChanged(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
