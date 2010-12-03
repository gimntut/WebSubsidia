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
 * $Id: TextProperties.php 162 2007-03-19 10:37:22Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/ODPElement.php';
/**
 * TextProperties class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 162 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.2 - 03.03.2007
 */
class TextProperties extends ODPElement {
	/**
	 * fo:font-style="italic"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontStyle($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('font-style', $value);
	}
	/**
	 * fo:font-weight="bold"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontWeight($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('font-weight', $value);
	}
	/**
	 * fo:font-size="12pt"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontSize($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('font-size', $value);
	}
	/**
	 * fo:language="de"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setLanguage($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('language', $value);
	}
	/**
	 * fo:country="DE"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setCountry($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('country', $value);
	}
	/**
	 * fo:hyphenate="false"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setHyphenate($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('hyphenate', $value);
	}
	/**
	 * fo:hyphenation-remain-char-count="2"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setHyphenationRemainCharCount($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('hyphenation-remain-char-count', $value);
	}
	/**
	 * fo:hyphenation-push-char-count="2"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setHyphenationPushCharCount($value) {
		//***FIX ME***: Check $value first!
		$this->putFOAttribute('hyphenation-push-char-count', $value);
	}
	/**
	 * 	style:font-name="Arial"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontName($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-name', $value);
	}
	/**
	 * style:font-name-asian="MS Mincho"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontNameAsian($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-name-asian', $value);
	}
	/**
	 * style:font-size-asian="14pt"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontSizeAsian($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-size-asian', $value);
	}
	/**
	 * style:font-style-asian="italic"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontWeightAsian($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-style-asian', $value);
	}
	/**
	 * style:font-name-complex="MS Mincho"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontNameComplex($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-name-complex', $value);
	}
	/**
	 * style:font-size-complex="14pt"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontSizeComplex($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-size-complex', $value);
	}
	/**
	 * style:font-style-complex="italic"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontStyleComplex($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-style-complex', $value);
	}
	/**
	 * style:font-weight-complex="bold"
	 * @since 	0.5.2 - 16.03.2007
	 */
	public function setFontWeightComplex($value) {
		//***FIX ME***: Check $value first!
		$this->putStyleAttribute('font-weight-complex', $value);
	}
	/*
	style:use-window-font-color="true"
	style:language-asian="none"
	style:country-asian="none" 
	style:language-complex="none"
	style:country-complex="none"
	*/
	
	/**
	 * fo:font-style="italic"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontStyle($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('font-style', $value);
	}
	/**
	 * fo:font-weight="bold"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontWeight($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('font-weight', $value);
	}
	/**
	 * fo:font-size="12pt"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontSize($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('font-size', $value);
	}
	/**
	 * fo:language="de"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getLanguage($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('language', $value);
	}
	/**
	 * fo:country="DE"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getCountry($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('country', $value);
	}
	/**
	 * fo:hyphenate="false"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getHyphenate($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('hyphenate', $value);
	}
	/**
	 * fo:hyphenation-remain-char-count="2"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getHyphenationRemainCharCount($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('hyphenation-remain-char-count', $value);
	}
	/**
	 * fo:hyphenation-push-char-count="2"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getHyphenationPushCharCount($value=null) {
		//***FIX ME***: Check $value first!
		return $this->putFOAttribute('hyphenation-push-char-count', $value);
	}
	/**
	 * 	style:font-name="Arial"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontName($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-name', $value);
	}
	/**
	 * style:font-name-asian="MS Mincho"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontNameAsian($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-name-asian', $value);
	}
	/**
	 * style:font-size-asian="14pt"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontSizeAsian($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-size-asian', $value);
	}
	/**
	 * style:font-style-asian="italic"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontWeightAsian($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-style-asian', $value);
	}
	/**
	 * style:font-name-complex="MS Mincho"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontNameComplex($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-name-complex', $value);
	}
	/**
	 * style:font-size-complex="14pt"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontSizeComplex($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-size-complex', $value);
	}
	/**
	 * style:font-style-complex="italic"
	 * @since 	0.5.2 - 19.03.2007
	 */
	public function getFontStyleComplex($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-style-complex', $value);
	}
	/**
	 * style:font-weight-complex="bold"
	 * @since 	0.5.2 - 19.032007
	 */
	public function getFontWeightComplex($value=null) {
		//***FIX ME***: Check $value first!
		return $this->getStyleAttribute('font-weight-complex', $value);
	}
}
?>
