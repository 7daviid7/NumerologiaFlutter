# Projecte: PFG - Assistent de Numerologia (Mètode Martine Coquatrix)

## 1. Visió General
Treball de Final de Grau per automatitzar estudis numerològics basats en el mètode de **Martine Coquatrix** ("La numerología a la luz del árbol de vida y las letras hebraicas").
L'eina digitalitza un procés manual, professionalitzant l'entrega de resultats.

## 2. Stack Tecnològic (Flutter)
* **Framework:** Flutter (Dart).
* **Target Actual:** Desktop (Windows/macOS/Linux).
* **Potencial Target:** Web & Mobile (Android/iOS).
* **Arquitectura Actual:** Monolítica (lògica i UI barrejades als Widgets).
* **Eines Clau:**
    * `flutter_test` (per validar càlculs).
    * (Si fas servir algun gestor d'estat com Provider, Riverpod o Bloc, posa-ho aquí. Si no, posa "setState / Vanilla").

## 3. Regles de Domini (CRÍTIQUES)
* **Entrada de Dades:** Format genealògic estricte (5 cognoms segons el cas).
    * Ex: *Nom* + *Cognom1 Pare* + *Cognom1 Mare* + *Cognom2 Pare* + *Cognom2 Pare*.
    Els cognoms dels avis són trascendents en aquests tipus d'estudis numerologics. Les herències familiars son importants. 
* **Lògica:** Càlculs basats en valors hebreus (Càbala), no Pitagòrics.

## 4. Full de Ruta de la Refactorització (Refactoring Roadmap)
1.  **Separació de Responsabilitats (Clean Architecture):**
    * Extreure la lògica de càlcul (mètodes que fan matemàtiques) fora dels fitxers de la UI (Widgets). Crear classes de servei o models de domini (ex: `NumerologyCalculator.dart`). Això en princpi ja està fet. 
    * 
2.  **Disseny Responsive:**
    * Substituir mides fixes (pixels) per widgets flexibles (`Expanded`, `Flexible`, `LayoutBuilder`).
    * Implementar un disseny que s'adapti si l'usuari redimensiona la finestra de l'escriptori.
3.  **Nova Funcionalitat IA:**
    * Implementar servei HTTP per connectar amb API (Gemini/OpenAI).
    * Generació de prompts dinàmics basats en els models de dades de Dart.
    * Persistència de dades (Firebase o Supabase són ideals per a Flutter) per guardar l'entrenament futur.
4.  **Millora en l'Exportació (Opcional però recomanat):**
    * Substituir la captura de pantalla per la generació programàtica de PDFs (paquet `pdf` de pub.dev) per a una entrega professional. Aquí recau la màxima dificultat, perquè la generació del pdf per imprimi hauria de ser exactament igual que com s'esta visualitzant per pantalla, per això hem començat primer amb pantalles més grans. 
**comentari**: per a pentalles petites de moment no tinc pensat com exportar-ho, perquè la idea és que amb una sola pantalla es pugui veure tota la informació, perquè es relaciona entre ella. Per pantalles petites possiblement es podria visualtizar les dades igualment per separat, i imprimir seguint el template per pantalles grans. 

## 5. Guia d'Estil
* Utilitzar `const` als widgets sempre que sigui possible.
* Seguir les convencions de `lints` de Dart.
* Variables i funcions en `camelCase`. Classes en `PascalCase`.