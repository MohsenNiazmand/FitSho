class MetadataItem {
  const MetadataItem({
    required this.key,
    required this.labelFa,
    required this.labelEn,
    this.icon,
    this.order = 0,
  });

  final String key;
  final String labelFa;
  final String labelEn;
  final String? icon;
  final int order;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MetadataItem &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;
}
