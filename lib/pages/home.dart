import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/pages/assetsPage.dart';
import 'package:assets_manager/pages/departmentList.dart';
import 'package:assets_manager/pages/departmentsPage.dart';
import 'package:assets_manager/pages/leftDrawerWidget.dart';
import 'package:assets_manager/pages/utilitys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthenticationBloc? _authenticationBloc;
  String? _uid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context)?.authenticationBloc;
    _uid = HomeBlocProvider.of(context)?.uid;
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QUẢN LÝ TÀI SẢN'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                final signOut = await _signOut();
                if (signOut) {
                  _authenticationBloc?.logoutUser.add(true);
                }
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      drawer: LeftDrawerWidgets(),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: TabBarView(
          controller: _tabController,
          children: [
            AssetsPages(flag: true),
            DepartmentsList(
              flag: false,
            ),
            AssetsPages(flag: false),
            Utilitys(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black38,
          tabs: [
            Tab(
              icon: Icon(Icons.home_filled),
              text: 'Tài sản',
            ),
            Tab(icon: Icon(Icons.web_asset_outlined), text: 'Phòng Ban'),
            Tab(
              icon: Icon(Icons.assessment_outlined),
              text: 'Khấu Hao',
            ),
            Tab(
              icon: Icon(Icons.apps_sharp),
              text: 'Thêm',
            ),
          ],
          indicator: ShapeDecoration(
              shape: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.solid)),
              gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.green.shade100])),
          labelStyle: TextStyle(fontSize: 14, color: Colors.white),
          unselectedLabelStyle: TextStyle(
              fontStyle: FontStyle.normal, fontSize: 12, color: Colors.white),
          onTap: (_tab) {
            _tab = _tabController.index;
            setState(() {
              switch (_tab) {
                case 0:
                  AssetsPage(flag: true);
                  break;
                case 1:
                  Warehouse();
                  break;
                case 2:
                  AssetsPage(flag: false);
                  break;
                case 3:
                  Utilitys();
                  break;
              }
            });
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<bool> _signOut() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Đăng xuất",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Thoát')),
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
}
