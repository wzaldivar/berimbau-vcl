{*******************************************************************************

  Berimbau VCL

  BbStickyLabel.pas

  Provides a label who sticks to other controls

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

unit BbStickyLabel;

interface

uses
  Classes, Controls, StdCtrls, Messages, BbWndProcOverride;

type
  TStickPosition = (spTopLeft,    spTopCenter,    spTopRight,
                    spBottomLeft, spBottomCenter, spBottomRight,
                    spLeftTop,    spLeftCenter,   spLeftBottom,
                    spRightTop,   spRightCenter,  spRightBottom);

  TBbStickyLabel = class(TLabel, IBbWndProcOverrider)
  private
    FLinkInterface: TBbWndProcOverrider;
    FStickPosition: TStickPosition;
    FStickDistance: Integer;
    FStickMargin: Integer;
    FStickReverse: Boolean;
    FStickUpdating: Boolean;
    FStickReverseUpdating: Boolean;
    property LinkInterface: TBbWndProcOverrider read FLinkInterface
      implements IBbWndProcOverrider;
    function GetStickControl: TControl;
    procedure SetCaption(const Value: TCaption);
    procedure SetFocusControl(const Value: TWinControl);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetStickControl(const Value: TControl);
    procedure WndProcHook(var Message: TMessage);
    procedure SetStickPosition(const Value: TStickPosition);
    procedure SetStickDistance(const Value: Integer);
    procedure SetStickMargin(const Value: Integer);
    procedure StickUpdate;
    procedure StickReverseUpdate;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
      AHeight: Integer); override;
  published
    property Caption write SetCaption;
    property FocusControl write SetFocusControl;
    property Left write SetLeft;
    property Top write SetTop;
    property StickControl: TControl read GetStickControl write SetStickControl;
    property StickDistance: Integer read FStickDistance write SetStickDistance
      default 1;
    property StickMargin: Integer read FStickMargin write SetStickMargin
      default 0;
    property StickPosition: TStickPosition read FStickPosition
      write SetStickPosition default spTopLeft;
    property StickReverse: Boolean read FStickReverse write FStickReverse
      default True;
  end;

implementation

{ TBbStickyLabel }

constructor TBbStickyLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FStickUpdating := False;
  FStickReverseUpdating := False;

  FLinkInterface := TBbWndProcOverrider.Create(Self);

  StickPosition := spTopLeft;
  StickDistance := 1;
  StickMargin := 0;
  StickReverse := True;
end;

destructor TBbStickyLabel.Destroy;
begin
  FLinkInterface.Free;

  inherited Destroy;
end;

function TBbStickyLabel.GetStickControl: TControl;
begin
  Result := LinkInterface.GetLinkedControl;
end;

procedure TBbStickyLabel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if FLinkInterface = nil then
  begin
    Exit;
  end;

  if FStickUpdating or FStickReverseUpdating then
  begin
    Exit;
  end;

  if StickReverse then
  begin
    StickReverseUpdate;
  end
  else
  begin
    StickUpdate;
  end;
end;

procedure TBbStickyLabel.SetCaption(const Value: TCaption);
var
  OldReverse: Boolean;
begin
  OldReverse := StickReverse;
  StickReverse := False;

  inherited Caption := Value;

  StickReverse := OldReverse;
end;

procedure TBbStickyLabel.SetFocusControl(const Value: TWinControl);
var
  OldFocusControl: TWinControl;
begin
  if FocusControl = Value then
  begin
    Exit;
  end;

  OldFocusControl := FocusControl;

  inherited FocusControl := Value;

  if (StickControl = nil) or (StickControl = OldFocusControl) then
  begin
    StickControl := Value;
  end;
end;

procedure TBbStickyLabel.SetLeft(const Value: Integer);
begin
  FStickReverseUpdating := not FStickUpdating;
  inherited Left := Value;
  StickReverseUpdate;
end;

procedure TBbStickyLabel.SetStickControl(const Value: TControl);
var
  OldStickControl: TControl;
begin
  if StickControl = Value then
  begin
    Exit;
  end;
  
  OldStickControl := StickControl;

  // Quick way
  // Do it with property editor
  if Value = Self then
  begin
    Exit;
  end;

  LinkInterface.SetLinkedControl(Value);
  LinkInterface.OverrideWndProc(WndProcHook);

  if (FocusControl = nil) or (OldStickControl = FocusControl) then
  begin
    if Value is TWinControl then
    begin
      FocusControl := Value as TWinControl;
    end;
  end;

  StickUpdate;
end;

procedure TBbStickyLabel.SetStickDistance(const Value: Integer);
begin
  FStickDistance := Value;
  StickUpdate;
end;

procedure TBbStickyLabel.SetStickMargin(const Value: Integer);
begin
  FStickMargin := Value;
  StickUpdate;
end;

procedure TBbStickyLabel.SetStickPosition(const Value: TStickPosition);
begin
  FStickPosition := Value;
  StickUpdate;
end;

procedure TBbStickyLabel.SetTop(const Value: Integer);
begin
  FStickReverseUpdating := not FStickUpdating;
  inherited Top := Value;
  StickReverseUpdate;
end;

procedure TBbStickyLabel.StickReverseUpdate;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft := 0;
  NewTop := 0;

  if StickControl = nil then
  begin
    Exit;
  end;

  if FStickUpdating then
  begin
    Exit;
  end;

  case StickPosition of
         spTopLeft,
       spTopCenter,
        spTopRight: begin
                      NewTop := Top + Height + StickDistance;
                    end;
      spBottomLeft,
    spBottomCenter,
     spBottomRight: begin
                      NewTop := Top - StickControl.Height - StickDistance;
                    end;
  end;

  case StickPosition of
         spTopLeft,
      spBottomLeft: begin
                      NewLeft := Left - StickMargin;
                    end;
    spTopCenter,
    spBottomCenter: begin
                      NewLeft := Left - (StickControl.Width - Width) div 2;
                    end;
        spTopRight,
     spBottomRight: begin
                      NewLeft := Left - (StickControl.Width - Width) +
                        StickMargin;
                    end;
  end;

  case StickPosition of
        spLeftTop,
     spLeftCenter,
     spLeftBottom: begin
                     NewLeft := Left + Width + StickDistance;
                   end;
       spRightTop,
    spRightCenter,
    spRightBottom: begin
                     NewLeft := Left - StickControl.Width - StickDistance;
                   end;
  end;

  case StickPosition of
        spLeftTop,
       spRightTop: begin
                     NewTop := Top - StickMargin;
                   end;
     spLeftCenter,
    spRightCenter: begin
                     NewTop := Top - (StickControl.Height - Height) div 2;
                   end;
     spLeftBottom,
    spRightBottom: begin
                     NewTop := Top - (StickControl.Height - Height) +
                      StickMargin;
                   end;
  end;

  FStickReverseUpdating := True;
  StickControl.SetBounds(NewLeft, NewTop, StickControl.Width,
    StickControl.Height);
  FStickReverseUpdating := False;
end;

procedure TBbStickyLabel.StickUpdate;
var
  NewLeft, NewTop: Integer;
begin
  NewLeft := 0;
  NewTop := 0;

  if StickControl = nil then
  begin
    Exit;
  end;

  if FStickReverseUpdating then
  begin
    Exit;
  end;

  Visible := StickControl.Visible;

  case StickPosition of
         spTopLeft,
       spTopCenter,
        spTopRight: begin
                      NewTop := StickControl.Top - (Height + StickDistance);
                    end;
      spBottomLeft,
    spBottomCenter,
     spBottomRight: begin
                      NewTop := StickControl.Top + StickControl.Height +
                        StickDistance;
                    end;
  end;

  case StickPosition of
         spTopLeft,
      spBottomLeft: begin
                      NewLeft := StickControl.Left + StickMargin;
                    end;
    spTopCenter,
    spBottomCenter: begin
                      NewLeft := StickControl.Left +
                        (StickControl.Width - Width) div 2;
                    end;
        spTopRight,
     spBottomRight: begin
                      NewLeft := StickControl.Left +
                        (StickControl.Width - Width) - StickMargin;
                    end;
  end;

  case StickPosition of
        spLeftTop,
     spLeftCenter,
     spLeftBottom: begin
                     NewLeft := StickControl.Left - (Width + StickDistance);
                   end;
       spRightTop,
    spRightCenter,
    spRightBottom: begin
                     NewLeft := StickControl.Left + StickControl.Width +
                       StickDistance;
                   end;
  end;

  case StickPosition of
        spLeftTop,
       spRightTop: begin
                     NewTop := StickControl.Top + StickMargin;
                   end;
     spLeftCenter,
    spRightCenter: begin
                     NewTop := StickControl.Top +
                       (StickControl.Height - Height) div 2;
                   end;
     spLeftBottom,
    spRightBottom: begin
                     NewTop := StickControl.Top +
                       (StickControl.Height - Height) - StickMargin;
                   end;
  end;

  FStickUpdating := True;
  SetBounds(NewLeft, NewTop, Width, Height);
  FStickUpdating := False;
end;

procedure TBbStickyLabel.WndProcHook(var Message: TMessage);
begin
  StickUpdate;
end;

end.
