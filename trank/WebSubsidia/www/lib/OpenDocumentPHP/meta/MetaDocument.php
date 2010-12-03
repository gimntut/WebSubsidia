<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * MetaDocument class.
 *  
 * In this container class we will store all the meta data and build a DOM document 
 * out of it. 
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
 * $Id: MetaDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  meta
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: MetaDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/meta/DublinCoreFragment.php';
require_once 'OpenDocumentPHP/meta/MetaFragment.php';
require_once 'OpenDocumentPHP/util/AbstractDocument.php';

/**
 * MetaDocument class.
 *  
 * In this container class we will store all the meta data and build a DOM document 
 * out of it. 
 *
 * You can find more informations about this in the 
 * {@link http://www.oasis-open.org/committees/download.php/12572/OpenDocument-v1.0-os.pdf OpenDocument format handbook v1.0}
 * page 40ff.
 *
 * Also you should now something about Dublin Meta core data. 
 * Take a look at the {@link http://dublincore.org/ Dublin core webpage} or read 
 * {@link http://en.wikipedia.org/wiki/Dublin_Core Dublin core in Wikipedia},
 * {@link http://dublincore.org/documents/usageguide/qualifiers.shtml Dublin core qualifiers}
 * or {@link http://de.wikipedia.org/wiki/Dublin_Core Dublin core in german Wikipedia}.
 *
 * To put some dublin core meta data in the MetaDocument, request a DublinCoreFragment and 
 * add the meta data there.
 * 
 * You can also add OpenDocument meta data to the MetaFragment. 
 *
 * This is an example of a meta.xml file:
 * <code>
 * <?xml version="1.0" encoding="UTF-8"?>
 * <office:document-meta 
 *      xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
 *      xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
 *      xmlns:dc="http://purl.org/dc/elements/1.1/"
 *      xmlns:xlink="http://www.w3.org/1999/xlink">
 *   <office:meta>
 *     <meta:generator>OpenOffice.org/1.9.118$Win32 OpenOffice.org_project/680m118$Build-8936</meta:generator>
 *     <meta:initial-creator>Peter Funny</meta:initial-creator>
 *     <meta:creation-date>2005-09-27T16:53:48</meta:creation-date>
 *     <dc:creator>Peter Funny</dc:creator>
 *     <dc:date>2005-09-29T18:12:57</dc:date>
 *     <meta:printed-by>Peter Funny</meta:printed-by>
 *     <meta:print-date>2005-09-29T17:57:42</meta:print-date>
 *     <dc:language>en-EN</dc:language>
 *     <meta:editing-cycles>11</meta:editing-cycles>
 *     <meta:editing-duration>PT6H11M44S</meta:editing-duration>
 *     <meta:user-defined meta:name="Info 1"/>
 *     <meta:user-defined meta:name="Info 2"/>
 *     <meta:user-defined meta:name="Info 3"/>
 *     <meta:user-defined meta:name="Info 4"/>
 *     <meta:document-statistic 
 *           meta:table-count="0" 
 *           meta:image-count="4" 
 *           meta:object-count="0" 
 *           meta:page-count="5" 
 *           meta:paragraph-count="92" 
 *           meta:word-count="1460" 
 *           meta:character-count="10405"/>
 *   </office:meta>
 * </office:document-meta>
 * </code>
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  meta
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.0 - 08. Feb. 2007
 */
class MetaDocument extends AbstractDocument {
	/**
	 * Root element of the meta DOM document. 
	 * 
	 * @var 		DOMElement
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $meta;
	/**
	 * DublinCoreFragment is the container for dublin core meta datas.
	 * 
	 * @var 		DublinCoreFragment
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $dublinCore;
	/**
	 * MetaFragment is the container for OpenDocument meta datas.
	 * 
	 * @var 		MetaFragment
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $metaCore;
	/**
	 * Link to the DOMElement which is the root of this DOM document.
	 * 
	 * @var 		DOMElement
	 * @access		protected
	 * @since 		0.5.0 - 08.02.2007
	 */
	protected $root;	
	/**
	 * Construtor method.
	 * 
	 * Creates two container classes to store/get dublin core and open document
	 * meta datas.
	 * 
	 * @since 		0.5.0 - 08.02.2007
	 */
	function __construct() {
		parent :: __construct('office:document-meta');
		//
		$this->meta = $this->createElementNS(self :: OFFICE, 'office:meta');
		$this->root->appendChild($this->meta);
		$this->dublinCore = new DublinCoreFragment($this, $this->meta);
		$this->metaCore = new MetaFragment($this, $this->meta);
		// Setup MetaFragment, because it is empty and should not be.
		$this->metaCore->initMetaFragment();
	}
	/**
	 * Retrieve a DublinCoreFragment to store/get dublin core meta date in it.
	 * 
	 * @return 		DublinCoreFragment 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDublinCoreFragment() {
		return $this->dublinCore;
	}
	/**
	 * Retrieve a MetaFragment to store/get opendocument meta data in it.
	 * 
	 * @return 		MetaFragment
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getMetaFragment() {
		return $this->metaCore;
	}
	/**
	 * Loads an meta document into this MetaDocument.
	 * 
	 * @access 	public
	 * @since 	0.5.2 - 22.02.2007
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
			 * We now setup the $this->meta element... 
			 * First we ask XPath to give us the <office:meta> tag. 
			 */						
			$tmp = $this->xpath->query('/office:document-meta/office:meta');			
						
			if ($tmp->length == 1) {
				/*
				 * The only result is the meta tag in this case. So we can put
				 * it in the $this->meta attribute.
				 */			
				$this->meta = $tmp->item(0);
				/*
				 * Now we set up the dublin core part of the meta document
				 */
				$this->dublinCore = new DublinCoreFragment($this, $this->meta);
				/*
				 * And now the (OpenDocument) meta part of the meta document
				 */
				$this->metaCore = new MetaFragment($this, $this->meta);
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