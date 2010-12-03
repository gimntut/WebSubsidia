<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 03. Mar. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * GraphicProperties class file.
 * 
 * This class handles the '<style:graphic-properties>' tag.
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
 * $Id: GraphicProperties.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  styles_proterties
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     SVN: $Id: GraphicProperties.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link        http://opendocumentphp.org
 * @since       0.5.2 - 04. Mar. 2007
 */

/**
 * Inlcude basic class
 */
require_once 'OpenDocumentPHP/util/ODPElement.php';

/**
 * GraphicProperties class.
 * 
 * '<style:graphic-properties>'
 *  
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  util
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link        http://opendocumentphp.org
 * @since 		0.5.2 - 04. Mar. 2007
 */
class GraphicProperties extends ODPElement {

	/**
	 * style:flow-with-text="false"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setMarginTop($value) {
		if (Validate::checkBoolean($value)) {
			$this->putStyleAttribute('flow-with-text', ''.$value);
		}			
	}			
	
	/**
	 * draw:shadow-offset-x="0.3cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setShadowOffsetX($value) {
		//
		$this->putDrawAttribute('shadow-offset-x', $value);
	}
	
	/**
	 * draw:shadow-offset-y="0.3cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setShadowOffsetY($value) {
		//
		$this->putDrawAttribute('shadow-offset-y', $value);
	}
	
	/**
	 * draw:start-line-spacing-horizontal="0.283cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setStartLineSpacingHorizontal($value) {
		//
		$this->putDrawAttribute('start-line-spacing-horizontal', $value);
	}
	
	/**
	 * draw:start-line-spacing-vertical="0.283cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setStartLineSpacingVertical($value) {
		//
		$this->putDrawAttribute('start-line-spacing-vertical', $value);
	}
	
	/**
	 * draw:end-line-spacing-horizontal="0.283cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setEndLineSpacingHorizontal($value) {
		//
		$this->putDrawAttribute('end-line-spacing-horizontal', $value);
	}
	
	/**
	 * draw:end-line-spacing-vertical="0.283cm"
	 * 
	 * @since 	0.5.2 - 21. Mar. 2007
	 */
	public function setEndLineSpacingVertical($value) {
		//
		$this->putDrawAttribute('end-line-spacing-vertical', $value);
	}	
}
?>
