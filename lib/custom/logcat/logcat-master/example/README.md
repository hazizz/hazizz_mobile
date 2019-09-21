# logcat_example

Demonstrates how to use the logcat plugin.

```sh
  Future<void> _getLogs() async {
    final String logs = await Logcat.execute();
    setState(() {
      // Update your UI
    });
  }
```