<?php
/*
 * Created on 04.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: TableCell.php 132 2007-02-25 12:06:22Z nmarkgraf $
 *
 */
/**
 * TableCell class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 132 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08.02.2007
 * @todo 		This class is highly experimental, outdated and should be updated soon.
 */
class TableCell {
	const TABLE = 'urn:oasis:names:tc:opendocument:xmlns:table:1.0';
	const TEXT = 'urn:oasis:names:tc:opendocument:xmlns:text:1.0';
	const OFFICE = 'urn:oasis:names:tc:opendocument:xmlns:office:1.0';
	private $domFragment;
	private $x;
	private $y;
	private $root;
	private $content;
	/**
	 * @access protected
	 * @var integer	$spannedRows Numbers of spanned rows
	 */
	protected $spannedRows;
	/**
	 * @access protected
	 * @var integer	$spannedCols Number of spanned columns
	 */
	protected $spannedCols;
	/**
	 * @access protected
	 * @var integer $decimal Number of decimals of a number. 
	 */
	protected $decimal;
	function __construct($domFragment, $x, $y) {
		$this->x = $x;
		$this->y = $y;
		$this->domFragment = $domFragment;
		$this->root = $this->domFragment->createElementNS(self :: TABLE, 'table:table-cell');
	}
	function setContent($content) {
		$this->content = $content;
	}
	function setDecimal($decimal) {
		$this->content = number_format($this->content, $decimal);
		$this->decimal = $decimal;
	}
	function getContent() {
		return $this->content;
	}
	/**
	 * @todo NOT IMPLEMENTED NOW
	 */
	function setFontBold() {
	}
	/**
	 * @todo NOT IMPLEMENTED NOW
	 */
	function setFontItalic() {
	}
	/**
	 * @todo NOT IMPLEMENTED NOW
	 */
	function setTextCenter() {
	}
	/**
	 *
	 * @access 	public
	 * @return 	integer						
	 */
	public function getSpannedRows() {
		return $this->spannedRows;
	}
	/**
	 * @access 	public
	 * @return 	integer								
	 */
	public function getSpannedCols() {
		return $this->spannedCols;
	}
	function getCellType() {
		$content = $this->content;
		$type = 'string';
		if (is_float($content) || is_numeric($content) || is_int($content)) {
			$type = 'float';
		} else {
		}
		return $type;
	}
	function getDocumentFragment() {
		$content = $this->content;
		$type = $this->getCellType();
		if ($this->getSpannedRows() > 1) {
			$this->root->setAttributeNS(self :: TABLE, 'table:number-rows-spanned', $this->getSpannedRows());
		}
		if ($this->getSpannedCols() > 1) {
			$this->root->setAttributeNS(self :: TABLE, 'table:number-columns-spanned', $this->getSpannedCols());
		}
		switch ($type) {
			case 'float' :
				$this->root->setAttributeNS(self :: OFFICE, 'office:value-type', $type);
				$this->root->setAttributeNS(self :: OFFICE, 'office:value', $content);
			case 'string' :
			default :
				if ($content != '') {
					$text = $this->domFragment->createElementNS(self :: TEXT, 'text:p', $content);
					$text->setAttributeNS(self :: OFFICE, 'office:value-type', $type);
					$this->root->appendChild($text);
				}
		}
		return $this->root;
	}
}
?>
