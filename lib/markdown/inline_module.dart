import 'package:ekko/markdown/tools/key_manager.dart';
import 'package:ekko/models/rule.dart';
import 'package:flutter/material.dart';


class GeneralOption {
	final BuildContext context;
	final GlobalKeyManager keyManager;
	final Map variables;
	final int noteId;
	final Function hotRefresh;

	GeneralOption({
		required this.context,
		required this.keyManager,
		required this.variables,
		required this.noteId,
		required this.hotRefresh
	});
}

class InlineModule {
	final String text;
	final RuleOption opt;
	final GeneralOption gOpt;

	InlineModule(
		this.text,
		this.opt,
		this.gOpt
	);

	InlineSpan span(){
		return TextSpan(text: text, style: opt.forceStyle);
	}

}
