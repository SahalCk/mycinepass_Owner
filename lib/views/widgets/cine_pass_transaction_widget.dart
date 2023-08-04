import 'dart:developer';
import 'package:cinepass_owner/models/transaction_model.dart';
import 'package:cinepass_owner/utils/colors.dart';
import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassBookingCard extends StatelessWidget {
  final MovieBookingModel movieBookingModel;
  const CinePassBookingCard({
    super.key,
    required this.movieBookingModel,
  });

  @override
  Widget build(BuildContext context) {
    log(movieBookingModel.selectedSeats[0].id);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding: EdgeInsets.all(Adaptive.h(2)),
              backgroundColor: backgroundColor,
              children: [
                Text(movieBookingModel.movieName,
                    style: TextStyle(color: Colors.blue[700], fontSize: 19)),
                Text(movieBookingModel.userName,
                    style: TextStyle(color: Colors.blue[700], fontSize: 19)),
                sizedBoxHeight10,
                const Text('---------------------------',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                sizedBoxHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Theater Name :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.ownerName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Screen :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.screen.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ticket Quantity :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.selectedSeats.length.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Seats :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(getSeatNumbers(movieBookingModel.selectedSeats),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.date.toString().substring(0, 10),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Time :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.date.toString().substring(10, 19),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('booking ID :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text(movieBookingModel.bookingId,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sub Total :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('₹${movieBookingModel.subtotal.toString()}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Convenience fees :',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('₹${movieBookingModel.fee.toString()}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16))
                  ],
                ),
                sizedBoxHeight20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total :',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Text('₹${movieBookingModel.subtotal.toString()}',
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                sizedBoxHeight20
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(Adaptive.h(1.3)),
        height: Adaptive.h(14.38),
        width: Adaptive.w(100),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(84, 168, 229, 0.1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(movieBookingModel.userName,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                getStatus(movieBookingModel.status)
              ],
            ),
            Text(movieBookingModel.movieName,
                style: const TextStyle(color: Colors.red, fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Screen ${movieBookingModel.screen.toString()}',
                    style: const TextStyle(color: Colors.amber, fontSize: 16)),
                Text(movieBookingModel.date.toString().substring(0, 10),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                        fontSize: 14)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(movieBookingModel.bookingId,
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
                Text(movieBookingModel.date.toString().substring(10, 16),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 221, 221, 221),
                        fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getStatus(String status) {
    if (status == 'Booked') {
      return Row(
        children: [
          const Icon(Icons.radio_button_on_sharp,
              color: Colors.green, size: 12.5),
          SizedBox(width: Adaptive.w(1)),
          const Text(
            'Booked',
            style: TextStyle(color: Colors.green, fontSize: 15.2),
          )
        ],
      );
    } else {
      return Row(
        children: [
          const Icon(Icons.radio_button_on_sharp,
              color: Colors.red, size: 12.5),
          SizedBox(width: Adaptive.w(1)),
          const Text(
            'Canceled',
            style: TextStyle(color: Colors.red, fontSize: 15.2),
          )
        ],
      );
    }
  }

  String getSeatNumbers(List<Seat> seatsList) {
    String seats = '';
    for (Seat seat in seatsList) {
      seats = '$seats,${seat.id}';
    }
    return seats.substring(1);
  }
}
