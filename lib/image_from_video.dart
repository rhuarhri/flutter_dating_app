

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ImageFromVideo
{
  Future<String> _getFilePath() async
  {
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}';
    String filePath = '$dirPath';

    return filePath;
  }


  Future<String> getImage(String videoFilePath) async
  {
    String path = await _getFilePath();

    print("image file path is " + path);

    String thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoFilePath,
      thumbnailPath: path,
      timeMs: 20,
      quality: 100,
    );

    return thumbnailPath;
  }
}

