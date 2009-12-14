{*******************************************************************************

  Berimbau VCL

  BbCoreComponentsReg.pas

  Register Berimbau VCL core components

  Copyright (C) 2009 Walber Zaldivar <walber.zaldivar@gmail.com>

********************************************************************************

  This library is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as published
  by the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.

*******************************************************************************}

unit BbCoreComponentsReg;

interface

uses
  Classes, BbStickyLabel;

procedure Register;

implementation

{$R ../../resources/BbCoreComponents.dcr}

procedure Register;
begin
  RegisterComponents('Bb Core Visual', [TBbStickyLabel]);
end;

end.
