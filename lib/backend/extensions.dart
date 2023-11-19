extension StringExtensions on String { 
	String title() { 
		return "${this[0].toUpperCase()}${substring(1)}"; 
	}
}
