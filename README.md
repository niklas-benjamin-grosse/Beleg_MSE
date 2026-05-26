# Beleg_MSE

> Toller Beleg für MSE

## Mindestens muss funktionieren

- **Infinitiv mit zu** d) Das Verb ist trennbar zusammengesetzt, und es entsteht ein dreifaches (!) Vorkommen von "zu", nämlich als Präfix eines Präfixes, als verschmolzene Konjunktion und als Teil des Worstammes. Dieser Fall ist sehr selten, z.B. werden "zurechtzupfen" und "zuzuckern" zu "zurechtzuzupfen" und "zuzuzuckern".
- **Formulierung mit** "Als [...]"
- **Exportformat** XML

## Gedanken zum Infinitiv mit 'zu' nur für Fall (d)

- Verb besteht aus den Teilen Vorsilbe und Wortstamm
- Korrekte Erkennung vom Infinitivmarker alles
davor gehört zu Vorsilbe und alles danach zum Wortstamm
  1. im Verb kommt irgendwo ein 'zu' vor: Marker = dieses 'zu'
  2. es kommt im Verb ein 'zuzu' vor: Marker = erstes 'zu'
  3. es kommt direkt am Anfang ein 'zuzu' vor: Marker = zweites 'zu'

Fall 3 folgt eigentlich aus Fall 2, wenn man bedenkt,
das mindestens ein Buchstabe vor dem inneren zu stehen muss.
