/* FUNCTION CHECKBANKNUM(ST:STRING):BOOLEAN;
VAR
V:INTEGER;
I:INTEGER;
C,SUM: INTEGER;
BEGIN
RESULT:=FALSE;
IF COPY(ST,6,3)<>'810' THEN EXIT;
SUM:=0;
FOR I := 1 TO LENGTH(ST) DO BEGIN
    VAL(ST[I],V,C);
    IF (I<=20) AND (C>0) THEN EXIT;
    IF (I>20) AND (C=0) THEN EXIT;
    IF (I=21) AND (C>0) THEN BREAK;
    CASE I%3 OF
    0: C:=3;
    1: C:=7;
    2: C:=1;
    END;
//    IF I=9 THEN SV[I]:=0 ELSE
    SUM:=SUM+V*C;
END;
RESULT:=5=(SUM*3)%10;
END;
*/

FUNCTION CHECKBANKNUM
PARAMETERS ST2
arrC:={3,7,1}
IF ST2==NIL 
    RETURN .F.
ENDIF
ST2 := ALLTRIM(ST2)
IF SUBSTR(ST2,6,3)<>'810' 
    RETURN .F.
ENDIF
SUM:=0
FOR I = 1 TO LEN(ST2) 
    V := VAL(ST2[I])
    IF (I<=20) .AND. (ST2[I]<>"0") .AND. (V==0)
        //? "1", ST2
        RETURN .F.
    ENDIF
    IF (I>20) .AND. ((V>0) .OR. (ST2[I]="0"))
        //? "2", ST2
        RETURN .F.
    ENDIF
    IF (I==21) .AND. (ST2[I]<>"0") .AND. (V==0)
        //? "3", ST2
        EXIT
    ENDIF
	C:=arrC[(I%3)+1]
    SUM=SUM+V*C
NEXT
//? SUM,""
RETURN 5==(SUM*3)%10