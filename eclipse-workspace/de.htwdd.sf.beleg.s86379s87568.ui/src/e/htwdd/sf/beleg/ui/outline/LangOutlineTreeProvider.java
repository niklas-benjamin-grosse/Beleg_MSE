package e.htwdd.sf.beleg.ui.outline;

import org.eclipse.swt.graphics.Image;
import org.eclipse.xtext.ui.editor.outline.IOutlineNode;
import org.eclipse.xtext.ui.editor.outline.impl.AbstractOutlineNode;
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider;
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode;

import e.htwdd.sf.beleg.lang.Gain;
import e.htwdd.sf.beleg.lang.InfWithZu;
import e.htwdd.sf.beleg.lang.Title;
import e.htwdd.sf.beleg.lang.UserStories;
import e.htwdd.sf.beleg.lang.UserStory;

public class LangOutlineTreeProvider extends DefaultOutlineTreeProvider {

	
	public class TerminalNode extends AbstractOutlineNode { 
		protected TerminalNode(IOutlineNode parent, Image image, Object text) {
			super(parent, image, text, true);
		} 
	}
	
	
	
	protected void _createChildren(IOutlineNode parentNode, UserStories model) {
		for (UserStory story : model.getUserstories()) {
			createNode(parentNode, story);
		}
	}

	protected void _createChildren(IOutlineNode parentNode, UserStory story) {
		createNode(parentNode, story.getTitle()); 
		new TerminalNode(parentNode, null, "Als");
		new TerminalNode(parentNode, null, "Role: " + story.getRole());
		new TerminalNode(parentNode, null, "möchte");
		new TerminalNode(parentNode, null, "ich");
		new TerminalNode(parentNode, null, "Goal: " + story.getGoal());
		new TerminalNode(parentNode, null, ",um");
		createNode(parentNode, story.getGain()); 
		new TerminalNode(parentNode, null, ".");
	} 

	protected void _createChildren(IOutlineNode parentNode, Title title) {
		new TerminalNode(parentNode, null, "noun: " + title.getSubst());
		new TerminalNode(parentNode, null, "infinitive: " + title.getInf());
	} 

	protected void _createChildren(IOutlineNode parentNode, Gain gain) {
		if (gain.getContext() != null)
			new TerminalNode(parentNode, null, "Context: " + gain.getContext());
		createNode(parentNode, gain.getVerb()); 
	} 
	
	
	protected boolean _isLeaf(Title verb) {
		  return false;
	}


	protected boolean _isLeaf(InfWithZu verb) {
		  return true;
	}
}
