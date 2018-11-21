unit uInRegisHLP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, uTSingleESRIgrid, uError, AVGRIDIO, uTabstractESRIgrid,
  uESRI;

type
  TMainForm = class(TForm)
    GoButton: TButton;
    SingleESRIgridModelgebied: TSingleESRIgrid;
    aRegisSingleESRIgrid: TSingleESRIgrid;
    procedure FormCreate(Sender: TObject);
    procedure GoButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  lf: TextFile;
  LogFileName, ApplicationFileName: TFileName;

  implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitialiseLogFile;
  InitialiseGridIO;
  Caption := ExtractFileName( ChangeFileExt( ParamStr( 0 ), '' ) );
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FinaliseLogFile;
end;

procedure TMainForm.GoButtonClick(Sender: TObject);
var
  iResult: Integer;
  RegisFileName, ModelFileName, OutputFileName: String;

Function RegisDataInModelgebied( const SingleESRIgridModelgebied, aRegisSingleESRIgrid: TSingleESRIgrid ): Boolean;
var
  NRows, NCols, i, j, NrOfNoValues: Integer;
  aValue, x, y: Single;
begin
  Result := true;

  NRows := SingleESRIgridModelgebied.NRows;
  NCols := SingleESRIgridModelgebied.NCols;
  NrOfNoValues := 0;

  for i:=1 to NRows do begin
    for j:=1 to NCols do begin
      aValue := SingleESRIgridModelgebied[ i, j ];
      if ( aValue <> MissingSingle ) then begin
        SingleESRIgridModelgebied.GetCellCentre( i, j, x, y );
        if ( aRegisSingleESRIgrid.GetValueXY( x, y ) <> MissingSingle ) then
          Exit;
      end else Inc( NrOfNoValues );
    end;
  end;
  if ( NrOfNoValues > 0 ) then
    Result := false;
end;

begin
  ModelFileName := ParamStr( 1 ); WriteToLogFile(  'ParamStr(1)=[' + ParamStr(1) + ']' );
  RegisFileName := ParamStr( 2 );  WriteToLogFile(  'ParamStr(2)=[' + ParamStr(2) + ']' );
  OutputFileName := ParamStr( 3 );  WriteToLogFile(  'ParamStr(3)=[' + ParamStr(3) + ']' );

  Try {-finally}
    Try {-Except}
      SingleESRIgridModelgebied := TSingleESRIgrid.InitialiseFromESRIGridFile( ModelFileName, iResult, self );
      if ( iResult <> cNoError ) then
        Raise Exception.Create( 'Error initialising ESRI raster grid van modelgebied.' );
      aRegisSingleESRIgrid := TSingleESRIgrid.InitialiseFromESRIGridFile( RegisFileName, iResult, self );
      if ( iResult <> cNoError ) then
        Raise Exception.Create( 'Error initialising Regis ESRI raster grid.' );
      if RegisDataInModelgebied(  SingleESRIgridModelgebied, aRegisSingleESRIgrid ) then
        aRegisSingleESRIgrid.SaveAs( OutputFileName, SingleESRIgridModelgebied.BndBox );
    Except
      On E: Exception do begin
        HandleError( E.Message, true );
      end;
    end;
  Finally
    Try SingleESRIgridModelgebied.free except end;
    Try aRegisSingleESRIgrid.free except end;
  end;

end;
end.
