import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class PerformanceUtils {
  /// Throttles function calls to improve performance
  static Function throttle(Function func, Duration delay) {
    bool isThrottled = false;
    
    return ([List<dynamic>? positionalArguments, Map<Symbol, dynamic>? namedArguments]) {
      if (!isThrottled) {
        Function.apply(func, positionalArguments, namedArguments);
        isThrottled = true;
        
        Future.delayed(delay, () {
          isThrottled = false;
        });
      }
    };
  }

  /// Debounces function calls
  static Function debounce(Function func, Duration delay) {
    Timer? timer;
    
    return ([List<dynamic>? positionalArguments, Map<Symbol, dynamic>? namedArguments]) {
      timer?.cancel();
      timer = Timer(delay, () {
        Function.apply(func, positionalArguments, namedArguments);
      });
    };
  }
}

/// A widget that only rebuilds when visible in viewport
class LazyLoadWidget extends StatefulWidget {
  final Widget child;
  final double threshold;
  final Widget? placeholder;
  
  const LazyLoadWidget({
    super.key,
    required this.child,
    this.threshold = 0.1,
    this.placeholder,
  });

  @override
  State<LazyLoadWidget> createState() => _LazyLoadWidgetState();
}

class _LazyLoadWidgetState extends State<LazyLoadWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > widget.threshold && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible 
          ? widget.child 
          : widget.placeholder ?? const SizedBox.shrink(),
    );
  }
}

/// Simple visibility detector
class VisibilityDetector extends StatefulWidget {
  @override
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;
  
  const VisibilityDetector({
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: widget.child,
    );
  }

  void _checkVisibility() {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      
      double visibleHeight = 0;
      if (position.dy < screenHeight && position.dy + size.height > 0) {
        final topVisible = math.max(0.0, -position.dy);
        final bottomVisible = math.min(size.height, screenHeight - position.dy);
        visibleHeight = bottomVisible - topVisible;
      }
      
      final visibleFraction = size.height > 0 ? visibleHeight / size.height : 0;
      widget.onVisibilityChanged(VisibilityInfo(visibleFraction: visibleFraction.toDouble()));
    }
  }
}

class VisibilityInfo {
  final double visibleFraction;
  
  VisibilityInfo({required this.visibleFraction});
}

