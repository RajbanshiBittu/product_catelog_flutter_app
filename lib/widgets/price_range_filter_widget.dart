import 'package:flutter/material.dart';

/// Price range filter widget with RangeSlider
/// 
/// Allows users to filter products by price range.
/// Displays current price range and provides interactive slider.
class PriceRangeFilterWidget extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double currentMin;
  final double currentMax;
  final Function(double, double) onChanged;

  const PriceRangeFilterWidget({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.currentMin,
    required this.currentMax,
    required this.onChanged,
  });

  @override
  State<PriceRangeFilterWidget> createState() =>
      _PriceRangeFilterWidgetState();
}

class _PriceRangeFilterWidgetState extends State<PriceRangeFilterWidget> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.currentMin, widget.currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Range',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_currentRange.start.toStringAsFixed(0)} - \$${_currentRange.end.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
          ),
          RangeSlider(
            values: _currentRange,
            min: widget.minPrice,
            max: widget.maxPrice,
            onChanged: (RangeValues values) {
              setState(() {
                _currentRange = values;
              });
              widget.onChanged(values.start, values.end);
            },
            divisions: ((widget.maxPrice - widget.minPrice) ~/ 10).clamp(1, 100),
            labels: RangeLabels(
              '\$${_currentRange.start.toStringAsFixed(0)}',
              '\$${_currentRange.end.toStringAsFixed(0)}',
            ),
          ),
        ],
      ),
    );
  }
}
