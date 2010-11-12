unit uViplataThread;

interface

uses
  Windows, Classes;

type
  TViplataThread = class(TThread)
  private
    FWinHandle: Cardinal;
    FSourcePath: string;
    FTargetPath: string;
    FPartLength: Integer;
    FFIOPath: string;
    procedure SetWinHandle(const Value: Cardinal);
    procedure SetSourcePath(const Value: string);
    procedure SetTargetPath(const Value: string);
    procedure SetPartLength(const Value: Integer);
    procedure SetFIOPath(const Value: string);
  protected
    DeltaPrc:Integer;
    procedure Execute; override;
    procedure Init;
  public
    property WinHandle:Cardinal read FWinHandle write SetWinHandle;
    property SourcePath:string read FSourcePath write SetSourcePath;
    property TargetPath:string read FTargetPath write SetTargetPath;
    property FIOPath:string read FFIOPath write SetFIOPath;
    property NextPartLength:Integer read FPartLength write SetPartLength;
  end;

implementation

uses uSprConst, cgsCHPR;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure EdkThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ EdkThread }
threadvar
  Thread:TViplataThread;

procedure CBProcedure(Counter, Max, Token: integer);
var
  Prc:Integer;
begin
  Prc:=Thread.DeltaPrc+Counter*Thread.FPartLength div Max;
  PostMessage(Thread.WinHandle,WM_ProgressPrc,Prc,Max);
end;

procedure TViplataThread.Execute;
var
  Chpr:TChprList;
begin
  Thread:=self;
  PostMessage(FWinHandle,WM_ProgressStart,0,0);
  Chpr:=TChprList.Create;
  try
    Chpr.Mode:=mdChpr;
    Chpr.LoadFromFile(FIOPath);
    Chpr.SaveToFile(FTargetPath+'\fio.csv');

    Init; // —брос счЄтчика
    // ”казание числа процентов, которые добавитьс€ при выполнении следующей строки
    NextPartLength := 10;
    CreateIndexForCSV(FTargetPath+'\fio.csv', FTargetPath+'\fio.Index', 0,CBProcedure);
    NextPartLength := 10;
    CreateIndexForTxt(FTargetPath+'\fio.csv', FTargetPath+'\fio.BIndex',CBProcedure);
    NextPartLength := 40;
    CreateTextBase(FSourcePath+'\bux\ARHIVSUM.DBF', FTargetPath+'\f5.csv', 0, True, CBProcedure);
    NextPartLength := 40;
    CreateTextBase(FSourcePath+'\SUBS\ARXSUB.DBF', FTargetPath+'\f7.csv', 0, True, CBProcedure);
  finally
    Chpr.Free;
    PostMessage(FWinHandle,WM_ProgressStop,0,0);
  end;
end;

procedure TViplataThread.Init;
begin
  NextPartLength:=0;  
end;

procedure TViplataThread.SetFIOPath(const Value: string);
begin
  FFIOPath := Value;
end;

procedure TViplataThread.SetPartLength(const Value: Integer);
begin
  if Value=0 then DeltaPrc:=0;
  DeltaPrc:=DeltaPrc+FPartLength;
  FPartLength := Value;
end;

procedure TViplataThread.SetSourcePath(const Value: string);
begin
  FSourcePath := Value;
end;

procedure TViplataThread.SetTargetPath(const Value: string);
begin
  FTargetPath := Value;
end;

procedure TViplataThread.SetWinHandle(const Value: Cardinal);
begin
  FWinHandle := Value;
end;

end.
