import 'dart:async';

import 'package:assets_manager/models/taisan.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_lichsusudung_api.dart';
import 'package:assets_manager/services/db_taisan_api.dart';

class HomeBloc {
  final DbApi dbApi;
  final DbLSSDApi dbLSSDApi;
  final AuthenticationApi authenticationApi;

  HomeBloc(this.dbApi, this.dbLSSDApi, this.authenticationApi) {
    _startListeners();
  }
  String? ma_Pb;
  String? maQr;

  final StreamController<String> _tenTsController =
      StreamController<String>.broadcast();
  Sink<String> get tenTsEditChanged => _tenTsController.sink;
  Stream<String> get tenTsEdit => _tenTsController.stream;

  final StreamController<String> _maController =
      StreamController<String>.broadcast();
  Sink<String> get maEditChanged => _maController.sink;
  Stream<String> get maEdit => _maController.stream;

  final StreamController<String> _maPBController =
      StreamController<String>.broadcast();
  Sink<String> get maPBEditChanged => _maPBController.sink;
  Stream<String> get maPBEdit => _maPBController.stream;

  final StreamController<String> _tinhtrangController =
      StreamController<String>.broadcast();
  Sink<String> get tinhtrangEditChanged => _tinhtrangController.sink;
  Stream<String> get tinhtrangEdit => _tinhtrangController.stream;

  final StreamController<List<Assets>> _assetsController =
      StreamController<List<Assets>>.broadcast();
  Sink<List<Assets>> get _addListAssets => _assetsController.sink;
  Stream<List<Assets>> get listAssets => _assetsController.stream;

  final StreamController<List<Assets>> _assetIDController =
      StreamController<List<Assets>>.broadcast();
  Sink<List<Assets>> get _addListIDAssets => _assetIDController.sink;
  Stream<List<Assets>> get listIDAssets => _assetIDController.stream;

  final StreamController<List<Assets>> _assetTTController =
      StreamController<List<Assets>>.broadcast();
  Sink<List<Assets>> get _addListTTAssets => _assetTTController.sink;
  Stream<List<Assets>> get listTTAssets => _assetTTController.stream;

  final StreamController<List<Assets>> _assetsPBController =
      StreamController<List<Assets>>.broadcast();
  Sink<List<Assets>> get _addListAssetsPB => _assetsPBController.sink;
  Stream<List<Assets>> get listAssetsPB => _assetsPBController.stream;

  //final StreamController<Assets> _assetController = StreamController<Assets>.broadcast();
  //Sink<Assets> get _addAssets => _assetController.sink;
  //Stream<Assets> get assets => _assetController.stream;

  final StreamController<Assets> _assetsDeleteController =
      StreamController<Assets>.broadcast();
  Sink<Assets> get deleteAssets => _assetsDeleteController.sink;

  void _startListeners() {
    _maPBController.stream.listen((maPB) {
      dbApi.getAssetsList(maPB).listen((assetsDocs) {
        _addListAssets.add(assetsDocs);
      });
    });

    /*dbApi.getAssetsListDSD().listen((assetsDocs) {
      _addListDSDAssets.add(assetsDocs);
    });

    dbApi.getAssetsListKhauHao().listen((assetsDocs) {
      _addListAssetsKH.add(assetsDocs);
    });*/

    _assetsDeleteController.stream.listen((assets) {
      dbApi.deleteAsset(assets);
      dbLSSDApi.deleteLichSuSuDungID(assets.Ma_qr ?? "");
    });

    _maController.stream.listen((maTs) {
      dbApi
          .getAssetsID(maTs.substring(27, maTs.length), maTs.substring(0, 26))
          .listen((assets) {
        _addListIDAssets.add(assets);
      });
    });

    _maPBController.stream.listen((maPB) {
      _tinhtrangController.stream.listen((tinhtrang) {
        dbApi.getAssetsTinhTrang(maPB, tinhtrang).listen((listAssetTT) {
          _addListTTAssets.add(listAssetTT);
        });
      });
    });

    _maPBController.stream.listen((maPB) {
      dbApi.getAssetsPB(maPB).listen((listAssetsPB) {
        _addListAssetsPB.add(listAssetsPB);
      });
    });
  }

  void dispose() {
    _assetsDeleteController.close();
    _assetsController.close();
    _maController.close();
    _tenTsController.close();
    _assetIDController.close();
    _tinhtrangController.close();
    _assetTTController.close();
    _addListAssetsPB.close();
    _maPBController.close();
    _assetsPBController.close();
  }
}
