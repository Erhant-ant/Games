import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key, required this.isDesktop});

  final bool isDesktop;

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _eyebrowFade;
  late final Animation<double> _titleFade;
  late final Animation<double> _bodyFade;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _eyebrowSlide;
  late final Animation<Offset> _titleSlide;
  late final Animation<Offset> _bodySlide;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    const slideBegin = Offset(0, 20);
    const slideEnd = Offset.zero;

    _eyebrowFade = _interval(0.0, 0.35);
    _titleFade = _interval(0.12, 0.50);
    _bodyFade = _interval(0.25, 0.65);
    _buttonFade = _interval(0.40, 0.80);

    _eyebrowSlide = _slideInterval(0.0, 0.35, slideBegin, slideEnd);
    _titleSlide = _slideInterval(0.12, 0.50, slideBegin, slideEnd);
    _bodySlide = _slideInterval(0.25, 0.65, slideBegin, slideEnd);
    _buttonSlide = _slideInterval(0.40, 0.80, slideBegin, slideEnd);

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  Animation<double> _interval(double begin, double end) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: Curves.easeOut)),
      );

  Animation<Offset> _slideInterval(double begin, double end, Offset from, Offset to) =>
      Tween<Offset>(begin: from, end: to).animate(
        CurvedAnimation(parent: _controller, curve: Interval(begin, end, curve: Curves.easeOut)),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 1500),
      child: AspectRatio(
        aspectRatio: widget.isDesktop ? 2.2 : 0.9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1528750997573-59b89d56f4f7?auto=format&fit=crop&w=1800&q=85',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFD8D0BA)),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xD9223F2C), Color(0x40223F2C), Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widget.isDesktop ? 80 : 28, vertical: widget.isDesktop ? 58 : 38),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 510,
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AnimatedItem(
                            fade: _eyebrowFade,
                            slide: _eyebrowSlide,
                            child: Text(strings.text('heroEyebrow'), style: const TextStyle(color: Color(0xFFF5DC9C), fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 15),
                          _AnimatedItem(
                            fade: _titleFade,
                            slide: _titleSlide,
                            child: Text(strings.text('heroTitle'), style: TextStyle(color: Colors.white, fontSize: widget.isDesktop ? 48 : 35, height: 1.08, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 15),
                          _AnimatedItem(
                            fade: _bodyFade,
                            slide: _bodySlide,
                            child: Text(strings.text('heroBody'), style: const TextStyle(color: Color(0xFFF9F5EA), fontSize: 16, height: 1.5)),
                          ),
                          const SizedBox(height: 27),
                          _AnimatedItem(
                            fade: _buttonFade,
                            slide: _buttonSlide,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF3E6C4), foregroundColor: AppColors.forest, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17)),
                              child: Text(strings.text('discover')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  const _AnimatedItem({required this.fade, required this.slide, required this.child});

  final Animation<double> fade;
  final Animation<Offset> slide;
  final Widget child;

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: slide.value,
        child: Opacity(opacity: fade.value, child: child),
      );
}

