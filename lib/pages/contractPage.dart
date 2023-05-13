import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_bloc.dart';
import 'package:assets_manager/bloc/contract_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_edit_bloc.dart';
import 'package:assets_manager/bloc/contract_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachHopDong.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/hopdong.dart';
import 'package:assets_manager/pages/contractEditPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_hopdong.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationServer =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationServer);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ContractBlocProvider(
                contractBloc:
                    ContractBloc(DbContractService(), _authenticationServer),
                uid: snapshot.data!,
                child: ContractPages());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Hợp Đồng.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class ContractPages extends StatefulWidget {
  const ContractPages({Key? key}) : super(key: key);

  @override
  _ContractPagesState createState() => _ContractPagesState();
}

class _ContractPagesState extends State<ContractPages> {
  ContractBloc? _contractBloc;
  List<Contract> listContract = [];
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  String email = FirebaseAuth.instance.currentUser?.email ?? "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractBloc = ContractBlocProvider.of(context)?.contractBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  void _addOrEditContract({required bool add, required Contract contract}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ContractEditBlocProvider(
                contractEditBloc:
                    ContractEditBloc(add, DbContractService(), contract),
                child: ContractEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteContract(String nameHD) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Xóa Hợp Đồng",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Bạn có chắc chắn muốn xóa hợp đồng ' + nameHD + ' không ?',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Huỷ')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Hợp Đồng'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile =
                    await PdfDSHopDongApi.generate(listContract, email, name);
                PdfApi.openFile(pdfFile);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _contractBloc?.listContract,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Hợp đồng.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditContract(add: true, contract: Contract());
        },
        icon: Icon(Icons.add),
        label: Text('Hợp Đồng '),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime now = DateTime.now();
        DateTime ngayHH = DateTime.parse(snapshot.data[index].NHH);
        var soNgay = ngayHH.difference(now);
        String _title = soNgay.inDays <= 30
            ? 'Sắp Hết Hạn \n' + snapshot.data[index].TenHD
            : snapshot.data[index].TenHD;
        String _subTilte = "Số hợp đồng: " +
            snapshot.data[index].SoHD +
            "\nNgày ký: " +
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(snapshot.data[index].NgayKy)) +
            "\nNgày Hết Hạn: " +
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(snapshot.data[index].NHH)) +
            "\nNCC: " +
            snapshot.data[index].NCC +
            "\nNội dung: \n" +
            snapshot.data[index].ND;
        listContract.add(snapshot.data[index]);

        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            tileColor: soNgay.inDays <= 30
                ? Colors.yellowAccent
                : index % 2 == 0
                    ? Colors.green.shade50
                    : Colors.white,
            leading: Column(
              children: <Widget>[
                Text(
                  soNgay.inDays <= 30
                      ? ' ${soNgay.inDays} Ngày'
                      : (index + 1).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.lightBlue),
                ),
              ],
            ),
            title: Text(
              _title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.blue),
            ),
            subtitle: Text(_subTilte),
            onTap: () {
              _addOrEditContract(
                add: false,
                contract: Contract(
                  documentID: snapshot.data[index].documentID,
                  SoHD: snapshot.data[index].SoHD,
                  TenHD: snapshot.data[index].TenHD,
                  NgayKy: snapshot.data[index].NgayKy,
                  NHH: snapshot.data[index].NHH,
                  NCC: snapshot.data[index].NCC,
                  ND: snapshot.data[index].ND,
                ),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteContract(_title);
            if (confirmDelete) {
              _contractBloc?.deleteContract.add(snapshot.data[index]);
            }
            return null;
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.green,
        );
      },
    );
  }
}
