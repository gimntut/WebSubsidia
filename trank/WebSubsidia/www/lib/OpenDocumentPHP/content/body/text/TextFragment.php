<?php
/*
 * Created on 26.02.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: TextFragment.php 136 2007-03-02 18:02:29Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/content/body/text/Heading.php';
require_once 'OpenDocumentPHP/content/body/text/Paragraph.php';
require_once 'OpenDocumentPHP/content/body/text/UserFieldDecl.php';
require_once 'OpenDocumentPHP/content/body/text/UserFieldGet.php';
require_once 'OpenDocumentPHP/content/body/text/UserFieldDecls.php';
require_once 'OpenDocumentPHP/util/Fragment.php';
/**
 * TextFragment class.
 * 
 * Here we store the <office:text>...<office:text> part of the content tree.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 136 $
 * @package    	OpenDocumentPHP
 * @subpackage  content_body_text
 * @since 		0.5.2 - 26.02.2007
 */
class TextFragment extends Fragment {
	private $forms = NULL;
	private $sequenzDecl = NULL;
	private $userFieldDecl = NULL;
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.2 - 26.02.2007
	 */
	function __construct($domFragment, $root = null) {
		parent :: __construct($domFragment, $root);
		if (isset ($root) && $root != null) {
		} else {
			$this->root = $this->createOfficeElement('text');
			// $this->root = $this->domFragment->createElementNS(self :: OFFICE, 'office:z');
		}
	}
	/**
	 * Create a new paragraph and append it to the document.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function nextParagraph() {
		$par = new Paragraph($this->domFragment);
		$this->root->appendChild($par->getElement());
		return $par;
	}
	/**
	 * Create a new heading and append it to the document.
	 * 
	 * @param		int $outlineLevel  Outline level of this heading.
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function nextHeading($outlineLevel = 1) {
		$par = new Heading($this->domFragment);
		$par->setHeadingLevel($outlineLevel);
		$this->root->appendChild($par->getElement());
		return $par;
	}
	/**
	 * Update User Field Decl(aration) 
	 * 
	 * @param		string $name  The name of the user-field-decl(aration) to be updated.
	 * @param		string $value The new value.
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */	
	function updateUserFieldDecl($name, $value) {
		if ($this->userFieldDecl == NULL) {
			$node = $this->getTag('/office:document-content/office:body/office:text/text:user-field-decls', '', '', -1);
			if ($node == '') {
				$this->userFieldDecl = new UserFieldDecls($this->domFragment);				
			} else {
				$this->userFieldDecl = new UserFieldDecls($this->domFragment, $node);
			}
		}
		$this->userFieldDecl->setUserFieldDecl($name, $value);
		// *** FIX ME ***
		// We must now scan the document for <text:user-field-get> tags and update them!
		$this->initXpath();
		$result = $this->xpath->query('/*/text:user-field-get[@name="' . $name . '"]');
		foreach ($result as $node) {
			$ufd = new UserFieldGet($this->domFragment, $node);
			$ufd->updateValue($value);
		}
	}
}
?>
