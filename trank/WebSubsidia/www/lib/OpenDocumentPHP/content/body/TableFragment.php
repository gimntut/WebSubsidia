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
 * $Id: TableFragment.php 136 2007-03-02 18:02:29Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/content/body/table/TableCell.php';
require_once 'OpenDocumentPHP/util/Fragment.php';
/**
 * TableFragment class.
 * Класс TableFragment.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 136 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08.02.2007
 */
class TableFragment extends Fragment {
	private $cells;
	private $minx = 9999999;
	private $maxx = 0;
	private $miny = 9999999;
	private $maxy = 0;
	/**
	 * Constructor method.
	 * Конструктор.
	 * 
	 * @since 		0.5.0 - 08.02.2007
	 */
	function __construct($domFragment) {
		parent :: __construct($domFragment);
		$this->root = $this->domFragment->createElementNS(self :: TABLE, 'table:table');
		$this->cells = array ();
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setTableName($name) {
		$this->root->setAttributeNS(self :: TABLE, 'table:name', $name);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getCell($col, $row) {
		$ret = null;
		if (isset ($this->cells[$row]) && isset ($this->cells[$row][$col])) {
			$ret = $this->cells[$row][$col];
		} else {
			$ret = new TableCell($this->domFragment, $col, $row);
			$this->cells[$row][$col] = $ret;
		}
		return $ret;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setCellContent($content, $col, $row) {
		$tmp = $this->getCell($col, $row);
		$tmp->setContent($content);
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	private function includeCells() {
		$cells = $this->cells;
		ksort($cells);
		$currentRow = 0;
		foreach ($this->cells as $row => $cols) {
			if ($currentRow < $row -1) {
				$tbRow = $this->domFragment->createElementNS(self :: TABLE, 'table-row');
				$tbRow->setAttributeNS(self :: TABLE, 'table:number-rows-repeated', ($row - $currentRow -1));
				$tbCell = $this->domFragment->createElementNS(self :: TABLE, 'table-cell');
				$tbCell->setAttributeNS(self :: TABLE, 'table:style-name', 'ce1');
				$tbRow->appendChild($tbCell);
				$this->root->appendChild($tbRow);
			}
			ksort($cols);
			$currentCol = 0;
			$tbRow = $this->domFragment->createElementNS(self :: TABLE, 'table-row');
			foreach ($cols as $col => $cell) {
				if ($currentCol < $col -1) {
					$tbCell = $this->domFragment->createElementNS(self :: TABLE, 'table-cell');
					$tbCell->setAttributeNS(self :: TABLE, 'table:number-columns-repeated', ($col - $currentCol -1));
					$tbRow->appendChild($tbCell);
				}
				$currentCol = $col;
				$tbRow->appendChild($cell->getDocumentFragment());
			}
			$this->root->appendChild($tbRow);
			$currentRow = $row;
		}
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDocumentFragment() {
		$this->includeCells();
		return $this->root;
	}
}
?>
