unit u_detail_etudiant;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls;

type

  { Tf_detail_etudiant }

  Tf_detail_etudiant = class(TForm)
    btn_retour: TButton;
    btn_valider: TButton;
    btn_annuler: TButton;
    cmb_sexe: TComboBox;
    cmb_filiere: TComboBox;
    edt_mel: TEdit;
    edt_portable: TEdit;
    edt_telephone: TEdit;
    edt_commune: TEdit;
    edt_code: TEdit;
    edt_nom: TEdit;
    edt_prenom: TEdit;
    edt_sexe: TEdit;
    edt_filiere: TEdit;
    edt_adresse: TEdit;
    edt_num: TEdit;
    lbl_releve3: TLabel;
    lbl_moy_fili: TLabel;
    lbl_releve2: TLabel;
    lbl_moy_etud: TLabel;
    lbl_releve1: TLabel;
    lbl_erreur_filiere: TLabel;
    lbl_erreur_mel: TLabel;
    lbl_erreur_telephone_portable: TLabel;
    lbl_erreur_commune: TLabel;
    lbl_erreur_code_postal: TLabel;
    lbl_erreur_adresse: TLabel;
    lbl_erreur_prenom: TLabel;
    lbl_erreur_nom: TLabel;
    lbl_erreur_num: TLabel;
    lbl_mel: TLabel;
    lbl_portable: TLabel;
    lbl_prenom: TLabel;
    lbl_telephone: TLabel;
    lbl_filiere: TLabel;
    lbl_adresse: TLabel;
    lbl_nom: TLabel;
    lbl_num: TLabel;
    lbl_ident: TLabel;
    lbl_contact: TLabel;
    mmo_filiere: TMemo;
    pnl_titre_releve: TPanel;
    pnl_releve: TPanel;
    pnl_filiere: TPanel;
    pnl_contact: TPanel;
    pnl_adresse: TPanel;
    pnl_ident: TPanel;
    pnl_detail: TPanel;
    pnl_btn: TPanel;
    pnl_titre: TPanel;
    procedure btn_annulerClick(Sender: TObject);
    procedure btn_retourClick(Sender: TObject);
    procedure btn_validerClick(Sender: TObject);
    procedure cmb_sexeChange(Sender: TObject);
    procedure edt_adresseExit(Sender: TObject);
    procedure edt_code_postalExit(Sender: TObject);
    procedure edt_filiereExit(Sender: TObject);
    procedure edt_melExit(Sender: TObject);
    procedure edt_nomExit(Sender: TObject);
    procedure edt_numChange(Sender: TObject);
    procedure edt_numExit(Sender: TObject);
    procedure edt_numKeyPress(Sender: TObject; var Key: char);
    procedure edt_permisExit(Sender: TObject);
    procedure edt_Enter(Sender: TObject);
    procedure edt_portableExit(Sender: TObject);
    procedure edt_prenomExit(Sender: TObject);
    procedure edt_sexeExit(Sender: TObject);
    procedure edt_telephoneExit(Sender: TObject);
    procedure edt_villeExit(Sender: TObject);
    procedure init ( idetud : string; affi : boolean);
    procedure detail ( idetud : string);
    procedure edit ( idetud : string);
    procedure add;
    procedure delete ( idetud : string);
    procedure lbl_ajout_inscriptionClick(Sender: TObject);
    procedure mmo_filiereChange(Sender: TObject);
    procedure pnl_amende_listClick(Sender: TObject);
    procedure pnl_identClick(Sender: TObject);

  private
    procedure affi_page;
    procedure affi_filiere (num : string);
    function affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;
    procedure affi_moy_etud(num: string);
    procedure affi_moy_fil(num: string);
    { private declarations }
  public
    { public declarations }
  end;

var
  f_detail_etudiant: Tf_detail_etudiant;

implementation

{$R *.lfm}

uses u_feuille_style, u_list_etudiant, u_releve, u_etudiant_ajout, u_modele, u_loaddataset;

{ Tf_detail_etudiant }

Var oldvaleur : string; // utilisée dans la modification pour comparer l’ancienne valeur avec la saisie
id : string; // variable active dans toute l'unité, contenant l'id etudiant affiché

procedure Tf_detail_etudiant.affi_page;
var
	flux : TLoadDataSet;
begin
     flux := modele.etudiant_num(id);
     flux.read;
     edt_num.text := flux.Get('id');
     edt_sexe.text := flux.Get('civ');
     edt_nom.text := flux.Get('nom');
     edt_prenom.text := flux.Get('prenom');
     edt_adresse.text := flux.Get('adresse');
     edt_code.text := flux.Get('cp');
     edt_commune.text := flux.Get('ville');
     edt_telephone.text := flux.Get('telephone');
     edt_portable.text := flux.Get('portable');
     edt_mel.text := flux.Get('mel');
     edt_filiere.text := flux.Get('code');

     flux.destroy;

     affi_filiere(edt_filiere.text);

     f_releve.affi_data(modele.etudiant_liste_notes(edt_num.text));


     affi_moy_etud(edt_num.text);
     affi_moy_fil(edt_filiere.text);


end;

procedure Tf_detail_etudiant.affi_filiere(num: string);
var ch: string;
begin
     ch := modele.filiere_proprio(num);
     mmo_filiere.clear;
     if num = '' then
     mmo_filiere.lines.Add('Filiere non identifiée')
     else begin
       mmo_filiere.lines.text := ch;
     end;

end;
procedure Tf_detail_etudiant.affi_moy_etud(num: string);
var ch: string;
begin
     ch := modele.moy_etud(num);
     if num = '' then
     lbl_moy_etud.caption := 'none'
     else begin
     lbl_moy_etud.caption := ch
     end;

end;

procedure Tf_detail_etudiant.affi_moy_fil(num: string);
var ch, ch2: string;
begin
ch2 := modele.rechercher_filiere(num);
ch := modele.moy_filiere(ch2);
     if num = '' then
     lbl_moy_fili.caption := 'none'
     else begin
     lbl_moy_fili.caption := ch
     end;

end;

procedure Tf_detail_etudiant.btn_annulerClick(Sender: TObject);
begin
  close;
end;

procedure Tf_detail_etudiant.btn_retourClick(Sender: TObject);
begin
  close;
end;

procedure Tf_detail_etudiant.btn_validerClick(Sender: TObject);

var
  flux	     : TLoadDataSet;
  saisie, erreur, ch	 : string;
  i 	     : integer;
  valide  : boolean;

begin

  valide := true;

  //nom
    erreur := '';
  saisie := edt_nom.text;
  if saisie = '' then erreur := 'Le nom doit être rempli' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_nom,edt_nom) AND valide;

  //prenom
    erreur := '';
  saisie := edt_prenom.text;
  if saisie = '' then erreur := 'Le prénom doit être rempli' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_prenom,edt_prenom) AND valide;

    //adresse
    erreur := '';
  saisie := edt_adresse.text;
  if saisie = '' then erreur := 'L''adresse doit être remplie' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_adresse,edt_adresse) AND valide;

    //cp
    erreur := '';
  saisie := edt_code.text;
  if saisie = '' then erreur := 'Le code postal doit être rempli' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_code_postal,edt_code) AND valide;

    //commune
    erreur := '';
  saisie := edt_commune.text;
  if saisie = '' then erreur := 'La commune doit être remplie' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_commune,edt_commune) AND valide;

    //mel
    erreur := '';
  saisie := edt_mel.text;
  if saisie = '' then erreur := 'Le mel doit être rempli' ;
  valide := affi_erreur_saisie(erreur,lbl_erreur_mel,edt_mel) AND valide;

    //telephone-portable
    erreur := '';
    if ((edt_telephone.text = '') AND (edt_portable.text = '')) then
    erreur := 'Le téléphone ou le portable doivent être saisis';
    valide := affi_erreur_saisie(erreur,lbl_erreur_telephone_portable,edt_telephone) AND affi_erreur_saisie(erreur,lbl_erreur_telephone_portable,edt_portable) AND valide;

    //filiere
        erreur := '';
    if (cmb_filiere.ItemIndex = -1) then
    erreur := 'La filière doit ëtre renseignée';
    valide := affi_erreur_saisie(erreur,lbl_erreur_filiere,edt_nom) AND valide;

      //pour le numero
   if  id = ''
   then  begin
            erreur := '';
            saisie := edt_num.text;
            if   saisie = ''   then  erreur := 'Le numéro doit être rempli.'
           else  begin
                   flux := modele.etudiant_num(saisie);
                   if  NOT  flux.endOf
                   then  erreur := 'Le numéro existe déjà';
           end;
           valide := affi_erreur_saisie (erreur, lbl_erreur_num, edt_num)  AND  valide;
   end;

   if  NOT  valide
   then  messagedlg ('Erreur enregistrement étudiant', 'La saisie est incorrecte.' +#13 +'Corrigez la saisie et validez à nouveau.', mtWarning, [mbOk], 0)
   else  begin
              if  id =''
	      then  modele.etudiant_insert(edt_num.text, cmb_sexe.items[cmb_sexe.ItemIndex], edt_nom.text, edt_prenom.text, edt_adresse.text, edt_code.text, edt_commune.text, edt_portable.text, edt_telephone.text, edt_mel.text, IntToStr(cmb_filiere.ItemIndex + 1))
	      else  begin
	            modele.etudiant_update(id, cmb_sexe.items[cmb_sexe.ItemIndex], edt_nom.text, edt_prenom.text, edt_adresse.text, edt_code.text, edt_commune.text, edt_portable.text, edt_telephone.text, edt_mel.text, IntToStr(cmb_filiere.ItemIndex + 1))
	      end;
   end;

end;

procedure Tf_detail_etudiant.cmb_sexeChange(Sender: TObject);
begin

end;

procedure Tf_detail_etudiant.edt_adresseExit(Sender: TObject);
begin
edt_adresse.text := TRIM(edt_adresse.text);
end;

procedure Tf_detail_etudiant.edt_code_postalExit(Sender: TObject);
begin
  edt_code.text := TRIM(edt_code.text);
end;

procedure Tf_detail_etudiant.edt_filiereExit(Sender: TObject);
begin
edt_filiere.text := TRIM(edt_filiere.text);
IF NOT ( edt_filiere.text = oldvaleur )
THEN affi_filiere (edt_filiere.text);
end;

procedure Tf_detail_etudiant.edt_melExit(Sender: TObject);
begin
  edt_mel.text := TRIM(edt_mel.text);
end;

procedure Tf_detail_etudiant.edt_nomExit(Sender: TObject);
begin
  edt_nom.text := TRIM(edt_nom.text);
end;
procedure Tf_detail_etudiant.edt_numChange(Sender: TObject);
begin
  oldvaleur := TEdit(Sender).text;
end;

procedure Tf_detail_etudiant.edt_numExit(Sender: TObject);
begin
edt_num.text := TRIM(edt_num.text);
end;

procedure Tf_detail_etudiant.edt_numKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tf_detail_etudiant.edt_permisExit(Sender: TObject);
begin
end;

procedure Tf_detail_etudiant.edt_Enter(Sender: TObject);
begin
   oldvaleur := TEdit(Sender).text;
end;

procedure Tf_detail_etudiant.edt_portableExit(Sender: TObject);
begin
  edt_portable.text := TRIM(edt_portable.text);
end;

procedure Tf_detail_etudiant.edt_prenomExit(Sender: TObject);
begin
  edt_prenom.text := TRIM(edt_prenom.text);
end;

procedure Tf_detail_etudiant.edt_sexeExit(Sender: TObject);
begin
end;

procedure Tf_detail_etudiant.edt_telephoneExit(Sender: TObject);
begin
  edt_telephone.text := TRIM(edt_telephone.text);
end;

procedure Tf_detail_etudiant.edt_villeExit(Sender: TObject);
begin
  edt_commune.text := TRIM(edt_commune.text);
end;

procedure Tf_detail_etudiant.Init ( idetud : string; affi : boolean);
begin
   style.panel_travail (pnl_titre);
   style.panel_travail (pnl_btn);
   style.panel_travail (pnl_detail);
   style.panel_travail  (pnl_ident);
	style.label_titre  (lbl_ident);
        style.label_titre  (lbl_num); style.label_erreur (lbl_erreur_num);
        style.label_titre(lbl_nom);   style.label_erreur (lbl_erreur_nom);
        style.label_titre(lbl_prenom);   style.label_erreur (lbl_erreur_prenom);
   style.panel_travail (pnl_adresse);
	style.label_titre (lbl_adresse);
	style.label_erreur(lbl_erreur_adresse);
        style.label_erreur(lbl_erreur_code_postal);
        style.label_erreur(lbl_erreur_commune);
   style.panel_travail (pnl_contact);
	style.label_titre (lbl_contact);   style.label_erreur (lbl_erreur_telephone_portable);
	style.label_titre (lbl_telephone);
        style.label_titre (lbl_portable);
        style.label_titre (lbl_mel); style.label_erreur (lbl_erreur_mel);
   style.panel_travail (pnl_filiere);
	style.label_titre (lbl_filiere);  style.memo_info(mmo_filiere);
	style.label_erreur (lbl_erreur_filiere);
   style.panel_travail (pnl_releve);
   style.panel_travail (pnl_titre_releve);
       style.label_titre(lbl_releve1);
       style.label_titre(lbl_releve2);
       style.label_titre(lbl_releve3);
       style.label_titre(lbl_moy_etud);
       style.label_titre(lbl_moy_fili);

   // initialisation identification
   lbl_erreur_num.caption	:='';
   lbl_erreur_nom.caption	:='';
   lbl_erreur_prenom.caption	:='';
   edt_num.clear;
   edt_nom.clear;
   edt_prenom.clear;
   edt_sexe.clear;
   edt_num.ReadOnly	:=affi;
   edt_nom.ReadOnly	:=affi;
   edt_prenom.ReadOnly	:=affi;
   edt_sexe.ReadOnly:= affi;

   //initialisation adresse
   lbl_erreur_adresse.caption := '';
   lbl_erreur_code_postal.caption := '';
   lbl_erreur_commune.caption := '';

   edt_adresse.clear;
   edt_code.clear;
   edt_commune.clear;
   edt_adresse.ReadOnly	:=affi;
   edt_code.ReadOnly	:=affi;
   edt_commune.ReadOnly	:=affi;

   //initilisation contact
   lbl_erreur_telephone_portable.Caption := '';
   lbl_erreur_mel.Caption := '';

   edt_telephone.Clear;
   edt_portable.clear;
   edt_mel.clear;

   edt_telephone.ReadOnly := affi;
   edt_portable.ReadOnly := affi;
   edt_mel.ReadOnly := affi;

   //init filiere

   lbl_erreur_filiere.Caption:= '';

   edt_filiere.Clear;
   mmo_filiere.Clear;

   edt_filiere.ReadOnly := affi;
   mmo_filiere.ReadOnly:= affi;

   btn_retour.visible := affi;
   btn_valider.Visible:= NOT affi;
   btn_annuler.Visible := NOT affi;

   cmb_sexe.Visible:= NOT affi;
   edt_sexe.Visible := affi;
   edt_filiere.Visible := affi;
   cmb_filiere.Visible:= NOT affi;

   f_releve.borderstyle := bsNone;
   f_releve.parent := pnl_releve;
   f_releve.align := alClient;
   f_releve.init(affi);
   f_releve.show;

   lbl_moy_etud.Caption:='';
   lbl_moy_fili.Caption := '';

   id := idetud;

   IF NOT(id='') THEN
   affi_page;

   show;

end;
function Tf_detail_etudiant.affi_erreur_saisie (erreur : string; lbl : TLabel; edt : TEdit) : boolean;
begin
lbl.caption := erreur;
if NOT (erreur = '')
then begin
edt.setFocus;
result := false;
end
else result := true;
end;
procedure Tf_detail_etudiant.detail (idetud : string);
begin
     init(idetud,true);        //mode affichage
     pnl_titre.caption := 'Détail d''un étudiant';
     btn_retour.setFocus;
          lbl_releve2.visible := true;
lbl_releve3.visible := true;
lbl_moy_etud.visible := true;
lbl_moy_fili.visible := true;
end;
procedure Tf_detail_etudiant.edit (idetud : string);
begin
     init(idetud,false);
     pnl_titre.caption := 'Modification d''un étudiant';
     edt_num.ReadOnly := true;
     edt_nom.setFocus;
     lbl_releve2.visible := true;
lbl_releve3.visible := true;
lbl_moy_etud.visible := true;
lbl_moy_fili.visible := true;

end;
procedure Tf_detail_etudiant.add;
begin
  init ('',false);   // pas de numéro d'etudiant
  pnl_titre.caption   := 'Nouvel étudiant';
  edt_num.setFocus;
  lbl_releve2.visible := false;
  lbl_releve3.visible := false;
  lbl_moy_etud.visible := false;
  lbl_moy_fili.visible := false;
  //lbl_releve
end;
procedure Tf_detail_etudiant.delete (idetud : string);
begin
IF   messagedlg ('Demande de confirmation'
     ,'Confirmez-vous la suppression de l''étudiant n°' + idetud
     ,mtConfirmation, [mbYes,mbNo], 0, mbNo) = mrYes
THEN  BEGIN
       modele.etudiant_delete(idetud);
       modele.etudiant_notation_delete(idetud);
       f_list_etudiant.line_delete;
END;
end;

procedure Tf_detail_etudiant.lbl_ajout_inscriptionClick(Sender: TObject);
begin

end;

procedure Tf_detail_etudiant.mmo_filiereChange(Sender: TObject);
begin

end;

procedure Tf_detail_etudiant.pnl_amende_listClick(Sender: TObject);
begin

end;

procedure Tf_detail_etudiant.pnl_identClick(Sender: TObject);
begin

end;

end.

