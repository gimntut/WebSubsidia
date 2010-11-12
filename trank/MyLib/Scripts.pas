unit Scripts;

interface

type
  TScriptLanguage = (slVBScript, slJScript);
const
  ScriptProgIDs: array[TScriptLanguage] of PWideChar = (
    'VBScript',
    'JScript'
  );
var
  ScriptCLSIDs: array[TScriptLanguage] of TGUID;

implementation

uses
  Windows, ActiveX;

procedure InitCLSIDs;
const
  NULL_GUID: TGUID = '{00000000-0000-0000-0000-000000000000}';
var
  L: TScriptLanguage;
begin
  for L := Low(TScriptLanguage) to High(TScriptLanguage) do
    if CLSIDFromProgID(ScriptProgIDs[L], ScriptCLSIDs[L]) <> S_OK
      then ScriptCLSIDs[L] := NULL_GUID;
end;

initialization
  InitCLSIDs;

end.
