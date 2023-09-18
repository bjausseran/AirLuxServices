library airlux.globals.models.automationvalue;

class AutomationValue {
  AutomationValue({
    required this.id,
    required this.captorId,
    required this.automationId,
    required this.automationvalue,
  });

  int id;
  int captorId;
  int automationId;
  int automationvalue;

  AutomationValue.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        captorId = json['captor_id'],
        automationId = json['automation_id'],
        automationvalue = json['value'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'captor_id': captorId,
        'automation_id': automationId,
        'value': automationvalue
      };
}
