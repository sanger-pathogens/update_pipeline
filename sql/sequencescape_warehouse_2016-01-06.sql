# ************************************************************
# Sequel Pro SQL dump
# Version 4499
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: seqw-db (MySQL 5.5.31-log)
# Database: sequencescape_warehouse
# Generation Time: 2016-01-06 09:59:54 +0000
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

CREATE TABLE `aliquots` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `receptacle_uuid` binary(16) DEFAULT NULL,
  `receptacle_internal_id` int(11) DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `library_uuid` binary(16) DEFAULT NULL,
  `library_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `tag_uuid` binary(16) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `receptacle_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `insert_size_from` int(11) DEFAULT NULL,
  `insert_size_to` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `bait_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_target_species` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_supplier_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_supplier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table asset_audits
# ------------------------------------------------------------

CREATE TABLE `asset_audits` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_uuid` binary(16) DEFAULT NULL,
  `witnessed_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table asset_freezers
# ------------------------------------------------------------

CREATE TABLE `asset_freezers` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `building` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `room` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `freezer` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shelf` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `uuid_and_is_current_idx` (`uuid`,`is_current`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table asset_links
# ------------------------------------------------------------

CREATE TABLE `asset_links` (
  `uuid` binary(16) NOT NULL,
  `ancestor_uuid` binary(16) DEFAULT NULL,
  `ancestor_internal_id` int(11) NOT NULL,
  `ancestor_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descendant_uuid` binary(16) DEFAULT NULL,
  `descendant_internal_id` int(11) NOT NULL,
  `descendant_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table batch_requests
# ------------------------------------------------------------

CREATE TABLE `batch_requests` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `batch_uuid` binary(16) DEFAULT NULL,
  `batch_internal_id` int(11) DEFAULT NULL,
  `request_uuid` binary(16) DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_uuid` binary(16) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_uuid` binary(16) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table batches
# ------------------------------------------------------------

CREATE TABLE `batches` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `created_by` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assigned_to` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pipeline_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pipeline_uuid` binary(16) DEFAULT NULL,
  `pipeline_internal_id` int(11) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qc_state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `production_state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table billing_events
# ------------------------------------------------------------

CREATE TABLE `billing_events` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `reference` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `division` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_uuid` binary(16) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `kind` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `entry_date` datetime DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `bait_library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_aliquots
# ------------------------------------------------------------

CREATE TABLE `current_aliquots` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `receptacle_uuid` binary(16) DEFAULT NULL,
  `receptacle_internal_id` int(11) DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `library_uuid` binary(16) DEFAULT NULL,
  `library_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `tag_uuid` binary(16) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `receptacle_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `insert_size_from` int(11) DEFAULT NULL,
  `insert_size_to` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `bait_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_target_species` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_supplier_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bait_supplier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `library_internal_id_study_internal_id_idx` (`library_internal_id`,`study_internal_id`),
  KEY `library_uuid_and_receptacle_type_idx` (`library_uuid`,`receptacle_type`),
  KEY `receptacle_internal_id_idx` (`receptacle_internal_id`),
  KEY `sample_internal_id_receptacle_internal_id_idx` (`sample_internal_id`,`receptacle_internal_id`),
  KEY `study_internal_id_receptacle_internal_id_idx` (`study_internal_id`,`receptacle_internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_asset_audits
# ------------------------------------------------------------

CREATE TABLE `current_asset_audits` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_uuid` binary(16) DEFAULT NULL,
  `witnessed_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_asset_links
# ------------------------------------------------------------

CREATE TABLE `current_asset_links` (
  `uuid` binary(16) NOT NULL,
  `ancestor_uuid` binary(16) DEFAULT NULL,
  `ancestor_internal_id` int(11) NOT NULL,
  `ancestor_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descendant_uuid` binary(16) DEFAULT NULL,
  `descendant_internal_id` int(11) NOT NULL,
  `descendant_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `ancestor_internal_id_descendant_internal_id_descendant_type_idx` (`ancestor_internal_id`,`descendant_internal_id`,`descendant_type`),
  KEY `descendant_internal_id_ancestor_internal_id_ancestor_type_idx` (`descendant_internal_id`,`ancestor_internal_id`,`ancestor_type`),
  KEY `descendant_uuid_ancestor_uuid_idx` (`descendant_uuid`,`ancestor_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_batch_requests
# ------------------------------------------------------------

CREATE TABLE `current_batch_requests` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `batch_uuid` binary(16) DEFAULT NULL,
  `batch_internal_id` int(11) DEFAULT NULL,
  `request_uuid` binary(16) DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_uuid` binary(16) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_uuid` binary(16) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `source_asset_internal_id_request_internal_id_idx` (`source_asset_internal_id`,`request_internal_id`),
  KEY `target_asset_internal_id_batch_uuid_idx` (`target_asset_internal_id`,`batch_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_batches
# ------------------------------------------------------------

CREATE TABLE `current_batches` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `created_by` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `assigned_to` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pipeline_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pipeline_uuid` binary(16) DEFAULT NULL,
  `pipeline_internal_id` int(11) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qc_state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `production_state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `created_by_idx` (`created_by`),
  KEY `state_idx` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_billing_events
# ------------------------------------------------------------

CREATE TABLE `current_billing_events` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `reference` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `division` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_uuid` binary(16) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `quantity` float DEFAULT NULL,
  `kind` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `entry_date` datetime DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `bait_library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_events
# ------------------------------------------------------------

CREATE TABLE `current_events` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `source_internal_id` int(11) DEFAULT NULL,
  `source_uuid` binary(16) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actioned` tinyint(1) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `of_interest_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descriptor_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `source_uuid_and_state_idx` (`source_uuid`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_lanes
# ------------------------------------------------------------

CREATE TABLE `current_lanes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `external_release` tinyint(1) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `volume` decimal(10,2) DEFAULT NULL,
  `concentration` decimal(18,2) DEFAULT NULL,
  `tag_uuid` binary(16) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `expected_sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_group_uuid` binary(16) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `source_request_internal_id` int(11) DEFAULT NULL,
  `source_request_uuid` binary(16) DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_multiplexed_library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_orders
# ------------------------------------------------------------

CREATE TABLE `current_orders` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `comments` text COLLATE utf8_unicode_ci,
  `inserted_at` datetime DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `fragment_size_required_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sequencing_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `insert_size` int(11) DEFAULT NULL,
  `number_of_lanes` int(11) DEFAULT NULL,
  `submission_uuid` binary(16) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_pac_bio_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_pac_bio_library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prep_kit_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `binding_kit_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smrt_cells_available` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `movie_length` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `protocol` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_plate_purposes
# ------------------------------------------------------------

CREATE TABLE `current_plate_purposes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_plates
# ------------------------------------------------------------

CREATE TABLE `current_plates` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_size` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_purpose_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_purpose_internal_id` int(11) DEFAULT NULL,
  `plate_purpose_uuid` binary(16) DEFAULT NULL,
  `infinium_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `fluidigm_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `barcode_idx` (`barcode`),
  KEY `infinium_barcode_and_barcode_idx` (`infinium_barcode`,`barcode`),
  KEY `inserted_at_idx` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_projects
# ------------------------------------------------------------

CREATE TABLE `current_projects` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `collaborators` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `funding_comments` text COLLATE utf8_unicode_ci,
  `cost_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `funding_model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `budget_division` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `external_funding_source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_manager` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `budget_cost_centre` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_quotas
# ------------------------------------------------------------

CREATE TABLE `current_quotas` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `quota_limit` int(11) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_reference_genomes
# ------------------------------------------------------------

CREATE TABLE `current_reference_genomes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_requests
# ------------------------------------------------------------

CREATE TABLE `current_requests` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_uuid` binary(16) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_closed` tinyint(1) DEFAULT NULL,
  `source_asset_two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_sample_uuid` binary(16) DEFAULT NULL,
  `source_asset_sample_internal_id` int(11) DEFAULT NULL,
  `target_asset_uuid` binary(16) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_closed` tinyint(1) DEFAULT NULL,
  `target_asset_two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_sample_uuid` binary(16) DEFAULT NULL,
  `target_asset_sample_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `state` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `submission_uuid` binary(16) DEFAULT NULL,
  `submission_internal_id` int(11) DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `assets_via_internal_id_from_source_idx` (`source_asset_internal_id`,`target_asset_internal_id`,`source_asset_type`),
  KEY `source_asset_uuid_and_request_type_idx` (`source_asset_uuid`,`request_type`),
  KEY `study_internal_id_idx` (`study_internal_id`),
  KEY `assets_via_internal_id_idx` (`target_asset_internal_id`,`source_asset_internal_id`,`target_asset_type`),
  KEY `target_asset_uuid_source_asset_internal_id_idx` (`target_asset_uuid`,`source_asset_internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_sample_tubes
# ------------------------------------------------------------

CREATE TABLE `current_sample_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_samples
# ------------------------------------------------------------

CREATE TABLE `current_samples` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference_genome` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `organism` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accession_number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `common_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `taxon_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `father` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mother` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `replicate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ethnicity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cohort` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_of_origin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `geographical_region` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `sanger_sample_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `control` tinyint(1) DEFAULT NULL,
  `empty_supplier_sample_name` tinyint(1) DEFAULT NULL,
  `supplier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `strain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by_manifest` tinyint(1) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `consent_withdrawn` tinyint(1) NOT NULL DEFAULT '0',
  `donor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `accession_number_idx` (`accession_number`),
  KEY `name_idx` (`name`),
  KEY `sanger_sample_id_idx` (`sanger_sample_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_studies
# ------------------------------------------------------------

CREATE TABLE `current_studies` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
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
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `contains_human_dna` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminated_human_dna` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_strategy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_sort_of_study` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ena_project_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_dac_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `array_express_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_policy_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `data_release_timing` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_period` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remove_x_and_autosomes` tinyint(1) NOT NULL DEFAULT '0',
  `alignments_in_bam` tinyint(1) NOT NULL DEFAULT '1',
  `separate_y_chromosome_data` tinyint(1) NOT NULL DEFAULT '0',
  `data_access_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prelim_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `accession_number_idx` (`accession_number`),
  KEY `name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_study_samples
# ------------------------------------------------------------

CREATE TABLE `current_study_samples` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `sample_internal_id_study_internal_id_idx` (`sample_internal_id`,`study_internal_id`),
  KEY `sample_uuid_study_internal_id_idx` (`sample_uuid`,`study_internal_id`),
  KEY `study_internal_id_sample_internal_id_idx` (`study_internal_id`,`sample_internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_submissions
# ------------------------------------------------------------

CREATE TABLE `current_submissions` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_tags
# ------------------------------------------------------------

CREATE TABLE `current_tags` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `expected_sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_group_uuid` binary(16) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `map_id_internal_id_idx` (`map_id`,`internal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table current_wells
# ------------------------------------------------------------

CREATE TABLE `current_wells` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gel_pass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `current_volume` float DEFAULT NULL,
  `buffer_volume` float DEFAULT NULL,
  `requested_volume` float DEFAULT NULL,
  `picked_volume` float DEFAULT NULL,
  `pico_pass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_uuid` binary(16) DEFAULT NULL,
  `measured_volume` decimal(5,2) DEFAULT NULL,
  `sequenom_count` int(11) DEFAULT NULL,
  `gender_markers` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotyping_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotyping_snp_plate_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `display_name` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `internal_id_idx` (`internal_id`),
  UNIQUE KEY `uuid_idx` (`uuid`),
  KEY `inserted_at_idx` (`inserted_at`),
  KEY `plate_barcode_plate_barcode_prefix_map_idx` (`plate_barcode`,`plate_barcode_prefix`,`map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table ebi_submission_stats
# ------------------------------------------------------------

CREATE TABLE `ebi_submission_stats` (
  `week_beginning` date NOT NULL,
  `ena_bp` bigint(20) DEFAULT NULL,
  `ega_bp` bigint(20) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`week_beginning`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table ega_datasets
# ------------------------------------------------------------

CREATE TABLE `ega_datasets` (
  `ebi_study_acc` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dataset_acc` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_id` int(4) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `index_study_id` (`study_id`),
  KEY `index_study_acc` (`ebi_study_acc`),
  KEY `index_dataset_acc` (`dataset_acc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table events
# ------------------------------------------------------------

CREATE TABLE `events` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `source_internal_id` int(11) DEFAULT NULL,
  `source_uuid` binary(16) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actioned` tinyint(1) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `of_interest_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descriptor_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table lanes
# ------------------------------------------------------------

CREATE TABLE `lanes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `external_release` tinyint(1) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table library_tubes
# ------------------------------------------------------------

CREATE TABLE `library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `volume` decimal(10,2) DEFAULT NULL,
  `concentration` decimal(18,2) DEFAULT NULL,
  `tag_uuid` binary(16) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `expected_sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_group_uuid` binary(16) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `source_request_internal_id` int(11) DEFAULT NULL,
  `source_request_uuid` binary(16) DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `multiplexed_library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table npg_information
# ------------------------------------------------------------

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
  `instrument_name` char(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instrument_model` char(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `manual_qc` tinyint(1) unsigned DEFAULT NULL,
  `clusters_raw` bigint(20) unsigned DEFAULT NULL,
  `raw_cluster_density` double(12,3) unsigned DEFAULT NULL,
  `pf_cluster_density` double(12,3) unsigned DEFAULT NULL,
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
  `contaminants_scan_hit1_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminants_scan_hit1_score` float(6,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit2_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminants_scan_hit2_score` float(6,2) unsigned DEFAULT NULL,
  `ref_match1_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `run_pending` datetime DEFAULT NULL,
  `qc_complete` datetime DEFAULT NULL,
  `tags_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `tags_decode_cv` float(6,2) unsigned DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `project_id` int(11) unsigned DEFAULT NULL,
  `request_id` int(11) unsigned DEFAULT NULL,
  `lane_type` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spike_tag_index` smallint(5) unsigned DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_forward_read` bigint(20) unsigned DEFAULT NULL,
  `q30_yield_kb_reverse_read` bigint(20) unsigned DEFAULT NULL,
  `q40_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `split_human_percent` float(5,2) DEFAULT NULL,
  `split_phix_percent` float(5,2) DEFAULT NULL,
  `bam_num_reads` bigint(20) unsigned DEFAULT NULL,
  `bam_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_human_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_human_percent_duplicate` float(5,2) DEFAULT NULL,
  `genotype_sample_name_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_sample_name_relaxed_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_mean_depth` float(7,2) DEFAULT NULL,
  `verify_bam_id_average_depth` float(11,2) unsigned DEFAULT NULL,
  `verify_bam_id_score` float(6,5) unsigned DEFAULT NULL,
  `verify_bam_id_snp_count` int(10) unsigned DEFAULT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table npg_plex_information
# ------------------------------------------------------------

CREATE TABLE `npg_plex_information` (
  `batch_id` bigint(20) unsigned NOT NULL,
  `id_run` bigint(20) unsigned NOT NULL,
  `position` int(1) unsigned NOT NULL,
  `tag_index` smallint(5) unsigned NOT NULL,
  `asset_id` int(11) unsigned DEFAULT NULL,
  `asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_id` int(11) unsigned DEFAULT NULL,
  `study_id` int(11) unsigned DEFAULT NULL,
  `project_id` int(11) unsigned DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
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
  `contaminants_scan_hit1_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminants_scan_hit1_score` float(6,2) unsigned DEFAULT NULL,
  `contaminants_scan_hit2_name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminants_scan_hit2_score` float(6,2) unsigned DEFAULT NULL,
  `ref_match1_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `tag_sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_decode_percent` float(5,2) unsigned DEFAULT NULL,
  `tag_decode_count` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q30_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_forward_read` int(10) unsigned DEFAULT NULL,
  `q40_yield_kb_reverse_read` int(10) unsigned DEFAULT NULL,
  `bam_num_reads` bigint(20) unsigned DEFAULT NULL,
  `bam_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_human_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_human_percent_duplicate` float(5,2) DEFAULT NULL,
  `genotype_sample_name_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_sample_name_relaxed_match` varchar(8) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotype_mean_depth` float(7,2) DEFAULT NULL,
  `mean_bait_coverage` float(6,2) unsigned DEFAULT NULL,
  `on_bait_percent` float(5,2) unsigned DEFAULT NULL,
  `on_or_near_bait_percent` float(5,2) unsigned DEFAULT NULL,
  `verify_bam_id_average_depth` float(11,2) unsigned DEFAULT NULL,
  `verify_bam_id_score` float(6,5) unsigned DEFAULT NULL,
  `verify_bam_id_snp_count` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_run`,`position`,`tag_index`),
  KEY `npg_plex_asset_id_index` (`asset_id`),
  KEY `npg_plex_asset_name_index` (`asset_name`),
  KEY `npg_plex_sample_id_index` (`sample_id`),
  KEY `npg_plex_study_id_index` (`study_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table npg_run_status
# ------------------------------------------------------------

CREATE TABLE `npg_run_status` (
  `id_run_status` int(11) NOT NULL DEFAULT '0',
  `id_run` bigint(20) unsigned NOT NULL,
  `date` datetime DEFAULT NULL,
  `id_run_status_dict` int(11) NOT NULL,
  `iscurrent` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_run_status`),
  KEY `npg_id_rsd` (`id_run_status_dict`),
  KEY `npg_run_date_state` (`id_run`,`date`,`id_run_status_dict`),
  KEY `npg_rs_iscurrent` (`iscurrent`),
  CONSTRAINT `npg_id_rsd` FOREIGN KEY (`id_run_status_dict`) REFERENCES `npg_run_status_dict` (`id_run_status_dict`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table npg_run_status_dict
# ------------------------------------------------------------

CREATE TABLE `npg_run_status_dict` (
  `id_run_status_dict` int(11) NOT NULL DEFAULT '0',
  `description` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `iscurrent` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `temporal_index` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_run_status_dict`),
  KEY `npg_status_description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table orders
# ------------------------------------------------------------

CREATE TABLE `orders` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `template_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `comments` text COLLATE utf8_unicode_ci,
  `inserted_at` datetime DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `fragment_size_required_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_required_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sequencing_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `insert_size` int(11) DEFAULT NULL,
  `number_of_lanes` int(11) DEFAULT NULL,
  `submission_uuid` binary(16) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table pac_bio_library_tubes
# ------------------------------------------------------------

CREATE TABLE `pac_bio_library_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prep_kit_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `binding_kit_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `smrt_cells_available` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `movie_length` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `protocol` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table plate_purposes
# ------------------------------------------------------------

CREATE TABLE `plate_purposes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table plates
# ------------------------------------------------------------

CREATE TABLE `plates` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_size` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_purpose_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_purpose_internal_id` int(11) DEFAULT NULL,
  `plate_purpose_uuid` binary(16) DEFAULT NULL,
  `infinium_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `fluidigm_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table project_users
# ------------------------------------------------------------

CREATE TABLE `project_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_internal_id` int(11) NOT NULL,
  `project_uuid` binary(16) NOT NULL,
  `role` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `login` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table projects
# ------------------------------------------------------------

CREATE TABLE `projects` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `collaborators` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `funding_comments` text COLLATE utf8_unicode_ci,
  `cost_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `funding_model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `budget_division` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `external_funding_source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_manager` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `budget_cost_centre` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table quotas
# ------------------------------------------------------------

CREATE TABLE `quotas` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `quota_limit` int(11) DEFAULT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table reference_genomes
# ------------------------------------------------------------

CREATE TABLE `reference_genomes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table requests
# ------------------------------------------------------------

CREATE TABLE `requests` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `request_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fragment_size_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `library_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `project_uuid` binary(16) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_uuid` binary(16) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_closed` tinyint(1) DEFAULT NULL,
  `source_asset_two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_asset_sample_uuid` binary(16) DEFAULT NULL,
  `source_asset_sample_internal_id` int(11) DEFAULT NULL,
  `target_asset_uuid` binary(16) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_barcode_prefix` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_closed` tinyint(1) DEFAULT NULL,
  `target_asset_two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_asset_sample_uuid` binary(16) DEFAULT NULL,
  `target_asset_sample_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `state` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `user` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `submission_uuid` binary(16) DEFAULT NULL,
  `submission_internal_id` int(11) DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table sample_tubes
# ------------------------------------------------------------

CREATE TABLE `sample_tubes` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table samples
# ------------------------------------------------------------

CREATE TABLE `samples` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference_genome` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `organism` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accession_number` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `common_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `taxon_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `father` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mother` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `replicate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ethnicity` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cohort` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_of_origin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `geographical_region` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `sanger_sample_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `control` tinyint(1) DEFAULT NULL,
  `empty_supplier_sample_name` tinyint(1) DEFAULT NULL,
  `supplier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `public_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `strain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_by_manifest` tinyint(1) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `consent_withdrawn` tinyint(1) NOT NULL DEFAULT '0',
  `donor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table schema_migrations
# ------------------------------------------------------------

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table studies
# ------------------------------------------------------------

CREATE TABLE `studies` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
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
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `contains_human_dna` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contaminated_human_dna` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_strategy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_sort_of_study` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ena_project_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `study_visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_dac_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `array_express_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ega_policy_accession_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `data_release_timing` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_period` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_release_delay_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remove_x_and_autosomes` tinyint(1) NOT NULL DEFAULT '0',
  `alignments_in_bam` tinyint(1) NOT NULL DEFAULT '1',
  `separate_y_chromosome_data` tinyint(1) NOT NULL DEFAULT '0',
  `data_access_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prelim_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table study_samples
# ------------------------------------------------------------

CREATE TABLE `study_samples` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_uuid` binary(16) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table study_users
# ------------------------------------------------------------

CREATE TABLE `study_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `study_internal_id` int(11) NOT NULL,
  `study_uuid` binary(16) NOT NULL,
  `role` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `login` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table submissions
# ------------------------------------------------------------

CREATE TABLE `submissions` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table submitted_assets
# ------------------------------------------------------------

CREATE TABLE `submitted_assets` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_uuid` binary(16) DEFAULT NULL,
  `asset_uuid` binary(16) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `submission_uuid_and_asset_uuid_idx` (`order_uuid`,`asset_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table tags
# ------------------------------------------------------------

CREATE TABLE `tags` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `expected_sequence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tag_group_uuid` binary(16) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table wells
# ------------------------------------------------------------

CREATE TABLE `wells` (
  `uuid` binary(16) NOT NULL,
  `internal_id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `map` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_barcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plate_barcode_prefix` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sample_uuid` binary(16) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gel_pass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `concentration` decimal(10,2) DEFAULT NULL,
  `current_volume` float DEFAULT NULL,
  `buffer_volume` float DEFAULT NULL,
  `requested_volume` float DEFAULT NULL,
  `picked_volume` float DEFAULT NULL,
  `pico_pass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL,
  `checked_at` datetime NOT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_uuid` binary(16) DEFAULT NULL,
  `measured_volume` decimal(5,2) DEFAULT NULL,
  `sequenom_count` int(11) DEFAULT NULL,
  `gender_markers` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotyping_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `genotyping_snp_plate_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `current_from` datetime NOT NULL,
  `current_to` datetime DEFAULT NULL,
  `display_name` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `uuid_and_current_from_and_current_to_idx` (`uuid`,`current_from`,`current_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
