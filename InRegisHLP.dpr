program InRegisHLP;

uses
  Forms,
  Sysutils,
  uError,
  Vcl.Dialogs,
  uInRegisHLP in 'uInRegisHLP.pas' {MainForm};

{$R *.RES}

Procedure ShowArgumentsAndTerminate;
begin
  ShowMessage('inRegisHLP ESRIgridModelArea RegisSingleESRIgrid RegisDataInModelgebied');
  Application.Terminate;
end;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Try
    Try
      if ( ParamCount = 3 ) then
        MainForm.GoButton.Click else
      //Application.Run;
      ShowArgumentsAndTerminate;
    Except
      WriteToLogFileFmt( 'Error in application: [%s].', [ApplicationFileName] );
    end;
  Finally
  end;
end.
