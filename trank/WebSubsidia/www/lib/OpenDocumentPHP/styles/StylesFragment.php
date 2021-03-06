<?php
/*
 * Created on 22.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * ��������� � ������� - ������ �����
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
 * $Id: StylesFragment.php 161 2007-03-19 09:35:16Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/styles/DefaultStyle.php';
require_once 'OpenDocumentPHP/styles/Style.php';
require_once 'OpenDocumentPHP/util/Fragment.php';
/**
 * SytlesFragment class.
 *
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 161 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08.02.2007
 */
class StylesFragment extends Fragment {
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08.02.2007
	 */
	function __construct($domFragment) {
		parent :: __construct($domFragment);
		$this->root = $this->createOfficeElement('styles');
		$this->tables = array ();
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getStyle() {
		$ret = $this->domFragment->createStyleStyleElement();
		$this->root->appendChild($ret->getElement());
		return $ret;
	}
	/**
	 * 
	 * @access 		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDefaultStyle() {
		$ret = $this->domFragment->createDefaultStyleElement();
		$this->root->appendChild($ret->getElement());
		return $ret;
	}
}
?>
