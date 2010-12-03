<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 11. Jul. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * Interface Namespaces file.
 * 
 * This interface just gives some constants to the classes which implements it.
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
 * $Id: Namespaces.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: Namespaces.php 202 2007-07-11 14:16:45Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.3 - 11. Jul. 2007
 */

/**
 * Interface Namespaces
 * 
 * This interface just gives some constants to the classes which implements it.
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @subpackage	util
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.3 - 11. Jul. 2007
 */
interface Namespaces {
	/**
	 * namespace OpenDocument meta
	 */
	const META = 'urn:oasis:names:tc:opendocument:xmlns:meta:1.0';
	/**
	 * namespace OpenDocument office
	 */
	const OFFICE = 'urn:oasis:names:tc:opendocument:xmlns:office:1.0';
	/**
	 * namespace OpenDocument manifest
	 */
	const MANIFEST = 'urn:oasis:names:tc:opendocument:xmlns:manifest:1.0';
	/**
	 * namespace OpenDocument style
	 */
	const STYLE = 'urn:oasis:names:tc:opendocument:xmlns:style:1.0';
	/**
	 * namespace OpenDocument text
	 */
	const TEXT = 'urn:oasis:names:tc:opendocument:xmlns:text:1.0';
	/**
	 * namespace OpenDocument draw
	 */
	const DRAW = 'urn:oasis:names:tc:opendocument:xmlns:drawing:1.0';
	/**
	 * namespace OpenDocument table
	 */
	const TABLE = 'urn:oasis:names:tc:opendocument:xmlns:table:1.0';
	/**
	 * namespace OpenDocument number
	 */
	const NUMBER = 'urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0';
	/**
	 * namespace OpenDocument chart
	 */
	const CHART = 'urn:oasis:names:tc:opendocument:xmlns:chart:1.0';
	/**
	 * namespace OpenDocument form
	 */
	const FORM = 'urn:oasis:names:tc:opendocument:xmlns:form:1.0';
	/**
	 * namespace OpenDocument config
	 */
	const CONFIG = 'urn:oasis:names:tc:opendocument:xmlns:config:1.0';
	/**
	 * namespace OpenDocument presentation
	 */
	const PRESENTATION = 'urn:oasis:names:tc:opendocument:xmlns:presentation:1.0';
	/**
	 * namespace OpenDocument dr3d
	 */
	const DR3D = 'urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0';
	/**
	 * namespace OpenDocument animation
	 */
	const ANIM = 'urn:oasis:names:tc:opendocument:xmlns:animation:1.0';
	/**
	 * namespace OpenDocument script
	 */
	const SCRIPT = 'urn:oasis:names:tc:opendocument:xmlns:script:1.0';
	/**
	 * namespace OpenDocument svg
	 */
	const SVG = 'urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0';
	/**
	 * namespace OpenDocument fo (formation objects)
	 */
	const FO = 'urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0';
	/**
	 * namespace OpenDocument smil
	 */
	const SMIL = 'urn:oasis:names:tc:opendocument:xmlns:smil-compatible:1.0';
	/**
	 * namespace Dublin Core
	 */
	const DC = 'http://purl.org/dc/elements/1.1/';
	/**
	 * namespace XLink
	 */
	const XLINK = 'http://www.w3.org/1999/xlink';
	/**
	 * namespace XForms
	 */
	const XFORMS = 'http://www.w3.org/2002/xforms';
	/**
	 * namespace MathML
	 */
	const MATHML = 'http://www.w3.org/1998/Math/MathML';
}
?>