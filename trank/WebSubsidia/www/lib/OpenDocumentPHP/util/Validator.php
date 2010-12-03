<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 10. Feb. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * Validator class file.
 * 
 * This class will have several static methods to check if a input string is of 
 * a certain format.
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
 * $Id: Validator.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: Validator.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.1 - 10. Feb. 2007
 */


/**
 * Validator class.
 * 
 * This class will have several static methods to check if a input string is of 
 * a certain format.
 * 
 * Most of the definition is reight out of the original RelaxNG schemata for 
 * OpenDocuments.
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.1 - 10. Feb. 2007
 */
class Validator {
	/**
	 * Checks if the input is a positive integer (input > 0).
	 * 
	 * @param 		mixed $input Input which is been testet.
	 * @return 		bool Is true, only if it is a positive integer.
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007 
	 */
	static public function isPositiveInteger($input) {
		return ((int) $input > 0);
	}
	/**
	 * Checks if the input is a integer.
	 * 
	 * @param 		mixed $input Input which is been testet.
	 * @return 		bool Is true, only if it is a positive integer.
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007 
	 */
	static public function isInteger($input) {
		$ret = false;
		if (isset ($input)) {
			$ret = is_int($input);
		}
		return $ret;
	}
	/**
	 * Checks if the input string is 'non-colonized name' (NCName). 
	 * 
	 * @param		mixed $input Input which is been tested.
	 * @return		bool Is true, only if $input is a non-colonized name.
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007
	 * @todo		This should be something like '([a-zA-Z_])(a-zA-Z0-9.-_)*'...?
	 */
	static public function checkNCName($input) {
		return ereg('([a-zA-z_])([a-zA-Z0-9\.-_]*)', $input); //[\i-[:]][\c-[:]]*
	}
	/**
	 * Checks if the input string is of "styleNameRef" type. Which is eigther 
	 * a NCName string or empty.
	 * 
	 * @param		mixed $input Input which is been tested.
	 * @return		bool Is true, only if $input is of "styleNameRef" type.
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007
	 */
	static public function checkStyleNameRef($input) {
		if (isset ($input)) {
			return checkNCName($input);
		} else {
			// Empty is okay!
			return true;
		}
	}
	/**
	 * Checks if the input string represents a color, like #00FF00 is green.
	 * 
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007
	 */
	static public function isColor($input) {
		return ereg('#[0-9a-fA-F]{6}', $input);
	}
	/**
	 * Checks if the input is a positiveLength.
	 * 
	 * @access		public
	 * @since		0.5.1 - 10. Feb. 2007
	 */
	static public function isPositiveLength($input) {
		return ereg('([0-9]*[1-9][0-9]*(\.[0-9]*)?|0+\.[0-9]*[1-9][0-9]*|\.[0-9]*[1-9][0-9]*)((cm)|(mm)|(in)|(pt)|(pc)|(px))', $input);
	}
	/**
	 * Checks if the input is a family value.
	 * 
	 * @access		public
	 * @since		0.5.2 - 19. Mar. 2007
	 */
	static public function checkFamilyValues($value) {
		$ret = false;
		switch ($value) {
			case 'ruby' :
			case 'control' :
			case 'presentation' :
			case 'drawing-page' :
			case 'default' :
			case 'chart' :
			case 'table-page' :
			case 'table-cell' :
			case 'table-row' :
			case 'table-column' :
			case 'section' :
			case 'text' :
			case 'table' :
			case 'paragraph' :
			case 'graphic' :
				$ret = true;
		}
		return $ret;
	}
}
?>

