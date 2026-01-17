import 'package:numerologia/utils/text_utils.dart'; // Adjust path if needed, but since we run locally we might need to copy the function in or run in context.

// Actually, to avoid path dependency issues in a standalone script, I'll just copy the function here for testing.

String stripMarkdown(String text) {
  // 1. Remove headers (### Title, ## Title, # Title)
  // We use multiline mode to ensure ^ matches start of line
  var result = text.replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '');

  // 2. Remove bold/italic markers (**text**, *text*, __text__, _text_)
  // Note: This is a simple regex and might not handle all nested edge cases perfectly,
  // but suffices for general cleanup.
  result = result.replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1'); // **bold**
  result = result.replaceAll(RegExp(r'\*([^*]+)\*'), r'$1'); // *italic*
  result = result.replaceAll(RegExp(r'__([^_]+)__'), r'$1'); // __bold__
  result = result.replaceAll(RegExp(r'_([^_]+)_'), r'$1'); // _italic_

  // 3. Remove list bullets (* item, - item, + item) at start of line
  result = result.replaceAll(RegExp(r'^[\*\-\+]\s+', multiLine: true), '');

  // 4. Remove blockquotes (> text)
  result = result.replaceAll(RegExp(r'^>\s+', multiLine: true), '');

  // 5. Remove code blocks (```code```)
  result = result.replaceAll(RegExp(r'```[\s\S]*?```'), '');
  // Optionally, if we want to keep the content of code blocks but remove fences:
  // result = result.replaceAll(RegExp(r'```.*?\n([\s\S]*?)```'), r'$1');

  // 6. Remove inline code (`code`)
  result = result.replaceAll(RegExp(r'`([^`]+)`'), r'$1');

  // 7. Remove links [text](url) -> text
  // result = result.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');
  // Fixed regex for links to be more robust?
  result = result.replaceAll(RegExp(r'\[([^\]]+)\]\([^\)]+\)'), r'$1');

  // Clean up extra whitespace that might have been left behind
  // result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return result.trim();
}

void main() {
  const input = '''
### Header 1
This is a **bold** text and *italic* text.
Here is a list:
* Item 1
* Item 2
- Item 3

> Blockquote here

Link: [Google](https://google.com)

Code: `print("hello")`
''';

  print("ORIGINAL:");
  print(input);
  print("-" * 20);
  print("STRIPPED:");
  print(stripMarkdown(input));
}
