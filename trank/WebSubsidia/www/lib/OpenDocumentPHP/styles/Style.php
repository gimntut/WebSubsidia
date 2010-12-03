<?php
/*
 * Created on 21.01.2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
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
 * $Id: Style.php 162 2007-03-19 10:37:22Z nmarkgraf $
 */
require_once 'OpenDocumentPHP/styles/DefaultStyle.php';
require_once 'OpenDocumentPHP/util/Validator.php';
/**
 * Styles class.
 * 
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	$Revision: 162 $
 * @package    	OpenDocumentPHP
 * @since 		0.5.0 - 08.02.2007
 */
class Style extends DefaultStyle {
	/**
	 * Set element to 'style:style'. 
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08.02.2007
	 * @deprecated  0.5.2 - 19.03.2007 No longer needed!
	 */
	protected function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: STYLE, 'style:style');
	}
	/* ---------- */
	/* Style Name */
	/* ---------- */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setStyleName($name) {
		$this->putStyleAttribute('name', $name);
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getStyleName() {
		return $this->getStyleAttribute('name');
	}
	/* ------------ */
	/* Display Name */
	/* ------------ */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setDisplayName($name) {
		$this->putStyleAttribute('display-name', $name);
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDisplayName() {
		return $this->getStyleAttribute('display-name');
	}
	/* ----------------- */
	/* Parent Style Name */
	/* ----------------- */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setParentStyleName($name) {
		$this->putStyleAttribute('parent-style-name', $name);
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getParentStyleName() {
		return $this->getStyleAttribute('parent-style-name');
	}
	/* --------------- */
	/* Next Style Name */
	/* --------------- */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setNextStyleName($name) {
		$this->putStyleAttribute('next-style-name', $name);
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getNextStyleName() {
		return $this->getStyleAttribute('next-style-name');
	}
	/* --------------- */
	/* List Style Name */
	/* --------------- */
	/**
	 * @todo We need a set/getListStyleName() function here. It should match:
	 *	<define name="style-style-attlist" combine="interleave">
	   *		<optional>
	   *    		<attribute name="style:list-style-name">
	   *        		<choice>
	   *            		<ref name="styleName"/>
	   *            		<empty/>
	   *        		</choice>
	   *    		</attribute>
	   *		</optional>
	   *	</define>
	   */
	/* ---------------- */
	/* Master Page Name */
	/* ---------------- */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setMasterPageName($name) {
		$this->putStyleAttribute('master-page-name', $name);
	}
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getMasterPageName() {
		return $this->getStyleAttribute('master-page-name');
	}
	/* -------------------- */
	/* Automatically Update */
	/* -------------------- */
	/**
	 * @todo We need a set/getAutoUpdate function here, that matches:
	 * <define name="style-style-attlist" combine="interleave">
	   *		<optional>
	   *			<attribute name="style:auto-update" a:defaultValue="false">
	 *				<ref name="boolean"/>
	   *			</attribute>
	   *		</optional>
	 * </define>
	 * 
	 */
	/* ------------- */
	/* DataStyleName */
	/* ------------- */
	/**
	 * Set the value of the 'style:data-style-name' attribute.
	 *   
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 * @param		string $value The new data style name. 
	 */
	function setDataStyleName($value) {
		if (Validator :: checkStyleNameRef($value)) {
			$this->putStyleAttribute('data-style-name', $value);
		}
	}
	/**
	 * Retrieve the value of the 'style:data-style-name' attribute.
	 * 
	 * @return		string Value of the 'style:data-style-name' attribute. 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getDataStyleName() {
		return $this->getStyleAttribute('data-style-name');
	}
	/* ----- */
	/* Class */
	/* ----- */
	/**
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function setClass($name) {
		$this->putStyleAttribute('class', $name);
	}
	/**
	 *
	 *  
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 */
	function getClass() {
		return $this->getStyleAttribute('class');
	}
	/* ------------------- */
	/* DefaultOutlineLevel */
	/* ------------------- */
	/**
	 * Set the 'style:default-outline-level' attribute.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 * @param		int $value The new default outline level.
	 */
	function setDefaultOutlineLevel($value) {
		if (Validator :: isPositiveInteger($value)) {
			$this->putStyleAttribute('default-outline-level', $value);
		}
	}
	/**
	 * Retrieve the value of the 'style:default-outline-level' attribute.
	 * 
	 * @todo 		Make the return type to be an integer not a string. 
	 * @access		public
	 * @since 		0.5.0 - 08.02.2007
	 * @return 		string The value of the 'style:default-outline-level' attribute.
	 */
	function getDefaultOutlineLevel() {
		$tmp = $this->getStyleAttribute('default-outline-level');
		return $tmp;
	}
}
?>
