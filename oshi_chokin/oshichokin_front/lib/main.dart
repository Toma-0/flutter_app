import 'state/import.dart';

import 'setting.dart';

import 'home.dart';
import 'sign_in.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    ProviderScope(
        child: MaterialApp(
      home:MyApp(),
    )),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with SingleTickerProviderStateMixin {
  @override
  void dispose() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print("sign_in");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Sign_in(),
          ),
        );
      } else {
        print("home");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WindowSize().init(context);
    double x = WindowSize.w! * 25;
    double y = WindowSize.h! * 25;
    dispose();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
