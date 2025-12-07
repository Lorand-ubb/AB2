CREATE TABLE Users (
	UserEmail NVARCHAR(50) NOT NULL PRIMARY KEY,
	UserName NVARCHAR(50) NOT NULL UNIQUE,
	UserBalance INT DEFAULT 0,
)

CREATE TABLE Operators (
	OperatorName NVARCHAR(50) PRIMARY KEY,
	OperatorReleaseDate DATE NOT NULL,
	OperatorType NVARCHAR(50) NOT NULL
)

CREATE TABLE Skins (
	SkinName NVARCHAR(50) PRIMARY KEY,
	ReleaseDate DATE NOT NULL,
)

CREATE TABLE Categories (
	CategorieName NVARCHAR(50) PRIMARY KEY,
)

CREATE TABLE Items (
	ItemName NVARCHAR(50) PRIMARY KEY,
	CategorieName NVARCHAR(50) NOT NULL,
	FOREIGN KEY (CategorieName) REFERENCES Categories(CategorieName)
)

CREATE TABLE ValidSkins (
	ValidSkinID INT IDENTITY(1,1) PRIMARY KEY,
	SkinName NVARCHAR(50) NOT NULL,
	ItemName NVARCHAR(50) NOT NULL,
	OperatorName NVARCHAR(50) NOT NULL,
	FOREIGN KEY (SkinName) REFERENCES Skins(SkinName),
	FOREIGN KEY (ItemName) REFERENCES Items(ItemName),
	FOREIGN KEY (OperatorName) REFERENCES Operators(OperatorName),
)

CREATE TABLE Own(
	SkinAcquireDate DATE NOT NULL,
    UserEmail NVARCHAR(50) NOT NULL,
    ValidSkinID INT NOT NULL,
    PRIMARY KEY (UserEmail, ValidSkinID),
    FOREIGN KEY (UserEmail) REFERENCES Users(UserEmail),
    FOREIGN KEY (ValidSkinID) REFERENCES ValidSkins(ValidSkinID)
)

CREATE TABLE Transactions (
	TransactionID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	TransactionValue INT NOT NULL,
	TransactionType NVARCHAR(50) NOT NULL,
	TransactionDate DATE NOT NULL,
	TransactionStatus NVARCHAR(50) NOT NULL,
	UserEmail NVARCHAR(50) NOT NULL,
	ValidSkinID INT NOT NULL,
	FOREIGN KEY (ValidSkinID) REFERENCES ValidSkins(ValidSkinID),
	FOREIGN KEY (UserEmail) REFERENCES Users(UserEmail), --ki csinalja a tranzakciot

)