unit uSprConst;

interface
uses Messages, Publ;
const
  WM_ProgressStart=WM_USER+1;
  WM_ProgressPrc=WM_USER+2;
  WM_ProgressStop=WM_USER+3;

procedure CreateTextBase( DbfFileName, CsvFileName: string; FieldIndex:Integer;
          AsAnsi:boolean=True; CBProc:TIntProc=nil; TimeOut:Integer=100);

implementation

uses cgsCHPR, cdbf, SysUtils;

var
  LocalCB:TIntProc;
  DeltaPrc:Integer;

  procedure CBProcDiv3(Counter:Integer; Max:Integer; Token:Integer);
  begin
    if not Assigned(LocalCB) then Exit;
    // 33 = 100 div 3
    Counter:=DeltaPrc+(Counter*33 div Max);
    LocalCB(Counter,100);
  end;

procedure CreateTextBase( DbfFileName, CsvFileName: string; FieldIndex:Integer;
          AsAnsi:boolean=True; CBProc:TIntProc=nil; TimeOut:Integer=100);
begin
  LocalCB:=CBProc;
  DeltaPrc:=0;
  DbfToCsv(DbfFileName,CsvFileName,True,CBProcDiv3, TimeOut);

  DeltaPrc:=33;
  CreateIndexForCSV( CsvFileName, ChangeFileExt(CsvFileName, '.Index'),
                     FieldIndex, CBProcDiv3, TimeOut);

  DeltaPrc:=66;
  CreateIndexForTxt( CsvFileName, ChangeFileExt(CsvFileName, '.BIndex'),
                     CBProcDiv3, TimeOut);
end;

end.
