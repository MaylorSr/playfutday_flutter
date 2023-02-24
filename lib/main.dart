import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/home_page.dart';
import 'package:playfutday_flutter/pages/login_page.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';
import 'package:playfutday_flutter/repositories/user_repository.dart';

import 'package:playfutday_flutter/services/authentication_service.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';
import 'config/locator.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //await SharedPreferences.getInstance();
  setupAsyncDependencies();
  configureDependencies();
  //await getIt.allReady();

  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      //GlobalContext.ctx = context;
      final authService = getIt<JwtAuthenticationService>();
      return AuthenticationBloc(authService)..add(AppLoaded());
    },
    child: MyApp(),
  ));
}

class GlobalContext {
  static late BuildContext ctx;
}

class MyApp extends StatelessWidget {
  //static late  AuthenticationBloc _authBloc;

  static late MyApp _instance;

  static Route route() {
    print("Enrutando al login");
    return MaterialPageRoute<void>(builder: (context) {
      var authBloc = BlocProvider.of<AuthenticationBloc>(context);
      authBloc..add(SessionExpiredEvent());
      return _instance;
    });
  }

  MyApp() {
    _instance = this;
  }

  @override
  Widget build(BuildContext context) {
    //GlobalContext.ctx = context;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Authentication Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            GlobalContext.ctx = context;
            if (state is AuthenticationAuthenticated) {
              // show home page with authenticated user
              return HomePage(
                postRepository: PostRepository(),
                searchRepositories: SearchRepositories(),
                adminRepository: AdminRepository(),
                user: state.user, // pass authenticated user
              );
            }
            // otherwise show login page
            // ignore: prefer_const_constructors
            return LoginPage();
          },
        )
        /*
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          GlobalContext.ctx = context;
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage(
              postRepository: PostRepository(),
              searchRepositories: SearchRepositories(), user: null,
            );
          }
          // otherwise show login page
          // ignore: prefer_const_constructors
          return LoginPage();
        },
      ),*/
        );
  }
}
