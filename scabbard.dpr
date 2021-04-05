program scabbard;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

var
  inFileName: String;
  inFS: TFileStream;
  outValue: Byte;

begin
  WriteLn('scabbard - Knives unlocker by Yoti');

  if (ParamCount < 1)
  then inFileName:=ExtractFilePath(ParamStr(0)) + 'file00.dat'
  else inFileName:=ParamStr(1);

  if (FileExists(inFileName) = False) then begin
    WriteLn('Error: cannot open ' + ExtractFileName(inFileName) + '!');
  end else

  begin
    try
      inFS:=TFileStream.Create(inFileName, fmOpenReadWrite or fmShareDenyWrite);
      if (inFS.Size = 1460) then begin
        inFS.Seek($80, soFromBeginning);
        outValue:=$01;
        inFS.Write(outValue, SizeOf(outValue));
        WriteLn('Knives Chau successfully unlocked!');
      end else
        WriteLn('Error: wrong file size!');
      inFS.Free;
    except
      WriteLn('Error: cannot write ' + ExtractFileName(inFileName) + '!');
    end;
  end;

  {$IFDEF DEBUG}ReadLn;{$ENDIF}
end.
