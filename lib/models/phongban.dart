class Department{
  String? documentID;
  String? Ten_Pb;
  String? SDT;
  String? DC;

  Department({
    this.documentID,
    this.Ten_Pb,
    this.SDT,
    this.DC
  });
  factory Department.fromDoc(dynamic doc) =>Department(
      documentID: doc.id,
      Ten_Pb: doc['Ten_Pb'],
    SDT: doc['SDT'],
    DC: doc['DC']
  );

  factory Department.fromDocTenPB(dynamic doc) => Department(
    documentID: doc.id,
    Ten_Pb: doc['Ten_Pb']
  );
}
