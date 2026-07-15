import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_template_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/sketch_coloring_view.dart';
import 'package:flutter/material.dart';

class SketchCard extends StatelessWidget {
  final SketchTemplateModel sketch;

  const SketchCard({super.key, required this.sketch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> SketchColoringView(sketch: sketch))
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffECF3F6),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Center(
              child: Image.asset(sketch.thumbnailUrl, fit: BoxFit.contain),
            ),
          ),

          if (sketch.isLocked)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 27,
                height: 27,
                decoration:  BoxDecoration(
                  color: AppColors.textYellow,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}