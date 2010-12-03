<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * ODPElement class file.  
 *
 * PHP Versions 5
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
 * $Id: Fragment.php 146 2007-03-05 09:53:21Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: Validator.php 201 2007-07-11 11:36:55Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.2 - 05. Mar. 2007
 */

require_once 'OpenDocumentPHP/util/Namespaces.php';

/**
 * ODPElement class.  
 *  
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.2 - 05. Mar. 2007
 * @abstract
 */
class ODPElement extends DOMElement implements Namespaces {
	/**
	 * The DOMElement if this is just a cover object.
	 * @access	private
	 */
	private $elem = NULL;
	/**
	 * Constructor.
	 *
	 * This is a workaround, because DOMElements are not realy PHP classes. 
	 * 
	 * @param 		mixed  $tagelem Either a DOMElement or a string
	 * @param 		string $value 
	 * @param 		string $namespace
	 * @since		0.5.2 - 07. Mar. 2007
	 */
	function __construct($tagelem, $value = NULL, $namespace = NULL) {
		if (is_string($tagelem)) {
			// This is a clean ODPElement
			parent :: __construct($tagelem, $value, $namespace);
			$this->elem = NULL;
		}
		elseif ($tagelem instanceof DOMElement) {
			// This is a cover ODPElement
			$this->elem = $tagelem;
		}
		elseif ($tagelem instanceof DOMDocument) {
			// We should call __setRoot to get a new ODPElement and add it 
			// to this DOMDocument.
		} else {
			// throw an ODPElement Exception! 
		};
	}
	/**
	 * Return this element as uncovered DOMElement.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007
	 */
	function getElement() {
		$ret = $this->elem;
		if (is_null($ret)) {
			$ret = $this;
		}
		return $ret;
	}
	/**
	 * Retrieve elements by given tagname and namespace.
	 * 
	 * @param		string $namespace
	 * @param		string $tag
	 * @return 		DOMNodeList List of all found elements. 
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	function getElementsByTagNameNS($namespace, $tag) {
		$ret = NULL;
		if (is_null($this->elem)) {
			$ret = parent :: getElementsByTagNameNS($namespace, $tag);
		} else {
			$ret = $this->elem->getElementsByTagNameNS($namespace, $tag);
		}
		return $ret;
	}
	/**
	 * Retrieve (first) element by given tagname and namespace.
	 * 
	 * @param		string $namespace
	 * @param		string $tag
	 * @return 		DOMElement First found element if there is one,  
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007	 
	 */
	function getElementByTagNameNS($namespace, $tag) {
		$ret = $this->getElementsByTagNameNS($namespace, $tag);
		// Check if we got a DOMNodeList or nothing ...
		if ((!is_null($ret)) && ($ret instanceof DOMNodeList)) {
			// If we got a correct anwser, check if we got items in the list
			if ($ret->length > 0) {
				// We got some, so return the first one, as requested.
				$ret = $ret->item(0);
			}
		}
		return $ret;
	}
	/**
	 * Check if this element has an attribute with given namespace and tagname. 
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007
	 */
	function hasAttributeNS($namespace, $tag) {
		$ret = NULL;
		if (is_null($this->elem)) {
			$ret = parent :: hasAttributeNS($namespace, $tag);
		} else {
			$ret = $this->elem->hasAttributeNS($namespace, $tag);
		}
		return $ret;
	}
	/**
	 * Set attribute with namespace.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007
	 */
	function removeAttributeNS($namespace, $tag) {
		$ret = NULL;
		if (is_null($this->elem)) {
			$ret = parent :: removeAttributeNS($namespace, $tag);
		} else {
			$ret = $this->elem->removeAttributeNS($namespace, $tag);
		}
		return $ret;
	}
	/**
	 * Set attribute with namespace.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007
	 */
	function setAttributeNS($namespace, $tag, $value) {
		$ret = NULL;
		if (is_null($this->elem)) {
			$ret = parent :: setAttributeNS($namespace, $tag, $value);
		} else {
			$ret = $this->elem->setAttributeNS($namespace, $tag, $value);
		}
		return $ret;
	}
	/* *** FIX ME ***
	function getAttributeNodeNS();
	function setAttributeNodeNS();
	function cloneNode();
	function hasChildNodes();
	function hasAttributes();
	function insertBefore();
	function isDefaultNamespace();
	function isSameNode();
	function isSupported();
	function lookupNamespaceURI();
	function lookupPrefix();
	function normalize();
	function removeChild();
	function replaceChild();
	*/
	/**
	 * Set attribute with namespace.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 07. Mar. 2007
	 */
	function appendChild($child) {
		$ret = NULL;
		if ($child instanceof ODPElement) {
			$uc_child = $child->getElement();
			if (is_null($this->elem)) {
				$ret = parent :: appendChild($uc_child);
			} else {
				$ret = $this->elem->appendChild($uc_child);
			}
		} else {
			$ret = parent :: appendChild($child);
		}
		return $ret;
	}
	/**
	 * Check if the current element has a child $tag with $namespace.
	 * 
	 * @return		bool True, if there is such an element else false.
	 * @access 		public
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	function hasChildNS($namespace, $tag) {
		// Get the list and if it has more than one Element return TRUE:
		return ($this->getElementByTagNameNS($namespace, $tag)->length > 0);
	}
	/**
	 * Retrieve a child by its namespace and tag from the current node.
	 * 
	 * @return		bool True, if there is such an element else false.
	 * @access 		public
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	function getChildNS($namespace, $tag) {
		$ret = true;
		// read all possible nodes with this tag and namespace in to a node list
		$nodeList = $this->getElementByTagNameNS($namespace, $tag);
		if ($nodelist->length != 1) {
			// There is no or to many nodes in the node list.
			$ret = false;
		} else {
			// Get first (and only) item of the node list.
			$ret = $nodeList->item(0);
		}
		return $ret;
	}
	/**
	 * Put an attribute with namespace, tag and value. 
	 * If an old attribute exists, it will be removed first.
	 *  
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	function putAttributeNS($namespace, $tag, $value) {
		$ret = true;
		if ($this->hasAttributeNS($namespace, $tag)) {
			$ret = $this->removeAttributeNS($namespace, $tag);
		}
		$this->setAttributeNS($namespace, $tag, $value);
		return $ret;
	}
	/**
	 * Retrieve an attribute with namespace, tag and value. 
	 * If a default value is given and the attribute does not exists, it will be
	 * created.
	 *
	 * @param		string $namespace
	 * @param		string $tag
	 * @param		string $value Default value  
	 * @access 		public
	 * @since 		0.5.2 - 19. Mar. 2007
	 */
	function getAttributeNS($namespace, $tag, $value = null) {
		// Set up default value
		$ret = $value;
		if (is_null($ret)) {
			// If there is no default value, setup false instead.
			$ret = false;
		}
		if ($this->hasAttributeNS($namespace, $tag)) {
			$ret = parent :: getAttributeNS($namespace, $tag);
		} else {
			if (!is_null($value)) {
				$this->setAttributeNS($namespace, $tag, $value);
			}
		}
		return $ret;
	}
	/**
	 * Set a Manifest attribute to the current ODPElement.
	 * 
	 * '<... manifest:$tagname="$value"...>'
	 * 
	 * @param 		string $tagname Tagname without prefix.
	 * @param		string $value Value of the attribute.
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	function setManifestAttribute($tag, $value) {
		return $this->setAttributeNS(self :: MANIFEST, 'manifest:' . $tag, $value);
	}
	/**
	 * Put (set with remove old) a FO attribute to the current ODPElement.
	 * 
	 * '<... fo:$tagname="$value"...>'
	 * 
	 * @param 		string $tagname Tagname without prefix.
	 * @param		string $value Value of the attribute.
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	function putFOAttribute($tagname, $value) {
		return $this->putAttributeNS(self :: FO, 'fo:' . $tagname, $value);
	}
	/**
	 * Put (set with remove old) a sytle attribute to the current ODPElement.
	 * 
	 * '<... style:$tagname="$value"...>'
	 * 
	 * @param 		string $tagname Tagname without prefix.
	 * @param		string $value Value of the attribute.
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	function putStyleAttribute($tagname, $value) {
		return $this->putAttributeNS(self :: STYLE, 'style:' . $tagname, $value);
	}
	/**
	 * Retrieve a style attribute of the current element.
	 * 
	 * '<... style:$tagname="$ret"...>'
	 * @access 		public
	 * @since 		0.5.2 - 19. Mar. 2007
	 */
	function getStyleAttribute($tagname, $value = null) {
		return $this->getAttributeNS(self :: STYLE, $tagname, $value);
	}
	/**
	 * Put (set with remove old) a draw attribute to the current ODPElement.
	 * 
	 * '<... draw:$tagname="$value"...>'
	 * 
	 * @param 		string $tagname Tagname without prefix.
	 * @param		string $value Value of the attribute.
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.2 - 21. Mar. 2007
	 */
	function putDrawAttribute($tagname, $value) {
		return $this->putAttributeNS(self :: DRAW, 'draw:' . $tagname, $value);
	}
	/**
	 * Retrieve a draw attribute of the current element.
	 * 
	 * '<... draw:$tagname="$ret"...>'
	 * @access 		public
	 * @since 		0.5.2 - 21. Mar. 2007
	 */
	function getDrawAttribute($tagname, $value = null) {
		return $this->getAttributeNS(self :: DRAW, $tagname, $value);
	}
}
?>
