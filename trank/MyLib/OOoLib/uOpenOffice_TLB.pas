unit uOpenOffice_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 17244 $
// File generated on 12.06.2010 21:05:28 from Type Library described below.

// ************************************************************************  //
// Type Lib: E:\Works\OpenOffice\uOpenOffice (1)
// LIBID: {480B7B9D-1A0E-4E0B-BA27-4CA8442A82CC}
// LCID: 0
// Helpfile:
// HelpString:
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (stdvcl40.dll)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  uOpenOfficeMajorVersion = 1;
  uOpenOfficeMinorVersion = 0;

  LIBID_uOpenOffice: TGUID = '{480B7B9D-1A0E-4E0B-BA27-4CA8442A82CC}';

  IID_IListener: TGUID = '{4410555C-006B-4C54-ACAE-C50169F51FF7}';
  CLASS_Listener: TGUID = '{63DC371D-6555-44DB-AB0F-6F275980CB10}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IListener = interface;
  IListenerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  Listener = IListener;


// *********************************************************************//
// Interface: IListener
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4410555C-006B-4C54-ACAE-C50169F51FF7}
// *********************************************************************//
  IListener = interface(IDispatch)
    ['{4410555C-006B-4C54-ACAE-C50169F51FF7}']
    procedure disposing(const Source: IDispatch); safecall;
    procedure notifyEvent(const event: IDispatch); safecall;
  end;

// *********************************************************************//
// DispIntf:  IListenerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4410555C-006B-4C54-ACAE-C50169F51FF7}
// *********************************************************************//
  IListenerDisp = dispinterface
    ['{4410555C-006B-4C54-ACAE-C50169F51FF7}']
    procedure disposing(const Source: IDispatch); dispid 201;
    procedure notifyEvent(const event: IDispatch); dispid 202;
  end;

// *********************************************************************//
// The Class CoListener provides a Create and CreateRemote method to
// create instances of the default interface IListener exposed by
// the CoClass Listener. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoListener = class
    class function Create: IListener;
    class function CreateRemote(const MachineName: string): IListener;
  end;

implementation

uses ComObj;

class function CoListener.Create: IListener;
begin
  Result := CreateComObject(CLASS_Listener) as IListener;
end;

class function CoListener.CreateRemote(const MachineName: string): IListener;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Listener) as IListener;
end;

end.

