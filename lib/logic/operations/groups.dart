import 'package:ikleeralles/logic/operations/abstract.dart';
import 'package:ikleeralles/network/auth/service.dart';
import 'package:ikleeralles/network/models/group.dart';

class GroupsOperation extends Operation<List<Group>> {


  @override
  Future<List<Group>> perform() {
    return AuthService().securedApi.getMyGroups();
  }

}