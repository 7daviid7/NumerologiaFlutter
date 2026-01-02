# NUMEN - Assistent Numerològic amb IA

**NUMEN** és una aplicació multiplataforma (Web i Desktop) desenvolupada amb **Flutter** que automatitza els estudis numerològics basats en la metodologia de Martine Coquatrix. El sistema integra l'API de **Google Gemini** per generar interpretacions textuals riques i personalitzades.

## 🚀 Tecnologies

* **Frontend:** Flutter (Dart)
* **Backend:** Google Firebase (Hosting, Firestore, Auth)
* **IA:** Google Gemini 2.5 Flash (via API REST)
* **Visualització:** SVG dinàmics (CustomPainter)
* **Generació de Documents:** PDF natius (pdf package)

## 🛠️ Requisits Previs

Assegura't de tenir instal·lat:

* [Flutter SDK](https://flutter.dev/docs/get-started/install) (versió estable més recent)
* [Git](https://git-scm.com/)
* [Firebase CLI](https://firebase.google.com/docs/cli) (per al desplegament)

## 📦 Instal·lació i Configuració

### 1. Preparació de l'Entorn

Abans de començar, necessitaràs instal·lar les següents eines:

*   **Flutter SDK:** Descarrega la versió estable des de [flutter.dev](https://flutter.dev) i afegeix-la al teu PATH.
*   **VS Code:** L'IDE recomanat. Instal·la les extensions oficials de "Flutter" i "Dart".
*   **Node.js & NPM:** Necessari per instal·lar les eines de Firebase. [Descarregar Node.js](https://nodejs.org/).

Un cop tinguis Node.js, instal·la **Firebase CLI** globalment:
```bash
npm install -g firebase-tools
firebase login
```

### 2. Clonar i Instal·lació

```bash
git clone https://github.com/7daviid7/numerologia_flutter.git
cd numerologia_flutter
flutter pub get
```

### 3. Configuració de Firebase (Opcional si ja tens firebase_options.dart)

Si necessites reconfigurar el projecte per connectar-lo al teu propi projecte de Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
Seguir les instruccions per seleccionar el teu projecte i plataformes.

### 4. Configuració de Secrets (.env)

El projecte necessita una clau d'API de Google Gemini.
Crea un fitxer `.env` a l'arrel:

```env
GEMINI_API_KEY=AIzaSy...LaTevaClauAQUI
```

## 🐛 Depuració (VS Code)

Per a una experiència de depuració fluida, es recomana configurar el fitxer `.vscode/launch.json` per evitar haver d'escriure la clau a cada comanda.

Exemple de `.vscode/launch.json` optimitzat per carregar automàticament el fitxer `.env`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "numerologia_flutter (Web)",
            "request": "launch",
            "type": "dart",
            "args": ["-d", "chrome"],
            "toolArgs": ["--dart-define-from-file=.env"]
        }
    ]
}
```

Gràcies a aquesta configuració (`toolArgs`), pots prémer directament **F5** a Visual Studio Code per iniciar la depuració sense haver de configurar res més manualment. El sistema llegirà les claus del fitxer `.env` automàticament.

També pots utilitzar `flutter devtools` per inspeccionar l'arbre de ginys, el rendiment i la memòria.

## 🚀 Desplegament a Producció

El projecte inclou un script d'automatització per desplegar a Firebase Hosting de forma segura.

1. Assegura't de tenir el fitxer `.env` configurat.
2. Executa l'script des de l'arrel:

   **Windows:**

   ```cmd
   tools\deploy_prod.bat
   ```

Aquest script realitzarà automàticament els passos següents:

1. Llegirà la `GEMINI_API_KEY` del fitxer `.env`.
2. Netejarà el projecte (`flutter clean`).
3. Compilarà la versió web de producció (`flutter build web --release`) injectant la clau d'API de form segura.
4.  Pujarà els fitxers a Firebase Hosting (`firebase deploy`).

🔗 **URL de Producció:** [https://charged-sum-419213.web.app/](https://charged-sum-419213.web.app/)

## 🐛 Depuració

Per a tasques de depuració, es recomana utilitzar **Visual Studio Code** amb l'extensió de Flutter.

1.  Obre el panell "Run and Debug" (Ctrl+Shift+D).
2.  Selecciona "Flutter (Chrome)" o "Flutter (Windows)".
3.  Assegura't de tenir els arguments necessaris a `.vscode/launch.json` o executa directament amb la clau injectada:
    ```bash
    flutter run --debug --dart-define=GEMINI_API_KEY=...
    ```

Pots utilitzar `flutter devtools` per inspeccionar l'arbre de ginys, el rendiment i la memòria.

## 📄 Llicència

Desenvolupat per **David Quintanilla** com a part del Projecte Final de Grau (Grau en Enginyeria Informàtica - UdG).
