#DEFINE OBJECT_CAPTION "(Object) - "
LPARAMETERS taArray, tlKeepOpen
EXTERNAL ARRAY taArray
ASSERT VARTYPE(taArray[1]) # "U" MESSAGE "You must pass an array to this method"
LOCAL lnSelect, lcCursor, lnRows, lnCols, lnCnt, lcCreate, lcWidth, lnRowCnt, lcInsert, lcColList, lcVal
LOCAL lnMaxWidth, laCopy[1]
lnSelect = SELECT(0)
SELECT 0

DIMENSION laCopy[ALEN(taArray, 1), MAX(1, ALEN(taArray, 2))]
ACOPY(taArray, laCopy)

lcCursor = "crs" + RIGHT(SYS(2015), 7)
lnRows = ALEN(laCopy, 1)
lnCols = MAX(1, ALEN(laCopy, 2))
* Add the row # column
lcCreate = "CREATE CURSOR " + lcCursor + " (RowNum N(4,0), "
lcColList = "RowNum, "
FOR lnCnt = 1 TO lnCols
	lnMaxWidth = 1
	FOR lnRowCnt = 1 TO lnRows
		IF VARTYPE(laCopy[lnRowCnt, lnCnt]) = "O"
			lnWidth = LEN(OBJECT_CAPTION + laCopy[lnRowCnt, lnCnt].Name)
		ELSE
			lnWidth = LEN(TRANS(laCopy[lnRowCnt, lnCnt]))
		ENDIF
		lnMaxWidth = MAX(lnWidth, lnMaxWidth)
	ENDFOR
	lcWidth = TRANS(lnMaxWidth)
	lcCol = "Col" + TRANS(lnCnt)
	lcCreate = lcCreate + lcCol + " C(" + lcWidth + ")" + IIF(lnCnt = lnCols, "", ", ")
	lcColList = lcColList + lcCol + IIF(lnCnt = lnCols, "", ", ")
ENDFOR
lcCreate = lcCreate + " )" 
&lcCreate
FOR lnRowCnt = 1 TO lnRows
	lcInsert = "INSERT INTO " + lcCursor + " (" + lcColList + " ) VALUES (" + TRANSFORM(lnRowCnt) + ", "
	FOR lnCnt = 1 TO lnCols
		IF VARTYPE(laCopy[lnRowCnt, lnCnt]) = "O"
			lcVal = "[" + OBJECT_CAPTION + laCopy[lnRowCnt, lnCnt].Name + "]"
*			lcVal = "[" + OBJECT_CAPTION + "]"
		ELSE
			lcVal = "[" + TRANS(laCopy[lnRowCnt, lnCnt]) + "]"
		ENDIF
		lcInsert = lcInsert + lcVal + IIF(lnCnt = lnCols, "", ", ")
	ENDFOR
	lcInsert = lcInsert + ")" 
	
	&lcInsert
ENDFOR
IF USED(lcCursor)
	PUSH KEY CLEAR
	ON KEY LABEL F9 COPY TO BRARRAY
	LOCATE
	IF tlKeepOpen
		BROWSE NORMAL NOWAIT
	ELSE
		BROWSE NORMAL
		USE IN (lcCursor)
	ENDIF
	POP KEY
ENDIF
SELECT (lnSelect)
RETURN

