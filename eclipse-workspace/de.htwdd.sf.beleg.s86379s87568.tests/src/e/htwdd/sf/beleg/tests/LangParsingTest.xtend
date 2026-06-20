package e.htwdd.sf.beleg.tests

import com.google.inject.Inject
import e.htwdd.sf.beleg.lang.Model
import e.htwdd.sf.beleg.lang.Userstories
import e.htwdd.sf.beleg.lang.Userstory
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith

@ExtendWith(InjectionExtension)
@InjectWith(LangInjectorProvider)
class LangParsingTest {
	@Inject
	ParseHelper<Model> parseHelper

	@Test
	def void parseBasicUserStory() {
		val result = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val stories = (result as Userstories).userstories
		Assertions.assertEquals(1, stories.size)
		val s = stories.get(0)
		Assertions.assertEquals("Nachricht schicken", s.title.join(" "))
		Assertions.assertEquals("Koordinator", s.role.join(" "))
		Assertions.assertEquals("Nutzer", s.gain.words.get(0))
		Assertions.assertEquals("zu", s.gain.words.get(1))
		Assertions.assertEquals("informieren", s.gain.words.get(2))
	}

	@Test
	def void parseMultipleUserStories() {
		val result = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
			Dokument drucken: Als Benutzer möchte ich Dokumente drucken, um Dokumente auszudrucken.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val stories = (result as Userstories).userstories
		Assertions.assertEquals(2, stories.size)
	}

	@Test
	def void testNonAsciiUtf8() {
		val result = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten übermitteln, um Nutzer zu informieren.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val s = (result as Userstories).userstories.get(0)
	}

	@Test
	def void parseFallBEmbeddedZu() {
		val result = parseHelper.parse('''
			Dokument drucken: Als Benutzer möchte ich Dokumente drucken, um Berichte auszudrucken.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void parseFallCZuzu() {
		val result = parseHelper.parse('''
			Aufgabe zuweisen: Als Koordinator möchte ich Aufgaben zuweisen, um Arbeit zuzuweisen.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void parseFallDTripleZu() {
		val result = parseHelper.parse('''
			Kaffee zuckern: Als Barista möchte ich Kaffee zuckern, um Kaffee zuzuzuckern.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}

	@Test
	def void parseFallDTripleZuZurecht() {
		val result = parseHelper.parse('''
			Kleidung zupfen: Als Schneider möchte ich Kleidung zupfen, um Stoff zurechtzuzupfen.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
	}
}
