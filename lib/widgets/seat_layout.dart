import 'package:flutter/material.dart';

class SeatLayout extends StatelessWidget {
  final int rows;
  final int columns;
  final List<int> bookedSeats;
  final Function(int) onSeatSelected;

  SeatLayout({
    required this.rows,
    required this.columns,
    required this.bookedSeats,
    required this.onSeatSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: rows * columns,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) {
        bool isBooked = bookedSeats.contains(index);
        return GestureDetector(
          onTap: isBooked ? null : () => onSeatSelected(index),
          child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isBooked ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
