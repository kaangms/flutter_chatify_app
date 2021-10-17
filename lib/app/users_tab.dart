import 'package:flutter/material.dart';
import 'package:flutter_chatify_app/app/chats.dart';
import 'package:flutter_chatify_app/view_model/all_users_view_model.dart';
import 'package:flutter_chatify_app/view_model/chat_view_model.dart';
import 'package:flutter_chatify_app/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({Key? key}) : super(key: key);

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.allUsers!.length == 1) {
                    return _IsThereAnyUser();
                  } else if (model.hasMoreLoading &&
                      index == model.allUsers!.length) {
                    return _newUsersAddedProgressIndicator();
                  } else {
                    return _createListUser(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.allUsers!.length + 1
                    : model.allUsers!.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _createListUser(int index) {
    final _userModel = Provider.of<UserModel>(context);
    final _users = Provider.of<AllUserViewModel>(context);
    var _snapUser = _users.allUsers![index];

    if (_snapUser.userID == _userModel.user!.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => ChatViewModel(
                  currentUser: _userModel.user!, chattedUser: _snapUser),
              child: ChatPage(),
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_snapUser.userName!),
          subtitle: Text(_snapUser.email!),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_snapUser.profilURL!),
          ),
        ),
      ),
    );
  }

  _newUsersAddedProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _IsThereAnyUser() {
    final _kullanicilarModel = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _kullanicilarModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.supervised_user_circle,
                  color: Theme.of(context).primaryColor,
                  size: 120,
                ),
                Text(
                  "Henüz Kullanıcı Yok",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }

  void _listScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      bringMoreUsers();
    }
  }

  void bringMoreUsers() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUserViewModel = Provider.of<AllUserViewModel>(context);
      await _allUserViewModel.bringMoreUsers();
      _isLoading = false;
    }
  }
}
