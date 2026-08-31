import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String timeAgo(dynamic date) {
    if (date == null) return '';
    DateTime? dt;
    if (date is DateTime) {
      dt = date;
    } else if (date is String && date.isNotEmpty) {
      dt = DateTime.tryParse(date);
    }
    if (dt == null) return date.toString();

    final now = DateTime.now();
    final difference = now.difference(dt.toLocal());

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM yyyy').format(dt.toLocal());
    }
  }

  static String formatJoinedAgo(dynamic date) {
    if (date == null) return 'Joined recently';
    DateTime? dt;
    if (date is DateTime) {
      dt = date;
    } else if (date is String && date.isNotEmpty) {
      dt = DateTime.tryParse(date);
    }
    if (dt == null) return 'Joined recently';

    final now = DateTime.now();
    final difference = now.difference(dt.toLocal());

    if (difference.inDays < 7) {
      final days = difference.inDays > 0 ? difference.inDays : 1;
      return 'Joined ${days}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Joined ${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Joined ${months}mo ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Joined ${years}y ago';
    }
  }

  static String formatTime(dynamic date) {
    if (date == null) return '';
    DateTime? dt;
    if (date is DateTime) {
      dt = date;
    } else if (date is String && date.isNotEmpty) {
      dt = DateTime.tryParse(date);
    }
    if (dt == null) return date.toString();
    return DateFormat('hh:mm a').format(dt.toLocal());
  }

  static String formatChatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(dateStr).toLocal();
      final DateTime now = DateTime.now();

      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return DateFormat('hh:mm a').format(dateTime);
      } else if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day - 1) {
        return 'Yesterday';
      } else {
        return DateFormat('dd/MM/yy').format(dateTime);
      }
    } catch (_) {
      return dateStr;
    }
  }

  static String formatPostTime(String? dateStr) {
    return timeAgo(dateStr);
  }
}
