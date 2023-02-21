import 'dart:io';

import 'package:a1_chat_app/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/app_config.dart';
import '../../../core/constan/const.dart';
import '../../../modules/messages/message-bloc/message_bloc.dart';
import '../../../modules/messages/models/message.dart';
import '../../../modules/storage/storage.dart';

abstract class MessageRepository {
  Future<List<Message?>> fetchUserMessages();

  Future<List<Message?>> fetchUserReceivedMessages();

  Future<void> fetchMessages();

  Future<dynamic> uploadMessageFile(File data);

  Future<String> downloadMessageFile(String url);

  List<Message?>? getMessages();

  Future<void> saveMessage(Message message);
}

class MessageRepositoryImpl extends MessageRepository {
  final Storage messageStorage;

  MessageRepositoryImpl(this.messageStorage);

  late List<Message?>? messages = [];

  final _dio = Dio();

  talkerDioLogger() {
    return TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    );
  }

  @override
  List<Message?>? getMessages() {
    return messages;
  }

  @override
  Future<void> saveMessage(Message message) async {
    messageStorage.saveMessage(message);
  }

  @override
  Future<void> fetchMessages() async {
    messages = await messageStorage.getMessages();
  }

  @override
  Future<List<Message?>> fetchUserMessages() async {
    _dio.interceptors.add(talkerDioLogger());
    try {
      final response = await _dio.get(
        "${Application.domain}/user-messages/${Application.user?.id}",
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonSocketIO(message)).toList();

      if (kDebugMode) {
        print("User Sending Messages");
        logger.i(userMessages.toString());
      }

      for (var message in userMessages) {
        if (message.isRead) {
          injector<MessageBloc>().add(MessageRead(message: message));
        }
        if (message.isDelivered) {
          injector<MessageBloc>().add(MessageDelivered(message: message));
        }
      }

      return userMessages;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<Message?>> fetchUserReceivedMessages() async {
    _dio.interceptors.add(talkerDioLogger());
    try {
      final response = await _dio.get(
        "${Application.domain}/user-received-messages/${Application.user?.id}",
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${Application.user?.token}'
          },
        ),
      );

      final loadedData = response.data['data'] as List<dynamic>;
      final List<Message> userMessages = loadedData.map((message) => Message.fromJsonSocketIO(message)).toList();

      if (kDebugMode) {
        print("User Receiving Messages");
        logger.i(loadedData.toString());
      }

      return userMessages;
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      rethrow;
    }
  }

  @override
  Future<dynamic> uploadMessageFile(File data) async {
    print("Start Posting Image  ..........");
    _dio.interceptors.add(talkerDioLogger());

    final multiPartData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        data.path,
        filename: data.path
            .split('/')
            .last,
      )
    });

    try {
      final response = await _dio.post(
        "${Application.domain}/upload-message-file",
        data: multiPartData,
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Accept': 'application/json',
            'content-type': 'multipart/form-data',
            'Authorization': 'Bearer ${Application.user?.token}',
          },
        ),
        onSendProgress: (sent, total) {
          // print("Sent : [ ${(sent / total) * 100} ] from : [ 100% ] ....");
          // AppBlocs.uploadingProcessBloc.add(AddUploadingProgress((sent/ total) * 100));
        },
      );
      if (kDebugMode) {
        print("Dio Posting Response  .. ${response.data}");
      }
      return response.data['data'];
    } on DioError catch (error) {
      rethrow;
    }
  }

  // late String _localPath;
  // late bool _permissionReady;
  // late TargetPlatform? platform;

  @override
  Future<String> downloadMessageFile(String url) async {

    final finalUrl = "${Application.domain}/uploads/images/$url";

    _dio.interceptors.add(talkerDioLogger());

    final savePath = "${Application.storageDir?.path}/downloads/$url";

    await Permission.storage.request();

    try {
       await _dio.download(
        finalUrl,
        savePath,
        onReceiveProgress: showDownloadProgress,
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          headers: {
            'Accept': 'application/json',
            'content-type': 'multipart/form-data',
            'Authorization': 'Bearer ${Application.user?.token}',
          },
        ),
      );

      print("Download Completed. ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]");

      return savePath;
    } catch (e) {
      print(e);
      rethrow;
    }
  }


  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + '%');
    }
  }
}


// final file = File(savePath);
// final raf = file.openSync(mode: FileMode.write);
//
// // response.data is List<int> type
// raf.writeFromSync(response.data);
// await raf.close();
// print(file.path);
// return file.path;


  //
  // Future<bool> _checkPermission() async {
  //   if (platform == TargetPlatform.android) {
  //     final status = await Permission.storage.status;
  //     if (status != PermissionStatus.granted) {
  //       final result = await Permission.storage.request();
  //       if (result == PermissionStatus.granted) {
  //         return true;
  //       }
  //     } else {
  //       return true;
  //     }
  //   } else {
  //     return true;
  //   }
  //   return false;
  // }
  //
  // Future<void> _prepareSaveDir() async {
  //   _localPath = Application.storageDir!.path;
  //
  //   print(_localPath);
  //
  //   final savedDir = Directory(_localPath);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     savedDir.create();
  //   }
  // }

  // Future<String?> _findLocalPath() async {
  //   if (platform == TargetPlatform.android) {
  //     return "/sdcard/download/";
  //   } else {
  //     var directory = await getApplicationDocumentsDirectory();
  //     return directory.path + Platform.pathSeparator + 'Download';
  //   }
  // }
// }
