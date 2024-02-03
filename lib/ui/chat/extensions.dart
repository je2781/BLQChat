import './filters.dart';

extension MessageExtension on Messages {
  String toNameString() {
    return toString().split('.').last.replaceAll('_', ' ');
  }
}
