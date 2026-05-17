/// Represents the estimated delivery time window returned by the backend.
///
/// The client should render [title], [label], and [subtitle] directly
/// without local ETA calculation. Backend text is the source of truth.
class EstimatedDeliveryWindowEntity {
  const EstimatedDeliveryWindowEntity({
    required this.minMinutes,
    required this.maxMinutes,
    required this.title,
    required this.label,
    required this.subtitle,
    required this.confidence,
    required this.source,
    required this.isApproximate,
    this.calculationMode,
    this.explanation,
  });

  final int minMinutes;
  final int maxMinutes;

  /// Section heading shown above the ETA.
  final String title;

  /// Main user-facing delivery-time text.
  final String label;

  /// Helper text shown under the ETA.
  final String subtitle;

  final String confidence;
  final String source;
  final bool isApproximate;

  /// Internal calculation mode used by the backend.
  final String? calculationMode;

  /// Short explanation of why this estimate was produced.
  final String? explanation;
}
