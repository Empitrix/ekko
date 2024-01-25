import 'package:ekko/config/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


InlineSpan getTableSpan({
	required BuildContext context,
	required String txt,
}){
	Map<String, Alignment> alignmentsMap = {
		"-:": Alignment.centerRight,
		":-": Alignment.centerLeft,
		":-:": Alignment.center,
		"-": Alignment.center,
	};

	List<String> lines = txt.split("\n");
	// essential need are not required 
	if(lines.length < 3){ return TextSpan(text: txt); }
	
	List<DataColumn> columns = [];
	List<DataRow> rows = [];
	List<Alignment> alignment = [];
	int idx = 0;

	// divider
	for(String i in lines[1].split("|")){
		if(i.trim().isEmpty){ continue; }
		for(String key in alignmentsMap.keys.toList()){
			if(i.trim().replaceAll(RegExp(r'\s'), "").replaceAll(RegExp(r'\-+'), "-") == key){
				alignment.add(alignmentsMap[key]!);
			}
		}
	}

	for(String column in lines[0].split("|")){
		if(column.trim().isEmpty){ continue; }
		idx ++;
		columns.add(
			DataColumn(
				numeric: idx != 1,
				label: Align(
					alignment: alignment[idx - 1],
					child: Text(
						column.trim(),
						style: Provider.of<ProviderManager>(context).defaultStyle.copyWith(
							fontWeight: FontWeight.bold,
							fontSize: Provider.of<ProviderManager>(context).defaultStyle.fontSize!
						),
					),
				)
			)
		);
	}

	List<String> cutRow = lines.sublist(2);
	for(int i = 0; i < cutRow.length; i++){
		List<DataCell> cells = [];
		idx = 0;
		for(String row in cutRow[i].split("|")){
			if(row.trim().isEmpty){ continue; }
			idx ++;
			cells.add(
				DataCell(
					Align(
						alignment: alignment[idx - 1],
						child: Text(
							row.trim(),
							style: Provider.of<ProviderManager>(context).defaultStyle
						),
					)
				)
			);
		}
		rows.add(DataRow(cells: cells, selected: i.isOdd));
	}

	DataTable dataTable = DataTable(
		border: TableBorder.all(
			color: Theme.of(context).colorScheme.inverseSurface,
			width: 1
		),
		showCheckboxColumn: true,
		columns: columns,
		rows: rows
	);
	// Add horizontal scroller for large rows
	return WidgetSpan(
		child: SingleChildScrollView(
			scrollDirection: Axis.horizontal,
			child: dataTable,
		)
	);
}

