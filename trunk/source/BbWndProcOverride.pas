{*******************************************************************************

  Berimbau VCL

  BbWndProcOverride.pas

  Provides interfaces for overriding windows procedures

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

unit BbWndProcOverride;

interface

uses
  Classes, Controls, Messages, BbComponentsLinkers;

type
  IBbWndProcOverrider = interface(IBbControlLinked)
    procedure OverrideWndProc(Value: TWndMethod); 
  end;

  // delegation class for IBbWndProcOverrider
  TBbWndProcOverrider = class(TBbControlLinked, IBbWndProcOverrider)
  private
    FOldWndProc: TWndMethod;
    FNewWndProc: TWndMethod;
    procedure WndProcOverrided(var Message: TMessage);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    destructor Destroy; override;
    procedure SetLinkedControl(const Value: TControl); override;
    procedure OverrideWndProc(Value: TWndMethod); virtual;
  end;

implementation

uses Math;

{ TBbWndProcOverrider }

destructor TBbWndProcOverrider.Destroy;
begin
  if GetLinkedControl <> nil then
  begin
    GetLinkedControl.WindowProc := FOldWndProc;
  end;

  inherited Destroy;
end;

procedure TBbWndProcOverrider.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent = GetLinkedControl) and (Operation = opRemove) then
  begin
    GetLinkedControl.WindowProc := FOldWndProc;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TBbWndProcOverrider.OverrideWndProc(Value: TWndMethod);
begin
  if GetLinkedControl <> nil then
  begin
    FNewWndProc := Value;
  end;
end;

procedure TBbWndProcOverrider.SetLinkedControl(const Value: TControl);
begin
  if GetLinkedControl <> nil then
  begin
    GetLinkedControl.WindowProc := FOldWndProc;  
  end;

  inherited SetLinkedControl(Value);

  if Value <> nil then
  begin
    FOldWndProc := Value.WindowProc;
    Value.WindowProc := WndProcOverrided;
  end;
end;

procedure TBbWndProcOverrider.WndProcOverrided(var Message: TMessage);
begin
  FNewWndProc(Message);
  FOldWndProc(Message);
end;

end.
