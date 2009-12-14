{*******************************************************************************

  Berimbau VCL

  BbComponentsLinkers.pas

  Provides interfaces for linking with components

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

unit BbComponentsLinkers;

interface

uses
  Classes, Controls;

type
  IBbComponentLinked = interface
    function GetLinkedComponent: TComponent;
    procedure SetLinkedComponent(const Value: TComponent);
  end;

  IBbControlLinked = interface
    function GetLinkedControl: TControl;
    procedure SetLinkedControl(const Value: TControl);
  end;

  // delegation class for IBbComponentLinked
  TBbComponentLinked = class(TComponent, IBbComponentLinked)
  private
    FLinkedComponent: TComponent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetLinkedComponent: TComponent; virtual;
    procedure SetLinkedComponent(const Value: TComponent); virtual;
  end;

  // delegation class for IBbControlLinked
  TBbControlLinked = class(TBbComponentLinked, IBbControlLinked)
  public
    function GetLinkedControl: TControl; virtual;
    procedure SetLinkedControl(const Value: TControl); virtual;
  end;
  
implementation

{ TBbComponentLinked }

constructor TBbComponentLinked.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLinkedComponent := nil;
end;

destructor TBbComponentLinked.Destroy;
begin
  SetLinkedComponent(nil);

  inherited Destroy;
end;

function TBbComponentLinked.GetLinkedComponent: TComponent;
begin
  Result := FLinkedComponent;
end;

procedure TBbComponentLinked.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent = FLinkedComponent) and (Operation = opRemove) then
  begin
    FLinkedComponent := nil;
  end;

  inherited Notification(AComponent, Operation);
end;

procedure TBbComponentLinked.SetLinkedComponent(const Value: TComponent);
begin
  if FLinkedComponent <> nil then
  begin
    FLinkedComponent.RemoveFreeNotification(Self);
  end;

  FLinkedComponent := Value;

  if FLinkedComponent <> nil then
  begin
    FLinkedComponent.FreeNotification(Self);
  end;
end;

{ TBbControlLinked }

function TBbControlLinked.GetLinkedControl: TControl;
begin
  Result := TControl(GetLinkedComponent);
end;

procedure TBbControlLinked.SetLinkedControl(const Value: TControl);
begin
  SetLinkedComponent(Value);
end;

end.
