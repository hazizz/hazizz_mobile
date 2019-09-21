package dev.pharsh.logcat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * LogcatPlugin
 */
public class LogcatPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "app.channel.logcat");
        channel.setMethodCallHandler(new LogcatPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("execLogcat")) {
            String logs = getLogs();
            if (logs != null) {
                result.success(logs);
            } else {
                result.error("UNAVAILABLE", "logs not available.", null);
            }
        } else {
            result.notImplemented();
        }
    }

    String getLogs() {
        try {
            Process process = Runtime.getRuntime().exec("logcat -d");
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));

            StringBuilder log = new StringBuilder();
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                log.append(line);
                log.append("\n");
            }
            return log.toString();
        } catch (IOException e) {
            return "EXCEPTION" + e.toString();
        }
    }
}
