USE TestEncryptionDB
GO

-- Create required symmetric key
CREATE SYMMETRIC KEY Key_PaymentInfo
WITH ALGORITHM = AES_128
ENCRYPTION BY PASSWORD = 'mystrongpassword'
GO

-- Perform encryption on sample text using ENCRYPTBYKEY function
OPEN SYMMETRIC KEY Key_PaymentInfo
DECRYPTION BY PASSWORD = 'mystrongpassword'
GO

SELECT ENCRYPTBYKEY(KEY_GUID('Key_PaymentInfo'), 'krishnraj');
 
CLOSE SYMMETRIC KEY Key_PaymentInfo
GO

-- Add new column in the table to store encrypted data
ALTER TABLE dbo.PaymentMaster
ADD EncryptCreditOrDebitNo VARBINARY(256),
	EncryptBankName VARBINARY(256)
GO

-- Perform encryption on table by updating existing data
OPEN SYMMETRIC KEY Key_PaymentInfo
DECRYPTION BY PASSWORD = 'mystrongpassword'
GO

UPDATE PaymentMaster
SET
	EncryptCreditOrDebitNo = ENCRYPTBYKEY(KEY_GUID('Key_PaymentInfo'), Credit_DebitCardNo),
	EncryptBankName = ENCRYPTBYKEY(KEY_GUID('Key_PaymentInfo'), BankName)

CLOSE SYMMETRIC KEY Key_PaymentInfo
GO

-- You can read the decrypted value as following
OPEN SYMMETRIC KEY Key_PaymentInfo
DECRYPTION BY PASSWORD = 'mystrongpassword'
GO

SELECT 
	CONVERT(VARCHAR(100), DECRYPTBYKEY(EncryptCreditOrDebitNo)) AS CardNo,
	CONVERT(VARCHAR(100), DECRYPTBYKEY(EncryptBankName))
FROM dbo.PaymentMaster

CLOSE SYMMETRIC KEY key_paymentinfo
GO

-- You can grant or remove permission of viewing decrypted data
-- First we will remove the permission
REVOKE VIEW DEFINITION ON SYMMETRIC KEY:: key_paymentinfo TO krish;
-- same way you can grant the permission to view the decrypted data.
GRANT VIEW DEFINITION ON SYMMETRIC KEY:: key_paymentinfo TO krish; 