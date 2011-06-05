unit uQFSObj;

interface
uses Classes;
type
  TQFSFlag = (qfPrint, qfReturn, qfCheck, qfExcel, qfEdit);
  TQFSFlags = set of TQFSFlag;

  TCustomQFSObj=class(TCollectionItem)
  private
    FFlags: TQFSFlags;
    procedure SetFlags(const Value: TQFSFlags);
  public
    property Flags:TQFSFlags read FFlags write SetFlags;
  end;

  TQFSCollection=class(TOwnedCollection)
  end;

   function RegisterQFSObj(TCustomQFSObj:TCustomQFSObj):boolean;

implementation
var
  QFSCollection:TQFSCollection;

function RegisterQFSObj(TCustomQFSObj:TCustomQFSObj):boolean;
begin
  result:=false;
end;

{ TCustomQFSObj }

procedure TCustomQFSObj.SetFlags(const Value: TQFSFlags);
begin
  FFlags := Value;
end;

initialization
  QFSCollection:=TQFSCollection.Create(nil,TCustomQFSObj);
finalization
  QFSCollection.Free;
end.
