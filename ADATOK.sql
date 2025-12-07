-- ========================
-- USERS
-- ========================
INSERT INTO Users (UserEmail, UserName, UserBalance) VALUES
('ash.player@gmail.com', 'AshHunter', 5200),
('sledge.main@gmail.com', 'SledgeMan', 3400),
('thermite.pro@gmail.com', 'ThermGod', 8900),
('rook.def@gmail.com', 'RookShield', 2500),
('twitch.gg@gmail.com', 'Twitchie', 7600),
('finka.boost@gmail.com', 'FinkaBoosted', 4100),
('pulse.scan@gmail.com', 'PulseWave', 6300),
('hibana.fire@gmail.com', 'HibanaBoom', 7200),
('mute.def@gmail.com', 'MuteSilencer', 3800),
('smoke.trap@gmail.com', 'SmokeToxic', 4600),
('ace.entry@gmail.com', 'AceBreaker', 8400),
('iq.smart@gmail.com', 'IQScanner', 5900),
('caveira.hunt@gmail.com', 'CaveiraPred', 2700),
('doc.heal@gmail.com', 'DocMedic', 5100),
('jackal.track@gmail.com', 'JackalEyes', 6700);

-- ========================
-- OPERATORS
-- ========================
INSERT INTO Operators (OperatorName, OperatorReleaseDate, OperatorType) VALUES
('Jager', '2015-12-01', 'Defender'),
('Maestro', '2018-06-07', 'Defender'),
('Kali', '2019-12-03', 'Attacker'),
('Ash', '2015-12-01', 'Attacker'),
('Sledge', '2015-12-01', 'Attacker'),
('Thermite', '2015-12-01', 'Attacker'),
('Rook', '2015-12-01', 'Defender'),
('Twitch', '2015-12-01', 'Attacker'),
('Finka', '2018-03-06', 'Attacker'),
('Pulse', '2015-12-01', 'Defender'),
('Hibana', '2016-11-17', 'Attacker'),
('Mute', '2015-12-01', 'Defender'),
('Smoke', '2015-12-01', 'Defender'),
('Ace', '2020-06-16', 'Attacker'),
('IQ', '2015-12-01', 'Attacker'),
('Caveira', '2016-08-02', 'Defender'),
('Doc', '2015-12-01', 'Defender'),
('Jackal', '2017-02-07', 'Attacker');

-- ========================
-- SKINS
-- ========================
INSERT INTO Skins (SkinName, ReleaseDate) VALUES
('Black Ice', '2016-02-01'),
('Crimson Heist', '2021-03-16'),
('Neon Dawn', '2020-12-01'),
('Steel Wave', '2020-06-16'),
('Void Edge', '2020-03-10'),
('Shifting Tides', '2019-12-03'),
('Ember Rise', '2019-09-10'),
('Phantom Sight', '2019-06-11'),
('Burnt Horizon', '2019-03-06'),
('Wind Bastion', '2018-12-04'),
('Grim Sky', '2018-09-04'),
('Para Bellum', '2018-06-07'),
('Chimera', '2018-03-06'),
('White Noise', '2017-12-05'),
('Blood Orchid', '2017-09-05'),
('Velvet Shell', '2017-02-07');

-- ========================
-- CATEGORIES
-- ========================
INSERT INTO Categories (CategorieName) VALUES
('Weapon'),
('Headgear'),
('Uniform'),
('Charm'),
('Card Background'),
('Weapon Attachment'),
('Gadget'),
('Operator Card');

-- ========================
-- ITEMS
-- ========================
INSERT INTO Items (ItemName, CategorieName) VALUES
('R4-C', 'Weapon'),
('416-C CARBINE', 'Weapon'),
('CSRX 300', 'Weapon'),
('ALDA 5.56', 'Weapon'),
('Sledge Hammer', 'Weapon'),
('Thermite Rifle Camo', 'Weapon'),
('Rook Uniform', 'Uniform'),
('Twitch Headgear', 'Headgear'),
('Finka Uniform', 'Uniform'),
('Pulse Charm', 'Charm'),
('Mute SMG Camo', 'Weapon'),
('Smoke Gas Charm', 'Charm'),
('IQ Headgear', 'Headgear'),
('Caveira Uniform', 'Uniform'),
('Jackal Rifle', 'Weapon');

-- ========================
-- VALID SKINS
-- ========================
INSERT INTO ValidSkins (SkinName, ItemName, OperatorName) VALUES
('Black Ice', 'R4-C', 'Ash'),
('Black Ice', '416-C CARBINE', 'Jager'),
('Black Ice', 'CSRX 300', 'Kali'),
('Black Ice', 'ALDA 5.56', 'Maestro'),
('Neon Dawn', 'Sledge Hammer', 'Sledge'),
('Steel Wave', 'Thermite Rifle Camo', 'Thermite'),
('Void Edge', 'Rook Uniform', 'Rook'),
('Shifting Tides', 'Twitch Headgear', 'Twitch'),
('Ember Rise', 'Finka Uniform', 'Finka'),
('Phantom Sight', 'Pulse Charm', 'Pulse'),
('Wind Bastion', 'Mute SMG Camo', 'Mute'),
('Grim Sky', 'Smoke Gas Charm', 'Smoke'),
('Chimera', 'IQ Headgear', 'IQ'),
('White Noise', 'Caveira Uniform', 'Caveira'),
('Velvet Shell', 'Jackal Rifle', 'Jackal');

-- ========================
-- OWN
-- ========================
INSERT INTO Own (SkinAcquireDate, UserEmail, ValidSkinID) VALUES
('2021-04-02', 'ash.player@gmail.com', 1),
('2020-12-10', 'sledge.main@gmail.com', 2),
('2020-07-01', 'thermite.pro@gmail.com', 3),
('2021-01-10', 'rook.def@gmail.com', 4),
('2022-05-05', 'twitch.gg@gmail.com', 5),
('2020-09-18', 'finka.boost@gmail.com', 6),
('2021-02-22', 'pulse.scan@gmail.com', 7),
('2019-06-19', 'hibana.fire@gmail.com', 8),
('2020-03-30', 'mute.def@gmail.com', 9),
('2020-09-14', 'smoke.trap@gmail.com', 10),
('2021-11-01', 'ace.entry@gmail.com', 11),
('2022-01-25', 'iq.smart@gmail.com', 12),
('2023-04-13', 'caveira.hunt@gmail.com', 13),
('2023-07-20', 'doc.heal@gmail.com', 14),
('2024-02-15', 'jackal.track@gmail.com', 15);

-- ========================
-- TRANSACTIONS
-- ========================
INSERT INTO Transactions (TransactionValue, TransactionType, TransactionDate, TransactionStatus, UserEmail, ValidSkinID) VALUES
(2500, 'Buying', '2021-04-02', 'Succesfull', 'ash.player@gmail.com', 1),
(1900, 'Buying', '2020-12-10', 'Succesfull', 'sledge.main@gmail.com', 2),
(3100, 'Selling', '2020-07-01', 'Succesfull', 'thermite.pro@gmail.com', 3),
(1700, 'Buying', '2021-01-10', 'Ongoing', 'rook.def@gmail.com', 4),
(2800, 'Buying', '2022-05-05', 'Succesfull', 'twitch.gg@gmail.com', 5),
(2300, 'Selling', '2020-09-18', 'Canceled', 'finka.boost@gmail.com', 6),
(2100, 'Buying', '2021-02-22', 'Succesfull', 'pulse.scan@gmail.com', 7),
(2400, 'Selling', '2019-06-19', 'Succesfull', 'hibana.fire@gmail.com', 8),
(2600, 'Buying', '2020-03-30', 'Ongoing', 'mute.def@gmail.com', 9),
(2200, 'Buying', '2020-09-14', 'Succesfull', 'smoke.trap@gmail.com', 10),
(3200, 'Selling', '2021-11-01', 'Succesfull', 'ace.entry@gmail.com', 11),
(2700, 'Buying', '2022-01-25', 'Succesfull', 'iq.smart@gmail.com', 12),
(2100, 'Selling', '2023-04-13', 'Succesfull', 'caveira.hunt@gmail.com', 13),
(2300, 'Buying', '2023-07-20', 'Ongoing', 'doc.heal@gmail.com', 13),
(2900, 'Selling', '2024-02-15', 'Succesfull', 'jackal.track@gmail.com', 15);
