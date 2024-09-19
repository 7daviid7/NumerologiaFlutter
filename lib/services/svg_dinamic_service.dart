import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart' as xml;

class SvgDynamicRenderer extends StatefulWidget {
  final double width;
  final double height;
  final String svgName;
  final int dia;
  final int mes;
  final int any;
  final int vida;
  final Map<int, int> mapFigura;

  SvgDynamicRenderer({
    required this.width,
    required this.height,
    required this.svgName,
    required this.dia,
    required this.mes,
    required this.any,
    required this.vida,
    required this.mapFigura,
  });

  @override
  _SvgDynamicRendererState createState() => _SvgDynamicRendererState();
}

class _SvgDynamicRendererState extends State<SvgDynamicRenderer> {
  String? _svgString;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    try {
      final String rawSvg = await rootBundle.loadString('assets/${widget.svgName}.svg');
      final xml.XmlDocument document = xml.XmlDocument.parse(rawSvg);

      // Troba l'element amb l'ID 'braçDret' i canvia el seu color de farciment a vermell
      final xml.XmlElement? bracDretElement = _findElementById(document, 'bracDret');
      if (bracDretElement != null) {
        bracDretElement.setAttribute('fill', 'red');
      }

      setState(() {
        _svgString = document.toXmlString();
      });
    } catch (e) {
      print('Error loading SVG: $e');
    }
  }

  xml.XmlElement? _findElementById(xml.XmlDocument document, String id) {
    return document.descendants
        .whereType<xml.XmlElement>()
        .firstWhereOrNull((element) => element.getAttribute('id') == id);
  }

  @override
  Widget build(BuildContext context) {
    return _svgString != null
        ? SvgPicture.string(
            _svgString!,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.contain,
          )
        : CircularProgressIndicator();
  }
}

extension IterableExtensions<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
