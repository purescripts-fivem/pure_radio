CREATE TABLE IF NOT EXISTS `pure_radios_faves` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charId` varchar(60) NOT NULL,
  `radio` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `charId` (`charId`)
) ENGINE=InnoDB;
