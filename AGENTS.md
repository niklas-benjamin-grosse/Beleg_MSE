# Beleg_MSE – AGENTS.md

## Projekt

HTW Dresden, MSE SS2026 – Modellgetriebene SW-Entwicklung.  
DSL für **User Stories auf Deutsch** mit **Xtext/Xtend**.  
Matrikelnummern: 86379, 87568.

- **n = (86379 + 87568) mod 24 = 19**
- **n mod 8 = 3** → Fall **(d)** – dreifaches "zu" (z.B. "zurechtzuzupfen")
- **n mod 3 = 1** → Exportformat **XML**
- Formulierungsvariante: **"Als [...]"**

## Projektstruktur

```
de.htwdd.sf.beleg.s86379s87568/
  src/.../Lang.xtext                 → Grammatik (DSL-Kern!)
  src/.../generator/LangGenerator.xtend → XML-Generator
  src/.../validation/LangValidator.java → Validierungsregeln
  src/.../scoping/LangScopeProvider.java → Scoping
  src/.../GenerateLang.mwe2          → MWE2-Workflow
  xtend-gen/ src-gen/ bin/           → Generiert (nie committen)

de.htwdd.sf.beleg.s86379s87568.ide/ → IDE-Plugin
de.htwdd.sf.beleg.s86379s87568.ui/  → UI-Plugin (Editor, Outline)
de.htwdd.sf.beleg.s86379s87568.feature/ → Feature für Update-Site
de.htwdd.sf.beleg.s86379s87568.repository/ → Eclipse Update-Site

runtime-EclipseXtext/
  .metadata/      → Eigenes Eclipse-Workspace für die zweite Eclipse-Instanz
                    (bereits gitignored – nur interne Caches)
  test/           → Testprojekt in der Runtime-Eclipse
    src/test.s86379s87568  → Beispiel-DSL-Datei zum Ausprobieren des Editors
    src/module-info.java   → Leeres Java-Modul (wird von Eclipse benötigt)
    bin/           → Kompilierte Klassen (nicht committen)
```

## Konzepte & Orientierung

### Wie Xtext funktioniert (das große Ganze)

1. Du schreibst eine **Grammatik** in `Lang.xtext` (wie eine formale Sprache)
2. Xtext generiert daraus einen **Parser** + **EMF-Modell** (AST = Baumstruktur deiner DSL)
3. Der generierte Parser liest `.s86379s87568`-Dateien und baut einen Baum aus `Userstory`, `Goal`, `Gain`-Knoten
4. Du navigierst diesen Baum im **Generator** (`LangGenerator.xtend`) und in **Tests**, um Werte auszulesen
5. Der Generator produziert eine **XML-Datei** aus dem Baum

### Zwei Eclipse-Instanzen

- **Dev-Eclipse**: Hier schreibst du Code (Grammatik, Generator, Tests). Läuft auf deinem normalen Workspace.
- **Runtime-Eclipse** (`runtime-EclipseXtext/`): Eine zweite Eclipse-Instanz mit deinen Plug-ins. Du startest sie aus der Dev-Eclipse. Dort siehst du den Editor visuell (Syntax-Highlighting, Outline, Fehler). Wird nur für UI-Tests gebraucht.

### Was die wichtigsten Dateien bedeuten

| Datei | Was ist das? |
|-------|-------------|
| `Lang.xtext` | **Grammatik-DSL** – definiert die Syntax deiner User-Story-Sprache |
| `GenerateLang.mwe2` | **MWE2-Workflow** – baut aus der Grammatik Parser, AST-Modell, Editor-Code |
| `LangGenerator.xtend` | **Codegenerator** – wandelt geparste User-Stories in XML (oder CSV/JSON) |
| `LangValidator.java` | **Validierungsregeln** – prüft DSL-Dateien auf Fehler (z.B. leere Titel) |
| `LangScopeProvider.java` | **Scoping** – definiert Sichtbarkeit von Referenzen zwischen DSL-Elementen |
| `*.ecore` / `*.genmodel` | Generiertes **EMF-Modell** – beschreibt die AST-Knoten-Typen (`Userstory`, `Goal`, ...) |
| `src-gen/` | Generierte Java-Klassen (Parser, AST-Impl, Serializer) – **lies sie, ändere sie nie** |
| `xtend-gen/` | Generiertes Java aus deinen Xtend-Dateien |
| `*.xtextbin` | Binary-Cache der Grammatik (generiert) |
| `bin/` | Kompilierte `.class`-Dateien |

### Wie finde ich heraus, was ich in Code nutzen kann?

- **`src-gen/` durchsuchen**: Willst du auf ein `title`-Feld zugreifen? Schau in `src-gen/.../lang/Userstory.java` nach, welche Felder die Klasse hat.
- **Grammatik lesen**: In `Lang.xtext` siehst du, welche Attribute/Rule-Referenzen es gibt. Jedes `name=ID` erzeugt eine `getName()`-Methode.
- **Generierten Java-Code lesen**: In `xtend-gen/` oder `src-gen/` steht der echte Java-Code – da siehst du die genauen Typen. Das ist oft klarer als die Xtend/Xtext-Abstraktion.

1. **Lang.xtext** editieren
2. MWE2-Workflow: `GenerateLang.mwe2` → Run As → MWE2 Workflow
3. **JUnit-Tests** laufen lassen (Level 1, ~1s)
4. Bei Fehlern → zurück zu 1
5. Bei OK → **Generator** anpassen (falls nötig)
6. Generator-Tests laufen lassen (Level 2, ~1s)
7. **Runtime-Eclipse** nur für visuelle UI-Prüfung (Level 3, ~30s)

**Nie die Runtime-Eclipse für reine Parser-/Generator-Tests starten.**

## Workflow bei Generator-Änderung

1. **LangGenerator.xtend** editieren
2. Test-Main oder JUnit-Test laufen lassen
3. Generator-Änderungen brauchen **keinen** MWE2-Durchlauf

## Test-Strategie

| Level | Was | Werkzeug | Dauer |
|-------|-----|----------|-------|
| 1 | Grammatik (Parser) | `ParseHelper` per JUnit | ~1s |
| 2 | Generator (XML) | `InMemoryFileSystemAccess` per JUnit/Main | ~1s |
| 3 | Editor (Syntax, Outline) | Runtime-Eclipse starten | ~30s |

## Git-Regeln

### Commit-Workflow (immer so)

1. `git status` – welche Dateien sind geändert?
2. `git diff` – sind die Änderungen korrekt?
3. **Nur die gewollten Dateien** explizit stagen:
   ```
   git add src/.../Lang.xtext src/.../LangGenerator.xtend
   ```
   **Niemals** `git add .` oder `git commit -a` – sonst landen Eclipse-Caches und generierte Dateien im Commit.
4. `git diff --cached` – prüfen ob nur das drin ist, was du willst
5. `git commit -m "<bereich>: <änderung>"` – z.B. `grammar: add Um variant`
6. `git status && git log --oneline -3` – sieht alles gut aus?

### Commit-Bereiche (für die Nachricht)

| Bereich | Wann | Beispiel |
|---------|------|----------|
| `grammar` | Änderung an `Lang.xtext` | `grammar: support Um-variant syntax` |
| `generator` | Änderung an `LangGenerator.xtend` | `generator: strip zu from triple-zu verbs` |
| `validation` | Änderung an `LangValidator.java` | `validation: reject empty title` |
| `ui` | UI-Plugin (`*.ui/`) | `ui: show terminals in outline` |
| `tests` | Test-Dateien | `tests: add parsing test for triple zu` |
| `chore` | Build, Config, `.gitignore` | `chore: add .gitignore for Eclipse metadata` |
| `docs` | README, AGENTS.md, Doku | `docs: add project overview` |

### Weitere Regeln

- **Nur Hand-Code committen** – niemals `bin/`, `src-gen/`, `xtend-gen/`
- **Ein Commit pro logischer Änderung** – Grammatik und Generator in separate Commits
- Nie `--amend` nach Push, nie `--force-push`
- `git status` und `git log --oneline -5` vor/nach jedem Commit checken

## Tägliche Disziplin

- **Mindestens ein Commit pro Arbeitstag**
- Erst verstehen, dann ändern: grep/glob/lesen → dann editieren
- Fehlermeldungen **genau** lesen, bevor du googlest oder fragst
- Tests sind dein Sicherheitsnetz – immer grün halten
- Große Änderungen in kleine, unabhängige Schritte zerlegen
- Nach jedem Schritt: bauen und testen, nicht erst am Ende
- **Generated code lesen** (Ja, auch der generierte Java-Code) – da stehen die echten Typen und Regeln drin
