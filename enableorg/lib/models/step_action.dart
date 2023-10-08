class StepAction {
  String step;
  String description;

  StepAction({
    required this.step,
    required this.description,
  });

  factory StepAction.fromMap(Map<String, dynamic> map) {
    return StepAction(
      step: map['step'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'step': step,
      'description': description,
    };
  }
}
