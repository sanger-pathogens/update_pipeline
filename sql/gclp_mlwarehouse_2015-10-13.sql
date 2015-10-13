# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: vm-mii-gclp (MySQL 5.5.40-log)
# Database: gclp_mlwarehouse
# Generation Time: 2015-10-13 09:54:41 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table study
# ------------------------------------------------------------

CREATE TABLE `study` (
  `id_study_tmp` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal to this database id, value can change',
  `id_lims` varchar(10) NOT NULL COMMENT 'LIM system identifier, e.g. GCLP-CLARITY, SEQSCAPE',
  `uuid_study_lims` varchar(36) DEFAULT NULL COMMENT 'LIMS-specific study uuid',
  `id_study_lims` varchar(20) NOT NULL COMMENT 'LIMS-specific study identifier',
  `last_updated` datetime NOT NULL COMMENT 'Timestamp of last update',
  `recorded_at` datetime NOT NULL COMMENT 'Timestamp of warehouse update',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of study deletion',
  `created` datetime DEFAULT NULL COMMENT 'Timestamp of study creation',
  `name` varchar(255) DEFAULT NULL,
  `reference_genome` varchar(255) DEFAULT NULL,
  `ethically_approved` tinyint(1) DEFAULT NULL,
  `faculty_sponsor` varchar(255) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `study_type` varchar(50) DEFAULT NULL,
  `abstract` text,
  `abbreviation` varchar(255) DEFAULT NULL,
  `accession_number` varchar(50) DEFAULT NULL,
  `description` text,
  `contains_human_dna` tinyint(1) DEFAULT NULL COMMENT 'Lane may contain human DNA',
  `contaminated_human_dna` tinyint(1) DEFAULT NULL COMMENT 'Human DNA in the lane is a contaminant and should be removed',
  `data_release_strategy` varchar(255) DEFAULT NULL,
  `data_release_sort_of_study` varchar(255) DEFAULT NULL,
  `ena_project_id` varchar(255) DEFAULT NULL,
  `study_title` varchar(255) DEFAULT NULL,
  `study_visibility` varchar(255) DEFAULT NULL,
  `ega_dac_accession_number` varchar(255) DEFAULT NULL,
  `array_express_accession_number` varchar(255) DEFAULT NULL,
  `ega_policy_accession_number` varchar(255) DEFAULT NULL,
  `data_release_timing` varchar(255) DEFAULT NULL,
  `data_release_delay_period` varchar(255) DEFAULT NULL,
  `data_release_delay_reason` varchar(255) DEFAULT NULL,
  `remove_x_and_autosomes` tinyint(1) NOT NULL DEFAULT '0',
  `aligned` tinyint(1) NOT NULL DEFAULT '1',
  `separate_y_chromosome_data` tinyint(1) NOT NULL DEFAULT '0',
  `data_access_group` varchar(255) DEFAULT NULL,
  `prelim_id` varchar(20) DEFAULT NULL COMMENT 'The preliminary study id prior to entry into the LIMS',
  PRIMARY KEY (`id_study_tmp`),
  UNIQUE KEY `study_id_lims_id_study_lims_index` (`id_lims`,`id_study_lims`),
  UNIQUE KEY `study_uuid_study_lims_index` (`uuid_study_lims`),
  KEY `study_accession_number_index` (`accession_number`),
  KEY `study_name_index` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
