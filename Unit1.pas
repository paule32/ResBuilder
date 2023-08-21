// ResBuilder v1.0
// (c) 2023 by Jens Kallup
// all rights reserved.
//
// help me. to write resource objects.
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, JvComponentBase, JvZlibMultiple, JvBrowseFolder;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    Button5: TButton;
    Button6: TButton;
    RichEdit1: TMemo;
    jvzlib: TJvZlibMultiple;
    Button7: TButton;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    FileList    : TStrings;
    FileListType: TStrings;
    FileListName: TStrings;

    FileOutputDir: String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if not(OpenDialog1.Execute) then
  begin
    ShowMessage('open error.');
    exit;
  end;
  Edit1.Text := OpenDialog1.FileName;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ShowMessage('ResBuilder v1.0' + #10 +
  'Copyright (c) 2023 Jens Kallup');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(
  Application.ExeName);

  FileList     := TStringList.Create;

  FileListName := TStringList.Create;
  FileListType := TStringList.Create;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  S1: String;
begin
  S1 := Trim(Edit1.Text);

  if Length(S1) < 1   then exit else
  if Length(S1) > 128 then exit ;

  S1 := ExtractFileName( S1 );
  S1 := ChangeFileExt( S1, '' );

  if FileListName.IndexOf( S1 ) > -1 then
  begin
    ShowMessage('item already exists.');
    exit;
  end;
  FileList    .Add( Edit1.Text );
  FileListName.Add( S1 );
  FileListType.Add( 'BMP' );

  S1 := S1 + #9 + 'BMP' + #9 + '"' + Edit1.Text + '"';
  RichEdit1.Lines.Add( S1 );
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FileListName.Clear;
  FileListName.Free;

  FileList.Clear;
  FileList.Free;

  FileListType.Clear;
  FileListType.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  S1: String;
begin
  S1 := Trim(Edit1.Text);

  if Length(S1) < 1  then exit else
  if Length(S1) > 64 then exit ;

  S1 := ExtractFileName( S1 );
  S1 := ChangeFileExt( S1, '' );

  if FileList.IndexOf( S1 ) > -1 then
  begin
    ShowMessage('item already exists.');
    exit;
  end;
  FileList    .Add( Edit1.Text );
  FileListName.Add( S1 );
  FileListType.Add( 'TXT' );

  S1 := S1 + #9 + 'TXT' + #9 + '"' + Edit1.Text + '"';
  RichEdit1.Lines.Add( S1 );
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  S1: String;
begin
  S1 := Trim(Edit1.Text);

  if Length(S1) < 1  then exit else
  if Length(S1) > 64 then exit ;

  S1 := ExtractFileName( S1 );
  S1 := ChangeFileExt( S1, '' );

  if FileList.IndexOf( S1 ) > -1 then
  begin
    ShowMessage('item already exists.');
    exit;
  end;

  FileList    .Add( Edit1.Text );
  FileListName.Add( S1 );
  FileListType.Add( 'CERT' );

  S1 := S1 + #9 + 'CERT' + #9 + '"' + Edit1.Text + '"';
  RichEdit1.Lines.Add( S1 );
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  MS: TMemoryStream;
  FL: TStrings;
  CF: TStrings;
  S1: String;
  I : Integer;
  J : Integer;
  WW: Integer;
  BA: Array of Byte;
  TF: TextFile;
begin
  if FileList.Count < 0 then
  begin
    ShowMessage('no data.');
    exit;
  end;

  if Length(Trim(Edit2.Text)) < 1 then begin
    ShowMessage('no output file.');
    exit;
  end;
  if not DirectoryExists(FileOutputDir) then begin
    CreateDir(FileOutputDir);
  end;

  FL := TStringList.Create;
  for i := 0 to FileList.Count - 1 do FL.Add( FileList.Strings[I] );
  for I := 0 to FileList.Count - 1 do
  begin
    FileList.Strings[I] := FileOutputDir + '\' +
    ChangeFileExt(ExtractFileName(FileList.Strings[I]), '.zip');
  end;

  CF := TStringList.Create;
  try
    for I := 0 to FL.Count - 1 do
    begin
      CF.Clear;
      CF.Add( FL.Strings[I] );
      jvzlib.CompressFiles( CF , FileList.Strings[I]);
    end;
  finally
    CF.Clear;
    CF.Free;
  end;

  for I := 0 to FileList.Count - 1 do
  begin
    MS := TMemoryStream.Create;
    try
      MS.LoadFromFile( FileList.Strings[I] );
      SetLength( BA,    MS.Size );
      MS.Read  ( BA[0], MS.size );

      S1 := FileOutputDir + '\' + ChangeFileExt(ExtractFileName(
      FileList.Strings[I]), '.pas');

      if FileExists( S1 ) then
      DeleteFile( S1 );

      AssignFile( TF, S1 );
      {$I+}
      ReWrite( TF );
      {$I-}
      try
        S1 := ChangeFileExt(ExtractFileName(
        FileList.Strings[I]),'');

        WriteLn( TF, '// ------------------------------------------------');
        WriteLn( TF, '// ResBuilder v.1.0' );
        WriteLn( TF, '// (c) 2023 by paule32.jk@gmail.com' );
        WriteLn( TF, '//');
        WriteLn( TF, '// THIS FILE WAS AUTOMATICALLY CREATED.');
        WriteLn( TF, '// ------------------------------------------------');
        WriteLn( TF, 'unit ' + S1 + ';');
        WriteLn( TF, 'interface');
        WriteLn( TF, 'const');
        WriteLn( TF, '  TByteArray_' + S1  +
        ': Array [0..' + IntToStr(MS.Size) + '] of Byte = (');

        ww    := 0 ;
        for J := 0 to MS.Size - 1 do
        begin
          inc( ww );
          if ww = 20 then
          begin
            WriteLn( TF, '' );
            ww := 0;
          end;
          Write( TF, '$' + IntToHex( BA[J], 2 ) );
          Write( TF, ', ');
        end;

        WriteLn( TF, '0 );' );
        WriteLn( TF, 'implementation');
        WriteLn( TF, 'end.');

        CloseFile( TF );
      except
        on E: Exception do
        begin
          ShowMessage('file creation error:' + #10 +
          E.ClassName + ' / ' + E.Message);
          exit;
        end;
      end;
    finally
      MS.Clear;
      MS.Free;
    end;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  S: String;
begin
  S := ExtractFilePath(Application.ExeName);
  if not BrowseForFolder('Target Folder',true,S) then
  begin
    ShowMessage('open error.');
    exit;
  end;
  FileOutputDir := S;
  Edit2.Text := S;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  Edit1.Text := '';
  Edit2.Text := '';

  RichEdit1.Lines.Clear;

  FileList.Clear;
  FileListName.Clear;
  FileListType.Clear;
end;

end.

