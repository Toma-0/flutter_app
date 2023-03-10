import "../state/import.dart";

class Navi {
  void syukkin(context, oshi) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SyukkinPage(oshi: oshi)),
    );
  }

  void button(context, oshi) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ButtonPage(oshi: oshi)),
    );
  }

  void chokin(context, oshi) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChokinPage(oshi: oshi)),
    );
  }

  void calender(context, oshi) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Calender(oshi: oshi)),
    );
  }

  void sns(context, oshi) {
    print("null");
  }

  void setting(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }
}
