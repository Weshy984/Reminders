import 'package:mobx/mobx.dart';

part 'reminder.g.dart';

class Reminder = _Reminder with _$Reminder;

abstract class _Reminder with Store{
  final String id;
  final DateTime dateCreated;

  @observable
  String text;

  @observable
  bool isDone;

  _Reminder({
    required this.id,
    required this.text,
    required this.isDone,
    required this.dateCreated,
  });

  @override
  bool operator == (covariant _Reminder other) =>
      id == other.id &&
      text == other.text &&
      isDone == other.isDone &&
      dateCreated == other.dateCreated;

  @override
  int get hashCode => Object.hash(id, text, isDone, dateCreated);
}