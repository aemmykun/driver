import 'package:intl/intl.dart';

final _aud = NumberFormat.currency(locale: 'en_AU', symbol: r'$');

String aud(int cents) => _aud.format(cents / 100);

String shortDate(DateTime value) => DateFormat('d MMM yyyy').format(value.toLocal());
