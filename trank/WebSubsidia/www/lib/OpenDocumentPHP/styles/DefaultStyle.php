<?php
/*
 * Created on 21.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 *
 * PHP versions 5.2 or better.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the GPL. For more information please see
 * <http://opendocumentphp.org>.
 * 
 * $Id: DefaultStyle.php 164 2007-04-10 11:24:30Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ODPElement.php';
require_once 'OpenDocumentPHP/styles/properties/TextProperties.php';
require_once 'OpenDocumentPHP/styles/properties/ParagraphProperties.php';
require_once 'OpenDocumentPHP/styles/properties/GraphicProperties.php';
require_once 'OpenDocumentPHP/util/Validator.php';
/**
 * DefaultStyle class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 164 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08.02.2007
 */
class DefaultStyle extends ODPElement {
	/**
	 * 
	 * @access	private
	 * @var		ParagraphProperties
	 */
	private $paragraphProp = null;
	/**
	 * @access	private
	 * @var		TextProperties
	 */
	private $textProp = null;
	/**
	 * Set element to 'style:default-style'.
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08.02.2007
	 * @deprecated  0.5.2 - 19.03.2007 No longer needed!
	 */
	protected function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: STYLE, 'style:default-style');
	}
	/* ------------ */
	/* Style Family */
	/* ------------ */
	/**
	 * Set family.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 * @param 		string $value Must be a value out of 'ruby','control', 'presentation',
	 * 							  'drawing-page', 'default', 'chart', 'table-page',
	 * 							  'table-cell', 'table-row', 'table-column',  
	 * 							  'section', 'text', 'table', 'paragraph' or 'graphic'.		
	 */
	function setFamily($value) {
		$ret = Validator :: checkFamilyValues($value);
		if ($ret) {
			//$this->setAttributeNS(self :: STYLE, 'style:family', $value);
			$this->putStyleAttribute('family', $value);
		}
		return $ret;
	}
	/**
		 * Retrieve family.
		 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getFamily() {
		return $this->getStyleAttribute('family');
	}
	/**
	 * Checks if the current default style has an paragraph-properties
	 * element as child.
	 * 
	 * @return bool True if there is an <style:paragraph-properties> tag as child of the current <style:default-style> tag.
	 * @access		public
	 * @since 		0.5.2 - 04.03.2007
	 */
	function hasParagraphProperties() {
		return $this->hasChildNS(self :: STYLE, 'paragraph-properties');
	}
	/**
	 * Checks if the current default style has an text-properties
	 * element as child.
	 * 
	 * @return bool True if there is an <style:text-properties> tag as child of the current <style:default-style> tag.
	 * @access		public
	 * @since 		0.5.2 - 04.03.2007
	 */
	function hasTextProperties() {
		return $this->hasChildNS(self :: STYLE, 'text-properties');
	}
	/**
	 * Checks if the current default style has an graphic-properties
	 * element as child.
	 * 
	 * @return bool True if there is an <style:graphic-properties> tag as child of the current <style:default-style> tag.
	 * @access		public
	 * @since 		0.5.2 - 04.03.2007
	 */
	function hasGraphicProperties() {
		return $this->hasChildNS(self :: STYLE, 'graphic-properties');
	}
	/**
	 * Retrieve a <style:paragraph-properties> tag.
	 * If it does not exists, create on and add it as a child.
	 * 
	 * @access		public
	 * @since 		0.5.2 - 03.03.2007
	 * @todo		Replace the else path by something which uses $this->getChild(..)! 
	 */
	function getParagraphProperties() {
		if ($this->paragraphProp == null) {
			// Look up <style:paragraph-properties> in current child list.
			if ($this->hasParagraphProperties()) {
				// Get the found properties, and set class attribute.
				$tmp = $this->getElementByTagNameNS(self :: STYLE, 'paragraph-properties');
				$this->paragraphProp = new ParagraphProperties($tmp);
			} else {
				// If not found, create a new on
				$this->paragraphProp = $this->getElement()->ownerDocument->createParagraphPropertiesElement();
				$this->appendChild($this->paragraphProp);
			}
		}
		return $this->paragraphProp;
	}
	/**
	 * Retrieve a <style:text-properties> tag.
	 * If it does not exists, create on and add it as a child.
	 * 
	 * @access		public
	 * @since 		0.5.2 - 03.03.2007
	 * @todo		Replace the else path by something which uses $this->getChild(..)! 
	 */
	function getTextProperties() {
		/*
		echo 'Retrieving text-properties:'."\n";
		if ($this->root->ownerDocument instanceof AbstractDocument) {
			echo 'The root is an AbstactDocument :-)'."\n";
		} else {
			echo 'The root is *NOT* an AbstactDocument :('."\n";
		}
		*/
		if ($this->textProp == null) {
			// Look up <style:text-properties> in current child list.
			if ($this->hasTextProperties()) {
				// Get the found properties, and set class attribute.
				$tmp = $this->getElementByTagNameNS(self :: STYLE, 'text-properties');
				$this->textProp = new TextProperties($tmp);
			} else {
				// If not found, create a new on
				$this->textProp = $this->getElement()->ownerDocument->createTextPropertiesElement();
				$this->appendChild($this->textProp->getElement());
			}
		}
		return $this->textProp;
	}
	/**
	 * Retrieve a <style:graphic-properties> tag.
	 * If it does not exists, create on and add it as a child.
	 * 
	 * @access		public
	 * @since 		0.5.2 - 03.03.2007
	 * @todo		Replace the else path by something which uses $this->getChild(..)! 
	 */
	function getGraphicProperties() {
		if ($this->textProp == null) {
			// Look up <style:graphic-properties> in current child list.
			if ($this->hasGraphicProperties()) {
				// Get the found properties, and set class attribute.
				$tmp = $this->getElementByTagNameNS(self :: STYLE, 'graphic-properties');
				$this->graphicProp = new GraphicProperties($tmp);
			} else {
				// If not found, create a new on
				$this->graphicProp = $this->getElement()->ownerDocument->createGraphicPropertiesElement();
				;
				$this->appendChild($this->graphicProp->getElement());
			}
		}
		return $this->graphicProp;
	}
}
?>
