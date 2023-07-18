class TheaterOwnerModel {
  final String ownerName;
  final String email;
  final String licenseID;
  final String phoneNumber;
  final String location;
  final String adharNumber;
  String adharPhotoPath;
  final String password;
  final String confrimPassword;

  TheaterOwnerModel(
      {required this.ownerName,
      required this.email,
      required this.licenseID,
      required this.phoneNumber,
      required this.location,
      required this.adharNumber,
      required this.adharPhotoPath,
      required this.password,
      required this.confrimPassword});
}
