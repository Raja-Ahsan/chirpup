import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/choose_magical_book_view.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/magic_coloring_onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MagicColoringEntryView extends StatefulWidget {
  final String childId;
  final String characterId;
  const MagicColoringEntryView({
    super.key,
    required this.childId,
    required this.characterId,
  });

  @override
  State<MagicColoringEntryView> createState() => _MagicColoringEntryViewState();
}

class _MagicColoringEntryViewState extends State<MagicColoringEntryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagicColoringBloc>().add(
        MagicColoringStarted(widget.childId, widget.characterId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MagicColoringBloc, MagicColoringStates>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return state.hasSeenOnboarding
            ? const ChooseMagicalBookView()
            : const MagicColoringOnboardingView();
      },
    );
  }
}
