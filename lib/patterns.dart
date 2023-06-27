// ignore_for_file: constant_identifier_names

enum Patterns {
  CHECKBOX_LIST_PATTERN(r"- (\[ \]) (.+)"),
  CHECKBOX_LIST_DONE_PATTERN(r"- (\[x]) (.+)"),
  BOLD_TEXT_PATTERN(r"\*\*(.*?)\*\*"),
  HEADERS_PATTERN(r"(#{1,6}\s)(.*)"),
  CODE_PATTERN(r"```[\s\S]*?```"),
  URL_PATTERN(r"\[([^\]]+)\]\((https?:\/\/[^\)]+)\)(?: - (.+))?");

  final String pattern;
  const Patterns(this.pattern);
}
