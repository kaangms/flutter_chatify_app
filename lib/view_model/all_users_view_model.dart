import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/locator.dart';
import 'package:flutter_chatify_app/model/auth_user.dart';
import 'package:flutter_chatify_app/repository/user_repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<AuthUser>? _allUsers;
  AuthUser? _lastBroughtUser;
  static final _numberOfUserToFetch = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();
  List<AuthUser>? get allUsers => _allUsers;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _allUsers = [];
    _lastBroughtUser = null;
    getUserWithPagination(_lastBroughtUser, false);
  }

  //refresh ve sayfalama için
  //yenielemanlar getir true yapılır
  //ilk açılıs için yenielemanlar için false deger verilir.
  getUserWithPagination(
      AuthUser? lastBroughtUser, bool newUserssBringing) async {
    if (_allUsers!.length > 0) {
      _lastBroughtUser = _allUsers!.last;
      print("en son getirilen username:" + _lastBroughtUser!.userName!);
    }

    if (newUserssBringing) {
    } else {
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUserWithPagination(
        _lastBroughtUser, _numberOfUserToFetch);

    if (yeniListe.length < _numberOfUserToFetch) {
      _hasMore = false;
    }

    //yeniListe.forEach((usr) => print("Getirilen username:" + usr.userName));

    _allUsers!.addAll(yeniListe);

    state = AllUserViewState.Loaded;
  }

  Future<void> bringMoreUsers() async {
    // print("Daha fazla user getir tetiklendi - viewmodeldeyiz -");
    if (_hasMore) getUserWithPagination(_lastBroughtUser, true);
    //else
    //print("Daha fazla eleman yok o yüzden çagrılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _lastBroughtUser = null;
    _allUsers = [];
    getUserWithPagination(_lastBroughtUser, true);
  }
}
