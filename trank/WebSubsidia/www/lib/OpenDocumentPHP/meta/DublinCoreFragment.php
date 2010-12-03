<?php
/*
 * Created on 10.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net) 
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
 * $Id: DublinCoreFragment.php 194 2007-06-19 08:23:22Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/util/Fragment.php';
/**
 * DublinCoreFragment class.
 *  
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 194 $
 * @package    	OpenDocumentPHP
 * @subpackage	meta
 * @since 		0.5.0 - 08.02.2007
 * @link		http://dublincore.org/ Dublin Core Metadata Initiative (R) 
 */
class DublinCoreFragment extends Fragment {
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $title = null;
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $description = null;
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $subject = null;
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $creator = null;
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $date = null;
	/**
	 * @access 		private
	 * @since 		0.5.0 - 08.02.2007
	 */
	private $language = null;
	/**
	 * Constructor method.
	 * 
	 * @param		DOMNode $domFragment
	 * @param		DOMNode	$root
	 * @since 		0.5.0 - 08.02.2007
	 */
	function __construct($domFragment, $root) {
		parent :: __construct($domFragment, $root);
		$this->root = $root;
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getCreator() {
		if (!isset ($this->creator)) {
			$this->creator = $this->getTag('creator', '');
		}
		return $this->creator->nodeValue;
	}
	/**
	 * 
	 * @param		string $creator
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setCreator($creator) {
		if ($this->getCreator() != $creator) {
			$newNode = $this->domFragment->createElementNS(self :: DC, 'dc:creator', $creator);
			$this->setTag($this->creator, $newNode);
			$this->creator = $newNode;
		}
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDescription() {
		if (!isset ($this->description)) {
			$this->description = $this->getTag('description', '');
		}
		return $this->description->nodeValue;
	}
	/**
	 * 
	 * @param		string $description
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setDescription($description) {
		if ($this->getDescription() != $description) {
			$newNode = $this->domFragment->createElementNS(self :: DC, 'dc:description', $description);
			$this->setTag($this->description, $newNode);
			$this->description = $newNode;
		}
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getLanguage() {
		if (!isset ($this->language)) {
			$this->language = $this->getTag('language', '');
		}
		return $this->language->nodeValue;
	}
	/**
	 * 
	 * @param		string $language
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setLanguage($language) {
		if ($this->getLanguage() != $language) {
			$newNode = $this->domFragment->createElementNS(self :: DC, 'dc:language', $language);
			$this->setTag($this->language, $newNode);
			$this->language = $newNode;
		}
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getSubject() {
		if (!isset ($this->subject)) {
			$this->subject = $this->getTag('subject', '');
		}
		return $this->subject->nodeValue;
	}
	/**
	 * 
	 * @param		string $subject
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setSubject($subject) {
		if ($this->getSubject() != $subject) {
			$newNode = $this->domFragment->createElementNS(self :: DC, 'dc:subject', $subject);
			$this->setTag($this->subject, $newNode);
			$this->subject = $newNode;
		}
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getTitle() {
		if (!isset ($this->title)) {
			$this->title = $this->getTag('title', '');
		}
		return $this->title->nodeValue;
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setTitle($title) {
		if ($this->getTitle() != $title) {
			$newNode = $this->domFragment->createElementNS(self :: DC, 'dc:title', $title);
			$this->setTag($this->title, $newNode);
			$this->title = $newNode;
		}
	}
	/**
	 *
	 * @param		string $tag
	 * @param		string $defaultValue
	 * @access		protected
	 * @since 		0.5.0 - 08.02.2007
	 */
	protected function getTag($tag, $defaultValue) {
		return parent :: getTag('//*/office:meta/dc:' . $tag, self :: DC, $tag, $defaultValue);
	}
}
?>
