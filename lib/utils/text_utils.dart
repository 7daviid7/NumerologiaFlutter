String stripMarkdown(String text) {
  // 1. Remove headers (### Title, ## Title, # Title)
  // We use multiline mode to ensure ^ matches start of line
  var result = text.replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '');

  // 1b. Replace horizontal rules (---, ***, ___) with long underscore line
  result = result.replaceAll(RegExp(r'^(\*{3,}|-{3,}|_{3,})$', multiLine: true),
      '___________________________________________________________________________');

  // 2. Remove bold/italic markers (**text**, *text*, __text__, _text_)
  // Note: This is a simple regex and might not handle all nested edge cases perfectly,
  // but suffices for general cleanup.
  result = result.replaceAllMapped(
      RegExp(r'\*\*([^*]+)\*\*'), (m) => m.group(1) ?? ''); // **bold**
  result = result.replaceAllMapped(
      RegExp(r'\*([^*]+)\*'), (m) => m.group(1) ?? ''); // *italic*
  result = result.replaceAllMapped(
      RegExp(r'__([^_]+)__'), (m) => m.group(1) ?? ''); // __bold__
  result = result.replaceAllMapped(
      RegExp(r'_([^_]+)_'), (m) => m.group(1) ?? ''); // _italic_

  // 3. Remove list bullets at start of line
  // Use replaceAll is fine here as we are replacing with empty string
  result = result.replaceAll(RegExp(r'^[\*\-\+]\s+', multiLine: true), '');

  // 4. Remove blockquotes
  result = result.replaceAll(RegExp(r'^>\s+', multiLine: true), '');

  // 5. Remove code blocks
  result = result.replaceAll(RegExp(r'```[\s\S]*?```'), '');
  // Optionally, if we want to keep the content of code blocks but remove fences:
  // result = result.replaceAll(RegExp(r'```.*?\n([\s\S]*?)```'), r'$1');

  // 6. Remove inline code (`code`)
  result =
      result.replaceAllMapped(RegExp(r'`([^`]+)`'), (m) => m.group(1) ?? '');

  // 7. Remove links [text](url) -> text
  result = result.replaceAllMapped(
      RegExp(r'\[([^\]]+)\]\([^\)]+\)'), (m) => m.group(1) ?? '');

  // Clean up extra whitespace that might have been left behind
  // result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return result.trim();
}
