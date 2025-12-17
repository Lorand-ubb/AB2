Create Trigger trigger_updateUserBalance
On Own
After Insert
AS
Begin
	Set Nocount On

	If Not Exists (Select 1 From Users, inserted Where Users.UserEmail = inserted.UserEmail)
	Begin
		Rollback
	End

	If Not Exists (Select 1 From ValidSkins, inserted Where ValidSkins.ValidSkinID = inserted.ValidSkinID)
	Begin
		Rollback
	End


	Update Users
	Set UserBalance = (Select TransactionValue From Transactions t Join inserted i On t.UserEmail = i.UserEmail)
End