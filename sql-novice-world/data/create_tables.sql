PRAGMA foreign_keys=ON;
DROP TABLE  IF EXISTS `Country`;
CREATE TABLE `Country` (
  `Code` TEXT NOT NULL DEFAULT '',
  `Name` TEXT NOT NULL DEFAULT '',
  `Continent` TEXT NOT NULL DEFAULT 'Asia',
  `Region` TEXT NOT NULL DEFAULT '',
  `Population` INTEGER NOT NULL DEFAULT 0,
  `LifeExpectancy` REAL DEFAULT NULL,
  `GNP` REAL DEFAULT NULL,
  `GovernmentForm` TEXT NOT NULL DEFAULT '',
  `HeadOfState` TEXT DEFAULT NULL,
  PRIMARY KEY (`Code`)
);

DROP TABLE  IF EXISTS `City`;
CREATE TABLE `City` (
  `ID` INTEGER NOT NULL,
  `Name` TEXT NOT NULL DEFAULT '',
  `CountryCode` TEXT NOT NULL DEFAULT '',
  `District` TEXT NOT NULL DEFAULT '',
  `Population` INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`)
  FOREIGN KEY(`CountryCode`) REFERENCES Country(`Code`)
);

DROP TABLE  IF EXISTS `CountryLanguage`;
CREATE TABLE `CountryLanguage` (
  `CountryCode` TEXT NOT NULL DEFAULT '',
  `Language` TEXT NOT NULL DEFAULT '',
  `IsOfficial` CHAR NOT NULL DEFAULT 'F',
  `Percentage` REAL NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`CountryCode`,`Language`)
  FOREIGN KEY(`CountryCode`) references Country(`Code`)
);
