# Dump of table allocation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `allocation`;

CREATE TABLE `allocation` (
  `study_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `individual_id` int(10) unsigned NOT NULL DEFAULT '0',
  `seq_centre_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`study_id`,`individual_id`,`seq_centre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table assembly
# ------------------------------------------------------------

DROP TABLE IF EXISTS `assembly`;

CREATE TABLE `assembly` ( 
  `assembly_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `reference_size` bigint(20) DEFAULT NULL,
  `taxon_id` mediumint(8) unsigned DEFAULT NULL,
  `translation_table` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`assembly_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table autoqc
# ------------------------------------------------------------

DROP TABLE IF EXISTS `autoqc`;

CREATE TABLE `autoqc` (
  `autoqc_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mapstats_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `test` varchar(50) NOT NULL DEFAULT '',
  `result` tinyint(1) DEFAULT '0',
  `reason` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`autoqc_id`),
  UNIQUE KEY `mapstats_test` (`mapstats_id`,`test`),
  KEY `mapstats_id` (`mapstats_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table exome_design
# ------------------------------------------------------------

DROP TABLE IF EXISTS `exome_design`;

CREATE TABLE `exome_design` (
  `exome_design_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `bait_bases` bigint(20) unsigned DEFAULT NULL,
  `target_bases` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`exome_design_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table file
# ------------------------------------------------------------

DROP TABLE IF EXISTS `file`;

CREATE TABLE `file` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `file_id` mediumint(8) unsigned NOT NULL,
  `lane_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `hierarchy_name` varchar(255) DEFAULT NULL,
  `processed` int(10) DEFAULT '0',
  `type` tinyint(4) DEFAULT NULL,
  `readlen` smallint(5) unsigned DEFAULT NULL,
  `raw_reads` bigint(20) unsigned DEFAULT NULL,
  `raw_bases` bigint(20) unsigned DEFAULT NULL,
  `mean_q` float unsigned DEFAULT NULL,
  `md5` char(32) DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  `reference` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`row_id`),
  KEY `file_id` (`file_id`),
  KEY `lane_id` (`lane_id`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table image
# ------------------------------------------------------------

DROP TABLE IF EXISTS `image`;

CREATE TABLE `image` (
  `image_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mapstats_id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `caption` varchar(40) DEFAULT NULL,
  `image` mediumblob,
  PRIMARY KEY (`image_id`),
  KEY `mapstats_id` (`mapstats_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table individual
# ------------------------------------------------------------

DROP TABLE IF EXISTS `individual`;

CREATE TABLE `individual` (
  `individual_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `hierarchy_name` varchar(255) NOT NULL,
  `alias` varchar(40) NOT NULL,
  `sex` enum('M','F','unknown') DEFAULT 'unknown',
  `acc` varchar(40) DEFAULT NULL,
  `species_id` mediumint(8) unsigned DEFAULT NULL,
  `population_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`individual_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `hierarchy_name` (`hierarchy_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table lane
# ------------------------------------------------------------

DROP TABLE IF EXISTS `lane`;

CREATE TABLE `lane` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lane_id` int(10) unsigned NOT NULL,
  `library_id` int(10) unsigned NOT NULL,
  `seq_request_id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `hierarchy_name` varchar(255) NOT NULL DEFAULT '',
  `acc` varchar(40) DEFAULT NULL,
  `readlen` smallint(5) unsigned DEFAULT NULL,
  `paired` tinyint(1) DEFAULT NULL,
  `raw_reads` bigint(20) unsigned DEFAULT NULL,
  `raw_bases` bigint(20) unsigned DEFAULT NULL,
  `npg_qc_status` enum('pending','pass','fail','-') DEFAULT NULL,
  `processed` int(10) DEFAULT '0',
  `auto_qc_status` enum('no_qc','passed','failed') DEFAULT NULL,
  `qc_status` enum('no_qc','pending','passed','failed') DEFAULT NULL,
  `gt_status` enum('unchecked','confirmed','wrong','unconfirmed','candidate','unknown','swapped') DEFAULT 'unchecked',
  `submission_id` smallint(5) unsigned DEFAULT NULL,
  `withdrawn` tinyint(1) DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `run_date` datetime DEFAULT NULL,
  `storage_path` varchar(255) DEFAULT NULL,
  `latest` tinyint(1) DEFAULT '0',
  `manually_withdrawn` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`row_id`),
  KEY `lane_id` (`lane_id`),
  KEY `lanename` (`name`),
  KEY `library_id` (`library_id`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `acc` (`acc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table library
# ------------------------------------------------------------

DROP TABLE IF EXISTS `library`;

CREATE TABLE `library` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `library_id` int(10) unsigned NOT NULL,
  `library_request_id` mediumint(8) unsigned NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `hierarchy_name` varchar(255) NOT NULL DEFAULT '',
  `prep_status` enum('unknown','pending','started','passed','failed','cancelled','hold') DEFAULT 'unknown',
  `auto_qc_status` enum('no_qc','passed','failed') DEFAULT NULL,
  `qc_status` enum('no_qc','pending','passed','failed') DEFAULT 'no_qc',
  `fragment_size_from` mediumint(8) unsigned DEFAULT NULL,
  `fragment_size_to` mediumint(8) unsigned DEFAULT NULL,
  `library_type_id` smallint(5) unsigned DEFAULT NULL,
  `library_tag` smallint(5) unsigned DEFAULT NULL,
  `library_tag_group` smallint(5) unsigned DEFAULT NULL,
  `library_tag_sequence` varchar(1024) DEFAULT NULL,
  `seq_centre_id` smallint(5) unsigned DEFAULT NULL,
  `seq_tech_id` smallint(5) unsigned DEFAULT NULL,
  `open` tinyint(1) DEFAULT '1',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`row_id`),
  KEY `ssid` (`ssid`),
  KEY `name` (`name`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `sample_id` (`sample_id`),
  KEY `library_id` (`library_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table library_multiplex_pool
# ------------------------------------------------------------

DROP TABLE IF EXISTS `library_multiplex_pool`;

CREATE TABLE `library_multiplex_pool` (
  `library_multiplex_pool_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `multiplex_pool_id` smallint(5) unsigned NOT NULL,
  `library_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`library_multiplex_pool_id`),
  KEY `library_multiplex_pool_id` (`library_multiplex_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table library_request
# ------------------------------------------------------------

DROP TABLE IF EXISTS `library_request`;

CREATE TABLE `library_request` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `library_request_id` mediumint(8) unsigned NOT NULL,
  `sample_id` int(10) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `prep_status` enum('unknown','pending','started','passed','failed','cancelled','hold') DEFAULT 'unknown',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`row_id`),
  KEY `library_request_id` (`library_request_id`),
  KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table library_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `library_type`;

CREATE TABLE `library_type` (
  `library_type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`library_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table mapper
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mapper`;

CREATE TABLE `mapper` (
  `mapper_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `version` varchar(40) NOT NULL,
  PRIMARY KEY (`mapper_id`),
  UNIQUE KEY `name_v` (`name`,`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table mapstats
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mapstats`;

CREATE TABLE `mapstats` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mapstats_id` mediumint(8) unsigned NOT NULL,
  `lane_id` int(10) unsigned NOT NULL,
  `mapper_id` smallint(5) unsigned DEFAULT NULL,
  `assembly_id` int(10) unsigned DEFAULT NULL,
  `raw_reads` bigint(20) unsigned DEFAULT NULL,
  `raw_bases` bigint(20) unsigned DEFAULT NULL,
  `clip_bases` bigint(20) unsigned DEFAULT NULL,
  `reads_mapped` bigint(20) unsigned DEFAULT NULL,
  `reads_paired` bigint(20) unsigned DEFAULT NULL,
  `bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `rmdup_reads_mapped` bigint(20) unsigned DEFAULT NULL,
  `rmdup_bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `adapter_reads` bigint(20) unsigned DEFAULT NULL,
  `error_rate` float unsigned DEFAULT NULL,
  `mean_insert` float unsigned DEFAULT NULL,
  `sd_insert` float unsigned DEFAULT NULL,
  `gt_expected` varchar(40) DEFAULT NULL,
  `gt_found` varchar(40) DEFAULT NULL,
  `gt_ratio` float unsigned DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  `bait_near_bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `target_near_bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `bait_bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `mean_bait_coverage` float unsigned DEFAULT NULL,
  `bait_coverage_sd` float unsigned DEFAULT NULL,
  `off_bait_bases` bigint(20) unsigned DEFAULT NULL,
  `reads_on_bait` bigint(20) unsigned DEFAULT NULL,
  `reads_on_bait_near` bigint(20) unsigned DEFAULT NULL,
  `reads_on_target` bigint(20) unsigned DEFAULT NULL,
  `reads_on_target_near` bigint(20) unsigned DEFAULT NULL,
  `target_bases_mapped` bigint(20) unsigned DEFAULT NULL,
  `mean_target_coverage` float unsigned DEFAULT NULL,
  `target_coverage_sd` float unsigned DEFAULT NULL,
  `target_bases_1X` float unsigned DEFAULT NULL,
  `target_bases_2X` float unsigned DEFAULT NULL,
  `target_bases_5X` float unsigned DEFAULT NULL,
  `target_bases_10X` float unsigned DEFAULT NULL,
  `target_bases_20X` float unsigned DEFAULT NULL,
  `target_bases_50X` float unsigned DEFAULT NULL,
  `target_bases_100X` float unsigned DEFAULT NULL,
  `exome_design_id` smallint(5) unsigned DEFAULT NULL,
  `percentage_reads_with_transposon` float unsigned DEFAULT NULL,
  `is_qc` tinyint(1) DEFAULT '0',
  `prefix` varchar(40) DEFAULT '_',
  PRIMARY KEY (`row_id`),
  KEY `mapstats_id` (`mapstats_id`),
  KEY `lane_id` (`lane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table multiplex_pool
# ------------------------------------------------------------

DROP TABLE IF EXISTS `multiplex_pool`;

CREATE TABLE `multiplex_pool` (
  `multiplex_pool_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`multiplex_pool_id`),
  UNIQUE KEY `ssid` (`ssid`),
  KEY `multiplex_pool_id` (`multiplex_pool_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table note
# ------------------------------------------------------------

DROP TABLE IF EXISTS `note`;

CREATE TABLE `note` (
  `note_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `note` text,
  PRIMARY KEY (`note_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table population
# ------------------------------------------------------------

DROP TABLE IF EXISTS `population`;

CREATE TABLE `population` (
  `population_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`population_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table project
# ------------------------------------------------------------

DROP TABLE IF EXISTS `project`;

CREATE TABLE `project` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `project_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `hierarchy_name` varchar(255) NOT NULL DEFAULT '',
  `study_id` smallint(5) DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  `data_access_group` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`row_id`),
  KEY `project_id` (`project_id`),
  KEY `ssid` (`ssid`),
  KEY `latest` (`latest`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table sample
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sample`;

CREATE TABLE `sample` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sample_id` int(10) unsigned NOT NULL,
  `project_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `hierarchy_name` varchar(40) NOT NULL DEFAULT '',
  `individual_id` int(10) unsigned DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`row_id`),
  KEY `sample_id` (`sample_id`),
  KEY `ssid` (`ssid`),
  KEY `latest` (`latest`),
  KEY `project_id` (`project_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table schema_version
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schema_version`;

CREATE TABLE `schema_version` (
  `schema_version` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`schema_version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into schema_version(schema_version) values (29);

# Dump of table seq_centre
# ------------------------------------------------------------

DROP TABLE IF EXISTS `seq_centre`;

CREATE TABLE `seq_centre` (
  `seq_centre_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`seq_centre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table seq_request
# ------------------------------------------------------------

DROP TABLE IF EXISTS `seq_request`;

CREATE TABLE `seq_request` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `seq_request_id` mediumint(8) unsigned NOT NULL,
  `library_id` int(10) unsigned NOT NULL,
  `multiplex_pool_id` smallint(5) unsigned DEFAULT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `seq_type` enum('HiSeq Paired end sequencing','Illumina-A HiSeq Paired end sequencing','Illumina-A Paired end sequencing','Illumina-A Pulldown ISC','Illumina-A Pulldown SC','Illumina-A Pulldown WGS','Illumina-A Single ended hi seq sequencing','Illumina-A Single ended sequencing','Illumina-B HiSeq Paired end sequencing','Illumina-B Paired end sequencing','Illumina-B Single ended hi seq sequencing','Illumina-B Single ended sequencing','Illumina-C HiSeq Paired end sequencing','Illumina-C MiSeq sequencing','Illumina-C Paired end sequencing','Illumina-C Single ended hi seq sequencing','Illumina-C Single ended sequencing','MiSeq sequencing','Paired end sequencing','Single ended hi seq sequencing','Single Ended Hi Seq Sequencing Control','Single ended sequencing') NOT NULL,
  `seq_status` enum('unknown','pending','started','passed','failed','cancelled','hold') DEFAULT 'unknown',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`row_id`),
  KEY `seq_request_id` (`seq_request_id`),
  KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table seq_tech
# ------------------------------------------------------------

DROP TABLE IF EXISTS `seq_tech`;

CREATE TABLE `seq_tech` (
  `seq_tech_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`seq_tech_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table species
# ------------------------------------------------------------

DROP TABLE IF EXISTS `species`;

CREATE TABLE `species` (
  `species_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `taxon_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`species_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table study
# ------------------------------------------------------------

DROP TABLE IF EXISTS `study`;

CREATE TABLE `study` (
  `study_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `acc` varchar(40) DEFAULT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table submission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `submission`;

CREATE TABLE `submission` (
  `submission_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `acc` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`submission_id`),
  UNIQUE KEY `acc` (`acc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




--
-- Views
--

DROP VIEW if EXISTS `latest_project`;
create view latest_project as select * from project where latest=true;
DROP VIEW if EXISTS `latest_sample`;
create view latest_sample as select * from sample where latest=true;
DROP VIEW if EXISTS `latest_library`;
create view latest_library as select * from library where latest=true;
DROP VIEW if EXISTS `latest_library_request`;
create view latest_library_request as select * from library_request where latest=true;
DROP VIEW if EXISTS `latest_seq_request`;
create view latest_seq_request as select * from seq_request where latest=true;
DROP VIEW if EXISTS `latest_lane`;
create view latest_lane as select * from lane where latest=true;
DROP VIEW if EXISTS `latest_file`;
create view latest_file as select * from file where latest=true;
DROP VIEW if EXISTS `latest_mapstats`;
create view latest_mapstats as select * from mapstats where latest=true;
