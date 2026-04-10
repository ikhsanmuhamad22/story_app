String formatDate(String isoString) {
  DateTime dateTime = DateTime.parse(isoString).toLocal();
  String formattedDate =
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  return formattedDate;
}
