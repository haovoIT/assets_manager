class SoTheoDoi {
  String? documentID;
  String? Ma_qr;
  String? Ten_ts;
  String? Ma_pb;
  String? Nguyen_gia;
  String? Tg_sd;
  String? Ngay_BD;
  String? Ngay_KT;
  String? Khau_hao;
  String? Ly_do;
  String? Name;
  String? Email;
  String? Thgian;

  SoTheoDoi({
    this.documentID,
    this.Ma_qr,
    this.Ten_ts,
    this.Ma_pb,
    this.Nguyen_gia,
    this.Tg_sd,
    this.Ngay_BD,
    this.Ngay_KT,
    this.Khau_hao,
    this.Ly_do,
    this.Name,
    this.Email,
    this.Thgian,
  });
  factory SoTheoDoi.fromDoc(dynamic doc) => SoTheoDoi(
      documentID: doc.id,
      Ten_ts: doc['Ten_ts'],
      Ma_pb: doc['Ma_pb'],
      Ma_qr: doc['Ma_qr'],
      Nguyen_gia: doc['Nguyen_gia'],
      Tg_sd: doc['Tg_sd'],
      Ngay_BD: doc['Ngay_BD'],
      Ngay_KT: doc['Ngay_KT'],
      Khau_hao: doc['Khau_hao'],
      Ly_do: doc['Ly_do'],
      Name: doc['Name'],
      Email: doc['Email'],
      Thgian: doc['Thgian']);
}
