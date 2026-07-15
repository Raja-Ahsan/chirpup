import 'dart:typed_data';

import 'package:chirp_up_app/core/constants/app_colors.dart';
import 'package:chirp_up_app/core/constants/app_sizes.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_bloc.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_events.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/bloc/magic_coloring_states.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/config/coloring_capability_config.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/image_utils.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/palette_color_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/data/models/sketch_template_model.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/views/coloring_complete_view.dart';
import 'package:chirp_up_app/features/child/kingdom_workshop/presentation/views/magic_coloring/presentation/widgets/coloring_canvas_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;

class SketchColoringView extends StatefulWidget {
  final SketchTemplateModel sketch;
  const SketchColoringView({super.key, required this.sketch});

  @override
  State<SketchColoringView> createState() => _SketchColoringViewState();
}

class _SketchColoringViewState extends State<SketchColoringView> {
  bool _toolInitialized = false;
  bool _showColorPickerHint = false;

  List<double> _brushSizeDotsFor(double imageWidth) => [
    imageWidth * 0.025,
    imageWidth * 0.040,
    imageWidth * 0.055,
  ];

  List<double> _eraserSizeDotsFor(double imageWidth) => [
    imageWidth * 0.040,
    imageWidth * 0.055,
    imageWidth * 0.070,
  ];

  List<double> _glitterSizeDotsFor(double imageWidth) => [
    imageWidth * 0.028,
    imageWidth * 0.045,
    imageWidth * 0.060,
  ];

  static const Map<ColoringToolMode, Color> _sizeAccentColors = {
    ColoringToolMode.brush: Color(0xff3688E8),
    ColoringToolMode.eraser: Color(0xffFF710B),
    ColoringToolMode.glitterPen: Color(0xff7B6CF4),
  };

  static const List<ColoringToolMode> _toolDisplayOrder = [
    ColoringToolMode.brush,
    ColoringToolMode.bucket,
    ColoringToolMode.glitterPen,
    ColoringToolMode.eraser,
  ];

  static const Map<ColoringToolMode, String> _toolIcons = {
    ColoringToolMode.brush: 'assets/png/paint_brush.png',
    ColoringToolMode.bucket: 'assets/png/paint_bucket.png',
    ColoringToolMode.glitterPen: 'assets/png/glitter_pen.png',
    ColoringToolMode.eraser: 'assets/png/eraser.png',
  };

  static const Map<ColoringToolMode, Color> _toolColors = {
    ColoringToolMode.brush: Color(0xff3688E8),
    ColoringToolMode.bucket: Color(0xff96B85E),
    ColoringToolMode.glitterPen: Color(0xff7B6CF4),
    ColoringToolMode.eraser: Color(0xffFF710B),
  };

  static const Map<ColoringToolMode, Color> _toolBorderColors = {
    ColoringToolMode.brush: Color(0xff0C5FBF),
    ColoringToolMode.bucket: Color(0xff7FAB32),
    ColoringToolMode.glitterPen: Color(0xff5B4EC7),
    ColoringToolMode.eraser: Color(0xffA85920),
  };

  Future<void> _onTickPressed(
    BuildContext context,
    MagicColoringStates state,
  ) async {
    final bloc = context.read<MagicColoringBloc>();

    bloc.add(const ColoringSaveRequested());

    final baked = state.bakedLayer;
    final sketch = state.sketchImage;
    Uint8List? pngBytes;

    if (baked != null && sketch != null) {
      // 👇 naya — bakedLayer (colors) + sketchImage (outline) ko compose karo,
      // taake final image mein colors AUR lines dono aayein
      final composedImage = await _composeColoredImage(baked, sketch);
      pngBytes = await ImageUtils.encodePng(composedImage);
    } else if (baked != null) {
      pngBytes = await ImageUtils.encodePng(baked);
    }

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ColoringCompleteView(coloredImageBytes: pngBytes),
      ),
    );
  }

  Future<ui.Image> _composeColoredImage(ui.Image baked, ui.Image sketch) async {
    final int width = baked.width;
    final int height = baked.height;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );

    canvas.drawImage(
      baked,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.none,
    );
    canvas.drawImage(
      sketch,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.none,
    );

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagicColoringBloc>().add(
        ColoringImageLoaded(
          sketchId: widget.sketch.id,
          assetPath: widget.sketch.assetUrl,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ageGroup = context.select<MagicColoringBloc, AgeGroup>(
      (bloc) => bloc.state.ageGroup,
    );
    final capabilities = ColoringCapabilityConfig.byAgeGroup[ageGroup]!;

    final allowedTools = _toolDisplayOrder
        .where(
          (tool) => capabilities.allowedTools.contains(_mapToConfigTool(tool)),
        )
        .toList();

    final bool showColorPicker = capabilities.allowedTools.contains(
      ColoringToolType.colorPicker,
    );
    final bool showBookmark = capabilities.bookmarkEnabled;

    // 👇 naya — sirf ek tool allowed ho to "single tool mode" (age 1-2 jaisa)
    final bool isSingleToolMode = allowedTools.length <= 1;

    return BlocConsumer<MagicColoringBloc, MagicColoringStates>(
      listenWhen: (p, c) => p.selectedTool != c.selectedTool,
      listener: (context, state) {
        if (!allowedTools.contains(state.selectedTool) &&
            allowedTools.isNotEmpty) {
          context.read<MagicColoringBloc>().add(
            ColoringToolChanged(allowedTools.first),
          );
        }
      },
      builder: (context, state) {
        if (!_toolInitialized &&
            allowedTools.isNotEmpty &&
            !allowedTools.contains(state.selectedTool)) {
          _toolInitialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<MagicColoringBloc>().add(
              ColoringToolChanged(allowedTools.first),
            );
          });
        }

        final palette = state.selectedTool == ColoringToolMode.glitterPen
            ? ColoringPalettes.glitter
            : ColoringPalettes.normal;

        final int totalRegions = state.regionData?.regionCount ?? 0;
        final int coloredRegions = state.regionColors.length;

        final bool isFullyColored =
            totalRegions > 0 && (coloredRegions / totalRegions) >= 0.3;
        debugPrint(
          'regionCount: ${state.regionData?.regionCount}, coloredRegions: ${state.regionColors.length}',
        );

        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/png/magic_coloring_bg.png",
                  fit: BoxFit.cover,
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                    vertical: AppSizes.horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Image.asset(
                              'assets/png/back_button.png',
                              height: 48,
                              width: 48,
                            ),
                          ),
                          const Spacer(),
                          if (showBookmark) ...[
                            Image.asset(
                              'assets/png/bookmark_button_lock.png',
                              width: 46,
                              height: 46,
                            ),
                            const SizedBox(width: 10),
                          ],
                          GestureDetector(
                            onTap: () => context.read<MagicColoringBloc>().add(
                              const ColoringCleared(),
                            ),
                            child: Image.asset(
                              'assets/png/delete_button.png',
                              width: 46,
                              height: 46,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'assets/png/screenshot_button.png',
                            width: 46,
                            height: 46,
                          ),
                          const SizedBox(width: 10),
                          isFullyColored
                              ? InkWell(
                                  onTap: () => _onTickPressed(context, state),
                                  child: Image.asset(
                                    'assets/png/check_button.png',
                                    width: 46,
                                    height: 46,
                                  ),
                                )
                              : Image.asset(
                                  'assets/png/grey_check_button.png',
                                  width: 46,
                                  height: 46,
                                ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ── Drawing canvas (real, region-based) ──
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final regionData = context
                                .watch<MagicColoringBloc>()
                                .state
                                .regionData;
                            if (regionData == null) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final imageAspectRatio =
                                regionData.width / regionData.height;

                            return Center(
                              child: AspectRatio(
                                aspectRatio: imageAspectRatio,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child:
                                        state.canvasStatus ==
                                                ColoringCanvasStatus.ready ||
                                            state.canvasStatus ==
                                                ColoringCanvasStatus.saving
                                        ? const ColoringCanvasWidget()
                                        : state.canvasStatus ==
                                              ColoringCanvasStatus.error
                                        ? Center(
                                            child: Text(
                                              state.canvasErrorMessage ??
                                                  'Error',
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: _buildSizeSelectorFor(
                          state.selectedTool,
                          state.brushSize,
                          state.regionData?.width.toDouble() ?? 400,
                        ),
                      ),

                      // 👇 spacing bhi condition ke sath — tool-row na ho to extra gap na bache
                      if (allowedTools.length > 1) const SizedBox(height: 20),

                      // ── Tool selector — sirf 1 se zyada tool ho tab dikhega ──
                      if (allowedTools.length > 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                height: 47,
                                width: 46.0 * allowedTools.length,
                                decoration: BoxDecoration(
                                  color: AppColors.textYellow,
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final slotWidth =
                                        constraints.maxWidth /
                                        allowedTools.length;
                                    final selectedIndex = allowedTools.indexOf(
                                      state.selectedTool,
                                    );

                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        AnimatedPositioned(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve: Curves.easeInOut,
                                          left: selectedIndex == -1
                                              ? 0
                                              : (slotWidth * selectedIndex) +
                                                    (slotWidth / 2) -
                                                    23,
                                          top: 0,
                                          bottom: 0,
                                          child: Center(
                                            child: Container(
                                              width: 46,
                                              height: 46,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:
                                                      _toolBorderColors[state
                                                          .selectedTool]!,
                                                  width: 2,
                                                ),
                                                color:
                                                    _toolColors[state
                                                        .selectedTool],
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  _toolIcons[state
                                                      .selectedTool]!,
                                                  height: 20,
                                                  width: 18,
                                                  fit: BoxFit.contain,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            allowedTools.length,
                                            (index) {
                                              final tool = allowedTools[index];
                                              final bool isSelected =
                                                  tool == state.selectedTool;
                                              return SizedBox(
                                                width: slotWidth,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    context
                                                        .read<
                                                          MagicColoringBloc
                                                        >()
                                                        .add(
                                                          ColoringToolChanged(
                                                            tool,
                                                          ),
                                                        );
                                                    final imgWidth =
                                                        state.regionData?.width
                                                            .toDouble() ??
                                                        400;
                                                    double defaultSize;
                                                    switch (tool) {
                                                      case ColoringToolMode
                                                          .brush:
                                                        defaultSize =
                                                            imgWidth * 0.025;
                                                        break;
                                                      case ColoringToolMode
                                                          .eraser:
                                                        defaultSize =
                                                            imgWidth * 0.035;
                                                        break;
                                                      case ColoringToolMode
                                                          .glitterPen:
                                                        defaultSize =
                                                            imgWidth * 0.028;
                                                        break;
                                                      case ColoringToolMode
                                                          .bucket:
                                                        return;
                                                    }
                                                    context
                                                        .read<
                                                          MagicColoringBloc
                                                        >()
                                                        .add(
                                                          ColoringBrushSizeChanged(
                                                            defaultSize,
                                                          ),
                                                        );
                                                  },
                                                  child: Center(
                                                    child: AnimatedOpacity(
                                                      duration: const Duration(
                                                        milliseconds: 250,
                                                      ),
                                                      opacity: isSelected
                                                          ? 0
                                                          : 1,
                                                      child: Image.asset(
                                                        _toolIcons[tool]!,
                                                        height: 20,
                                                        width: 18,
                                                        fit: BoxFit.contain,
                                                        color: const Color(
                                                          0xff4D4A51,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            if (showColorPicker)
                              GestureDetector(
                                onTap: () {
                                  context.read<MagicColoringBloc>().add(
                                    const ColoringColorPickerToggled(),
                                  );
                                  if (!state.isColorPickerActive) {
                                    setState(() => _showColorPickerHint = true);
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        if (mounted) {
                                          setState(
                                            () => _showColorPickerHint = false,
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                                child: Image.asset(
                                  state.isColorPickerActive
                                      ? 'assets/png/color_picker_enable_button.png'
                                      : 'assets/png/color_picker_disable_button.png',
                                  width: 43,
                                  height: 43,
                                ),
                              ),
                          ],
                        ),

                      SizedBox(height: isSingleToolMode ? 15 : 25),

                      // ── Color palette (single-tool mode mein bade circles) ──
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: palette.map((p) {
                            final bool isSelected = state.selectedPalette == p;

                            // 👇 naya — single-tool mode (age 1-2) mein circles bade
                            final double circleWidth = isSingleToolMode
                                ? 55.0
                                : 47.73;
                            final double circleHeight = isSingleToolMode
                                ? 57.0
                                : 57.73;

                            return GestureDetector(
                              onTap: () => context
                                  .read<MagicColoringBloc>()
                                  .add(ColoringColorSelected(p)),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: isSingleToolMode ? 8 : 4,
                                ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: circleWidth,
                                  height: circleHeight,
                                  decoration: BoxDecoration(
                                    color: p.isGlitter ? null : p.color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: isSingleToolMode ? 3 : 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: p.color.withValues(
                                                alpha: 0.5,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      if (!p.isGlitter ||
                                          state.glitterTexture == null) {
                                        return const SizedBox.shrink();
                                      }
                                      return Center(
                                        child: SizedBox(
                                          width: circleWidth,
                                          height: 43,
                                          child: ClipOval(
                                            child: CustomPaint(
                                              size: Size(
                                                circleWidth,
                                                circleWidth,
                                              ),
                                              painter: _GlitterSwatchPainter(
                                                color: p.color,
                                                glitterTexture:
                                                    state.glitterTexture!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showColorPickerHint)
                Positioned(
                  right: 10,
                  bottom: 210,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showColorPickerHint ? 1.0 : 0.0,
                    child: Image.asset(
                      'assets/png/coloring_instruction_dialog.png',
                      width: 130,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  ColoringToolType _mapToConfigTool(ColoringToolMode mode) {
    switch (mode) {
      case ColoringToolMode.brush:
        return ColoringToolType.brush;
      case ColoringToolMode.bucket:
        return ColoringToolType.bucket;
      case ColoringToolMode.glitterPen:
        return ColoringToolType.glitterPen;
      case ColoringToolMode.eraser:
        return ColoringToolType.eraser;
    }
  }

  Widget _buildSizeSelectorFor(
    ColoringToolMode tool,
    double currentSize,
    double imageWidth,
  ) {
    List<double> actualSizes;
    switch (tool) {
      case ColoringToolMode.brush:
        actualSizes = _brushSizeDotsFor(imageWidth);
        break;
      case ColoringToolMode.eraser:
        actualSizes = _eraserSizeDotsFor(imageWidth);
        break;
      case ColoringToolMode.glitterPen:
        actualSizes = _glitterSizeDotsFor(imageWidth);
        break;
      case ColoringToolMode.bucket:
        return const SizedBox(key: ValueKey('size_empty'), height: 0);
    }

    final Color accent = _sizeAccentColors[tool] ?? const Color(0xff7B6CF4);

    const List<double> previewDotSizes = [14, 20, 26];

    return Container(
      key: ValueKey('size_row_$tool'),
      decoration: BoxDecoration(
        color: const Color(0xffD9F4FF),
        borderRadius: BorderRadius.circular(39),
      ),
      width: 140,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(actualSizes.length, (index) {
          final double actualSize = actualSizes[index];
          final double previewSize = previewDotSizes[index];
          final bool isSelected = currentSize == actualSize;

          return GestureDetector(
            onTap: () => context.read<MagicColoringBloc>().add(
              ColoringBrushSizeChanged(actualSize),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: previewSize,
              height: previewSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 1,
                ),
                shape: BoxShape.circle,
                color: isSelected ? accent : accent.withValues(alpha: 0.4),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _GlitterSwatchPainter extends CustomPainter {
  final Color color;
  final ui.Image glitterTexture;

  _GlitterSwatchPainter({required this.color, required this.glitterTexture});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(rect, Paint()..color = color);

    final shader = ui.ImageShader(
      glitterTexture,
      TileMode.repeated,
      TileMode.repeated,
      Matrix4.identity().storage,
    );
    canvas.drawRect(
      rect,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.screen,
    );
  }

  @override
  bool shouldRepaint(covariant _GlitterSwatchPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.glitterTexture != glitterTexture;
  }
}
