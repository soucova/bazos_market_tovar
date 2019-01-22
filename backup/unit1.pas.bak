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
    Button4: TButton;
    Button5: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
    //  aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
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
  PocetRiadkov, AktualnyRiadok: integer;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var Riadok, PoziciaZnaku: integer;
    Pomocna: string;
begin
{=============== FORM 1 ==============}

  {-*- DEAKTIVACIA COMPONENTOV/NASTAVENIA -*-}
  Randomize;
  Memo1.Clear;

  Button2.enabled := false;                     //Tlacidlo pre pridavanie tovaru
  Button5.Enabled := false;                     //Tlacidlo pre editovanie poloziek
  Edit1.Enabled := false;
  Edit2.Enabled := false;
  ComboBox1.Enabled := false;

  {ﾟ*✫.-*- NACITANIE DO RECORDU -*-.✫*ﾟ }
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
    StringGrid1.Cells[0, Riadok] := inttostr(Riadok);
  end;


end;

{procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  {-*- ZAFARBENIE AKTUALNEHO POLICKA -*-}
           //chyba Zafarbenie celeho riadku
  If (gdfocused in astate) then
  begin
    stringgrid1.canvas.brush.color:=clyellow;
    stringgrid1.canvas.fillrect(arect);
    stringgrid1.canvas.drawfocusrect(arect);
    stringgrid1.canvas.font.color:=clblack;
    stringgrid1.canvas.TextOut(arect.left+3,arect.top+3,stringgrid1.Cells[acol,arow]);
  end;
end; }

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
begin
  If (Gdfixed in astate) then
     exit;
  If (aRow = StringGrid1.Row) then
     StringGrid1.Canvas.Brush.Color := rgbtocolor(255,255,200);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  AktualnyRiadok := aRow;
  StringGrid1.Invalidate;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
{===== BUTTON - VYTVORIT POLOZKU =====}

  {-*- AKTIVACIA COMPONENTOV -*-}
  Button2.enabled := true;
  Button5.Enabled := false;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox1.Enabled := true;
  Label4.caption := 'Vytvorenie Novej Polozky';

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

  If (NazovEdit = '') or ((KodEdit > 999999) or (KodEdit < 100000)) then
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
    Memo1.Append('Nova polozka ( ' + Tovar[PocetRiadkov].Nazov + ' : ' + inttostr(Tovar[PocetRiadkov].Kod) + ' ) uspesne pridana.');
  end;

   {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
    StringGrid1.Cells[0, I] := inttostr(I);
  end

end;

procedure TForm1.Button3Click(Sender: TObject);
var KodPom, I: integer;
    NazovPom, NazovMessage: string;
begin
{===== BUTTON - ODSTRANIT OZNACENE =====}

  {-*- AKTIVACIA COMPONENTOV/NASTAVENIA -*-}
  Button5.enabled := false;
  Button2.Enabled := false;
  Edit1.Enabled := false;
  Edit2.Enabled := false;
  ComboBox1.Enabled := false;
  Label4.caption := '';
  Edit1.Text := '';
  Edit2.Text := '100000';
  ComboBox1.Text := 'Zelenina';

  {-*- DIALOGOVE OKNO -*-}
  If MessageDlg('Chces naozaj odstranit '+ Tovar[AktualnyRiadok].Nazov +' ?', MTConfirmation, [mbYES, mbNO], 0) = mrYES then
  Begin
  {-*- ODSTRANENIE A POSUN -*-}
    NazovMessage := Tovar[AktualnyRiadok].Nazov;
    For I := AktualnyRiadok to (PocetRiadkov - 1) do
      Begin
            KodPom := Tovar[I+1].Kod;
            NazovPom := Tovar[I+1].Nazov;
            Tovar[I].Kod := KodPom;
            Tovar[I].Nazov := NazovPom;
      End;
    Dec(PocetRiadkov, 1);
    Memo1.Append('Polozka ('+NazovMessage+') bola odstranena.');
  End
  Else
  Begin
    Exit;
  End;


  {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
    StringGrid1.Cells[0, I] := inttostr(I);
  end
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
{===== BUTTON - EDITOVAT OZNACENE =====}

  {-*- AKTIVACIA COMPONENTOV -*-}
  Button5.enabled := true;
  Button2.Enabled := false;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox1.Enabled := true;
  Label4.caption := 'Editovanie Existujucej Polozky';

  {-*- NASTAVENIE EDITOV -*-}
  Edit1.text := Tovar[AktualnyRiadok].Nazov;
  Edit2.text := inttostr(Tovar[AktualnyRiadok].Kod);

end;

procedure TForm1.Button5Click(Sender: TObject);
var I, KodEdit, KodPom, Zhoda: integer;
    NazovEdit, NazovPom: string;
begin
{============= BUTTON - ZMENIT =============}

  NazovPom := StringGrid1.Cells[2, AktualnyRiadok];
  KodPom := strtoint(StringGrid1.Cells[1, AktualnyRiadok]);

  {-*- KONTROLA HODNOT -*-}
  Zhoda := 0;
  NazovEdit := Edit1.text;
  KodEdit := strtoint(Edit2.text);
  If (NazovEdit = '') or ((KodEdit > 999999) or (KodEdit < 100000)) then
  begin
    Memo1.Append('Nepovoleny Nazov/Kod Tovaru');
    Zhoda := 1;
  end;

  {-*- PRIDANIE DO RECORDU -*-}
  If Zhoda = 0 then
  begin
    Tovar[AktualnyRiadok].Nazov := NazovEdit;
    Tovar[AktualnyRiadok].Kod := KodEdit;
    Memo1.Append('Zmena polozky ( ' + NazovPom + ' : ' + inttostr(KodPom) + ' ) >>>'+ Tovar[AktualnyRiadok].Nazov + ' : ' + inttostr(Tovar[AktualnyRiadok].Kod));
  end;

   {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
    StringGrid1.Cells[0, I] := inttostr(I);
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
{NEDOSTATKY:

}
