import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class HeartRatingBar extends StatelessWidget {
  final Function  onRatingUpdate;
  final bool      ignoreGestures;
  final double    initialRating;
  final double    itemSize;

  HeartRatingBar({
    @required this.initialRating,
              this.itemSize = 15,
              this.ignoreGestures = false,
              this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      itemCount: 5,
      itemSize: itemSize,
      initialRating: initialRating,
      ignoreGestures: ignoreGestures,
      allowHalfRating: true,
      direction: Axis.horizontal,
      itemPadding: EdgeInsets.all(2),
      ratingWidget: RatingWidget(
        full: Image.asset(
          'assets/icons/rating/heart.png',
          color: Theme.of(context).primaryColor,
        ),
        half: Image.asset(
          'assets/icons/rating/heart_half.png',
          color: Theme.of(context).primaryColor,
        ),
        empty: Image.asset(
          'assets/icons/rating/heart_border.png',
          color: Theme.of(context).primaryColor,
        ),
      ),
      onRatingUpdate: onRatingUpdate,
    );
  }
}