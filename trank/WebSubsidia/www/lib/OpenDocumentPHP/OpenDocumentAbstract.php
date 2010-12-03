<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 04. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * OpenDocumentAbstract class file. 
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
 * $Id: OpenDocumentAbstract.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: OpenDocumentAbstract.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

/**
 * Include basic classes  
 */
require_once 'OpenDocumentPHP/util/AbstractDocument.php';
require_once 'OpenDocumentPHP/util/Fragment.php';
require_once 'OpenDocumentPHP/util/ElementFragment.php';
require_once 'OpenDocumentPHP/global/FontFaceDeclFragment.php';
require_once 'OpenDocumentPHP/global/AutomaticStylesFragment.php';
require_once 'OpenDocumentPHP/content/ContentDocument.php';
require_once 'OpenDocumentPHP/meta/MetaDocument.php';
require_once 'OpenDocumentPHP/styles/StylesDocument.php';
require_once 'OpenDocumentPHP/settings/SettingsDocument.php';
require_once 'OpenDocumentPHP/OpenDocumentArchive.php';

/**
 * OpenDocumentAbstract class.
 *
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 * @link	   	http://www.oasis-open.org/committees/download.php/12572/OpenDocument-v1.0-os.pdf Open Document Format for Office Applications Release 1.0
 * @link 		http://www.oasis-open.org/committees/download.php/19274/OpenDocument-v1.0ed2-cs1.pdf Open Document Format for Office Applications Release 1.0 2nd Edition
 * @link 		http://www.oasis-open.org/committees/download.php/20847/OpenDocument-v1.1-cs1.pdf Open Document Format for Office Applications Release 1.1
 */
abstract class OpenDocumentAbstract extends OpenDocumentArchive {
	/**
	 * The content document as object.
	 * Содержимое документа, как объект
	 * 
	 * @var 		ContentDocument
	 * @access		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected $content;
	/**
	 * The styles document as object.
	 * Стили документа, как объект
	 * 
	 * @var 		StylesDocument
	 * @access		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected $styles;
	/**
	 * The meta document as object.
	 * Метаданные документа, как объект
	 * 
	 * @var 		MetaDocument
	 * @access		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected $meta;
	/**
	 * The settings document as object.
	 * Настройки документа, как объект
	 * 
	 * @var 		SettingsDocument
	 * @access		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected $settings;
	/**
	 * Initialise the usual attributes of this class.
	 * Инициализация используемых атрибутов этого класса
	 * 
	 * Calling this method will initialise fresh and new objects for the content, 
	 * the meta, the styles and the settings document as part of this OpenDocument.
	 * 
	 * Вызов этого метода сбросит (или задаст) состояние объектов содежимого документа, 
	 * метаданных, стилей и настроек в качестве части этого ОпенДокумента
	 * 
	 * @access 		protected
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	protected function init() {
		$this->content = new ContentDocument();
		$this->meta = new MetaDocument();
		$this->styles = new StylesDocument();
		$this->settings = new SettingsDocument();
	}
	/**
	 * Retrieve the meta document as an object of the MetaDocument class.
	 * Получить объект метаданных как объект класса MetaDocument
	 * 
	 * @return		MetaDocument The meta document as object.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getMeta() {
		return $this->meta;
	}
	/**
	 * Retrieve the body part of the content document as an object of the BodyFragment class.
	 * Получить тело документа как объект класса BodyFragment
	 * 
	 * @return		BodyFragment The body part of the content document as object.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 * @deprecated  0.5.3 - 02. Jul. 2007
	 */
	function getBody() {
		return $this->getContent()->getBody();
	}
	/**
	 * Retrieve the styles document as an object of the StylesDocument class.
	 * Получить стили документа как объект класса StylesDocument
	 *
	 * @return		StylesDocument The styles document as object.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getStyles() {
		return $this->styles;
	}
	/**
	 * Retrieve the content document as an object of the ContentDocument class.
	 * Получить содержимое документа как объект класса ContentDocument
	 *
	 * @return		ContentDocument The meta document as object.
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function getContent() {
		return $this->content;
	}
	/**
	 * Close the current OpenDocument.
	 * Закрыть текущий ОпенДокумент
	 *
	 * When ever you work with an OpenDocument, you should close it a the end.
	 * Вы должны закрывать ОпенДокумент в конце каждой работы с ним.
	 *  
	 * <code>
	 * $text = new OpenDocumentText($fullpath);
	 * //... do something ...
	 * //... делаем что-нибудь ...
	 * $text->close();
	 * </code>
	 *
	 * If you want to revert all modifications and do not write anything back to the archive you can 
	 * use the first parameter of this function and set it to <b>false</b>.
	 * 
	 * Чтобы внесёные в документ изменения не сохранились, нужно 
	 * задать первый параметр функции равным <b>false</b>.
	 * 
	 * <code>
	 * $text = new OpenDocumentText($fullpath);
	 * //... do something ...
	 * // But we do not want to write it back to the archive
	 * //... делаем что-нибудь ...
	 * // Но мы не хотим записавать изменения в файл
	 * $text->close( false );
	 * </code>
	 * 
	 * @param		bool $write Should we write something back to the archive? - Default is <b>true</b>. 
	 * @access 		public
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function close($write=true) {
		if ($write) {
			// append content.xml
			// добавляем content.xml
			$this->addFromString('content.xml', $this->content->saveXML(), 'text/xml');
			// append meta.xml
			// добавляем meta.xml
			$this->addFromString('meta.xml', $this->meta->saveXML(), 'text/xml');
			// append settings.xml
			// добавляем settings.xml
			$this->addFromString('settings.xml', $this->settings->saveXML(), 'text/xml');
			// append styles.xml
			// добавляем styles.xml
			$this->addFromString('styles.xml', $this->styles->saveXML(), 'text/xml');
		}
		parent :: close($write);
	}
	/**
	 * Load meta document.
	 * Загрузка метаданных документа.
	 *
	 * @access 		protected
	 * @since 		0.5.2 - 02. Mar. 2007
	 */
	protected function loadMeta() {
		return $this->meta->loadXML($this->getFromName('meta.xml'));
	}
	/**
	 * Load settings document.
	 * Загрузка настроек документа.
	 *
	 * @access 		protected
	 * @since 		0.5.2 - 02. Mar. 2007
	 */
	protected function loadSettings() {
		return $this->settings->loadXML($this->getFromName('settings.xml'));
	}
	/**
	 * Load content document.
	 * Занрузка содержимого документа.
	 *
	 * @access 		protected
	 * @since 		0.5.2 - 02. Mar. 2007
	 */
	protected function loadContent() {
		return $this->content->loadXML($this->getFromName('content.xml'));
	}
	/**
	 * Load styles document.
	 * Загрузка стилей документа.
	 *
	 * @access 		protected
	 * @since 		0.5.2 - 02. Mar. 2007
	 */
	protected function loadStyles() {
		return $this->styles->loadXML($this->getFromName('styles.xml'));
	}
	/**
	 * Open an OpenDocument and read the meta, settings, content and styles data 
	 * out of the ususal xml files and stores them into their attributes.
	 *
	 * Открытие ОпенДокумента и чтение метаданных, настроек, содежимого и стилей
	 * из используемых xml-файлов с сохранением в свои свойства (атрибуты)
	 *
	 * @param		string $filename Filename
	 * @param		int $flags File opening flags
	 * @param		string $mimetype Mimetype
	 * @return		bool If everything went fine, we got <b>true</b> as result, else we get <b>false</b>.
	 * @access 		public
	 * @since 		0.5.2 - 22. Feb. 2007
	 */
	function open($filename, $flags = 0, $mimetype = '') {
		$this->init();
		$ret = parent :: open($filename, $flags, $mimetype);
		if (($flags && self :: CREATE) > 0) {
			// New!
			// Новый!
		} else {
			// Load old data ...
			// Чтение старых данных ...
			if ($ret === true) {
				$ret = $this->loadMeta();
				if ($ret === true) {
					$ret = $this->loadSettings();
					if ($ret === true) {
						$ret = $this->loadContent();
						if ($ret === true) {
							$ret = $this->loadStyles();
						}
					}
				}
			}
		}
		return $ret;
	}
}
?>
