import 'package:flutter/material.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';

final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
//void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Sistem Informasi Mahasiswa';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state.
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final NIMControl = TextEditingController();
  final PasswordControl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    NIMControl.dispose();
    PasswordControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Sistem Informasi Mahasiswa'),
      ),
      body: SingleChildScrollView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset("images/logo-ftik.png")))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "NIM",
                      hintText: "Masukkan NIM Anda"),
                  controller: NIMControl,
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      hintText: "Masukkan Password Anda"),
                  controller: PasswordControl,
                )),
            Container(
                margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)),
                child: TextButton(
                    onPressed: () {
                      //TODO Firebase Login
                      String NIM = NIMControl.text;
                      String Password = PasswordControl.text;

                      _databaseReference
                          .child("Mahasiswa")
                          .child(NIM)
                          .get()
                          .then((snapshot) {
                        Map<dynamic, dynamic> data =
                            snapshot.value as Map<dynamic, dynamic>;
                        String dbPass = data['password'];
                        if (Password == dbPass) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Berhasil"),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new ProfilePage(NIM: NIM)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Login Gagal"),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      });
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ))),
            TextButton(
                onPressed: () {
                  // TODO Firebase Register
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new RegisterPage()));
                },
                child: Text("Daftar Akun Mahasiswa",
                    style: TextStyle(color: Colors.blue, fontSize: 15)))
          ],
        ),
      ),
    );
  }
}
