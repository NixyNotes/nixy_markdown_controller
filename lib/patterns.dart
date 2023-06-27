// ignore_for_file: constant_identifier_names,  public_member_api_docs

enum Patterns {
  CHECKBOX_LIST_PATTERN(r'- (\[ \]) (.+)'),
  CHECKBOX_LIST_DONE_PATTERN(r'- (\[x]) (.+)'),
  BOLD_TEXT_PATTERN(r'\*\*(.*?)\*\*'),
  HEADERS_PATTERN(r'(#{1,6}\s)(.*)'),
  CODE_PATTERN(r'```[\s\S]*?```'),
  URL_PATTERN(r'\[([^\]]+)\]\((https?:\/\/[^\)]+)\)(?: - (.+))?');

  const Patterns(this.pattern);
  final String pattern;
}
