<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * AbstractDocument class file.
 *
 * This is the basic class for all DOMDocuments used in this project. 
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
 * $Id: AbstractDocument.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: AbstractDocument.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

/**
 * Inlcude namespace interface
 */
require_once 'OpenDocumentPHP/util/Namespaces.php';

/**
 * Include basic classes
 */
require_once 'OpenDocumentPHP/util/ODPElement.php';
require_once 'OpenDocumentPHP/styles/properties/ParagraphProperties.php';
require_once 'OpenDocumentPHP/styles/properties/TextProperties.php';
require_once 'OpenDocumentPHP/styles/DefaultStyle.php';
require_once 'OpenDocumentPHP/styles/Style.php';

/*
 * If "OPD_USE_XML_BEAUTIFIER" is set, we use it to pimp up our output.
 * But first we must include the XML_Beautifier once:
 */
if ( defined("OPD_USE_XML_BEAUTIFIER") ) 
{
	require_once 'XML/Beautifier.php';
}

/**
 * AbstractDocument class.
 *  
 * This class can use the PEAR:XML_Beautifier to pimp up the xml output strings.
 * If you want to use it, you should do something like:
 * <code>
 * define("ODP_USE_XML_BEAUTIFIER", "yes");
 * require 'OpenDocumentPHP/AbstractDocument.php';
 * </code>
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */
class AbstractDocument extends DOMDocument implements Namespaces {
	/**
	 * Link to the DOMElement which is the root of this DOM document.
	 * 
	 * @var 		DOMElement
	 * @access		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected $root;
	/**
	* @access 	protected
	* @var 		DOMXpath
	* @since 	0.5.2 - 26. Feb. 2007
	*/
	protected $xpath = null;
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007		
	 */
	function __construct($documentRoot = NULL) {
		parent :: __construct('1.0', 'UTF-8');
		$this->formatOutput = true;
		$this->recover = true;
		//
		$config = $this->config;
		if ($config != null) {
			if ($config->canSetParameter('canonical-form', 'true')) {
				$config->setParameter('canonical-form', 'true');
			}
			if ($config->canSetParameter('datatype-normalizlation', 'true')) {
				$config->setParameter('datatype-normalizlation', 'true');
			}
		}
		//
		$this->_setRoot($documentRoot);
		// I am not sure that this will work, but I try it:
		/**/
		$this->registerNodeClass('DOMDocument', 'AbstractDocument');
		/**/
		$this->registerNodeClass('DOMElement', 'ODPElement');
	}
	/**
	 * Set the root Element of this document.
	 * 
	 * @since 		0.5.1 - 08. Feb. 2007
	 * @access 		protected		
	 */
	protected function _setRoot($documentRoot = NULL) {
		if (isset ($documentRoot) && $documentRoot !== 0) {
			$this->root = $this->createElementNS(self :: OFFICE, $documentRoot);
			$this->root->setAttributeNS(self :: OFFICE, 'office:version', '1.0');
			$this->appendChild($this->root);
		}
	}
	/**
	 * Retrieve the value of an element by its namespace and tag.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @param		string $namespace Namespace of the element.
	 * @param		string $elemet Tag of the element.
	 * @return		mixed The value of the element as string or the boolean 'false',
	 * 			          if no element was found.
	 */
	function getElementNS($namespace, $element) {
		$retValue = false;
		$nodelist = $this->getElementsByTagNameNS($namespace, $element);
		if ($nodelist->length === 1) {
			$retValue = $nodelist->item(0)->nodeValue;
		}
		return $retValue;
	}
	/**
	 * Dumps the internal XML tree back into a string.
	 * 
	 * Creates an XML document from the DOM representation. This function 
	 * is usually called after building a new DOM document from scratch.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @param		DOMNode $node Use this parameter to output only a specific node 
	 * 							  without XML declaration rather than the entire document. 
	 * @param		int $options  Additional Options. Currently only LIBXML_NOEMPTYTAG 
	 * 							  is supported. 
	 */
	function saveXML($node = NULL, $options = NULL) {
		$ret = false;
		$this->normalize();
		$this->normalizeDocument();
		if (isset ($options)) 
		{
			$ret = parent :: saveXML($node, $options);
		}
		elseif (isset ($node)) 
		{
			$ret = parent :: saveXML($node);
		} 
		else 
		{
			$ret = parent :: saveXML();
		}
		/*
		 * If OPD_USE_XML_BEAUTIFIER is set, we will use the XML_Beautifier to pimp
		 * up our output.
		 */
		if ( defined("OPD_USE_XML_BEAUTIFIER") ) 
		{
			/*
			 * Initialise a new XML_Beautifier 
			 */
			$fmt = new XML_Beautifier();
			/*
			 * reformat current xml string
			 */
			$ret = $fmt->formatString($ret);
			/*
			 * destroy XML_Beautifier
			 */
			unset ($fmt);
		}
		return $ret;
	}
	/**
	 * This function is not needed, so we always return false!
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function loadHTML($source) {
		return false;
	}
	/**
	 * This function is not needed, so we always return false!
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function loadHTMLFile($filename) {
		return false;
	}
	/**
	 * This function is not needed, so we always return false!
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function saveHTML() {
		return false;
	}
	/**
	 * This function is not needed, so we always return false!
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function saveHTMLFile($filename) {
		return false;
	}
	/**
	 * Initialize xpath. You must do this before using xpath.
	 * 
	 * @access 		protected
	 * @since 		0.5.2 - 26. Feb. 2007
	 */
	protected function initXpath() {
		if (!isset ($this->xpath)) {
			$this->xpath = new DOMXpath($this);
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
	 * @param       string $value If seted, this is the node value.
	 * @access 		protected
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	protected function createOfficeElement($tag, $value) {
		return $this->createElementNS(self :: OFFICE, 'office:' . $tag, $value);
	}
	/**
	 * Create an DOMElement in the Meta namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		string $tag Tag of the new DOMElement		 
	 * @param       string $value If seted, this is the node value.
	 * @access 		protected
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	protected function createMetaElement($tag, $value = null) {
		return $this->createElementNS(self :: META, 'meta:' . $tag, $value);
	}
	/**
	 * Create an DOMElement in the Meta namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		string $tag Tag of the new DOMElement		 
	 * @param       string $value If seted, this is the node value.
	 * @access 		protected
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	protected function createStyleElement($tag, $value = null) {
		return $this->createElementNS(self :: STYLE, 'style:' . $tag, $value);
	}
	/**
	 * Create an DOMElement in the DC namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		string $tag Tag of the new DOMElement		 
	 * @param       string $value If seted, this is the node value.
	 * @access 		protected
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	protected function createDCElement($tag, $value = null) {
		return $this->createElementNS(self :: DC, 'dc:' . $tag, $value);
	}
	/**
	 * Create an DOMElement in the Manifest namespace with tag $tag.
	 * 
	 * @return		DOMElement
	 * @param		string $tag Tag of the new DOMElement		 
	 * @param       string $value If seted, this is the node value.
	 * @access 		protected
	 * @since 		0.5.2 - 05. Mar. 2007
	 */
	protected function createManifestElement($tag, $value = null) {
		return $this->createElementNS(self :: MANIFEST, 'manifest:' . $tag, $value);
	}
	/**
	 * Create an ODPElement as '<style:text-properties>'.
	 * 
	 * @return		ODPElement
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	public function createTextPropertiesElement() {
		/* 
		//It should be:
		$ret = new TextProperties('style:text-properties', NULL, self::STYLE );
		$ret = $this->adoptNode($ret);
		return $ret; 
		//But we must use: _PHP IS A MESS_ */
		return new TextProperties($this->createStyleElement('text-properties'));
	}
	/**
	 * Create an ODPElement as '<style:paragraph-properties>'.
	 * 
	 * @return		ODPElement
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	public function createParagraphPropertiesElement() {
		/* 
		//It should be:
		$ret = new ParagraphProperties('style:paragraph-properties', NULL, self::STYLE );
		$ret = $this->adoptNode($ret);
		return $ret; 
		//But we must use: _PHP IS A MESS_ */
		return new ParagraphProperties($this->createStyleElement('paragraph-properties'));
	}
	/**
	 * Create an ODPElement as '<style:graphic-properties>'.
	 * 
	 * @return		ODPElement
	 * @access 		public
	 * @since 		0.5.2 - 16. Mar. 2007
	 */
	public function createGraphicPropertiesElement() {
		/* 
		//It should be:
		$ret = new GraphicProperties('style:graphic-properties', NULL, self::STYLE );
		$ret = $this->adoptNode($ret);
		return $ret;
		// Alternativly this should work too:
		*/
		$this->registerNodeClass('DOMElement', 'GraphicProperties');
		$ret = $this->createStyleElement('graphic-properties');
		$this->registerNodeClass('DOMElement', NULL);
		/*
		//But we must use: _PHP IS A MESS_ 		
		$ret= new GraphicProperties($this->createStyleElement('graphic-properties'));
		*/
		return $ret;
	}
	/**
	 * Create an ODPElement as '<style:default-style>'.
	 *
	 * @return		ODPElement
	 * @access 		public
	 * @since 		0.5.2 - 19. Mar. 2007
	 */
	public function createDefaultStyleElement() {
		/* 
		//It should be:
		$ret = new ParagraphProperties('style:paragraph-properties', NULL, self::STYLE );
		$ret = $this->adoptNode($ret);
		return $ret; 
		//But we must use: _PHP IS A MESS_ */
		return new DefaultStyle($this->createStyleElement('default-style'));
	}
	/**
	 * Create an ODPElement as '<style:style>'.
	 * 
	 * @return		ODPElement
	 * @access 		public
	 * @since 		0.5.2 - 19. Mar. 2007
	 */
	public function createStyleStyleElement() {
		/* 
		//It should be:
		$ret = new ParagraphProperties('style:paragraph-properties', NULL, self::STYLE );
		$ret = $this->adoptNode($ret);
		return $ret; 
		//But we must use: _PHP IS A MESS_ */
		return new Style($this->createStyleElement('style'));
	}
}
?>