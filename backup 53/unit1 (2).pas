unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;
type
  Data = record
     Kod:integer;
     Nazov:string;
  end;
const N = 50;
var
  Subor: textfile;
  Tovar: array[1..N] of Data;
  PocetRiadkov: integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var Riadok, PoziciaZnaku: integer;
    Pomocna: string;
begin
  {ﾟ*✫.-* DEAKTIVACIA COMPONENTOV/NASTAVENIA -*-.✫*ﾟ}
  Randomize;
  Memo1.Clear;

  Button2.enabled := false;                     //Tlacidlo pre pridavanie tovaru
  Edit1.Enabled := false;
  Edit2.Enabled := false;
  ComboBox1.Enabled := false;

  {ﾟ*✫.-*- NACITANIE DO RECORDU -*-.✫*ﾟ}
  Riadok := 0;
  AssignFile(Subor, 'data.txt');
  Reset(Subor);
  Readln(Subor, PocetRiadkov);
  While not eof(Subor) do
  begin
    inc(Riadok);
    Readln(Subor, Pomocna);
    Tovar[Riadok].Kod := strtoint(copy(Pomocna, 2, 6));
    Delete(Pomocna, 1, 10);
    PoziciaZnaku := pos(']', Pomocna);
    Delete(Pomocna, PoziciaZnaku, 1);
    Tovar[Riadok].Nazov := Pomocna;
  end;

  {ﾟ*✫.-* VPISOVANIE DO TABULKY -*-.✫*ﾟ}

  StringGrid1.Rowcount := PocetRiadkov + 1;     //Pocet Riadkov + Header
  StringGrid1.Cells[1, 0] := 'Kod Tovaru';      //[Stlpec, Riadok]
  StringGrid1.Cells[2, 0] := 'Nazov Tovaru';
  For Riadok := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, Riadok] := inttostr(Tovar[Riadok].Kod);
    StringGrid1.Cells[2, Riadok] := Tovar[Riadok].Nazov;
  end;


end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  {-*- AKTIVACIA COMPONENTOV -*-}
  Button2.enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox1.Enabled := true;

end;

procedure TForm1.Button2Click(Sender: TObject);
var I, KodEdit, Zhoda: integer;
    NazovEdit: string;
begin
  {-*- KONTROLA HODNOT -*-}
  Zhoda := 0;
  NazovEdit := Edit1.text;
  KodEdit := strtoint(Edit2.text);

  For I := 1 to PocetRiadkov do
  Begin
    If (NazovEdit = Tovar[I].Nazov) or (KodEdit = Tovar[I].Kod) then
    begin
      Memo1.Append('Tento Tovar/Kod Tovaru uz existuje.');
      Zhoda := 1;
    end;
  end;

  If (NazovEdit = '') or (KodEdit > 999999) then
  begin
    Memo1.Append('Nepovoleny Nazov/Kod Tovaru');
    Zhoda := 1;
  end;

  {-*- PRIDANIE DO RECORDU -*-}
  If Zhoda = 0 then
  begin
    Inc(PocetRiadkov, 1);
    Tovar[PocetRiadkov].Nazov := NazovEdit;
    Tovar[PocetRiadkov].Kod := KodEdit;
    Memo1.Append('Nova polozka (' + Tovar[PocetRiadkov].Nazov + ';' + inttostr(Tovar[PocetRiadkov].Kod) + ') uspesne pridana.');
  end;

   {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
  end

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var ZaciatokKodu, KoniecKodu: string;
    PomocneCislo, I: integer;
begin
  Case ComboBox1.text of
    'Zelenina'        : ZaciatokKodu := '1';
    'Ovocie'          : ZaciatokKodu := '2';
    'Mliecne vyrobky' : ZaciatokKodu := '3';
    'Drogeria'        : ZaciatokKodu := '4';
    'Ine'             : ZaciatokKodu := '5';

  end;

  KoniecKodu := '';
  For I := 1 to 5 do
  begin
    PomocneCislo := Random(10);
    KoniecKodu := (inttostr(PomocneCislo) + KoniecKodu);
  end;
  Edit2.text := (ZaciatokKodu + KoniecKodu);

end;

end.

