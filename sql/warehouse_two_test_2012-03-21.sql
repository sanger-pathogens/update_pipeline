# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.1.48)
# Database: warehouse_two_test
# Generation Time: 2012-03-21 10:45:10 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table aliquots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `aliquots`;

CREATE TABLE `aliquots` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `receptacle_uuid` varchar(36) DEFAULT NULL,
  `receptacle_internal_id` int(11) DEFAULT NULL,
  `study_uuid` varchar(36) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `project_uuid` varchar(36) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `library_uuid` varchar(36) DEFAULT NULL,
  `library_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `tag_uuid` varchar(36) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `receptacle_type` varchar(255) DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `insert_size_from` int(11) DEFAULT NULL,
  `insert_size_to` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_aliquots_on_uuid` (`uuid`),
  KEY `index_aliquots_on_internal_id` (`internal_id`),
  KEY `index_aliquots_on_last_updated` (`last_updated`),
  KEY `index_aliquots_on_created` (`created`),
  KEY `index_aliquots_on_receptacle_uuid` (`receptacle_uuid`),
  KEY `index_aliquots_on_receptacle_internal_id` (`receptacle_internal_id`),
  KEY `index_aliquots_on_library_internal_id` (`library_internal_id`),
  KEY `index_aliquots_on_library_uuid` (`library_uuid`),
  KEY `index_aliquots_on_sample_uuid` (`sample_uuid`),
  KEY `index_aliquots_on_sample_internal_id` (`sample_internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table current_library_tubes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_library_tubes`;

CREATE TABLE `current_library_tubes` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `volume` decimal(5,0) DEFAULT NULL,
  `concentration` decimal(5,0) DEFAULT NULL,
  `tag_uuid` varchar(36) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `expected_sequence` varchar(255) DEFAULT NULL,
  `tag_map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) DEFAULT NULL,
  `tag_group_uuid` varchar(36) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `source_request_internal_id` int(11) DEFAULT NULL,
  `source_request_uuid` varchar(36) DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `fragment_size_required_from` varchar(255) DEFAULT NULL,
  `fragment_size_required_to` varchar(255) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table current_multiplexed_library_tubes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_multiplexed_library_tubes`;

CREATE TABLE `current_multiplexed_library_tubes` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `volume` decimal(5,0) DEFAULT NULL,
  `concentration` decimal(5,0) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table current_pulldown_multiplexed_library_tubes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_pulldown_multiplexed_library_tubes`;

CREATE TABLE `current_pulldown_multiplexed_library_tubes` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `concentration` decimal(5,0) DEFAULT NULL,
  `volume` decimal(5,0) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table current_requests
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_requests`;

CREATE TABLE `current_requests` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `fragment_size_from` varchar(255) DEFAULT NULL,
  `fragment_size_to` varchar(255) DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `study_uuid` varchar(36) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_name` varchar(255) DEFAULT NULL,
  `project_uuid` varchar(36) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `source_asset_uuid` varchar(36) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_type` varchar(50) DEFAULT NULL,
  `source_asset_name` varchar(255) DEFAULT NULL,
  `source_asset_barcode` varchar(255) DEFAULT NULL,
  `source_asset_barcode_prefix` varchar(255) DEFAULT NULL,
  `source_asset_state` varchar(255) DEFAULT NULL,
  `source_asset_closed` varchar(255) DEFAULT NULL,
  `source_asset_two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `source_asset_sample_uuid` varchar(36) DEFAULT NULL,
  `source_asset_sample_internal_id` int(11) DEFAULT NULL,
  `target_asset_uuid` varchar(36) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_type` varchar(50) DEFAULT NULL,
  `target_asset_name` varchar(255) DEFAULT NULL,
  `target_asset_barcode` varchar(255) DEFAULT NULL,
  `target_asset_barcode_prefix` varchar(255) DEFAULT NULL,
  `target_asset_state` varchar(255) DEFAULT NULL,
  `target_asset_closed` varchar(255) DEFAULT NULL,
  `target_asset_two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `target_asset_sample_uuid` varchar(36) DEFAULT NULL,
  `target_asset_sample_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `state` varchar(40) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `user` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table current_samples
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_samples`;

CREATE TABLE `current_samples` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `reference_genome` varchar(255) DEFAULT NULL,
  `organism` varchar(255) DEFAULT NULL,
  `accession_number` varchar(50) DEFAULT NULL,
  `common_name` varchar(255) DEFAULT NULL,
  `description` text,
  `taxon_id` varchar(255) DEFAULT NULL,
  `father` varchar(255) DEFAULT NULL,
  `mother` varchar(255) DEFAULT NULL,
  `replicate` varchar(255) DEFAULT NULL,
  `ethnicity` varchar(255) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `cohort` varchar(255) DEFAULT NULL,
  `country_of_origin` varchar(255) DEFAULT NULL,
  `geographical_region` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `sanger_sample_id` varchar(255) DEFAULT NULL,
  `control` tinyint(1) DEFAULT NULL,
  `empty_supplier_sample_name` tinyint(1) DEFAULT NULL,
  `supplier_name` varchar(255) DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `sample_visibility` varchar(255) DEFAULT NULL,
  `strain` varchar(255) DEFAULT NULL,
  `updated_by_manifest` tinyint(1) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table current_studies
# ------------------------------------------------------------

DROP TABLE IF EXISTS `current_studies`;

CREATE TABLE `current_studies` (
  `dont_use_id` int(11) NOT NULL DEFAULT '0',
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
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
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `contains_human_dna` varchar(255) DEFAULT NULL,
  `contaminated_human_dna` varchar(255) DEFAULT NULL,
  `data_release_strategy` varchar(255) DEFAULT NULL,
  `data_release_sort_of_study` varchar(255) DEFAULT NULL,
  `ena_project_id` varchar(255) DEFAULT NULL,
  `study_title` varchar(255) DEFAULT NULL,
  `study_visibility` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `ega_dac_accession_number` varchar(255) DEFAULT NULL,
  `array_express_accession_number` varchar(255) DEFAULT NULL,
  `ega_policy_accession_number` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;



# Dump of table npg_information
# ------------------------------------------------------------

DROP TABLE IF EXISTS `npg_information`;

CREATE TABLE `npg_information` (
  `id_npg_information` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` bigint(20) unsigned NOT NULL,
  `id_run` bigint(20) unsigned NOT NULL,
  `position` int(1) unsigned NOT NULL,
  `id_run_pair` bigint(20) unsigned DEFAULT NULL,
  `run_complete` datetime DEFAULT NULL,
  `cycles` int(4) unsigned NOT NULL,
  `cluster_count` bigint(20) unsigned DEFAULT NULL,
  `pf_bases` bigint(20) unsigned DEFAULT NULL,
  `is_dev` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `has_two_runfolders` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `paired_read` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `cancelled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `instrument_name` char(32) DEFAULT NULL,
  `instrument_model` char(64) DEFAULT NULL,
  `manual_qc` tinyint(1) unsigned DEFAULT NULL,
  `clusters_raw` bigint(20) unsigned DEFAULT NULL,
  `raw_cluster_density` double(12,3) unsigned DEFAULT NULL,
  `pf_cluster_density` double(12,3) unsigned DEFAULT NULL,
  `insert_size_quartile1` smallint(5) unsigned DEFAULT NULL,
  `insert_size_quartile3` smallint(5) unsigned DEFAULT NULL,
  `insert_size_median` smallint(5) unsigned DEFAULT NULL,
  `gc_percent_forward_read` float(5,2) unsigned DEFAULT NULL,
  `gc_percent_reverse_read` float(5,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_forward_read` float(4,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_reverse_read` float(4,2) unsigned DEFAULT NULL,
  `adapters_percent_forward_read` float(4,2) unsigned DEFAULT NULL,
  `adapters_percent_reverse_read` float(4,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit1_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit1_score` float(6,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit2_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit2_score` float(6,2) unsigned DEFAULT NULL,
  `ref_match1_name` varchar(100) DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `run_pending` datetime DEFAULT NULL,
  `qc_complete` datetime DEFAULT NULL,
  `tags_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `asset_name` varchar(255) DEFAULT NULL,
  `sample_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `project_id` int(11) unsigned DEFAULT NULL,
  `request_id` int(11) unsigned DEFAULT NULL,
  `lane_type` varchar(20) DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_forward_read` bigint(20) unsigned DEFAULT NULL,
  `q30_yield_reverse_read` bigint(20) unsigned DEFAULT NULL,
  `split_human_percent` float(5,2) DEFAULT NULL,
  `split_phix_percent` float(5,2) DEFAULT NULL,
  `bam_num_reads` bigint(20) unsigned DEFAULT NULL,
  `bam_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_human_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_human_percent_duplicate` float(5,2) DEFAULT NULL,
  PRIMARY KEY (`id_npg_information`),
  UNIQUE KEY `batch_run_pos` (`batch_id`,`id_run`,`position`),
  UNIQUE KEY `id_run_position` (`id_run`,`position`),
  KEY `npg_asset_name_index` (`asset_name`),
  KEY `npg_sample_id_index` (`sample_id`),
  KEY `npg_asset_id_index` (`asset_id`),
  KEY `npg_request_id_index` (`request_id`),
  KEY `npg_cancelled_and_run_pending_index` (`cancelled`,`run_pending`),
  KEY `npg_cancelled_and_run_complete_index` (`cancelled`,`run_complete`),
  KEY `npg_study_id_index` (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table npg_plex_information
# ------------------------------------------------------------

DROP TABLE IF EXISTS `npg_plex_information`;

CREATE TABLE `npg_plex_information` (
  `batch_id` bigint(20) unsigned NOT NULL,
  `id_run` bigint(20) unsigned NOT NULL,
  `position` int(1) unsigned NOT NULL,
  `tag_index` smallint(5) unsigned NOT NULL,
  `asset_id` int(11) unsigned DEFAULT NULL,
  `asset_name` varchar(255) DEFAULT NULL,
  `sample_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `project_id` int(11) unsigned DEFAULT NULL,
  `insert_size_quartile1` smallint(5) unsigned DEFAULT NULL,
  `insert_size_quartile3` smallint(5) unsigned DEFAULT NULL,
  `insert_size_median` smallint(5) unsigned DEFAULT NULL,
  `gc_percent_forward_read` float(5,2) unsigned DEFAULT NULL,
  `gc_percent_reverse_read` float(5,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_forward_read` float(4,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_reverse_read` float(4,2) unsigned DEFAULT NULL,
  `adapters_percent_forward_read` float(4,2) unsigned DEFAULT NULL,
  `adapters_percent_reverse_read` float(4,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit1_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit1_score` float(6,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit2_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit2_score` float(6,2) unsigned DEFAULT NULL,
  `ref_match1_name` varchar(100) DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `tag_sequence` varchar(255) DEFAULT NULL,
  `tag_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `tag_decode_count` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `bam_num_reads` bigint(20) unsigned DEFAULT NULL,
  `bam_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_human_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_human_percent_duplicate` float(5,2) DEFAULT NULL,
  PRIMARY KEY (`id_run`,`position`,`tag_index`),
  KEY `npg_plex_asset_id_index` (`asset_id`),
  KEY `npg_plex_asset_name_index` (`asset_name`),
  KEY `npg_plex_sample_id_index` (`sample_id`),
  KEY `npg_plex_study_id_index` (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
