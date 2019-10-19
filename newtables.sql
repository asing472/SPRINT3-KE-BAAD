---CREATED BY AKASH KUMAR SINGH
---MODULE ACCOUNTS
---CREATED ON 

use [13th Aug CLoud PT Immersive]
GO



---CREATED TABLE REGULAR ACCOUNT
CREATE TABLE TeamE.RegularAccount
(AccountID uniqueidentifier constraint PK_RegularAccount_AccountID primary key,
	CustomerID uniqueidentifier NOT NULL constraint FK_RegularAccount_CustomerID foreign key references TeamE.Customer(CustomerID),
	AccountNo char(10) NOT NULL UNIQUE check(len(AccountNo) = 10),
	CurrentBalance money NOT NULL default 0 check(CurrentBalance >= 0),
	AccountType varchar(10) NOT NULL check(AccountType = 'Savings' OR AccountType = 'Current'),
	Branch varchar(30) NOT NULL check(Branch = 'Delhi' OR Branch = 'Mumbai'OR Branch = 'Chennai'OR Branch = 'Bengaluru' ),
	Status char(10) NOT NULL default 'Active' check(Status ='Active' OR Status = 'Closed'),
	MinimumBalance money NOT NULL default 500 check(MinimumBalance >= 0),
	InterestRate decimal NOT NULL default 3.5 check(InterestRate >= 0),
	CreationDateTime datetime NOT NULL default SysDateTime(),
	LastModifiedDateTime datetime NOT NULL default SysDateTime())

GO



---CREATED TABLE FIXED ACCOUNT
CREATE TABLE TeamE.FixedAccount
(AccountID uniqueidentifier constraint PK_FixedAccount_AccountID primary key,
	CustomerID uniqueidentifier NOT NULL constraint FK_FixedAccount_CustomerID foreign key references TeamE.Customer(CustomerID),
	AccountNo char(10) NOT NULL UNIQUE check(len(AccountNo) = 10),
	CurrentBalance money default 0 check(CurrentBalance >= 0) ,
	AccountType varchar(10) NOT NULL check(AccountType = 'Fixed'),
	Branch varchar(30) NOT NULL check(Branch = 'Delhi' OR Branch = 'Mumbai'OR Branch = 'Chennai'OR Branch = 'Bengaluru' ),
	Tenure decimal NOT NULL check(tenure > 0),
	FDDeposit money NOT NULL check(FDDeposit > 0),
	Status char(10) NOT NULL default 'Active' check(Status ='Active' OR Status = 'Closed'),
	MinimumBalance money NOT NULL default 500 check(MinimumBalance >= 0),
	InterestRate decimal NOT NULL default 3.5 check(InterestRate >= 0),
	CreationDateTime datetime NOT NULL default SysDateTime(),
	LastModifiedDateTime datetime NOT NULL default SysDateTime())
GO

---CREATED PROCEDURE FOR ADDING ITEMS IN REGULAR ACCOUNT TABLE

alter procedure TeamE.CreateRegularAccount
(@CustomerID uniqueidentifier,@AccountType varchar(10),@Branch varchar(30),@MinimumBalance money,@InterestRate decimal)
as
begin

		---THROWING EXCEPTION IF CUSTOMER ID IS NULL
		if @CustomerID IS null
			throw 50001,'Invalid Customer ID',1
		
		---GENERATING ACCOUNT ID
		declare @AccountID uniqueidentifier
			set @AccountID = NEWID()
		
		---GENERATING ACCOUNT NO
		declare @acount int,@AccountNo char(10)
			set @acount = (select count(*) from TeamE.RegularAccount)
			set @AccountNo = (SELECT CONVERT(char(10),(1000000001 + @acount)))

		---THROWING EXCEPTION IF ACCOUNT TYPE IS NOT SAVINGS OR CURRENT
		if @AccountType NOT IN('Savings','Current')
			throw 50001,'Invalid Account Type',6

		---THROWING EXCEPTION IF HOME BRANCH IS INVALID OR NULL
		if @Branch NOT IN('Mumbai','Delhi','Chennai','Bengaluru')
			throw 50001,'Invalid Branch',7

			INSERT INTO TeamE.RegularAccount(AccountID, CustomerID, AccountNo,
	AccountType ,Branch,MinimumBalance,InterestRate)VALUES(@AccountID, @CustomerID, @AccountNo,
	@AccountType ,@Branch,@MinimumBalance,@InterestRate)

	SELECT @@ROWCOUNT as Column1,@AccountNo as Column2
end

GO


---CREATED PROCEDURE FOR ADDING ITEMS IN FIXED ACCOUNT TABLE
create procedure TeamE.CreateFixedAccount
(@CustomerID uniqueidentifier,@Branch varchar(30),@Tenure decimal,@FDDeposit money,@MinimumBalance money,@InterestRate decimal)
as
begin

		---THROWING EXCEPTION IF CUSTOMER ID IS NULL
		if @CustomerID IS null
			throw 50001,'Invalid Customer ID',1

		---GENERATING ACCOUNT ID
		declare @AccountID uniqueidentifier
			set @AccountID = NEWID()
		
		---GENERATING ACCOUNT NO
		declare @acount int,@AccountNo char(10)
			set @acount = (select count(*) from TeamE.FixedAccount)
			set @AccountNo = (SELECT CONVERT(char(10),(2000000001 + @acount)))

		---THROWING EXCEPTION IF HOME BRANCH IS INVALID OR NULL
		if @Branch NOT IN('Mumbai','Delhi','Chennai','Bengaluru')
			throw 50001,'Invalid Branch',7

		---THROWING EXCEPTION IF TENURE IS INVALID 
		if @Tenure <= 0 
			throw 50001, 'Invalid Tenure',5

		---THROWING EXCEPTION IF FDDEPOSIT AMOUNT IS INVALID 
		if @FDDeposit <= 0 
			throw 50001, 'Invalid FDDeposit Amount',5

			INSERT INTO TeamE.FixedAccount(AccountID, CustomerID, AccountNo,Branch,Tenure,FDDeposit,MinimumBalance,InterestRate)VALUES(@AccountID, @CustomerID, @AccountNo,
	@Branch,@Tenure,@FDDeposit,@MinimumBalance,@InterestRate)

	SELECT @@ROWCOUNT,@AccountNo
end


GO


---INSERTING VALUES INTO REGULARACCOUNT TABLE

--declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date,@accountno char(10),@acount int
--set @cid = (select top 1 CustomerID from TeamE.Customer)
--set @aid = NEWID()
--set @acount = (select count(*) from TeamE.RegularAccount)
--set @accountno = (SELECT CONVERT(char(10),(1000000001 + @acount)))
--EXEC CreateRegularAccount @aid,@cid,@accountno,0,'Savings','Mumbai',500,3.5

--select * from TeamE.RegularAccount

--GO

--declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date,@accountno char(10),@acount int
--set @cid = (select CustomerID from TeamE.Customer where CustomerNumber = '100003')
--set @aid = NEWID()
--set @acount = (select count(*) from TeamE.RegularAccount)
--set @accountno = (SELECT CONVERT(char(10),(1000000001 + @acount)))
--EXEC CreateRegularAccount @aid,@cid,@accountno,0,'Current','Delhi',500,3.5

--select * from TeamE.RegularAccount

--GO

select * from TeamE.Customer


------CREATED PROCEDURE FOR DELETING ITEMS FROM REGULAR ACCOUNT TABLE

alter procedure TeamE.DeleteRegularAccount(@AccountNo char(10))

as 
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1

		---SETTING THE VALUE OF STATUS FROM "ACTIVE" TO "CLOSED"
		update TeamE.RegularAccount
		set Status = 'Closed' where AccountNo = @AccountNo;

		update TeamE.RegularAccount
		set LastModifiedDateTime = SYSDATETIME() where AccountNo = @AccountNo;

end

GO


---DELETING VALUES FROM REGULARACCOUNT TABLE

declare @accountno char(10)
set @accountno = '1000000001'

EXEC TeamE.DeleteRegularAccount @accountno

GO

select * from TeamE.RegularAccount

GO


---INSERTING VALUES INTO FIXEDACCOUNT TABLE

--declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date,@accountno char(10),@acount int,@tenure decimal,@fddeposit money
--set @cid = (select top 1 CustomerID from TeamE.Customer)
--set @aid = NEWID()
--set @acount = (select count(*) from TeamE.FixedAccount)
--set @accountno = (SELECT CONVERT(char(10),(2000000001 + @acount)))
--set @tenure = 12
--set @fddeposit = 500000
--EXEC CreateFixedAccount @aid,@cid,@accountno,0,'Fixed','Mumbai',500,3.5,@tenure,@fddeposit

--select * from TeamE.FixedAccount

--GO


--declare @cid uniqueidentifier,@aid uniqueidentifier,@crdate date,@modate date,@accountno char(10),@acount int,@tenure decimal,@fddeposit money
--set @cid = (select CustomerID from TeamE.Customer where CustomerNumber = '100004')
--set @aid = NEWID()
--set @acount = (select count(*) from TeamE.FixedAccount)
--set @accountno = (SELECT CONVERT(char(10),(2000000001 + @acount)))
--set @tenure = 10
--set @fddeposit = 300000
--EXEC CreateFixedAccount @aid,@cid,@accountno,0,'Fixed','Bengaluru',500,3.5,@tenure,@fddeposit

--select * from TeamE.FixedAccount

--GO

------CREATED PROCEDURE FOR DELETING ITEMS FROM FIXED ACCOUNT TABLE

alter procedure TeamE.DeleteFixedAccount(@AccountNo char(10))

as 
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.FixedAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '2%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1

		---SETTING THE VALUE OF STATUS FROM "ACTIVE" TO "CLOSED"
		update TeamE.FixedAccount
		set Status = 'Closed' where AccountNo = @AccountNo;

		update TeamE.FixedAccount
		set LastModifiedDateTime = SYSDATETIME() where AccountNo = @AccountNo;

end

GO

declare @accountno char(10)
set @accountno = '2000000001'

EXEC DeleteFixedAccount @accountno

GO

---CREATING A VIEW TO GET ACTIVE REGULAR ACCOUNTS BY ACCOUNT NO

create view [GetAccountByAccountNo]
as
SELECT * from TeamE.RegularAccount WHERE Status = 'Active'

GO

---CREATED PROCEDURE FOR CHANGING HOME BRANCH OF REGULAR ACCOUNT

alter procedure TeamE.ChangeRegularAccountBranch(@AccountNo char(10),@Branch varchar(30))

as 
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1


		---THROWING EXCEPTION IF THE HOME BRANCH ENTERED IS NOT VALID
		if @Branch NOT IN ('Mumbai','Delhi','Chennai','Bengaluru')
			throw 50001,'Home branch entered is invalid',1

		---CHANGING THE HOME BRANCH IF ACCOUNT NO MATCHES
		update TeamE.RegularAccount
		set Branch = @Branch where ((AccountNo = @AccountNo)AND(Branch IN ('Mumbai','Delhi','Chennai','Bengaluru')))

		update TeamE.RegularAccount
		set LastModifiedDateTime = SYSDATETIME() where AccountNo = @AccountNo;

end

GO

declare @accountno char(10), @branch varchar(30)
set @accountno = '1000000002'
set @branch = 'Shimla'

EXEC ChangeRegularAccountBranch @accountno,@branch

GO

---CREATED PROCEDURE FOR CHANGING HOME BRANCH OF FIXED ACCOUNT

alter procedure TeamE.ChangeFixedAccountBranch(@AccountNo char(10),@Branch varchar(30))

as 
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.FixedAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '2%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1


		---THROWING EXCEPTION IF THE HOME BRANCH ENTERED IS NOT VALID
		if @Branch NOT IN ('Mumbai','Delhi','Chennai','Bengaluru')
			throw 50001,'Home branch entered is invalid',1

		---CHANGING THE HOME BRANCH IF ACCOUNT NO MATCHES
		update TeamE.FixedAccount
		set Branch = @Branch where ((AccountNo = @AccountNo)AND(Branch IN ('Mumbai','Delhi','Chennai','Bengaluru')))

		update TeamE.FixedAccount
		set LastModifiedDateTime = SYSDATETIME() where AccountNo = @AccountNo;

end

GO

declare @accountno char(10), @branch varchar(30)
set @accountno = '2000000005'
set @branch = 'Bengaluru'

EXEC TeamE.ChangeFixedAccountBranch @accountno,@branch

GO


---CREATED PROCEDURE FOR CHANGING THE ACCOUNT TYPE OF REGULAR ACCOUNTS

alter procedure TeamE.ChangeRegularAccountType(@AccountNo char(10),@AccountType varchar(10))

as 
begin
		
		---THROWING EXCEPTION IF THE ACCOUNT NO ENTERED BELONGS TO FIXED ACCOUNT TABLE
		if EXISTS(SELECT * from TeamE.FixedAccount WHERE AccountNo = @AccountNo) 
			throw 50001,'Fixed accounts cannot be modified into other account types',1

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1


		---THROWING EXCEPTION IF THE ACCOUNT TYPE ENTERED IS NOT VALID
		if @AccountType NOT IN ('SAVINGS','CURRENT')
			throw 50001,'Account Type entered is invalid',1

		---CHANGING THE ACCOUNT TYPE IF ACCOUNT NO MATCHES
		update TeamE.RegularAccount
		set AccountType = @AccountType where ((AccountNo = @AccountNo)AND(AccountType IN ('Savings','Current')))


		update TeamE.RegularAccount
		set LastModifiedDateTime = SYSDATETIME() where AccountNo = @AccountNo;

end

GO


declare @accountno char(10), @acctype varchar(10)
set @accountno = '1000000002'
set @acctype = 'Savings'

EXEC TeamE.ChangeRegularAccountType @accountno,@acctype

GO

declare @accountno char(10), @acctype varchar(10)
set @accountno = '2000000001'
set @acctype = 'Savings'

EXEC TeamE.ChangeRegularAccountType @accountno,@acctype

GO


---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNT BY ACCOUNT NO

alter procedure TeamE.GetRegularAccountByAccountNo(@AccountNo char(10))
as
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.RegularAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '1%')
			throw 50001,'Account does not exists',1

		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1

		
		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a, TeamE.Customer c WHERE (AccountNo = @AccountNo) 
		AND (c.CustomerID = a.CustomerID )

end

EXEC GetRegularAccountByAccountNo '1000000002'


---CREATED PROCEDURE FOR LISTING FIXED ACCOUNT BY ACCOUNT NO

alter procedure TeamE.GetFixedAccountByAccountNo(@AccountNo char(10)) 
as
begin

		
		---THROWING EXCEPTION IF THE ACCOUNT DOESN'T EXISTS
		if NOT EXISTS(SELECT * from TeamE.FixedAccount WHERE AccountNo = @AccountNo) AND (len(@AccountNo) = 10) AND (@AccountNo LIKE '2%')
			throw 50001,'Account does not exists',1


		---THROWING EXCEPTION IF ACCOUNT No IS NULL OR INVALID
		if @AccountNo is null OR (len(@AccountNo) <> 10) 
			throw 50001,'Invalid Account No',1



		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.FixedAccount a, TeamE.Customer c WHERE (AccountNo = @AccountNo) 
		AND (c.CustomerID = a.CustomerID )

end


GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY CUSTOMER ID

alter procedure TeamE.GetRegularAccountsByCustomerID(@CustomerID uniqueIdentifier)
as
begin
		
		---THROWING EXCEPTION IF THE CUSTOMER ID ENTERED IS NOT VALID
	    if @CustomerID NOT IN (SELECT CustomerID from TeamE.Customer where CustomerID = @CustomerID)
					throw 50001,'Customer does not exists',1


		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a INNER JOIN TeamE.Customer c ON ((c.CustomerID = a.CustomerID)AND(@CustomerID = a.CustomerID ))

end


GO

---CREATED PROCEDURE FOR LISTING FIXED ACCOUNTS BY CUSTOMER ID

alter procedure TeamE.GetFixedAccountsByCustomerID(@CustomerID uniqueIdentifier)
as
begin

		---THROWING EXCEPTION IF THE CUSTOMER ID ENTERED IS NOT VALID
	    if @CustomerID NOT IN (SELECT CustomerID from TeamE.Customer where CustomerID = @CustomerID)
					throw 50001,'Customer does not exists',1


		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.FixedAccount a INNER JOIN TeamE.Customer c ON ((c.CustomerID = a.CustomerID)AND(@CustomerID = a.CustomerID ))
end

GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY ACCOUNT TYPE

alter procedure TeamE.GetRegularAccountsByAccountType(@AccountType varchar(10))
as
begin

		---THROWING EXCEPTION IF THE ACCOUNT TYPE ENTERED IS NOT VALID
				if @AccountType NOT IN ('SAVINGS','CURRENT')
					throw 50001,'Account Type entered is invalid',1

		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a, TeamE.Customer c WHERE (AccountType = @AccountType) 
		AND (c.CustomerID = a.CustomerID )

end

GO


---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNTS BY ACCOUNT OPENING DATE

Create procedure TeamE.GetRegularAccountsByAccountOpeningDate(@StartDate datetime,@EndDate datetime)
as
begin
		
		---THROWING EXCEPTION IF END DATE IS LATER THAN TODAY
		if (@EndDate > = GETDATE())
			throw 50001,'End date cannot be later than today',1

		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a, TeamE.Customer c WHERE ((a.CreationDateTime >= @StartDate) 
		AND (a.CreationDateTime <= @EndDate))

end

GO


---CREATED PROCEDURE FOR LISTING FIXED ACCOUNTS BY ACCOUNT OPENING DATE

Create procedure TeamE.GetFixedAccountsByAccountOpeningDate(@StartDate datetime,@EndDate datetime)
as
begin
		
		---THROWING EXCEPTION IF END DATE IS LATER THAN TODAY
		if (@EndDate > = GETDATE())
			throw 50001,'End date cannot be later than today',1

		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.FixedAccount a, TeamE.Customer c WHERE ((a.CreationDateTime >= @StartDate) 
		AND (a.CreationDateTime <= @EndDate))

end

GO

---CREATED PROCEDURE FOR LISTING REGULAR ACCOUNT BY BRANCH

create procedure TeamE.GetRegularAccountsByBranch(@Branch varchar(30))
as
begin

		
		
		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a, TeamE.Customer c WHERE (Branch = @Branch) 
		AND (c.CustomerID = a.CustomerID )

end

GO


---CREATED PROCEDURE FOR LISTING FIXED ACCOUNT BY BRANCH

create procedure TeamE.GetFixedAccountsByBranch(@Branch varchar(10)) 
as
begin


		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.FixedAccount a, TeamE.Customer c WHERE (Branch = @Branch) 
		

end


GO


---CREATED PROCEDURE FOR LISTING ALL REGULAR ACCOUNTS 

alter procedure TeamE.GetAllRegularAccounts
as
begin

		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.RegularAccount a, TeamE.Customer c WHERE (c.CustomerID = a.CustomerID) 
	
end

GO

 

---CREATED PROCEDURE FOR LISTING ALL FIXED ACCOUNTS 

alter procedure TeamE.GetAllFixedAccounts
as
begin

		SELECT c.CustomerName,c.CustomerNumber,a.* from TeamE.FixedAccount a, TeamE.Customer c WHERE (c.CustomerID = a.CustomerID) 

end

GO


EXEC TeamE.GetAllRegularAccounts

select * from TeamE.Customer


EXEC GetRegularAccountByAccountNo '1000000002'


EXEC TeamE.GetRegularAccountsByCustomerID '290184BE-68B1-4F27-A362-08CF50849B9B'

EXEC TeamE.GetRegularAccountsByAccountType 'Current'

EXEC TeamE.GetRegularAccountsByCustomerNo '100005'