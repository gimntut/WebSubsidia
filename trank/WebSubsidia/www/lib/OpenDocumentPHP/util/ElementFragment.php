<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 21. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 *
 * PHP Versions 5.
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
 * $Id: ElementFragment.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: ElementFragment.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @link		http://www.oasis-open.org/committees/download.php/20493/UCR.pdf OpenDocument Metadata Use Cases and Requirements
 * @since 		0.5.0 - 08. Feb. 2007
 * @deprecated  0.5.2 - 05. Mar. 2007 Use ODPElement instead of Fragment or ElementFragment! 
 */

/**
 * Incluve basic class
 */
require_once 'OpenDocumentPHP/util/Fragment.php';

/**
 * Abstract ElementFragment class.  
 *  
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage  util 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @abstract
 * @since 		0.5.0 - 08. Feb. 2007
 * @deprecated  0.5.2 - 05. Mar. 2007 Use ODPElement instead of Fragment or ElementFragment! 
 */
abstract class ElementFragment extends Fragment {
	/**
	 * Constructor method.
	 * 
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($domFragment, $root = null) {
		parent :: __construct($domFragment, $root);
		if (isset ($root) && $root != null) {
		} else {
			$this->__setRoot();
		}
	}
	/**
	 * Set the $root attribute correctly.
	 * 
	 * @abstract 
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	abstract protected function __setRoot();
	/**
	 * Set an attribute with namespace, tag and value. 
	 * If an attibute old exists, it will be removed first.
	 *  
	 * @return  	mixed <b>True</b> if there was no old attibute, else the old attribute node. 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setAttributeNS($namespace, $tag, $value) {
		$ret = true;
		if ($this->root->hasAttributeNS($namespace, $tag)) {
			$ret = $this->root->removeAttributeNS($namespace, $tag);
		}
		$this->root->setAttributeNS($namespace, $tag, $value);
		return $ret;
	}
	/**
	 * Retreive an attribute by namespace and tag. 
	 * 
	 * @return  	mixed The value of the retrieved attribute or <b>false</b> if there is no such attribute.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getAttributeNS($namespace, $tag) {
		$ret = false;
		if ($this->root->hasAttributeNS($namespace, $tag)) {
			$ret = $this->root->getAttributeNS($namespace, $tag);
			// echo "got AttributeNS '".$namespace.'\':'.$tag.'='.$ret."\n";
		}
		return $ret;
	}
	/**
	 * Retrieve the current Class as DOMElement.
	 * 
	 * @return 		DOMElement The current class as DOMElement.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getElement() {
		return $this->getDocumentFragment();
	}
}
?>
