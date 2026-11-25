/// UI-facing contract for demonstrating repository failures.
///
/// Screens depend on this abstraction, not on mock repository classes.
abstract interface class NetworkFailureController {
  bool get enabled;
  void setEnabled(bool value);
}
