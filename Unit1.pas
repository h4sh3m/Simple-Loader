unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, tlhelp32, StdCtrls, Buttons, ExtCtrls;

type
  TForm1 = class(TForm)
    btnExecute: TBitBtn;
    opn: TOpenDialog;
    gpInputFile: TGroupBox;
    edtPath: TEdit;
    btnOpen: TBitBtn;
    gpDelay: TGroupBox;
    edtDelay: TEdit;
    Label1: TLabel;
    gpPatchBytes: TGroupBox;
    memPatch: TMemo;
    procedure btnExecuteClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  PI: PROCESS_INFORMATION;
  SI: STARTUPINFO;
  Context: _CONTEXT;
  Buffer: PChar;
  S: string;
  W: NativeUInt;
  BaseAddr : integer;
  b : byte;

implementation

{$R *.dfm}

function GetImageBase(PID : NativeUInt; FilePath : WideString) : NativeUInt;
var
  ModuleSnap: THandle;
  ModuleEntry32: TModuleEntry32;
  More: Boolean;
begin
  Result := 0;

  try
    ModuleSnap := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE or $10, PID);

    if Integer(ModuleSnap) = -1 then
    begin
      //messagebox(0,'Can''t Read Process Memory','Error',mb_iconerror);
      Exit;
    end;

    ModuleEntry32.dwSize := SizeOf(ModuleEntry32);
    More := Module32First(ModuleSnap, ModuleEntry32);
    while More do
    begin
      if Pos(FilePath, WideString(ModuleEntry32.szExePath)) > 0 then
      //if ModuleEntry32.th32ModuleID = TID then
      begin
        Result := NativeUInt(ModuleEntry32.modBaseAddr);
        Break;
      end;

      More := Module32Next(ModuleSnap, ModuleEntry32);
    end;
  finally
    CloseHandle(ModuleSnap);
  end;
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
var
  ImageBase : NativeUInt;
  str : TStringList;
  RVA, i : NativeUInt;
  PatchByte : Byte;
begin
  if edtPath.Text = '' then
  begin
    messagebox(handle,'Plaese Select Target File to apply Loader !','Error',16);
    exit
  end;

  GetMem(Buffer,255);
  FillChar(PI,SizeOf(TProcessInformation),#0);
  FillChar(SI,SizeOf(TStartupInfo),#0);
  SI.cb:=SizeOf(SI);

  if not CreateProcess(PChar(edtPath.Text),nil,nil,nil,False,CREATE_SUSPENDED ,nil,nil,SI,PI) then
  begin
    messagebox(0,'Failed to load process!','Error',MB_ICONERROR);
    Exit;
  end;


  Context.ContextFlags:=$00010000+15+$10;

  ResumeThread(PI.hThread);
  ImageBase := GetImageBase(PI.dwProcessId, edtPath.Text);

  sleep(StrToInt(edtDelay.text));
  suspendthread(PI.hThread);

  str := TStringList.Create;

  for i := 0 to memPatch.Lines.Count-1 do
  begin
    try
      str.Delimiter := ':';
      str.DelimitedText := memPatch.Lines.Strings[i].Replace(' ', '');
      RVA := StrToUInt('$' + str.Strings[0]);
      PatchByte := StrToUInt('$' + str.Strings[1]) and $FF;
    except
      MessageBox(Handle, 'Check entered patch data', 'Error', MB_ICONERROR);
    end;

    WriteProcessMemory(PI.hProcess,Pointer(ImageBase + RVA),@PatchByte,1,W);
  end;

  str.Free;

  ResumeThread(PI.hThread);
  Context.ContextFlags:=$00010000+15+$10;

  FreeMem(Buffer);
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if opn.Execute then
    edtPath.Text := opn.FileName;
end;

end.
 