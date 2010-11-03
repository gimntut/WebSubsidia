unit PublDrivers;

interface

function InitComPort(Port: string): THandle;
procedure CloseComPort(ComPort: THandle);

implementation

uses
  Windows;

function InitComPort(Port: string): THandle;
const
  RxBufferSize = 256;
  TxBufferSize = 256;
var
  DCB: TDCB;
 //Config:string;
  CommTimeouts: TCommTimeouts;
begin
 // Открытие файла порта на чтение запись
 // прим. необходимо вынести в отдельный модуль
  Result := CreateFile(Pchar(Port), GENERIC_READ or GENERIC_WRITE, 0, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
 // Проверка правильности открытия файла
  if Result = INVALID_HANDLE_VALUE then
  begin
 // При неудачном открытии файла завершить работу
    Result := 0;
    Exit;
  end;
  repeat
    if not (SetupComm(Result, RxBufferSize, TxBufferSize) and
      PurgeComm(Result, PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR) and
      GetCommState(Result, DCB)) then
      break;
  //изменяем DCB
    DCB.BaudRate := 9599;//реальная скорость будет 9600
    DCB.ByteSize := 8;
    DCB.Parity := NoParity;
    DCB.StopBits := OneStopBit;
  //       Config :='baud=9600 parity=n data=8 stop=1';
  //if not BuildCommDCB(@Config[1],DCB) then Result :=False;
    if not SetCommState(Result, DCB) then
      break;
  //получаем текущие параметры таймаутов
  // прим. А зачем?
    GetCommTimeouts(Result, CommTimeouts);
  // Установка новых параметров таймаутов
    with CommTimeouts do
    begin
      ReadIntervalTimeout := 0;
      ReadTotalTimeoutMultiplier := 15;
      ReadTotalTimeoutConstant := 1;
      WriteTotalTimeoutMultiplier := 0;
      WriteTotalTimeoutConstant := 1000;
    end;
  // В случае неудачи завершить работу
    if not SetCommTimeouts(Result, CommTimeouts) then
      break;
    Exit;
  until true;
  CloseHandle(Result);
  Result := 0;
end;

procedure CloseComPort(ComPort: THandle);
begin
  if ComPort <> 0 then
    CloseHandle(ComPort);
end;

end.
