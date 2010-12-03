<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 05. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * AutomaticStylesFragment class file.
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
 * $Id: AutomaticStylesFragment.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * 
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  global
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     SVN: $Id: AutomaticStylesFragment.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/util/Fragment.php';

/**
 * AutomaticStylesFragment class.
 *  
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  content
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */
class AutomaticStylesFragment extends Fragment {

	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($domFragment,$root = null) {
		parent :: __construct($domFragment, $root);
		if (isset($root) && $root != null) {
		} else {
			$this->root = $this->domFragment->createElementNS(self :: OFFICE, 'office:automatic-styles');
		}
	}
}
?>
