program	Browse;

{$APPTYPE CONSOLE}

uses
  cdbfapi,
  SysUtils,
  PublStr,
  CdbfObj in 'CdbfObj.pas';

var
	d	:PDBF;
	i, j	:integer;
  prc, s: string;
  cnt: Integer;
  IsOutputFile: boolean;
  ScreenOutput: Text;
begin
	if paramcount<1 then
	begin
		writeln('Browse. Version 1.00. Copyright (c) Sergey Chehuta, 2001'+#13#10+
			'Use:'+#13#10+
			#9+'Browse <filename.dbf> [switches]'
			);
		exit;
	end;

	d := OpenBase(PChar( paramstr(1) ));
	if d = nil then
	begin
		writeln('Cannot open file: "', paramstr(1), '"');
		exit;
	end
	else
	begin
    s:=ParamStr(2);
    IsOutputFile:=s<>'';
    if IsOutputFile then begin
      AssignFile(Output,s);
      Rewrite(Output);
      AssignFile(ScreenOutput,'con');
      Rewrite(ScreenOutput);
    end;

		for j := 0 to fieldcount(d)-1 do
		begin
      if j>0 then write(';');
			write(GetFieldName(d,j));
		end;
		writeln;
    cnt:=reccount(d);
    prc:='';
		for i := 0 to cnt-1 do
		begin
			ReadRecord(d, i);
			for j := 0 to fieldcount(d)-1 do
			begin
        if j>0 then write(';');
				write(AsAnsi(PublStr.Trim(GetStr(d, j))));
			end;
			writeln;
      //if i>10 then break;
      if not IsOutputFile then Continue;
      s:=IntToStr(i*100 div cnt)+'%';
      if s=prc then Continue;
      write(ScreenOutput,StringOfChar(#8,Length(prc)));
      write(ScreenOutput,s);
      prc:=s;
		end;
    if IsOutputFile then begin;
      write(ScreenOutput,StringOfChar(#8,Length(prc)));
      write(ScreenOutput,'Done');
    end;
		Closebase(d);
    if IsOutputFile then CloseFile(ScreenOutput);
	end;
end.
