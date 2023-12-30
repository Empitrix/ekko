import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/* Custom URL Launcher */
Future<void> launchThis({
	required BuildContext context, required String url})async{
	try{
		await launchUrl(
			Uri.parse(url),
			mode: LaunchMode.externalApplication
		);
	}catch(e){
		// Failed to launch URL
	}
}

