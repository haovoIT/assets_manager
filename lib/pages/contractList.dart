import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_bloc.dart';
import 'package:assets_manager/bloc/contract_bloc_provider.dart';
import 'package:assets_manager/models/hopdong.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_hopdong.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationserver =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationserver);
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
                    ContractBloc(DbContractService(), _authenticationserver),
                uid: snapshot.data!,
                child: ContractLists());
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

class ContractLists extends StatefulWidget {
  const ContractLists({Key? key}) : super(key: key);

  @override
  _ContractListsState createState() => _ContractListsState();
}

class _ContractListsState extends State<ContractLists> {
  ContractBloc? _contractBloc;
  TextEditingController tenController = new TextEditingController();
  String tenHD = "";
  bool flag = true;
  List<Contract> listContract = [];
  List<Contract> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractBloc = ContractBlocProvider.of(context)!.contractBloc;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tenController.addListener(() {
      setState(() {
        tenHD = tenController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            leading: new Icon(Icons.search),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {
                  tenController.clear(),
                  setState(() {
                    flag = true;
                  }),
                },
              ),
            ],
            title: TextFormField(
              enabled: true,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: "Nhập tên phòng ban....",
              ),
              controller: tenController,
              onChanged: (name) {
                listContract.clear();
                flag = false;
              },
            )),
        body: StreamBuilder(
            stream: _contractBloc?.listContract,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                list = snapshot.data;
                return _build(snapshot);
              } else {
                return Center(
                  child: Container(
                    child: Text('Thêm Hợp Đồng.'),
                  ),
                );
              }
            }),
      ),
      onWillPop: () async {
        final snackBar = SnackBar(
          content: Text(
            'Vui lòng chọn Hợp Đồng thích hợp !!',
            style: TextStyle(
                fontSize: 18, fontStyle: FontStyle.italic, color: Colors.red),
          ),
          backgroundColor: Colors.blue.shade200,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      },
    );
  }

  Widget _build(AsyncSnapshot snapshot) {
    if (flag) {
      return _buildListViewSeparated(list);
    } else {
      for (int i = 0; i < snapshot.data.length; i++) {
        if (snapshot.data[i].TenHD
            .toLowerCase()
            .contains(tenHD.toLowerCase())) {
          listContract.add(snapshot.data[i]);
        }
      }
      return _buildListViewSeparated(listContract);
    }
  }

  Widget _buildListViewSeparated(List<Contract> listContracts) {
    return ListView.separated(
      itemCount: listContracts.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = listContracts[index].TenHD ?? "";
        String _subtilte = "Số hợp đồng: " +
            listContracts[index].SoHD! +
            DateFormat.yMd()
                .format(DateTime.parse(listContracts[index].NgayKy!)) +
            "\nNgày Hết Hạn: " +
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(listContracts[index].NHH!)) +
            "\nNCC: " +
            listContracts[index].NCC!;
        return ListTile(
          tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
          leading: Column(
            children: <Widget>[
              Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
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
          subtitle: Text(_subtilte),
          onTap: () {
            Navigator.pop(context, listContracts[index].TenHD);
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
