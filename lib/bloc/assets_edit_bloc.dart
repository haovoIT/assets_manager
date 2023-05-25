import 'dart:async';

import 'package:assets_manager/component/domain_service.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/models/history_asset_model.dart';
import 'package:assets_manager/services/db_asset_api.dart';
import 'package:assets_manager/services/db_diary_api.dart';
import 'package:assets_manager/services/db_history_asset_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AssetsEditBloc {
  final DbApi dbApi;
  final DbHistoryAssetApi dbHistoryAssetApi;
  final DbDiaryApi dbDiaryApi;
  final bool add;
  AssetsModel selectAsset;

  AssetsEditBloc({
    required this.add,
    required this.dbApi,
    required this.dbHistoryAssetApi,
    required this.dbDiaryApi,
    required this.selectAsset,
  }) {
    _startEditListeners().then((finished) => _getAssets(add, selectAsset));
  }

  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  final StreamController<String> _nameAssetController =
      StreamController<String>.broadcast();
  Sink<String> get nameAssetEditChanged => _nameAssetController.sink;
  Stream<String> get nameAssetEdit => _nameAssetController.stream;

  final StreamController<String> _idDepartmentController =
      StreamController<String>.broadcast();
  Sink<String> get idDepartmentEditChanged => _idDepartmentController.sink;
  Stream<String> get idDepartmentEdit => _idDepartmentController.stream;

  final StreamController<String> _departmentNameController =
      StreamController<String>.broadcast();
  Sink<String> get departmentNameEditChanged => _departmentNameController.sink;
  Stream<String> get departmentNameEdit => _departmentNameController.stream;

  final StreamController<String> _yearOfManufactureController =
      StreamController<String>.broadcast();
  Sink<String> get yearOfManufactureEditChanged =>
      _yearOfManufactureController.sink;
  Stream<String> get yearOfManufactureEdit =>
      _yearOfManufactureController.stream;

  final StreamController<String> _producingCountryController =
      StreamController<String>.broadcast();
  Sink<String> get producingCountryEditChanged =>
      _producingCountryController.sink;
  Stream<String> get producingCountryEdit => _producingCountryController.stream;

  final StreamController<String> _assetGroupNameController =
      StreamController<String>.broadcast();
  Sink<String> get assetGroupNameEditChanged => _assetGroupNameController.sink;
  Stream<String> get assetGroupNameEdit => _assetGroupNameController.stream;

  final StreamController<String> _starDateController =
      StreamController<String>.broadcast();
  Sink<String> get starDateEditChanged => _starDateController.sink;
  Stream<String> get starDateEdit => _starDateController.stream;

  final StreamController<String> _endDateController =
      StreamController<String>.broadcast();
  Sink<String> get endDateEditChanged => _endDateController.sink;
  Stream<String> get endDateEdit => _endDateController.stream;

  final StreamController<String> _statusController =
      StreamController<String>.broadcast();
  Sink<String> get statusEditChanged => _statusController.sink;
  Stream<String> get statusEdit => _statusController.stream;

  final StreamController<String> _originalPriceController =
      StreamController<String>.broadcast();
  Sink<String> get originalPriceEditChanged => _originalPriceController.sink;
  Stream<String> get originalPriceEdit => _originalPriceController.stream;

  final StreamController<String> _usedTimeController =
      StreamController<String>.broadcast();
  Sink<String> get usedTimeEditChanged => _usedTimeController.sink;
  Stream<String> get usedTimeEdit => _usedTimeController.stream;

  final StreamController<String> _amountController =
      StreamController<String>.broadcast();
  Sink<String> get amountEditChanged => _amountController.sink;
  Stream<String> get amountEdit => _amountController.stream;

  final StreamController<String> _contractNameController =
      StreamController<String>.broadcast();
  Sink<String> get contractNameEditChanged => _contractNameController.sink;
  Stream<String> get contractNameEdit => _contractNameController.stream;

  final StreamController<String> _purposeOfUsingController =
      StreamController<String>.broadcast();
  Sink<String> get purposeOfUsingEditChanged => _purposeOfUsingController.sink;
  Stream<String> get purposeOfUsingEdit => _purposeOfUsingController.stream;

  final StreamController<String> _qrCodeController =
      StreamController<String>.broadcast();
  Sink<String> get qrCodeEditChanged => _qrCodeController.sink;
  Stream<String> get qrCodeEdit => _qrCodeController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<String> _depreciationController =
      StreamController<String>.broadcast();
  Sink<String> get depreciationEditChanged => _depreciationController.sink;
  Stream<String> get depreciationEdit => _depreciationController.stream;

  final StreamController<String> _responseController =
      StreamController<String>.broadcast();
  Sink<String> get responseEditChanged => _responseController.sink;
  Stream<String> get responseEdit => _responseController.stream;

  _startEditListeners() async {
    _nameAssetController.stream.listen((nameAsset) {
      selectAsset.nameAsset = nameAsset;
    });
    _idDepartmentController.stream.listen((idDepartment) {
      selectAsset.idDepartment = idDepartment;
    });
    _departmentNameController.stream.listen((departmentName) {
      selectAsset.departmentName = departmentName;
    });
    _yearOfManufactureController.stream.listen((yearOfManufacture) {
      selectAsset.yearOfManufacture = yearOfManufacture;
    });
    _producingCountryController.stream.listen((producingCountry) {
      selectAsset.producingCountry = producingCountry;
    });
    _assetGroupNameController.stream.listen((assetGroupName) {
      selectAsset.assetGroupName = assetGroupName;
    });
    _starDateController.stream.listen((starDate) {
      selectAsset.starDate = starDate;
    });
    _endDateController.stream.listen((endDate) {
      selectAsset.endDate = endDate;
    });
    _statusController.stream.listen((status) {
      selectAsset.status = status;
    });
    _originalPriceController.stream.listen((originalPrice) {
      selectAsset.originalPrice = originalPrice;
    });
    _usedTimeController.stream.listen((usedTime) {
      selectAsset.usedTime = usedTime;
    });
    _amountController.stream.listen((amount) {
      selectAsset.amount = amount;
    });
    _contractNameController.stream.listen((contractName) {
      selectAsset.contractName = contractName;
    });
    _purposeOfUsingController.stream.listen((purposeOfUsing) {
      selectAsset.purposeOfUsing = purposeOfUsing;
    });
    _qrCodeController.stream.listen((qrCode) {
      selectAsset.qrCode = qrCode;
    });
    _depreciationController.stream.listen((depreciation) {
      selectAsset.depreciation = depreciation;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveAssets();
      } else if (action == "Add") {
        _addAssets();
      } else if (action == DomainProvider.CONVERT_ASSET_ALL) {
        _convertAsset(true);
      }
    });
  }

  void _getAssets(bool add, AssetsModel asset) {
    if (add) {
      selectAsset = AssetsModel();
      selectAsset.documentID = asset.documentID;
      selectAsset.nameAsset = asset.nameAsset;
      selectAsset.idDepartment = asset.idDepartment;
      selectAsset.departmentName = asset.departmentName;
      selectAsset.yearOfManufacture = asset.yearOfManufacture;
      selectAsset.producingCountry = asset.producingCountry;
      selectAsset.assetGroupName = asset.assetGroupName;
      selectAsset.starDate = asset.starDate;
      selectAsset.status = asset.status;
      selectAsset.originalPrice = asset.originalPrice;
      selectAsset.usedTime = asset.usedTime;
      selectAsset.amount = asset.amount;
      selectAsset.contractName = asset.contractName;
      selectAsset.purposeOfUsing = asset.purposeOfUsing;
      selectAsset.qrCode = asset.qrCode;
      selectAsset.userId = asset.userId;
      selectAsset.starDate = asset.starDate;
      selectAsset.endDate = asset.endDate;
      selectAsset.depreciation = asset.depreciation;
      // selectAsset.nameAsset = '';
      // selectAsset.idDepartment = '';
      // selectAsset.departmentName = '';
      // selectAsset.yearOfManufacture = DateTime.now().toString();
      // selectAsset.producingCountry = '';
      // selectAsset.assetGroupName = '';
      // selectAsset.status = 'Đang Sử Dụng';
      // selectAsset.starDate = DateTime.now().toString();
      // selectAsset.originalPrice = '0.0';
      // selectAsset.usedTime = '12';
      // selectAsset.amount = '';
      // selectAsset.contractName = '';
      // selectAsset.purposeOfUsing = '';
      // selectAsset.qrCode = DateTime.now().toString();
      // selectAsset.userId = userId;
      // selectAsset.starDate = DateTime.now().toString();
      // selectAsset.endDate = Alert.addMonth(12, DateTime.now().toString());
      // selectAsset.depreciation = '';
    } else {
      selectAsset.nameAsset = asset.nameAsset;
      selectAsset.idDepartment = asset.idDepartment;
      selectAsset.departmentName = asset.departmentName;
      selectAsset.yearOfManufacture = asset.yearOfManufacture;
      selectAsset.producingCountry = asset.producingCountry;
      selectAsset.assetGroupName = asset.assetGroupName;
      selectAsset.starDate = asset.starDate;
      selectAsset.status = selectAsset.status;
      selectAsset.originalPrice = asset.originalPrice;
      selectAsset.usedTime = asset.usedTime;
      selectAsset.amount = asset.amount;
      selectAsset.contractName = asset.contractName;
      selectAsset.purposeOfUsing = asset.purposeOfUsing;
      selectAsset.qrCode = asset.qrCode;
      selectAsset.userId = asset.userId;
      selectAsset.starDate = asset.starDate;
      selectAsset.endDate = asset.endDate;
      selectAsset.depreciation = asset.depreciation;
    }

    nameAssetEditChanged.add(selectAsset.nameAsset ?? "");
    idDepartmentEditChanged.add(selectAsset.idDepartment ?? "");
    departmentNameEditChanged.add(selectAsset.departmentName ?? "");
    yearOfManufactureEditChanged.add(selectAsset.yearOfManufacture ?? "");
    producingCountryEditChanged.add(selectAsset.producingCountry ?? "");
    assetGroupNameEditChanged.add(selectAsset.assetGroupName ?? "");
    statusEditChanged.add(selectAsset.status ?? "");
    originalPriceEditChanged.add(selectAsset.originalPrice ?? "");
    usedTimeEditChanged.add(selectAsset.usedTime ?? "");
    amountEditChanged.add(selectAsset.amount ?? "");
    contractNameEditChanged.add(selectAsset.contractName ?? "");
    purposeOfUsingEditChanged.add(selectAsset.purposeOfUsing ?? "");
    endDateEditChanged.add(selectAsset.endDate ?? "");
    starDateEditChanged.add(selectAsset.starDate ?? "");
  }

  void _saveAssets() async {
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    AssetsModel assets = AssetsModel(
      documentID: selectAsset.documentID,
      nameAsset: selectAsset.nameAsset,
      idDepartment: selectAsset.idDepartment,
      departmentName: selectAsset.departmentName,
      yearOfManufacture: selectAsset.yearOfManufacture,
      producingCountry: selectAsset.producingCountry,
      assetGroupName: selectAsset.assetGroupName,
      status: selectAsset.status,
      originalPrice: selectAsset.originalPrice,
      usedTime: selectAsset.usedTime,
      amount: selectAsset.amount,
      contractName: selectAsset.contractName,
      purposeOfUsing: selectAsset.purposeOfUsing,
      qrCode: selectAsset.qrCode,
      userId: userId,
      starDate: selectAsset.starDate,
      endDate: selectAsset.endDate,
      dateCreate: DateTime.now().toString(),
      depreciation: selectAsset.depreciation,
    );
    if (add) {
      String responseAddAsset = await dbApi.addAssets(assets: assets);
      if (responseAddAsset != "" && responseAddAsset.isNotEmpty == true) {
        DiaryModel diary = DiaryModel(
            documentID: selectAsset.qrCode,
            nameAsset: selectAsset.nameAsset,
            idAsset: responseAddAsset,
            idDepartment: selectAsset.idDepartment,
            originalPrice: selectAsset.originalPrice,
            usedTime: selectAsset.usedTime,
            qrCode: selectAsset.qrCode,
            starDate: selectAsset.starDate,
            endDate: selectAsset.endDate,
            dateCreate: DateTime.now().toString(),
            depreciation: selectAsset.depreciation,
            userName: name,
            userEmail: email,
            dateUpdate: DateTime.now().toString(),
            detail: "Thêm Mới");
        String responseAddDiary = await dbDiaryApi.addDiaryModel(diary);
        HistoryAssetModel historyAssetModel = HistoryAssetModel(
          documentID: selectAsset.qrCode,
          nameAsset: selectAsset.nameAsset,
          idAsset: responseAddAsset,
          idDepartment: selectAsset.idDepartment,
          departmentName: selectAsset.departmentName,
          yearOfManufacture: selectAsset.yearOfManufacture,
          producingCountry: selectAsset.producingCountry,
          assetGroupName: selectAsset.assetGroupName,
          status: selectAsset.status,
          originalPrice: selectAsset.originalPrice,
          usedTime: selectAsset.usedTime,
          amount: selectAsset.amount,
          contractName: selectAsset.contractName,
          purposeOfUsing: selectAsset.purposeOfUsing,
          qrCode: selectAsset.qrCode,
          userId: userId,
          starDate: selectAsset.starDate,
          endDate: selectAsset.endDate,
          dateCreate: DateTime.now().toString(),
          depreciation: selectAsset.depreciation,
          userName: name,
          userEmail: email,
          dateUpdate: DateTime.now().toString(),
        );
        dbHistoryAssetApi.addHistoryAsset(historyAssetModel);
        if (responseAddDiary != "" && responseAddDiary.isNotEmpty == true) {
          responseEditChanged.add(DomainProvider.SUCCESS);
        } else {
          responseEditChanged.add(DomainProvider.ERROR);
        }
      } else {
        responseEditChanged.add(DomainProvider.ERROR);
      }
    } else {
      final responseAsset =
          await dbApi.updateAssetWithTransaction(assets: assets);
      if (responseAsset == DomainProvider.SUCCESS) {
        HistoryAssetModel historyAssetModel = HistoryAssetModel(
          nameAsset: selectAsset.nameAsset,
          idAsset: selectAsset.documentID,
          idDepartment: selectAsset.idDepartment,
          departmentName: selectAsset.departmentName,
          yearOfManufacture: selectAsset.yearOfManufacture,
          producingCountry: selectAsset.producingCountry,
          assetGroupName: selectAsset.assetGroupName,
          status: selectAsset.status,
          originalPrice: selectAsset.originalPrice,
          usedTime: selectAsset.usedTime,
          amount: selectAsset.amount,
          contractName: selectAsset.contractName,
          purposeOfUsing: selectAsset.purposeOfUsing,
          qrCode: selectAsset.qrCode,
          userId: selectAsset.userId,
          starDate: selectAsset.starDate,
          endDate: selectAsset.endDate,
          depreciation: selectAsset.depreciation,
          userName: name,
          userEmail: email,
          dateUpdate: DateTime.now().toString(),
          dateCreate: selectAsset.dateCreate,
        );
        final responseHistory =
            await dbHistoryAssetApi.addHistoryAsset(historyAssetModel);
        if (responseHistory != "" && responseHistory.isNotEmpty == true) {
          responseEditChanged.add(DomainProvider.SUCCESS);
        } else {
          responseEditChanged.add(DomainProvider.ERROR);
        }
      } else {
        responseEditChanged.add(DomainProvider.ERROR);
      }
    }
  }

  void _addAssets() async {
    AssetsModel assets = AssetsModel(
      documentID: selectAsset.documentID,
      nameAsset: selectAsset.nameAsset,
      idDepartment: selectAsset.idDepartment,
      departmentName: selectAsset.departmentName,
      yearOfManufacture: selectAsset.yearOfManufacture,
      producingCountry: selectAsset.producingCountry,
      assetGroupName: selectAsset.assetGroupName,
      status: selectAsset.status,
      originalPrice: selectAsset.originalPrice,
      usedTime: selectAsset.usedTime,
      amount: selectAsset.amount,
      contractName: selectAsset.contractName,
      purposeOfUsing: selectAsset.purposeOfUsing,
      qrCode: selectAsset.qrCode,
      userId: selectAsset.userId,
      starDate: selectAsset.starDate,
      endDate: selectAsset.endDate,
      depreciation: selectAsset.depreciation,
      dateCreate: DateTime.now().toString(),
    );
    String responseAddAsset = await dbApi.addAssets(assets: assets);

    if (responseAddAsset != "" && responseAddAsset.isNotEmpty == true) {
      responseEditChanged.add(DomainProvider.SUCCESS);
    } else {
      responseEditChanged.add(DomainProvider.ERROR);
    }
  }

  void _convertAsset(bool isAll) async {
    if (isAll) {
      final AssetsModel convertAsset = AssetsModel(
        documentID: selectAsset.documentID,
        nameAsset: selectAsset.nameAsset,
        idDepartment: selectAsset.idDepartment,
        departmentName: selectAsset.departmentName,
        yearOfManufacture: selectAsset.yearOfManufacture,
        producingCountry: selectAsset.producingCountry,
        assetGroupName: selectAsset.assetGroupName,
        status: selectAsset.status,
        originalPrice: selectAsset.originalPrice,
        usedTime: selectAsset.usedTime,
        amount: selectAsset.amount,
        contractName: selectAsset.contractName,
        purposeOfUsing: selectAsset.purposeOfUsing,
        qrCode: selectAsset.qrCode,
        userId: userId,
        starDate: selectAsset.starDate,
        endDate: selectAsset.endDate,
        dateCreate: selectAsset.dateCreate,
        depreciation: selectAsset.depreciation,
      );

      final responseAsset = await dbApi.updateAsset(assets: convertAsset);
      if (responseAsset == DomainProvider.SUCCESS) {
        HistoryAssetModel historyAssetModel = HistoryAssetModel(
          nameAsset: selectAsset.nameAsset,
          idAsset: selectAsset.documentID,
          idDepartment: selectAsset.idDepartment,
          departmentName: selectAsset.departmentName,
          yearOfManufacture: selectAsset.yearOfManufacture,
          producingCountry: selectAsset.producingCountry,
          assetGroupName: selectAsset.assetGroupName,
          status: selectAsset.status,
          originalPrice: selectAsset.originalPrice,
          usedTime: selectAsset.usedTime,
          amount: selectAsset.amount,
          contractName: selectAsset.contractName,
          purposeOfUsing: selectAsset.purposeOfUsing,
          qrCode: selectAsset.qrCode,
          userId: selectAsset.userId,
          starDate: selectAsset.starDate,
          endDate: selectAsset.endDate,
          depreciation: selectAsset.depreciation,
          userName: name,
          userEmail: email,
          dateUpdate: DateTime.now().toString(),
        );
        final responseHistory =
            await dbHistoryAssetApi.addHistoryAsset(historyAssetModel);
        if (responseHistory != "" && responseHistory.isNotEmpty == true) {
          responseEditChanged.add(DomainProvider.SUCCESS);
        } else {
          responseEditChanged.add(DomainProvider.ERROR);
        }
      } else {
        responseEditChanged.add(DomainProvider.ERROR);
      }
    }
  }

  void dispose() {
    _nameAssetController.close();
    _idDepartmentController.close();
    _yearOfManufactureController.close();
    _producingCountryController.close();
    _assetGroupNameController.close();
    _statusController.close();
    _originalPriceController.close();
    _starDateController.close();
    _endDateController.close();
    _usedTimeController.close();
    _amountController.close();
    _contractNameController.close();
    _purposeOfUsingController.close();
    _qrCodeController.close();
    _saveController.close();
    _depreciationController.close();
    _departmentNameController.close();
    _responseController.close();
  }
}
