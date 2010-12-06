unit uSpravka;

interface
uses Classes, StdCtrls;

type

  TSpravka=class
  private
    FName: string;
    FFilter: string;
    FPath: string;
    procedure SetFilter(const Value: string);
    procedure SetPath(const Value: string);
  protected
    // Действие выполняемое при изменении путей к базе
    procedure DoChangePath(APath:string); virtual; abstract;
    function GetText: string; virtual; abstract;
  public
    constructor Create(AName:string);
    destructor Destroy; override;
    procedure OutFound; virtual; abstract;
    procedure Generate(Ind:Integer); virtual; abstract;
    procedure Show(Sender:TObject; Memo:TMemo); virtual; abstract;
    procedure Prepare(s:string); virtual; abstract;
    ////////////////////////////////////////////////
    property Name:string read FName;
    property Filter:string read FFilter write SetFilter;
    property Path:string read FPath write SetPath;
    // Текст справки
    property Text:string read GetText;
  end;

  TSpravki=class(TList)
  private
    function Get(Index: Integer): TSpravka;
    procedure Put(Index: Integer; const Value: TSpravka);
  public
    function Registry(Spravka:TSpravka):boolean;
    property Items[Index: Integer]: TSpravka read Get write Put; default;
  end;

function Spravki:TSpravki;

implementation
uses SysUtils;

var
  FSpravki:TSpravki;
{ TSpravka }

constructor TSpravka.Create(AName: string);
begin
  if not Spravki.Registry(self) then Abort;
  FName:=AName;
end;

destructor TSpravka.Destroy;
begin

  inherited;
end;

procedure TSpravka.SetFilter(const Value: string);
begin
  FFilter := Value;
end;

procedure TSpravka.SetPath(const Value: string);
begin
  DoChangePath(Value);
  FPath := Value;
end;

function Spravki:TSpravki;
begin
  if not Assigned(FSpravki) then FSpravki:=TSpravki.Create;
  Result:=FSpravki;
end;

{ TSpravki }

function TSpravki.Get(Index: Integer): TSpravka;
begin
  result:=inherited Get(Index);
end;

procedure TSpravki.Put(Index: Integer; const Value: TSpravka);
begin
  inherited Put(Index, Value);
end;

function TSpravki.Registry(Spravka:TSpravka):boolean;
var
  I: Integer;
begin
  Result:=false;
  for I := 0 to Count - 1 do
    if SameText(Spravka.Name,Items[I].Name) then Exit;
  Result:=Add(Spravka)<>-1;
end;

initialization
finalization
  FSpravki.Free;
end.
