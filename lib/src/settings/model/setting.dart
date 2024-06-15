import 'package:hive/hive.dart';

part 'setting.g.dart';

@HiveType(typeId: 10)
class Setting extends HiveObject {
  @HiveField(0)
  final bool isDarkMode;

  Setting({
    required this.isDarkMode,
  });

  Setting copyWith({
    bool? isDarkMode,
  }) {
    return Setting(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  static const boxName = 'setting';
}
