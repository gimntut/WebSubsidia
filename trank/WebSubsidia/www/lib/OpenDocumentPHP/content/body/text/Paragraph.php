<?php
/*
 * Created on 19.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
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
 * $Id: Paragraph.php 145 2007-03-04 12:43:08Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ElementFragment.php';
/**
 * Paragraph class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 145 $
 * @package    	OpenDocumentPHP
 * @subpackage  content_body_text
 * @since 		0.5.0 - 08.02.2007
 */
class Paragraph extends ElementFragment {
	/**
	 * Set element to 'text:p'.
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08.02.2007
	 */
	protected function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: TEXT, 'text:p');
	}
	/* -- */
	/* ID */
	/* -- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setId($id) {
		$this->setAttributeNS(self :: TEXT, 'text:id', $id);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getId() {
		return $this->getAttributeNS(self :: TEXT, 'id');
	}
	/* ---------- */
	/* Style Name */
	/* ---------- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setStyleName($name) {
		$this->setAttributeNS(self :: TEXT, 'text:style-name', $name);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getStyleName() {
		return $this->getAttributeNS(self :: TEXT, 'style-name');
	}
	/* ---------- */
	/* Class Name */
	/* ---------- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setClassNames($names) {
		$this->setAttributeNS(self :: TEXT, 'text:class-names', $names);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getClassNames() {
		return $this->getAttributeNS(self :: TEXT, 'class-names');
	}
	/* --------------- */
	/* Cond Style Name */
	/* --------------- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setCondStyleName($name) {
		$this->setAttributeNS(self :: TEXT, 'text:cond-style-name', $name);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getCondStyleName() {
		return $this->getAttributeNS(self :: TEXT, 'cond-style-name');
	}
	/* ------ */
	/* append */
	/* ------ */
	/**
	 * Append a text node or a DOMElement as a child to the current paragraph node.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 * @param 		mixed $content Eigther a text (as a string) or a child node 
	 * 							   (as a DOMElement) which will be appended to the
	 *                             current paragraph node. 
	 */
	function append($content) {
		if (is_string($content)) {
			$this->append($this->domFragment->createTextNode($content));
		} else {
			$this->root->appendChild($content);
		}
	}
}
?>
