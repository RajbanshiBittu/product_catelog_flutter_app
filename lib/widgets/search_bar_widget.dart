import 'package:flutter/material.dart';
import 'dart:async';

/// Search bar widget with debounced search input
/// 
/// Implements 500ms debounce to avoid excessive rebuilds
/// Includes clear button for better UX
class SearchBarWidget extends StatefulWidget {
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<SearchBarWidget> createState() =>
      _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateClearButton);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _updateClearButton() {
    setState(() {});
  }

  void _onSearchChanged(String value) {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Start new timer with 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}