<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 04. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * ContentDocument class file. 
 * Файл класса ContentDocument. 
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
 * $Id: ContentDocument.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * 
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  content
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     SVN: $Id: ContentDocument.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/content/body/BodyFragment.php';
require_once 'OpenDocumentPHP/global/FontFaceDeclFragment.php';
require_once 'OpenDocumentPHP/global/AutomaticStylesFragment.php';
require_once 'OpenDocumentPHP/content/ScriptsFragment.php';
require_once 'OpenDocumentPHP/util/AbstractDocument.php';

/**
 * ContentDocument class.
 * Класс ContentDocument.
 *  
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  content
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */
class ContentDocument extends AbstractDocument {
	/**
	 * @var 		ScriptsFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $scripts;
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
	 * @var 		BodyFragment
	 * @access		private
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	private $body;
	/**
	 * Constructor method.
	 * Конструктор.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct() {
		parent :: __construct('office:document-content');
		// append ScriptFragment
		// добавить ScriptFragment
		$this->scripts = new ScriptsFragment($this);
		$this->root->appendChild($this->scripts->getDocumentFragment());
		// append FontFaceDeclFragment
		// добавить FontFaceDeclFragment
		$this->fontfacedecl = new FontFaceDeclFragment($this);
		$this->root->appendChild($this->fontfacedecl->getDocumentFragment());
		// append AutomaticStylesFragment
		// добавить AutomaticStylesFragment
		$this->automaticstyles = new AutomaticStylesFragment($this);
		$this->root->appendChild($this->automaticstyles->getDocumentFragment());
		// append BodyFramgent
		// добавить BodyFramgent
		$this->body = new BodyFragment($this);
		$this->root->appendChild($this->body->getDocumentFragment());
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setSpreadsheet() {
		$this->body->setSpreadsheet();
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setText() {
		$this->body->setText();
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getTable($name) {
		$table = $this->body->getNewTableFragment($name);
		return $table;
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
	function getBody() {
		return $this->body;
	}
	/**
	 * Loads a content document into this ContentDocument.
	 * Загрузить содержимое документа в ContentDocument.
	 * 
	 * @access 	public
	 * @since 	0.5.2 - 26. Feb. 2007
	 */
	function loadXML($source) {
		$ret = parent :: loadXML($source);
		if ($ret === TRUE) {
			$this->root = $this->documentElement;
			$this->initXpath();
			$result = $this->xpath->query('/office:document-content');
			$tmp = $result;
			if ($tmp->length == 1) {
				$this->content = $tmp->item(0);
				$result = $this->xpath->query('/office:document-content/office:scripts');
				if ($result->length == 1) {
					$node = $result->item(0);
					$this->scripts = new ScriptsFragment($this, $node);
				} else {
					$ret = false;
				}
				$result = $this->xpath->query('/office:document-content/office:font-face-decls');
				if ($result->length == 1) {
					$node = $result->item(0);
					$this->fontfacedecl = new FontFaceDeclFragment($this, $node);
				} else {
					$ret = false;
				}
				$result = $this->xpath->query('/office:document-content/office:automatic-styles');
				if ($result->length == 1) {
					$node = $result->item(0);
					$this->automaticstyles = new AutomaticStylesFragment($this, $node);
				} else {
					$ret = false;
				}
				$result = $this->xpath->query('/office:document-content/office:body');
				if ($result->length == 1) {
					$node = $result->item(0);
					$this->body = new BodyFragment($this, $node);
				} else {
					$ret = false;
				}
			} else {
				// This should never happend!
				// Этого ни когда не должно случиться!
				$ret = FALSE;
			}
		}
		return $ret;
	}
}
?>
