<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * Abstract Fragment class file  
 * 
 * PHP Version 5
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
 * $Id: Fragment.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: Fragment.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.0 - 08. Feb. 2007
 * @deprecated  0.5.2 - 05. Mar. 2007 Use ODPElement instead of Fragment or ElementFragment!
 */

/**
 * Include namespace interface  
 */
require_once 'OpenDocumentPHP/util/Namespaces.php';

/**
 * Abstract Fragment class.  
 *  
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @abstract
 * @since 		0.5.0 - 08. Feb. 2007
 * @deprecated  0.5.2 - 05. Mar. 2007 Use ODPElement instead of Fragment or ElementFragment!
 */
abstract class Fragment implements Namespaces {
	/**
 	 * @access protected
	 */
	protected $domFragment;
	/**
	 * @access protected
	 */
	protected $root;
	/**
	 * @access protected
	 * @var DOMXpath
	 */
	protected $xpath = null;
	/**
	 * Constructor method.
	 * 
	 * @param 		DOMDocument $domFragment Basic DOM document.
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($domFragment, $root = NULL) {
		$this->domFragment = $domFragment;
		if (isset($root) && ($root !== 0)) {
			$this->root = $root;
		} else {			
			$this->root = $this->domFragment;
		}
	}
	/**
	 * Returns the root DOMElement of this DOM fragment.
	 * 
	 * @return		DOMElement Root node of this DOM fragment.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getDocumentFragment() {
		return $this->root;
	}
	/**
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function getTag($query, $namespace, $tag, $defaultValue) {
		$ret = null;
		// init XPath
		$this->initXpath();
		// Do query
		// ***fix me***:	
		//echo 'Query:' . $query;
		$result = $this->xpath->query($query);
		// Check result
		if ($result->length <= 0) {
			// We did not find a node in the document, so we need to add a new tag:
			if ($defaultValue !== -1) {	
				//echo "-> create new node!";		
				$ret = $this->domFragment->createElementNS($namespace, $tag, $defaultValue);
				$this->root->appendChild($ret);
			} else {
				//echo "-> no node found!";
				$ret = '';
			}							
		} else {
			// There where nodes in the list. So we grab the first one in the nodelist.
			//echo '-> found node!'; 
			$ret = $result->item(0);
		}
		//echo "\n";
		return $ret;
	}
	/**
	 * Set (which means append or replace an existing node) a new node.
	 * 
	 * @param		DOMElement $node Old node which should be replaced	
	 * @param		DOMElement $newNode New node which should be appended or replace the <b>$node</b> node
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function setTag($node, $newNode) {
		$tmp = $node->parentNode;
		if ($tmp != null) {
			//$tmp->replaceNode($newNode, $node);
			//$tmp->replaceChild($node, $newNode);
			//$tmp->replaceChild($newNode, $node);
			$tmp->removeChild($node);
			$tmp->appendChild($newNode);
		} else {
			$this->root->appendChild($newNode);
		}
	}
	/**
	 * Check if the current element has a child $tag with $namespace.
	 * 
	 * @return		bool True, if there is such an element else false.
	 * @access 		public
	 * @since 		0.5.2 - 04. Mar. 2007
	 */
	function hasChild($namespace, $tag) {
		// Get the list and if it has more than one Element return TRUE:
		return ($this->root->getElementByTagNameNS($namespace, $tag)->length > 0);
	}
	/**
	 * Retrieve a child by its namespace and tag from the current node.
	 * 
	 * @return		bool True, if there is such an element else false.
	 * @access 		public
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	function getChild($namespace, $tag) {
		$ret = true;
		// read all possible nodes with this tag and namespace in to a node list
		$nodeList = $this->root->getElementByTagNameNS($namespace, $tag);
		if ($nodelist->length != 1 )  {
			// There is no or to many nodes in the node list.
			$ret = false;
		} else {
			// Get first (and only) item of the node list.
			$ret = $nodeList->item(0);
		} 
		return $ret;
	}
	/**
	 * Initialize xpath. You must do this before using xpath.
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function initXpath() {
		if (!isset ($this->xpath)) {
			$this->xpath = new DOMXpath($this->domFragment);
			$this->xpath->registerNamespace('office', self :: OFFICE);
			$this->xpath->registerNamespace('meta', self :: META);
			$this->xpath->registerNamespace('text', self :: TEXT);
			$this->xpath->registerNamespace('dc', self :: DC);
			$this->xpath->registerNamespace('xlink', self :: XLINK);
			$this->xpath->registerNamespace('style', self :: STYLE);
			$this->xpath->registerNamespace('draw', self :: DRAW);
			$this->xpath->registerNamespace('table', self :: TABLE);
			$this->xpath->registerNamespace('mathml', self :: MATHML);
		}
	}
	/**
	 * Create an DOMElement in the Office namespace with tag $tag.
	 * 
	 * Example:
	 * 
	 * <code>
	 * 	$this->createOfficeElement('document');
	 * </code>
	 * will create an DOMElement like:
	 * <code>
	 * 	<office:document xmlns:office="" />
	 * </code>
	 * .
	 * 
	 * @return		DOMElement
	 * @param		string $tag Tag of the new DOMElement		 
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.2 - 05. Mar. 2007 Use the AbstractDocument->create...Element() method instead!
	 */
	protected function createOfficeElement($tag) {
		return $this->domFragment->createElementNS(self :: OFFICE, 'office:' . $tag);
	}
	/**
	 * Create an DOMElement in the Meta namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		$string $tag Tag of the new DOMElement	
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.2 - 05. Mar. 2007 Use the AbstractDocument->create...Element() method instead!
	 */
	protected function createMetaElement($tag) {
		return $this->domFragment->createElementNS(self :: META, 'meta:' . $tag);
	}
	/**
	 * Create an DOMElement in the Meta namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		$string $tag Tag of the new DOMElement	
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.2 - 05. Mar. 2007 Use the AbstractDocument->create...Element() method instead!
	 */
	protected function createStyleElement($tag) {
		return $this->domFragment->createElementNS(self :: SYTLE, 'style:' . $tag);
	}
	/**
	 * Create an DOMElement in the DC namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		$string $tag Tag of the new DOMElement
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.2 - 05. Mar. 2007 Use the AbstractDocument->create...Element() method instead!
	 */
	protected function createDCElement($tag) {
		return $this->domFragment->createElementNS(self :: DC, 'dc:' . $tag);
	}
	/**
	 * Set attribute with namespace.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	function appendChild($child) {
		$ret = NULL;
		if ($child instanceof ODPElement) {
			$uc_child = $child->getElement();
			$ret = $this->root->appendChild($uc_child);			
		} else {
			$this->root->appendChild($child);
		}
		return $ret;
	}
}
?>