{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit eccontrols;

interface

uses
  ECTypes, ECScale, ECBevel, ECLink, ECImageMenu, ECSpinCtrls, ECSwitch, ECEditBtns, ECHeader, ECCheckListBox, 
  ECSlider, ECProgressBar, ECRuler, ECGroupCtrls, ECTabCtrl, ECConfCurve, ECScheme, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ECBevel', @ECBevel.Register);
  RegisterUnit('ECLink', @ECLink.Register);
  RegisterUnit('ECImageMenu', @ECImageMenu.Register);
  RegisterUnit('ECSpinCtrls', @ECSpinCtrls.Register);
  RegisterUnit('ECSwitch', @ECSwitch.Register);
  RegisterUnit('ECEditBtns', @ECEditBtns.Register);
  RegisterUnit('ECHeader', @ECHeader.Register);
  RegisterUnit('ECCheckListBox', @ECCheckListBox.Register);
  RegisterUnit('ECSlider', @ECSlider.Register);
  RegisterUnit('ECProgressBar', @ECProgressBar.Register);
  RegisterUnit('ECRuler', @ECRuler.Register);
  RegisterUnit('ECGroupCtrls', @ECGroupCtrls.Register);
  RegisterUnit('ECTabCtrl', @ECTabCtrl.Register);
  RegisterUnit('ECConfCurve', @ECConfCurve.Register);
  RegisterUnit('ECScheme', @ECScheme.Register);
end;

initialization
  RegisterPackage('eccontrols', @Register);
end.
