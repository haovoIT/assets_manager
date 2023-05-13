class Assets{
  String? documentID;
  String? Ten_ts;
  String? Ma_pb;
  String? Ten_pb;
  String? Nam_sx;
  String? Nuoc_sx;
  String? Ten_nts;
  String? Tinh_trang;
  String? Nguyen_gia;
  String? Tg_sd;
  String? So_luong;
  String? Ten_hd;
  String? Mdsd;
  String? Ma_qr;
  String? Uid;


  Assets({
    this.documentID,
    this.Ten_ts,
    this.Ma_pb,
    this.Ten_pb,
    this.Nam_sx,
    this.Nuoc_sx,
    this.Ten_nts,
    this.Tinh_trang,
    this.Nguyen_gia,
    this.Tg_sd,
    this.So_luong,
    this.Ten_hd,
    this.Mdsd,
    this.Ma_qr,
    this.Uid
});
  factory Assets.fromDoc(dynamic doc) => Assets(
    documentID: doc.id,
    Ten_ts: doc['Ten_ts'],
    Ma_pb: doc['Ma_pb'],
    Ten_pb: doc['Ten_pb'],
    Nam_sx: doc['Nam_sx'],
    Nuoc_sx: doc['Nuoc_sx'],
    Ten_nts: doc['Ten_nts'],
    Tinh_trang: doc['Tinh_trang'],
    Nguyen_gia:  doc['Nguyen_gia'],
    Tg_sd: doc['Tg_sd'],
    So_luong: doc['So_luong'],
    Ten_hd: doc['Ten_hd'],
    Mdsd: doc['Mdsd'],
    Ma_qr: doc['Ma_qr'],
    Uid: doc['Uid']
  );
}