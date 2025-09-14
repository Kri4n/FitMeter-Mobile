// duration_helper.dart

class DurationHelper {
  /// Convert hh:mm:ss string to total seconds
  static int parseDuration(String duration) {
    final parts = duration.split(':').map(int.parse).toList();
    if (parts.length == 3) {
      final hours = parts[0];
      final minutes = parts[1];
      final seconds = parts[2];
      return hours * 3600 + minutes * 60 + seconds;
    }
    return 0;
  }

  /// Format seconds back into hh:mm:ss
  static String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }
}
