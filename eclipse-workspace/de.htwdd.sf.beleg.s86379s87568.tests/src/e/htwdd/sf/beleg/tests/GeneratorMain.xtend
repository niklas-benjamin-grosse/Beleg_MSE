package e.htwdd.sf.beleg.tests

import e.htwdd.sf.beleg.lang.Model
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.generator.InMemoryFileSystemAccess

class GeneratorMain {
	def static void main(String[] args) {
		val injector = new LangInjectorProvider().getInjector
		val parseHelper = injector.getInstance(typeof(ParseHelper))
		val generator = injector.getInstance(typeof(IGenerator2))

		val model = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
			Themen vergleichen: Als Journalist möchte ich verschiedene Übersichten zu Themen ,um diese zu vergleichen.
			Geld geben: Als Banker möchte ich mehr Geld erhalten ,um Freunde zu bezuschussen.
			Paket zurücksenden: Als unzufriedener Kunde möchte ich die Adresse klar einsehen können, um das Paket zurückzusenden. 
			Dokument drucken: Als Benutzer möchte ich Dokumente drucken, um Berichte auszudrucken.
			Task hinzufügen: Als Projektleiter möchte ich einen Dialog, um mehrere Tasks einer Person hinzuzufügen.
			Aufgabe zuweisen: Als Koordinator möchte ich Aufgaben zuweisen, um Arbeit zuzuweisen.
			Kaffee zuckern: Als Barista möchte ich Kaffee zuckern, um Kaffee zuzuzuckern.
			Kleidung zupfen: Als Schneider möchte ich Kleidung zupfen, um Stoff zurechtzuzupfen.
				
		''')

		val errors = model.eResource.errors
		if (!errors.empty) {
			println("=== PARSER-FEHLER ===")
			errors.forEach[println(it)]
			return
		}

		val fsa = new InMemoryFileSystemAccess
		generator.doGenerate(model.eResource, fsa, null)

		println("=== GENERIERTES XML ===")
		println(fsa.textFiles.values.head ?: "(leer)")
	}
}
