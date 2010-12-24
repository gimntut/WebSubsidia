unit ngTemplater;

interface
uses Classes, superobject, IniFiles;
type
  TTemplateParsePrc = procedure (ParamName:string;var Value:string) of object;
  TTemplater=class
  private
    Request:ISuperObject;
    FData: string;
    FModified: boolean;
    TemplateStrings:TStringList;
    TextStrings:TStringList;
    Variables:THashedStringList;
    Blocks:THashedStringList;
    procedure RepeatBlock(InList,OutList:TStrings; BlockName:string; CallBack:TTemplateParsePrc=nil);
    procedure SetData(const Value: string);
    procedure SetTemplate(const Value: string);
    function GetText: string;
    procedure GenerateText;
    function GetTemplate: string;
    function LookupParse(S:string):string;
  protected
//    procedure ChangeBlock(ParamName: string; var Value: string);
    function Parse(S:string; CallBack:TTemplateParsePrc=nil):string;
    procedure ParseList(InList,OutList:TStrings; CallBack:TTemplateParsePrc=nil);
    function GetValue(BaseName,FieldName:string):string; overload;
    function GetValue(BaseField:string):string; overload;
    procedure LoadTemplate(FileName:string);
    property Modified:boolean read FModified default False;
  public
    constructor Create;
    destructor Destroy; override;
    property Data:string read FData write SetData;
    property Template:string read GetTemplate write SetTemplate;
    property Text:string read GetText;
  end;

  TBaseField=record
    Fmt:string;
    BaseName:string;
    FieldName:string;
  end;

  function BaseField(s:string):TBaseField;
  function BF2Str(BaseName, FieldName:string; Fmt:string=''):string; overload;
  function BF2Str(BFR:TBaseField):string; overload;

implementation
uses
ViewLog,
SysUtils;

function TTemplater.GetValue(BaseName, FieldName: string): string;
var
  Fields:TSuperArray;
  I: Integer;
  Row: Integer;
begin
  Row:=StrToIntDef(Blocks.Values[BaseName],0);
  Fields:=Request[format('%s.fields',[BaseName])].AsArray;
  Result:='';
  for I := 0 to Fields.Length - 1 do begin
    if not SameText(FieldName,Fields[I].AsString) then Continue;
    Result:=Request[format('%s.values[%d][%d]',[BaseName,Row,I])].AsString;
    break;
  end;
end;

function TTemplater.GetTemplate: string;
begin
  Result := TemplateStrings.Text;
end;

function TTemplater.GetText: string;
begin
  if Modified then GenerateText;
  Result := TextStrings.Text;
end;

function TTemplater.GetValue(BaseField: string): string;
var
  sts: TStringList;
  fmt: string;
  s: string;
begin
  Log('GetValue: '+BaseField);
  Result:='';
  if BaseField='' then Exit;
  sts := TStringList.Create;
  sts.Delimiter:='/';
  sts.StrictDelimiter:=true;
  sts.DelimitedText:=BaseField;
  fmt:=sts[sts.Count-1];
  sts.Delete(sts.Count-1);
  if pos('%',fmt)=0 then fmt:='%s';

  case sts.Count of
    1: begin
      s:=sts[0];
      s:=Variables.Values[s];
      Result := Parse(s);
    end;
    2: begin
      Result := GetValue(sts[0],sts[1]);
    end;
    else Result:= '';
  end;
//  if Result<>'' then
  Result:=format(fmt,[Result]);
  Result:=Result+'';
  sts.Free;
end;

procedure TTemplater.LoadTemplate(FileName: string);
begin
  TemplateStrings.LoadFromFile(FileName);
end;

function TTemplater.Parse;
var
  I: Integer;
  State:Integer;
  Brakes:Integer;
  ParamName:string;
  Value: string;
  Start: Integer;
  StartParam:Integer;
  OnceAgain: Boolean;
begin
  if copy(s,1,2)='::' then begin
    Result:=LookupParse(s);
    Exit;
  end;
  Log('Parse: '+S);
  State:=0; // Простой текст
  Brakes:=0;
  Start:=1;
  repeat
    OnceAgain := false;
    StartParam := 1;
    ParamName:='';
    for I := Start to Length(S) do begin
      case state of
        0: begin // Простой текст
          if s[I]='!' then begin
           State := 1;
           StartParam := I;
          end;
        end;
        1: begin // Найден восклицательный знак
          if s[I]='(' then begin
            State := 2;
            Brakes := 1;
          end else State := 0;
        end;
        2: begin // Найдена скобка за восклицательным знаком
          case s[I] of
            '(': inc(Brakes);
            ')': dec(Brakes);
          end;
          if Brakes=0 then begin
             State := 0;
             Value := GetValue(ParamName);
             if Assigned(CallBack) then CallBack(ParamName,Value);
             S:=Copy(S,1,StartParam-1)+Value+Copy(S,I+1,MaxInt);
             Start:=StartParam+Length(Value);
             OnceAgain:=true;
             break;
          end;
          ParamName:=ParamName + S[I];
        end;
      end;
    end;
  until not OnceAgain;
  Result := S;
end;

procedure TTemplater.ParseList;
var
  I: Integer;
  sts: TStringList;
  State:Integer;
  BlockName:string;
  S: string;
begin
  for I := 0 to InList.count - 1 do begin
    S:=InList[I];
    if SameText(copy(S,1,9),':Замена: ') then begin
      Delete(S,1,9);
      Variables.Add(S);
    end;
  end;
  State := 0;
  sts := TStringList.Create;
  for I := 0 to InList.count - 1 do begin
    S:=InList[I];
    if SameText(copy(S,1,9),':Замена: ') then Continue;
    case State of
      0: begin // Обычная строка
        if SameText(Copy(S,1,8),':Старт: ') then begin
          BlockName:=Copy(S, 9, MaxInt);
          sts.Clear;
          State := 1;
        end else begin
          OutList.add(Parse(InList[I], CallBack));
        end;
      end;
      1: begin // Cтрока повторяющегося блока
        if SameText(TrimRight(S),':Стоп: '+BlockName)
        then begin
          RepeatBlock(sts,OutList,BlockName,CallBack);
          State := 0;
        end else sts.Add(S);
      end;
    end;
  end;
  sts.Free;
end;

//procedure TTemplater.ChangeBlock(ParamName:string;var Value:string);
//var
//  BFR: TBaseFieldRow;
//  CurrentRow: Integer;
//begin
//  BFR:=BaseFieldRow(ParamName);
//  CurrentRow:=StrToIntDef(Blocks.Values[BFR.BaseName],-1);
//  if CurrentRow<>-1 then begin
//    Value:='!('+BFR2Str(BFR.BaseName,BFR.FieldName,CurrentRow,BFR.Fmt)+')';
//  end;
//end;

procedure TTemplater.RepeatBlock;
var
  I: Integer;
  BaseArr : TSuperArray;
begin
  BaseArr := Request[BlockName+'.values'].AsArray;
  if BaseArr=nil then Exit;
  for I := 0 to BaseArr.Length - 1 do begin
    Blocks.Values[BlockName]:=IntToStr(I);
    ParseList(InList,OutList,CallBack);
  end;
  Blocks.Values[BlockName]:='';
end;

procedure TTemplater.SetData(const Value: string);
begin
  FData := Value;
  FModified := true;
end;

procedure TTemplater.SetTemplate(const Value: string);
begin
  TemplateStrings.Text := Value;
  FModified := true;
end;

constructor TTemplater.Create;
begin
  FModified := False;
  TemplateStrings := TStringList.Create;
  TextStrings := TStringList.Create;
  Variables := THashedStringList.Create;
  Variables.CaseSensitive := False;
  Blocks := THashedStringList.Create;
  Blocks.CaseSensitive := False;
end;

destructor TTemplater.Destroy;
begin
  TemplateStrings.Free;
  TextStrings.Free;
  inherited;
end;

function TTemplater.LookupParse(S:string):string;
var
  sts: TStringList;
  I: Integer;
  BaseName:string;
  Fmt:string;
  Arr:TSuperArray;
  J: Integer;
  us: Boolean;
  OldBlockValue:string;
  FieldName:string;
  Counter:Integer;
begin
  Delete(S,1,2);
  sts := TStringList.Create;
  sts.CaseSensitive := false;
  sts.CommaText := S;
  BaseName:=BaseField(sts[0]).BaseName;
  Fmt:=BaseField(sts[0]).Fmt;
  for I := 1 to sts.Count - 1 do sts[I]:=Parse(sts[I]);
  Arr:=Request[BaseName+'.values'].AsArray;
  OldBlockValue := Blocks.Values[BaseName];
  Counter:=0;
  for I := 0 to Arr.Length - 1 do begin
    us:=true;
    Blocks.Values[BaseName]:=IntToStr(I);
    for J := 1 to sts.Count - 1 do begin
      FieldName:=sts.Names[J];
      if FieldName='*' then Continue;
      us:=us and SameText(sts.ValueFromIndex[J],GetValue(BaseName,FieldName));
      if not us then break;
    end;
    if us then
      for J := 1 to sts.Count - 1 do begin
        FieldName:=sts.Names[J];
        if FieldName<>'*' then Continue;
        inc(Counter);
        us:=IntToStr(Counter)=sts.ValueFromIndex[J];
        break;
      end;
    if us then break;
  end;
  Result:=GetValue(sts[0]);
  Blocks.Values[BaseName] := OldBlockValue;
  sts.Free;
end;

procedure TTemplater.GenerateText;
begin
  Request := so(FData);
  TextStrings.Clear;
  ParseList(TemplateStrings, TextStrings);
  FModified := False;
end;

function BaseField(s:string):TBaseField;
var
  sts: TStringList;
  I: Integer;
begin
  sts := TStringList.Create;
  sts.Delimiter:='/';
  sts.DelimitedText:=s;
  for I := 0 to sts.Count - 2 do begin
    case I of
      0: Result.BaseName:=sts[I];
      1: Result.FieldName:=sts[I];
//      2: Result.Row:=StrToIntDef(sts[2],0);
    end;
  end;
  Result.Fmt:=sts[sts.Count - 1];
  if Result.Fmt='' then Result.Fmt:='%s';
  sts.Free;
end;

function BF2Str(BaseName, FieldName:string; Fmt:string=''):string; overload;
begin
  Result:=format('%s/%s/%s',[BaseName, FieldName, Fmt])
end;

function BF2Str(BFR:TBaseField):string; overload;
begin
  with BFR do
    Result:=BF2Str(BaseName, FieldName, Fmt);
end;

end.
