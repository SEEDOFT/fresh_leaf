import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  const RatingStarsWidget({
    required this.rating,
    this.size = 14,
    this.color,
    this.count,
    super.key,
  });

  final double rating;
  final double size;
  final Color? color;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? Colors.amber;
    final stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating.ceil();
        return Icon(
          filled
              ? Icons.star
              : half
              ? Icons.star_half
              : Icons.star_border,
          size: size,
          color: starColor,
        );
      }),
    );

    if (count != null && count! > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          stars,
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size * 0.85,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    return stars;
  }
}

class InteractiveRatingStars extends StatefulWidget {
  const InteractiveRatingStars({
    required this.onChanged,
    this.initialRating = 0,
    this.size = 36,
    super.key,
  });

  final ValueChanged<int> onChanged;
  final int initialRating;
  final double size;

  @override
  State<InteractiveRatingStars> createState() => _InteractiveRatingStarsState();
}

class _InteractiveRatingStarsState extends State<InteractiveRatingStars> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        return GestureDetector(
          onTap: () {
            setState(() => _rating = starIndex);
            widget.onChanged(starIndex);
          },
          child: Icon(
            starIndex <= _rating ? Icons.star : Icons.star_border,
            size: widget.size,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}
