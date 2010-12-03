<?php
/*
 * Created on 03.03.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: ParagraphProperties.php 161 2007-03-19 09:35:16Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ODPElement.php';
/**
 * ParagraphProperties class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 161 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.2 - 03.03.2007
 */
class ParagraphProperties extends ODPElement {
	/**
	 * fo:margin-top="0.423cm"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setMarginTop($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('margin-top', $value);
	}
	/**
	 * fo:margin-bottom="0.212cm"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setMarginBottom($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('margin-bottom', $value);
	}
	/**
	 * fo:keep-with-next="always"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setKeepWithNext($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('keep-with-next', $value);
	}
	/**
	 * fo:text-align
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setTextAlign($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('text-align', $value);
	}
	/**
	 * fo:hyphenation-ladder-count="no-limit"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setHyphenationLadderCount($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('hyphenation-ladder-count', $value);
	}
	/**
	 * style:justify-single-word
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setJustifySingleWord($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('justify-single-word', $value);
	}
	/**
	 *	style:text-autospace="ideograph-alpha"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setTextAutospace($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('text-autospace', $value);
	}
	/**
	 * style:punctuation-wrap="hanging"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setPunctuationWrap($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('punctuation-wrap', $value);
	}
	/**
	 * style:line-break="strict"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setLineBreak($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('line-break', $value);
	}
	/**
	 * style:tab-stop-distance="1.251cm"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setTabStopDistance($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('tab-stop-distance', $value);
	}
	/**
	 * style:writing-mode="page"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setWritingMode($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('writing-mode', $value);
	}
}
?>