set %rar%="%programfiles%\WinRar\rar.exe"
del Работа со списками.exe
copy QuickFindString.exe "Работа со списками.exe"
%rar% a "Работа со списками.rar" "Работа со списками.exe"
copy "Работа со списками.exe" ".\Работа со списками\Работа со списками.exe"
copy "Работа со списками.exe" "H:\Списки\Программы\Работа со списками.exe"
pause