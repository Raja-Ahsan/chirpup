
import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/routes/app_routes.dart';
import 'package:chirp_up_app/core/widgets/heading_text.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_model.dart';
import 'package:flutter/material.dart';

class SketchCard extends StatelessWidget {
  final SketchItem sketch;

  const SketchCard({required this.sketch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.pushReplacementNamed(context, AppRoutes.sketchColoring),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffECF3F6),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Center(
              child: Image.asset(sketch.imagePath, fit: BoxFit.contain),
            ),
          ),
      
          if (sketch.isLocked && sketch.lockNumber != null)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: AppColors.textYellow,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: HeadingText(
                    text: '${sketch.lockNumber}',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
