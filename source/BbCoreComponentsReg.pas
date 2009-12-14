unit BbCoreComponentsReg;

interface

uses
  Classes, BbStickyLabel;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Bb Core Visual', [TBbStickyLabel]);
end;

end.
