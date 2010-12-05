<?php
/*
 * Created on 04.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: BodyFragment.php 183 2007-06-12 07:58:41Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/content/body/TableFragment.php';
require_once 'OpenDocumentPHP/content/body/text/Heading.php';
require_once 'OpenDocumentPHP/content/body/text/Paragraph.php';
require_once 'OpenDocumentPHP/content/body/text/TextFragment.php';
require_once 'OpenDocumentPHP/util/Fragment.php';
/**
 * BodyFragment class. 
 * Класс BodyFragment. 
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 183 $
 * @package    	OpenDocumentPHP
 * @subpackage	content_body
 * @since 		0.5.0 - 08.02.2007
 */
class BodyFragment extends Fragment {
	/**
	 * @var 		array Array of tables in this document.
	 * @access		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $tables;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $root2 = null;
	/**
	 * Constructor method.
	 * Конструктор.
	 * 
	 * @since 		0.5.0 - 08.02.2007
	 */
	function __construct($domFragment) {
		parent :: __construct($domFragment);
		$this->root = $this->createOfficeElement('body');
		$this->tables = array ();
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setSpreadsheet() {
		//*** FIX ME ***
		//*** ИСПРАВЬ МЕНЯ ***
		// $this->root2 = $this->createOfficeElement('spreadsheet');
		//$this->root->appendChild($this->root2);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setText() {
		$this->root2 = new TextFragment($this->domFragment);
		$this->root->appendChild($this->root2->getDocumentFragment());
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getNewTableFragment($name) {
		$ret = new TableFragment($this->domFragment);
		$ret->setTableName($name);
		$this->tables[$name] = $ret;
		return $ret;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDocumentFragment() {
		foreach ($this->tables as $elem) {
			$this->root2->appendChild($elem->getDocumentFragment());
		}
		return $this->root;
	}
	/**
	 * 
	 * @access 		public
	 * @deprecated	0.5.2 - 26.02.2007
	 * @since 		0.5.0 - 08.02.2007
	 */
	function nextParagraph() {
		return $this->root2->nextParagraph();
	}
	/**
	 * 
	 * @access 		public
	 * @deprecated	0.5.2 - 26.02.2007
	 * @since 		0.5.0 - 08.02.2007
	 */
	function nextHeading($outlineLevel = '1') {
		return $this->root2->nextHeading($outlineLevel);
	}
	
	function getTextFragment() {
		if ($this->root2 == null) {
			$this->initXpath();
			$result = $this->xpath->query('/office:document-content/office:body/office:text');
			if ($result->length == 1) {
					$node = $result->item(0);
					$this->root2 = new TextFragment($this->domFragment, $node);
			} else {
					$ret = false;
			}
			
		}
		return $this->root2;
	}
}
?>