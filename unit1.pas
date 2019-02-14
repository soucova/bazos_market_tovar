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
    Button6: TButton;
    Button7: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
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
    procedure Button6Click(Sender: TObject);
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
  Subor, Subor2: textfile;
  Tovar, AktualnaTab: array[1..N] of Data;
  Kategorie: array[1..10] of string;
  PocetRiadkov, AktualnyRiadok, ComboPrepinac: integer;
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
  ComboBox1.Items.Clear;


  {ﾟ*✫.-*- NACITANIE DO RECORDU -*-.✫*ﾟ }
  Riadok := 0;
  AssignFile(Subor, 'data.txt');
  Reset(Subor);
  Readln(Subor, PocetRiadkov);
  For Riadok := 1 to PocetRiadkov do
  begin
    Readln(Subor, Pomocna);
    Tovar[Riadok].Kod := strtoint(copy(Pomocna, 1, 3));
    Delete(Pomocna, 1, 4);
    Tovar[Riadok].Nazov := Pomocna;
  end;

  {While not eof(Subor) do
  begin
    inc(Riadok);
    Readln(Subor, Pomocna);
    Tovar[Riadok].Kod := strtoint(copy(Pomocna, 1, 3));
    Delete(Pomocna, 1, 4);
    //PoziciaZnaku := pos(']', Pomocna);
    //Delete(Pomocna, PoziciaZnaku, 1);
    Tovar[Riadok].Nazov := Pomocna;
  end;}

    {-*- NACITANIE KATEGORIE -*-}
  Riadok := 0;
  AssignFile(Subor, 'kategorie.txt');
  Reset(Subor);
 While not eof(Subor) do
  begin
    inc(Riadok);
    Readln(Subor, Kategorie[Riadok]);
    ComboBox1.Items.Add(Kategorie[Riadok]);
  end;

  {ﾟ*✫.-*- VPISOVANIE DO TABULKY/COMBOBOXU -*-.✫*ﾟ}
  //plus kontrola
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
  If (Gdfixed in aState) then
     exit;
  If (aRow = StringGrid1.Row) then
     StringGrid1.Canvas.Brush.Color := rgbtocolor(255,255,200);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  //AktualnyRiadok := aRow;
  AktualnyRiadok := strtoint(StringGrid1.Cells[0,aRow]);
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
  ComboPrepinac := 1;

  {-*- EDITY -*-}
  Edit1.Text := '';
  Edit2.Text := '100';
  ComboBox1.Text := 'Ovocie';

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
      Memo1.Append('Tento Tovar/Kod Tovaru uz existuje');
      Zhoda := 1;
    end;
  end;

  If (NazovEdit = '') or ((KodEdit > 499) or (KodEdit < 100)) or (Length(NazovEdit) > 25) then
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
  end;
  StringGrid1.CheckPosition;

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
  Edit2.Text := '100';
  ComboBox1.Text := 'Ovocie';

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
    Memo1.Append('Polozka ( '+NazovMessage+' ) bola odstranena.');
  End
  Else
  Begin
    Memo1.Append('Polozka nebola odstranena');
    Exit;
  End;


  {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
    StringGrid1.Cells[0, I] := inttostr(I);
  end;
  StringGrid1.CheckPosition;
end;

procedure TForm1.Button4Click(Sender: TObject);
var KodPomocna: String;
begin
{===== BUTTON - EDITOVAT OZNACENE =====}

  {-*- AKTIVACIA COMPONENTOV -*-}
  Button5.enabled := true;
  Button2.Enabled := false;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  ComboBox1.Enabled := true;
  Label4.caption := 'Editovanie Existujucej Polozky';
  ComboPrepinac := 0;

  {-*- NASTAVENIE EDITOV -*-}
  Edit1.text := Tovar[AktualnyRiadok].Nazov;
  Edit2.text := inttostr(Tovar[AktualnyRiadok].Kod);

  {-*- NASTAVENIE EDITOV -*-}
  Edit1.text := Tovar[AktualnyRiadok].Nazov;
  Edit2.text := inttostr(Tovar[AktualnyRiadok].Kod);
  KodPomocna := Edit2.text;
  ComboBox1.text := Kategorie[strtoint(KodPomocna[1])];

end;

procedure TForm1.Button5Click(Sender: TObject);
var I, KodEdit, KodPom, Zhoda: integer;
    NazovEdit, NazovPom: string;
begin
{============ BUTTON - ZMENIT ============}

  NazovPom := Tovar[AktualnyRiadok].Nazov;
  KodPom := Tovar[AktualnyRiadok].Kod;

  {-*- KONTROLA HODNOT -*-}
  Zhoda := 0;
  NazovEdit := Edit1.text;
  KodEdit := strtoint(Edit2.text);
  If (NazovEdit = '') or ((KodEdit > 499) or (KodEdit < 100)) or (Length(NazovEdit) > 25) then
  begin
    Memo1.Append('Nepovoleny Nazov/Kod Tovaru.');
    Zhoda := 1;
  end;

  {-*- PRIDANIE DO RECORDU -*-}
  If Zhoda = 0 then
  begin
    Tovar[AktualnyRiadok].Nazov := NazovEdit;
    Tovar[AktualnyRiadok].Kod := KodEdit;
    Memo1.Append('Zmena polozky  ' + NazovPom + ' : ' + inttostr(KodPom) + ' >>> '+ Tovar[AktualnyRiadok].Nazov + ' : ' + inttostr(Tovar[AktualnyRiadok].Kod));
  end;

  {-*- VPISOVANIE DO TABULKY -*-}
  StringGrid1.Rowcount := PocetRiadkov + 1;
  For I := 1 to PocetRiadkov do
  begin
    StringGrid1.Cells[1, I] := inttostr(Tovar[I].Kod);
    StringGrid1.Cells[2, I] := Tovar[I].Nazov;
    StringGrid1.Cells[0, I] := inttostr(I);
  end;
  StringGrid1.CheckPosition;



end;

procedure TForm1.Button6Click(Sender: TObject);
var Riadok: integer;
begin
 {-*- VPISOVANIE DO SUBORU -*-}
  If MessageDlg('Chces naozaj ulozit zmeny ?', MTConfirmation, [mbYES, mbNO], 0) = mrYES then
  Begin
    Riadok := 0;
    AssignFile(Subor2, 'data_2.txt');
    Rewrite(Subor2);
    Writeln(Subor2, inttostr(PocetRiadkov));
    For Riadok := 1 to PocetRiadkov do
    Begin
      Writeln(Subor2, inttostr(Tovar[Riadok].Kod)+';'+Tovar[Riadok].Nazov);
    end;
    Memo1.Append('Zmeny boli ulozene do suboru.');

    //plus kontrola
    Closefile( Subor2 );
  End
  Else
    Exit;

end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var ZaciatokKodu, KoniecKodu: string;
    PomocneCislo, I: integer;
begin
  Case ComboBox1.text of
    'Ovocie'          : ZaciatokKodu := '1';
    'Zelenina'        : ZaciatokKodu := '2';
    'Pecivo'          : ZaciatokKodu := '3';
    'Ine'             : ZaciatokKodu := '4';
  end;

    If ComboPrepinac = 1 then
  begin
    KoniecKodu := '';
    For I := 1 to 2 do
    begin
      PomocneCislo := Random(10);
      KoniecKodu := (inttostr(PomocneCislo) + KoniecKodu);
    end;
    Edit2.text := (ZaciatokKodu + KoniecKodu);
  end
  Else
  begin
    KoniecKodu := Edit2.text;
    Delete (KoniecKodu, 1, 1);
    Edit2.text := (ZaciatokKodu + KoniecKodu);
  end;

end;

end.
{NEDOSTATKY:
> Oznacenie viacerych poloziek (na vymazanie)
> Filtrovanie/Zoradenie (StringGrid?)
> Automaticke zobrazenie selected Polozky v upravovacom panely
> Farebne odlisenie Varovnych/ Informacnych Sprav
> Moznost Ulozenia Zmien do Suboru/Automaticke ukladanie
> Kategotie
}
