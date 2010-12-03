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
 * $Id: Heading.php 145 2007-03-04 12:43:08Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/content/body/text/Paragraph.php';
/**
 * Heading class extends Paragraph class.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 145 $
 * @package    	OpenDocumentPHP
 * @subpackage  content_body_text
 * @since 		0.5.0 - 02.08.2007
 */
class Heading extends Paragraph {
	/**
	 * Set element to 'text:h'.
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08.02.2007
	 */
	protected function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: TEXT, 'text:h');
	}
	/* ------------- */
	/* Heading Level */
	/* ------------- */
	/**
	 * Set heading level ('text:outline-level') attribute.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 * @param 		int $level A positive integer for the new heading level.
	 */
	function setHeadingLevel($level) {
		$ret = false;		
		$level = (int) $level;
		if (Validator::isPositiveInteger($level)) {
				$this->setAttributeNS(self :: TEXT, 'text:outline-level', $level);
				$ret = true;	
		}
		return $ret;
	}
	/**
	 * Retrieve heading level ('text:outline-level') attribute.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 * @return		int The heading/outline level as a positive integer.		
	 */
	function getHeadingLevel() {
		$ret = 1;
		$tmp = $this->getAttributeNS(self :: TEXT, 'outline-level');
		if ($tmp !== false) {
			$ret = (int) tmp;
		}
		return $ret;
	}
	/* ----------------- */
	/* Heading Numbering */
	/* ----------------- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setRestartNumbering() {
		$this->setAttributeNS(self :: TEXT, 'text:restart-numbering', 'true');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function unSetRestartNumbering() {
		$this->setAttributeNS(self :: TEXT, 'text:restart-numbering', 'false');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getRestartNumbering() {
		$ret = false;
		$tmp = $this->getAttributeNS(self :: TEXT, 'restart-numbering');
		if ($tmp !== false || $tmp != 'false') {
			$ret = true;
		}
		return $ret;
	}
	/* ----------- */
	/* Start Value */
	/* ----------- */
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setStartValue($startValue) {
		$ret = false;
		$startValue = (int) $startValue;
		if (is_integer($startValue)) {
			if ($startValue >= 0) {
				$this->setAttributeNS(self :: TEXT, 'text:start-value', $startValue);
				$ret = true;
			}
		}
		return $ret;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getStartValue() {
		$ret = false;
		$tmp = $this->getAttributeNS(self :: TEXT, 'start-value');
		if ($tmp !== false) {
			$ret = (int) tmp;
		}
		return $ret;
	}
	/* ------------------------ */
	/* Supress Heading Numering */
	/* ------------------------ */
	/**
	 * Supress Header Numbering.
	 * 
	 * It is sometimes desired to have a specific heading which should not be numbered.
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setIsListHeader() {
		$this->setAttributeNS(self :: TEXT, 'text:is-list-header', 'true');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function unSetIsListHeader() {
		$this->setAttributeNS(self :: TEXT, 'text:is-list-header', 'false');
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getIsListHeader() {
		$ret = false;
		$tmp = $this->getAttributeNS(self :: TEXT, 'is-list-header');
		if ($tmp !== false || $tmp != 'false') {
			$ret = true;
		}
		return $ret;
	}
	/* ------------------------ */
	/* Formatted Heading Number */
	/* ------------------------ */
}
?>
