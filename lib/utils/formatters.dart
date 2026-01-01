import 'package:intl/intl.dart';

final _dt = DateFormat('yyyy-MM-dd HH:mm');

String fmtDateTime(DateTime dt) {
  final local = dt.toLocal();
  return _dt.format(local);
}
