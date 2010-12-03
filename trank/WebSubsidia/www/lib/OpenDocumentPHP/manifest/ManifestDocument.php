<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 29. Dec. 2006 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * ManifestDocument class file.
 * 
 * This class extends DOMDocument to fit a manifest document as it is used 
 * by OpenDocumentArchives to store the meta information into it.
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
 * $Id: ManifestDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	manifest
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: ManifestDocument.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 * @todo		We need to support encryption data. 
 * @todo		Also we need to support the optional size part. 
 */

require_once 'OpenDocumentPHP/util/AbstractDocument.php';

/**
 * ManifestDocument class
 * 
 * This class extends DOMDocument to fit a manifest document as it is used 
 * by OpenDocumentArchives to store the meta information into it.
 * 
 * Example:
 * <code> 
 * $manifest = new ManifestDocument( 'application/vnd.oasis.opendocument.text' );
 * $manifest->addFileEntry( 'Configurations2/',
 * 							'application/vnd.sun.xml.ui.configuration' );
 * $manifest->addFileEntry( 'content.xml', 'text/xml' );
 * </code>
 * This code will create a manifest DOM document as follows:
 * <code>
 * <?xml version="1.0" encoding="UTF-8"?> 
 * <!DOCTYPE manifest:manifest PUBLIC "-//OpenOffice.org//DTD Manifest 1.0//EN" 
 *                      			  "Manifest.dtd">
 *  <manifest:manifest 
 * 		   xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0">
 *    <manifest:file-entry 
 * 		   manifest:media-type="application/vnd.oasis.opendocument.text" 
 * 	       manifest:full-path="/"/>
 *    <manifest:file-entry 
 *		   manifest:media-type="application/vnd.sun.xml.ui.configuration" 
 *		   manifest:full-path="Configurations2/"/>
 *    <manifest:file-entry 
 *		   manifest:media-type="text/xml" 
 *		   manifest:full-path="content.xml"/>
 *  </manifest:manifest>
 * </code>
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	manifest
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 * @todo		We need to support encryption data. 
 * @todo		Also we need to support the optional size part. 
 */
class ManifestDocument extends AbstractDocument {
	/** 
	 * Doctype information for Manifest DOM documents
	 */
	const odmDOCTYPE = '<!DOCTYPE manifest:manifest PUBLIC "-//OpenOffice.org//DTD Manifest 1.0//EN" "Manifest.dtd">';
	/**
	 * Root Tag for Mainifest DOM documents
	 */
	const odmROOT = 'manifest:manifest';
	/**
	 * Link to the DOMElement which contains the mime type.
	 * 
	 * @var DOMElement
	 * @access private
	 */
	private $mimetype;
	/**
	 * Constructor
	 * 
	 * @param 		string mimetype Mime type of the archive
	 * @param 		string encoding Encoding of the manifest file. The default is 'UTF-8'. 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($mimetype = '', $encoding = 'UTF-8') {
		/*
		 * We can not use the normal way to produce a DOM document, because
		 * Manifest documents needs other DocType informtions. So we have to go this
		 * way and produce a DOM document 'by hand'.
		 */ 
		parent :: __construct();
		/*
		 * We must use this way to ensure that we have the right encoding and doc type.
		 */
		$this->loadXML('<?xml version="1.0" encoding="' . $encoding . '"?>' . self :: odmDOCTYPE . "\n" . '<manifest/>');
		/*
		 * But we must change the root element, so we first remove it ...
		 */
		$this->removeChild($this->getElementsByTagName('manifest')->item(0));
		/*
		 * ...and now we create a new one.
		 * This is a hack! Please do not use createManifestElement here!
		 */
		$this->root = $this->createElementNS(self :: MANIFEST, self :: odmROOT);
		/*
		 * and append it to the document as new root.
		 */
		$this->appendChild($this->root);
		/*
		 * Add root informations. This line is part of every Manifest document.
		 */
		$this->mimetype = $this->makeFileEntryElement('/', $mimetype);
		$this->root->appendChild($this->mimetype);
	}
	protected function _setRoot($documentRoot = 0) {
	}
	/**
	 * Make a path string unix-aware.
	 * 
	 * @return 		string A unix-aware full path.
	 * @param		string fullpath Normal full path.
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private function fp($fullpath) {
		return str_replace("\\", '/', $fullpath);
	}
	/**
	 * Creates a DOM element with the tag 'manifest:file-enty' and 
	 * adds 'manifest:full-path', and 'manifest:media-type' attributes to it.
	 *  
	 * @return 		DOMElement A DOM element which containt a single file entry.
	 * @param 		string fullpath The full path of the file that has been added.
	 * @param 		string mimetype The mime type of this file
	 * @param 		int size The size of this file. (default: not used)
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private function makeFileEntryElement($fullpath, $mimetype, $size = -1) {
		/*
		 * Create a new file-entry element ...
		 */
		$node = $this->createManifestElement('file-entry');
		/*
		 * ... add the fullpath of the file to full-path attribute, ...
		 */
		$node->setManifestAttribute('full-path', $this->fp($fullpath));
		/*
		 * ... add mime type of the file into media-type attribute.
		 */
		$node->setManifestAttribute('media-type', $mimetype);
		/*
		 *  If a size attribute is needed, add some ...
		 */
		if ($size >= 0) {
			/*
			 * ... to the size attribute of the file-entry element.
			 */
			$node->setManifestAttribute('size', $size);
		}
		// *** FIX ME *** - We need to handle encrypted Entrys too
		return $node;
	}
	/**
	 * Add a full path to the file entry list in this manifest document.
	 * 
	 * Example:
	 * <code>
	 * $manifest = new ManifestDocument();
	 * ...
	 * $manifest->addFileEntry('test/feature.xml', 'text/xml');
	 * ...
	 * </code>
	 * 
	 * will add 
	 * 
	 * <code>
	 *   <manifest-file-entry manifest:full-path="test/feature.xml" 
	 * 						  manifest:media-type="text/xml" />
	 * </code>
	 * 
	 * to the manifest DOM document.
	 * 
	 * @param 		string fullpath The full path of the file that has been added.
	 * @param 		string mimetype The mime type of this file
	 * @param 		int size The size of this file. 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function addFileEntry($fullpath, $mimetype, $size = -1) {
		$node = $this->makeFileEntryElement($fullpath, $mimetype, $size);
		// Append new file-entry node to root node		
		$this->root->appendChild($node);
	}
	/**
	 * Remove a full path from this manifest document.
	 * 
	 * @param 		string fullpath File to remove (given as a full path).
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function removeFileEntry($fullpath) {
		$ret = false;
		$element = $this->getFileEntry($fullpath);
		if ($element !== false) {
			$this->root->removeChild($element);
			$ret = true;
		}
		return $ret;
	}
	/**
	 * Get File Entry
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFileEntry($fullpath) {
		$ret = false;
		$search = $this->fp($fullpath);
		foreach ($this->getElementsByTagNameNS(self :: MANIFEST, 'file-entry') as $element) {
			if ($element->getAttributeNS(self :: MANIFEST, 'full-path') === $search) {
				$ret = $element;
				break;
			}
		}
		return $ret;
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFilelist() {
		$ret = array ();
		foreach ($this->getElementsByTagNameNS(self :: MANIFEST, 'file-entry') as $element) {
			$tmp = array (
				'name' => $element->getAttributeNS(self :: MANIFEST,
				'full-path'
			), 'media-type' => $element->getAttributeNS(self :: MANIFEST, 'media-type'));
			if ($element->hasAttributeNS(self :: MANIFEST, 'size') === true) {
				$tmp['manifest_size'] = $element->getAttributeNS(self :: MANIFEST, 'size');
			}
			$ret[] = $tmp;
		}
		return $ret;
	}
	/**
	 * Rename a file name entry in this manifest document.
	 * 
	 * @param 		string fullpath Old file name (as a full path).
	 * @param 		string newfullpath New file name (as a full path).
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function renameFileEntry($fullpath, $newfullpath) {
		$ret = false;
		if ($fullpath != $newfullpath) {
			$element = $this->getFileEntry($fullpath);
			if ($element !== false) {
				$element->removeAttributeNS(self :: MANIFEST, 'full-path');
				$element->setAttributeNS(self :: MANIFEST, 'manifest:full-path', $this->fp($newfullpath));
				$ret = true;
			}
		}
		return $ret;
	}
	/**
	 * Set mime type of the archive.
	 * 
	 * @param 		string mimetype New mime type of this archive.
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setMimeType($mimetype) {
		/*
		 * First we remove the old media-type attribute ...
		 */
		$this->mimetype->removeAttributeNS(self :: MANIFEST, 'media-type');
		/*
		 * ... and now we can add the new mimetype to the media-type attribute.
		 */
		$this->mimetype->setAttributeNS(self :: MANIFEST, 'media-type', $mimetype);
	}
	/**
	 * Returns mime type of the archive.
	 * 
	 * @return 		string Mime type of this archive
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getMimeType() {
		return $this->mimetype->getAttributeNS(self :: MANIFEST, 'media-type');
	}
	/**
	 * Reads MimeType out of the current DOM document.
	 * 
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private function readMimeType() {
		$this->mimetype = $this->getFileEntry('/');
	}
	/**
	 * Setup root of the DOM document.
	 * 
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private function setupRoot() {
		$this->root = $this->getElementsByTagNameNS(self :: MANIFEST, 'manifest')->item(0);
	}
	/**
	 * Loads an XML document from a string.
	 * This method may also be called statically to load and create a 
	 * ManifestDocument object. The static invocation may be used when no 
	 * ManifestDocument properties need to be set prior to loading. 
	 * 
	 * @param 		string source The string containing the XML.
	 * @return 		boolean
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007 
	 */
	function loadXML($source, $options = 0) {
		$ret = parent :: loadXML($source, $options);
		$this->readMimeType();
		$this->setupRoot();
		return $ret;
	}
	/**
	 * Loads an XML document from a file.
	 * 
	 * This method may also be called statically to load and create a 
	 * DOMDocument object. The static invocation may be used when no 
	 * ManifestDocument properties need to be set prior to loading.
	 *  
	 * @param 		string filename The path to the XML document.
	 * @param 		int options
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function load($filename, $options = 0) {
		$ret = parent :: load($filename, $options);
		$this->readMimeType();
		$this->setupRoot();
		return $ret;
	}
}
?>
