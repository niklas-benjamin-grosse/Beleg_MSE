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

runtime-EclipseXtext/ → Laufzeit-Eclipse zum Testen des Editors
```

## Workflow bei Grammatik-Änderung

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

- **Nur Hand-Code committen** – niemals `bin/`, `src-gen/`, `xtend-gen/`
- `git diff --cached` **vor jedem Commit** prüfen
- Commit-Nachricht: `<bereich>: <änderung>`  
  z.B. `grammar: add Um variant`, `generator: handle triple zu`
- **Ein Commit pro logischer Änderung**
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
