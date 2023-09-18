import 'dart:async';

import 'package:airlux/screens/globals/models/automation.dart';
import 'package:airlux/widgets/automation_card.dart';
import 'package:airlux/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'globals/models/user.dart';
import 'globals/user_context.dart' as user_context;
import 'package:intl/intl.dart';

class AutomationsScreen extends StatefulWidget {
  AutomationsScreen({super.key});

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://${user_context.serverIP}:6001'));

  @override
  State<StatefulWidget> createState() => AutomationsScreenState();
}

class AutomationsScreenState extends State<AutomationsScreen> {
  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    List<AutomationCard> cards = List.empty(growable: true);
    final f = DateFormat('dd/MM/yyyy hh:mm');
    final insertf = DateFormat('yyyy-MM-dd hh:mm:ss');
    for (int i = 0; i < user_context.automations.length; i++) {
      Automation automation = user_context.automations[i];
      User user = user_context.users
          .firstWhere((element) => element.id == automation.userId);
      cards.add(AutomationCard(
        icon: Icons.auto_mode,
        outlinedIcon: Icons.auto_mode_outlined,
        title: automation.name,
        startDate: automation.startDate,
        owner: user.name,
        frequency: automation.frequency.toString(),
        pillTextOn: automation.isScheduled ? "Activé" : "En Cours",
        pillTextOff: automation.isScheduled ? "Désactivé" : "Disponible",
        switchValue: automation.enabled,
        onSwitchChanged: (bool) {
          var linkedValue = user_context.automationValues
              .where((element) => element.automationId == automation.id)
              .toList();
          // Envoyer les valeurs ici si bool = true
          if (automation.isScheduled) {
            widget.webSocketChannel.sink.add(
              'tocloud//automations//{"id": ${automation.id}, "name": "${automation.name}", "user_id": ${automation.userId}, "start_date": "${automation.startDate != null ? insertf.format(automation.startDate as DateTime) : "null"}", "frequency": "${automation.frequency == null ? "null" : automation.frequency.toString().split('.')[1]}", "enabled": ${bool ? 1 : 0}, "is_scheduled": ${automation.isScheduled ? 1 : 0}}//update',
            );
          } else {
            widget.webSocketChannel.sink.add(
              'tocloud//automations//{"id": ${automation.id}, "name": "${automation.name}", "user_id": ${automation.userId}, "start_date": "${automation.startDate != null ? insertf.format(automation.startDate as DateTime) : "null"}", "frequency": "${automation.frequency == null ? "null" : automation.frequency.toString().split('.')[1]}", "enabled": ${bool ? 1 : 0}, "is_scheduled": ${automation.isScheduled ? 1 : 0}}//update',
            );
            for (int i = 0; i < linkedValue.length; i++) {
              widget.webSocketChannel.sink.add(
                  'tocloud//captor_values//{"captor_id":"${linkedValue[i].captorId}", "value": "${bool ? linkedValue[i].automationvalue : linkedValue[i].automationvalue == 0 ? 1 : 0}"}//insert');
            }
          }
        },
        isScheduled: automation.isScheduled
            ? 'Programmée - ${automation.frequency.toString().split('.').last} - ${automation.startDate != null ? f.format(automation.startDate as DateTime) : 'Non programmée'}'
            : 'Instantanée',
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Automatisations'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cards,
          ),
        ),
      ),
    );
  }
}
