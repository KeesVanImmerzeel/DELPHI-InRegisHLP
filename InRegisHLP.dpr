program InRegisHLP;

uses
  Forms,
  Sysutils,
  uError,
  uInRegisHLP in 'uInRegisHLP.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Try
    Try
      if ( ParamCount = 3 ) then
        MainForm.GoButton.Click else
      Application.Run;
    Except
      WriteToLogFileFmt( 'Error in application: [%s].', [ApplicationFileName] );
    end;
  Finally
  end;
end.
