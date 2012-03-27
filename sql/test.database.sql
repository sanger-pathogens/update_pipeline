--
-- Table structure for table `version`
--

DROP TABLE IF EXISTS `schema_version`;
CREATE TABLE `schema_version` (
  `schema_version` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`schema_version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into schema_version(schema_version) values (18);

--
-- Table structure for table `assembly`
--

DROP TABLE IF EXISTS `assembly`;
CREATE TABLE `assembly` (
  `assembly_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `reference_size` integer,
  `taxon_id` mediumint(8) unsigned DEFAULT NULL,
  `translation_table` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY  (`assembly_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `exome_design`
--

DROP TABLE IF EXISTS `exome_design`;
CREATE TABLE `exome_design` (
  `exome_design_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `bait_bases` bigint(20) unsigned default NULL,
  `target_bases` bigint(20) unsigned default NULL,
  PRIMARY KEY (`exome_design_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `note`
--

DROP TABLE IF EXISTS `note`;
CREATE TABLE `note` (
  `note_id` mediumint(8) unsigned NOT NULL auto_increment,
  `note` text default NULL,
  PRIMARY KEY  (`note_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `file`
--

DROP TABLE IF EXISTS `file`;
CREATE TABLE `file` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `file_id` mediumint(8) unsigned NOT NULL,
  `lane_id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `hierarchy_name` varchar(255) default NULL,
  `processed` int(10) default 0,
  `type` tinyint(4) default NULL,
  `readlen` smallint(5) unsigned default NULL,
  `raw_reads` bigint(20) unsigned default NULL,
  `raw_bases` bigint(20) unsigned default NULL,
  `mean_q` float unsigned default NULL,
  `md5` varchar(40) default NULL,
  `note_id` mediumint(8) unsigned default NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) default '0',
  KEY `file_id` (`file_id`),
  KEY `lane_id` (`lane_id`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `image_id` mediumint(8) unsigned NOT NULL auto_increment,
  `mapstats_id` mediumint(8) unsigned NOT NULL,
  `name` varchar(40) NOT NULL,
  `caption` varchar(40) default NULL,
  `image` MEDIUMBLOB,
  PRIMARY KEY (`image_id`),
  KEY  `mapstats_id` (`mapstats_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `lane`
--

DROP TABLE IF EXISTS `lane`;
CREATE TABLE `lane` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `lane_id` mediumint(8) unsigned NOT NULL,
  `library_id` smallint(5) unsigned NOT NULL,
  `seq_request_id` mediumint(8) unsigned NOT NULL,
  `name` varchar(255) NOT NULL default '',
  `hierarchy_name` varchar(255) NOT NULL default '',
  `acc` varchar(40) default NULL,
  `readlen` smallint(5) unsigned default NULL,
  `paired` tinyint(1) default NULL,
  `raw_reads` bigint(20) unsigned default NULL,
  `raw_bases` bigint(20) unsigned default NULL,
  `npg_qc_status` enum('pending','pass','fail','-') default 'pending',
  `processed` int(10) default 0,
  `auto_qc_status` enum('no_qc','passed','failed') default 'no_qc',
  `qc_status` enum('no_qc','pending','passed','failed','gt_pending','investigate') default 'no_qc',
  `gt_status` enum('unchecked','confirmed','wrong','unconfirmed','candidate','unknown','swapped') default 'unchecked',
  `submission_id` smallint(5) unsigned default NULL,
  `withdrawn` tinyint(1) default NULL,
  `note_id` mediumint(8) unsigned default NULL,
  `changed` datetime NOT NULL,
  `run_date` datetime default NULL,
  `storage_path` varchar(255) default NULL,
  `latest` tinyint(1) default '0',
  KEY `lane_id` (`lane_id`),
  KEY `lanename` (`name`),
  KEY `library_id` (`library_id`),
  KEY `hierarchy_name` (`hierarchy_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `library`
--

DROP TABLE IF EXISTS `library`;
CREATE TABLE `library` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `library_id` smallint(5) unsigned NOT NULL,
  `library_request_id` mediumint(8) unsigned NOT NULL,
  `sample_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned default NULL,
  `name` varchar(255) NOT NULL default '',
  `hierarchy_name` varchar(255) NOT NULL default '',
  `prep_status` enum('unknown','pending','started','passed','failed','cancelled','hold') default 'unknown',
  `auto_qc_status` enum('no_qc','passed','failed') default 'no_qc',
  `qc_status` enum('no_qc','pending','passed','failed') default 'no_qc',
  `fragment_size_from` mediumint(8) unsigned default NULL,
  `fragment_size_to` mediumint(8) unsigned default NULL,
  `library_type_id` smallint(5) unsigned default NULL,
  `library_tag` smallint(5) unsigned,
  `library_tag_group` smallint(5) unsigned,
  `library_tag_sequence` varchar(1024),
  `seq_centre_id` smallint(5) unsigned default NULL,
  `seq_tech_id` smallint(5) unsigned default NULL,
  `open` tinyint(1) default '1',
  `note_id` mediumint(8) unsigned default NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) default '0',
  KEY `ssid` (`ssid`),
  KEY `name` (`name`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `sample_id` (`sample_id`),
  KEY `library_id` (`library_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `multiplex_pool`
--
DROP TABLE IF EXISTS `multiplex_pool`;
CREATE TABLE `multiplex_pool` (
  `multiplex_pool_id` mediumint(8) unsigned NOT NULL auto_increment key,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL default '',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  KEY `multiplex_pool_id` (`multiplex_pool_id`),
  KEY `name` (`name`),
  UNIQUE KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `library_multiplex_pool`
--
DROP TABLE IF EXISTS `library_multiplex_pool`;
CREATE TABLE `library_multiplex_pool` (
  `library_multiplex_pool_id` mediumint(8) unsigned NOT NULL auto_increment key,
  `multiplex_pool_id` smallint(5) unsigned NOT NULL,
  `library_id` smallint(5) unsigned NOT NULL,
  KEY `library_multiplex_pool_id` (`library_multiplex_pool_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Table structure for table `library_request`
--
DROP TABLE IF EXISTS `library_request`;
CREATE TABLE `library_request` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `library_request_id` mediumint(8) unsigned NOT NULL,
  `sample_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `prep_status` enum('unknown','pending','started','passed','failed','cancelled','hold') DEFAULT 'unknown',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  KEY `library_request_id` (`library_request_id`),
  KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `seq_request`
--
DROP TABLE IF EXISTS `seq_request`;
CREATE TABLE `seq_request` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `seq_request_id` mediumint(8) unsigned NOT NULL,
  `library_id` smallint(5) unsigned,
  `multiplex_pool_id` smallint(5) unsigned,
  `ssid` mediumint(8) unsigned DEFAULT NULL,
  `seq_type` enum('Single ended sequencing','Paired end sequencing','HiSeq Paired end sequencing','MiSeq sequencing','Single ended hi seq sequencing') DEFAULT 'Single ended sequencing',
  `seq_status` enum('unknown','pending','started','passed','failed','cancelled','hold') DEFAULT 'unknown',
  `note_id` mediumint(8) unsigned DEFAULT NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) DEFAULT '0',
  KEY `seq_request_id` (`seq_request_id`),
  KEY `ssid` (`ssid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `library_type`
--

DROP TABLE IF EXISTS `library_type`;
CREATE TABLE `library_type` (
  `library_type_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY  (`library_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `mapper`
--

DROP TABLE IF EXISTS `mapper`;
CREATE TABLE `mapper` (
  `mapper_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  `version` varchar(40) NOT NULL,
  PRIMARY KEY  (`mapper_id`),
  UNIQUE KEY `name_v` (`name`, `version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `mapstats`
--

DROP TABLE IF EXISTS `mapstats`;
CREATE TABLE `mapstats` (
  `row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mapstats_id` mediumint(8) unsigned NOT NULL,
  `lane_id` mediumint(8) unsigned NOT NULL,
  `mapper_id` smallint(5) unsigned DEFAULT NULL,
  `assembly_id` smallint(5) unsigned DEFAULT NULL,
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
  PRIMARY KEY (`row_id`),
  KEY `mapstats_id` (`mapstats_id`),
  KEY `lane_id` (`lane_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `population`
--

DROP TABLE IF EXISTS `population`;
CREATE TABLE `population` (
  `population_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY  (`population_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `species`
--

DROP TABLE IF EXISTS `species`;
CREATE TABLE `species` (
  `species_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `taxon_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY  (`species_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `individual`
--

DROP TABLE IF EXISTS `individual`;
CREATE TABLE `individual` (
  `individual_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `hierarchy_name` varchar(255) NOT NULL,
  `alias` varchar(40) NOT NULL,
  `sex` enum('M','F','unknown') default 'unknown',
  `acc` varchar(40) default NULL,
  `species_id` smallint(5) unsigned default NULL,
  `population_id` smallint(5) unsigned default NULL,
  PRIMARY KEY  (`individual_id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `hierarchy_name` (`hierarchy_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
CREATE TABLE `project` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `project_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned default NULL,
  `name` varchar(255) NOT NULL default '',
  `hierarchy_name` varchar(255) NOT NULL default '',
  `study_id` smallint(5) default NULL,
  `note_id` mediumint(8) unsigned default NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) default '0',
  KEY `project_id` (`project_id`),
  KEY `ssid` (`ssid`),
  KEY `latest` (`latest`),
  KEY `hierarchy_name` (`hierarchy_name`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `study`
--

DROP TABLE IF EXISTS `study`;
CREATE TABLE `study` (
`study_id` smallint(5) unsigned NOT NULL auto_increment,
`name` varchar(40) NOT NULL default '',
`acc` varchar(40) default NULL,
`ssid` mediumint(8) unsigned default NULL,
`note_id` mediumint(8) unsigned default NULL,
PRIMARY KEY  (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `allocation`
--

DROP TABLE IF EXISTS `allocation`;
CREATE TABLE `allocation` (
`study_id` smallint(5) unsigned default NULL,
`individual_id` smallint(5) unsigned default NULL,
`seq_centre_id` smallint(5) unsigned default NULL,
PRIMARY KEY  (`study_id`,`individual_id`,`seq_centre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
CREATE TABLE `sample` (
  `row_id` int unsigned NOT NULL auto_increment key,
  `sample_id` smallint(5) unsigned NOT NULL,
  `project_id` smallint(5) unsigned NOT NULL,
  `ssid` mediumint(8) unsigned default NULL,
  `name` varchar(40) NOT NULL default '',
  `hierarchy_name` varchar(40) NOT NULL default '',
  `individual_id` smallint(5) unsigned default NULL,
  `note_id` mediumint(8) unsigned default NULL,
  `changed` datetime NOT NULL,
  `latest` tinyint(1) default '0',
  KEY  (`sample_id`),
  KEY `ssid` (`ssid`),
  KEY `latest` (`latest`),
  KEY `project_id` (`project_id`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `seq_centre`
--

DROP TABLE IF EXISTS `seq_centre`;
CREATE TABLE `seq_centre` (
  `seq_centre_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY  (`seq_centre_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `seq_tech`
--

DROP TABLE IF EXISTS `seq_tech`;
CREATE TABLE `seq_tech` (
  `seq_tech_id` smallint(5) unsigned NOT NULL auto_increment,
  `name` varchar(40) NOT NULL,
  PRIMARY KEY  (`seq_tech_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `submission`
--

DROP TABLE IF EXISTS `submission`;
CREATE TABLE `submission` (
  `submission_id` smallint(5) unsigned NOT NULL auto_increment,
  `date` datetime NOT NULL,
  `name` varchar(40) NOT NULL,
  `acc` varchar(40) default NULL,
  PRIMARY KEY  (`submission_id`),
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
