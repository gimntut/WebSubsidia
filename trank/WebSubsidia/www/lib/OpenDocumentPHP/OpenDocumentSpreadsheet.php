<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 04. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * OpenDocumentSpreadsheet class file
 * Файл класса OpenDocumentSpreadsheet 
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
 * $Id: OpenDocumentSpreadsheet.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: OpenDocumentSpreadsheet.php 207 2007-07-20 09:17:51Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

/**
 * Include basic class  
 * Подключение базового класса
 */
require_once 'OpenDocumentPHP/OpenDocumentAbstract.php';

 /**
 * Класс OpenDocumentSpreadsheet.
 *
 * You could uses this class as follows:
 * Вы должны использовать этот класс следующим образом:
 * 
 * <code>
 * 		$text = new OpenDocumentText( 'YourFavoriteTextDocument.odt' );
 * 		// do some thing with it
 * 		// Делаем здесь что-нибудь
 * 		...
 * 		// And write it back
 * 		// Выполняем запись
 * 		$text->close();
 * </code>
 * 
 * If you want to revert all modifications and do not write anything back to the archive you can
 * use the first parameter of this function and set it to <b>false</b>.
 *
 * Если выхотите закрыть документ без сохранения выполненых изменений,
 * то установите значение первого параметра функции в <b>false</b>.
 *
 * <code>
 * $text = new OpenDocumentText($fullpath);
 * //... do something ...
 * // But we do not want to write it back to the archive
 * //... Делаем что-нибудь ...
 * // Но не хотим записывать обратно в архив
 * $text->close( false );
 * </code>
 *
 * Be aware that even if <b>you</b> do not modify the OpenDocument, the library will! 
 * So do not expect the that the file is absolute the same after you run the close method.
 * 
 * Помните, что даже если вы ничего в ОпенДокументе не меняли, то библиотека меняет!
 * Поэтому не ожидайте, что документ останется прежним после выполнения $text->close();
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version     Release: @package_version@
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */
class OpenDocumentSpreadsheet extends OpenDocumentAbstract {

	/**
	 * Namespace CALC
	 * Пространство имен CALC
	 */
	const odmCalcNamespace = 'application/vnd.oasis.opendocument.spreadsheet';
	
	/**
	 * Constructor method.
	 * Конструктор.
	 *
	 * Read (and if not exists create) an OpenDocument calc file (aka spreadsheet).
	 * Читает (а если не существует, то создаёт) электронную таблицу ОпенДокумент.
	 *
	 * 	
	 * @param 		string $fullpath Full path and name of the document
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($fullpath=null) {
		// Construct a text document
		// Создаётся документ Calc
		parent :: __construct(self :: odmCalcNamespace);
		// Is the variable $fullpath given?
		// Если передана переменная $fullpath, то ...
		if (isset($fullpath) && is_string($fullpath)) {			
			if (file_exists($fullpath)) {
				// File does exist, so we can load it via open.
				// ... если Файл существует, то загружаем его, ...
				parent :: open($fullpath);
			} else {
				// File does not exist, so we can create it.		
				// ... а если не существует, то создаём ...
				parent :: open($fullpath, self :: CREATE, self :: odmCalcNamespace);
				// Clean it, with a fresh init call.				
				// Вызываем метод инициализации, для очистки.
				$this->init();				
				// Set everything to a OpenDocument CALC file.
				// Задаём всё в файле CALC ОпенДокумента.
				$this->content->setSpreadsheet();
			}
		} else {
		    // JUST A CLEAN FILE WITH NO FILE NAME JET!!!! DANGER!!!!
		    // Чистый файл без имени файла!!!! Опасно!!!!
			$this->init();
			$this->content->setSpreadsheet();
		}
	}
	
	/**
	 * Create a new sheet with the name '$sheetname'.
	 * Создание нового листа с именем '$sheetname'.
	 * 
	 * @access 		public
	 * @param  		string $sheetname The name of the new sheet
	 * @return 		object  
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function addSheet($sheetname) {
		return $this->content->getTable($sheetname);
	}
}
?>
