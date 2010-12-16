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

S5:=LEFT(ST2,5)
US := .F.
US := US .OR. (S5=='42307')
US := US .OR. (S5=='42306')
US := US .OR. (S5=='42301')
US := US .OR. (S5=='40817')
IF .NOT. US
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