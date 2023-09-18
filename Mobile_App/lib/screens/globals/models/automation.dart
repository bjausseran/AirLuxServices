library airlux.globals.models.automation;

enum Frequency { hour, day, week, month }

class Automation {
  Automation({
    required this.id,
    required this.name,
    required this.userId,
    required this.isScheduled,
    required this.frequency,
    required this.startDate,
  });

  int id;
  String name;
  int userId;
  late bool isScheduled;
  Frequency? frequency;
  DateTime? startDate;
  late bool enabled;

  Automation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        userId = json['user_id'] {
    switch (json['frequency']) {
      case 'hour':
        frequency = Frequency.hour;
        break;
      case 'day':
        frequency = Frequency.day;
        break;
      case 'week':
        frequency = Frequency.week;
        break;
      case 'month':
        frequency = Frequency.month;
        break;
      default:
        frequency = null;
    }

    isScheduled = json['is_scheduled'] == 0 ? false : true;
    enabled = json['enabled'] == 0 ? false : true;
    startDate =
        json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user_id': userId,
        'is_scheduled': isScheduled,
        'enabled': enabled,
        'frequency': frequency.toString(),
        'start_date': startDate
      };
}
