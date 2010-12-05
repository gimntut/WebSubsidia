<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/*
 * Created on 04. Jan. 2007 by Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * Доработка и перевод - Гимаев Наиль
 */

/**
 * OpenDocumentText class file.
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
 * $Id: OpenDocumentText.php 209 2007-07-21 12:10:43Z nmarkgraf $
 * 
 * @category    File Formats
 * @package    	OpenDocumentPHP
 * @author 		Norman Markgraf (nmarkgraf(at)user.sourceforge.net)
 * @copyright 	Copyright in 2006, 2007 by The OpenDocumentPHP Team 
 * @license 	http://www.gnu.org/licenses/gpl.html GNU General Public License 2.0.
 * @version    	SVN: $Id: OpenDocumentText.php 209 2007-07-21 12:10:43Z nmarkgraf $
 * @link       	http://opendocumentphp.org
 * @since 		0.5.0 - 08. Feb. 2007
 */

/**
 * Include basic class  
 * Подключение базового класса
 */
require_once 'OpenDocumentPHP/OpenDocumentAbstract.php';

/**
 * OpenDocumentText class.
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
 * You can use the setDefaultMeta() method to set up some meta datas. Also you can use the
 * setDefaultFontFace() and setDefaultStyles() methods to bring in some fonts, so you can 
 * write a short text. You should take a look at this methods and write your own methods to
 * match your needs.  
 * 
 * Вы должны использовать метод setDefaultMeta(), чтобы задать метаданные. Также вы должны 
 * использовать методы setDefaultFontFace() и setDefaultStyles() для определения в документе, 
 * некоторых шрифтов. Посмотрите код этих методов, и напишите свои под ваши потребности.
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
class OpenDocumentText extends OpenDocumentAbstract {
	/**
	 * Namespace TEXT
	 * Пространство имён TEXT
	 */
	const odmTextNamespace = 'application/vnd.oasis.opendocument.text';
	/**
	 * Constructor method.
	 * Конструктор.
	 * 
	 * Read (and if not exists create) an OpenDocument text file.
	 * Читает (а если не существует, то создаёт) текстовый ОпенДокумент.
	 * 
	 * @param 		string $fullpath Full path and name of the document
	 * @since 		0.5.0 - 08. Feb. 2007
	 */
	function __construct($fullpath=null) {
		// Construct a text document
		// Создаётся текстовый документ
		parent :: __construct(self :: odmTextNamespace);
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
				parent :: open($fullpath, self :: CREATE, self :: odmTextNamespace);
				// Вызываем метод инициализации, для очистки.
				$this->init();				
				// Set everything to a OpenDocument TEXT file.
				// Задаём всё в файле текстового ОпенДокумента.
				$this->content->setText();
			}
		} else {
		    // JUST A CLEAN FILE WITH NO FILE NAME JET!!!! DANGER!!!!
		    // Чистый файл без имени файла!!!! ОПАСНО!!!!
			$this->init();
			$this->content->setText();
		}
	}

	/**
	 * Setup some default data for the meta.xml.
	 * Установка некоторых данных по умолчанию для meta.xml.
	 * 
	 * We will setup some data for the meta.xml document. You can use this method and
	 * overwrite even the static given data in this method by calling the MetaFragment
	 * or DublinCoreFragment methods again.
	 * 
	 * Мы установим некоторые данные для документ meta.xml. Вы можете использовать этот метод,
	 * а потом переписать статически заданные данные вызовом методов MetaFragment
	 * или DublinCoreFragment.
	 * 
	 * Currently we set the following meta datas:
	 * По умолчанию мы задаём следующие метаданные:
	 * 
	 * <i>DublinCore:</i>
	 * * The subject is set to 'A generated subject by OpenDocumentPHP.'.
	 * * The title is set to 'This is a generated title by OpenDocumentPHP.'.
	 * * The description is set to 'This is a short description by OpenDocumentPHP.'.
	 * * The language is set up 'en' for an english text.
	 * 
	 * <i>Дублинское ядро:</i>
	 * * Тема устанавливается в 'A generated subject by OpenDocumentPHP.'.
	 * * Заголовок устанавливается в 'This is a generated title by OpenDocumentPHP.'.
	 * * Описание устанавливается в 'This is a short description by OpenDocumentPHP.'.
	 * * Описание устанавливается как 'en'.
	 * 
	 * <i>(OpenDocument-)Meta:</i>
	 * <b>currently nothing is set here.</b>
	 * 
	 * <i>(ОпенДокумент-)Meta:</i>
	 * <b>Здесь ни чего не задаём.</b>
	 * 
	 * In your own code you can change the value very simple:
	 * В собственом коде можем поменять значения очень просто:
	 * <code>
	 * $doc = new OpenDocumentText('YourFavoriteText.odt');
	 * ...
	 * // Retreive the DublinCoreFragment to change dublin core meta data
	 * // Вызываем DublinCoreFragment для изменения данных Дублинского ядра
	 * $dc = $doc->getMeta()->getDublinCoreFragment();
	 * // Change title to new title
	 * // Изменяем заголовок документа на другой
	 * $dc->setTitle( 'This is a new title of the document (Это новый заголовок документа).' );
	 * ...
	 * // Retreive the MetaFragment to change OpenDocument meta data
	 * // Вызываем MetaFragment для изменения метаданных ОпенДокумента
	 * $meta = $doc->getMeta()->getMetaFragment();
	 * // Change the initial creator of the document
	 * // Изменить имя создателя документа
	 * $meta->setInitialCreator( 'Robert Duck (Роберт Дак)' );
	 * ...	
	 * </code>
	 * 
	 * @access		public
	 * @since		0.5.2 - 21. Mar. 2007
	 */
	function setDefaultMeta() {
		// =====================================================================
		$dc = $this->getMeta()->getDublinCoreFragment();
		// ---------------------------------------------------------------------
		$dc->setSubject('A generated subject by OpenDocumentPHP.');
		$dc->setTitle('This is a generated title by OpenDocumentPHP.');
		$dc->setDescription('This is a short description by OpenDocumentPHP.');
		$dc->setLanguage('en');
		// =====================================================================	
		$meta = $this->getMeta()->getMetaFragment();
		// ---------------------------------------------------------------------		
	}
	/**
	 * We set up some default font face declarations here.
	 * Здесь мы задаём шрифт по умолчанию.
	 * 
	 * We put the same font face declarations in the styles.xml and content.xml
	 * document. 
	 * 
	 * Мы помещаем описание некоторых шрифтов в документы styles.xml и content.xml
	 * 
	 * There are two font faces declared by this method:
	 * <i>Tahoma1</i> and <i>Arial Unicode MS</i>.
	 * 
	 * В этом методе описаны два шрифта:
	 * <i>Tahoma1</i> и <i>Arial Unicode MS</i>.
	 * 
	 * @access 		public
	 * @since		0.5.3 - 10. Jul. 2007
	 */
	function setDefaultFontFaces() {
		// Get the StylesDocument object
		// Получение объекта StylesDocument
		$styles = $this->getStyles();
		// Получение объекта FontFaceDeclarations
		$ffd = $styles->getFontFaceDeclarations();
		/*
		 * Create a new font face.
		 * We will call it 'Tahoma1' which depends on the 'Tahoma' font family.
		 * 
		 * Определение параметров нового шрифта
		 * Мы будем называть его "Tahoma1", которая зависит от шрифта "Tahoma".
		 */
		$fontface_Tahoma = $ffd->nextFontFace();
		$fontface_Tahoma->setStyleName('Tahoma1');
		$fontface_Tahoma->setSVGFontFamily('Tahoma');
		/*
		 * Create a new font face.
		 * We will call it 'Arial Unicode MS' which depends on the 'Arial Unicode MS' font family
		 * and we set the font pitch to 'variable'.		 
		 * 
		 * Определение параметров нового шрифта
		 * Мы будем называть его "Arial Unicode MS", который зависит от шрифта "Arial Unicode MS",
		 * с переменным шагом шрифта.
		 */
		$fontface_Arial = $ffd->nextFontFace();
		$fontface_Arial->setStyleName('Arial Unicode MS');
		$fontface_Arial->setSVGFontFamily(utf8_encode("'Arial Unicode MS'"));
		$fontface_Arial->setFontPitch('variable');
		/*
		 * We need FontFaceDecl in content.xml too.
		 * So we make a copy of the font face declaration and import this 
		 * to the font face declaration part of the content.xml
		 * 
		 * Мы должны записать FontFaceDecl также в content.xml.
		 * Для этого мы просто импортируем декларацию шрифтов
		 * в файл content.xml
		 * 
		 */
		$content = $this->getContent();
		$cffd = $content->getFontFaceDeclarations();
		$cffd->importNode($ffd->getDocumentFragment());		
	}
	
	/**
	 * Set up some default styles.
	 * Задаём стили по умолчанию.
	 * 
	 * We define the 'Standart' and 'Heading_20_1' fonts in this method.
	 * Пусть в этом методе это будут стили 'Standart' и 'Heading_20_1'.
	 * 
	 * @access 		public
	 * @since		0.5.3 - 10. Jul. 2007
	 */
	 function setDefaultStyles() {
		$default_style = $this->getStyles()->getStyles()->getDefaultStyle();
		$default_style->setFamily('paragraph');
		
		// Set paragraph properties:
		// Свойства абзаца:

		$paragraph_properties = $default_style->getParagraphProperties();
		$paragraph_properties->setHyphenationLadderCount('no-limit');
		$paragraph_properties->setTextAutospace('ideograph-alpha');
		$paragraph_properties->setPunctuationWrap = ('hanging');
		$paragraph_properties->setLineBreak('strict');
		$paragraph_properties->setTabStopDistance('1.251cm');
		$paragraph_properties->setWritingMode('page');
		
		// Set text properties:
		// Свойства текста:

		$text_properties = $default_style->getTextProperties();
		$text_properties->setLanguage('de');
		$text_properties->setCountry('DE');
		$text_properties->setFontName('Times New Roman');
		$text_properties->setFontSize('12pt');
		$text_properties->setFontNameAsian('Arial Unicode MS');
		$text_properties->setFontSizeAsian('12pt');
		$text_properties->setFontNameComplex('Tahoma');
		$text_properties->setFontSizeComplex('12pt');
		$text_properties->setHyphenate('false');
		$text_properties->setHyphenationRemainCharCount('2');
		$text_properties->setHyphenationPushCharCount('2');
		// ...
/*
			<style:text-properties 
			style:use-window-font-color="true"
				style:language-asian="none"
				style:country-asian="none" 
				style:language-complex="none"
				style:country-complex="none" 
*/
		$style_Standard = $this->getStyles()->getStyles()->getStyle();
		$style_Standard->setStyleName('Standard');
		$style_Standard->setFamily('paragraph');
		$style_Standard->setClass('text');
		
		$style_Heading_20_1 = $this->getStyles()->getStyles()->getStyle();
		$style_Heading_20_1->setStyleName('Heading_20_1');
		$style_Heading_20_1->setDisplayName('Heading_1');
		$style_Heading_20_1->setFamily('paragraph');
		$style_Heading_20_1->setClass('text');
		$style_Heading_20_1->setDefaultOutlineLevel(1);
		
		// Set paragraph properties:
		// Свойства абзаца:

		$style_Heading_20_1_paragraph_properties = $style_Heading_20_1->getParagraphProperties();
		$style_Heading_20_1_paragraph_properties->setMarginTop('0.423cm');
		$style_Heading_20_1_paragraph_properties->setMarginBottom('0.212cm');
		$style_Heading_20_1_paragraph_properties->setKeepWithNext('always');
		
		//	Set text properties:
		//	Свойства текста:

		$style_Heading_20_1_text_properties = $style_Heading_20_1->getTextProperties();
		$style_Heading_20_1_text_properties->setFontName('Arial');
		$style_Heading_20_1_text_properties->setFontSize('14pt');
		$style_Heading_20_1_text_properties->setFontNameAsian('MS Mincho');
		$style_Heading_20_1_text_properties->setFontSizeAsian('14pt');
		$style_Heading_20_1_text_properties->setFontNameComplex('Tahoma');
		$style_Heading_20_1_text_properties->setFontSizeComplex('14pt');	
	}
}
?>
