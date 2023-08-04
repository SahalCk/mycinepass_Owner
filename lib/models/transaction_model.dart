class MovieBookingModel {
  final String id;
  final String userName;
  final String movieName;
  final String ownerName;
  final String location;
  final String showTime;
  final DateTime date;
  final List<Seat> selectedSeats;
  final String bookingId;
  final int subtotal;
  final num fee;
  final num total;
  final num screen;
  final String status;
  final String language;
  final String image;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  MovieBookingModel({
    required this.id,
    required this.userName,
    required this.movieName,
    required this.ownerName,
    required this.location,
    required this.showTime,
    required this.date,
    required this.selectedSeats,
    required this.bookingId,
    required this.subtotal,
    required this.fee,
    required this.total,
    required this.screen,
    required this.status,
    required this.language,
    required this.image,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MovieBookingModel.fromJson(Map<String, dynamic> json) {
    return MovieBookingModel(
      id: json['_id'],
      userName: json['userName'],
      movieName: json['movieName'],
      ownerName: json['ownerName'],
      location: json['location'],
      showTime: json['showTime'],
      date: DateTime.parse(json['date']),
      selectedSeats: List<Seat>.from(
          json['selectedSeats'].map((seatJson) => Seat.fromJson(seatJson))),
      bookingId: json['bookingId'],
      subtotal: json['subtotal'],
      fee: json['fee'],
      total: json['total'],
      screen: json['screen'],
      status: json['status'],
      language: json['language'],
      image: json['image'],
      paymentStatus: json['paymentstatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Seat {
  final String id;
  final String seatStatus;

  Seat({required this.id, required this.seatStatus});

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      seatStatus: json['seatStatus'],
    );
  }
}
