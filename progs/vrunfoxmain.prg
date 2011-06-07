#INCLUDE		vRunFox.h
LOCAL lcPath, loForm
SET DELETED OFF
SET EXCLUSIVE OFF
SET CLOCK STATUS
SET CENTURY ON
_SCREEN.VISIBLE = .T.

* Make the "public" memvars for quick and dirty commands
PRIVATE a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z
STORE .F. TO a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z

* Private memvars to hold the encryption objects, if needed
PRIVATE poCryptoA, poCryptoB
poCryptoA = .NULL.
poCryptoB = .NULL.

loForm = NEWOBJECT("LoginForm", "classes\loginForm.vcx")
loForm.Show()

IF loForm.cPW # TOP_SECRET
	RETURN
ENDIF

DO FORM vRunFox

IF EMPTY(PROGRAM(2))
	* This is being run standalone	
	READ EVENTS
ENDIF

RETURN


FUNCTION GetCrypto(tcAscBin)
	LOCAL loRetVal
	loRetVal = .NULL.

	DO CASE
		CASE LEFT(UPPER(tcAscBin), 1) == "A"
			* Ascii
			IF ISNULL(poCryptoA)
				poCryptoA = NEWOBJECT("cryptoascii", "crypto.vcx")
			ENDIF
			loRetVal = poCryptoA
		CASE LEFT(UPPER(tcAscBin), 1) == "B"
			* Binary
			IF ISNULL(poCryptoB)
				poCryptoB = NEWOBJECT("cryptobinary", "crypto.vcx")
			ENDIF
			loRetVal = poCryptoB
	ENDCASE

	RETURN loRetVal
ENDFUNC


FUNCTION EncryptA(tcStr)
	LOCAL loCrypt
	loCrypt = GetCrypto("ASC")

	RETURN loCrypt.Encrypt(tcStr)
ENDFUNC


FUNCTION EncryptB(tcStr)
	LOCAL loCrypt
	loCrypt = GetCrypto("BIN")

	RETURN loCrypt.Encrypt(tcStr)
ENDFUNC


FUNCTION DecryptA(tcStr)
	LOCAL loCrypt
	loCrypt = GetCrypto("ASC")

	RETURN loCrypt.Decrypt(tcStr)
ENDFUNC


FUNCTION DecryptB(tcStr)
	LOCAL loCrypt
	loCrypt = GetCrypto("BIN")

	RETURN loCrypt.Decrypt(tcStr)
ENDFUNC


