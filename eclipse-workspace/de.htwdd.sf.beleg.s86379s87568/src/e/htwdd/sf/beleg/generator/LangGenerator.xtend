package e.htwdd.sf.beleg.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import e.htwdd.sf.beleg.lang.UserStories
import e.htwdd.sf.beleg.lang.UserStory
import org.eclipse.emf.common.util.EList
import e.htwdd.sf.beleg.lang.InfWithZu

class LangGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val stories = (resource.contents.head as UserStories).userstories
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

	def toXml(UserStory story) '''
		<userstory>
			<title>«story.title.subst» «story.title.inf»</title>
			<role>«story.role»</role>
			<goal>«story.goal»</goal>
			<gain>«story.gain.context === null ? "" : story.gain.context» «story.gain.verb.toInfinitive»</gain>
		</userstory>
	'''

	// Extrahiert Object und infinitiv ohne zu
	def toInfinitive(InfWithZu verb) { 
		val infinitive = 
			if (verb.inf !== null)	
				verb.inf
			else
				verb.with_embedded_zu.verbWithoutZu 
				
		'''«infinitive»'''
	}

	def verbWithoutZu(String verb) {
		val idx = verb.lastIndexOf("zu")
		if (idx >= 0) verb.substring(0, idx) + verb.substring(idx + 2)
		else verb
	}
}
