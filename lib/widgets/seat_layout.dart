import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SeatLayout extends StatelessWidget {
  final int rows;
  final int columns;
  final List<int> bookedSeats;
  final Set<int> selectedSeats;
  final Function(int) onSeatSelected;

  SeatLayout({
    required this.rows,
    required this.columns,
    required this.bookedSeats,
    required this.selectedSeats,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: rows * columns,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final seatNumber = index + 1;
        final bool isBooked = bookedSeats.contains(seatNumber);
        final bool isSelected = selectedSeats.contains(seatNumber);

        return GestureDetector(
          onTap: isBooked ? null : () => onSeatSelected(seatNumber),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isBooked
                  ? Constants.textSecondaryColor
                  : isSelected
                      ? Constants.primaryColor
                      : Constants.surfaceColor,
              borderRadius: BorderRadius.circular(Constants.borderRadius),
              border: Border.all(
                color: isBooked
                    ? Constants.textSecondaryColor
                    : isSelected
                        ? Constants.primaryColor
                        : Constants.textSecondaryColor,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Constants.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$seatNumber',
                style: TextStyle(
                  color: isSelected
                      ? Constants.textColor
                      : isBooked
                          ? Constants.textSecondaryColor
                          : Constants.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
