class LichSuSuDung {
  String? documentID;
  String? Ten_ts;
  String? Ten_pb;
  String? Nam_sx;
  String? Nuoc_sx;
  String? Ma_nts;
  String? Ma_tinh_trang;
  String? Nguyen_gia;
  String? Tg_sd;
  String? So_luong;
  String? So_hd;
  String? Mdsd;
  String? Ma_qr;
  String? Name;
  String? Email;
  String? Thgian;

  LichSuSuDung({
    this.documentID,
    this.Ten_ts,
    this.Ten_pb,
    this.Nam_sx,
    this.Nuoc_sx,
    this.Ma_nts,
    this.Ma_tinh_trang,
    this.Nguyen_gia,
    this.Tg_sd,
    this.So_luong,
    this.So_hd,
    this.Mdsd,
    this.Ma_qr,
    this.Name,
    this.Email,
    this.Thgian,
  });
  factory LichSuSuDung.fromDoc(dynamic doc) => LichSuSuDung(
      documentID: doc.id,
      Ten_ts: doc['Ten_ts'],
      Ten_pb: doc['Ten_pb'],
      Nam_sx: doc['Nam_sx'],
      Nuoc_sx: doc['Nuoc_sx'],
      Ma_nts: doc['Ma_nts'],
      Ma_tinh_trang: doc['Ma_tinh_trang'],
      Nguyen_gia: doc['Nguyen_gia'],
      Tg_sd: doc['Tg_sd'],
      So_luong: doc['So_luong'],
      So_hd: doc['So_hd'],
      Mdsd: doc['Mdsd'],
      Ma_qr: doc['Ma_qr'],
      Name: doc['Name'],
      Email: doc['Email'],
      Thgian: doc['Thgian']);
}
