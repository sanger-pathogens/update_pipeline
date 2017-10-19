# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: vm-mii-ml (MySQL 5.5.40-log)
# Database: ml_mlwarehouse
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
  `id_lims` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'LIM system identifier, e.g. GCLP-CLARITY, SEQSCAPE',
  `uuid_study_lims` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'LIMS-specific study uuid',
  `id_study_lims` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'LIMS-specific study identifier',
  `last_updated` datetime NOT NULL COMMENT 'Timestamp of last update',
  `recorded_at` datetime NOT NULL COMMENT 'Timestamp of warehouse update',
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of study deletion',
  `created` datetime DEFAULT NULL COMMENT 'Timestamp of study creation',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference_genome` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ethically_approved` tinyint(1) DEFAULT NULL,
  `faculty_sponsor` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `abstract` text COLLATE utf8_unicode_ci,
  `abbreviation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accession_number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `contains_human_dna` tinyint(1) DEFAULT NULL COMMENT 'Lane may contain human DNA',
  `contaminated_human_dna` tinyint(1) DEFAULT NULL COMMENT 'Human DNA in the lane is a contaminant and should be removed',
  `data_release_strategy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_sort_of_study` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ena_project_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_dac_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `array_express_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_policy_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_timing` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_period` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remove_x_and_autosomes` tinyint(1) NOT NULL DEFAULT '0',
  `aligned` tinyint(1) NOT NULL DEFAULT '1',
  `separate_y_chromosome_data` tinyint(1) NOT NULL DEFAULT '0',
  `data_access_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prelim_id` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The preliminary study id prior to entry into the LIMS',
  `hmdmc_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The Human Materials and Data Management Committee approval number(s) for the study.',
  `data_destination` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'The data destination type(s) for the study. It could be ''standard'', ''14mg'' or ''gseq''. This may be extended, if Sanger gains more external customers. It can contain multiply destinations separated by a space.',
  PRIMARY KEY (`id_study_tmp`),
  UNIQUE KEY `study_id_lims_id_study_lims_index` (`id_lims`,`id_study_lims`),
  UNIQUE KEY `study_uuid_study_lims_index` (`uuid_study_lims`),
  KEY `study_accession_number_index` (`accession_number`),
  KEY `study_name_index` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `iseq_product_metrics` (
  `id_iseq_pr_metrics_tmp` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal to this database id, value can change',
  `id_iseq_flowcell_tmp` int(10) unsigned DEFAULT NULL COMMENT 'Flowcell id, see "iseq_flowcell.id_iseq_flowcell_tmp"',
  `id_run` int(10) unsigned NOT NULL COMMENT 'NPG run identifier',
  `position` smallint(2) unsigned NOT NULL COMMENT 'Flowcell lane number',
  `tag_index` smallint(5) unsigned DEFAULT NULL COMMENT 'Tag index, NULL if lane is not a pool',
  `qc_seq` tinyint(1) DEFAULT NULL COMMENT 'Sequencing lane level QC outcome, a result of either manual or automatic assessment by core',
  `qc_lib` tinyint(1) DEFAULT NULL COMMENT 'Library QC outcome, a result of either manual or automatic assessment by core',
  `qc` tinyint(1) DEFAULT NULL COMMENT 'Overall QC assessment outcome, a logical product (conjunction) of qc_seq and qc_lib values, defaults to the qc_seq value when qc_lib is not defined',
  `tag_sequence4deplexing` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Tag sequence used for deplexing the lane, common suffix might have been truncated',
  `actual_forward_read_length` smallint(4) unsigned DEFAULT NULL COMMENT 'Actual forward read length, bp',
  `actual_reverse_read_length` smallint(4) unsigned DEFAULT NULL COMMENT 'Actual reverse read length, bp',
  `indexing_read_length` smallint(2) unsigned DEFAULT NULL COMMENT 'Indexing read length, bp',
  `tag_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `tag_decode_count` int(10) unsigned DEFAULT NULL,
  `insert_size_quartile1` smallint(5) unsigned DEFAULT NULL,
  `insert_size_quartile3` smallint(5) unsigned DEFAULT NULL,
  `insert_size_median` smallint(5) unsigned DEFAULT NULL,
  `insert_size_num_modes` smallint(4) unsigned DEFAULT NULL,
  `insert_size_normal_fit_confidence` float(3,2) unsigned DEFAULT NULL,
  `gc_percent_forward_read` float(5,2) unsigned DEFAULT NULL,
  `gc_percent_reverse_read` float(5,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_forward_read` float(4,2) unsigned DEFAULT NULL,
  `sequence_mismatch_percent_reverse_read` float(4,2) unsigned DEFAULT NULL,
  `adapters_percent_forward_read` float(5,2) unsigned DEFAULT NULL,
  `adapters_percent_reverse_read` float(5,2) unsigned DEFAULT NULL,
  `ref_match1_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `num_reads` bigint(20) unsigned DEFAULT NULL,
  `percent_mapped` float(5,2) DEFAULT NULL,
  `percent_duplicate` float(5,2) DEFAULT NULL,
  `chimeric_reads_percent` float(5,2) unsigned DEFAULT NULL COMMENT 'mate_mapped_defferent_chr_5 as percentage of all',
  `human_percent_mapped` float(5,2) DEFAULT NULL,
  `human_percent_duplicate` float(5,2) DEFAULT NULL,
  `genotype_sample_name_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_sample_name_relaxed_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_mean_depth` float(7,2) DEFAULT NULL,
  `mean_bait_coverage` float(8,2) unsigned DEFAULT NULL,
  `on_bait_percent` float(5,2) unsigned DEFAULT NULL,
  `on_or_near_bait_percent` float(5,2) unsigned DEFAULT NULL,
  `verify_bam_id_average_depth` float(11,2) unsigned DEFAULT NULL,
  `verify_bam_id_score` float(6,5) unsigned DEFAULT NULL,
  `verify_bam_id_snp_count` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_iseq_pr_metrics_tmp`),
  KEY `iseq_pm_run_index` (`id_run`),
  KEY `iseq_pm_run_pos_index` (`id_run`,`position`),
  KEY `iseq_pm_fcid_run_pos_tag_index` (`id_run`,`position`,`tag_index`),
  KEY `iseq_pr_metrics_flc_fk` (`id_iseq_flowcell_tmp`),
  KEY `iseq_pr_metrics_lm_fk` (`id_run`,`position`),
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `iseq_run_lane_metrics` (
  `flowcell_barcode` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Manufacturer flowcell barcode or other identifier as recorded by NPG',
  `id_run` int(10) unsigned NOT NULL COMMENT 'NPG run identifier',
  `position` smallint(2) unsigned NOT NULL COMMENT 'Flowcell lane number',
  `instrument_name` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instrument_model` char(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `paired_read` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `cycles` int(4) unsigned NOT NULL,
  `cancelled` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT 'Boolen flag to indicate whether the run was cancelled',
  `run_pending` datetime DEFAULT NULL COMMENT 'Timestamp of run pending status',
  `run_complete` datetime DEFAULT NULL COMMENT 'Timestamp of run complete status',
  `qc_complete` datetime DEFAULT NULL COMMENT 'Timestamp of qc complete status',
  `pf_cluster_count` bigint(20) unsigned DEFAULT NULL,
  `raw_cluster_count` bigint(20) unsigned DEFAULT NULL,
  `raw_cluster_density` double(12,3) unsigned DEFAULT NULL,
  `pf_cluster_density` double(12,3) unsigned DEFAULT NULL,
  `pf_bases` bigint(20) unsigned DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `tags_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `tags_decode_cv` float(6,2) unsigned DEFAULT NULL,
  `unexpected_tags_percent` float(5,2) unsigned DEFAULT NULL COMMENT 'tag0_perfect_match_reads as a percentage of total_lane_reads',
  `run_priority` tinyint(3) DEFAULT NULL COMMENT 'Sequencing lane level run priority, a result of either manual or default value set by core',
  PRIMARY KEY (`id_run`,`position`),
  KEY `iseq_rlmm_id_run_index` (`id_run`),
  KEY `iseq_rlm_cancelled_and_run_pending_index` (`cancelled`,`run_pending`),
  KEY `iseq_rlm_cancelled_and_run_complete_index` (`cancelled`,`run_complete`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
