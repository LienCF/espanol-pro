import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/speech_evaluation_controller.dart';

class RecordingWidget extends ConsumerWidget {
  final String referenceText;
  final String id; // Unique ID for this recording session (e.g., drill item index)
  final String lessonId;

  const RecordingWidget({
    super.key, 
    required this.referenceText,
    required this.id,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the specific controller family member for this item
    final state = ref.watch(speechEvaluationControllerProvider(id));
    final controller = ref.read(speechEvaluationControllerProvider(id).notifier);

    return Column(
      children: [
        _buildActionButton(context, state, controller),
        // Only show status if NOT in initial state
        if (state != const SpeechEvaluationState.initial()) 
          _buildStatusMessage(context, state),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, 
    SpeechEvaluationState state, 
    SpeechEvaluationController controller
  ) {
    return state.when(
      initial: () => IconButton(
        onPressed: controller.startRecording,
        icon: const Icon(Icons.mic),
        tooltip: 'Start Recording',
        color: Theme.of(context).primaryColor,
      ),
      recording: () => IconButton(
        onPressed: () => controller.stopRecordingAndEvaluate(referenceText, lessonId),
        icon: const Icon(Icons.stop_circle),
        tooltip: 'Stop & Evaluate',
        color: Colors.red,
        iconSize: 32,
      ),
      processing: () => const SizedBox(
        width: 24, 
        height: 24, 
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      success: (result) => IconButton(
        onPressed: controller.reset, // Reset to try again
        icon: const Icon(Icons.refresh),
        tooltip: 'Try Again',
        color: Colors.green,
      ),
      error: (_) => IconButton(
        onPressed: controller.reset,
        icon: const Icon(Icons.refresh),
        color: Colors.red,
      ),
    );
  }

  Widget _buildStatusMessage(BuildContext context, SpeechEvaluationState state) {
    return state.maybeWhen(
      success: (result) => Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Column(
          children: [
            Text(
              'Score: ${result.score}',
              style: TextStyle(
                color: result.isMatch ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (result.feedback.isNotEmpty)
              Text(
                result.feedback.join('\n'),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      error: (msg) => Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          'Error', // Short text to not break layout, full error in tooltip or console?
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
      recording: () => const Text('Recording...', style: TextStyle(fontSize: 10, color: Colors.red)),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
