
-- Create the database master key
USE MASTER
GO

CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'mystrongpassword'
GO

-- Create self signed certificate
USE MASTER
GO

CREATE CERTIFICATE Cert_PaymentInfo
WITH SUBJECT = 'My Security Certificate', 
           EXPIRY_DATE = '2025-12-31'
GO

-- Create a database encryption key (DEK) under particular database for which you want to implement TDE
USE TestEncryptionDB
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE Cert_PaymentInfo;
GO

-- Turn on TDE on that database.
ALTER DATABASE TestEncryptionDB
      SET ENCRYPTION ON;
GO

-- Take the backup of master key
USE MASTER;
GO

BACKUP MASTER KEY 
TO FILE = 'E:\Blog\TDE\MasterKey_PaymentInfo.key'
ENCRYPTION BY PASSWORD = 'mystrongpassword'
GO

BACKUP CERTIFICATE Cert_PaymentInfo
TO FILE = 'E:\Blog\TDE\Cert_PaymentInfo.crt'
WITH PRIVATE KEY
(
        FILE = 'E:\Blog\TDE\Cert_PaymentInfo.pvk',
        ENCRYPTION BY PASSWORD = 'mystrongpassword'
);

-- Let's take the backup of the database
BACKUP DATABASE TestEncryptionDB
TO DISK = 'E:\Blog\TDE\TestEncryptionDB.bak'
GO

--- Now to restore this TDE enabled DB on other instance follow below steps.
-- Create master key

USE MASTER;
GO

CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'MyStrong@Passwor'   -- You can specify different password on other instance.

-- create certificate from existing
CREATE CERTIFICATE Cert_PaymentInfo
FROM FILE = 'E:\Blog\TDE\Cert_PaymentInfo.crt'
WITH PRIVATE KEY
(
         FILE = 'E:\Blog\TDE\Cert_PaymentInfo.pvk',
         DECRYPTION BY PASSWORD = 'mystrongpassword'
)
GO

-- Now go ahead and try to restore the TDE enabled database