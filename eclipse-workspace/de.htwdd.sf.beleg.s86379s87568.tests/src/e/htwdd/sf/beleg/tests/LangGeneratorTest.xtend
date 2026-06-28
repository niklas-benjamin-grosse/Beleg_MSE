package e.htwdd.sf.beleg.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.generator.IGenerator2
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import e.htwdd.sf.beleg.lang.UserStories

@ExtendWith(InjectionExtension)
@InjectWith(LangInjectorProvider)
class LangGeneratorTest {
	@Inject
	ParseHelper<UserStories> parseHelper

	@Inject
	IGenerator2 generator

	@Test
	def void testGeneratorProducesOutput() {
		val model = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
		''')
		Assertions.assertNotNull(model)
		val errors = model.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')

		val fsa = new InMemoryFileSystemAccess
		generator.doGenerate(model.eResource, fsa, null)

		Assertions.assertFalse(fsa.textFiles.isEmpty, "Generator should produce at least one file")
	}

	@Test
	def void testGeneratorMultipleStories() {
		val model = parseHelper.parse('''
			Nachricht schicken: Als Koordinator möchte ich Nachrichten verschicken, um Nutzer zu informieren.
			Dokument drucken: Als Benutzer möchte ich Dokumente drucken, um Berichte auszudrucken.
		''')
		Assertions.assertNotNull(model)
		val errors = model.eResource.errors
		Assertions.assertTrue(errors.isEmpty, '''Unexpected errors: «errors.join(", ")»''')

		val fsa = new InMemoryFileSystemAccess
		generator.doGenerate(model.eResource, fsa, null)

		Assertions.assertFalse(fsa.textFiles.isEmpty)
		val output = fsa.textFiles.values.head
		println('''Generated output: «output»''')
	}
}
