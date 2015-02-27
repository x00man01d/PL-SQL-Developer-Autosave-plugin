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
  private
    function GetFolder: string;
  public
    { Public declarations }
  end;

var
  frmPref: TfrmPref;

procedure DoPreferences;

implementation

uses
  uMain;

{$R *.DFM}

procedure DoPreferences;
begin
  frmPref := TfrmPref.Create(Application);
  with frmPref do
  begin
    if ShowModal = mrOK then
    begin
      IDE_SetPrefAsString(PlugInID, '', PChar(cbbServer.Text),
        PChar(edPath.Text));
    end;
    Free;
  end;
  frmPref := nil;
end;

procedure TfrmPref.btnSelectPathClick(Sender: TObject);
begin
  edPath.Text := GetFolder;
end;

procedure TfrmPref.FormCreate(Sender: TObject);
var
  I: Integer;
  Description, Username, Password, Database,
    ConnectAs: PChar;
  ID, ParentID: Integer;
  res: Boolean;
begin
  i := 0;
  repeat
    res := PlugInIntf.IDE_GetConnectionTree(i, Description, Username, Password, Database,
      ConnectAs, id, ParentID);

    if not ((Username = '') or (Database = '') or (ParentID = 0)) then
      cbbServer.Items.Add(UpperCase(Username + '@' + database));

    Inc(i);
  until not res;
end;

function TfrmPref.GetFolder: string;
var
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..MAX_PATH] of char;
  TempPath: array[0..MAX_PATH] of char;
begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Self.Handle;
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar('Choose folder');
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    result := TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

end.

