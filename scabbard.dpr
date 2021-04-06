program scabbard;

{$APPTYPE CONSOLE}

uses
  System.Classes,
  System.Console,
  System.SysUtils,
  WinApi.Windows;

const
  ProgramTitle: String = 'scabbard - Knives unlocker by Yoti';

var
  ConsoleTitle: Array [0..MAX_PATH] of Char;
  ForegroundColor: TConsoleColor;
  inFileName: String;
  inFS: TFileStream;
  outValue: Byte;

begin
  GetConsoleTitle(PChar(@ConsoleTitle), MAX_PATH);
  SetConsoleTitle(PChar(ChangeFileExt(ExtractFileName(ParamStr(0)), '')));
  ForegroundColor:=Console.ForegroundColor;
  if (ProgramTitle <> '') then WriteLn(ProgramTitle);

  if (ParamCount < 1)
  then inFileName:=ExtractFilePath(ParamStr(0)) + 'file00.dat'
  else inFileName:=ParamStr(1);

  if (FileExists(inFileName) = False) then begin
    Console.ForegroundColor:=TConsoleColor(12); // Red
    WriteLn('Error: cannot open ' + ExtractFileName(inFileName) + '!');
  end else

  begin
    try
      inFS:=TFileStream.Create(inFileName, fmOpenReadWrite or fmShareDenyWrite);
      if (inFS.Size = 1460) then begin
        inFS.Seek($80, soFromBeginning); // Fixed offset $80
        outValue:=$01; // Patch $00 -> $01
        inFS.Write(outValue, SizeOf(outValue));
        Console.ForegroundColor:=TConsoleColor(10); // Green
        WriteLn('Knives Chau successfully unlocked!');
      end else begin
        Console.ForegroundColor:=TConsoleColor(12); // Red
        WriteLn('Error: wrong file size!');
      end;
      inFS.Free;
    except
      Console.ForegroundColor:=TConsoleColor(12); // Red
      WriteLn('Error: cannot write ' + ExtractFileName(inFileName) + '!');
    end;
  end;

  Console.ForegroundColor:=ForegroundColor;
  SetConsoleTitle(ConsoleTitle);
  {$IFDEF DEBUG}ReadLn;{$ENDIF}
end.
