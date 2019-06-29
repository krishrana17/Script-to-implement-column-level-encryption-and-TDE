CREATE TABLE [dbo].[PaymentMaster]
(
[PaymentId] [int] NOT NULL IDENTITY(1, 1),
[OrderId] [int] NULL,
[OrderAmount] [money] NULL,
[PaymentMethod] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Credit_DebitCardNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
