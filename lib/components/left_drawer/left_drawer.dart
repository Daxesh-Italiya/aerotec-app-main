import 'package:aerotec_flutter_app/providers/user_provider.dart';
import 'package:aerotec_flutter_app/screens/authentication/login.dart';
import 'package:aerotec_flutter_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:aerotec_flutter_app/components/left_drawer/account_settings.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {


  Future _logout() async{
    bool res = await AuthService.logout();
    if(res) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Container(
                width: 100,
                height:100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.black,
                    width: 1
                  ),
                ),
                child: ClipOval(
                  // child: userProvider.user!.imageUrl.isEmpty ? Icon(Icons.person) : Image.network(userProvider.user!.imageUrl, fit: BoxFit.cover)
                )
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Account Settings'),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AccountSettings()));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            trailing: Icon(Icons.exit_to_app),
            onTap: _logout,
          ),
          Divider(),
        ],
      ),
    );
  }
}
