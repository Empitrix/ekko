import 'package:ekko/backend/backend.dart';
import 'package:ekko/backend/behaviors.dart';
import 'package:ekko/components/nf_icons.dart';
import 'package:ekko/components/sheets.dart';
import 'package:ekko/components/tag.dart';
import 'package:ekko/config/manager.dart';
import 'package:ekko/config/navigator.dart';
import 'package:ekko/config/public.dart';
import 'package:ekko/models/note.dart';
import 'package:ekko/views/display_page.dart';
import 'package:ekko/views/land_page.dart';
import 'package:ekko/views/modify_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteItem extends StatelessWidget {
	final SmallNote note;
	final Function backLoad;
	
	const NoteItem({
		super.key,
		required this.note,
		required this.backLoad
	});

	@override
	Widget build(BuildContext context) {
		if(!note.isVisible){
			return Container();
		}
		GlobalKey thisKey = GlobalKey();
		return Listener(
			onPointerDown: isDesktop() ? (pointer){
				if(pointer.buttons == 2){
					// show
					generalSmallNoteSheet(
						context: context, load: backLoad, note: note);
				}
			} : null,
			child: InkWell(
				onTap: () => changeView(
					context, DisplayPage(
						smallNote: note,
						previousPage: const LandPage(),
						previousPageName: "LandPage",
						loadAll: backLoad,
					),
					"DisplayPage",
					isPush: true
				),
				onLongPress: isDesktop() ? null : (){
					generalSmallNoteSheet(
						context: context, load: backLoad, note: note);
				},
				
				// Child widget
				child: Container(
					padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
					key: thisKey,
					child: Row(
						children: [
							Badge(
								backgroundColor: dMode ? 
									const Color(0xffed3232):
									const Color(0xffbf1111),
								label: Transform.rotate(
									angle: getAngle(45),
									child: NfFont(
										unicode: "\udb81\udc03",
										color: Colors.white,
										format:false).widget(),
								),
								isLabelVisible: note.isPinned,
								child: IconButton(
									icon: const Icon(Icons.edit),
									color: Theme.of(context).primaryColor,
									onPressed: (){
										changeView(
											context,
											ModifyPage(
												note: note,
												folderId: note.folderId,
												backLoad: backLoad,
												previousPage: const LandPage(),
												previousPageName: "LandPage",
											),
											"ModifyPage",
											isPush: true
										);
									}
								),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.start,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											note.title,
											overflow: TextOverflow.ellipsis,
											style: TextStyle(
												fontSize: 16,
												letterSpacing: Provider.of<ProviderManager>(context).defaultStyle.letterSpacing,
												color: Theme.of(context)
													.colorScheme
													.inverseSurface,
												fontWeight: FontWeight.bold,
											),
										),

										// // {@Date}
										// Text(
										// 	differenceFromNow(note.lastEdit),
										// 	style: Provider.of<ProviderManager>(context).defaultStyle.merge(
										// 		TextStyle(
										// 			fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize! - 4,
										// 			color: dMode ? Colors.teal : Colors.teal[800],
										// 			fontWeight: FontWeight.w700
										// 		)
										// 	),
										// ),

										// {@Tags}
										Wrap(
											crossAxisAlignment: WrapCrossAlignment.center,
											children: [
												for(String tag in note.description.trim().split(" ")) TextTag(
													// context: context, 
													tag: tag,
													// margin: const EdgeInsets.only(right: 5, top: 5),
													// padding: const EdgeInsets.symmetric(horizontal: 5),
												),
											],
										),
									],
								)
							),
							const SizedBox(width: 12),

							FutureBuilder<Size>(
								future: getParrentSize(thisKey),
								builder: (BuildContext context, AsyncSnapshot<Size> h){
									if(!h.hasData){ return const SizedBox(); }
									return Column(
										children: [
											SizedBox(height: h.data!.height == 0 ? 0 : h.data!.height - 40, width: 30),
											Text(
												// differenceFromNow(note.lastEdit),
												formatizeVDate(differenceFromNow(note.lastEdit)),
												style: Provider.of<ProviderManager>(context).defaultStyle.merge(
													TextStyle(
														fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize! - 4,
														color: dMode ? Colors.teal : Colors.teal[800],
														fontWeight: FontWeight.w700
													)
												),
											),
										],
									);
								},
							),

							// IconButton(
							// 	icon: Icon(noteModeIcon(note.mode)),
							// 	color: Theme.of(context).primaryColor,
							// 	onPressed: (){/* Note Actons */},
							// ),
						],
					),
				),
			)
		);
	}
}
