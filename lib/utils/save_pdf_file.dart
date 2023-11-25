import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Directory?> getExternalStorageDir({required String folderName}) async {
  Directory? directory;
  try {
    if (Platform.isAndroid) {

      await _requestPermission(Permission.storage);
      await _requestPermission(Permission.accessMediaLocation);
      await _requestPermission(Permission.manageExternalStorage);
      directory = await getExternalStorageDirectory();

      log('Directory path : ${directory!.path}');
      String newPath = "";
      List<String> folders = directory.path.split('/');
      for (int f = 1; f < folders.length; f++) {
        String folder = folders[f];
        if (folder != 'Android') {
          newPath += "/$folder";
        } else {
          break;
        }
      }
      newPath = "$newPath/$folderName";
      directory = Directory(newPath);
      log('Directory path : ${directory.path}');

    } else {
      if (await _requestPermission(Permission.photos)) {
        directory = await getTemporaryDirectory();
      } else {
        return null;
      }
    }

    if (!await directory.exists()) {
      log("!await directory.exists() : ${!await directory.exists()}");
      await directory.create(recursive: true);
    }
  } catch (e) {
    log("ERROR: while get External Storage Dir : $e");
  }
  return directory;
}

Future<bool> _requestPermission(Permission permission) async {
  bool isGranted = await permission.isGranted;
  if (isGranted) {
    log('${permission}.isGranted : ${permission.isGranted}');
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      log('${permission}.isGranted : ${permission.isGranted}');

      return true;
    } else {
      log('${permission}.isGranted : ${permission.isGranted}');

      return false;
    }
  }
}

