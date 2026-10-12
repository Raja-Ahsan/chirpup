import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/widgets/common_button.dart';
import 'package:chirp_up_app/core/widgets/custom_text.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/melody_mixer/data/models/reflaction_tag_model.dart';
import 'package:flutter/material.dart';

class MelodyReflectView extends StatefulWidget {
  final String backgroundAsset;
  final List<ReflectionTag> tags;
  final void Function(String tagId, String note) onSave;

  const MelodyReflectView({
    super.key,
    required this.backgroundAsset,
    required this.tags,
    required this.onSave,
  });

  @override
  State<MelodyReflectView> createState() => _MelodyReflectViewState();
}

class _MelodyReflectViewState extends State<MelodyReflectView> {
  String? _selectedTag;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true, // keyboard pe adjust
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(widget.backgroundAsset, fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 15),

                // title
                HeadingText(
                  text: 'Reflect on\nYour Creation',
                  fontSize: 28,
                  color: AppColors.textYellow,
                  shadowColor: Colors.black,
                  textAlign: TextAlign.center,
                  lineSpacing: 0,
                ),
                SizedBox(height: 15),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            HeadingText(
                              text: 'What inspired your melody?',
                              fontSize: 20,
                              color: Colors.white,
                              shadowColor: Colors.transparent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // tag cards — select pe glow
                        ...widget.tags.map((t) {
                          final isSelected = t.id == _selectedTag;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTag = t.id),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                scale: isSelected ? 1.02 : 1.0,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      t.imageAsset,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                    // selected glow border
                                    if (isSelected)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                blurRadius: 16,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 16),

                        // free text prompt
                        Row(
                          children: [
                            SizedBox(width: 10),
                            CustomText(
                              text: 'How does your melody make you feel?',
                              fontSize: 16,
                              weight: FontWeight.w700,
                              color: Color(0xFF99BBE1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // custom text field
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F6EC),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 4,
                            style: const TextStyle(
                              color: Color(0xFF858789),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Nunito',
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Write anything you want to share...',
                              hintStyle: TextStyle(
                                color: Color(0xFF858789),
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // save button
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 8, 15,10),
                  child: CommonButton(
                    title: 'Save My Reflection',
                    bgColor: AppColors.greenColor,
                    onPressed: _selectedTag == null
                        ? null // tag chune bina disabled
                        : () => widget.onSave(
                            _selectedTag!,
                            _controller.text.trim(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
