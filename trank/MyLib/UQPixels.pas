unit UQPixels;
// Fast access to TBitmap pixels
// © Boris Novgorodov, Novosibirsk, mbo@mail.ru
// Alexey Radionov, Ulyanovsk
// 2003

interface

uses
  Windows, Graphics;

type
  TLogPal = record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: array[0..255] of TPaletteEntry;
  end;

  TSetPixelsMethod = procedure(X, Y: Integer; const Value: TColor) of object;
    register;
  TGetPixelsMethod = function(X, Y: Integer): TColor of object;
    register;

  TQuickPixels = class
  private
    FBitmap: TBitmap;
    FWidth, FHeight: Integer;
    FBPP: Integer;
    FStart: Integer;
    FDelta: Integer;
    FPixelFormat: TPixelFormat;
    FLogPal: TLogPal;
    FHPal: HPalette;
    FLastIndex: Integer;
    FLastColor: TColor;
    FByPaletteIndex: Boolean;
    FTrackBitmapChange: Boolean;

    function GetPixels(X, Y: Integer): TColor;
    function GetPixels1(X, Y: Integer): TColor;
    function GetPixels1Index(X, Y: Integer): TColor;
    function GetPixels4(X, Y: Integer): TColor;
    function GetPixels4Index(X, Y: Integer): TColor;
    function GetPixels8(X, Y: Integer): TColor;
    function GetPixels8Index(X, Y: Integer): TColor;
    function GetPixels15(X, Y: Integer): TColor;
    function GetPixels16(X, Y: Integer): TColor;
    function GetPixels24(X, Y: Integer): TColor;
    function GetPixels32(X, Y: Integer): TColor;

    procedure SetPixels(X, Y: Integer; const Value: TColor);
    procedure SetPixels1(X, Y: Integer; const Value: TColor);
    procedure SetPixels1Index(X, Y: Integer; const Value: TColor);
    procedure SetPixels4(X, Y: Integer; const Value: TColor);
    procedure SetPixels4Index(X, Y: Integer; const Value: TColor);
    procedure SetPixels8(X, Y: Integer; const Value: TColor);
    procedure SetPixels8Index(X, Y: Integer; const Value: TColor);
    procedure SetPixels15(X, Y: Integer; const Value: TColor);
    procedure SetPixels16(X, Y: Integer; const Value: TColor);
    procedure SetPixels24(X, Y: Integer; const Value: TColor);
    procedure SetPixels32(X, Y: Integer; const Value: TColor);

    procedure SetBPP(const Value: Integer);
    procedure SetByPaletteIndex(const Value: Boolean);
    procedure SetTrackBitmapChange(const Value: Boolean);
    procedure BitmapChange(Sender: TObject);
  public

    SetPixel: TSetPixelsMethod;
    GetPixel: TGetPixelsMethod;

    //установка соединения объекта с растром (DIB!)
    procedure Attach(Bmp: TBitmap);

    //вспомог. функция для получения цвета из палитры
    function PalIndex(const Color: TColor): Integer;
    destructor Destroy; override;

    property Width: Integer read FWidth;
    property Height: Integer read FHeight;

    //BitsPerPixel
    property BPP: Integer read FBPP;

   //при установке в True для режимов с палитрой вместо цвета работа идет с
   //индексом цвета в палитре
    property ByPaletteIndex: Boolean read FByPaletteIndex write SetByPaletteIndex;

    //основное свойство для доступа к растру
    property Pixels[X, Y: Integer]: TColor read GetPixels write SetPixels; default;

    //позволяет отслеживать изменения критических для доступа параметров растра:
    //размеров и цветового формата
    property TrackBitmapChange: Boolean read FTrackBitmapChange write SetTrackBitmapChange;
  end;

implementation

{ TQuickPixels }

procedure TQuickPixels.Attach(Bmp: TBitmap);
var
  DS: TDibSection;
begin
  FBPP := 0;
  FBitmap := Bmp;
  FWidth := FBitmap.Width;
  FHeight := FBitmap.Height;
  if pfDevice = FBitmap.PixelFormat then
    FBitmap.PixelFormat := pf24bit;
  FPixelFormat := FBitmap.PixelFormat;
  case FPixelFormat of
    // для подобных режимов все просто
    pf1bit:
      SetBPP(1);
    pf4bit:
      SetBPP(4);
    pf8bit:
      SetBPP(8);
    pf15bit:
      SetBPP(15);
    pf16bit:
      SetBPP(16);
    pf24bit:
      SetBPP(24);
    pf32bit:
      SetBPP(32);
    pfCustom:
    // а здесь проведем небольшое исследование
      if GetObject(FBitmap.Handle, SizeOf(DS), @DS) > 0 then
        // получим информационный заголовок растра
        with DS, dsBmih do
          case biBitCount of
            16:
              case biCompression of
                BI_RGB:
                  SetBPP(15);
                BI_BITFIELDS:
        // анализируем стандартные маски доступа к цветовым составляющим
                begin
                  if dsBitFields[1] = $7E0 then
                    SetBPP(16);
                  if dsBitFields[1] = $3E0 then
                    SetBPP(15);
                end;
              end;
            32:
              case biCompression of
                BI_RGB:
                  SetBPP(32);
                BI_BITFIELDS:
                  if dsBitFields[1] = $FF0000 then
                    SetBPP(32);
              end;
          end;
  end;
  Assert(FBPP > 0, 'Bitmap format is not supported');
  if FHPal <> 0 then
    DeleteObject(FHPal);
  if FBPP <= 8 then
  begin
    //скопируем палитру во внутреннее поле, чтобы не обращаться к FBitmap:
    FLogPal.palVersion := $300;
    FLogPal.palNumEntries := 1 shl FBPP;
    GetPaletteEntries(FBitmap.Palette, 0, FLogPal.palNumEntries,
      FLogPal.palPalEntry[0]);
    // создадим для данной логической палитры и HPalette, что нам потребуется
    //при поиске ближайшего цвета
    FHPal := CreatePalette(PLogPalette(@FLogPal)^);
    FLastColor := $7FFFFFF;
  end;
  //базовый адрес блока данных
  if FBitmap.Width = 0 then
  begin
    FStart := -1;
    FDelta := 0;
  end
  else
  begin
    FStart := Integer(FBitmap.Scanline[0]);
   //разность между адресами соседних строк развертки растра (обычно отриц.)
    if FBitmap.Height = 1 then
      FDelta := 0
    else
      FDelta := Integer(FBitmap.Scanline[1]) - FStart;
  end;
  if FTrackBitmapChange then
    FBitmap.OnChange := BitmapChange;
end;

destructor TQuickPixels.Destroy;
begin
  DeleteObject(FHPal);
  inherited;
end;

procedure TQuickPixels.SetPixels1(X, Y: Integer; const Value: TColor);
asm
  PUSH EBX
  PUSH ESI
  MOV ESI,[EBP+8]   //цвет
  CMP ESI,[EAX].FLastColor
  //проверка, не использовался ли в прошлый раз этот же цвет
  JZ @@TheSame
  //нет - ищем ближайший в палитре
  MOV [EAX].FLastColor,ESI    //запомним цвет
  PUSH ECX
  PUSH EDX
  PUSH EAX
  PUSH ESI
  MOV EAX,[EAX].FHPal
  PUSH EAX
  CALL GetNearestPaletteIndex
  MOV EBX,EAX
  POP EAX
  POP EDX
  POP ECX
  MOV [EAX].FLastIndex,EBX
  JMP @@SetCol
  @@TheSame:
  //да - используем сохраненный индекс
  MOV EBX,[EAX].FLastIndex
  @@SetCol:
  MOV ESI,[EAX].FDelta
  IMUL ESI,ECX
  ADD ESI,[EAX].FStart
  MOV EAX,EDX
  SHR EAX, 3   //X div 8
  ADD ESI,EAX  //адрес нужного байта FStart + FDelta * Y + (X Div 8);
  MOV EAX,[ESI] //получили байт с данными о 8 точках
  MOV ECX,EDX
  AND ECX, 7   //X mod 8
  MOV EDX, $80
  SHR EDX,CL   //маска для нужного бита
  OR EBX,EBX
  JZ @@IsZero
  OR EAX,EDX   //установка бита в 1
  JMP @@SetByte
  @@IsZero:
  NOT EDX
  AND EAX,EDX  //сброс бита в 0
  @@SetByte:
  MOV [ESI],AL   //запись байта с измененной точкой
  POP ESI
  POP EBX
end;

procedure TQuickPixels.SetPixels1Index(X, Y: Integer; const Value: TColor);
asm
  PUSH EBX
  PUSH ESI
  MOV EBX,[EBP+8]
  MOV ESI,[EAX].FDelta
  IMUL ESI,ECX
  ADD ESI,[EAX].FStart
  MOV EAX,EDX
  SHR EAX, 3
  ADD ESI,EAX
  MOV EAX,[ESI]
  MOV ECX,EDX
  AND ECX, 7
  MOV EDX, $80
  SHR EDX,CL
  OR EBX,EBX
  JZ @@IsZero
  OR EAX,EDX
  JMP @@SetByte
  @@IsZero:
  NOT EDX
  AND EAX,EDX
  @@SetByte:
  MOV [ESI],AL
  POP ESI
  POP EBX
end;

procedure TQuickPixels.SetPixels4(X, Y: Integer; const Value: TColor);
asm
  PUSH ESI
  MOV ESI,ECX
  PUSH EBX
  IMUL ESI, [EAX].FDelta
  MOV ECX,Value
  MOV EBX,[EAX].FLastIndex  //сохраненный индекс
  ADD ESI,[EAX].FStart
  CMP ECX, [EAX].FLastColor
  JZ @@SetCol
  MOV [EAX].FLastColor,ECX
  MOV EBX,EAX    //сохраним Self
  PUSH EDX
  PUSH ECX
  PUSH [EAX].FHPal
  CALL GetNearestPaletteIndex
  XCHG EBX,EAX     //в EBX - найденный индекс цвета
  POP EDX
  MOV [EAX].FLastIndex,EBX
  @@SetCol:
  SHR EDX, 1      //X div 2
  MOV ECX, $F0
  LEA ESI,[ESI+EDX]   //FStart + FDelta * Y + (X Div 2);
  JC @@SetByte
  //флаг переноса, свидетельствующий о нечетности,
  // устанавливается при выполнении shr
  MOV ECX, $0f
  SHL EBX, 4 //для четных точек устанавливаем старший полубайт
  @@SetByte:
  MOV EAX,[ESI]  //в AL - исходный байт, соотв. двум точкам
  AND EAX,ECX    //обнулим устанавливаемый полубайт
  OR EAX,EBX     //установим новое значение этого полубайта
  POP EBX
  MOV [ESI],AL   //вернем измененный байт на свое место
  POP ESI
end;

procedure TQuickPixels.SetPixels4Index(X, Y: Integer; const Value: TColor);
asm
  PUSH EBX
  PUSH ESI
  MOV EBX,[EBP+8]
  MOV ESI,[EAX].FDelta
  IMUL ESI,ECX
  ADD ESI,[EAX].FStart
  MOV EAX,EDX
  SHR EAX, 1
  ADD ESI,EAX
  MOV EAX,[ESI]
  AND EDX, 1
  JZ @@IsEven
  AND EAX, $F0
  OR EAX,EBX
  JMP @@SetByte
  @@IsEven:
  AND EAX, $0F
  SHL EBX, 4
  OR EAX,EBX
  @@SetByte:
  MOV [ESI],AL
  POP ESI
  POP EBX
end;

procedure TQuickPixels.SetPixels8(X, Y: Integer; const Value: TColor);
asm
  PUSH EBX
  PUSH ESI
  IMUL ECX,[EAX].FDelta
  MOV ESI,[EBP+8]  //Value
  ADD ECX,[EAX].FStart    //FStart + FDelta * Y
  CMP ESI,[EAX].FLastColor
  JZ @@TheSame
  MOV [EAX].FLastColor,ESI  //запомним цвет
  PUSH ECX
  PUSH EDX
  PUSH EAX
  PUSH ESI
  MOV EAX,[EAX].FHPal
  PUSH EAX
  //сохраняем регистры, нужные для вызова функции параметра укладываем в стек
  //в порядке, необходимом для соглашения stdcall
  CALL GetNearestPaletteIndex
  MOV EBX,EAX  //результат функции - индекс цвета
  POP EAX
  POP EDX
  POP ECX
  MOV [EAX].FLastIndex,EBX  //запомним индекс последнего цвета
  JMP @@SetCol
  @@TheSame:
  MOV EBX,[EAX].FLastIndex
  //цвет с прошлого вызова остался таким же, индекс его уже хранится в поле FLastIndex
  @@SetCol:
  POP ESI
  MOV [ECX+EDX],BL
  //запишем байт индекса по вычисленному ранее адресу + X
  POP EBX
end;

procedure TQuickPixels.SetPixels8Index(X, Y: Integer; const Value: TColor);
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOV EAX,[EBP+8]
  MOV [ECX+EDX], AL   //PByte(FStart + FDelta * Y + X)^ := Value (т.е. индекс)
end;

procedure TQuickPixels.SetPixels15(X, Y: Integer; const Value: TColor);
//PWord(FStart + FDelta * Y + (X Shl 1))^ :=
//((Value And $F8) Shl 7) or ((Value And $F800) Shr 6) or
//((Value And $FF0000) Shr 19);
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOV EAX,[EBP+$08]  //Value
  PUSH ESI
  MOV ESI,EAX        //Self
  AND ESI, $F8       //маска
  SHL ESI, 7
  PUSH EDI
  MOV EDI,EAX
  AND EDI, $F800
  SHR EDI, 6
  OR ESI,EDI
  POP EDI
  AND EAX, $FF0000
  SHR EAX, 19
  OR EAX,ESI
  MOV [ECX+EDX*2],AX
  POP ESI
end;

procedure TQuickPixels.SetPixels16(X, Y: Integer; const Value: TColor);
//PWord(FStart + FDelta * Y + (X Shl 1))^ :=
//((Value And $F8) Shl 8) or ((Value And $FC00) Shr 5)
//or ((Value And $FF0000) Shr 19);
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOV EAX,[EBP+$08]  //Value
  PUSH ESI
  MOV ESI,[EBP+$08]
  AND ESI, $F8       //маска
  SHL ESI, 8
  PUSH EDI
  MOV EDI,[EBP+$08]
  AND EDI, $FC00
  SHR EDI, 5
  OR ESI,EDI
  POP EDI
  AND EAX, $FF0000
  SHR EAX, 19
  OR EAX,ESI
  MOV [ECX+EDX*2],AX
  POP ESI
end;

procedure TQuickPixels.SetPixels24(X, Y: Integer; const Value: TColor);
//PRGBTriple(FStart + FDelta * Y + 3 * X)^ := PRGBTriple(@i)^
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  LEA EDX,[EDX+EDX*2]
  MOV EAX,[EBP+8]  //Value
  BSWAP EAX
  SHR EAX, 8
  MOV [ECX+EDX],AX
  SHR EAX, 16
  MOV [ECX+EDX+2],AL
end;

procedure TQuickPixels.SetPixels32(X, Y: Integer; const Value: TColor);
//PInteger(FStart + FDelta * Y + (X Shl 2))^ := SwappedValue
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOV EAX, Value
  BSWAP EAX
  SHR EAX, 8
  MOV [ECX+4*EDX],EAX
end;

procedure TQuickPixels.SetPixels(X, Y: Integer; const Value: TColor);
begin
  if (x < 0) or (x >= FBitmap.Width) or (y < 0) or (y >= FBitmap.Height) then
    Exit;
  SetPixel(X, Y, Value);
end;

function TQuickPixels.GetPixels(X, Y: Integer): TColor;
begin
  Result := 0;
  if (x < 0) or (x >= FBitmap.Width) or (y < 0) or (y >= FBitmap.Height) then
    Exit;
  Result := GetPixel(X, Y);
end;

procedure TQuickPixels.SetBPP(const Value: Integer);
begin
  FBPP := Value;
  case FBPP of
    1:
      if FByPaletteIndex then
      begin
        SetPixel := SetPixels1Index;
        GetPixel := GetPixels1Index;
      end
      else
      begin
        SetPixel := SetPixels1;
        GetPixel := GetPixels1;
      end;
    4:
      if FByPaletteIndex then
      begin
        SetPixel := SetPixels4Index;
        GetPixel := GetPixels4Index;
      end
      else
      begin
        SetPixel := SetPixels4;
        GetPixel := GetPixels4;
      end;
    8:
      if FByPaletteIndex then
      begin
        SetPixel := SetPixels8Index;
        GetPixel := GetPixels8Index;
      end
      else
      begin
        SetPixel := SetPixels8;
        GetPixel := GetPixels8;
      end;
    15:
    begin
      SetPixel := SetPixels15;
      GetPixel := GetPixels15;
    end;
    16:
    begin
      SetPixel := SetPixels16;
      GetPixel := GetPixels16;
    end;
    24:
    begin
      SetPixel := SetPixels24;
      GetPixel := GetPixels24;
    end;
    32:
    begin
      SetPixel := SetPixels32;
      GetPixel := GetPixels32;
    end;
  end;
end;

procedure TQuickPixels.SetByPaletteIndex(const Value: Boolean);
begin
  if Value <> FByPaletteIndex then
  begin
    FByPaletteIndex := Value;
    SetBPP(FBPP); //переназначение метода доступа
  end;
end;

function TQuickPixels.PalIndex(const Color: TColor): Integer;
asm
  PUSH EDX
  MOV EAX,[EAX].FHPal
  PUSH EAX
  CALL GetNearestPaletteIndex
end;

function TQuickPixels.GetPixels1(X, Y: Integer): TColor;
asm
  PUSH EBX
  MOV EBX,EDX   //X
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  SHR EDX,3     //X div 8
  MOVZX EDX, BYTE PTR [ECX+EDX ]
  //в DL теперь байт, соответствующий 8 точкам
  MOV ECX,EBX
  AND ECX,7     //X mod 8
  MOV EBX,EDX
  MOV EDX,$80   //1000000b
  SHR EDX,CL    //сдвигаем единичку вправо на X mod 8
  AND EBX,EDX   //накладываем маску
  POP EBX
  JZ @@Zero     //если нужный бит нулевой, выставлен флаг ZF
  mov EAX, DWORD PTR [EAX+8].FLogPal  //бит единичный, берем из палитры 1-й цвет
  JMP @@Exit
  @@Zero:
  MOV EAX, DWORD PTR [EAX+4].FLogPal  //берем из палитры 0-й цвет
  @@Exit:
end;

function TQuickPixels.GetPixels15(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOVZX EAX,word ptr [ECX+2*EDX]  //PWord(FStart + FDelta * Y + (X * 2))^
  MOV ECX,EAX
  AND ECX,$1F       //5 бит Blue
  IMUL ECX,541052   //масштабирование
  MOV EDX,EAX
  AND ECX,$FF0000   //маска Blue
  AND EDX,$3E0      //5 бит Green
  IMUL EDX,135263
  AND EAX,$7C00
  SHR EDX,11
  IMUL EAX,135263    //Red
  AND EDX,$FF00     //маска Green
  SHR EAX,24
  OR EAX,ECX
  OR EAX,EDX
end;

function TQuickPixels.GetPixels16(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOVZX EAX,word ptr [ECX+2*EDX] //PWord(FStart + FDelta * Y + (X * 2))^
  MOV ECX,EAX
  AND ECX,$1F
  IMUL ECX,541052
  AND ECX,$FF0000
  MOV EDX,EAX
  AND EDX,$7E0
  IMUL EDX,135263
  SHR EDX,12
  AND EAX,$F800
  AND EDX,$FF00
  IMUL EAX,135263
  SHR EAX,24
  OR EAX,ECX
  OR EAX,EDX
end;

function TQuickPixels.GetPixels1Index(X, Y: Integer): TColor;
asm
  PUSH EDX
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  SHR EDX,3
  MOVZX EAX, BYTE PTR [ECX+EDX]
  POP ECX
  AND ECX,7
  SHR EAX,CL
  AND EAX,1
end;

function TQuickPixels.GetPixels24(X, Y: Integer): TColor;
//PRGBTriple(@i)^ := PRGBTriple(FStart + FDelta * Y + 3 * X)^;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  ADD ECX,EDX
  MOVZX EAX,WORD PTR [ECX+2*EDX]
  BSWAP EAX
  SHR EAX,8
  MOVZX ECX, BYTE PTR [ECX+2*EDX+2]
  OR EAX,ECX
end;

function TQuickPixels.GetPixels32(X, Y: Integer): TColor;
//SwappedValue := PInteger(FStart + FDelta * Y + 4 * X )^;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOV EAX,[ECX+4*EDX]
  BSWAP EAX
  SHR EAX, 8
end;

function TQuickPixels.GetPixels4(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart  //в ECX теперь номер цвета в палитре
  SHR EDX,1     //X div 2
  MOVZX ECX, BYTE PTR [ECX+EDX]
  JNC @@IsEven
  //флаг переноса CF установлен при выполнении Shr,
  //если младший бит был единичным, т.е. X нечетно
  AND ECX,$0F    //маска младшего полубайта
  JMP @@GetCol
  @@IsEven:
  SHR ECX,4      //старший полубайт, сдвинутый вправо
  @@GetCol:
  MOV EAX, DWORD PTR [EAX+ECX*4+4].FLogPal
  //Self + смещение поля FLogPal + смещение массива цветов + номер цвета*4
  //(4 = SizeOf(TPaletteEntry))

end;

function TQuickPixels.GetPixels4Index(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart  //в ECX теперь номер цвета в палитре
  SHR EDX,1
  MOVZX EAX, BYTE PTR [ECX+EDX]
  JNC @@IsEven
  AND EAX,$0F
  JMP @@Exit
  @@IsEven:
  SHR EAX,4
  @@Exit:
end;

function TQuickPixels.GetPixels8(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart  //в ECX теперь номер цвета в палитре
  MOVZX ECX, BYTE PTR [ECX+EDX]
  MOV EAX, DWORD PTR [EAX+ECX*4+4].FLogPal
end;

function TQuickPixels.GetPixels8Index(X, Y: Integer): TColor;
asm
  IMUL ECX,[EAX].FDelta
  ADD ECX,[EAX].FStart
  MOVZX EAX, BYTE PTR [ECX+EDX]
end;

procedure TQuickPixels.SetTrackBitmapChange(const Value: Boolean);
begin
  FTrackBitmapChange := Value;
  if Assigned(FBitmap) then
    if FTrackBitmapChange then
      FBitmap.OnChange := BitmapChange
    else
      FBitmap.OnChange := nil;
end;

procedure TQuickPixels.BitmapChange(Sender: TObject);
begin
  if (FBitmap.Width <> FWidth) or (FBitmap.Height <> FHeight) or
    (FBitmap.PixelFormat <> FPixelFormat) then
    Attach(FBitmap);
end;

end.
