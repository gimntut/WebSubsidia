<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net) 
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * SettingsDocument class file.
 * 
 * OpenDocumentPHP does not support the settings document right now. But it is in
 * the OpenDocument documentation, so we have build a wrapper class for it.
 *  
 * Because of that, no real functionality is added. Feel free to change it. ;-)
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
 * $Id: SettingsDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 *
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	settings
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: SettingsDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/util/AbstractDocument.php';

/**
 * SettingsDocument class.
 * 
 * OpenDocumentPHP does not support the settings document right now. But it is in
 * the OpenDocument documentation, so we have build a wrapper class for it.
 *  
 * Because of that, no real functionality is added. Feel free to change it. ;-)
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	settings
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */
class SettingsDocument extends AbstractDocument {
	/**
	 * Root element of the settings DOM document.
	 * 
	 * @var 		DOMElement
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $settings;
	/**
	 * Constructor method.
	 * 
	 * We construct an empty settings document here. It should look like:
	 * <code>
	 *  <?xml version="1.0" encoding="UTF-8"?>
	 * 	<office:document-settings xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.0">
	 * 		<office:settings/>
	 *	</office:document-settings>
	 * </code>
	 * 
	 * This is in general not a valid document, because the <office:settings> tag needs
	 * some children (one or more config items). If there are no such children the
	 * {@link saveXML()} method will remove the <office:settings/> tag to match the
	 * RelaxNG specification. 
	 * So currently the saved settings.xml should look more like:
	 * <code>
	 *  <?xml version="1.0" encoding="UTF-8"?>
	 * 	<office:document-settings xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" office:version="1.0" /
	 * </code>
	 * 	  
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct() {
		parent :: __construct('office:document-settings');
		/*
		 * create a main (not root) element ( <office:settings>...</office:settings> )
		 */ 
		$this->settings = $this->createElementNS(self :: OFFICE, 'office:settings');
		/*
		 * and add it to the document root. This may be wrong, if we did not add
		 * any further config items to the settings document. But we will correct this
		 * later in the saveXML method.
		 */
		$this->root->appendChild($this->settings);
	}
	
	/**
	 * Save the needed parts of the settings.xml as a XML. If we do not have
	 * any config items in th settings document, we remove anything and leave 
	 * just the skeleton.
	 *  
	 * @access		private
	 * @since		0.5.3 - 09. Jul. 2007
	 */
	function saveXML() {
		/*
		 * We must check if this->settings has any children, if not we *must* remove it from the tree.
		 */
		if ( !$this->settings->hasChildNodes() ) {
			$this->root->removeChild( $this->settings );
		}
		/*
		 * Now we can do the inhereted stuff.
		 */
		return parent::saveXML();
	}
	/**
	 * Loads a settings document into this SettingsDocument object.
	 * 
	 * @access 	public
	 * @since 	0.5.2 - 22. Feb. 2007
	 */
	function loadXML($source) {
		/*
		 * First we load the document by the parent method
		 */
		$ret = parent::loadXML($source);
		
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
			 * We now setup the $this->settings element... 
			 * First we ask XPath to give us the <office:settings> tag. 
			 */			
			$tmp = $this->xpath->query('/office:document-settings/office:settings');			
			
			if ($tmp->length == 1) {
				/*
				 * The only result is the settings tag in this case. So we can put
				 * it in the $this->settings attribute.
				 */
				$this->settings = $tmp->item( 0 );
			} elseif ($tmp->length == 0) {
				/*
				 * We got an empty seetings document. This could happen. We need
				 * to setup a <office:settings> element and add it to the document.
				 * If no other config item will be added to this, the saveXML 
				 * method will eliminate this empty tag.
				 */
				$this->settings = $this->createElementNS(self :: OFFICE, 'office:settings');
				$this->root->appendChild($this->settings);				
			} else {
				/*
				 * Something strange happend and this should never occure.
				 * *** EXCEPTION HANDLING ***
				 */
				$ret = FALSE;			
			}
		}
		return $ret;
	}
}
?>