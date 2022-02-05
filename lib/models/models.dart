class NepseShareDataModel {
  String companyName;
  // String scrip;
  var closingPrice;

  NepseShareDataModel({
    this.companyName,
    // this.scrip,
    this.closingPrice,
  });

  factory NepseShareDataModel.fromJson(Map<String, dynamic> json) =>
      NepseShareDataModel(
        companyName: json['companyName'],
        // scrip: json['symbol'],
        closingPrice: json['closingPrice'],
      );

  Map<String, dynamic> toJson() => {
        "companyName": companyName,
        // "symbol": scrip,
        "closingPrice": closingPrice,
      };
}
