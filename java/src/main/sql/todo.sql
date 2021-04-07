-- Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
-- Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.

CREATE TABLE `todos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_done` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;