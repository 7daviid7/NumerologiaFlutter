import 'package:flutter/material.dart';

class NumerologyItem {
  final String id;
  final String title;
  final String shortDesc;
  final String fullDesc;
  final String? bodyPart;
  final String? excessTrap;
  final Color color;
  final IconData icon;
  final String? angel; // For Sefirot
  final String? planet; // For Sefirot

  const NumerologyItem({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.fullDesc,
    this.bodyPart,
    this.excessTrap,
    required this.color,
    required this.icon,
    this.angel,
    this.planet,
  });
}

class NumerologyContent {
  static const List<NumerologyItem> basicNumbers = [
    NumerologyItem(
      id: '1',
      title: 'El Pare / El Líder',
      shortDesc: 'Yang: Foc i Aire. Lideratge, independència, innovació.',
      fullDesc:
          'És la representació de la unitat, l\'origen del tot. La manifestació d\'una força nova. Representa l\'arquetip del PARE, referència psicològica molt important. És el pioner i el líder que obra els camins, que es llença amb decisió i autoritat als seus projectes. Injecta noves energies a les idees, i llença nous projectes intel·lectuals i mentals. Sempre vol ser el primer, i ser reconegut com el millor.',
      bodyPart:
          'Correspon a l\'hemisferi cerebral esquerra, que determina el costat dret del nostre cos. És el centre de la voluntat, del potencial intel·lectual i abstracte, del pensament lògic, de l\'acció.',
      excessTrap:
          'Orgullós, dominador, egoista, ambiciós, impacient, irritable, tirànic, inflexible, intolerant, exigent, implacable, insensible.',
      color: Color(0xFFFF5722), // Deep Orange (Fire/Sun)
      icon: Icons.emoji_objects,
    ),
    NumerologyItem(
      id: '2',
      title: 'La Mare / La Dualitat',
      shortDesc: 'Yin: Aigua i Terra. Sensibilitat, col·laboració.',
      fullDesc:
          'De la unitat de l\'1, passem a la dualitat del 2. Representa el principi femení. El dos, neix de l\'1, i forma amb ell un sistema binari. D\'aquesta manera, tenim dos pols: El Yang i el Yin.\n\nLa grafia d\'aquest número, està composta per corbes i línies rectes, per la qual cosa, indica la seva adaptabilitat i flexibilitat. És caracteritza per tenir una actitud de disponibilitat, sempre atent per escoltar i ser flexible. El número 2, vol ser i sentir, lentament, descobrint la seva afectivitat i sentiments interiors profunds. Té com a objectiu, donar i rebre.\n\nÉs el número de la feminitat i maternitat. Correspon a l\'arquetip de mare. Vol estimar i ser estimat, envoltar-se d\'amor, viure al nivell dels seus sentiments, de la seva tendresa. Té por a la soledat, i sempre està buscant la fusió amb algú altre. A més, sempre compte amb la capacitat d\'adaptar-se i d\'actuar amb molta intuïció i diplomàcia. A través de la seva delicadesa, de la seva virtut d\'escoltar i de poder acollir, pot arribar a canviar el curs de les coses i les opinions dels altres. ÉS EL NÚMERO DE LA COL·LABORACIÓ.\n\nPosseeix un gran potencial artístic gràcies a la seva sensibilitat i apertura al món de la imaginació i els somnis. No té confiança en si mateix, i necessita sempre la aprovació d\'algú altre per poder creure amb ell mateix. Sol viure amb complexa d\'inferioritat, a no ser que sigui reconegut per algú altre. És incapaç de suportar els conflictes, i per això prefereix callar i no expressar el que sent, per temor a ser rebutjat pels altres. S\'empassa les seves emocions, fins al punt d\'asfixiar-se i destruir-se.',
      bodyPart:
          'Correspon a l\'hemisferi cerebral dret, el món de la imaginació, la sensibilitat i la intuïció. Aquest hemisferi, determina la part esquerra del nostre cos, la part femenina i receptiva. Està relacionada també amb els òrgans dobles del cos, és a dir, els pulmons, els ronyons...',
      excessTrap:
          'Dubte, dualitat, complexa d\'inferioritat, falta d\'autoestima i autodestrucció, vulnerabilitat, descontrol de les emocions, dependència, rol de víctima i inseguretat.',
      color: Color(0xFF039BE5), // Light Blue (Water)
      icon: Icons.water_drop,
    ),
    NumerologyItem(
      id: '3',
      title: 'El Nen / La Comunicació',
      shortDesc: 'Yang. Comunicació, creativitat, alegria.',
      fullDesc:
          'El 3, és la unió de l\'1 i el 2. És un número perfecte, perquè conté la força de l\'1 (energia masculina), i la sensibilitat del 2 (energia femenina). Representa l\'arquetip del nen, fruit de la unió del pare i la mare.\n\nLa seva grafia està composta per corbes sensuals, amb tres puntes obertes que reflecteixen l\'intercanvi amb els altres:\n• En el cap: la comunicació verbal.\n• En el cor: la comunicació sentimental i emocional.\n• En el ventre: La comunicació corporal i el plaer.\n\nTé l\'art de comunicar-se i expressar-se a través de la seva veu, la seva paraula. Posseeix un do per ensenyar i transmetre el seus coneixements. En el pla artístic, pot emprendre qualsevol projecte, degut al seu talent, originalitat i el seu desenvolupat sentit estètic. Necessita estimar i ser estimat per TOTS. Li agrada complaure i destacar. Ser reconegut pel seu públic. La admiració dels altres és la seva força, però també pot convertir-se en la seva debilitat.\n\nQuan no se sent estimat i acceptat pels altres, pot tancar-se en si mateix, sofrir molt i tornar-se amargat i frustrat. Necessita estar envoltat pels seus amics, dels seus germans, de la seva família. Del seu grup de comunicació per compartir i gaudir de la vida en companyia. Està molt pendent de la mirada dels altres, i la necessita per tenir confiança en si mateix. LA SEVA IMATGE SOCIAL ÉS PRIMORDIAL, i quan aquest aspecte és torna obsessiu, pot arribar a convertir-se en una persona superficial.\n\nTé l\'art de viure bé el present. L\'AQUÍ I L\'ARA. És molt generós, li agrada compartir, és molt alegre, optimista i espontani. Adora les festes i les reunions, i posseeix un gran sentit de l\'humor. El seu públic li resulta tant indispensable, que pot passar la seva vida actuant en rols determinats, sense viure la seva pròpia identitat. Té dificultats per viure en soledat, ja que tem enfrontar-se a la seva pròpia veritat.',
      bodyPart:
          'Comunicació verbal (cap), sentimental (cor) i corporal (ventre).',
      excessTrap:
          'Frivolitat, superficialitat, agitació, dispersió, falta d’identitat, irresponsabilitat, vanitat, inestabilitat.',
      color: Color(0xFFFFC107), // Amber/Yellow (Light/Joy)
      icon: Icons.record_voice_over,
    ),
    NumerologyItem(
      id: '4',
      title: 'Les Arrels / L’Estructura',
      shortDesc: 'Yin: Terra. Estabilitat, treball, organització.',
      fullDesc:
          'El seu element és la terra, que la transforma a través del seu treball. És el número de la encarnació. La seva grafia és un conjunt de rectes, amb angles ben definits, que inspiren fermesa i seguretat. Una imatge que recorda al tro d’un rei.\n\nEl seu símbol, és el quadrat o el cub. Ens inspira estabilitat, equilibri i força. L’arquetip del 4 són les arrels. Representa la base sobre la qual construïm la nostra vida. La seva força radica en les normes establertes. Abans de donar un pas, necessita saber cap a on va dirigit. Per aquesta raó, a vegades avança molt lentament i li falta flexibilitat. És molt fidel, i sempre necessita aferrar-se a les tradicions de la seva terra natal i de la seva família. Com a conseqüència, se sent responsable del patrimoni material familiar. És el número del treball i la organització. Li agrada el treball ben fet, i dedicarà tots els seus esforços per complir els seus deures. Ha de tenir en compte, però, a no omplir-se de càrregues extres.',
      bodyPart: 'Esquelet i dents (la part dura del cos).',
      excessTrap:
          'Bloqueig mental i emocional, melancolia, rigidesa, obsessió per l’ordre, tosquedat, materialisme, obsessió per el treball, avarícia, inflexibilitat, dogmatisme i poca flexibilitat mental.',
      color: Color(0xFF388E3C), // Green (Earth/Roots)
      icon: Icons.foundation,
    ),
    NumerologyItem(
      id: '5',
      title: 'L’Aventurer / El Canvi',
      shortDesc: 'Yang: Mart. Llibertat, risc, energia vital.',
      fullDesc:
          'S’ubica a mig camí entre l’1 i el 9. Té l’energia exterior de l’1, obrint camins i lluitant en busca de nous reptes, i l’energia interior del 9, per la seva necessitat de reflexió. Està associat a Mart, el Déu de la guerra. La seva imatge és la d’un rei energètic que va a la batalla a fi de conquistar altres regnes: VIURE INSEGURETATS I CÓRRER RISCOS.\n\nEl seu símbol és el pentagrama, i la seva grafia consisteix en una barra horitzontal superior que representa el seu gran desenvolupament mental, la seva curiositat sense límits i la seva gran capacitat d’anàlisi. Aquesta barra, recolzada sobre una corba, representa l’energia vital i sexual. Per un número 5, el vital és sentir-se lliure de llaços innecessaris. Necessita galopar lliurement sense sentir-se empresonat sota convencionalismes i regles. És rebel amb el seu mode de pensar i viure. És conscient del poder de la seva energia, i ha d’aprendre a dominar-la i controlar-l. Així mateix, ha de mantenir fermes les rendes del seu cavall, amb molta disciplina i rigor, pel contrari, acabaria desbocat.\n\nSempre busca experiències noves pel pur plaer d’experimentar, però, encara que a vegades cremi les seves ales per volar massa a prop del sol, aquest sempre està llest per cobrar el preu dels seus errors. És molt honest, i sempre juga net. El número 5, ha de saber, que també té dificultats, doncs mai acaba els seus projectes personals, degut a que sempre s’impacienta i comença a interessar-se per altres projectes. Córrer el risc de convertir-se en un “picaflor”, que va de flor en flor en busca del no res. Per aquesta raó, és essencial que s’escolti a si mateix i mediti les seves decisions. És una aventurer per naturalesa, i sempre està disposat a viure tot tipus d’aventures i reptes físics/intel·lectuals. Se sent permanentment atret pels viatges i els descobriments d’altres cultures, però sempre necessita tornar als seus inicis. Degut a això, té el do dels idiomes.\n\nAquesta força vital, el pot portar a excessos: hiperactivitat, consumisme cultural... pot caure al descontrol, abusar de l’alcohol i el tabac, les drogues, realitzar experiències perilloses... el seu temperament explosiu el porta a situacions de risc. Per això, és important que el número cinc realitzi esport, per calmar aquesta hiperactivitat i equilibrar la seva energia.',
      bodyPart: 'Energia vital (Ki), energia sexual, part masculina Yang.',
      excessTrap:
          'Irritabilitat, violència, agressivitat, inconstància, llibertinatge, addiccions, perill, hiperactivitat.',
      color: Color(0xFFD32F2F), // Red (Mars/Energy)
      icon: Icons.explore,
    ),
    NumerologyItem(
      id: '6',
      title: 'L’Harmonia / L’Amor',
      shortDesc: 'Yin. Amor, família, bellesa, servei.',
      fullDesc:
          'És el centre de l’amor. El 6, es representa amb dos triangles encastats que formen el segell de Salomó, l’estrella de sis puntes.\n\nLa grafia del sis, és una única corba que s’embolcalla sobre si mateixa. La seva base rodona, representa un ventre, simbolisme de la fertilitat i de l’amor. Viu segons la seva sensibilitat i les seves emocions. És el número de la feminitat que aporta pau i harmonia. Ens convida al descans, a la flexibilitat i la apertura del cor. La seva prioritat i desig és donar, protegir i cuidar als altes. Per contra, li costa molt donar i rebre. Sovint arribar al sacrifici, oblidant-se de si mateix. Per evitar aquesta situació, el número sis ha d’amar-se i cuidar-se en primer lloc, per poder entregar un amor equilibrat i sa. Inclús, pot arribar a ser possessiu i manipular afectivament als altres, a fi d’aconseguir ser amat i amar. Pot arribar a tenir pànic ha ser abandonat pel seus éssers estimats.\n\nSe sentirà satisfet en professons que estan relacionades amb el cos i la salut, com per exemple medicina, estètica, massatgista... A més, posseeix un gran poder creatiu, i és capaç d’apreciar la bellesa visible i invisible dels sers.\n\nL’arquetip del sis, representa la forma de viure la nostre part femenina Yin. Degut a la seva gran sensibilitat és bastant vulnerable, i sol viure bastantes crisis d’identitat i desequilibris emocionals forts. A més, també pot caure en l’apatia i la comoditat, conformant-se i sen mandrós.',
      bodyPart: 'Plexe cardíac, cor (centre de les emocions).',
      excessTrap:
          'Vulnerabilitat, fragilitat, possessió, manipulació afectiva, gelosia, sacrifici, culpabilitat, obsessió, depressió, apatia i mandra.',
      color: Color(0xFFEC407A), // Pink (Love/Heart)
      icon: Icons.favorite,
    ),
    NumerologyItem(
      id: '7',
      title: 'El Místic / La Saviesa',
      shortDesc: 'Yang. Espiritualitat, perfecció, estudi.',
      fullDesc:
          'És el número de la espiritualitat. És l’enllaç entre l’humà i el diví. El número sagrat per excel·lència. Sol associar-se a la bellesa i a la perfecció, sovint també, a les victòries. El 7, ens introdueix en la bellesa espiritual, simbolitzada en el Sabbat (sèptim dia), quan Déu descansa per admirar la perfecció de la creació.\n\nEl 7 ens convida a trobar la unitat interior després d’un llarg aprenentatge personal que requereix autocontrol, exigència i una profunda concentració.\n\nLa seva grafia s’assembla al número 1, però amb un cap més desenvolupat, més sobrecarregat que sembla inclinar-se degut al seu pes de saber i coneixement. La seva base es fràgil i poc estable.\n\nTé un sentit de la bellesa i de l’estètica que l’impulsa a buscar permanentment l’elegància. És molt sensible a la naturalesa i necessita estar en contacte amb ella. Necessita saber i aprendre, recolzant-se en llibres, escrits o documents. Tota la seva vida està buscant coneixements. Degut a això, és molt savi. Avança amb constància per aconseguir donar respostes a les grans interrogacions i enigmes existencials, descobrint les grans veritats. És el número dels grans místics, teòlegs i filòsofs que ens permeten accedir a una realitat superior. L’excés del treball mental, però, pot ocasionar-li dificultats per viure les contingències materials i expressar els seus sentiments. És difícil per aquesta persona, connectar-se amb el seu cos i el seu cor.\n\nNecessita la soledat i el silenci a l’hora de meditar, contemplar i reflexionar. No obstant, això pot desencadenar a tancar-se en la seva “torre de marfil”, i aïllar-se dels altres. Pot arribar a viure amb massa serietat i austeritat. Aquest excés de saber, pot provocar en ell actituds d’orgull, superioritat, menyspreu i sarcasme.\n\nSi no aconsegueix els seus ideals, pot caure en una depressió o procés d’autodestrucció aïllant-se per complet del món.',
      bodyPart:
          'Hemisferi cerebral esquerre (lògica/anàlisi) i Chakra del tercer ull (espiritualitat).',
      excessTrap:
          'Intransigència, intolerància, sarcasme, supèrbia, soledat, aïllament, pessimisme, auto-càstig, depressió i desequilibri mental.',
      color: Color(0xFF7B1FA2), // Purple (Mysticism/Spirituality)
      icon: Icons.self_improvement,
    ),
    NumerologyItem(
      id: '8',
      title: 'El Poder / La Transformació',
      shortDesc: 'Yin/Yang. Poder material, justícia, talents.',
      fullDesc:
          'És la manifestació de la intel·ligència perfecta i la capacitat de transformar la matèria. Aquest caduceu, està compost per dos parts simètriques que ens ajuden a comprendre millor el simbolisme del número 8:\n• La serpentina de l’esquerra, representa el que rebem de l’univers: talents i dons.\n• La serpentina de la dreta correspon a la manera en que retornem a l’univers els fruits de la Terra transformada.\n• La vara del centre simbolitza la mediació entre Déu i l’Home.\n\nEl 8 és el símbol del Kundalini, de l’energia sexual, de la creativitat que ens ajuda a entrar en altres nivells de consciència. Com es pot veure en la seva grafia, les energies circulen des de dalt fins a baix, com si fos un rellotge de sorra. Representa el símbol de l’infinit en posició vertical.\n\nEl 8, representa el nostre poder, el nostre talent. A més, el 8, per ser dos vegades 4, és sòlid, responsable i té un gran sentit del concret. Té una gran personalitat d’organització i realització. És un número que comparteix aspectes Yin i Yang. El seu aspecte Yin, l’ajuda a prendre’s el seu temps, preparar estratègies i madurar els seus projectes abans de llançar-se a l’acció, mentre que el seu aspecte Yang, l’ajuda amb una gran capacitat d’organització, rendiment i producció.\n\nPer ser reconegut pels altres, necessita afirmar el seu poder material i econòmic. No pot viure sense treballar. Li agraden els reptes, i els afronta amb coratge i audàcia. Es capaç de realitzar qualsevol projecte. Darrere aquesta aparença exigent i autoritària, és generós i bondadós quan se sent amat pels altres. A més, posseeix un gran sentit de la justícia i l’honestedat.\n\nAquesta aparença exterior de poder i seguretat, pot amagar una gran fragilitat interior. És un número tant fort i amb tanta energia, que fàcilment pot cometre excessos de poder, orgull i dominació.',
      bodyPart: 'Plexe solar (potència i vulnerabilitat).',
      excessTrap:
          'Orgull, materialisme, cobdícia, supèrbia, arrogància, tirania, despotisme, autoritarisme, agressivitat, violència, crueltat i impaciència.',
      color: Color(0xFFFFD700), // Gold (Power/Material) - or Dark Amber
      icon: Icons.balance,
    ),
    NumerologyItem(
      id: '9',
      title: 'L’Hermità / L’Univers',
      shortDesc: 'Yang. Humanitarisme, saviesa interior, final de cicle.',
      fullDesc:
          'El número 9 és l’apertura de la ment i l’esperit. És l’últim número d’una sola xifra, que ens proposa anar més enllà dels nostres límits, i obrir-nos camins cap a horitzons més amplis. Al tarot, és el símbol de l’ermità, el que viu i manté la seva llum interior. El número Maestre interior, que necessita la seva llibertat física i espiritual per transmetre la saviesa al món.\n\nLa seva grafia és un 6 invertit, i tanmateix, com el 6, està format únicament per corbes que evoquen les relacions amb aspectes sensibles i receptius. La diferència entre el 6 i el 9, doncs, mentre el 6 viu els seus sentiments i les seves emocions, el 9 exposa totes les seves energies al seu cap. La seva debilitat, és tanmateix la seva virtut. És com un globus que està molt carregat d’idees, somnis... però que té una connexió fràgil i poc estable amb la terra.\n\nPer ser 3 vegades 3, viu en el seu món imaginari, per la qual cosa, també posseeix un gran creativitat i sensibilitat artística molt aguda.\n\nEl número del coneixement i misticisme per la seva connexió directe entre el seu cor i l’energia còsmica. El número del visionari. Compte amb una compassió que li permet captar els missatges de patiment que emeten els altres, i sentir la necessitat d’ajudar-los. Un número altruista, amb una vocació humanitària; viu amb l’ideal d’ajudar als més dèbils. El número de la compassió i la tolerància.\n\nÉs tant idealista, compassiu i generós, que pot arribar a l’abnegació, oblidant-se de si mateix, posicionant als altres com la seva única prioritat. A més, si no aconsegueix els seu objectiu d’ajudar als altres, pot arribar a caure en l’autodestrucció i depressió.\n\nEl 9, té problemes per acceptar les regles i exigències de la vida quotidiana, perquè prefereix refugiar-se al seu món imaginari.',
      bodyPart: 'Chakra corona (connexió superior).',
      excessTrap:
          'Utopia, falta de connexió amb la realitat, inconsistència, aïllament, mandra, marginació, depressió, comportaments agressius, orgull, dominació i autodestrucció.',
      color: Color(0xFF3F51B5), // Indigo (Wisdom/Universal)
      icon: Icons.public,
    ),
  ];

  static const List<NumerologyItem> masterNumbers = [
    NumerologyItem(
      id: '11',
      title: 'Missatger Diví / Mestre',
      shortDesc: 'Mestre. Força moral, intuïció, tensió nerviosa.',
      fullDesc:
          'Està compost per dos vegades 1, per la qual cosa, necessita ser reconegut i afirmar-se amb autoritat. A la vegada, representa el dos (1+1=2), la saviesa de l’arbre de la vida. Per aquest motiu, se l’anomena el missatger diví.\n\nS’assembla al número 9, però amb una missió més elevada. Apareix en busca d’una veritat profunda. Està dotat de força moral fora del comú, així com una intel·ligència subtil i un potent magnetisme intel·lectual.\n\nPerò aquest número pot tenir també els seus riscos i trampes, degut a la seva barreja de dos vegades 1, i del 2:\n• Vulnerabilitat emocional.\n• Nervis i impaciència.\n• Un camí de vida que ha de recórrer amb saviesa i evitant els excessos.\n• Complexa de superioritat, excés d’autoritat o manipulació.',
      bodyPart: 'Sistema nerviós (tensió elèctrica).',
      excessTrap:
          'Vulnerabilitat emocional, nervis, impaciència, complex de superioritat o bloqueig.',
      color: Color(0xFFFF4081), // Pink Accent (High Vibration)
      icon: Icons.bolt,
    ),
    NumerologyItem(
      id: '22',
      title: 'Constructor / Geni',
      shortDesc: 'Mestre. Gran projectes, visió futurista, tensió.',
      fullDesc:
          'És presentat com un inventor apassionat, un visionari amb una gran sensibilitat, un organitzador genial. El seu objectiu és realitzar grans projectes, amb idees noves i futuristes. És el número de la superació per aconseguir propòsits més elevats. Però el 22 pot tenir també els seus límits:\n• La pèrdua de l’equilibri psicològic quan és deixa portar per corrents contradictòries.\n• La mala gestió de les emocions. És el punt dèbil del 22. Pot viure tensions afectives i conflictes racionals.\n• L’excés de tensions que prové d’una energia física mal distribuïda o mal utilitzada.',
      bodyPart: 'Estructura òssia completa (suport de grans càrregues).',
      excessTrap:
          'Desequilibri psicològic, tensió extrema, depressió, abús de poder.',
      color: Color(0xFFC0CA33), // Lime (Material + High Energy)
      icon: Icons.architecture,
    ),
    NumerologyItem(
      id: '33',
      title: 'Amor Incondicional',
      shortDesc: 'Mestre. Sacrifici, compassió total, guia.',
      fullDesc:
          'Quan ens trobem amb un 33, és necessari veure si la persona és capaç de viure l’aspecte del 6 amb harmonia i equilibri. El 33 és el número del sacrifici, de l’amor perfecte, de la compassió i la comprensió.\n\nEl número dels grans mestres. Poques persones son capaces de viure’l amb equilibri perquè suposa un gran discerniment per evitar caure en l’excés de l’abnegació i sacrifici.',
      bodyPart: 'Tot el cos (canal d’energia pura).',
      excessTrap:
          'Abnegació excessiva, martiri, desconnexió de la realitat, càrrega del món.',
      color: Color(0xFF00E5FF), // Cyan Accent (Ethereal/High Love)
      icon: Icons.volunteer_activism,
    ),
  ];

  static const List<NumerologyItem> sefirot = [
    NumerologyItem(
      id: '1',
      title: 'Kether: La Corona',
      shortDesc: 'La Voluntat Primera, l’origen absolut.',
      fullDesc:
          'És la primera emanació, la Corona. Representa la voluntat pura i l’origen de tot. Està més enllà de la comprensió humana.',
      angel: 'Métatron (Serafins)',
      planet: 'Nebulosa Central / Neptú',
      color: Colors.white, // Pure Light
      icon: Icons.flare,
    ),
    NumerologyItem(
      id: '2',
      title: 'Hochmah: Saviesa',
      shortDesc: 'La Saviesa Revelada, impuls creatiu.',
      fullDesc:
          'La Saviesa. És l’impuls dinàmic de la creació, l’energia masculina expansiva. La guspira divina.',
      angel: 'Raziel (Querubins)',
      planet: 'Zodíac / Urà',
      color: Color(0xFFB0BEC5), // Silver/Grey
      icon: Icons.lightbulb,
    ),
    NumerologyItem(
      id: '3',
      title: 'Binah: Intel·ligència',
      shortDesc: 'Intel·ligència Concreta, la forma.',
      fullDesc:
          'La Intel·ligència o Enteniment. Dona forma a l’energia de Hochmah. El principi femení constrictiu.',
      angel: 'Tsaphkiel (Trons)',
      planet: 'Saturn',
      color: Colors.black87, // Black/Dark (Absorption)
      icon: Icons.architecture,
    ),
    NumerologyItem(
      id: '4',
      title: 'Hesed: Misericòrdia',
      shortDesc: 'Amor expansiu, abundància.',
      fullDesc:
          'La Misericòrdia i l’Abundància. L’amor que dona sense límits. Expansió i bondat.',
      angel: 'Tsadkiel (Dominacions)',
      planet: 'Júpiter',
      color: Color(0xFF2196F3), // Blue
      icon: Icons.volunteer_activism,
    ),
    NumerologyItem(
      id: '5',
      title: 'Geburah: Rigor',
      shortDesc: 'Força, disciplina, justícia.',
      fullDesc:
          'El Rigor, la Força i el Judici. Posa límits a Hesed. És la disciplina necessària per a la creació.',
      angel: 'Kamaël (Potències)',
      planet: 'Mart',
      color: Color(0xFFD32F2F), // Red
      icon: Icons.gavel,
    ),
    NumerologyItem(
      id: '6',
      title: 'Tiferet: Bellesa',
      shortDesc: 'Equilibri, harmonia, el Cor.',
      fullDesc:
          'La Bellesa i l’Harmonia. El centre de l’Arbre, el Cor. Equilibra Hesed i Geburah.',
      angel: 'Mikhaël (Virtuts)',
      planet: 'Sol',
      color: Color(0xFFFFD700), // Gold/Yellow
      icon: Icons.wb_sunny,
    ),
    NumerologyItem(
      id: '7',
      title: 'Netzah: Victòria',
      shortDesc: 'Emoció, art, natura.',
      fullDesc:
          'La Victòria i l’Eternitat. L’esfera de les emocions, els instints i la natura. Inspiració artística.',
      angel: 'Haniel (Principats)',
      planet: 'Venus',
      color: Color(0xFF4CAF50), // Green
      icon: Icons.park,
    ),
    NumerologyItem(
      id: '8',
      title: 'Hod: Glòria',
      shortDesc: 'Intel·lecte, comunicació, màgia.',
      fullDesc:
          'La Glòria i l’Esplendor. L’esfera de l’intel·lecte racional, la comunicació i la ciència.',
      angel: 'Raphaël (Arcàngels)',
      planet: 'Mercuri',
      color: Color(0xFFFF9800), // Orange
      icon: Icons.science,
    ),
    NumerologyItem(
      id: '9',
      title: 'Yesod: Fonament',
      shortDesc: 'Subconscient, somnis, imaginació.',
      fullDesc:
          'El Fonament. El dipòsit de les imatges, la lluna, els somnis i el subconscient. Connecta amb la terra.',
      angel: 'Gabriel (Àngels)',
      planet: 'Lluna',
      color: Color(0xFF9C27B0), // Violet/Purple
      icon: Icons.nightlight_round,
    ),
    NumerologyItem(
      id: '10',
      title: 'Malkuth: Regne',
      shortDesc: 'Món físic, terra, realització.',
      fullDesc:
          'El Regne. El món físic on vivim. La culminació de l’Arbre. On la llum divina toca terra.',
      angel: 'Uriel (Homes Perfectes)',
      planet: 'Terra',
      color: Color(0xFF795548), // Brown/Earth
      icon: Icons.public,
    ),
  ];

  static const List<NumerologyItem> houses = [
    NumerologyItem(
      id: '1',
      title: 'Casa 1: El Pare / Ego',
      shortDesc: 'Identitat, llançament de projectes, relació amb el pare.',
      fullDesc:
          'Representa l’estructura de l’ego, la identitat en el món i la dinàmica d’afirmació. Com ens llancem a nous projectes. La relació amb la figura paterna.',
      color: Color(0xFFFF5722),
      icon: Icons.person,
    ),
    NumerologyItem(
      id: '2',
      title: 'Casa 2: La Mare / Emocions',
      shortDesc: 'Emocions, escolta, feminitat, relació amb la mare.',
      fullDesc:
          'La forma de viure les emocions. La capacitat d’escoltar i acollir. La relació amb la mare i les pròpies energies femenines.',
      color: Color(0xFF039BE5),
      icon: Icons.volunteer_activism,
    ),
    NumerologyItem(
      id: '3',
      title: 'Casa 3: Els Altres / Creativitat',
      shortDesc: 'Germans, amics, expressió personal, imatge.',
      fullDesc:
          'Relació amb germans, amics i societat. Poder creatiu i expressió. Valorització de la pròpia imatge i alegria de viure.',
      color: Color(0xFFFFC107),
      icon: Icons.group,
    ),
    NumerologyItem(
      id: '4',
      title: 'Casa 4: La Llar / Feina',
      shortDesc: 'Món material, cos físic, arrels familiars.',
      fullDesc:
          'El món material i fets reals: feina, llar, cos. Arrels i tradició familiar. Compromís i estabilitat.',
      color: Color(0xFF388E3C),
      icon: Icons.home_work,
    ),
    NumerologyItem(
      id: '5',
      title: 'Casa 5: La Llibertat / Canvi',
      shortDesc: 'Adaptació, sexualitat, parella (dona), canvis.',
      fullDesc:
          'Facilitat d’adaptació, llibertat i energia sexual. Imatge de la parella (com busques la dona). Aventures i canvis.',
      color: Color(0xFFD32F2F),
      icon: Icons.flight_takeoff,
    ),
    NumerologyItem(
      id: '6',
      title: 'Casa 6: La Família / Harmonia',
      shortDesc: 'Relacions afectives, llar, parella (home), servei.',
      fullDesc:
          'Responsabilitat familiar i relacions afectives. Benestar i harmonia. Imatge de la parella (com busques l’home).',
      color: Color(0xFFEC407A),
      icon: Icons.family_restroom,
    ),
    NumerologyItem(
      id: '7',
      title: 'Casa 7: La Ment / Esperit',
      shortDesc: 'Coneixement, reflexió, presa de consciència.',
      fullDesc:
          'Espiritualitat i connexió divina. Reflexió, estudi i coneixement profund. Herències culturals.',
      color: Color(0xFF7B1FA2),
      icon: Icons.school,
    ),
    NumerologyItem(
      id: '8',
      title: 'Casa 8: El Poder / Talents',
      shortDesc: 'Realisme, diners, èxit, estratègia.',
      fullDesc:
          'Potencial dels talents i realització material. Poder d’estratègia, diners i estatus social. Transformació.',
      color: Color(0xFFFFD700),
      icon: Icons.monetization_on,
    ),
    NumerologyItem(
      id: '9',
      title: 'Casa 9: El Món / Compassió',
      shortDesc: 'Univers, estranger, humanitari, ideals.',
      fullDesc:
          'Consciència universal i connexió còsmica. Viatges, estranger, misticisme. Servei humanitari i compassió.',
      color: Color(0xFF3F51B5),
      icon: Icons.public,
    ),
  ];

  static const List<NumerologyItem> foundations = [
    NumerologyItem(
      id: 'intro',
      title: 'Què és la Numerologia?',
      shortDesc: 'Vibració secreta, energia i informació.',
      fullDesc:
          'La numerologia és un conjunt de creences que estableix una relació oculta entre els números, els éssers vius i les forces espirituals. Investiga la «vibració secreta» d\'aquest codi per influir sobre persones i esdeveniments.\n\nCom va dir Nikola Tesla: "Si vols conèixer els secrets de l\'Univers, pensa en termes d\'energia, freqüència i vibració". Els números són pura energia vibrant.',
      color: Colors.indigo,
      icon: Icons.question_answer,
    ),
    NumerologyItem(
      id: 'origins',
      title: 'Origen de la Numerologia',
      shortDesc: 'Pitàgores, Càbala i Tradició.',
      fullDesc:
          'Té tres fonts principals:\n\n1. Numerologia Pitagòrica (500 aC): Pitàgores veia en les pautes numèriques l\'explicació dels fenòmens naturals.\n2. Simbolisme Cabalista: Basat en la tradició mística jueva i l\'Arbre de la Vida.\n3. Simbolisme Cristià-Medieval: Interpretació numèrica dels textos sagrats.',
      color: Colors.deepPurple,
      icon: Icons.history_edu,
    ),
    NumerologyItem(
      id: 'body_tree',
      title: 'El Cos Humà i l\'Arbre',
      shortDesc: 'Som fets a imatge de l\'Arbre de la Vida.',
      fullDesc:
          'Portem l\'esquema de l\'Arbre a dins:\n\n* La columna vertebral és el pilar de l\'equilibri (Kether a Malkuth).\n* El cap (Kether) connecta amb l\'infinit.\n* La regió cardíaca (Tiferet) és l\'ànima.\n* La zona urogenital (Yesod) és la fundació vital.\n\nEl nostre desenvolupament físic i espiritual segueix aquest mapa sagrat.',
      color: Colors.teal,
      icon: Icons.accessibility_new,
    ),
  ];
}
