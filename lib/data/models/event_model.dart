import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/event_entity.dart';

@immutable
class EventModel extends Equatable {
  final String url;
  final String startDate;
  final String endDate;
  final String name;
  final String icon;

  @override
  List<Object> get props {
    return [
      url,
      startDate,
      endDate,
      name,
      icon,
    ];
  }

  const EventModel({
    required this.url,
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.icon,
  });

  EventModel copyWith({
    String? url,
    String? startDate,
    String? endDate,
    String? name,
    String? icon,
  }) {
    return EventModel(
      url: url ?? this.url,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'startDate': startDate,
      'endDate': endDate,
      'name': name,
      'icon': icon,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      url: map['url'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  EventEntity get eventEntiryFromModel => EventEntity(
      name: name,
      referenceUrl: url,
      iconUrl: icon,
      date: '$startDate - $endDate');

  @override
  String toString() {
    return 'EventModel(url: $url, startDate: $startDate, endDate: $endDate, name: $name, icon: $icon)';
  }
}

extension EventEntityAdapter on EventEntity {
  Map<String, dynamic> toMap() => {
        'name': name,
        'referenceUrl': referenceUrl,
        'iconUrl': iconUrl,
        'date': date
      };

  static EventEntity fromMap(Map<String, dynamic> map) => EventEntity(
      name: map['name'],
      referenceUrl: map['referenceUrl'],
      iconUrl: map['iconUrl'],
      date: map['date']);

  static EventEntity fromModel(EventModel model) => EventEntity(
      name: model.name,
      referenceUrl: model.url,
      iconUrl: model.icon,
      date: '${model.startDate} - ${model.endDate}');
}
