import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  final List<String> logs;

  const LogsPage({Key? key, required this.logs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white // Dynamic icon color
          ),
        ),
        title: const Text(
          "DNS Change Logs",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff2E3787), // Consistent AppBar color
      ),
      body: logs.isEmpty
          ? Center(
        child: Text(
          "No logs available.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0), // Added padding
        itemCount: logs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0), // Spacing between items
            child: ListTile(
              title: Text(
                logs[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              tileColor: isDarkMode
                  ? const Color(0xFF1E1E1E) // Subtle gray for dark mode
                  : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          );
        },
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}
