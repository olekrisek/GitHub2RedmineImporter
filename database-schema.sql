SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `redmine` DEFAULT CHARACTER SET utf8 ;
USE `redmine` ;

-- -----------------------------------------------------
-- Table `redmine`.`attachments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`attachments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `container_id` INT(11) NULL DEFAULT NULL ,
  `container_type` VARCHAR(30) NULL DEFAULT NULL ,
  `filename` VARCHAR(255) NOT NULL DEFAULT '' ,
  `disk_filename` VARCHAR(255) NOT NULL DEFAULT '' ,
  `filesize` INT(11) NOT NULL DEFAULT '0' ,
  `content_type` VARCHAR(255) NULL DEFAULT '' ,
  `digest` VARCHAR(40) NOT NULL DEFAULT '' ,
  `downloads` INT(11) NOT NULL DEFAULT '0' ,
  `author_id` INT(11) NOT NULL DEFAULT '0' ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `disk_directory` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_attachments_on_author_id` (`author_id` ASC) ,
  INDEX `index_attachments_on_created_on` (`created_on` ASC) ,
  INDEX `index_attachments_on_container_id_and_container_type` (`container_id` ASC, `container_type` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`auth_sources`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`auth_sources` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(30) NOT NULL DEFAULT '' ,
  `name` VARCHAR(60) NOT NULL DEFAULT '' ,
  `host` VARCHAR(60) NULL DEFAULT NULL ,
  `port` INT(11) NULL DEFAULT NULL ,
  `account` VARCHAR(255) NULL DEFAULT NULL ,
  `account_password` VARCHAR(255) NULL DEFAULT '' ,
  `base_dn` VARCHAR(255) NULL DEFAULT NULL ,
  `attr_login` VARCHAR(30) NULL DEFAULT NULL ,
  `attr_firstname` VARCHAR(30) NULL DEFAULT NULL ,
  `attr_lastname` VARCHAR(30) NULL DEFAULT NULL ,
  `attr_mail` VARCHAR(30) NULL DEFAULT NULL ,
  `onthefly_register` TINYINT(1) NOT NULL DEFAULT '0' ,
  `tls` TINYINT(1) NOT NULL DEFAULT '0' ,
  `filter` VARCHAR(255) NULL DEFAULT NULL ,
  `timeout` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_auth_sources_on_id_and_type` (`id` ASC, `type` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`boards`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`boards` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `description` VARCHAR(255) NULL DEFAULT NULL ,
  `position` INT(11) NULL DEFAULT '1' ,
  `topics_count` INT(11) NOT NULL DEFAULT '0' ,
  `messages_count` INT(11) NOT NULL DEFAULT '0' ,
  `last_message_id` INT(11) NULL DEFAULT NULL ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `boards_project_id` (`project_id` ASC) ,
  INDEX `index_boards_on_last_message_id` (`last_message_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`changes`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`changes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `changeset_id` INT(11) NOT NULL ,
  `action` VARCHAR(1) NOT NULL DEFAULT '' ,
  `path` TEXT NOT NULL ,
  `from_path` TEXT NULL DEFAULT NULL ,
  `from_revision` VARCHAR(255) NULL DEFAULT NULL ,
  `revision` VARCHAR(255) NULL DEFAULT NULL ,
  `branch` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `changesets_changeset_id` (`changeset_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`changeset_parents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`changeset_parents` (
  `changeset_id` INT(11) NOT NULL ,
  `parent_id` INT(11) NOT NULL ,
  INDEX `changeset_parents_changeset_ids` (`changeset_id` ASC) ,
  INDEX `changeset_parents_parent_ids` (`parent_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`changesets`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`changesets` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `repository_id` INT(11) NOT NULL ,
  `revision` VARCHAR(255) NOT NULL ,
  `committer` VARCHAR(255) NULL DEFAULT NULL ,
  `committed_on` DATETIME NOT NULL ,
  `comments` TEXT NULL DEFAULT NULL ,
  `commit_date` DATE NULL DEFAULT NULL ,
  `scmid` VARCHAR(255) NULL DEFAULT NULL ,
  `user_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `changesets_repos_rev` (`repository_id` ASC, `revision` ASC) ,
  INDEX `index_changesets_on_user_id` (`user_id` ASC) ,
  INDEX `index_changesets_on_repository_id` (`repository_id` ASC) ,
  INDEX `index_changesets_on_committed_on` (`committed_on` ASC) ,
  INDEX `changesets_repos_scmid` (`repository_id` ASC, `scmid` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`changesets_issues`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`changesets_issues` (
  `changeset_id` INT(11) NOT NULL ,
  `issue_id` INT(11) NOT NULL ,
  UNIQUE INDEX `changesets_issues_ids` (`changeset_id` ASC, `issue_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`comments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`comments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `commented_type` VARCHAR(30) NOT NULL DEFAULT '' ,
  `commented_id` INT(11) NOT NULL DEFAULT '0' ,
  `author_id` INT(11) NOT NULL DEFAULT '0' ,
  `comments` TEXT NULL DEFAULT NULL ,
  `created_on` DATETIME NOT NULL ,
  `updated_on` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_comments_on_commented_id_and_commented_type` (`commented_id` ASC, `commented_type` ASC) ,
  INDEX `index_comments_on_author_id` (`author_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`custom_fields`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`custom_fields` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `type` VARCHAR(30) NOT NULL DEFAULT '' ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `field_format` VARCHAR(30) NOT NULL DEFAULT '' ,
  `possible_values` TEXT NULL DEFAULT NULL ,
  `regexp` VARCHAR(255) NULL DEFAULT '' ,
  `min_length` INT(11) NOT NULL DEFAULT '0' ,
  `max_length` INT(11) NOT NULL DEFAULT '0' ,
  `is_required` TINYINT(1) NOT NULL DEFAULT '0' ,
  `is_for_all` TINYINT(1) NOT NULL DEFAULT '0' ,
  `is_filter` TINYINT(1) NOT NULL DEFAULT '0' ,
  `position` INT(11) NULL DEFAULT '1' ,
  `searchable` TINYINT(1) NULL DEFAULT '0' ,
  `default_value` TEXT NULL DEFAULT NULL ,
  `editable` TINYINT(1) NULL DEFAULT '1' ,
  `visible` TINYINT(1) NOT NULL DEFAULT '1' ,
  `multiple` TINYINT(1) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `index_custom_fields_on_id_and_type` (`id` ASC, `type` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`custom_fields_projects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`custom_fields_projects` (
  `custom_field_id` INT(11) NOT NULL DEFAULT '0' ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  UNIQUE INDEX `index_custom_fields_projects_on_custom_field_id_and_project_id` (`custom_field_id` ASC, `project_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`custom_fields_trackers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`custom_fields_trackers` (
  `custom_field_id` INT(11) NOT NULL DEFAULT '0' ,
  `tracker_id` INT(11) NOT NULL DEFAULT '0' ,
  UNIQUE INDEX `index_custom_fields_trackers_on_custom_field_id_and_tracker_id` (`custom_field_id` ASC, `tracker_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`custom_values`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`custom_values` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `customized_type` VARCHAR(30) NOT NULL DEFAULT '' ,
  `customized_id` INT(11) NOT NULL DEFAULT '0' ,
  `custom_field_id` INT(11) NOT NULL DEFAULT '0' ,
  `value` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `custom_values_customized` (`customized_type` ASC, `customized_id` ASC) ,
  INDEX `index_custom_values_on_custom_field_id` (`custom_field_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`documents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`documents` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `category_id` INT(11) NOT NULL DEFAULT '0' ,
  `title` VARCHAR(60) NOT NULL DEFAULT '' ,
  `description` TEXT NULL DEFAULT NULL ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `documents_project_id` (`project_id` ASC) ,
  INDEX `index_documents_on_category_id` (`category_id` ASC) ,
  INDEX `index_documents_on_created_on` (`created_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`enabled_modules`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`enabled_modules` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NULL DEFAULT NULL ,
  `name` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `enabled_modules_project_id` (`project_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`enumerations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`enumerations` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `position` INT(11) NULL DEFAULT '1' ,
  `is_default` TINYINT(1) NOT NULL DEFAULT '0' ,
  `type` VARCHAR(255) NULL DEFAULT NULL ,
  `active` TINYINT(1) NOT NULL DEFAULT '1' ,
  `project_id` INT(11) NULL DEFAULT NULL ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  `position_name` VARCHAR(30) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_enumerations_on_project_id` (`project_id` ASC) ,
  INDEX `index_enumerations_on_id_and_type` (`id` ASC, `type` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`groups_users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`groups_users` (
  `group_id` INT(11) NOT NULL ,
  `user_id` INT(11) NOT NULL ,
  UNIQUE INDEX `groups_users_ids` (`group_id` ASC, `user_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`issue_categories`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`issue_categories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `assigned_to_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `issue_categories_project_id` (`project_id` ASC) ,
  INDEX `index_issue_categories_on_assigned_to_id` (`assigned_to_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`issue_relations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`issue_relations` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `issue_from_id` INT(11) NOT NULL ,
  `issue_to_id` INT(11) NOT NULL ,
  `relation_type` VARCHAR(255) NOT NULL DEFAULT '' ,
  `delay` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `index_issue_relations_on_issue_from_id_and_issue_to_id` (`issue_from_id` ASC, `issue_to_id` ASC) ,
  INDEX `index_issue_relations_on_issue_from_id` (`issue_from_id` ASC) ,
  INDEX `index_issue_relations_on_issue_to_id` (`issue_to_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`issue_statuses`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`issue_statuses` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `is_closed` TINYINT(1) NOT NULL DEFAULT '0' ,
  `is_default` TINYINT(1) NOT NULL DEFAULT '0' ,
  `position` INT(11) NULL DEFAULT '1' ,
  `default_done_ratio` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_issue_statuses_on_position` (`position` ASC) ,
  INDEX `index_issue_statuses_on_is_closed` (`is_closed` ASC) ,
  INDEX `index_issue_statuses_on_is_default` (`is_default` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`issues`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`issues` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `tracker_id` INT(11) NOT NULL ,
  `project_id` INT(11) NOT NULL ,
  `subject` VARCHAR(255) NOT NULL DEFAULT '' ,
  `description` TEXT NULL DEFAULT NULL ,
  `due_date` DATE NULL DEFAULT NULL ,
  `category_id` INT(11) NULL DEFAULT NULL ,
  `status_id` INT(11) NOT NULL ,
  `assigned_to_id` INT(11) NULL DEFAULT NULL ,
  `priority_id` INT(11) NOT NULL ,
  `fixed_version_id` INT(11) NULL DEFAULT NULL ,
  `author_id` INT(11) NOT NULL ,
  `lock_version` INT(11) NOT NULL DEFAULT '0' ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `updated_on` DATETIME NULL DEFAULT NULL ,
  `start_date` DATE NULL DEFAULT NULL ,
  `done_ratio` INT(11) NOT NULL DEFAULT '0' ,
  `estimated_hours` FLOAT NULL DEFAULT NULL ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  `root_id` INT(11) NULL DEFAULT NULL ,
  `lft` INT(11) NULL DEFAULT NULL ,
  `rgt` INT(11) NULL DEFAULT NULL ,
  `is_private` TINYINT(1) NOT NULL DEFAULT '0' ,
  `closed_on` DATETIME NULL DEFAULT NULL ,
  `GitIssueNr` INT(11) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `issues_project_id` (`project_id` ASC) ,
  INDEX `index_issues_on_status_id` (`status_id` ASC) ,
  INDEX `index_issues_on_category_id` (`category_id` ASC) ,
  INDEX `index_issues_on_assigned_to_id` (`assigned_to_id` ASC) ,
  INDEX `index_issues_on_fixed_version_id` (`fixed_version_id` ASC) ,
  INDEX `index_issues_on_tracker_id` (`tracker_id` ASC) ,
  INDEX `index_issues_on_priority_id` (`priority_id` ASC) ,
  INDEX `index_issues_on_author_id` (`author_id` ASC) ,
  INDEX `index_issues_on_created_on` (`created_on` ASC) ,
  INDEX `index_issues_on_root_id_and_lft_and_rgt` (`root_id` ASC, `lft` ASC, `rgt` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`journal_details`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`journal_details` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `journal_id` INT(11) NOT NULL DEFAULT '0' ,
  `property` VARCHAR(30) NOT NULL DEFAULT '' ,
  `prop_key` VARCHAR(30) NOT NULL DEFAULT '' ,
  `old_value` TEXT NULL DEFAULT NULL ,
  `value` TEXT NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `journal_details_journal_id` (`journal_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`journals`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`journals` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `journalized_id` INT(11) NOT NULL DEFAULT '0' ,
  `journalized_type` VARCHAR(30) NOT NULL DEFAULT '' ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `notes` TEXT NULL DEFAULT NULL ,
  `created_on` DATETIME NOT NULL ,
  `private_notes` TINYINT(1) NOT NULL DEFAULT '0' ,
  `GitCommentID` INT(11) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `journals_journalized_id` (`journalized_id` ASC, `journalized_type` ASC) ,
  INDEX `index_journals_on_user_id` (`user_id` ASC) ,
  INDEX `index_journals_on_journalized_id` (`journalized_id` ASC) ,
  INDEX `index_journals_on_created_on` (`created_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`member_roles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`member_roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `member_id` INT(11) NOT NULL ,
  `role_id` INT(11) NOT NULL ,
  `inherited_from` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_member_roles_on_member_id` (`member_id` ASC) ,
  INDEX `index_member_roles_on_role_id` (`role_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`members`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`members` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `mail_notification` TINYINT(1) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `index_members_on_user_id_and_project_id` (`user_id` ASC, `project_id` ASC) ,
  INDEX `index_members_on_user_id` (`user_id` ASC) ,
  INDEX `index_members_on_project_id` (`project_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`messages`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`messages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `board_id` INT(11) NOT NULL ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  `subject` VARCHAR(255) NOT NULL DEFAULT '' ,
  `content` TEXT NULL DEFAULT NULL ,
  `author_id` INT(11) NULL DEFAULT NULL ,
  `replies_count` INT(11) NOT NULL DEFAULT '0' ,
  `last_reply_id` INT(11) NULL DEFAULT NULL ,
  `created_on` DATETIME NOT NULL ,
  `updated_on` DATETIME NOT NULL ,
  `locked` TINYINT(1) NULL DEFAULT '0' ,
  `sticky` INT(11) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `messages_board_id` (`board_id` ASC) ,
  INDEX `messages_parent_id` (`parent_id` ASC) ,
  INDEX `index_messages_on_last_reply_id` (`last_reply_id` ASC) ,
  INDEX `index_messages_on_author_id` (`author_id` ASC) ,
  INDEX `index_messages_on_created_on` (`created_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`news`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`news` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NULL DEFAULT NULL ,
  `title` VARCHAR(60) NOT NULL DEFAULT '' ,
  `summary` VARCHAR(255) NULL DEFAULT '' ,
  `description` TEXT NULL DEFAULT NULL ,
  `author_id` INT(11) NOT NULL DEFAULT '0' ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `comments_count` INT(11) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `news_project_id` (`project_id` ASC) ,
  INDEX `index_news_on_author_id` (`author_id` ASC) ,
  INDEX `index_news_on_created_on` (`created_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`open_id_authentication_associations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`open_id_authentication_associations` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `issued` INT(11) NULL DEFAULT NULL ,
  `lifetime` INT(11) NULL DEFAULT NULL ,
  `handle` VARCHAR(255) NULL DEFAULT NULL ,
  `assoc_type` VARCHAR(255) NULL DEFAULT NULL ,
  `server_url` BLOB NULL DEFAULT NULL ,
  `secret` BLOB NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`open_id_authentication_nonces`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`open_id_authentication_nonces` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `timestamp` INT(11) NOT NULL ,
  `server_url` VARCHAR(255) NULL DEFAULT NULL ,
  `salt` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`projects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`projects` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `description` TEXT NULL DEFAULT NULL ,
  `homepage` VARCHAR(255) NULL DEFAULT '' ,
  `is_public` TINYINT(1) NOT NULL DEFAULT '1' ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `updated_on` DATETIME NULL DEFAULT NULL ,
  `identifier` VARCHAR(255) NULL DEFAULT NULL ,
  `status` INT(11) NOT NULL DEFAULT '1' ,
  `lft` INT(11) NULL DEFAULT NULL ,
  `rgt` INT(11) NULL DEFAULT NULL ,
  `inherit_members` TINYINT(1) NOT NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `index_projects_on_lft` (`lft` ASC) ,
  INDEX `index_projects_on_rgt` (`rgt` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`projects_trackers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`projects_trackers` (
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `tracker_id` INT(11) NOT NULL DEFAULT '0' ,
  UNIQUE INDEX `projects_trackers_unique` (`project_id` ASC, `tracker_id` ASC) ,
  INDEX `projects_trackers_project_id` (`project_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`queries`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`queries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NULL DEFAULT NULL ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `filters` TEXT NULL DEFAULT NULL ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `is_public` TINYINT(1) NOT NULL DEFAULT '0' ,
  `column_names` TEXT NULL DEFAULT NULL ,
  `sort_criteria` TEXT NULL DEFAULT NULL ,
  `group_by` VARCHAR(255) NULL DEFAULT NULL ,
  `type` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_queries_on_project_id` (`project_id` ASC) ,
  INDEX `index_queries_on_user_id` (`user_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`repositories`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`repositories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `url` VARCHAR(255) NOT NULL DEFAULT '' ,
  `login` VARCHAR(60) NULL DEFAULT '' ,
  `password` VARCHAR(255) NULL DEFAULT '' ,
  `root_url` VARCHAR(255) NULL DEFAULT '' ,
  `type` VARCHAR(255) NULL DEFAULT NULL ,
  `path_encoding` VARCHAR(64) NULL DEFAULT NULL ,
  `log_encoding` VARCHAR(64) NULL DEFAULT NULL ,
  `extra_info` TEXT NULL DEFAULT NULL ,
  `identifier` VARCHAR(255) NULL DEFAULT NULL ,
  `is_default` TINYINT(1) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) ,
  INDEX `index_repositories_on_project_id` (`project_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`roles`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `position` INT(11) NULL DEFAULT '1' ,
  `assignable` TINYINT(1) NULL DEFAULT '1' ,
  `builtin` INT(11) NOT NULL DEFAULT '0' ,
  `permissions` TEXT NULL DEFAULT NULL ,
  `issues_visibility` VARCHAR(30) NOT NULL DEFAULT 'default' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`schema_migrations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`schema_migrations` (
  `version` VARCHAR(255) NOT NULL ,
  UNIQUE INDEX `unique_schema_migrations` (`version` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`settings`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`settings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `value` TEXT NULL DEFAULT NULL ,
  `updated_on` DATETIME NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_settings_on_name` (`name` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 25
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`time_entries`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`time_entries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL ,
  `user_id` INT(11) NOT NULL ,
  `issue_id` INT(11) NULL DEFAULT NULL ,
  `hours` FLOAT NOT NULL ,
  `comments` VARCHAR(255) NULL DEFAULT NULL ,
  `activity_id` INT(11) NOT NULL ,
  `spent_on` DATE NOT NULL ,
  `tyear` INT(11) NOT NULL ,
  `tmonth` INT(11) NOT NULL ,
  `tweek` INT(11) NOT NULL ,
  `created_on` DATETIME NOT NULL ,
  `updated_on` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `time_entries_project_id` (`project_id` ASC) ,
  INDEX `time_entries_issue_id` (`issue_id` ASC) ,
  INDEX `index_time_entries_on_activity_id` (`activity_id` ASC) ,
  INDEX `index_time_entries_on_user_id` (`user_id` ASC) ,
  INDEX `index_time_entries_on_created_on` (`created_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`tokens`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`tokens` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `action` VARCHAR(30) NOT NULL DEFAULT '' ,
  `value` VARCHAR(40) NOT NULL DEFAULT '' ,
  `created_on` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `tokens_value` (`value` ASC) ,
  INDEX `index_tokens_on_user_id` (`user_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`trackers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`trackers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(30) NOT NULL DEFAULT '' ,
  `is_in_chlog` TINYINT(1) NOT NULL DEFAULT '0' ,
  `position` INT(11) NULL DEFAULT '1' ,
  `is_in_roadmap` TINYINT(1) NOT NULL DEFAULT '1' ,
  `fields_bits` INT(11) NULL DEFAULT '0' ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`user_preferences`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`user_preferences` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `user_id` INT(11) NOT NULL DEFAULT '0' ,
  `others` TEXT NULL DEFAULT NULL ,
  `hide_mail` TINYINT(1) NULL DEFAULT '0' ,
  `time_zone` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_user_preferences_on_user_id` (`user_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`users` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `login` VARCHAR(255) NOT NULL DEFAULT '' ,
  `hashed_password` VARCHAR(40) NOT NULL DEFAULT '' ,
  `firstname` VARCHAR(30) NOT NULL DEFAULT '' ,
  `lastname` VARCHAR(255) NOT NULL DEFAULT '' ,
  `mail` VARCHAR(60) NOT NULL DEFAULT '' ,
  `admin` TINYINT(1) NOT NULL DEFAULT '0' ,
  `status` INT(11) NOT NULL DEFAULT '1' ,
  `last_login_on` DATETIME NULL DEFAULT NULL ,
  `language` VARCHAR(5) NULL DEFAULT '' ,
  `auth_source_id` INT(11) NULL DEFAULT NULL ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `updated_on` DATETIME NULL DEFAULT NULL ,
  `type` VARCHAR(255) NULL DEFAULT NULL ,
  `identity_url` VARCHAR(255) NULL DEFAULT NULL ,
  `mail_notification` VARCHAR(255) NOT NULL DEFAULT '' ,
  `salt` VARCHAR(64) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `index_users_on_id_and_type` (`id` ASC, `type` ASC) ,
  INDEX `index_users_on_auth_source_id` (`auth_source_id` ASC) ,
  INDEX `index_users_on_type` (`type` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 6
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`versions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`versions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL DEFAULT '0' ,
  `name` VARCHAR(255) NOT NULL DEFAULT '' ,
  `description` VARCHAR(255) NULL DEFAULT '' ,
  `effective_date` DATE NULL DEFAULT NULL ,
  `created_on` DATETIME NULL DEFAULT NULL ,
  `updated_on` DATETIME NULL DEFAULT NULL ,
  `wiki_page_title` VARCHAR(255) NULL DEFAULT NULL ,
  `status` VARCHAR(255) NULL DEFAULT 'open' ,
  `sharing` VARCHAR(255) NOT NULL DEFAULT 'none' ,
  PRIMARY KEY (`id`) ,
  INDEX `versions_project_id` (`project_id` ASC) ,
  INDEX `index_versions_on_sharing` (`sharing` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`watchers`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`watchers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `watchable_type` VARCHAR(255) NOT NULL DEFAULT '' ,
  `watchable_id` INT(11) NOT NULL DEFAULT '0' ,
  `user_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `watchers_user_id_type` (`user_id` ASC, `watchable_type` ASC) ,
  INDEX `index_watchers_on_user_id` (`user_id` ASC) ,
  INDEX `index_watchers_on_watchable_id_and_watchable_type` (`watchable_id` ASC, `watchable_type` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`wiki_content_versions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`wiki_content_versions` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `wiki_content_id` INT(11) NOT NULL ,
  `page_id` INT(11) NOT NULL ,
  `author_id` INT(11) NULL DEFAULT NULL ,
  `data` LONGBLOB NULL DEFAULT NULL ,
  `compression` VARCHAR(6) NULL DEFAULT '' ,
  `comments` VARCHAR(255) NULL DEFAULT '' ,
  `updated_on` DATETIME NOT NULL ,
  `version` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `wiki_content_versions_wcid` (`wiki_content_id` ASC) ,
  INDEX `index_wiki_content_versions_on_updated_on` (`updated_on` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`wiki_contents`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`wiki_contents` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `page_id` INT(11) NOT NULL ,
  `author_id` INT(11) NULL DEFAULT NULL ,
  `text` LONGTEXT NULL DEFAULT NULL ,
  `comments` VARCHAR(255) NULL DEFAULT '' ,
  `updated_on` DATETIME NOT NULL ,
  `version` INT(11) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `wiki_contents_page_id` (`page_id` ASC) ,
  INDEX `index_wiki_contents_on_author_id` (`author_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`wiki_pages`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`wiki_pages` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `wiki_id` INT(11) NOT NULL ,
  `title` VARCHAR(255) NOT NULL ,
  `created_on` DATETIME NOT NULL ,
  `protected` TINYINT(1) NOT NULL DEFAULT '0' ,
  `parent_id` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `wiki_pages_wiki_id_title` (`wiki_id` ASC, `title` ASC) ,
  INDEX `index_wiki_pages_on_wiki_id` (`wiki_id` ASC) ,
  INDEX `index_wiki_pages_on_parent_id` (`parent_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`wiki_redirects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`wiki_redirects` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `wiki_id` INT(11) NOT NULL ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  `redirects_to` VARCHAR(255) NULL DEFAULT NULL ,
  `created_on` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `wiki_redirects_wiki_id_title` (`wiki_id` ASC, `title` ASC) ,
  INDEX `index_wiki_redirects_on_wiki_id` (`wiki_id` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`wikis`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`wikis` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `project_id` INT(11) NOT NULL ,
  `start_page` VARCHAR(255) NOT NULL ,
  `status` INT(11) NOT NULL DEFAULT '1' ,
  PRIMARY KEY (`id`) ,
  INDEX `wikis_project_id` (`project_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `redmine`.`workflows`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `redmine`.`workflows` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `tracker_id` INT(11) NOT NULL DEFAULT '0' ,
  `old_status_id` INT(11) NOT NULL DEFAULT '0' ,
  `new_status_id` INT(11) NOT NULL DEFAULT '0' ,
  `role_id` INT(11) NOT NULL DEFAULT '0' ,
  `assignee` TINYINT(1) NOT NULL DEFAULT '0' ,
  `author` TINYINT(1) NOT NULL DEFAULT '0' ,
  `type` VARCHAR(30) NULL DEFAULT NULL ,
  `field_name` VARCHAR(30) NULL DEFAULT NULL ,
  `rule` VARCHAR(30) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `wkfs_role_tracker_old_status` (`role_id` ASC, `tracker_id` ASC, `old_status_id` ASC) ,
  INDEX `index_workflows_on_old_status_id` (`old_status_id` ASC) ,
  INDEX `index_workflows_on_role_id` (`role_id` ASC) ,
  INDEX `index_workflows_on_new_status_id` (`new_status_id` ASC) )
ENGINE = InnoDB
AUTO_INCREMENT = 145
DEFAULT CHARACTER SET = utf8;

USE `redmine` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
