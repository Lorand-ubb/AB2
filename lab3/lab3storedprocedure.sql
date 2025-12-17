CREATE PROCEDURE SkinBuy
	@pUserEmail nvarchar(100), @pValidSkinID int, @pTransactionID int
AS
BEGIN

	Set Nocount On

	Select * into #temp From Transactions Where TransactionID = @pTransactionID

	Declare @userbalance int
	Set @userbalance = (Select 1 From Users Where UserEmail = @pUserEmail)
	Declare @transactionvalue int
	Set @transactionvalue = (Select TransactionValue From Transactions Where TransactionID = @pTransactionID)

	If @userbalance < @transactionvalue
	Begin
		return -1
	End

	If (Select TransactionType From #temp) != 'Selling'
	Begin
		return -2
	End

	If (Select TransactionStatus From #temp) != 'Ongoing'
	Begin
		return -3
	End

	If Not Exists (Select 1 From ValidSkins Where ValidSkinID = @pValidSkinID)
	Begin
		return -4
	End

	If Not Exists (Select 1 From Users Where UserEmail = @pUserEmail)
	Begin
		return -5
	End


	Update Transactions
	Set TransactionStatus = 'Succesfull'
	Where TransactionID = @pTransactionID

	Insert into Own
	Values (getDate(), @pUserEmail, @pValidSkinID);

END