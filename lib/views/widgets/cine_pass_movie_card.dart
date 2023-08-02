// ignore_for_file: prefer_const_constructors

import 'package:cinepass_owner/utils/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CinePassMovieCard extends StatelessWidget {
  final int index;
  final String screenID;
  final String screenNumber;
  final String movieName;
  final String showTime;
  final String startDate;
  final String endDate;

  final String ticketPrice;
  const CinePassMovieCard(
      {super.key,
      required this.index,
      required this.screenID,
      required this.movieName,
      required this.screenNumber,
      required this.showTime,
      required this.startDate,
      required this.endDate,
      required this.ticketPrice});

  @override
  Widget build(BuildContext context) {
    List<String> backGroundImages = [
      'assets/card_background/bg1.jpg',
      'assets/card_background/bg2.jpg',
      'assets/card_background/bg3.jpg',
      'assets/card_background/bg4.jpg'
    ];
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Adaptive.h(1.3), horizontal: Adaptive.w(3)),
      width: Adaptive.w(100),
      height: Adaptive.h(26),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(84, 168, 229, 0.1),
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
              fit: BoxFit.fill,
              opacity: 0.08,
              image: AssetImage(
                  backGroundImages[index % backGroundImages.length.round()]))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen Number : $screenNumber',
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            width: Adaptive.w(95),
            child: Text('Movie Name : $movieName',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
          Text('Show Time : $showTime',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('Start Date : $startDate',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('End Date : $endDate',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text('Ticket Price : ₹$ticketPrice',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          sizedBoxHeight15,
          Row(
            children: [
              SizedBox(
                width: Adaptive.w(18),
                height: Adaptive.h(3.5),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              SizedBox(
                width: Adaptive.w(2.5),
              ),
              SizedBox(
                width: Adaptive.w(18),
                height: Adaptive.h(3.5),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7))),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
