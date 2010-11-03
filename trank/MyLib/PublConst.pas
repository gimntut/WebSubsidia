unit PublConst;

interface

const
{$IFDEF LINUX}
  fmOpenRead = O_RDONLY;
  fmOpenWrite = O_WRONLY;
  fmOpenReadWrite = O_RDWR;
//  fmShareCompat not supported
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
//  fmShareDenyRead  not supported
  fmShareDenyNone = $0030;
{$ENDIF}
{$IFDEF MSWINDOWS}
  fmOpenRead = $0000;
  fmOpenWrite = $0001;
  fmOpenReadWrite = $0002;

  fmShareCompat = $0000 platform; // DOS compatibility mode is not portable
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead = $0030 platform; // write-only not supported on all platforms
  fmShareDenyNone = $0040;
{$ENDIF}


implementation

end.
