<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 29. Dec. 2006 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * ��������� � ������� - ������ �����
 */

/**
 * OpenDocumentArchive class file.
 * ���� ����� OpenDocumentArchive.
 * 
 * This is a extension of the class ZipArchive to handle OpenDocumentArchives.
 * That is a file that, like jar archives in java, have meta informations.
 * Unlike in jar files, this meta informations are stored in a XML file named
 * 'manifest.xml' in the 'META-INF' directory of the ZIP archive.
 * 
 * If you have got any problems with the <i>ZipArchive</i> class, please read the
 * information on the class-level documentation first.
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
 * $Id: OpenDocumentArchive.php 209 2007-07-21 12:10:43Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: OpenDocumentArchive.php 209 2007-07-21 12:10:43Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

/*
 * Check for useable PHP version:
 */
if (version_compare(PHP_VERSION, "5.2.0") < 0) {
	// die("You need at least PHP 5.2.0 to use OpenDocumentArchive!");
	die("��� ����� PHP 5.2.0 (��� ����) ��� ������������� OpenDocumentArchive!");
}
/*
 * Check if ZipArchive is installed properly
 * �������� �� ������� ������������� ZipArchive
 */

if (!class_exists('ZipArchive')) {
    die("You need ZipArchive to be enabled. On Linux systems use '--enable-zip' option at compile time. On Windows systems enable 'php_zip.dll' inside of 'php.ini'.")
}

/**
 * Include ManifestDocument class for the additional manifest  
 * ����������� ������ ManifestDocument ��� ��������������� ���������
 */
require_once 'OpenDocumentPHP/manifest/ManifestDocument.php';

/**
 * OpenDocumentArchive class.
 * ����� OpenDocumentArchive
 * 
 * This is a extension of the class ZipArchive to handle OpenDocumentArchives.
 * That is a file that, like jar archives in java, have meta informations.
 * Unlike in jar files, this meta informations are stored in a XML file named
 * 'manifest.xml' in the 'META-INF' directory of the ZIP archive.
 * 
 * OpenDocumentArchives ���������� ������ ZipArchive
 * ������� ������ JAR - ������� Java, ���� ���� ����� ����������,
 * �� � ������� �� JAR-�����, ���������� ��������� � XML-�����
 * � ��������� 'manifest.xml' � �������� 'META-INF' ZIP-������.
 * 
 * This class will handle everything needed.
 * ���� ����� ����� ��������� �� �����������.
 * 
 * <i>But be aware, that you have at least PHP 5.2.0 and enabled zip support.</i>
 * �� � ��� ������ ���� PHP 5.2.0 (��� ����) � ���������� zip.
 * 
 * <i> Linux systems (general) </i>
 *  
 * In order to use these functions you must compile PHP with zip support by using 
 * the <i>--with-zip[=DIR]</i> configure option, where <i>[DIR]</i> is the prefix 
 * of the ZZIPlib library install.
 * 
 * <i> Linux systems (debian) </i>
 * 
 * The easiest way is to use <i>apt-get install php5-zip</i> on command line. This
 * will do it in most cases. Please ensure that you run PHP 5.2.1 (or better) on your
 * linux box.
 * 
 * <i> Windows systems </i>
 * Windows users need to enable <i>php_zip.dll</i> inside of <i>php.ini</i> in order to 
 * use the <i>ZipArchive</i> class.
 * 
 * YOU NEED AT LEAST PHP 5.2.0 !!!
 *  
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @link        http://php.net/zip
 * @since 		0.5.0 - 08. Feb. 2007
 */
class OpenDocumentArchive extends ZipArchive {
	/**
	 * Full path to manifest xml in the OpenDocument archive. 
	 * ������ ���� � xml-��������� � ������ �������������
	 */
	const PathToManifestXml = 'META-INF/manifest.xml';
	/**
	 * No Manifest was found in Archive that where opened. 
	 * � ������ ��� ������ �� ��������
	 */
	const NOMANIFEST = 1024;
	/**
	 * The OpenDocument Manifest document as object.
	 * �������� �������������, ��� ������
	 * 
	 * @var ManifestDocument
	 * @access private
	 */
	private $manifest;
	/**
	 * Constructor method.
	 * �����������
	 * 
	 * @param 		string $mimetype Mime type of the achrive
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($mimetype = '') {
		$this->manifest = new ManifestDocument($mimetype);
	}
	/**
	 * Adds a file to a ZIP archive from the given path.
	 * ���������� ����� � ����� �� ��������� ����.
	 * 
	 * @param 		string $localname The name of the entry to create.
	 * @param 		string $filename The path to the file to add.
	 * @param 		string $mimetype Mime type of the file.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function addFile($filename, $localname = '', $mimetype = 'text/text') {
		/*
		 * First add to ZipArchive ...
		 * ������� ��������� � ����� ...
		 */
		$ret = parent :: addFile($filename, $localname);
		if ($ret === true) {
			/*
			 * If successfully added to archive make a manifest entry
			 * ���� ������ ���������, �� ��������� � ���������
			 */
			if ($localname === '') {
				/*
				 *  If $localname not set, use $filename instead
				 *  ���� �� ������ $localname, �� ���������� $filename
				 */ 
				$localname = $filename;
			}
			/*
			 * add new file-entry to manifest document 
			 * ��������� ��� ����� � ��������
			 */
			$this->manifest->addFileEntry($localname, $mimetype);
		}
		return $ret;
	}
	/**
	 * Add a file to a ZIP archive using its contents.
	 * ���������� ����� � ����� ��������� ��� ����������.
	 * 
	 * @param 		string $localname The name of the entry to create.
	 * @param 		string $contents The contents to use to create the entry. It is used in a binary safe mode. 
	 * @param 		string $mimetype Mime type of the file.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function addFromString($localname, $contents, $mimetype = 'text/text') {
		/*
		 * First add to ZipArchive ...
		 * ������� ��������� � ����� ...
		 */
		$ret = parent :: addFromString($localname, $contents);
		if ($ret === true) {
			/*
			 * If successfully added to archive make a manifest entry
			 * ���� ������ ���������, �� ��������� � ���������
			 */
			$this->manifest->addFileEntry($localname, $mimetype);
		}
		return $ret;
	}
	/**
	 * Retrieve mime type of the OpenDocument archive. 
	 * �������� MIME ��� ������ ������������.
	 * 
	 * @return 		string Current mime type of the OpenDocument archive.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getMimeType() {
		return $this->manifest->getMimeType();
	}
	/**
	 * Set mime type of the OpenDocument archive.
	 * ������ MIME ��� ������ ������������.
	 * 
	 * There for we delete the file 'mimetype' in the current OpenDocument archive 
	 * and add a new file 'mimetype' with the new mime type given as parameter $mimetype. 
	 * 
	 * �������� ����� 'mimetype' � ������� ������ ������������� � �����������
	 * ����������� ������ ����� 'mimetype' � ����� MIME �����, ��������� � ��������� $mimetype. 
	 * 
	 * @param 		string $mimetype New mime type of the OpenDocument archive.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setMimeType($mimetype) {
		/*
		 * We need to change the file 'mimetype' in the current archive as well:
		 * So we first remove the file ...
		 * 
		 * �� ������ �������� ���� 'mimetype' � ������� ������, ���:
		 * ��-������ ������� ���� ...
		 */
		parent::deleteName('mimetype');
		// ... and add a new one.
		// ... � ��������� �����.
		parent::addFormString('mimetype', $mimetype);
		// Set mime type also in the manfifest document.
		// ����� ��������� MIME ��� � ��������� ���������.
		$this->manifest->setMimeType($mimetype);
	}
	/**
	 * Opens a new zip archive for reading, writing or modifying.
	 * 
	 * If we create a new archive, we add to files. First the manifest document
	 * stored in the ManifestDocument and second the file 'mimetype' which only
	 * include the 
	 * 
	 * @param 		string $filename The file name of the ZIP archive to open.
	 * @param 		int $flags The mode to use to open the archive.
	 * @return		mixed  
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function open($filename, $flags = 0, $mimetype = '') {
		$ret = parent :: open($filename, $flags);
		if ($ret === true) {
			if (($flags && self :: CREATE) > 0) {
				// If archive was freshly made, we need a new ManifestDocument.
				unset ($this->manifest);
				$this->manifest = new ManifestDocument($mimetype);
				// Add the file 'mimetype' with the current mimetype
				if ($mimetype != '') {
					parent::addFromString('mimetype', $mimetype);
				}
			} else {
				$mfxml = parent :: getFromName(self :: PathToManifestXml);
				if ($mfxml === false) {
					$ret = self :: NOMANIFEST + $mfxml;
				} else {
					$this->manifest->loadXML($mfxml);
				}
			}
		}
		return $ret;
	}
	/**
	 * Delete an entry in the archive using its name.
	 * 
	 * @param 		string $name Name of the entry to delete.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function deleteName($name) {
		$ret = parent :: deleteName($name);
		if ($ret === true) {
			// After the file is delete from the archive we also need to 
			// remove it from the manifest file.
			$ret = $this->manifest->removeFileEntry($name);
		}
		return $ret;
	}
	/**
	 * Delete an entry in the archive using its index.
	 * 
	 * @param 		int $index Index of the entry to delete.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function deleteIndex($index) {
		$ret = false;
		$stats = parent :: statIndex($index);
		if ($stats !== false) {
			$name = $stats['name'];
			$ret = $this->deleteName($name);
		}
		return $ret;
	}
	/**
	 * Renames an entry defined by its index.
	 * 
	 * @param 		int $index Index of the entry to rename.
	 * @param 		string $newname New name.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function renameIndex($index, $newname) {
		$ret = false;
		$stats = parent :: statIndex($index);
		if ($stats !== false) {
			$name = $stats['name'];
			$ret = $this->renameName($name, $newname);
		}
		return $ret;
	}
	/**
	 * Renames an entry defined by its name.
	 * 
	 * @param 		string $name Name of the entry to rename.
	 * @param 		string $newname New name.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function renameName($name, $newname) {
		$ret = parent :: renameName($name, $newname);
		if ($ret === true) {
			$ret = $this->manifest->renameFileEntry($name, $newname);
		}
		return $ret;
	}
	/**
	 * Get the details of an entry defined by its name.
	 * �������� ���������� � ������ �� � �����.
	 * 
	 * The function obtains information about the entry defined by its name.
	 * ������� �������� ���������� �� ���������� ������ �� � �����.
	 * 
	 * @param 		string $name Name of the entry.
	 * @param 		int $flags The flags argument specifies how the name lookup should be done. Also, ZIPARCHIVE::FL_UNCHANGED may be ORed to it to request information about the original file in the archive, ignoring any changes made.
	 * @return 		array|bool Returns an array containing the entry details or <b>FALSE</b> on failure.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function statName($name, $flags = 0) {
		$ret = false;
		$stat = parent :: statName($name, $flags);
		if ($stat !== false) {
			$ret = $stat;
			$tmp = $this->manifest->getFilelist();
			foreach ($tmp as $element) {
				if ($element['name'] === $name) {
					$ret = array_merge($stat, $element);
					break;
				}
			}
		}
		return $ret;
	}
	/**
	 * Retrieve file list.
	 * ��������� ������ ������.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFilelist() {
		return $this->manifest->getFilelist();
	}
	/**
	 * Retrieve file from archive as a DOM document.
	 * ��������� ���� �� ������ ��� DOM-������.
	 * 
	 * @return		DOMDocument The file as a DOM document.
	 * @param		string $filename 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getDOMFromName($filename) {
		$ret = new DOMDocument();
		$ret->loadXML(parent :: getFromName($filename));
		return $ret;
	}
	/**
	 * Retreive the manifest document as a ManifestDocument object.
	 * ��������� �������� ��������� ��� ������ ������ ManifestDocument.
	 * 
	 * @return		ManifestDocument The manifest document.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getManifest() {
		return $this->manifest;
	}
	/**
	 * Revert all changes done to an entry with the given name.
	 * Always returns <b>false</b>!
	 * 
	 * ������� ��� ���������, ������������� ��� ������� � ��������� ������
	 * ������ ���������� <b>false</b>!
	 * 
	 * @param 		string Name of the entry.
	 * @return 		boolean Returns <b>true</b> if success, <b>false</b> if not.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function unchangeName($index) {
		return false;
	}
	/**
	 * Revert all changes done to an entry at the given index.
	 * Always returns <b>false</b>!
	 * 
	 * ������� ��� ���������, ������������� ��� ������� � ��������� ��������.
	 * ������ ���������� <b>false</b>!
	 * 
	 * @param 		int $index Index of the entry.
	 * @return 		boolean Returns <b>true</b> if success, <b>false</b> if not.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function unchangeIndex($index) {
		return false;
	}
	/**
	 * Undo all changes done in the archive. Always returns <b>false</b>!
	 * �������� ��� ��������� �������� � ������. ������ ���������� <b>false</b>!
	 * 
	 * @return 		boolean Returns <b>true</b> if success, <b>false</b> if not.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function unchangeAll() {
		return false;
	}
	/**
	 * Close opened or created archive and save changes. This method is 
	 * automatically called at the end of the script.
	 * 
	 * ��������� �������� ��� ��������� ����� � ��������� ���������.
	 * ���� ����� ������������� ���������� ��� ���������� �������.
	 * 
	 * @param		boolean $write Should we write to archive? - Default is true. 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function close($write=true) {
		if ($write) {
			/*
			 * We want to write all changes back to the archive, so first we normalize 
			 * the manifest document ...
			 * 
			 * �� ����� �������� ��� ��������� ������� � �����, �� �������
			 * ������� � ������� ������� ��������� ...
			 */
			$this->manifest->normalize();
			/*
			 * ... than we delete old manifest.xml in the archive ..
			 * ... ������� �� ������ ������ manifest.xml �� ������
			 */
			parent :: deleteName(self :: PathToManifestXml);
			/*
			 *  ... and at last we write the ManifestDocument
			 *  ... � ��� ����� �� ������� ManifestDocument
			 */
			parent :: addFromString(self :: PathToManifestXml, $this->manifest->saveXML());
		} else {
			/*
			 * So we don't want to change a thing in the archive, 
			 * thats why we revert all done work first.
			 * 
			 * �� �� ����� ������ ������ � ������,
			 * ������� ������� � ��������������� ���������.
			 */
			parent::unchangeAll();
		}
		/*
		 * Now we can close the OpenDocumentArchive: 
		 * � ��� ������ ����� �����������
		 */
		return parent :: close();
	}
}
?>