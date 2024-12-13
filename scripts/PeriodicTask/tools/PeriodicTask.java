package tools;

import java.io.File;
import java.util.Calendar;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class PeriodicTask {
	public static void main(String[] args) {
		if(args == null || args.length < 2) {
			System.out.println("Usage PeriodicTask period_in_minutes path_script_pwsh");
			System.exit(1);
			return;
		}
		
		int period = 30;
		try {
			period = Integer.parseInt(args[0]);
		}
		catch(Exception ex) {
			System.out.println("First argument is not a number: " + args[0] + ", default period = " + period);
		}
		
		String scriptPath = args[1];
		File file = new File(scriptPath);
		if(!file.exists()) {
			System.out.println(args[1] + " not exists.");
			System.exit(1);
			return;
		}
		if(!file.isFile()) {
			System.out.println(args[1] + " is not a file.");
			System.exit(1);
			return;
		}
		
		Runnable task = () -> {
			try {
				ProcessBuilder processBuilder = null;
				String script = file.getAbsolutePath();
				if(script.endsWith(".ps1")) {
					log("powershell.exe -File " + file.getAbsolutePath() + "...");
					processBuilder = new ProcessBuilder("powershell.exe", "-File", script);
				}
				else if(script.endsWith(".exe")) {
					log(script + "...");
					processBuilder = new ProcessBuilder(script);
				}
				else {
					log("cmd.exe /C start " + file.getAbsolutePath() + "...");
					processBuilder = new ProcessBuilder("cmd.exe", "/C", "start", script);
				}
				Process process = processBuilder.start();
				int exitCode = process.waitFor();
				log("exitCode: " + exitCode);
			} 
			catch (Exception e) {
				log("Exception: " + e.getMessage());
				e.printStackTrace();
			}
		};
		
		int initialDelay = 0;
		ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
		scheduler.scheduleAtFixedRate(task, initialDelay, period, TimeUnit.MINUTES);
		Runtime.getRuntime().addShutdownHook(new Thread(() -> {
			log("shutdown...");
			scheduler.shutdown();
			try {
				if (!scheduler.awaitTermination(5, TimeUnit.SECONDS)) {
					log("shutdownNow...");
					scheduler.shutdownNow();
				}
			} catch (InterruptedException e) {
				scheduler.shutdownNow();
			}
		}));
	}
	
	protected static void log(String message) {
		Calendar cal = Calendar.getInstance();
		int iYear  = cal.get(Calendar.YEAR);
		int iMonth = cal.get(Calendar.MONTH) + 1;
		int iDay   = cal.get(Calendar.DATE);
		int iHour  = cal.get(Calendar.HOUR_OF_DAY);
		int iMin   = cal.get(Calendar.MINUTE);
		int iSec   = cal.get(Calendar.SECOND);
		String sYear   = String.valueOf(iYear);
		String sMonth  = iMonth < 10 ? "0" + iMonth : String.valueOf(iMonth);
		String sDay    = iDay   < 10 ? "0" + iDay   : String.valueOf(iDay);
		String sHour   = iHour  < 10 ? "0" + iHour  : String.valueOf(iHour);
		String sMin    = iMin   < 10 ? "0" + iMin   : String.valueOf(iMin);
		String sSec    = iSec   < 10 ? "0" + iSec   : String.valueOf(iSec);
		String ts = sYear + "-" + sMonth + "-" + sDay + " " + sHour + ":" + sMin + ":" + sSec;
		System.out.println(ts + " " + message);
	}
}
