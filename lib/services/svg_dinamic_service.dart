import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:numerologia/constants/svg_constants_identifiers.dart';
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
  // ignore: library_private_types_in_public_api
  _SvgDynamicRendererState createState() => _SvgDynamicRendererState();
}

class _SvgDynamicRendererState extends State<SvgDynamicRenderer> {
  String? _svgString;
  String? _pintar; 
  int?any0, any1, dia0,dia1, mes0,mes1; 


  @override
  void initState() {
    super.initState();
    any0=widget.any ~/ 10;
    any1= widget.any %10; 
    dia0 = widget.dia ~/ 10;  // Obtenir la primera xifra del dia
    dia1 = widget.dia % 10;    // Obtenir la segona xifra del dia
    mes0 = widget.mes ~/ 10;  // Obtenir la primera xifra del mes
    mes1 = widget.mes % 10;    // Obtenir la segona xifra del mes
    _loadSvg();
  }

  Future<void> _loadSvg() async {
    try {
      final String rawSvg = await rootBundle.loadString('assets/${widget.svgName}.svg');
      final xml.XmlDocument document = xml.XmlDocument.parse(rawSvg);

      _pintarSvg(document);

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

  void _pintarSvg(xml.XmlDocument document)
  {
    _pintar= '#FF6347';
    widget.mapFigura.forEach((key, value) 
    {
      if(key==dia0 || key==dia1 || key==mes0 || key==mes1 || key==any0 ||key==any1)
      {
        _escollirColorVermell(key);
        _switchCaseComplet(key, document);
      }
      
      if(value== dia0 || value== dia1 || value==mes0 || value==mes1 || value==any0 || value==any1)
      {
        _escollirColorBlau(value);
        _switchCaseMeitat(key, document);
      }
      
    });

  }

 void _escollirColorVermell(int key) {
  int conditionsMet = 0;
  // Comprova quantes condicions es compleixen
  if (key == dia0) conditionsMet++;
  if (key == dia1) conditionsMet++;
  if (key == mes0) conditionsMet++;
  if (key == mes1) conditionsMet++; 
  if (key == any0) conditionsMet++; 
  if (key == any1) conditionsMet++; 

  // Assigna el color en funció del nombre de condicions que es compleixen
  switch (conditionsMet) {
    case 1:
      _pintar = '#FFA07A'; // Vermell molt clar (LightSalmon)
    case 2:
      _pintar = '#FF4500'; // Vermell clar (OrangeRed)
    case 3:
      _pintar = '#B22222'; // Vermell més intens (FireBrick)
    case 4:
      _pintar = '#8B0000'; // Vermell molt fosc (DarkRed)
  }
}


  void _escollirColorBlau(int key) {
  int conditionsMet = 0;

  // Comprova quantes condicions es compleixen
  if (key == dia0) conditionsMet++;
  if (key == dia1) conditionsMet++;
  if (key == mes0) conditionsMet++;
  if (key == mes1) conditionsMet++; 
  if (key == any0) conditionsMet++; 
  if (key == any1) conditionsMet++; 

  // Assigna el color en funció del nombre de condicions que es compleixen
  switch (conditionsMet) {
    case 1:
      _pintar = '#B0E0E6'; // Blau molt clar (PowderBlue)
    case 2:
      _pintar = '#4682B4'; // Blau mig (SteelBlue)
    case 3:
      _pintar = '#1E90FF'; // Blau més intens (DodgerBlue)
    case 4:
      _pintar = '#000080'; // Blau molt fosc (Navy)
  }
}

  
  void _switchCaseComplet(int key, xml.XmlDocument document)
  {
    switch(key)
        {
          case  SvgIdentifiers.CAP_DRET:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'capDret');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case  SvgIdentifiers.CAP_ESQUERRE:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'capEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case  SvgIdentifiers.BRAC_ESQUERRE: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'bracEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.PANXA_ESQUERRE: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'panxaEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CADERA:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'cadera');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CAMA_ESQUERRE:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'camaEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CAMA_DRETA: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'camaDreta');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.PANXA_DRETA:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'panxaDreta');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.BRAC_DRET:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'bracDret');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
        }
  }
  void _switchCaseMeitat(int key, xml.XmlDocument document)
  {
    switch(key)
        {
          case  SvgIdentifiers.CAP_DRET:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatCapDret');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case  SvgIdentifiers.CAP_ESQUERRE:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatCapEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case  SvgIdentifiers.BRAC_ESQUERRE: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatBracEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.PANXA_ESQUERRE: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatPanxaEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CADERA:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatCadera');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CAMA_ESQUERRE:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatCamaEsquerre');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.CAMA_DRETA: 
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatCamaDreta');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.PANXA_DRETA:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatPanxaDreta');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
          case SvgIdentifiers.BRAC_DRET:
          {
            final xml.XmlElement? bracDretElement = _findElementById(document, 'meitatBracDret');
            if (bracDretElement != null) {
              bracDretElement.setAttribute('fill', _pintar);
            }
          }
        }
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
