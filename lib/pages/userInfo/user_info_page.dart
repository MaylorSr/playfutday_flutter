import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';

import '../../blocs/userInfo/user_info.event.dart';
import '../../blocs/userInfo/user_info_ubloc.dart';
import 'destails_state.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final adminRepository = AdminRepository();
        return UserInfoDetailsBloc(adminRepository)
          ..add(UserInfoDetailFetched(id));
      },
      child: UserInfoDetailsL(),
    );
  }
}
