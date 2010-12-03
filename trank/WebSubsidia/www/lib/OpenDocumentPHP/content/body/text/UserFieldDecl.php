<?php
/*
 * Created on 26.02.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: UserFieldDecl.php 136 2007-03-02 18:02:29Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ElementFragment.php';
/**
 * UserFieldDecl class.
 * 
 * 
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 136 $
 * @package    	OpenDocumentPHP
 * @subpackage  content_body_text
 * @since 		0.5.2 - 26.02.2007
 */
class UserFieldDecl extends ElementFragment {
	/**
	 * Set element root to "text:user-field-decl"
	 * 
	 * @access 		protected
	 * @since 		0.5.2 - 26.02.2007
	 */
	function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: TEXT, 'text:user-field-decl');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function setValueType($type) {		
		$this->setAttributeNS(self :: OFFICE, 'office:value-type', $type);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function getValueType() {	
		return $this->getAttributeNS(self :: OFFICE, 'value-type');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function setStringValue($value) {
		$this->setValueType('string');
		$this->setAttributeNS(self :: OFFICE, 'office:string-value', $value);		
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function getStringValue() {
		return $this->getAttributeNS(self :: OFFICE, 'string-value');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function setName($name) {
		$this->setAttributeNS(self :: TEXT, 'text:name', $name);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function getName() {
		return $this->getAttributeNS(self :: TEXT, 'name');
	}
}
?>