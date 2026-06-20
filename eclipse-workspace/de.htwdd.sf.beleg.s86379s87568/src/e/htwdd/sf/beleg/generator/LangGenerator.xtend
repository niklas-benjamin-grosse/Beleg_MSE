package e.htwdd.sf.beleg.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import e.htwdd.sf.beleg.lang.Userstories
import e.htwdd.sf.beleg.lang.Userstory
import org.eclipse.emf.common.util.EList

class LangGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val stories = (resource.contents.head as Userstories).userstories
		val sourceName = resource.URI.lastSegment
		val baseName = sourceName.substring(0, sourceName.lastIndexOf('.'))
		fsa.generateFile(baseName + ".userstories.xml", '''
			<?xml version="1.0" encoding="UTF-8"?>
			<userstories>
				«FOR story : stories»
					«story.toXml»
				«ENDFOR»
			</userstories>
		''')
	}

	def toXml(Userstory story) '''
		<userstory>
			<title>«story.title.join(" ")»</title>
			<role>«story.role.join(" ")»</role>
			<goal>«story.goal.words.join(" ")»</goal>
			<gain>«story.gain.words.nutzenText»</gain>
		</userstory>
	'''

	// Extrahiert Object und infinitiv ohne zu
	def nutzenText(EList<String> words) {
		val obj = 
			if (words.size >= 2 && words.get(words.size - 2) == "zu")
				words.subList(0, words.size - 2).join(" ")
			else
				words.subList(0, words.size - 1).join(" ")
		
		val verb = 
			if (words.size >= 2 && words.get(words.size - 2) == "zu")
				words.last
			else
				words.last.verbOhneZu
		'''«obj» «verb»'''
	}

	def verbOhneZu(String verb) {
		val idx = verb.lastIndexOf("zu")
		if (idx >= 0) verb.substring(0, idx) + verb.substring(idx + 2)
		else verb
	}
}
