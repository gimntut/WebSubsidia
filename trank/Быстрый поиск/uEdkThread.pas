unit uEdkThread;

interface

uses
  Windows, Classes;

type
  TEdkThread = class(TThread)
  private
    FWinHandle: Cardinal;
    FSourcePath: string;
    FTargetPath: string;
    procedure SetWinHandle(const Value: Cardinal);
    procedure SetSourcePath(const Value: string);
    procedure SetTargetPath(const Value: string);
  protected
    DeltaPrc:Integer;
    procedure Execute; override;
  public
    property WinHandle:Cardinal read FWinHandle write SetWinHandle;
    property SourcePath:string read FSourcePath write SetSourcePath;
    property TargetPath:string read FTargetPath write SetTargetPath;
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
  Thread:TEdkThread;


procedure CBProcedure(Counter, Max, Token: integer);
var
  Prc:Integer;
begin
  Prc:=Thread.DeltaPrc+Counter*50 div Max;
  PostMessage(Thread.WinHandle,WM_ProgressPrc,Prc,Max);
end;

procedure TEdkThread.Execute;
var
  Path:string;
begin
  Thread:=self;
  PostMessage(FWinHandle,WM_ProgressStart,0,0);
  try
    Path := FSourcePath + '\main\';
    DeltaPrc := 0;
    CreateTextBase(Path + 'db1.dbf', FTargetPath+'\base2.csv', 3, True, cbProcedure);
    DeltaPrc := 50;
    CreateTextBase(Path + 'adb1.dbf', FTargetPath+'\base1.csv', 0, True, cbProcedure);
  finally
    PostMessage(FWinHandle,WM_ProgressStop,0,0);
  end;
end;

procedure TEdkThread.SetSourcePath(const Value: string);
begin
  FSourcePath := Value;
end;

procedure TEdkThread.SetTargetPath(const Value: string);
begin
  FTargetPath := Value;
end;

procedure TEdkThread.SetWinHandle(const Value: Cardinal);
begin
  FWinHandle := Value;
end;

end.
