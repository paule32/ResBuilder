unit Example;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponentBase, JvZlibMultiple, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    z: TJvZlibMultiple;
    RichEdit1: TRichEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses
  test1;
procedure TForm1.Button1Click(Sender: TObject);
var
  b: Integer;
  theData: Array of Byte;
  theStream: TMemoryStream;
begin
  RichEdit1.Lines.Clear;
  if not(DirectoryExists('temp')) then
  CreateDir('temp');

  SetLength(theData,Length(TByteArray_test1)-1);
  for b := 0 to Length(TByteArray_test1)-1 do
  begin
    theData[b] := TByteArray_test1[b];
  end;

  theStream := TMemoryStream.Create;
  try
    theStream.Write(theData[Low(theData)], Length(theData));
    theStream.Seek(0, soFromBeginning);
    theStream.SaveToFile('temp\XBytes.bin');
  finally
    theStream.Clear;
    theStream.Free;
  end;

  z.DecompressFile('temp\XBytes.bin','temp',true);
  RichEdit1.Lines.LoadFromFile('temp\Example.pas');
end;

end.
