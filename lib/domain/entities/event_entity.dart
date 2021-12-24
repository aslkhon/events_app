import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String name;
  final String referenceUrl;
  final String iconUrl;
  final String date;

  const EventEntity({
    required this.name,
    required this.referenceUrl,
    required this.iconUrl,
    required this.date,
  });

  @override
  List<Object?> get props => [name, referenceUrl, iconUrl, date];
}
