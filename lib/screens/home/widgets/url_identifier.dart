bool isValidUrl(String url) {
  const urlPattern = r'^(https?:\/\/)?' 
      r'([a-zA-Z0-9-_]+\.)+[a-zA-Z]{2,}'
      r'(:\d+)?(\/.*)?$';
  final regExp = RegExp(urlPattern);

  return regExp.hasMatch(url);
}
