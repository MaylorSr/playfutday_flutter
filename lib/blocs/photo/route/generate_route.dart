import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/blocs/photo/route/route_nanme.dart';
import 'package:playfutday_flutter/pages/newPost/new_PostPage.dart';

import '../../../pages/newPost/edit_Page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeEdit:
        //default: // else
        return MaterialPageRoute(
            builder: (_) => EditPhotoPage(
                  image: settings.arguments as File,
                ));
      //break;
      //case routeHome:
      default:
        return MaterialPageRoute(builder: (_) => const NewPost());
      //break;
    }
  }
}
