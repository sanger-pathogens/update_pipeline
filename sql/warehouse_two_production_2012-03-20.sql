# ************************************************************
# Sequel Pro SQL dump
# Version 3408
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: mcs7 (MySQL 5.1.39-log)
# Database: warehouse_two_production
# Generation Time: 2012-03-20 16:52:13 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table a
# ------------------------------------------------------------

CREATE TABLE `a` (
  `now()` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table aliquots
# ------------------------------------------------------------

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



# Dump of table asset_audits
# ------------------------------------------------------------

CREATE TABLE `asset_audits` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `asset_barcode` varchar(255) DEFAULT NULL,
  `asset_barcode_prefix` varchar(255) DEFAULT NULL,
  `asset_uuid` varchar(36) DEFAULT NULL,
  `witnessed_by` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_asset_audits_on_created_by` (`created_by`),
  KEY `index_asset_audits_on_key` (`key`),
  KEY `index_asset_audits_on_uuid` (`uuid`),
  KEY `index_asset_audits_on_internal_id` (`internal_id`),
  KEY `index_asset_audits_on_last_updated` (`last_updated`),
  KEY `index_asset_audits_on_created` (`created`),
  KEY `index_asset_audits_on_asset_uuid` (`asset_uuid`),
  KEY `index_asset_audits_on_asset_barcode` (`asset_barcode`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table asset_freezers
# ------------------------------------------------------------

CREATE TABLE `asset_freezers` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `asset_type` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(255) DEFAULT NULL,
  `building` varchar(255) DEFAULT NULL,
  `room` varchar(255) DEFAULT NULL,
  `freezer` varchar(255) DEFAULT NULL,
  `shelf` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_asset_freezers_on_uuid` (`uuid`),
  KEY `index_asset_freezers_on_internal_id` (`internal_id`),
  KEY `index_asset_freezers_on_name` (`name`),
  KEY `index_asset_freezers_on_asset_type` (`asset_type`),
  KEY `index_asset_freezers_on_barcode` (`barcode`),
  KEY `index_asset_freezers_on_barcode_prefix` (`barcode_prefix`),
  KEY `index_asset_freezers_on_building` (`building`),
  KEY `index_asset_freezers_on_room` (`room`),
  KEY `index_asset_freezers_on_freezer` (`freezer`),
  KEY `index_asset_freezers_on_shelf` (`shelf`),
  KEY `index_asset_freezers_on_is_current` (`is_current`),
  KEY `index_asset_freezers_on_checked_at` (`checked_at`),
  KEY `index_asset_freezers_on_last_updated` (`last_updated`),
  KEY `index_asset_freezers_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table asset_links
# ------------------------------------------------------------

CREATE TABLE `asset_links` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) DEFAULT NULL,
  `ancestor_uuid` varchar(36) DEFAULT NULL,
  `ancestor_internal_id` int(11) DEFAULT NULL,
  `ancestor_type` varchar(255) DEFAULT NULL,
  `descendant_uuid` varchar(36) DEFAULT NULL,
  `descendant_internal_id` int(11) DEFAULT NULL,
  `descendant_type` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_asset_links_on_ancestor_uuid` (`ancestor_uuid`),
  KEY `index_asset_links_on_uuid` (`uuid`),
  KEY `index_asset_links_on_ancestor_internal_id` (`ancestor_internal_id`),
  KEY `index_asset_links_on_descendant_uuid` (`descendant_uuid`),
  KEY `index_asset_links_on_descendant_internal_id` (`descendant_internal_id`),
  KEY `index_asset_links_on_checked_at` (`checked_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table batch_requests
# ------------------------------------------------------------

CREATE TABLE `batch_requests` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `batch_uuid` varchar(36) DEFAULT NULL,
  `batch_internal_id` int(11) DEFAULT NULL,
  `request_uuid` varchar(36) DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `source_asset_uuid` varchar(36) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_name` varchar(255) DEFAULT NULL,
  `target_asset_uuid` varchar(36) DEFAULT NULL,
  `target_asset_internal_id` int(11) DEFAULT NULL,
  `target_asset_name` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_batch_requests_on_uuid` (`uuid`),
  KEY `index_batch_requests_on_internal_id` (`internal_id`),
  KEY `index_batch_requests_on_batch_uuid` (`batch_uuid`),
  KEY `index_batch_requests_on_batch_internal_id` (`batch_internal_id`),
  KEY `index_batch_requests_on_request_uuid` (`request_uuid`),
  KEY `index_batch_requests_on_request_internal_id` (`request_internal_id`),
  KEY `index_batch_requests_on_source_asset_uuid` (`source_asset_uuid`),
  KEY `index_batch_requests_on_source_asset_internal_id` (`source_asset_internal_id`),
  KEY `index_batch_requests_on_source_asset_name` (`source_asset_name`),
  KEY `index_batch_requests_on_target_asset_uuid` (`target_asset_uuid`),
  KEY `index_batch_requests_on_target_asset_internal_id` (`target_asset_internal_id`),
  KEY `index_batch_requests_on_target_asset_name` (`target_asset_name`),
  KEY `index_batch_requests_on_is_current` (`is_current`),
  KEY `index_batch_requests_on_checked_at` (`checked_at`),
  KEY `index_batch_requests_on_last_updated` (`last_updated`),
  KEY `index_batch_requests_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table batches
# ------------------------------------------------------------

CREATE TABLE `batches` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `created_by` varchar(30) DEFAULT NULL,
  `assigned_to` varchar(30) DEFAULT NULL,
  `pipeline_name` varchar(255) DEFAULT NULL,
  `pipeline_uuid` varchar(36) DEFAULT NULL,
  `pipeline_internal_id` int(11) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `qc_state` varchar(50) DEFAULT NULL,
  `production_state` varchar(50) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_batches_on_uuid` (`uuid`),
  KEY `index_batches_on_internal_id` (`internal_id`),
  KEY `index_batches_on_created_by` (`created_by`),
  KEY `index_batches_on_pipeline_uuid` (`pipeline_uuid`),
  KEY `index_batches_on_pipeline_internal_id` (`pipeline_internal_id`),
  KEY `index_batches_on_state` (`state`),
  KEY `index_batches_on_qc_state` (`qc_state`),
  KEY `index_batches_on_is_current` (`is_current`),
  KEY `index_batches_on_checked_at` (`checked_at`),
  KEY `index_batches_on_last_updated` (`last_updated`),
  KEY `index_batches_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table billing_events
# ------------------------------------------------------------

CREATE TABLE `billing_events` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` varchar(36) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `division` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `request_internal_id` int(11) DEFAULT NULL,
  `request_uuid` varchar(36) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `cost_code` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `quantity` float DEFAULT '1',
  `kind` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `entry_date` datetime DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_billing_events_on_uuid` (`uuid`),
  KEY `index_billing_events_on_internal_id` (`internal_id`),
  KEY `index_billing_events_on_reference` (`reference`),
  KEY `index_billing_events_on_project_internal_id` (`project_internal_id`),
  KEY `index_billing_events_on_project_uuid` (`project_uuid`),
  KEY `index_billing_events_on_project_name` (`project_name`),
  KEY `index_billing_events_on_division` (`division`),
  KEY `index_billing_events_on_created_by` (`created_by`),
  KEY `index_billing_events_on_request_internal_id` (`request_internal_id`),
  KEY `index_billing_events_on_request_uuid` (`request_uuid`),
  KEY `index_billing_events_on_request_type` (`request_type`),
  KEY `index_billing_events_on_library_type` (`library_type`),
  KEY `index_billing_events_on_cost_code` (`cost_code`),
  KEY `index_billing_events_on_price` (`price`),
  KEY `index_billing_events_on_quantity` (`quantity`),
  KEY `index_billing_events_on_kind` (`kind`),
  KEY `index_billing_events_on_description` (`description`),
  KEY `index_billing_events_on_is_current` (`is_current`),
  KEY `index_billing_events_on_entry_date` (`entry_date`),
  KEY `index_billing_events_on_checked_at` (`checked_at`),
  KEY `index_billing_events_on_last_updated` (`last_updated`),
  KEY `index_billing_events_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table current_asset_audits
# ------------------------------------------------------------

CREATE TABLE `current_asset_audits` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `key` VARCHAR(255) DEFAULT NULL,
   `message` VARCHAR(255) DEFAULT NULL,
   `created_by` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `asset_barcode` VARCHAR(255) DEFAULT NULL,
   `asset_barcode_prefix` VARCHAR(255) DEFAULT NULL,
   `asset_uuid` VARCHAR(36) DEFAULT NULL,
   `witnessed_by` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_asset_freezers
# ------------------------------------------------------------

CREATE TABLE `current_asset_freezers` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `asset_type` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(255) DEFAULT NULL,
   `building` VARCHAR(255) DEFAULT NULL,
   `room` VARCHAR(255) DEFAULT NULL,
   `freezer` VARCHAR(255) DEFAULT NULL,
   `shelf` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_asset_links
# ------------------------------------------------------------

CREATE TABLE `current_asset_links` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) DEFAULT NULL,
   `ancestor_uuid` VARCHAR(36) DEFAULT NULL,
   `ancestor_internal_id` INT(11) DEFAULT NULL,
   `ancestor_type` VARCHAR(255) DEFAULT NULL,
   `descendant_uuid` VARCHAR(36) DEFAULT NULL,
   `descendant_internal_id` INT(11) DEFAULT NULL,
   `descendant_type` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_batch_requests
# ------------------------------------------------------------

CREATE TABLE `current_batch_requests` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `batch_uuid` VARCHAR(36) DEFAULT NULL,
   `batch_internal_id` INT(11) DEFAULT NULL,
   `request_uuid` VARCHAR(36) DEFAULT NULL,
   `request_internal_id` INT(11) DEFAULT NULL,
   `request_type` VARCHAR(255) DEFAULT NULL,
   `source_asset_uuid` VARCHAR(36) DEFAULT NULL,
   `source_asset_internal_id` INT(11) DEFAULT NULL,
   `source_asset_name` VARCHAR(255) DEFAULT NULL,
   `target_asset_uuid` VARCHAR(36) DEFAULT NULL,
   `target_asset_internal_id` INT(11) DEFAULT NULL,
   `target_asset_name` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_batches
# ------------------------------------------------------------

CREATE TABLE `current_batches` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `created_by` VARCHAR(30) DEFAULT NULL,
   `assigned_to` VARCHAR(30) DEFAULT NULL,
   `pipeline_name` VARCHAR(255) DEFAULT NULL,
   `pipeline_uuid` VARCHAR(36) DEFAULT NULL,
   `pipeline_internal_id` INT(11) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `qc_state` VARCHAR(50) DEFAULT NULL,
   `production_state` VARCHAR(50) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_billing_events
# ------------------------------------------------------------

CREATE TABLE `current_billing_events` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `reference` VARCHAR(255) DEFAULT NULL,
   `project_internal_id` INT(11) DEFAULT NULL,
   `project_uuid` VARCHAR(36) DEFAULT NULL,
   `project_name` VARCHAR(255) DEFAULT NULL,
   `division` VARCHAR(255) DEFAULT NULL,
   `created_by` VARCHAR(255) DEFAULT NULL,
   `request_internal_id` INT(11) DEFAULT NULL,
   `request_uuid` VARCHAR(36) DEFAULT NULL,
   `request_type` VARCHAR(255) DEFAULT NULL,
   `library_type` VARCHAR(255) DEFAULT NULL,
   `cost_code` VARCHAR(255) DEFAULT NULL,
   `price` INT(11) DEFAULT NULL,
   `quantity` FLOAT DEFAULT '1',
   `kind` VARCHAR(255) DEFAULT NULL,
   `description` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `entry_date` DATETIME DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_events
# ------------------------------------------------------------

CREATE TABLE `current_events` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `source_internal_id` INT(11) DEFAULT NULL,
   `source_uuid` VARCHAR(36) DEFAULT NULL,
   `source_type` VARCHAR(255) DEFAULT NULL,
   `message` VARCHAR(255) DEFAULT NULL,
   `state` VARCHAR(255) DEFAULT NULL,
   `identifier` VARCHAR(255) DEFAULT NULL,
   `location` VARCHAR(255) DEFAULT NULL,
   `actioned` TINYINT(1) DEFAULT NULL,
   `content` TEXT DEFAULT NULL,
   `created_by` VARCHAR(255) DEFAULT NULL,
   `of_interest_to` VARCHAR(255) DEFAULT NULL,
   `descriptor_key` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_lanes
# ------------------------------------------------------------

CREATE TABLE `current_lanes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `closed` TINYINT(1) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `external_release` TINYINT(1) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `scanned_in_date` DATE DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_library_tubes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `closed` TINYINT(1) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `sample_uuid` VARCHAR(36) DEFAULT NULL,
   `sample_internal_id` INT(11) DEFAULT NULL,
   `volume` DECIMAL(5) DEFAULT NULL,
   `concentration` DECIMAL(5) DEFAULT NULL,
   `tag_uuid` VARCHAR(36) DEFAULT NULL,
   `tag_internal_id` INT(11) DEFAULT NULL,
   `expected_sequence` VARCHAR(255) DEFAULT NULL,
   `tag_map_id` INT(11) DEFAULT NULL,
   `tag_group_name` VARCHAR(255) DEFAULT NULL,
   `tag_group_uuid` VARCHAR(36) DEFAULT NULL,
   `tag_group_internal_id` INT(11) DEFAULT NULL,
   `source_request_internal_id` INT(11) DEFAULT NULL,
   `source_request_uuid` VARCHAR(36) DEFAULT NULL,
   `library_type` VARCHAR(255) DEFAULT NULL,
   `fragment_size_required_from` VARCHAR(255) DEFAULT NULL,
   `fragment_size_required_to` VARCHAR(255) DEFAULT NULL,
   `sample_name` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `scanned_in_date` DATE DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `public_name` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_multiplexed_library_tubes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `closed` TINYINT(1) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `volume` DECIMAL(5) DEFAULT NULL,
   `concentration` DECIMAL(5) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `scanned_in_date` DATE DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `public_name` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_plate_purposes
# ------------------------------------------------------------

CREATE TABLE `current_plate_purposes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_plates
# ------------------------------------------------------------

CREATE TABLE `current_plates` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `plate_size` INT(11) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `plate_purpose_name` VARCHAR(255) DEFAULT NULL,
   `plate_purpose_internal_id` INT(11) DEFAULT NULL,
   `plate_purpose_uuid` VARCHAR(36) DEFAULT NULL,
   `infinium_barcode` VARCHAR(255) DEFAULT NULL,
   `location` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_projects
# ------------------------------------------------------------

CREATE TABLE `current_projects` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `collaborators` VARCHAR(255) DEFAULT NULL,
   `funding_comments` TEXT DEFAULT NULL,
   `cost_code` VARCHAR(255) DEFAULT NULL,
   `funding_model` VARCHAR(255) DEFAULT NULL,
   `approved` TINYINT(1) DEFAULT NULL,
   `budget_division` VARCHAR(255) DEFAULT NULL,
   `external_funding_source` VARCHAR(255) DEFAULT NULL,
   `project_manager` VARCHAR(255) DEFAULT NULL,
   `budget_cost_centre` VARCHAR(255) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_pulldown_multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `current_pulldown_multiplexed_library_tubes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `closed` TINYINT(1) DEFAULT NULL,
   `concentration` DECIMAL(5) DEFAULT NULL,
   `volume` DECIMAL(5) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `scanned_in_date` DATE DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `public_name` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_quotas
# ------------------------------------------------------------

CREATE TABLE `current_quotas` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `quota_limit` INT(11) DEFAULT NULL,
   `request_type` VARCHAR(255) DEFAULT NULL,
   `project_internal_id` INT(11) DEFAULT NULL,
   `project_uuid` VARCHAR(36) DEFAULT NULL,
   `project_name` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_requests
# ------------------------------------------------------------

CREATE TABLE `current_requests` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `request_type` VARCHAR(255) DEFAULT NULL,
   `fragment_size_from` VARCHAR(255) DEFAULT NULL,
   `fragment_size_to` VARCHAR(255) DEFAULT NULL,
   `read_length` INT(11) DEFAULT NULL,
   `library_type` VARCHAR(255) DEFAULT NULL,
   `study_uuid` VARCHAR(36) DEFAULT NULL,
   `study_internal_id` INT(11) DEFAULT NULL,
   `study_name` VARCHAR(255) DEFAULT NULL,
   `project_uuid` VARCHAR(36) DEFAULT NULL,
   `project_internal_id` INT(11) DEFAULT NULL,
   `project_name` VARCHAR(255) DEFAULT NULL,
   `source_asset_uuid` VARCHAR(36) DEFAULT NULL,
   `source_asset_internal_id` INT(11) DEFAULT NULL,
   `source_asset_type` VARCHAR(50) DEFAULT NULL,
   `source_asset_name` VARCHAR(255) DEFAULT NULL,
   `source_asset_barcode` VARCHAR(255) DEFAULT NULL,
   `source_asset_barcode_prefix` VARCHAR(255) DEFAULT NULL,
   `source_asset_state` VARCHAR(255) DEFAULT NULL,
   `source_asset_closed` VARCHAR(255) DEFAULT NULL,
   `source_asset_two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `source_asset_sample_uuid` VARCHAR(36) DEFAULT NULL,
   `source_asset_sample_internal_id` INT(11) DEFAULT NULL,
   `target_asset_uuid` VARCHAR(36) DEFAULT NULL,
   `target_asset_internal_id` INT(11) DEFAULT NULL,
   `target_asset_type` VARCHAR(50) DEFAULT NULL,
   `target_asset_name` VARCHAR(255) DEFAULT NULL,
   `target_asset_barcode` VARCHAR(255) DEFAULT NULL,
   `target_asset_barcode_prefix` VARCHAR(255) DEFAULT NULL,
   `target_asset_state` VARCHAR(255) DEFAULT NULL,
   `target_asset_closed` VARCHAR(255) DEFAULT NULL,
   `target_asset_two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `target_asset_sample_uuid` VARCHAR(36) DEFAULT NULL,
   `target_asset_sample_internal_id` INT(11) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `state` VARCHAR(40) DEFAULT NULL,
   `priority` INT(11) DEFAULT NULL,
   `user` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_sample_tubes
# ------------------------------------------------------------

CREATE TABLE `current_sample_tubes` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `closed` TINYINT(1) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `sample_uuid` VARCHAR(36) DEFAULT NULL,
   `sample_internal_id` INT(11) DEFAULT NULL,
   `sample_name` VARCHAR(255) DEFAULT NULL,
   `scanned_in_date` DATE DEFAULT NULL,
   `volume` DECIMAL(5) DEFAULT NULL,
   `concentration` DECIMAL(5) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_samples
# ------------------------------------------------------------

CREATE TABLE `current_samples` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `reference_genome` VARCHAR(255) DEFAULT NULL,
   `organism` VARCHAR(255) DEFAULT NULL,
   `accession_number` VARCHAR(50) DEFAULT NULL,
   `common_name` VARCHAR(255) DEFAULT NULL,
   `description` TEXT DEFAULT NULL,
   `taxon_id` VARCHAR(255) DEFAULT NULL,
   `father` VARCHAR(255) DEFAULT NULL,
   `mother` VARCHAR(255) DEFAULT NULL,
   `replicate` VARCHAR(255) DEFAULT NULL,
   `ethnicity` VARCHAR(255) DEFAULT NULL,
   `gender` VARCHAR(20) DEFAULT NULL,
   `cohort` VARCHAR(255) DEFAULT NULL,
   `country_of_origin` VARCHAR(255) DEFAULT NULL,
   `geographical_region` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `sanger_sample_id` VARCHAR(255) DEFAULT NULL,
   `control` TINYINT(1) DEFAULT NULL,
   `empty_supplier_sample_name` TINYINT(1) DEFAULT NULL,
   `supplier_name` VARCHAR(255) DEFAULT NULL,
   `public_name` VARCHAR(255) DEFAULT NULL,
   `sample_visibility` VARCHAR(255) DEFAULT NULL,
   `strain` VARCHAR(255) DEFAULT NULL,
   `updated_by_manifest` TINYINT(1) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_studies
# ------------------------------------------------------------

CREATE TABLE `current_studies` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `reference_genome` VARCHAR(255) DEFAULT NULL,
   `ethically_approved` TINYINT(1) DEFAULT NULL,
   `faculty_sponsor` VARCHAR(255) DEFAULT NULL,
   `state` VARCHAR(50) DEFAULT NULL,
   `study_type` VARCHAR(50) DEFAULT NULL,
   `abstract` TEXT DEFAULT NULL,
   `abbreviation` VARCHAR(255) DEFAULT NULL,
   `accession_number` VARCHAR(50) DEFAULT NULL,
   `description` TEXT DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `contains_human_dna` VARCHAR(255) DEFAULT NULL,
   `contaminated_human_dna` VARCHAR(255) DEFAULT NULL,
   `data_release_strategy` VARCHAR(255) DEFAULT NULL,
   `data_release_sort_of_study` VARCHAR(255) DEFAULT NULL,
   `ena_project_id` VARCHAR(255) DEFAULT NULL,
   `study_title` VARCHAR(255) DEFAULT NULL,
   `study_visibility` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL,
   `ega_dac_accession_number` VARCHAR(255) DEFAULT NULL,
   `array_express_accession_number` VARCHAR(255) DEFAULT NULL,
   `ega_policy_accession_number` VARCHAR(255) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_study_samples
# ------------------------------------------------------------

CREATE TABLE `current_study_samples` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) DEFAULT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `sample_internal_id` INT(11) DEFAULT NULL,
   `sample_uuid` VARCHAR(36) DEFAULT NULL,
   `study_internal_id` INT(11) DEFAULT NULL,
   `study_uuid` VARCHAR(36) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_submissions
# ------------------------------------------------------------

CREATE TABLE `current_submissions` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `created_by` VARCHAR(255) DEFAULT NULL,
   `template_name` VARCHAR(255) DEFAULT NULL,
   `state` VARCHAR(255) DEFAULT NULL,
   `study_name` VARCHAR(255) DEFAULT NULL,
   `study_uuid` VARCHAR(36) DEFAULT NULL,
   `project_name` VARCHAR(255) DEFAULT NULL,
   `project_uuid` VARCHAR(36) DEFAULT NULL,
   `message` VARCHAR(255) DEFAULT NULL,
   `comments` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL,
   `read_length` INT(11) DEFAULT NULL,
   `fragment_size_required_from` VARCHAR(255) DEFAULT NULL,
   `fragment_size_required_to` VARCHAR(255) DEFAULT NULL,
   `library_type` VARCHAR(255) DEFAULT NULL,
   `sequencing_type` VARCHAR(255) DEFAULT NULL,
   `insert_size` INT(11) DEFAULT NULL,
   `number_of_lanes` INT(11) DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_tag_instances
# ------------------------------------------------------------

CREATE TABLE `current_tag_instances` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `barcode` VARCHAR(255) DEFAULT NULL,
   `barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `two_dimensional_barcode` VARCHAR(255) DEFAULT NULL,
   `tag_uuid` VARCHAR(36) DEFAULT NULL,
   `tag_internal_id` INT(11) DEFAULT NULL,
   `tag_expected_sequence` VARCHAR(255) DEFAULT NULL,
   `tag_map_id` INT(11) DEFAULT NULL,
   `tag_group_name` VARCHAR(255) DEFAULT NULL,
   `tag_group_uuid` VARCHAR(36) DEFAULT NULL,
   `tag_group_internal_id` INT(11) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_tags
# ------------------------------------------------------------

CREATE TABLE `current_tags` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `expected_sequence` VARCHAR(255) DEFAULT NULL,
   `map_id` INT(11) DEFAULT NULL,
   `tag_group_name` VARCHAR(255) DEFAULT NULL,
   `tag_group_uuid` VARCHAR(36) DEFAULT NULL,
   `tag_group_internal_id` INT(11) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table current_wells
# ------------------------------------------------------------

CREATE TABLE `current_wells` (
   `dont_use_id` INT(11) NOT NULL DEFAULT '0',
   `uuid` VARCHAR(36) NOT NULL,
   `internal_id` INT(11) DEFAULT NULL,
   `name` VARCHAR(255) DEFAULT NULL,
   `map` VARCHAR(5) DEFAULT NULL,
   `plate_barcode` VARCHAR(255) DEFAULT NULL,
   `plate_barcode_prefix` VARCHAR(2) DEFAULT NULL,
   `sample_uuid` VARCHAR(36) DEFAULT NULL,
   `sample_internal_id` INT(11) DEFAULT NULL,
   `sample_name` VARCHAR(255) DEFAULT NULL,
   `gel_pass` VARCHAR(255) DEFAULT NULL,
   `concentration` FLOAT DEFAULT NULL,
   `current_volume` FLOAT DEFAULT NULL,
   `buffer_volume` FLOAT DEFAULT NULL,
   `requested_volume` FLOAT DEFAULT NULL,
   `picked_volume` FLOAT DEFAULT NULL,
   `pico_pass` VARCHAR(255) DEFAULT NULL,
   `is_current` TINYINT(1) DEFAULT NULL,
   `checked_at` DATETIME DEFAULT NULL,
   `last_updated` DATETIME DEFAULT NULL,
   `created` DATETIME DEFAULT NULL,
   `plate_uuid` VARCHAR(36) DEFAULT NULL,
   `measured_volume` DECIMAL(5) DEFAULT NULL,
   `sequenom_count` INT(11) DEFAULT NULL,
   `gender_markers` VARCHAR(40) DEFAULT NULL,
   `genotyping_status` VARCHAR(255) DEFAULT NULL,
   `genotyping_snp_plate_id` VARCHAR(255) DEFAULT NULL,
   `inserted_at` DATETIME DEFAULT NULL
) ENGINE=MyISAM;



# Dump of table delayed_jobs
# ------------------------------------------------------------

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text,
  `last_error` text,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table events
# ------------------------------------------------------------

CREATE TABLE `events` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `source_internal_id` int(11) DEFAULT NULL,
  `source_uuid` varchar(36) DEFAULT NULL,
  `source_type` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `actioned` tinyint(1) DEFAULT NULL,
  `content` text,
  `created_by` varchar(255) DEFAULT NULL,
  `of_interest_to` varchar(255) DEFAULT NULL,
  `descriptor_key` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_events_on_uuid` (`uuid`),
  KEY `index_events_on_checked_at` (`checked_at`),
  KEY `index_events_on_internal_id` (`internal_id`),
  KEY `index_events_on_source_internal_id` (`source_internal_id`),
  KEY `index_events_on_source_uuid` (`source_uuid`),
  KEY `index_events_on_message` (`message`),
  KEY `index_events_on_state` (`state`),
  KEY `index_events_on_identifier` (`identifier`),
  KEY `index_events_on_last_updated` (`last_updated`),
  KEY `index_events_on_created` (`created`),
  KEY `index_events_on_is_current` (`is_current`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table lane_allocation
# ------------------------------------------------------------

CREATE TABLE `lane_allocation` (
  `cost_code` text NOT NULL,
  `budget_division` text NOT NULL,
  `library_tubes` smallint(6) DEFAULT NULL,
  `multiplexed_library_tubes` smallint(6) DEFAULT NULL,
  `37` smallint(6) DEFAULT NULL,
  `54` smallint(6) DEFAULT NULL,
  `76` smallint(6) DEFAULT NULL,
  `108` smallint(6) DEFAULT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table lanes
# ------------------------------------------------------------

CREATE TABLE `lanes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `external_release` tinyint(1) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_lanes_on_uuid` (`uuid`),
  KEY `index_lanes_on_internal_id` (`internal_id`),
  KEY `index_lanes_on_name` (`name`),
  KEY `index_lanes_on_barcode` (`barcode`),
  KEY `index_lanes_on_state` (`state`),
  KEY `index_lanes_on_external_release` (`external_release`),
  KEY `index_lanes_on_is_current` (`is_current`),
  KEY `index_lanes_on_checked_at` (`checked_at`),
  KEY `index_lanes_on_last_updated` (`last_updated`),
  KEY `index_lanes_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table library_tubes
# ------------------------------------------------------------

CREATE TABLE `library_tubes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
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
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_library_tubes_on_uuid` (`uuid`),
  KEY `index_library_tubes_on_internal_id` (`internal_id`),
  KEY `index_library_tubes_on_name` (`name`),
  KEY `index_library_tubes_on_barcode` (`barcode`),
  KEY `index_library_tubes_on_state` (`state`),
  KEY `index_library_tubes_on_sample_uuid` (`sample_uuid`),
  KEY `index_library_tubes_on_sample_internal_id` (`sample_internal_id`),
  KEY `index_library_tubes_on_sample_name` (`sample_name`),
  KEY `index_library_tubes_on_is_current` (`is_current`),
  KEY `index_library_tubes_on_checked_at` (`checked_at`),
  KEY `index_library_tubes_on_scanned_in_date` (`scanned_in_date`),
  KEY `index_library_tubes_on_last_updated` (`last_updated`),
  KEY `index_library_tubes_on_created` (`created`),
  KEY `index_library_tubes_on_tag_uuid` (`tag_uuid`),
  KEY `index_library_tubes_on_tag_internal_id` (`tag_internal_id`),
  KEY `index_library_tubes_on_tag_map_id` (`tag_map_id`),
  KEY `index_library_tubes_on_tag_group_uuid` (`tag_group_uuid`),
  KEY `index_library_tubes_on_tag_group_internal_id` (`tag_group_internal_id`),
  KEY `index_library_tubes_on_source_request_internal_id` (`source_request_internal_id`),
  KEY `index_library_tubes_on_source_request_uuid` (`source_request_uuid`),
  KEY `index_library_tubes_on_library_type` (`library_type`),
  KEY `index_library_tubes_on_fragment_size_required_from` (`fragment_size_required_from`),
  KEY `index_library_tubes_on_fragment_size_required_to` (`fragment_size_required_to`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `multiplexed_library_tubes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_multiplexed_library_tubes_on_uuid` (`uuid`),
  KEY `index_multiplexed_library_tubes_on_internal_id` (`internal_id`),
  KEY `index_multiplexed_library_tubes_on_barcode` (`barcode`),
  KEY `index_multiplexed_library_tubes_on_state` (`state`),
  KEY `index_multiplexed_library_tubes_on_is_current` (`is_current`),
  KEY `index_multiplexed_library_tubes_on_checked_at` (`checked_at`),
  KEY `index_multiplexed_library_tubes_on_scanned_in_date` (`scanned_in_date`),
  KEY `index_multiplexed_library_tubes_on_last_updated` (`last_updated`),
  KEY `index_multiplexed_library_tubes_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table npg_run_status_dict
# ------------------------------------------------------------

CREATE TABLE `npg_run_status_dict` (
  `id_run_status_dict` int(11) NOT NULL DEFAULT '0',
  `description` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_run_status_dict`),
  KEY `npg_status_description` (`description`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table old_requests
# ------------------------------------------------------------

CREATE TABLE `old_requests` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_requests_on_internal_id` (`internal_id`),
  KEY `index_requests_on_study_uuid` (`study_uuid`),
  KEY `index_requests_on_project_uuid` (`project_uuid`),
  KEY `index_requests_on_study_internal_id` (`study_internal_id`),
  KEY `index_requests_on_project_internal_id` (`project_internal_id`),
  KEY `index_requests_on_source_asset_uuid` (`source_asset_uuid`),
  KEY `index_requests_on_source_asset_internal_id` (`source_asset_internal_id`),
  KEY `index_requests_on_target_asset_uuid` (`target_asset_uuid`),
  KEY `index_requests_on_target_asset_internal_id` (`target_asset_internal_id`),
  KEY `index_requests_on_request_type` (`request_type`),
  KEY `index_requests_on_study_name` (`study_name`),
  KEY `index_requests_on_project_name` (`project_name`),
  KEY `index_requests_on_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table old_wells
# ------------------------------------------------------------

CREATE TABLE `old_wells` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `map` varchar(5) DEFAULT NULL,
  `plate_barcode` varchar(255) DEFAULT NULL,
  `plate_barcode_prefix` varchar(2) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `gel_pass` varchar(255) DEFAULT NULL,
  `concentration` float DEFAULT NULL,
  `current_volume` float DEFAULT NULL,
  `buffer_volume` float DEFAULT NULL,
  `requested_volume` float DEFAULT NULL,
  `picked_volume` float DEFAULT NULL,
  `pico_pass` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_uuid` varchar(36) DEFAULT NULL,
  `measured_volume` decimal(5,2) DEFAULT NULL,
  `sequenom_count` int(11) DEFAULT NULL,
  `gender_markers` varchar(40) DEFAULT NULL,
  `genotyping_status` varchar(255) DEFAULT NULL,
  `genotyping_snp_plate_id` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_wells_on_uuid` (`uuid`),
  KEY `index_wells_on_internal_id` (`internal_id`),
  KEY `index_wells_on_name` (`name`),
  KEY `index_wells_on_map` (`map`),
  KEY `index_wells_on_plate_barcode` (`plate_barcode`),
  KEY `index_wells_on_sample_uuid` (`sample_uuid`),
  KEY `index_wells_on_sample_internal_id` (`sample_internal_id`),
  KEY `index_wells_on_sample_name` (`sample_name`),
  KEY `index_wells_on_gel_pass` (`gel_pass`),
  KEY `index_wells_on_concentration` (`concentration`),
  KEY `index_wells_on_current_volume` (`current_volume`),
  KEY `index_wells_on_buffer_volume` (`buffer_volume`),
  KEY `index_wells_on_requested_volume` (`requested_volume`),
  KEY `index_wells_on_picked_volume` (`picked_volume`),
  KEY `index_wells_on_pico_pass` (`pico_pass`),
  KEY `index_wells_on_is_current` (`is_current`),
  KEY `index_wells_on_checked_at` (`checked_at`),
  KEY `index_wells_on_last_updated` (`last_updated`),
  KEY `index_wells_on_created` (`created`),
  KEY `index_wells_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table plate_purposes
# ------------------------------------------------------------

CREATE TABLE `plate_purposes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_plate_purposes_on_uuid` (`uuid`),
  KEY `index_plate_purposes_on_internal_id` (`internal_id`),
  KEY `index_plate_purposes_on_name` (`name`),
  KEY `index_plate_purposes_on_is_current` (`is_current`),
  KEY `index_plate_purposes_on_checked_at` (`checked_at`),
  KEY `index_plate_purposes_on_last_updated` (`last_updated`),
  KEY `index_plate_purposes_on_created` (`created`),
  KEY `index_plate_purposes_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table plates
# ------------------------------------------------------------

CREATE TABLE `plates` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `plate_size` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_purpose_name` varchar(255) DEFAULT NULL,
  `plate_purpose_internal_id` int(11) DEFAULT NULL,
  `plate_purpose_uuid` varchar(36) DEFAULT NULL,
  `infinium_barcode` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_plates_on_uuid` (`uuid`),
  KEY `index_plates_on_internal_id` (`internal_id`),
  KEY `index_plates_on_name` (`name`),
  KEY `index_plates_on_barcode` (`barcode`),
  KEY `index_plates_on_barcode_prefix` (`barcode_prefix`),
  KEY `index_plates_on_is_current` (`is_current`),
  KEY `index_plates_on_checked_at` (`checked_at`),
  KEY `index_plates_on_last_updated` (`last_updated`),
  KEY `index_plates_on_created` (`created`),
  KEY `index_plates_on_plate_purpose_internal_id` (`plate_purpose_internal_id`),
  KEY `index_plates_on_plate_purpose_uuid` (`plate_purpose_uuid`),
  KEY `index_plates_on_infinium_barcode` (`infinium_barcode`),
  KEY `index_plates_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table projects
# ------------------------------------------------------------

CREATE TABLE `projects` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `collaborators` varchar(255) DEFAULT NULL,
  `funding_comments` text,
  `cost_code` varchar(255) DEFAULT NULL,
  `funding_model` varchar(255) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT NULL,
  `budget_division` varchar(255) DEFAULT NULL,
  `external_funding_source` varchar(255) DEFAULT NULL,
  `project_manager` varchar(255) DEFAULT NULL,
  `budget_cost_centre` varchar(255) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_projects_on_uuid` (`uuid`),
  KEY `index_projects_on_internal_id` (`internal_id`),
  KEY `index_projects_on_name` (`name`),
  KEY `index_projects_on_collaborators` (`collaborators`),
  KEY `index_projects_on_cost_code` (`cost_code`),
  KEY `index_projects_on_funding_model` (`funding_model`),
  KEY `index_projects_on_approved` (`approved`),
  KEY `index_projects_on_budget_division` (`budget_division`),
  KEY `index_projects_on_external_funding_source` (`external_funding_source`),
  KEY `index_projects_on_project_manager` (`project_manager`),
  KEY `index_projects_on_budget_cost_centre` (`budget_cost_centre`),
  KEY `index_projects_on_state` (`state`),
  KEY `index_projects_on_is_current` (`is_current`),
  KEY `index_projects_on_checked_at` (`checked_at`),
  KEY `index_projects_on_last_updated` (`last_updated`),
  KEY `index_projects_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table pulldown_multiplexed_library_tubes
# ------------------------------------------------------------

CREATE TABLE `pulldown_multiplexed_library_tubes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `public_name` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_pulldown_multiplexed_library_tubes_on_uuid` (`uuid`),
  KEY `index_pulldown_multiplexed_library_tubes_on_internal_id` (`internal_id`),
  KEY `index_pulldown_multiplexed_library_tubes_on_last_updated` (`last_updated`),
  KEY `index_pulldown_multiplexed_library_tubes_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table quotas
# ------------------------------------------------------------

CREATE TABLE `quotas` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `quota_limit` int(11) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `project_internal_id` int(11) DEFAULT NULL,
  `project_uuid` varchar(36) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_quotas_on_uuid` (`uuid`),
  KEY `index_quotas_on_quota_limit` (`quota_limit`),
  KEY `index_quotas_on_request_type` (`request_type`),
  KEY `index_quotas_on_project_internal_id` (`project_internal_id`),
  KEY `index_quotas_on_project_uuid` (`project_uuid`),
  KEY `index_quotas_on_internal_id` (`internal_id`),
  KEY `index_quotas_on_is_current` (`is_current`),
  KEY `index_quotas_on_checked_at` (`checked_at`),
  KEY `index_quotas_on_last_updated` (`last_updated`),
  KEY `index_quotas_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table requests
# ------------------------------------------------------------

CREATE TABLE `requests` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_requests_on_internal_id` (`internal_id`),
  KEY `index_requests_on_study_uuid` (`study_uuid`),
  KEY `index_requests_on_project_uuid` (`project_uuid`),
  KEY `index_requests_on_study_internal_id` (`study_internal_id`),
  KEY `index_requests_on_project_internal_id` (`project_internal_id`),
  KEY `index_requests_on_source_asset_uuid` (`source_asset_uuid`),
  KEY `index_requests_on_source_asset_internal_id` (`source_asset_internal_id`),
  KEY `index_requests_on_target_asset_uuid` (`target_asset_uuid`),
  KEY `index_requests_on_target_asset_internal_id` (`target_asset_internal_id`),
  KEY `index_requests_on_request_type` (`request_type`),
  KEY `index_requests_on_study_name` (`study_name`),
  KEY `index_requests_on_project_name` (`project_name`),
  KEY `index_requests_on_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table requests_old
# ------------------------------------------------------------

CREATE TABLE `requests_old` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_requests_on_uuid` (`uuid`),
  KEY `index_requests_on_internal_id` (`internal_id`),
  KEY `index_requests_on_study_uuid` (`study_uuid`),
  KEY `index_requests_on_project_uuid` (`project_uuid`),
  KEY `index_requests_on_study_internal_id` (`study_internal_id`),
  KEY `index_requests_on_project_internal_id` (`project_internal_id`),
  KEY `index_requests_on_fragment_size_from` (`fragment_size_from`),
  KEY `index_requests_on_fragment_size_to` (`fragment_size_to`),
  KEY `index_requests_on_library_type` (`library_type`),
  KEY `index_requests_on_read_length` (`read_length`),
  KEY `index_requests_on_source_asset_uuid` (`source_asset_uuid`),
  KEY `index_requests_on_source_asset_internal_id` (`source_asset_internal_id`),
  KEY `index_requests_on_source_asset_type` (`source_asset_type`),
  KEY `index_requests_on_target_asset_uuid` (`target_asset_uuid`),
  KEY `index_requests_on_target_asset_internal_id` (`target_asset_internal_id`),
  KEY `index_requests_on_target_asset_type` (`target_asset_type`),
  KEY `index_requests_on_request_type` (`request_type`),
  KEY `index_requests_on_study_name` (`study_name`),
  KEY `index_requests_on_project_name` (`project_name`),
  KEY `index_requests_on_source_asset_name` (`source_asset_name`),
  KEY `index_requests_on_source_asset_barcode` (`source_asset_barcode`),
  KEY `index_requests_on_source_asset_barcode_prefix` (`source_asset_barcode_prefix`),
  KEY `index_requests_on_source_asset_state` (`source_asset_state`),
  KEY `index_requests_on_source_asset_closed` (`source_asset_closed`),
  KEY `index_requests_on_source_asset_two_dimensional_barcode` (`source_asset_two_dimensional_barcode`),
  KEY `index_requests_on_source_asset_sample_uuid` (`source_asset_sample_uuid`),
  KEY `index_requests_on_source_asset_sample_internal_id` (`source_asset_sample_internal_id`),
  KEY `index_requests_on_target_asset_name` (`target_asset_name`),
  KEY `index_requests_on_target_asset_barcode` (`target_asset_barcode`),
  KEY `index_requests_on_target_asset_barcode_prefix` (`target_asset_barcode_prefix`),
  KEY `index_requests_on_target_asset_state` (`target_asset_state`),
  KEY `index_requests_on_target_asset_closed` (`target_asset_closed`),
  KEY `index_requests_on_target_asset_two_dimensional_barcode` (`target_asset_two_dimensional_barcode`),
  KEY `index_requests_on_target_asset_sample_uuid` (`target_asset_sample_uuid`),
  KEY `index_requests_on_target_asset_sample_internal_id` (`target_asset_sample_internal_id`),
  KEY `index_requests_on_is_current` (`is_current`),
  KEY `index_requests_on_checked_at` (`checked_at`),
  KEY `index_requests_on_last_updated` (`last_updated`),
  KEY `index_requests_on_created` (`created`),
  KEY `index_requests_on_state` (`state`),
  KEY `index_requests_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table sample_tubes
# ------------------------------------------------------------

CREATE TABLE `sample_tubes` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `closed` tinyint(1) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `scanned_in_date` date DEFAULT NULL,
  `volume` decimal(5,2) DEFAULT NULL,
  `concentration` decimal(5,2) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_sample_tubes_on_uuid` (`uuid`),
  KEY `index_sample_tubes_on_internal_id` (`internal_id`),
  KEY `index_sample_tubes_on_name` (`name`),
  KEY `index_sample_tubes_on_barcode` (`barcode`),
  KEY `index_sample_tubes_on_state` (`state`),
  KEY `index_sample_tubes_on_closed` (`closed`),
  KEY `index_sample_tubes_on_two_dimensional_barcode` (`two_dimensional_barcode`),
  KEY `index_sample_tubes_on_sample_uuid` (`sample_uuid`),
  KEY `index_sample_tubes_on_sample_name` (`sample_name`),
  KEY `index_sample_tubes_on_volume` (`volume`),
  KEY `index_sample_tubes_on_concentration` (`concentration`),
  KEY `index_sample_tubes_on_is_current` (`is_current`),
  KEY `index_sample_tubes_on_checked_at` (`checked_at`),
  KEY `index_sample_tubes_on_sample_internal_id` (`sample_internal_id`),
  KEY `index_sample_tubes_on_scanned_in_date` (`scanned_in_date`),
  KEY `index_sample_tubes_on_last_updated` (`last_updated`),
  KEY `index_sample_tubes_on_created` (`created`),
  KEY `index_sample_tubes_on_barcode_prefix` (`barcode_prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table samples
# ------------------------------------------------------------

CREATE TABLE `samples` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_samples_on_uuid` (`uuid`),
  KEY `index_samples_on_internal_id` (`internal_id`),
  KEY `index_samples_on_name` (`name`),
  KEY `index_samples_on_reference_genome` (`reference_genome`),
  KEY `index_samples_on_organism` (`organism`),
  KEY `index_samples_on_accession_number` (`accession_number`),
  KEY `index_samples_on_common_name` (`common_name`),
  KEY `index_samples_on_taxon_id` (`taxon_id`),
  KEY `index_samples_on_father` (`father`),
  KEY `index_samples_on_mother` (`mother`),
  KEY `index_samples_on_replicate` (`replicate`),
  KEY `index_samples_on_ethnicity` (`ethnicity`),
  KEY `index_samples_on_gender` (`gender`),
  KEY `index_samples_on_cohort` (`cohort`),
  KEY `index_samples_on_country_of_origin` (`country_of_origin`),
  KEY `index_samples_on_geographical_region` (`geographical_region`),
  KEY `index_samples_on_is_current` (`is_current`),
  KEY `index_samples_on_checked_at` (`checked_at`),
  KEY `index_samples_on_last_updated` (`last_updated`),
  KEY `index_samples_on_created` (`created`),
  KEY `index_samples_on_sanger_sample_id` (`sanger_sample_id`),
  KEY `index_samples_on_control` (`control`),
  KEY `index_samples_on_empty_supplier_sample_name` (`empty_supplier_sample_name`),
  KEY `index_samples_on_supplier_name` (`supplier_name`),
  KEY `index_samples_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table schema_migrations
# ------------------------------------------------------------

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table studies
# ------------------------------------------------------------

CREATE TABLE `studies` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
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
  `ega_policy_accession_number` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_studies_on_uuid` (`uuid`),
  KEY `index_studies_on_internal_id` (`internal_id`),
  KEY `index_studies_on_name` (`name`),
  KEY `index_studies_on_reference_genome` (`reference_genome`),
  KEY `index_studies_on_ethically_approved` (`ethically_approved`),
  KEY `index_studies_on_faculty_sponsor` (`faculty_sponsor`),
  KEY `index_studies_on_state` (`state`),
  KEY `index_studies_on_study_type` (`study_type`),
  KEY `index_studies_on_abbreviation` (`abbreviation`),
  KEY `index_studies_on_accession_number` (`accession_number`),
  KEY `index_studies_on_is_current` (`is_current`),
  KEY `index_studies_on_checked_at` (`checked_at`),
  KEY `index_studies_on_last_updated` (`last_updated`),
  KEY `index_studies_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table study_samples
# ------------------------------------------------------------

CREATE TABLE `study_samples` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) DEFAULT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `study_internal_id` int(11) DEFAULT NULL,
  `study_uuid` varchar(36) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_study_samples_on_uuid` (`uuid`),
  KEY `index_study_samples_on_internal_id` (`internal_id`),
  KEY `index_study_samples_on_sample_internal_id` (`sample_internal_id`),
  KEY `index_study_samples_on_sample_uuid` (`sample_uuid`),
  KEY `index_study_samples_on_study_internal_id` (`study_internal_id`),
  KEY `index_study_samples_on_study_uuid` (`study_uuid`),
  KEY `index_study_samples_on_checked_at` (`checked_at`),
  KEY `index_study_samples_on_is_current` (`is_current`),
  KEY `index_study_samples_on_last_updated` (`last_updated`),
  KEY `index_study_samples_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table submissions
# ------------------------------------------------------------

CREATE TABLE `submissions` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `template_name` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `study_name` varchar(255) DEFAULT NULL,
  `study_uuid` varchar(36) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `project_uuid` varchar(36) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  `read_length` int(11) DEFAULT NULL,
  `fragment_size_required_from` varchar(255) DEFAULT NULL,
  `fragment_size_required_to` varchar(255) DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `sequencing_type` varchar(255) DEFAULT NULL,
  `insert_size` int(11) DEFAULT NULL,
  `number_of_lanes` int(11) DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_submissions_on_uuid` (`uuid`),
  KEY `index_submissions_on_internal_id` (`internal_id`),
  KEY `index_submissions_on_last_updated` (`last_updated`),
  KEY `index_submissions_on_created` (`created`),
  KEY `index_submissions_on_project_uuid` (`project_uuid`),
  KEY `index_submissions_on_study_uuid` (`study_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table submitted_assets
# ------------------------------------------------------------

CREATE TABLE `submitted_assets` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_uuid` varchar(255) DEFAULT NULL,
  `asset_uuid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_submitted_assets_on_submission_uuid` (`submission_uuid`),
  KEY `index_submitted_assets_on_asset_uuid` (`asset_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table tableau_bam
# ------------------------------------------------------------

CREATE TABLE `tableau_bam` (
  `bamfile` varchar(20) DEFAULT NULL,
  `sample_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `study_id` int(11) DEFAULT NULL,
  `study_name` varchar(255) DEFAULT NULL,
  `study_type` varchar(255) DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `asset_name` varchar(255) DEFAULT NULL,
  `library_created` datetime DEFAULT NULL,
  `library_type` varchar(255) DEFAULT NULL,
  `lane_state` varchar(20) DEFAULT NULL,
  `lane_type` varchar(20) DEFAULT NULL,
  `request_created` datetime DEFAULT NULL,
  `request_id` int(11) DEFAULT NULL,
  `request_type` varchar(255) DEFAULT NULL,
  `request_state` varchar(20) DEFAULT NULL,
  `fragment_size_from` varchar(255) DEFAULT NULL,
  `fragment_size_to` varchar(255) DEFAULT NULL,
  `readlength` int(3) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `project_name` varchar(255) DEFAULT NULL,
  `source_asset_internal_id` int(11) DEFAULT NULL,
  `source_asset_name` varchar(255) DEFAULT NULL,
  `source_asset_type` varchar(50) DEFAULT NULL,
  `batch_id` bigint(20) DEFAULT NULL,
  `position` int(1) DEFAULT NULL,
  `tag_group_name` varchar(255) DEFAULT NULL,
  `tag_index` smallint(5) DEFAULT NULL,
  `tag_map_id` int(11) DEFAULT NULL,
  `chip_barcode` varchar(20) DEFAULT NULL,
  `id_run` bigint(20) DEFAULT NULL,
  `instrument_model` char(64) DEFAULT NULL,
  `instrument_name` char(32) DEFAULT NULL,
  `manual_qc` tinyint(1) DEFAULT NULL,
  `run_pending` datetime DEFAULT NULL,
  `run_complete` datetime DEFAULT NULL,
  `qc_complete` datetime DEFAULT NULL,
  `raw_cluster_density` double(12,3) DEFAULT NULL,
  `pf_cluster_density` double(12,3) DEFAULT NULL,
  `tag_decode_count` int(10) DEFAULT NULL,
  `tag_decode_percent` float(5,2) DEFAULT NULL,
  `tag_sequence` varchar(255) DEFAULT NULL,
  `q20_yield_kb_forward_read` int(10) DEFAULT NULL,
  `q20_yield_kb_reverse_read` int(10) DEFAULT NULL,
  `yield` int(20) DEFAULT NULL,
  `adapters_percent_forward_read` float(4,2) DEFAULT NULL,
  `adapters_percent_reverse_read` float(4,2) DEFAULT NULL,
  `bam_human_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_human_percent_mapped` float(5,2) DEFAULT NULL,
  `bam_percent_duplicate` float(5,2) DEFAULT NULL,
  `bam_percent_mapped` float(5,2) DEFAULT NULL,
  `contaminants_scan_hit1_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit1_score` float(6,2) DEFAULT NULL,
  `contaminants_scan_hit2_name` varchar(50) DEFAULT NULL,
  `contaminants_scan_hit2_score` float(6,2) DEFAULT NULL,
  `gc_percent_forward_read` float(5,2) DEFAULT NULL,
  `gc_percent_reverse_read` float(5,2) DEFAULT NULL,
  `insert_size_median` smallint(5) DEFAULT NULL,
  `ref_match1_name` varchar(100) DEFAULT NULL,
  `ref_match1_percent` float(5,2) DEFAULT NULL,
  `ref_match2_name` varchar(100) DEFAULT NULL,
  `ref_match2_percent` float(5,2) DEFAULT NULL,
  `sequence_mismatch_percent_forward_read` float(4,2) DEFAULT NULL,
  `sequence_mismatch_percent_reverse_read` float(4,2) DEFAULT NULL,
  `country_of_origin` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table tag_instances
# ------------------------------------------------------------

CREATE TABLE `tag_instances` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `barcode_prefix` varchar(2) DEFAULT NULL,
  `two_dimensional_barcode` varchar(255) DEFAULT NULL,
  `tag_uuid` varchar(36) DEFAULT NULL,
  `tag_internal_id` int(11) DEFAULT NULL,
  `tag_expected_sequence` varchar(255) DEFAULT NULL,
  `tag_map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) DEFAULT NULL,
  `tag_group_uuid` varchar(36) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_tag_instances_on_uuid` (`uuid`),
  KEY `index_tag_instances_on_internal_id` (`internal_id`),
  KEY `index_tag_instances_on_name` (`name`),
  KEY `index_tag_instances_on_barcode` (`barcode`),
  KEY `index_tag_instances_on_barcode_prefix` (`barcode_prefix`),
  KEY `index_tag_instances_on_two_dimensional_barcode` (`two_dimensional_barcode`),
  KEY `index_tag_instances_on_tag_uuid` (`tag_uuid`),
  KEY `index_tag_instances_on_tag_internal_id` (`tag_internal_id`),
  KEY `index_tag_instances_on_tag_expected_sequence` (`tag_expected_sequence`),
  KEY `index_tag_instances_on_tag_map_id` (`tag_map_id`),
  KEY `index_tag_instances_on_tag_group_name` (`tag_group_name`),
  KEY `index_tag_instances_on_tag_group_uuid` (`tag_group_uuid`),
  KEY `index_tag_instances_on_tag_group_internal_id` (`tag_group_internal_id`),
  KEY `index_tag_instances_on_checked_at` (`checked_at`),
  KEY `index_tag_instances_on_last_updated` (`last_updated`),
  KEY `index_tag_instances_on_created` (`created`),
  KEY `index_tag_instances_on_is_current` (`is_current`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table tags
# ------------------------------------------------------------

CREATE TABLE `tags` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `expected_sequence` varchar(255) DEFAULT NULL,
  `map_id` int(11) DEFAULT NULL,
  `tag_group_name` varchar(255) DEFAULT NULL,
  `tag_group_uuid` varchar(36) DEFAULT NULL,
  `tag_group_internal_id` int(11) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_tags_on_uuid` (`uuid`),
  KEY `index_tags_on_internal_id` (`internal_id`),
  KEY `index_tags_on_expected_sequence` (`expected_sequence`),
  KEY `index_tags_on_map_id` (`map_id`),
  KEY `index_tags_on_tag_group_name` (`tag_group_name`),
  KEY `index_tags_on_tag_group_uuid` (`tag_group_uuid`),
  KEY `index_tags_on_tag_group_internal_id` (`tag_group_internal_id`),
  KEY `index_tags_on_checked_at` (`checked_at`),
  KEY `index_tags_on_last_updated` (`last_updated`),
  KEY `index_tags_on_created` (`created`),
  KEY `index_tags_on_is_current` (`is_current`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table uuid_objects
# ------------------------------------------------------------

CREATE TABLE `uuid_objects` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `object_name` varchar(255) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `deleted` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  UNIQUE KEY `index_uuid_objects_on_uuid` (`uuid`),
  KEY `index_uuid_objects_on_internal_id` (`internal_id`),
  KEY `index_uuid_objects_on_name` (`name`),
  KEY `index_uuid_objects_on_object_name` (`object_name`),
  KEY `index_uuid_objects_on_checked_at` (`checked_at`),
  KEY `index_uuid_objects_on_last_updated` (`last_updated`),
  KEY `index_uuid_objects_on_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table wells
# ------------------------------------------------------------

CREATE TABLE `wells` (
  `dont_use_id` int(11) NOT NULL AUTO_INCREMENT,
  `uuid` varchar(36) NOT NULL,
  `internal_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `map` varchar(5) DEFAULT NULL,
  `plate_barcode` varchar(255) DEFAULT NULL,
  `plate_barcode_prefix` varchar(2) DEFAULT NULL,
  `sample_uuid` varchar(36) DEFAULT NULL,
  `sample_internal_id` int(11) DEFAULT NULL,
  `sample_name` varchar(255) DEFAULT NULL,
  `gel_pass` varchar(255) DEFAULT NULL,
  `concentration` float DEFAULT NULL,
  `current_volume` float DEFAULT NULL,
  `buffer_volume` float DEFAULT NULL,
  `requested_volume` float DEFAULT NULL,
  `picked_volume` float DEFAULT NULL,
  `pico_pass` varchar(255) DEFAULT NULL,
  `is_current` tinyint(1) DEFAULT NULL,
  `checked_at` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `plate_uuid` varchar(36) DEFAULT NULL,
  `measured_volume` decimal(5,2) DEFAULT NULL,
  `sequenom_count` int(11) DEFAULT NULL,
  `gender_markers` varchar(40) DEFAULT NULL,
  `genotyping_status` varchar(255) DEFAULT NULL,
  `genotyping_snp_plate_id` varchar(255) DEFAULT NULL,
  `inserted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`dont_use_id`),
  KEY `index_wells_on_uuid` (`uuid`),
  KEY `index_wells_on_internal_id` (`internal_id`),
  KEY `index_wells_on_name` (`name`),
  KEY `index_wells_on_map` (`map`),
  KEY `index_wells_on_plate_barcode` (`plate_barcode`),
  KEY `index_wells_on_sample_uuid` (`sample_uuid`),
  KEY `index_wells_on_sample_internal_id` (`sample_internal_id`),
  KEY `index_wells_on_sample_name` (`sample_name`),
  KEY `index_wells_on_gel_pass` (`gel_pass`),
  KEY `index_wells_on_concentration` (`concentration`),
  KEY `index_wells_on_current_volume` (`current_volume`),
  KEY `index_wells_on_buffer_volume` (`buffer_volume`),
  KEY `index_wells_on_requested_volume` (`requested_volume`),
  KEY `index_wells_on_picked_volume` (`picked_volume`),
  KEY `index_wells_on_pico_pass` (`pico_pass`),
  KEY `index_wells_on_is_current` (`is_current`),
  KEY `index_wells_on_checked_at` (`checked_at`),
  KEY `index_wells_on_last_updated` (`last_updated`),
  KEY `index_wells_on_created` (`created`),
  KEY `index_wells_on_inserted_at` (`inserted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table yield
# ------------------------------------------------------------

CREATE TABLE `yield` (
  `month` bigint(20) DEFAULT NULL,
  `division` varchar(255) DEFAULT NULL,
  `id_run` bigint(20) unsigned NOT NULL DEFAULT '0',
  `instrument_model` char(64) DEFAULT NULL,
  `cycles` int(11) unsigned NOT NULL DEFAULT '0',
  `kind` varchar(255) DEFAULT NULL,
  `Samples` bigint(20) unsigned DEFAULT NULL,
  `Yield` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;





# Replace placeholder table for current_sample_tubes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_sample_tubes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_sample_tubes`
AS select
   `sample_tubes`.`dont_use_id` AS `dont_use_id`,
   `sample_tubes`.`uuid` AS `uuid`,
   `sample_tubes`.`internal_id` AS `internal_id`,
   `sample_tubes`.`name` AS `name`,
   `sample_tubes`.`barcode` AS `barcode`,
   `sample_tubes`.`closed` AS `closed`,
   `sample_tubes`.`state` AS `state`,
   `sample_tubes`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `sample_tubes`.`sample_uuid` AS `sample_uuid`,
   `sample_tubes`.`sample_internal_id` AS `sample_internal_id`,
   `sample_tubes`.`sample_name` AS `sample_name`,
   `sample_tubes`.`scanned_in_date` AS `scanned_in_date`,
   `sample_tubes`.`volume` AS `volume`,
   `sample_tubes`.`concentration` AS `concentration`,
   `sample_tubes`.`is_current` AS `is_current`,
   `sample_tubes`.`checked_at` AS `checked_at`,
   `sample_tubes`.`last_updated` AS `last_updated`,
   `sample_tubes`.`created` AS `created`,
   `sample_tubes`.`barcode_prefix` AS `barcode_prefix`,
   `sample_tubes`.`inserted_at` AS `inserted_at`
from `sample_tubes`
where (`sample_tubes`.`is_current` = 1);


# Replace placeholder table for current_samples with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_samples`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_samples`
AS select
   `samples`.`dont_use_id` AS `dont_use_id`,
   `samples`.`uuid` AS `uuid`,
   `samples`.`internal_id` AS `internal_id`,
   `samples`.`name` AS `name`,
   `samples`.`reference_genome` AS `reference_genome`,
   `samples`.`organism` AS `organism`,
   `samples`.`accession_number` AS `accession_number`,
   `samples`.`common_name` AS `common_name`,
   `samples`.`description` AS `description`,
   `samples`.`taxon_id` AS `taxon_id`,
   `samples`.`father` AS `father`,
   `samples`.`mother` AS `mother`,
   `samples`.`replicate` AS `replicate`,
   `samples`.`ethnicity` AS `ethnicity`,
   `samples`.`gender` AS `gender`,
   `samples`.`cohort` AS `cohort`,
   `samples`.`country_of_origin` AS `country_of_origin`,
   `samples`.`geographical_region` AS `geographical_region`,
   `samples`.`is_current` AS `is_current`,
   `samples`.`checked_at` AS `checked_at`,
   `samples`.`last_updated` AS `last_updated`,
   `samples`.`created` AS `created`,
   `samples`.`sanger_sample_id` AS `sanger_sample_id`,
   `samples`.`control` AS `control`,
   `samples`.`empty_supplier_sample_name` AS `empty_supplier_sample_name`,
   `samples`.`supplier_name` AS `supplier_name`,
   `samples`.`public_name` AS `public_name`,
   `samples`.`sample_visibility` AS `sample_visibility`,
   `samples`.`strain` AS `strain`,
   `samples`.`updated_by_manifest` AS `updated_by_manifest`,
   `samples`.`inserted_at` AS `inserted_at`
from `samples`
where (`samples`.`is_current` = 1);


# Replace placeholder table for current_asset_audits with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_asset_audits`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_asset_audits`
AS select
   `asset_audits`.`dont_use_id` AS `dont_use_id`,
   `asset_audits`.`uuid` AS `uuid`,
   `asset_audits`.`internal_id` AS `internal_id`,
   `asset_audits`.`key` AS `key`,
   `asset_audits`.`message` AS `message`,
   `asset_audits`.`created_by` AS `created_by`,
   `asset_audits`.`is_current` AS `is_current`,
   `asset_audits`.`checked_at` AS `checked_at`,
   `asset_audits`.`last_updated` AS `last_updated`,
   `asset_audits`.`created` AS `created`,
   `asset_audits`.`asset_barcode` AS `asset_barcode`,
   `asset_audits`.`asset_barcode_prefix` AS `asset_barcode_prefix`,
   `asset_audits`.`asset_uuid` AS `asset_uuid`,
   `asset_audits`.`witnessed_by` AS `witnessed_by`,
   `asset_audits`.`inserted_at` AS `inserted_at`
from `asset_audits`
where (`asset_audits`.`is_current` = 1);


# Replace placeholder table for current_study_samples with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_study_samples`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_study_samples`
AS select
   `study_samples`.`dont_use_id` AS `dont_use_id`,
   `study_samples`.`uuid` AS `uuid`,
   `study_samples`.`internal_id` AS `internal_id`,
   `study_samples`.`sample_internal_id` AS `sample_internal_id`,
   `study_samples`.`sample_uuid` AS `sample_uuid`,
   `study_samples`.`study_internal_id` AS `study_internal_id`,
   `study_samples`.`study_uuid` AS `study_uuid`,
   `study_samples`.`is_current` AS `is_current`,
   `study_samples`.`checked_at` AS `checked_at`,
   `study_samples`.`last_updated` AS `last_updated`,
   `study_samples`.`created` AS `created`,
   `study_samples`.`inserted_at` AS `inserted_at`
from `study_samples`
where (`study_samples`.`is_current` = 1);


# Replace placeholder table for current_lanes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_lanes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_lanes`
AS select
   `lanes`.`dont_use_id` AS `dont_use_id`,
   `lanes`.`uuid` AS `uuid`,
   `lanes`.`internal_id` AS `internal_id`,
   `lanes`.`name` AS `name`,
   `lanes`.`barcode` AS `barcode`,
   `lanes`.`barcode_prefix` AS `barcode_prefix`,
   `lanes`.`closed` AS `closed`,
   `lanes`.`state` AS `state`,
   `lanes`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `lanes`.`external_release` AS `external_release`,
   `lanes`.`is_current` AS `is_current`,
   `lanes`.`scanned_in_date` AS `scanned_in_date`,
   `lanes`.`checked_at` AS `checked_at`,
   `lanes`.`last_updated` AS `last_updated`,
   `lanes`.`created` AS `created`,
   `lanes`.`inserted_at` AS `inserted_at`
from `lanes`
where (`lanes`.`is_current` = 1);


# Replace placeholder table for current_tags with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_tags`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_tags`
AS select
   `tags`.`dont_use_id` AS `dont_use_id`,
   `tags`.`uuid` AS `uuid`,
   `tags`.`internal_id` AS `internal_id`,
   `tags`.`expected_sequence` AS `expected_sequence`,
   `tags`.`map_id` AS `map_id`,
   `tags`.`tag_group_name` AS `tag_group_name`,
   `tags`.`tag_group_uuid` AS `tag_group_uuid`,
   `tags`.`tag_group_internal_id` AS `tag_group_internal_id`,
   `tags`.`is_current` AS `is_current`,
   `tags`.`checked_at` AS `checked_at`,
   `tags`.`last_updated` AS `last_updated`,
   `tags`.`created` AS `created`,
   `tags`.`inserted_at` AS `inserted_at`
from `tags`
where (`tags`.`is_current` = 1);


# Replace placeholder table for current_wells with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_wells`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_wells`
AS select
   `wells`.`dont_use_id` AS `dont_use_id`,
   `wells`.`uuid` AS `uuid`,
   `wells`.`internal_id` AS `internal_id`,
   `wells`.`name` AS `name`,
   `wells`.`map` AS `map`,
   `wells`.`plate_barcode` AS `plate_barcode`,
   `wells`.`plate_barcode_prefix` AS `plate_barcode_prefix`,
   `wells`.`sample_uuid` AS `sample_uuid`,
   `wells`.`sample_internal_id` AS `sample_internal_id`,
   `wells`.`sample_name` AS `sample_name`,
   `wells`.`gel_pass` AS `gel_pass`,
   `wells`.`concentration` AS `concentration`,
   `wells`.`current_volume` AS `current_volume`,
   `wells`.`buffer_volume` AS `buffer_volume`,
   `wells`.`requested_volume` AS `requested_volume`,
   `wells`.`picked_volume` AS `picked_volume`,
   `wells`.`pico_pass` AS `pico_pass`,
   `wells`.`is_current` AS `is_current`,
   `wells`.`checked_at` AS `checked_at`,
   `wells`.`last_updated` AS `last_updated`,
   `wells`.`created` AS `created`,
   `wells`.`plate_uuid` AS `plate_uuid`,
   `wells`.`measured_volume` AS `measured_volume`,
   `wells`.`sequenom_count` AS `sequenom_count`,
   `wells`.`gender_markers` AS `gender_markers`,
   `wells`.`genotyping_status` AS `genotyping_status`,
   `wells`.`genotyping_snp_plate_id` AS `genotyping_snp_plate_id`,
   `wells`.`inserted_at` AS `inserted_at`
from `wells`
where (`wells`.`is_current` = 1);


# Replace placeholder table for current_plate_purposes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_plate_purposes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_plate_purposes`
AS select
   `plate_purposes`.`dont_use_id` AS `dont_use_id`,
   `plate_purposes`.`uuid` AS `uuid`,
   `plate_purposes`.`internal_id` AS `internal_id`,
   `plate_purposes`.`name` AS `name`,
   `plate_purposes`.`is_current` AS `is_current`,
   `plate_purposes`.`checked_at` AS `checked_at`,
   `plate_purposes`.`last_updated` AS `last_updated`,
   `plate_purposes`.`created` AS `created`,
   `plate_purposes`.`inserted_at` AS `inserted_at`
from `plate_purposes`
where (`plate_purposes`.`is_current` = 1);


# Replace placeholder table for current_tag_instances with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_tag_instances`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_tag_instances`
AS select
   `tag_instances`.`dont_use_id` AS `dont_use_id`,
   `tag_instances`.`uuid` AS `uuid`,
   `tag_instances`.`internal_id` AS `internal_id`,
   `tag_instances`.`name` AS `name`,
   `tag_instances`.`barcode` AS `barcode`,
   `tag_instances`.`barcode_prefix` AS `barcode_prefix`,
   `tag_instances`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `tag_instances`.`tag_uuid` AS `tag_uuid`,
   `tag_instances`.`tag_internal_id` AS `tag_internal_id`,
   `tag_instances`.`tag_expected_sequence` AS `tag_expected_sequence`,
   `tag_instances`.`tag_map_id` AS `tag_map_id`,
   `tag_instances`.`tag_group_name` AS `tag_group_name`,
   `tag_instances`.`tag_group_uuid` AS `tag_group_uuid`,
   `tag_instances`.`tag_group_internal_id` AS `tag_group_internal_id`,
   `tag_instances`.`is_current` AS `is_current`,
   `tag_instances`.`checked_at` AS `checked_at`,
   `tag_instances`.`last_updated` AS `last_updated`,
   `tag_instances`.`created` AS `created`,
   `tag_instances`.`inserted_at` AS `inserted_at`
from `tag_instances`
where (`tag_instances`.`is_current` = 1);


# Replace placeholder table for current_projects with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_projects`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_projects`
AS select
   `projects`.`dont_use_id` AS `dont_use_id`,
   `projects`.`uuid` AS `uuid`,
   `projects`.`internal_id` AS `internal_id`,
   `projects`.`name` AS `name`,
   `projects`.`collaborators` AS `collaborators`,
   `projects`.`funding_comments` AS `funding_comments`,
   `projects`.`cost_code` AS `cost_code`,
   `projects`.`funding_model` AS `funding_model`,
   `projects`.`approved` AS `approved`,
   `projects`.`budget_division` AS `budget_division`,
   `projects`.`external_funding_source` AS `external_funding_source`,
   `projects`.`project_manager` AS `project_manager`,
   `projects`.`budget_cost_centre` AS `budget_cost_centre`,
   `projects`.`state` AS `state`,
   `projects`.`is_current` AS `is_current`,
   `projects`.`checked_at` AS `checked_at`,
   `projects`.`last_updated` AS `last_updated`,
   `projects`.`created` AS `created`,
   `projects`.`inserted_at` AS `inserted_at`
from `projects`
where (`projects`.`is_current` = 1);


# Replace placeholder table for current_submissions with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_submissions`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_submissions`
AS select
   `submissions`.`dont_use_id` AS `dont_use_id`,
   `submissions`.`uuid` AS `uuid`,
   `submissions`.`internal_id` AS `internal_id`,
   `submissions`.`is_current` AS `is_current`,
   `submissions`.`checked_at` AS `checked_at`,
   `submissions`.`last_updated` AS `last_updated`,
   `submissions`.`created` AS `created`,
   `submissions`.`created_by` AS `created_by`,
   `submissions`.`template_name` AS `template_name`,
   `submissions`.`state` AS `state`,
   `submissions`.`study_name` AS `study_name`,
   `submissions`.`study_uuid` AS `study_uuid`,
   `submissions`.`project_name` AS `project_name`,
   `submissions`.`project_uuid` AS `project_uuid`,
   `submissions`.`message` AS `message`,
   `submissions`.`comments` AS `comments`,
   `submissions`.`inserted_at` AS `inserted_at`,
   `submissions`.`read_length` AS `read_length`,
   `submissions`.`fragment_size_required_from` AS `fragment_size_required_from`,
   `submissions`.`fragment_size_required_to` AS `fragment_size_required_to`,
   `submissions`.`library_type` AS `library_type`,
   `submissions`.`sequencing_type` AS `sequencing_type`,
   `submissions`.`insert_size` AS `insert_size`,
   `submissions`.`number_of_lanes` AS `number_of_lanes`
from `submissions`
where (`submissions`.`is_current` = 1);


# Replace placeholder table for current_plates with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_plates`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_plates`
AS select
   `plates`.`dont_use_id` AS `dont_use_id`,
   `plates`.`uuid` AS `uuid`,
   `plates`.`internal_id` AS `internal_id`,
   `plates`.`name` AS `name`,
   `plates`.`barcode` AS `barcode`,
   `plates`.`barcode_prefix` AS `barcode_prefix`,
   `plates`.`plate_size` AS `plate_size`,
   `plates`.`is_current` AS `is_current`,
   `plates`.`checked_at` AS `checked_at`,
   `plates`.`last_updated` AS `last_updated`,
   `plates`.`created` AS `created`,
   `plates`.`plate_purpose_name` AS `plate_purpose_name`,
   `plates`.`plate_purpose_internal_id` AS `plate_purpose_internal_id`,
   `plates`.`plate_purpose_uuid` AS `plate_purpose_uuid`,
   `plates`.`infinium_barcode` AS `infinium_barcode`,
   `plates`.`location` AS `location`,
   `plates`.`inserted_at` AS `inserted_at`
from `plates`
where (`plates`.`is_current` = 1);


# Replace placeholder table for current_multiplexed_library_tubes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_multiplexed_library_tubes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_multiplexed_library_tubes`
AS select
   `multiplexed_library_tubes`.`dont_use_id` AS `dont_use_id`,
   `multiplexed_library_tubes`.`uuid` AS `uuid`,
   `multiplexed_library_tubes`.`internal_id` AS `internal_id`,
   `multiplexed_library_tubes`.`name` AS `name`,
   `multiplexed_library_tubes`.`barcode` AS `barcode`,
   `multiplexed_library_tubes`.`barcode_prefix` AS `barcode_prefix`,
   `multiplexed_library_tubes`.`closed` AS `closed`,
   `multiplexed_library_tubes`.`state` AS `state`,
   `multiplexed_library_tubes`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `multiplexed_library_tubes`.`volume` AS `volume`,
   `multiplexed_library_tubes`.`concentration` AS `concentration`,
   `multiplexed_library_tubes`.`is_current` AS `is_current`,
   `multiplexed_library_tubes`.`scanned_in_date` AS `scanned_in_date`,
   `multiplexed_library_tubes`.`checked_at` AS `checked_at`,
   `multiplexed_library_tubes`.`last_updated` AS `last_updated`,
   `multiplexed_library_tubes`.`created` AS `created`,
   `multiplexed_library_tubes`.`public_name` AS `public_name`,
   `multiplexed_library_tubes`.`inserted_at` AS `inserted_at`
from `multiplexed_library_tubes`
where (`multiplexed_library_tubes`.`is_current` = 1);


# Replace placeholder table for current_requests with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_requests`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_requests`
AS select
   `requests`.`dont_use_id` AS `dont_use_id`,
   `requests`.`uuid` AS `uuid`,
   `requests`.`internal_id` AS `internal_id`,
   `requests`.`request_type` AS `request_type`,
   `requests`.`fragment_size_from` AS `fragment_size_from`,
   `requests`.`fragment_size_to` AS `fragment_size_to`,
   `requests`.`read_length` AS `read_length`,
   `requests`.`library_type` AS `library_type`,
   `requests`.`study_uuid` AS `study_uuid`,
   `requests`.`study_internal_id` AS `study_internal_id`,
   `requests`.`study_name` AS `study_name`,
   `requests`.`project_uuid` AS `project_uuid`,
   `requests`.`project_internal_id` AS `project_internal_id`,
   `requests`.`project_name` AS `project_name`,
   `requests`.`source_asset_uuid` AS `source_asset_uuid`,
   `requests`.`source_asset_internal_id` AS `source_asset_internal_id`,
   `requests`.`source_asset_type` AS `source_asset_type`,
   `requests`.`source_asset_name` AS `source_asset_name`,
   `requests`.`source_asset_barcode` AS `source_asset_barcode`,
   `requests`.`source_asset_barcode_prefix` AS `source_asset_barcode_prefix`,
   `requests`.`source_asset_state` AS `source_asset_state`,
   `requests`.`source_asset_closed` AS `source_asset_closed`,
   `requests`.`source_asset_two_dimensional_barcode` AS `source_asset_two_dimensional_barcode`,
   `requests`.`source_asset_sample_uuid` AS `source_asset_sample_uuid`,
   `requests`.`source_asset_sample_internal_id` AS `source_asset_sample_internal_id`,
   `requests`.`target_asset_uuid` AS `target_asset_uuid`,
   `requests`.`target_asset_internal_id` AS `target_asset_internal_id`,
   `requests`.`target_asset_type` AS `target_asset_type`,
   `requests`.`target_asset_name` AS `target_asset_name`,
   `requests`.`target_asset_barcode` AS `target_asset_barcode`,
   `requests`.`target_asset_barcode_prefix` AS `target_asset_barcode_prefix`,
   `requests`.`target_asset_state` AS `target_asset_state`,
   `requests`.`target_asset_closed` AS `target_asset_closed`,
   `requests`.`target_asset_two_dimensional_barcode` AS `target_asset_two_dimensional_barcode`,
   `requests`.`target_asset_sample_uuid` AS `target_asset_sample_uuid`,
   `requests`.`target_asset_sample_internal_id` AS `target_asset_sample_internal_id`,
   `requests`.`is_current` AS `is_current`,
   `requests`.`checked_at` AS `checked_at`,
   `requests`.`last_updated` AS `last_updated`,
   `requests`.`created` AS `created`,
   `requests`.`state` AS `state`,
   `requests`.`priority` AS `priority`,
   `requests`.`user` AS `user`,
   `requests`.`inserted_at` AS `inserted_at`
from `requests`
where (`requests`.`is_current` = 1);


# Replace placeholder table for current_batch_requests with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_batch_requests`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_batch_requests`
AS select
   `batch_requests`.`dont_use_id` AS `dont_use_id`,
   `batch_requests`.`uuid` AS `uuid`,
   `batch_requests`.`internal_id` AS `internal_id`,
   `batch_requests`.`batch_uuid` AS `batch_uuid`,
   `batch_requests`.`batch_internal_id` AS `batch_internal_id`,
   `batch_requests`.`request_uuid` AS `request_uuid`,
   `batch_requests`.`request_internal_id` AS `request_internal_id`,
   `batch_requests`.`request_type` AS `request_type`,
   `batch_requests`.`source_asset_uuid` AS `source_asset_uuid`,
   `batch_requests`.`source_asset_internal_id` AS `source_asset_internal_id`,
   `batch_requests`.`source_asset_name` AS `source_asset_name`,
   `batch_requests`.`target_asset_uuid` AS `target_asset_uuid`,
   `batch_requests`.`target_asset_internal_id` AS `target_asset_internal_id`,
   `batch_requests`.`target_asset_name` AS `target_asset_name`,
   `batch_requests`.`is_current` AS `is_current`,
   `batch_requests`.`checked_at` AS `checked_at`,
   `batch_requests`.`last_updated` AS `last_updated`,
   `batch_requests`.`created` AS `created`,
   `batch_requests`.`inserted_at` AS `inserted_at`
from `batch_requests`
where (`batch_requests`.`is_current` = 1);


# Replace placeholder table for current_studies with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_studies`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_studies`
AS select
   `studies`.`dont_use_id` AS `dont_use_id`,
   `studies`.`uuid` AS `uuid`,
   `studies`.`internal_id` AS `internal_id`,
   `studies`.`name` AS `name`,
   `studies`.`reference_genome` AS `reference_genome`,
   `studies`.`ethically_approved` AS `ethically_approved`,
   `studies`.`faculty_sponsor` AS `faculty_sponsor`,
   `studies`.`state` AS `state`,
   `studies`.`study_type` AS `study_type`,
   `studies`.`abstract` AS `abstract`,
   `studies`.`abbreviation` AS `abbreviation`,
   `studies`.`accession_number` AS `accession_number`,
   `studies`.`description` AS `description`,
   `studies`.`is_current` AS `is_current`,
   `studies`.`checked_at` AS `checked_at`,
   `studies`.`last_updated` AS `last_updated`,
   `studies`.`created` AS `created`,
   `studies`.`contains_human_dna` AS `contains_human_dna`,
   `studies`.`contaminated_human_dna` AS `contaminated_human_dna`,
   `studies`.`data_release_strategy` AS `data_release_strategy`,
   `studies`.`data_release_sort_of_study` AS `data_release_sort_of_study`,
   `studies`.`ena_project_id` AS `ena_project_id`,
   `studies`.`study_title` AS `study_title`,
   `studies`.`study_visibility` AS `study_visibility`,
   `studies`.`inserted_at` AS `inserted_at`,
   `studies`.`ega_dac_accession_number` AS `ega_dac_accession_number`,
   `studies`.`array_express_accession_number` AS `array_express_accession_number`,
   `studies`.`ega_policy_accession_number` AS `ega_policy_accession_number`
from `studies`
where (`studies`.`is_current` = 1);


# Replace placeholder table for current_quotas with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_quotas`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_quotas`
AS select
   `quotas`.`dont_use_id` AS `dont_use_id`,
   `quotas`.`uuid` AS `uuid`,
   `quotas`.`internal_id` AS `internal_id`,
   `quotas`.`quota_limit` AS `quota_limit`,
   `quotas`.`request_type` AS `request_type`,
   `quotas`.`project_internal_id` AS `project_internal_id`,
   `quotas`.`project_uuid` AS `project_uuid`,
   `quotas`.`project_name` AS `project_name`,
   `quotas`.`is_current` AS `is_current`,
   `quotas`.`checked_at` AS `checked_at`,
   `quotas`.`last_updated` AS `last_updated`,
   `quotas`.`created` AS `created`,
   `quotas`.`inserted_at` AS `inserted_at`
from `quotas`
where (`quotas`.`is_current` = 1);


# Replace placeholder table for current_asset_links with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_asset_links`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_asset_links`
AS select
   `asset_links`.`dont_use_id` AS `dont_use_id`,
   `asset_links`.`uuid` AS `uuid`,
   `asset_links`.`ancestor_uuid` AS `ancestor_uuid`,
   `asset_links`.`ancestor_internal_id` AS `ancestor_internal_id`,
   `asset_links`.`ancestor_type` AS `ancestor_type`,
   `asset_links`.`descendant_uuid` AS `descendant_uuid`,
   `asset_links`.`descendant_internal_id` AS `descendant_internal_id`,
   `asset_links`.`descendant_type` AS `descendant_type`,
   `asset_links`.`is_current` AS `is_current`,
   `asset_links`.`checked_at` AS `checked_at`,
   `asset_links`.`last_updated` AS `last_updated`,
   `asset_links`.`created` AS `created`,
   `asset_links`.`inserted_at` AS `inserted_at`
from `asset_links`
where (`asset_links`.`is_current` = 1);


# Replace placeholder table for current_library_tubes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_library_tubes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_library_tubes`
AS select
   `library_tubes`.`dont_use_id` AS `dont_use_id`,
   `library_tubes`.`uuid` AS `uuid`,
   `library_tubes`.`internal_id` AS `internal_id`,
   `library_tubes`.`name` AS `name`,
   `library_tubes`.`barcode` AS `barcode`,
   `library_tubes`.`barcode_prefix` AS `barcode_prefix`,
   `library_tubes`.`closed` AS `closed`,
   `library_tubes`.`state` AS `state`,
   `library_tubes`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `library_tubes`.`sample_uuid` AS `sample_uuid`,
   `library_tubes`.`sample_internal_id` AS `sample_internal_id`,
   `library_tubes`.`volume` AS `volume`,
   `library_tubes`.`concentration` AS `concentration`,
   `library_tubes`.`tag_uuid` AS `tag_uuid`,
   `library_tubes`.`tag_internal_id` AS `tag_internal_id`,
   `library_tubes`.`expected_sequence` AS `expected_sequence`,
   `library_tubes`.`tag_map_id` AS `tag_map_id`,
   `library_tubes`.`tag_group_name` AS `tag_group_name`,
   `library_tubes`.`tag_group_uuid` AS `tag_group_uuid`,
   `library_tubes`.`tag_group_internal_id` AS `tag_group_internal_id`,
   `library_tubes`.`source_request_internal_id` AS `source_request_internal_id`,
   `library_tubes`.`source_request_uuid` AS `source_request_uuid`,
   `library_tubes`.`library_type` AS `library_type`,
   `library_tubes`.`fragment_size_required_from` AS `fragment_size_required_from`,
   `library_tubes`.`fragment_size_required_to` AS `fragment_size_required_to`,
   `library_tubes`.`sample_name` AS `sample_name`,
   `library_tubes`.`is_current` AS `is_current`,
   `library_tubes`.`scanned_in_date` AS `scanned_in_date`,
   `library_tubes`.`checked_at` AS `checked_at`,
   `library_tubes`.`last_updated` AS `last_updated`,
   `library_tubes`.`created` AS `created`,
   `library_tubes`.`public_name` AS `public_name`,
   `library_tubes`.`inserted_at` AS `inserted_at`
from `library_tubes`
where (`library_tubes`.`is_current` = 1);


# Replace placeholder table for current_billing_events with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_billing_events`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_billing_events`
AS select
   `billing_events`.`dont_use_id` AS `dont_use_id`,
   `billing_events`.`uuid` AS `uuid`,
   `billing_events`.`internal_id` AS `internal_id`,
   `billing_events`.`reference` AS `reference`,
   `billing_events`.`project_internal_id` AS `project_internal_id`,
   `billing_events`.`project_uuid` AS `project_uuid`,
   `billing_events`.`project_name` AS `project_name`,
   `billing_events`.`division` AS `division`,
   `billing_events`.`created_by` AS `created_by`,
   `billing_events`.`request_internal_id` AS `request_internal_id`,
   `billing_events`.`request_uuid` AS `request_uuid`,
   `billing_events`.`request_type` AS `request_type`,
   `billing_events`.`library_type` AS `library_type`,
   `billing_events`.`cost_code` AS `cost_code`,
   `billing_events`.`price` AS `price`,
   `billing_events`.`quantity` AS `quantity`,
   `billing_events`.`kind` AS `kind`,
   `billing_events`.`description` AS `description`,
   `billing_events`.`is_current` AS `is_current`,
   `billing_events`.`entry_date` AS `entry_date`,
   `billing_events`.`checked_at` AS `checked_at`,
   `billing_events`.`last_updated` AS `last_updated`,
   `billing_events`.`created` AS `created`,
   `billing_events`.`inserted_at` AS `inserted_at`
from `billing_events`
where (`billing_events`.`is_current` = 1);


# Replace placeholder table for current_pulldown_multiplexed_library_tubes with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_pulldown_multiplexed_library_tubes`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_pulldown_multiplexed_library_tubes`
AS select
   `pulldown_multiplexed_library_tubes`.`dont_use_id` AS `dont_use_id`,
   `pulldown_multiplexed_library_tubes`.`uuid` AS `uuid`,
   `pulldown_multiplexed_library_tubes`.`internal_id` AS `internal_id`,
   `pulldown_multiplexed_library_tubes`.`name` AS `name`,
   `pulldown_multiplexed_library_tubes`.`barcode` AS `barcode`,
   `pulldown_multiplexed_library_tubes`.`barcode_prefix` AS `barcode_prefix`,
   `pulldown_multiplexed_library_tubes`.`state` AS `state`,
   `pulldown_multiplexed_library_tubes`.`closed` AS `closed`,
   `pulldown_multiplexed_library_tubes`.`concentration` AS `concentration`,
   `pulldown_multiplexed_library_tubes`.`volume` AS `volume`,
   `pulldown_multiplexed_library_tubes`.`two_dimensional_barcode` AS `two_dimensional_barcode`,
   `pulldown_multiplexed_library_tubes`.`scanned_in_date` AS `scanned_in_date`,
   `pulldown_multiplexed_library_tubes`.`is_current` AS `is_current`,
   `pulldown_multiplexed_library_tubes`.`checked_at` AS `checked_at`,
   `pulldown_multiplexed_library_tubes`.`last_updated` AS `last_updated`,
   `pulldown_multiplexed_library_tubes`.`created` AS `created`,
   `pulldown_multiplexed_library_tubes`.`public_name` AS `public_name`,
   `pulldown_multiplexed_library_tubes`.`inserted_at` AS `inserted_at`
from `pulldown_multiplexed_library_tubes`
where (`pulldown_multiplexed_library_tubes`.`is_current` = 1);


# Replace placeholder table for current_asset_freezers with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_asset_freezers`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_asset_freezers`
AS select
   `asset_freezers`.`dont_use_id` AS `dont_use_id`,
   `asset_freezers`.`uuid` AS `uuid`,
   `asset_freezers`.`internal_id` AS `internal_id`,
   `asset_freezers`.`name` AS `name`,
   `asset_freezers`.`asset_type` AS `asset_type`,
   `asset_freezers`.`barcode` AS `barcode`,
   `asset_freezers`.`barcode_prefix` AS `barcode_prefix`,
   `asset_freezers`.`building` AS `building`,
   `asset_freezers`.`room` AS `room`,
   `asset_freezers`.`freezer` AS `freezer`,
   `asset_freezers`.`shelf` AS `shelf`,
   `asset_freezers`.`is_current` AS `is_current`,
   `asset_freezers`.`checked_at` AS `checked_at`,
   `asset_freezers`.`last_updated` AS `last_updated`,
   `asset_freezers`.`created` AS `created`,
   `asset_freezers`.`inserted_at` AS `inserted_at`
from `asset_freezers`
where (`asset_freezers`.`is_current` = 1);


# Replace placeholder table for current_batches with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_batches`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_batches`
AS select
   `batches`.`dont_use_id` AS `dont_use_id`,
   `batches`.`uuid` AS `uuid`,
   `batches`.`internal_id` AS `internal_id`,
   `batches`.`created_by` AS `created_by`,
   `batches`.`assigned_to` AS `assigned_to`,
   `batches`.`pipeline_name` AS `pipeline_name`,
   `batches`.`pipeline_uuid` AS `pipeline_uuid`,
   `batches`.`pipeline_internal_id` AS `pipeline_internal_id`,
   `batches`.`state` AS `state`,
   `batches`.`qc_state` AS `qc_state`,
   `batches`.`production_state` AS `production_state`,
   `batches`.`is_current` AS `is_current`,
   `batches`.`checked_at` AS `checked_at`,
   `batches`.`last_updated` AS `last_updated`,
   `batches`.`created` AS `created`,
   `batches`.`inserted_at` AS `inserted_at`
from `batches`
where (`batches`.`is_current` = 1);


# Replace placeholder table for current_events with correct view syntax
# ------------------------------------------------------------

DROP TABLE `current_events`;
CREATE ALGORITHM=UNDEFINED DEFINER=`wh_admin`@`%` SQL SECURITY DEFINER VIEW `current_events`
AS select
   `events`.`dont_use_id` AS `dont_use_id`,
   `events`.`uuid` AS `uuid`,
   `events`.`internal_id` AS `internal_id`,
   `events`.`source_internal_id` AS `source_internal_id`,
   `events`.`source_uuid` AS `source_uuid`,
   `events`.`source_type` AS `source_type`,
   `events`.`message` AS `message`,
   `events`.`state` AS `state`,
   `events`.`identifier` AS `identifier`,
   `events`.`location` AS `location`,
   `events`.`actioned` AS `actioned`,
   `events`.`content` AS `content`,
   `events`.`created_by` AS `created_by`,
   `events`.`of_interest_to` AS `of_interest_to`,
   `events`.`descriptor_key` AS `descriptor_key`,
   `events`.`is_current` AS `is_current`,
   `events`.`checked_at` AS `checked_at`,
   `events`.`last_updated` AS `last_updated`,
   `events`.`created` AS `created`,
   `events`.`inserted_at` AS `inserted_at`
from `events`
where (`events`.`is_current` = 1);

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
