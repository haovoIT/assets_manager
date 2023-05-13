import 'package:assets_manager/bloc/login_bloc.dart';
import 'package:assets_manager/component/app_colors.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/component/domain_service.dart';
import 'package:assets_manager/component/global_styles.dart';
import 'package:assets_manager/global_widget/text_field_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alert {
  static Duration duration = const Duration(seconds: 2);

  static void showLoadingIndicator(
      {String? message, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (val) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.main,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  message ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.main,
                      decoration: TextDecoration.none),
                )
              ],
            ),
          );
        });
  }

  static void closeLoadingIndicator(context) {
    Navigator.of(context).pop();
  }

  static void showColoredToast() {
    Fluttertoast.showToast(
        msg: "This is Colored Toast with android duration of 5 Sec",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  static void showForgotPassword(
    context, {
    required TextEditingController resetEmailController,
    required LoginBloc? loginBloc,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            LoginString.FORGOT_PASSWORD,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    LoginString.CONTENT_FORGOT_PASS,
                    textAlign: TextAlign.center,
                  ),
                  GlobalStyles.sizedBoxHeight_10,
                  StreamBuilder(
                      stream: loginBloc?.emailsEdit,
                      builder: (context, snapshot) => TextFieldLogin(
                            hintText: LoginString.HINT_TEXT_EMAIL,
                            labelText: LoginString.LABEL_TEXT_EMAIL,
                            errorText: snapshot.error != null
                                ? snapshot.error.toString()
                                : "",
                            onChangeFunction: (email) =>
                                loginBloc?.emailsEditChanged.add(email),
                            inputAction: TextInputAction.done,
                          ))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                CommonString.CANCEL,
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            StreamBuilder(
              initialData: false,
              stream: loginBloc?.forgotPasswordEdit,
              builder: (context, snapshot) => Container(
                width: 100,
                height: 60,
                child: ElevatedButton(
                  child: Text(
                    CommonString.CONTINUE,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    loginBloc?.forgotPasswordEditChanged
                        .add(DomainProvider.RESET);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> showSuccess(
      {required String title,
      String? message,
      required String buttonText,
      required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message ?? ""),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(buttonText),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<dynamic> showError({
    required String title,
    required String message,
    required String buttonText,
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(buttonText),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
  //
  // static Future<dynamic> selectFile() async {
  //   return showDialog(
  //     context: Get.context!,
  //     builder: (_) => Dialog(
  //       insetPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  //       child: Builder(
  //         builder: (context) {
  //           var width = MediaQuery.of(context).size.width;
  //
  //           return Container(
  //             width: width,
  //             margin: EdgeInsets.symmetric(vertical: 15),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 15),
  //                   child: Text(
  //                     FlutterI18n.translate(context, "COMMON.uploadFile"),
  //                     style:
  //                         TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: width,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(top: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.centerLeft,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(result: "image"),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.image"),
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: width,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(bottom: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.centerLeft,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(result: "pdf"),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.pdf"),
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.centerRight,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(right: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.bottomRight,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.cancel"),
  //                             style: TextStyle(
  //                                 fontSize: 17, fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  // static Future<dynamic> showConfirmDialog({detail}) {
  //   return showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(FlutterI18n.translate(context, "COMMON.confirm")),
  //       content: Text(detail ?? ""),
  //       actions: <Widget>[
  //         CupertinoDialogAction(
  //           child: Text(FlutterI18n.translate(context, "COMMON.ok")),
  //           onPressed: () => Get.back(result: true),
  //         ),
  //         CupertinoDialogAction(
  //           child: Text(FlutterI18n.translate(context, "COMMON.cancel")),
  //           onPressed: () => Get.back(result: false),
  //         )
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
  //
  // static Future<dynamic> showSelectImage() {
  //   /* -- 1 for camera
  //      -- 2 for photo
  //    */
  //   return Get.bottomSheet(
  //     SafeArea(
  //         child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.symmetric(horizontal: 5),
  //           decoration: BoxDecoration(
  //               color: Color(0xffF1F1F1),
  //               borderRadius: BorderRadius.circular(15)),
  //           child: CupertinoActionSheet(
  //               title: Column(
  //                 children: [
  //                   Text(
  //                     FlutterI18n.translate(
  //                         Get.context!, "addRequest.attachments"),
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10),
  //                     child: Text(FlutterI18n.translate(
  //                         Get.context!, "addRequest.typeFile")),
  //                   ),
  //                 ],
  //               ),
  //               actions: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 6),
  //                   child: CupertinoDialogAction(
  //                     child: Text(
  //                       FlutterI18n.translate(Get.context!, "addRequest.image"),
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w600, fontSize: 18),
  //                     ),
  //                     onPressed: () => Get.back(result: "image"),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 1),
  //                   child: CupertinoDialogAction(
  //                     child: Text(
  //                       FlutterI18n.translate(
  //                           Get.context!, "addRequest.document"),
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500, fontSize: 18),
  //                     ),
  //                     onPressed: () => Get.back(result: "document"),
  //                   ),
  //                 ),
  //               ]),
  //         ),
  //         Container(
  //           margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
  //           height: 60,
  //           decoration: BoxDecoration(
  //               color: Color(0xffF1F1F1),
  //               borderRadius: BorderRadius.circular(14)),
  //           child: CupertinoActionSheet(actions: [
  //             CupertinoDialogAction(
  //               child: Center(
  //                 child: Text(
  //                   FlutterI18n.translate(Get.context!, "addRequest.cancel"),
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                 ),
  //               ),
  //               onPressed: () => Get.back(),
  //             ),
  //           ]),
  //         )
  //       ],
  //     )),
  //     isScrollControlled: true,
  //   );
  // }
  //
  // static Future<dynamic> showImageModal(
  //     {required String appbarTitle,
  //     required List<dynamic>? imageList,
  //     required int index}) {
  //   return Get.generalDialog(
  //     barrierColor: Colors.white,
  //     barrierDismissible: false,
  //     pageBuilder: (_, __, ___) {
  //       return SizedBox.expand(
  //         child: Scaffold(
  //             appBar: AppBar(
  //               backgroundColor: Colors.transparent,
  //               centerTitle: true,
  //               elevation: 0,
  //               leading: IconButton(
  //                 icon: Icon(
  //                   Icons.arrow_back_outlined,
  //                   size: 20,
  //                   color: AppColors.main,
  //                 ),
  //                 onPressed: () => Get.back(),
  //               ),
  //               title: Text(
  //                 appbarTitle,
  //                 style: TextStyle(
  //                   color: AppColors.main,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               automaticallyImplyLeading: false,
  //             ),
  //             body: PageView.builder(
  //                 itemCount: imageList!.length,
  //                 controller: PageController(initialPage: index),
  //                 itemBuilder: (context, index) {
  //                   return Stack(
  //                     alignment: Alignment.topRight,
  //                     children: [
  //                       PhotoView(
  //                         imageProvider: NetworkImage(
  //                             "${dotenv.env['APIURL']}" + imageList[index]!),
  //                         backgroundDecoration: BoxDecoration(
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       IconButton(
  //                         icon: CircleAvatar(
  //                           backgroundColor: AppColors.gray.withOpacity(0.4),
  //                           radius: 20,
  //                           child: Icon(
  //                             Icons.download_sharp,
  //                             size: 20,
  //                             color: AppColors.main,
  //                           ),
  //                         ),
  //                         onPressed: () async {
  //                           String url =
  //                               "${dotenv.env['APIURL']}" + imageList[index];
  //                           var response = await Dio().get(url,
  //                               options:
  //                                   Options(responseType: ResponseType.bytes));
  //                           final result = await ImageGallerySaver.saveImage(
  //                               Uint8List.fromList(response.data),
  //                               quality: 60,
  //                               name: "Giaic_connect_" +
  //                                   DateTime.now().toString());
  //                           if (result["errorMessage"] != "null") {
  //                             Get.snackbar(
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.success"),
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.successDownload"),
  //                               backgroundColor: Colors.white,
  //                               titleText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.success"),
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 16,
  //                                     color: AppColors.main),
  //                               ),
  //                               messageText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.successDownload"),
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: AppColors.main,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               duration: const Duration(seconds: 2),
  //                               icon: SvgPicture.asset(
  //                                 AppImages.icLogo,
  //                                 fit: BoxFit.fill,
  //                                 height: 45,
  //                                 width: 45,
  //                               ),
  //                               borderRadius: 20.0,
  //                               borderColor: AppColors.main,
  //                               borderWidth: 1,
  //                             );
  //                           } else {
  //                             Get.snackbar(
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.error"),
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.failedDownload"),
  //                               backgroundColor: Colors.white,
  //                               titleText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.error"),
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 16,
  //                                     color: AppColors.red),
  //                               ),
  //                               messageText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.failedDownload"),
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: AppColors.main,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               duration: const Duration(seconds: 2),
  //                               icon: SvgPicture.asset(
  //                                 AppImages.icLogo,
  //                                 fit: BoxFit.fill,
  //                                 height: 45,
  //                                 width: 45,
  //                               ),
  //                               borderRadius: 20.0,
  //                               borderColor: AppColors.main,
  //                               borderWidth: 1,
  //                             );
  //                           }
  //                         },
  //                       ),
  //                     ],
  //                   );
  //                 })),
  //       );
  //     },
  //   );
  // }
  //
  // static Future<dynamic> showQuestionDeleteAccount({
  //   String? message,
  //   String? textConfirm,
  //   String? yesButton,
  //   String? cancelButton,
  //   Function()? functionYes,
  // }) {
  //   return showDialog(
  //     context: Get.context!,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             message ?? "",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.main),
  //           ),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           Text(
  //             textConfirm ?? "",
  //             textAlign: TextAlign.left,
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ],
  //       ),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
  //       actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(10))),
  //       actions: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //                 onPressed: () => Get.back(),
  //                 child: Text(
  //                   cancelButton ?? "",
  //                   style: TextStyle(color: Colors.black),
  //                 ),
  //                 style: TextButton.styleFrom(
  //                     primary: AppColors.gray,
  //                     shape: RoundedRectangleBorder(
  //                         side: BorderSide(
  //                           width: 0.5,
  //                           color: Color(0xff333333),
  //                         ),
  //                         borderRadius: BorderRadius.circular(10)))),
  //             TextButton(
  //                 onPressed: functionYes ?? () => Get.back(result: true),
  //                 child: Text(yesButton ?? ""),
  //                 style: TextButton.styleFrom(
  //                   primary: Colors.white,
  //                   backgroundColor: AppColors.main,
  //                   shape: RoundedRectangleBorder(
  //                       side: BorderSide(width: 1, color: AppColors.main),
  //                       borderRadius: BorderRadius.circular(10)),
  //                 )),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // static Future<dynamic> showImageModalFile(
  //     {required String appbarTitle,
  //     required List<dynamic>? imageList,
  //     required int index}) {
  //   return Get.generalDialog(
  //     barrierColor: Colors.white,
  //     barrierDismissible: false,
  //     pageBuilder: (_, __, ___) {
  //       return SizedBox.expand(
  //         child: Scaffold(
  //             appBar: AppBar(
  //               backgroundColor: Colors.transparent,
  //               centerTitle: true,
  //               elevation: 0,
  //               leading: IconButton(
  //                 icon: Icon(
  //                   Icons.arrow_back_outlined,
  //                   size: 20,
  //                   color: AppColors.main,
  //                 ),
  //                 onPressed: () => Get.back(),
  //               ),
  //               title: Text(
  //                 appbarTitle,
  //                 style: TextStyle(
  //                   color: AppColors.main,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               automaticallyImplyLeading: false,
  //             ),
  //             body: PageView.builder(
  //                 itemCount: imageList!.length,
  //                 controller: PageController(initialPage: index),
  //                 itemBuilder: (context, index) {
  //                   return PhotoView(
  //                     imageProvider: FileImage(imageList[index]),
  //                   );
  //                 })),
  //       );
  //     },
  //   );
  // }
}
