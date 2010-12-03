<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 10. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * MetaFragment class file.
 *    
 * PHP versions 5
 *   
 * LICENSE:
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
 * $Id: MetaFragment.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * 
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  meta
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     SVN: $Id: MetaFragment.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/util/Fragment.php';

/**
 * MetaFragment class.
 *    
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  meta
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */
class MetaFragment extends Fragment {
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $generator = null;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $initialCreator = null;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $creationDate = null;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $printedBy = null;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $printDate = null;
	/**
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $editDuration = null;
	/**
	 * @var			array ...
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
		 */
	private $keywords = null;
	/**
	 * @var			array ...
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $userDefineds = null;
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($domFragment, $root) {
		parent :: __construct($domFragment, $root);
		$this->keywords = array ();
		$this->userDefineds = array (
			'Info 1' => '',
			'Info 2' => '',
			'Info 3' => '',
			'Info 4' => ''
		);
		$this->root = $root;
		$this->initXpath();
		//setlocale(LC_TIME, 'de_DE');
		//		$this->setUserDefinedArray($this->userDefineds);
	}
	/**
	 * 
	 */
	function initMetaFragment() {
		$this->setGenerator();
		$this->setCreationDate();
	}
	/**
	 *
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function getTag($tag, $defaultValue) {
		return parent :: getTag('//*/office:meta/meta:' . $tag, self :: META, $tag, $defaultValue);
	}
	/**
	 * 
	 * @deprecated  0.5.1 - 09. Feb. 2007
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getDocumentFragment() {
		return null;
	}
	/**
	 * Retrieve the so called initial-creator. This should be the first author of this document.
	 * 
	 * In a meta document, if there is a tag like this one
	 * <code>
	 * <meta:initial-creator>Alex Latchford</meta:initial-creator>
	 * <code>
	 * this method will return "Alex Latchford" as a string.
	 * 
	 * @return		String The initial creator of this document.
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getInitialCreator() {
		if (!isset ($this->initialCreator)) {
			$this->initialCreator = $this->getTag('initial-creator', '');
		}
		return $this->initialCreator->nodeValue;
	}
	/**
	 * Put the so called initial-creator into the current meta document. The initial creator should be the first
	 * author of an OpenDocument and should allways be put in.
	 * 
	 * If you write something like:
	 * <code>
	 * 	$metaDoc->setInitialCreator('Norman Markgraf');
	 * </code>
	 * to a MetaDocument $metaDoc, the initial creator is set to the string 'Norman Markgraf'.
	 * 
	 * @param		String	$creator The new initial creator of this OpenDocument.
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setInitialCreator($creator) {
		if ($this->getInitialCreator() != $creator) {
			$newNode = $this->domFragment->createElementNS(self :: META, 'meta:initial-creator', $creator);
			$this->setTag($this->initialCreator, $newNode);
			$this->initialCreator = $newNode;
		}
	}
	/**
	 * Retrieve the generator tag. The generator is the name of the programm on which the current OpenDocument was
	 * generated.
	 * 
	 * 
	 * @return		String The generator tag.
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getGenerator() {
		if (!isset ($this->generator)) {
			$this->generator = $this->getTag('generator', '');
		}
		return $this->generator->nodeValue;
	}
	/**
	 * Put the generator tag into the meta document. If called with no parameter the generator tag will be set to:
	 * 'OpenDocumentPHP/$Revision: 206 $', as this is the default value
	 * 
	 * @param		String The new generator tag.
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setGenerator($generator = 'OpenDocumentPHP/$Revision: 206 $') {
		if ($this->getGenerator() != $generator) {
			$newNode = $this->domFragment->createElementNS(self :: META, 'meta:generator', $generator);
			$this->setTag($this->generator, $newNode);
			$this->generator = $newNode;
		}
	}
	/**
	 *
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function makeCreationDate($s = null) {
		$ret = $s;
		if (is_null($s)) {
			$ret = date('c');
		} else {
			if (is_string($s)) {
				if (($time = strtotime($s)) === -1) {
					// *** FIX ME ***
					echo "**FIX ME**";	
				}else {
				$ret = date('c', strtotime($s));
				}	
			} else {
				$ret = date('c', $s);
			}
		}
		return $ret;
	}
	/**
	 * Retrieve the creation date of this document.
	 * 
	 * @return		string creation date
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getCreationDate() {
		if (!isset($this->creationDate)) {
			$this->creationDate = $this->getTag('creation-date', $this->makeCreationDate());
		}
		return $this->creationDate->nodeValue;
	}
	/**
	 * Put the creation date into the meta document. If no date parameter where given, the current date
	 * will be used. 	 
	 * 
	 * @param       string|date new creation date
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setCreationDate($date = null) {
		$tmpdate = $this->makeCreationDate($date);
		if ($this->getCreationDate() != $tmpdate) {
			$newNode = $this->domFragment->createElementNS(self :: META, 'meta:creation-date', $tmpdate);
			$this->setTag($this->creationDate, $newNode);
			$this->creationDate = $newNode;
		}
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getPrintDate() {
		if (!isset ($this->printDate)) {
			$this->printDate = $this->getTag('print-date', '');
		}
		return $this->printDate->nodeValue;
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setPrintDate($date = null) {
		$tmpdate = $this->makeCreationDate($date);
		if ($this->getPrintDate() != $tmpdate) {
			$newNode = $this->domFragment->createElementNS(self :: META, 'meta:print-date', $date);
			$this->setTag($this->printDate, $newNode);
			$this->printDate = $newNode;
		}
	}
	/**
	 * 
	 * @param  		array $userDefined
	 * @access		public
	 * @since 		0.5.2 - 03. Mar. 2007
	 */
	function setUserDefinedArray(array $userDefined) {
		foreach ($userDefined as $name => $value) {
			$this->setUserDefined($name, $value);
		}
	}
	/**
	 *
	 * @param		string $name
	 * @param 		string $value
	 * @access		public
	 * @since 		0.5.2 - 03. Mar. 2007
	 */
	function setUserDefined($name, $value) {		
		$oldNode = $this->getTag('user-defined/[meta:name="' . $name . '"]', $value);
		$newNode = $this->domFragment->createElementNS(self :: META, 'meta:user-defined');
		$newNode->setAttributeNS(self :: META, 'meta:name', $value);
		$this->setTag($oldNode, $newNode);
	}
}
?>
