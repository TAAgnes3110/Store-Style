import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({super.key});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int selectedSizeIndex = 0;
  final sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: List.generate(
        sizes.length,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(sizes[index]),
            selected: selectedSizeIndex == index,
            onSelected: (bool isSelected) {
              setState(() {
                selectedSizeIndex = isSelected ? index : selectedSizeIndex;
              });
            },
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: selectedSizeIndex == index
                  ? Colors.white // White for selected state
                  : (isDark ? Colors.white : Colors.black), // Adaptive color for unselected state
            ),
          ),
        ),
      ),
    );
  }
}
