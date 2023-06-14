class Contract {
  String? documentID;
  String? SoHD;
  String? TenHD;
  String? NgayKy;
  String? NHH;
  String? NCC;
  String? ND;

  Contract({
    this.documentID,
    this.SoHD,
    this.TenHD,
    this.NgayKy,
    this.NHH,
    this.NCC,
    this.ND,
});

  factory Contract.fromdoc(dynamic doc) => Contract(
    documentID: doc.id,
    SoHD: doc['SoHD'],
    TenHD: doc['TenHD'],
    NgayKy: doc['NgayKy'],
    NHH: doc['NHH'],
    NCC: doc['NCC'],
    ND: doc['ND']
  );

}