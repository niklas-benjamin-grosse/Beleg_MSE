package e.htwdd.sf.beleg.tests

import com.google.inject.Inject
import e.htwdd.sf.beleg.lang.UserStories
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
	ParseHelper<UserStories> parseHelper

	@Test
	def void parseBasicUserStoryWithStandaloneZU() 
	{
		val result = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val stories = result.userstories
		Assertions.assertEquals(1, stories.size)
		val s = stories.get(0)
		Assertions.assertEquals("Nachricht", s.title.subst)
		Assertions.assertEquals("schicken", s.title.inf)
		Assertions.assertEquals("Koordinator", s.role)
		Assertions.assertEquals("Nachrichten verschicken", s.goal)
		Assertions.assertEquals("Nutzer", s.gain.context)
		Assertions.assertEquals("informieren", s.gain.verb.inf)
		Assertions.assertEquals(null, s.gain.verb.getWith_embedded_zu)
	}

	@Test
	def void parseBasicUserStoryWithEmbeddedZU() {
		val result = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer aufzubauen.
		''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val stories = result.userstories
		Assertions.assertEquals(1, stories.size)
		val s = stories.get(0)
		Assertions.assertEquals("Nachricht", s.title.subst)
		Assertions.assertEquals("schicken", s.title.inf)
		Assertions.assertEquals("Koordinator", s.role)
		Assertions.assertEquals("Nachrichten verschicken", s.goal)
		Assertions.assertEquals("Nutzer", s.gain.context)
		Assertions.assertEquals(null, s.gain.verb.inf)
		Assertions.assertEquals("aufzubauen", s.gain.verb.with_embedded_zu)
		
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
		val stories = result.userstories
		Assertions.assertEquals(2, stories.size)
	}

	@Test
	def void testNonAsciiUtf8() {
		val result = parseHelper.parse('''
		Nachricht schicken: Als guter  Tester möchte ich Infos Tieren, um einkaufen aufzugeben. 
			''')
		Assertions.assertNotNull(result)
		val errors = result.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')
		val s = result.userstories.get(0)
		System.out.println(s.role)
		System.out.println(s.goal)
		System.out.println(s.gain.context)
		System.out.println(s.gain.verb.inf)
		System.out.println(s.gain.verb.with_embedded_zu)
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
