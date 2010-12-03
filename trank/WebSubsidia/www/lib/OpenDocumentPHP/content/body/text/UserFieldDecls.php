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
 * $Id: UserFieldDecls.php 136 2007-03-02 18:02:29Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ElementFragment.php';
/**
 * UserFieldDecls class.
 * 
 * In this class we store all UserFieldDecl objects.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 136 $
 * @package    	OpenDocumentPHP
 * @subpackage  content_body_text
 * @since 		0.5.2 - 26.02.2007
 */

class UserFieldDecls extends ElementFragment {
	/**
	 * Set element root to "text:user-field-decl"
	 * 
	 * @access 		protected
	 * @since 		0.5.2 - 26.02.2007
	 */
	function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: TEXT, 'text:user-field-decls');
	}
	
	/**
	 * Retrieve User Field Decl by name and type;
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function getUserFieldDecl($name) {
		$node = $this->getTag('/office:document-content/office:body/office:text/text:user-field-decls/text:user-field-decl[@text:name="'.$name.'"]', '','', -1);
		// echo get_class($node) . ' ' . 'name:' . $node->tagName ."\n";
		/*if ($node->attributes == null) {
			echo "NO ATTRIBUTES!";
		} else {
			echo $node->attributes->item(0)->name.":".$node->attributes->item(0)->value."\n";
			echo $node->attributes->item(1)->name.":".$node->attributes->item(1)->value."\n";
			echo $node->attributes->item(2)->name.":".$node->attributes->item(2)->value."\n";
		}
		*/
		$ret = NULL;
		if ($node == '') {
			$ret = false;
		} else {			
			$ret = new UserFieldDecl($this->domFragment, $node);									
		}
		return $ret;
	}
	/**
	 * 
	 */
	function setUserFieldDecl($name, $value) {
		$ret = false;		
		$oldNode = $this->getUserFieldDecl($name);		
		if ($oldNode !== false) {			
			$tmp = $oldNode->getValueType();
			switch ($tmp) {
				case 'string' : 
					$oldNode->setStringValue($value);
					$ret = true;
					break;
				default :
					// echo "not found: '".$oldNode->getValueType()."'\n";
					$ret = false;
			}			
		}
		return $ret;
	}
	
	/**
	 * Append new UserFieldDecl to this set.
	 * 
	 * @access 		public
	 * @since 		0.5.2 - 26.02.2007
	 */
	function appendUserFieldDecl($name, $type, $value) {
		$newNode = new UserFieldDecl($this->domFragment);
		$ret = false;
		switch ($type) {
			case 'string': 
				$newNode->setStringValue(value);
				break;
			default :
				$ret = false;
		}
		$newNode->setName($name);	 		
		if (isset($newNode) && $newNode != NULL) {
			$this->root->appendChild($newNode->getDocumentFragment);
			$ret = true;
		}
		return $ret;
	}
}
?>