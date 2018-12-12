// Created by x00man01d
// Copyright (c) 2015. All rights reserved.
unit uPref;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, StdCtrls, PlugInIntf, ExtCtrls,
  ShlObj;

type
  TfrmPref = class(TForm)
    pnlButtons: TPanel;
    cbbServer: TComboBox;
    edPath: TEdit;
    btnSelectPath: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectPathClick(Sender: TObject);
    procedure cbbServerChange(Sender: TObject);
  private
    function GetFolder: string;
  public
    { Public declarations }
  end;


procedure DoPreferences;

implementation

{$R *.DFM}

procedure DoPreferences;
begin
  with TfrmPref.Create(Application) do
  begin
    if ShowModal = mrOK then
    begin
      IDE_SetPrefAsString(PlugInID, '', PAnsiChar(AnsiString(cbbServer.Text)),
        PAnsiChar(AnsiString(edPath.Text)));
    end;
    Free;
  end;
//frmPref := nil;
end;

procedure TfrmPref.btnSelectPathClick(Sender: TObject);
begin
  edPath.Text := GetFolder;
end;

procedure TfrmPref.cbbServerChange(Sender: TObject);
var
  APath: AnsiString;
begin
  APath := AnsiString(cbbServer.Text);
  edPath.Text := string(IDE_GetPrefAsString(PlugInID, '',
    PAnsiChar(APath), ''));
end;

procedure TfrmPref.FormCreate(Sender: TObject);
var
  I: Integer;
  Description, Username, Password, Database, ConnectAs: PAnsiChar;
  ID, ParentID: Integer;
  res: Boolean;
begin
  I := 0;
  repeat
    res := PlugInIntf.IDE_GetConnectionTree(I, Description, Username, Password,
      Database, ConnectAs, ID, ParentID);

    if not((Username = '') or (Database = '') or (ParentID = 0)) then
      cbbServer.Items.Add(UpperCase(string(Username) + '@' + string(Database)));

    Inc(I);
  until not res;
end;

function TfrmPref.GetFolder: string;
var
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array [0 .. MAX_PATH] of char;
  TempPath: array [0 .. MAX_PATH] of char;
begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Self.Handle;
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar('Choose folder');
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemID <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    result := TempPath;
    GlobalFreePtr(lpItemID);
  end;

end;

end.
