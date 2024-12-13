import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/ImageConst.dart';
import '../updateDNS.dart';
import 'Logs.dart';

class DNSConfigurator extends StatefulWidget {
  @override
  _DNSConfiguratorState createState() => _DNSConfiguratorState();
}

class _DNSConfiguratorState extends State<DNSConfigurator> {
  final TextEditingController _dnsController = TextEditingController();
  final List<String> _dnsLogs = [];
  late FlutterLocalNotificationsPlugin _notificationsPlugin;
  ThemeMode _themeMode = ThemeMode.light; // Default theme mode

  @override
  void initState() {
    super.initState();
    _loadLogs();
    _initializeNotifications();
    _loadThemePreference();
  }

  @override
  void dispose() {
    _dnsController.dispose();
    super.dispose();
  }

  /// Load DNS Logs from SharedPreferences
  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dnsLogs.addAll(prefs.getStringList('dnsLogs') ?? []);
    });
  }

  /// Save DNS Logs to SharedPreferences
  Future<void> _saveLog(String log) async {
    final prefs = await SharedPreferences.getInstance();
    _dnsLogs.add(log);
    await prefs.setStringList('dnsLogs', _dnsLogs);
  }

  /// Initialize Notifications
  void _initializeNotifications() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings();
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);

    _notificationsPlugin.initialize(initializationSettings);
  }

  /// Show Notification
  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'dns_changes',
      'DNS Changes',
      channelDescription: 'Notification for successful DNS updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, title, body, notificationDetails);
  }

  /// Validate and Update DNS
  void _updateDNS() async {
    final dns = _dnsController.text.trim();
    if (!_isValidIPAddress(dns)) {
      _showErrorDialog(
          "Invalid IP Address", "Please enter a valid IPv4 or IPv6 address.");
      return;
    }

    try {
      final result = await DNSUpdater.updateDNS(dns);
      final timestamp = DateTime.now().toIso8601String();
      final log = "[$timestamp] DNS Updated to: $dns";
      await _saveLog(log);
      _showNotification(
          "DNS Updated", "Your DNS has been successfully updated to $dns.");
    } catch (e) {
      _showErrorDialog("Error", e.toString());
    }

    setState(() {
      _dnsController.clear();
    });
  }

  /// Validate IP Address
  bool _isValidIPAddress(String ip) {
    final ipv4Pattern =
        r'^((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$';
    final ipv6Pattern =
        r'^([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|(([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4})$';
    return RegExp(ipv4Pattern).hasMatch(ip) || RegExp(ipv6Pattern).hasMatch(ip);
  }

  /// Error Dialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  /// Show Logs Page
  void _showLogs() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogsPage(logs: _dnsLogs),
      ),
    );
  }

  /// Load Theme Preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = (prefs.getBool('isDarkMode') ?? false)
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  /// Save Theme Preference to SharedPreferences
  Future<void> _saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  /// Toggle Theme Mode
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      _saveThemePreference(_themeMode == ThemeMode.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: Scaffold(
        backgroundColor: _themeMode==ThemeMode.dark?Color(0xFFFFFFFF):Colors.black,
        appBar: AppBar(
          backgroundColor: Color(0xff2E3787),
          centerTitle: true,
          title: const Text("DNS Configurator",
          style: TextStyle(
            color: Colors.white
          ),),
          actions: [
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: Colors.white,
              ),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(),
                  InkWell(
                    onTap: () {
                      _showLogs();
                    },
                    child: Container(
                      height: width * 0.04,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(
                          color: _themeMode == ThemeMode.dark ? Colors.blueAccent : Colors.blueAccent, // Dynamic border color
                          width: 2.0,
                        ),
                      ),
                      child: Center(
                          child: Text(
                              "Logs Notification",
                          style: TextStyle(
                            fontSize: width*0.014,
                            fontWeight: FontWeight.w500,
                            color: _themeMode==ThemeMode.dark?Colors.black:Colors.white
                          ),)), // Navigate to Logs Page
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: width * 0.01,
              ),
              Hero(
                tag: 'tag',
                child: CircleAvatar(
                  radius: width * 0.05,
                  backgroundImage: AssetImage(ImageConst.dns),
                ),
              ),
              SizedBox(height: width * 0.02),
              SizedBox(
                height: width * 0.2,
                width: width * 0.3,
                child: TextField(
                  controller: _dnsController,
                   style: TextStyle(
                     color:   _themeMode==ThemeMode.dark?Colors.black:Colors.white
                   ),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color:  _themeMode==ThemeMode.dark?Colors.black:Colors.white
                    ),
                    hintText: "e.g., 8.8.8.8 or 2001:4860:4860::8888",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _updateDNS();
                },
                child: Container(
                  width: width * 0.1,
                  height: width * 0.04,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      gradient: LinearGradient(
                          colors: [CupertinoColors.activeBlue, Colors.blue])),
                  child: Center(
                    child: Text(
                      "Update DNS",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: width * 0.01),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
