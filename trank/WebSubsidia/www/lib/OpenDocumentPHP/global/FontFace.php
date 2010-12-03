<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 22. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * FontFace class file.
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
 * $Id: FontFace.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * 
 * @category    File Formats
 * @package     OpenDocumentPHP
 * @subpackage  global
 * @author      Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright   Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license     http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     SVN: $Id: FontFace.php 206 2007-07-20 07:22:24Z nmarkgraf $
 * @link        http://opendocumentphp.org
 * @since       0.5.0 - 08. Feb. 2007
 */

require_once 'OpenDocumentPHP/util/ElementFragment.php';

/**
 * FontFace class.
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
class FontFace extends ElementFragment {

    /**
	 * Set the root element to 'style:font-face-decl'.
	 * 
	 * @access protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function __setRoot() {
		$this->root = $this->domFragment->createElementNS(self :: STYLE, 'style:font-face');
	}
	/* ---------- */
	/* Style Name */
	/* ---------- */
	/**
	 * Set style name.
	 * 
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setStyleName($name) {
		$this->setAttributeNS(self :: STYLE, 'style:name', $name);
	}
	/**
	 * Retrive style name.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getStyleName() {
		return $this->getAttributeNS(self :: STYLE, 'style:name');
	}
	/* ---------- */
	/* font pitch */
	/* ---------- */
	/**
	 * Set font pitch.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setFontPitch($name) {
		$this->setAttributeNS(self :: STYLE, 'style:font-pitch', $name);
	}
	/**
	 * Retrieve font pitch
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFontPitch() {
		return $this->getAttributeNS(self :: STYLE, 'style:font-pitch');
	}
	/* ------------------- */
	/* Font Family Generic */
	/* ------------------- */
	/**
	 * Set font family generic.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setFontFamilyGeneric($name) {
		$this->setAttributeNS(self :: STYLE, 'style:font-family-generic', $name);
	}
	/**
	 * Retrieve font family gerneric
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFontFamilyGeneric() {
		return $this->getAttributeNS(self :: STYLE, 'style:font-family-generic');
	}
	/* --------------- */
	/* Font Adornments */
	/* --------------- */
	/**
	 * Set font adornments.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setFontAdornments($name) {
		$this->setAttributeNS(self :: STYLE, 'style:font-adornments', $name);
	}
	/**
	 * Retrieve font adornments.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFontAdornments() {
		return $this->getAttributeNS(self :: STYLE, 'style:font-adornments');
	}
	/* ------------ */
	/* Font Charset */
	/* ------------ */
	/**
	 * Set font charset.
	 * 
	 * @todo check if $name matches pattern: [A-Za-z][A-Za-z0-9._\-]*
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setFontCharset($name) {
		$this->setAttributeNS(self :: STYLE, 'style:font-charset', $name);
	}
	/**
	 * Retieve font charset.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getFontCharset() {
		return $this->getAttributeNS(self :: STYLE, 'style:font-charset');
	}
	/* === */
	/* SVG */
	/* === */
	//
	/* ----------- */
	/* font family */
	/* ----------- */
	/**
	 * Set SVG font family.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setSVGFontFamily($name) {
		$this->setAttributeNS(self :: SVG, 'svg:font-family', $name);
	}
	/**
	 * Retreive SVG font family.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getSVGFontFamily() {
		return $this->getAttributeNS(self :: SVG, 'svg:font-family');
	}
	/* ------------ */
	/* font variant */
	/* ------------ */
	/**
	 * Set SVG font variant.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setSVGFontVariant($name) {
		$this->setAttributeNS(self :: SVG, 'svg:font-variant', $name);
	}
	/**
	 * Retrieve SVG font variant.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getSVGFontVariant() {
		return $this->getAttributeNS(self :: SVG, 'svg:font-variant');
	}
	/* ----------- */
	/* font weight */
	/* ----------- */
	/**
	 * Set SVG font weight
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function setSVGFontWeight($name) {
		$this->setAttributeNS(self :: SVG, 'svg:font-weight', $name);
	}
	/**
	 * Retrieve SVG font weight.
	 * 
	 * @access		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getSVGFontWeight() {
		return $this->getAttributeNS(self :: SVG, 'svg:font-weight');
	}
	/*
	 * @todo: Matching functions this:
	 * <optional>
	        <attribute name="svg:font-stretch">
	            <choice>
	                <value>normal</value>
	                <value>ultra-condensed</value>
	                <value>extra-condensed</value>
	                <value>condensed</value>
	                <value>semi-condensed</value>
	                <value>semi-expanded</value>
	                <value>expanded</value>
	                <value>extra-expanded</value>
	                <value>ultra-expanded</value>
	            </choice>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:font-size">
	            <ref name="positiveLength"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:unicode-range"/>
	    </optional>
	    <optional>
	        <attribute name="svg:units-per-em">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:panose-1"/>
	    </optional>
	    <optional>
	        <attribute name="svg:stemv">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:stemh">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:slope">
	            <ref name="integer"/>
	        </attribute>
	        </optional>
	    <optional>
	        <attribute name="svg:cap-height">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:x-height">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:accent-height">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:ascent">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:descent">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:widths"/>
	    </optional>
	    <optional>
	        <attribute name="svg:bbox"/>
	    </optional>
	    <optional>
	        <attribute name="svg:ideographic">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:alphabetic">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:mathematical">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:hanging">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:v-ideographic">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:v-alphabetic">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:v-mathematical">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:v-hanging">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:underline-position">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:underline-thickness">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:strikethrough-position">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:strikethrough-thickness">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	    <optional>
	        <attribute name="svg:overline-position">
	            <ref name="integer"/>
	        </attribute>
	        </optional>
	    <optional>
	        <attribute name="svg:overline-thickness">
	            <ref name="integer"/>
	        </attribute>
	    </optional>
	</define>
	
	 */
}
?>
