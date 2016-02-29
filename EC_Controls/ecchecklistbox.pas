{**************************************************************************************************
 This file is part of the Eye Candy Controls (EC-C)

  Copyright (C) 2015 Vojtěch Čihák, Czech Republic

  This library is free software; you can redistribute it and/or modify it under the terms of the
  GNU Library General Public License as published by the Free Software Foundation; either version
  2 of the License, or (at your option) any later version with the following modification:

  As a special exception, the copyright holders of this library give you permission to link this
  library with independent modules to produce an executable, regardless of the license terms of
  these independent modules,and to copy and distribute the resulting executable under terms of
  your choice, provided that you also meet, for each linked independent module, the terms and
  conditions of the license of that module. An independent module is a module which is not derived
  from or based on this library. If you modify this library, you may extend this exception to your
  version of the library, but you are not obligated to do so. If you do not wish to do so, delete
  this exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
  the GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public License along with this
  library; if not, write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.

**************************************************************************************************}

unit ECCheckListBox;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, LCLType, StdCtrls, Graphics, LMessages, LResources,
  Themes, ECTypes, types;

type
  TOnItemClickEvent = procedure(Sender: TObject; AColumn, AIndex: Integer) of object;

  { TCustomECCheckListBox }
  TCustomECCheckListBox = class(TCustomListBox)
  private
    FAlignment: TLeftRight;
    FAllowGrayed: Boolean;
    FCheckColumns: SmallInt;
    FGrid: Boolean;
    FHovered: TPoint;
    FIndent: SmallInt;
    FOnItemClick: TOnItemClickEvent;
    FSpacing: SmallInt;
    FStates: array of array of TCheckBoxState;
    function GetChecked(AColumn: Integer; AIndex: Integer): Boolean;
    function GetState(AColumn: Integer; AIndex: Integer): TCheckBoxState;
    procedure SetAlignment(AValue: TLeftRight);
    procedure SetCheckColumns(AValue: SmallInt);
    procedure SetChecked(AColumn: Integer; AIndex: Integer; AValue: Boolean);
    procedure SetGrid(AValue: Boolean);
    procedure SetHovered(AValue: TPoint);
    procedure SetIndent(AValue: SmallInt);
    procedure SetSpacing(AValue: SmallInt);
    procedure SetState(AColumn: Integer; AIndex: Integer; AValue: TCheckBoxState);
  protected const
    cDefCheckColumns = 2;
    cDefIndent = 2;
    cDefSpacing = 9;
  protected
    FBorder: SmallInt;
    FCheckArea: Integer;
    FCheckSize: TSize;
    FItemClickEvent: Boolean;
    FNeedMeasure: Boolean;
    FRightToLeft: Boolean;
    FTextHeight: SmallInt;
    procedure AllocateStates(OldChClmns, NewChClmns, OldRows, NewRows: Integer);
    procedure CMBiDiModeChanged(var Message: TLMessage); message CM_BIDIMODECHANGED;
    procedure DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState); override;
    procedure FontChanged(Sender: TObject); override;
    procedure InitializeWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Loaded; override;
    procedure MouseLeave; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure SetBorderStyle(NewStyle: TBorderStyle); override;
    procedure SetItemHeight(Value: Integer);
    procedure SetItems(Value: TStrings); override;
    procedure WMSize(var {%H-}Message: TLMSize); message LM_SIZE;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure AddItem(const Item: string; AnObject: TObject = nil); reintroduce;
    procedure AssignItems(AItems: TStrings);
    procedure CheckAll(AState: TCheckBoxState; AColumn: Integer);
    procedure Clear; override;
    procedure DeleteItem(AIndex: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure MoveItem(CurIndex, NewIndex: Integer);
    procedure Toggle(AColumn, AIndex: Integer);
    property Alignment: TLeftRight read FAlignment write SetAlignment default taLeftJustify;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property CheckColumns: SmallInt read FCheckColumns write SetCheckColumns default cDefCheckColumns;
    property Checked[AColumn: Integer; AIndex: Integer]: Boolean read GetChecked write SetChecked;
    property Grid: Boolean read FGrid write SetGrid default False;
    property Hovered: TPoint read FHovered write SetHovered;
    property Indent: SmallInt read FIndent write SetIndent default cDefIndent;
    property Spacing: SmallInt read FSpacing write SetSpacing default cDefSpacing;
    property State[AColumn: Integer; AIndex: Integer]: TCheckBoxState read GetState write SetState;
    property OnItemClick: TOnItemClickEvent read FOnItemClick write FOnItemClick;
  end;

  { TECCheckListBox }
  TECCheckListBox = class(TCustomECCheckListBox)
  published
    property Align;
    property Alignment;
    property AllowGrayed;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property Color;
    property CheckColumns;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Grid;
    property Indent;
    property Items;
    property ItemIndex;
    property ParentBidiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Spacing;
    property TabOrder;
    property TabStop;
    property TopIndex;
    property Visible;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDrawItem;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnItemClick;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnShowHint;
    property OnStartDrag;
    property OnUTF8KeyPress;
  end;

procedure Register;

implementation

{ TCustomECCheckListBox }

constructor TCustomECCheckListBox.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FCheckColumns:=cDefCheckColumns;
  FHovered:=Point(-1, -1);
  FIndent:=cDefIndent;
  FSpacing:=cDefSpacing;
  MultiSelect:=False;
  Style:=lbOwnerDrawVariable;  { because of Win32 - it doesn't like lbOwnerDrawFixed }
  FNeedMeasure:=True;
  AccessibleRole:=larListBox;
end;

procedure TCustomECCheckListBox.AddItem(const Item: string; AnObject: TObject);
begin
  inherited AddItem(Item, AnObject);
  AllocateStates(CheckColumns, CheckColumns, Items.Count-1, Items.Count);
end;

procedure TCustomECCheckListBox.AllocateStates(OldChClmns, NewChClmns, OldRows, NewRows: Integer);
var i, j: Integer;
begin
  SetLength(FStates, NewChClmns, NewRows);
  for i:=OldChClmns to NewChClmns-1 do
    for j:=OldRows to NewRows-1 do
      FStates[i, j]:=cbUnchecked;
end;

procedure TCustomECCheckListBox.AssignItems(AItems: TStrings);
begin
  Items.Assign(AItems);
  AllocateStates(0, CheckColumns, 0, AItems.Count);
end;

procedure TCustomECCheckListBox.CheckAll(AState: TCheckBoxState; AColumn: Integer);
var j: Integer;
begin
  for j:=0 to Items.Count-1 do
    FStates[AColumn, j]:=AState;
  Invalidate;
end;

procedure TCustomECCheckListBox.Clear;
begin
  inherited Clear;
  AllocateStates(0, 0, 0, 0);
end;

procedure TCustomECCheckListBox.CMBiDiModeChanged(var Message: TLMessage);
begin
  inherited CMBiDiModeChanged(Message);
  FRightToLeft:=IsRightToLeft;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.DeleteItem(AIndex: Integer);
var i, j, aOldCount: Integer;
begin
  aOldCount:=Items.Count;
  if (AIndex>=0) and (AIndex<aOldCount) then
    begin
      Items.Delete(AIndex);
      for j:=AIndex+1 to aOldCount-1 do
        for i:=0 to CheckColumns-1 do
          FStates[i, j-1]:=FStates[i, j];
      AllocateStates(CheckColumns, aOldCount, CheckColumns, Items.Count);
    end;
end;

procedure TCustomECCheckListBox.ExchangeItems(Index1, Index2: Integer);
var aState: TCheckBoxState;
    i: Integer;
begin
  Items.Exchange(Index1, Index2);
  for i:=0 to CheckColumns-1 do
    begin
      aState:=FStates[i, Index2];
      FStates[i, Index2]:=FStates[i, Index1];
      FStates[i, Index1]:=aState;
    end;
end;

procedure TCustomECCheckListBox.MoveItem(CurIndex, NewIndex: Integer);
var arStates: array of TCheckBoxState;
    i, j: Integer;
begin
  Items.Move(CurIndex, NewIndex);
  SetLength(arStates, CheckColumns);
  for i:=0 to CheckColumns-1 do
    arStates[i]:=FStates[i, CurIndex];
  if CurIndex<NewIndex then
    begin
      for j:=CurIndex to NewIndex-1 do
        for i:=0 to CheckColumns-1 do
          FStates[i, j]:=FStates[i, j+1];
    end else
    begin
      for j:=CurIndex downto NewIndex+1 do
        for i:=0 to CheckColumns-1 do
          FStates[i, j]:=FStates[i, j-1];
    end;
  for i:=0 to CheckColumns-1 do
    FStates[i, NewIndex]:=arStates[i];
end;

procedure TCustomECCheckListBox.DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState);
                              { Enabled, State, Highlighted }
const caCheckThemes: array [Boolean, TCheckBoxState, Boolean] of TThemedButton =
                     { normal, highlighted }
        (((tbCheckBoxUncheckedDisabled, tbCheckBoxUncheckedDisabled),  { disabled, unchecked }
          (tbCheckBoxCheckedDisabled, tbCheckBoxCheckedDisabled),      { disabled, checked }
          (tbCheckBoxMixedDisabled, tbCheckBoxMixedDisabled)),         { disabled, grayed }
         ((tbCheckBoxUncheckedNormal, tbCheckBoxUncheckedHot),         { enabled, unchecked }
          (tbCheckBoxCheckedNormal, tbCheckBoxCheckedHot),             { enabled, checked }
          (tbCheckBoxMixedNormal, tbCheckBoxMixedHot)));               { enabled, grayed }
      cPadding: SmallInt = 2;
var aDetails: TThemedElementDetails;
    bEnabled, bRightToLeft: Boolean;
    aFlags: Cardinal;
    anyRect: TRect;
    aState: TCheckBoxState;
    i, aHovered, aLeft: Integer;
begin  { do not call inherited ! }
  bEnabled:=IsEnabled;
  if (odSelected in State) and bEnabled  then
    begin
      if not Focused then Canvas.Brush.Color:=
        GetMergedColor(Canvas.Brush.Color, GetColorResolvingDefault(Color, Brush.Color), 0.6);
      Canvas.FillRect(ARect);
    end;
  bRightToLeft:= (FRightToLeft xor (Alignment=taRightJustify));
  aLeft:=ARect.Right-Indent-CheckColumns*FCheckSize.cx-(CheckColumns-1)*Spacing-1;
  if FNeedMeasure then
    begin
      if not FRightToLeft then
        begin
          if Alignment=taLeftJustify
            then FCheckArea:=aLeft+FBorder-Spacing div 2
            else FCheckArea:=ClientRect.Right+FBorder-aLeft+Spacing div 2;
        end else
        begin
          if Alignment=taLeftJustify
            then FCheckArea:=ClientRect.Right+(Width-FBorder-ClientWidth)-aLeft+Spacing div 2
            else FCheckArea:=aLeft+(Width-FBorder-ClientWidth)-Spacing div 2;
        end;
      FTextHeight:=Canvas.TextHeight('ŠjÁÇ');
      FNeedMeasure:=False;
    end;
  anyRect.Top:=(ARect.Bottom+ARect.Top-FCheckSize.cy) div 2;
  anyRect.Bottom:=anyRect.Top+FCheckSize.cy;
  if Grid then
    begin
      Canvas.Pen.Color:=clBtnShadow;
      Canvas.Pen.Style:=psDot;
      Canvas.Line(0, ARect.Bottom-1, ARect.Right, ARect.Bottom-1);
      if not bRightToLeft then
        begin
          Canvas.MoveTo(aLeft-Spacing div 2 -1, ARect.Top);
          Canvas.LineTo(Canvas.PenPos.X, ARect.Bottom);
        end;
    end;
  if Index=Hovered.Y
    then aHovered:=Hovered.X
    else aHovered:=-1;
  for i:=0 to CheckColumns-1 do
    begin
      if not (csDesigning in ComponentState)
        then aState:=FStates[i, Index]
        else aState:=cbUnchecked;
      aDetails:=ThemeServices.GetElementDetails(caCheckThemes[bEnabled, aState, aHovered=i]);
      if not bRightToLeft
        then anyRect.Left:=aLeft+i*(FCheckSize.cx+Spacing)
        else anyRect.Left:=ARect.Right-ARect.Left-aLeft-i*Spacing-(i+1)*FCheckSize.cx;
      anyRect.Right:=anyRect.Left+FCheckSize.cx;
      ThemeServices.DrawElement(Canvas.Handle, aDetails, anyRect);
      if Grid and (bRightToLeft or (i<(CheckColumns-1))) then
        begin
          Canvas.MoveTo(anyRect.Left+FCheckSize.cx+Spacing div 2, ARect.Top);
          Canvas.LineTo(Canvas.PenPos.X, ARect.Bottom);
        end;
    end;
  Canvas.Brush.Style:=bsClear;
  if not (odSelected in State)
    then Canvas.Font.Color:=GetColorResolvingDefault(Font.Color, clWindowText)
    else Canvas.Font.Color:=clHighlightText;
  aFlags:=DT_END_ELLIPSIS+DT_VCENTER+DT_SINGLELINE+DT_NOPREFIX;
  if not bRightToLeft then
    begin
      anyRect.Left:=ARect.Left+cPadding;
      anyRect.Right:=ARect.Right;
    end else
    begin
      anyRect.Right:=ARect.Right-cPadding;
      anyRect.Left:=ARect.Left;
      aFlags:=aFlags or DT_RIGHT or DT_RTLREADING;
    end;
  anyRect.Top:=(ARect.Top+ARect.Bottom-FTextHeight) div 2;
  anyRect.Bottom:=anyRect.Top+FTextHeight;
  aDetails:=ThemeServices.GetElementDetails(caCheckThemes[bEnabled, cbUnchecked, False]);
  ThemeServices.DrawText(Canvas, aDetails, Items[Index], anyRect, aFlags, 0);
end;

procedure TCustomECCheckListBox.FontChanged(Sender: TObject);
begin
  FNeedMeasure:=True;
  inherited FontChanged(Sender);
end;

procedure TCustomECCheckListBox.InitializeWnd;
var aDetails: TThemedElementDetails;
begin
  inherited InitializeWnd;
  FBorder:=2;  { should be done better }
  aDetails:=ThemeServices.GetElementDetails(tbCheckBoxCheckedNormal);
  FCheckSize:=ThemeServices.GetDetailSize(aDetails);
  FNeedMeasure:=True;
end;

procedure TCustomECCheckListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (CheckColumns>0) and (ItemIndex>=0) then
    begin
      case Key of
        VK_SPACE: Toggle(0, ItemIndex);
        VK_1..VK_9: if (Key-VK_1)<CheckColumns then
                      begin
                        Toggle(Key-VK_1, ItemIndex);
                        Key:=0;
                      end;
      end;
    end;
end;

procedure TCustomECCheckListBox.Loaded;
begin
  inherited Loaded;
  AllocateStates(0, CheckColumns, 0, Items.Count);
end;

procedure TCustomECCheckListBox.MouseLeave;
begin
  inherited MouseLeave;
  Hovered:=Point(-1, -1);;
end;

procedure TCustomECCheckListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var aRow, aClmnsM1, i, aLimit: Integer;
begin
  inherited MouseMove(Shift, X, Y);
  aRow:=GetIndexAtY(Y);
  if aRow>=0 then
    begin
      aClmnsM1:=CheckColumns-1;
      if aClmnsM1>=0 then
        begin
          i:=-1;
          aLimit:=FCheckArea;
          if not (FRightToLeft xor (Alignment=taRightJustify)) then
            begin
              while (X>=aLimit) and (i<aClmnsM1) do
               begin
                 inc(aLimit, FCheckSize.cx+Spacing);
                 inc(i);
               end;
            end else
            begin
              while (X<aLimit) and (i<aClmnsM1) do
               begin
                 dec(aLimit, FCheckSize.cx+Spacing);
                 inc(i);
               end;
            end;
        end;
    end else
    i:=-1;
  Hovered:=Point(i, aRow);
end;

procedure TCustomECCheckListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button=mbLeft) and (Hovered.X>=0) and (Hovered.Y>=0)
    then Toggle(Hovered.X, Hovered.Y);
end;

procedure TCustomECCheckListBox.SetBorderStyle(NewStyle: TBorderStyle);
begin
  if NewStyle=bsNone  { should be done better }
    then FBorder:=0
    else FBorder:=2;
  inherited SetBorderStyle(NewStyle);
end;

procedure TCustomECCheckListBox.SetItemHeight(Value: Integer);
begin
  inherited SetItemHeight(Value);
  FNeedMeasure:=True;
end;

procedure TCustomECCheckListBox.SetItems(Value: TStrings);
begin
  AllocateStates(0, CheckColumns, 0, Value.Count);
  inherited SetItems(Value);
end;

procedure TCustomECCheckListBox.Toggle(AColumn, AIndex: Integer);
const caNewStateMap: array [TCheckBoxState, Boolean] of TCheckBoxState =
  { False (AllowGrayed) True }
  ((cbChecked, cbGrayed),       { cbUnchecked }
   (cbUnChecked, cbUnChecked),  { cbChecked }
   (cbChecked, cbChecked));     { cbGrayed }
begin
  FItemClickEvent:=True;
  State[AColumn, AIndex]:=caNewStateMap[FStates[AColumn, AIndex], AllowGrayed];
  FItemClickEvent:=False;
end;

procedure TCustomECCheckListBox.WMSize(var Message: TLMSize);
begin
  FNeedMeasure:=True;
end;

{ Setters }

function TCustomECCheckListBox.GetChecked(AColumn: Integer; AIndex: Integer): Boolean;
begin
  Result:= (FStates[AColumn, AIndex]=cbChecked);
end;

function TCustomECCheckListBox.GetState(AColumn: Integer; AIndex: Integer): TCheckBoxState;
begin
  Result:=FStates[AColumn, AIndex];
end;

procedure TCustomECCheckListBox.SetAlignment(AValue: TLeftRight);
begin
  if FAlignment=AValue then exit;
  FAlignment:=AValue;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetChecked(AColumn: Integer; AIndex: Integer; AValue: Boolean);
begin
  if not AValue
    then State[AColumn, AIndex]:=cbUnchecked
    else State[AColumn, AIndex]:=cbChecked;
end;

procedure TCustomECCheckListBox.SetCheckColumns(AValue: SmallInt);
begin
  if FCheckColumns=AValue then exit;
  AllocateStates(CheckColumns, AValue, Items.Count, Items.Count);
  FCheckColumns:=AValue;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetGrid(AValue: Boolean);
begin
  if FGrid=AValue then exit;
  FGrid:=AValue;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetHovered(AValue: TPoint);
begin
  if (FHovered.X<>AValue.X) or (FHovered.Y<>AValue.Y) then
    begin
      FHovered:=AValue;
      Invalidate;
    end;
end;

procedure TCustomECCheckListBox.SetIndent(AValue: SmallInt);
begin
  if FIndent=AValue then exit;
  FIndent:=AValue;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetSpacing(AValue: SmallInt);
begin
  if FSpacing=AValue then exit;
  FSpacing:=AValue;
  FNeedMeasure:=True;
  Invalidate;
end;

procedure TCustomECCheckListBox.SetState(AColumn: Integer; AIndex: Integer; AValue: TCheckBoxState);
begin
  FStates[AColumn, AIndex]:=AValue;
  if FItemClickEvent and assigned(FOnItemClick) then FOnItemClick(self, AColumn, AIndex);
  Invalidate;
end;

procedure Register;
begin
  {$I ecchecklistbox.lrs}
  RegisterComponents('EC-C', [TECCheckListBox]);
end;

end.

