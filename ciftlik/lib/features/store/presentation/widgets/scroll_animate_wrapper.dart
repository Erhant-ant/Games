import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A wrapper that animates its child with a fade-in + slide-up effect
/// when it first becomes visible in the viewport.
class ScrollAnimateWrapper extends StatefulWidget {
  const ScrollAnimateWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.slideOffset = 40.0,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;

  @override
  State<ScrollAnimateWrapper> createState() => _ScrollAnimateWrapperState();
}

class _ScrollAnimateWrapperState extends State<ScrollAnimateWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(curve);

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (_hasAnimated || !mounted) return;

    if (_scrollPosition == null) {
      final scrollable = Scrollable.maybeOf(context);
      try {
        if (scrollable != null) {
          _scrollPosition = scrollable.position;
          _scrollPosition?.addListener(_checkVisibility);
        }
      } catch (_) {}
    }

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final viewport = RenderAbstractViewport.maybeOf(renderBox);
    if (viewport == null) {
      _triggerAnimation();
      return;
    }

    try {
      final revealOffset = viewport.getOffsetToReveal(renderBox, 0.0).offset;
      final scrollPixels = _scrollPosition?.pixels ?? 0.0;
      final viewportDimension = _scrollPosition?.viewportDimension ?? 1000.0;

      // Widget top is within the visible area
      if (revealOffset < scrollPixels + viewportDimension + 50) {
        _triggerAnimation();
      }
    } catch (_) {}
  }

  void _triggerAnimation() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    _scrollPosition?.removeListener(_checkVisibility);
    
    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Disable animation on mobile to prevent viewport white screen bug
    if (MediaQuery.sizeOf(context).width < 900) {
      return widget.child;
    }
    
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) => Transform.translate(
        offset: _slideAnimation.value,
        child: Opacity(
          opacity: _fadeAnimation.value,
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
