<?php
/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: StylesDocument.php 201 2007-07-11 11:36:55Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/global/AutomaticStylesFragment.php';
require_once 'OpenDocumentPHP/global/FontFaceDeclFragment.php';
require_once 'OpenDocumentPHP/styles/StylesFragment.php';
require_once 'OpenDocumentPHP/styles/MasterStylesFragment.php';
require_once 'OpenDocumentPHP/util/AbstractDocument.php';
/**
 * StylesDocument class.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 201 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08. Feb. 2007
 */
class StylesDocument extends AbstractDocument {
	/**
	 * @var 		StylesFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $styles;
	/**
	 * @var 		FontFaceDeclFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $fontfacedecl;
	/**
	 * @var 		AutomaticStylesFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $automaticstyles;
	/**
	 * @var 		MasterStylesFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $masterstyles;
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct() {
		parent :: __construct('office:document-styles');
		//
		$this->fontfacedecl = new FontFaceDeclFragment($this);
		$this->styles = new StylesFragment($this);
		$this->automaticstyles = new AutomaticStylesFragment($this);
		$this->masterstyles = new MasterStylesFragment($this);
		// append FontFaceDeclFragment
		$this->root->appendChild($this->fontfacedecl->getDocumentFragment());
		// append StylesFragment
		$this->root->appendChild($this->styles->getDocumentFragment());
		// append AutomaticStylesFragment
		$this->root->appendChild($this->automaticstyles->getDocumentFragment());
		// append MasterFragment
		$this->root->appendChild($this->masterstyles->getDocumentFragment());
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFontFaceDeclarations() {
		return $this->fontfacedecl;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getStyles() {
		return $this->styles;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getAutomaticStyles() {
		return $this->automaticstyles;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getMasterStyles() {
		return $this->masterstyles;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.2 - 02. Mar. 2007 This method is no longer necessary. Parent method did it all.
	 */
	function saveXML() {
		return parent :: saveXML();
	}
	/**
	 * Loads styles document into this StylesDocument.
	 * 
	 * @access 	public
	 * @since 	0.5.2 - 02. Mar. 2007
	 */
	function loadXML($source) {
		/*
		 * First we load the document by the parent method
		 */	
		$ret = parent :: loadXML($source);
		
		if ($ret === TRUE) {
			/*
			 * If it was loaded correctly, we need to set up some
			 * local attributes. Therefore we first init the XPath stuff
			 */				
			$this->initXpath();
			/*
			 * Now we need the document root element to fill $this->root 
			 */
			$this->root = $this->documentElement;
			/*
			 * We now setup the $this->styles element... 
			 * First we ask XPath to give us the <office:styles> tag. 
			 */					
			$tmp = $this->xpath->query('/office:document-styles/office:styles');
						
			if ($tmp->length == 1) {
				/*
				 * The only result is the styles tag in this case. So we can use it
				 * to start the StylesFragment class. 
				 */			
				$node = $tmp->item(0);
				$this->styles = new StylesFragment($this, $node);
				/*
				 * We need the font faces declations in a seperate class,
				 * so we try to get them from the document as well:
				 */
				$result = $this->xpath->query('/office:document-styles/office:font-face-decls');
				if ($result->length == 1) {
				 	/*
				 	 * The only result is the font face declations tag in this case. 
				 	 * So we can use it to start the FontFaceDeclFragment class. 
				 	 */			
					$node = $result->item(0);
					$this->fontfacedecl = new FontFaceDeclFragment($this, $node);
				} else {
					/*
				 	 * Something strange happend and this should never occure.
				 	 * *** EXCEPTION HANDLING ***
				 	 */				
					$ret = false;
				}
				/*
				 * We need the automatic-styles stuff in a seperate class,
				 * so we try to get them from the document as well:
				 */				
				$result = $this->xpath->query('/office:document-styles/office:automatic-styles');
				if ($result->length == 1) {
				 	/*
				 	 * The only result is the automatic-styles tag in this case. 
				 	 * So we can use it to start the AutomaticStylesFragment class. 
				 	 */			
					$node = $result->item(0);
					$this->automaticstyles = new AutomaticStylesFragment($this, $node);
				} else {
					/*
				 	 * Something strange happend and this should never occure.
				 	 * *** EXCEPTION HANDLING ***
				 	 */				
				$ret = false;
				}
				/*
				 * We need the master-styles in a seperate class,
				 * so we try to get them from the document as well:
				 */
				$result = $this->xpath->query('/office:document-styles/office:master-styles');
				if ($result->length == 1) {
				 	/*
				 	 * The only result is master-styles tag in this case. 
				 	 * So we can use it to start the MasterStylesFragment class. 
				 	 */			
					$node = $result->item(0);
					$this->masterstyles = new MasterStylesFragment($this, $node);
				} else {
					/*
				 	 * Something strange happend and this should never occure.
				 	 * *** EXCEPTION HANDLING ***
				 	 */				
				$ret = false;
				}
			}
		}
		return $ret;
	}
}
?>
