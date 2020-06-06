/*
SQLyog Ultimate v12.3.1 (64 bit)
MySQL - 5.7.24 : Database - examxx
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`examxx` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `examxx`;

/*Table structure for table `et_comment` */

DROP TABLE IF EXISTS `et_comment`;

CREATE TABLE `et_comment` (
  `comment_id` int(10) NOT NULL AUTO_INCREMENT,
  `question_id` int(10) NOT NULL,
  `index_id` int(10) NOT NULL,
  `user_id` int(10) NOT NULL,
  `content_msg` mediumtext NOT NULL,
  `quoto_id` int(10) NOT NULL DEFAULT '0',
  `re_id` int(10) NOT NULL DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `fk_q_id` (`question_id`),
  KEY `fk_u_id` (`user_id`),
  CONSTRAINT `fk_q_id` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_u_id` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_comment` */

/*Table structure for table `et_exam_paper` */

DROP TABLE IF EXISTS `et_exam_paper`;

CREATE TABLE `et_exam_paper` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `content` mediumtext,
  `duration` int(11) NOT NULL COMMENT '试卷考试时间',
  `total_point` int(11) DEFAULT '0',
  `pass_point` int(11) DEFAULT '0',
  `group_id` int(11) NOT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否所有用户可见，默认为0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试卷状态， 0未完成 -> 1已完成 -> 2已发布 -> 3通过审核 （已发布和通过审核的无法再修改）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `summary` varchar(100) DEFAULT NULL COMMENT '试卷介绍',
  `is_subjective` tinyint(1) DEFAULT NULL COMMENT '为1表示为包含主观题的试卷，需阅卷',
  `answer_sheet` mediumtext COMMENT '试卷答案，用答题卡的结构保存',
  `creator` varchar(40) DEFAULT NULL COMMENT '创建人的账号',
  `paper_type` varchar(40) NOT NULL DEFAULT '1' COMMENT '0 真题 1 模拟 2 专家',
  `field_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试卷';

/*Data for the table `et_exam_paper` */

/*Table structure for table `et_field` */

DROP TABLE IF EXISTS `et_field`;

CREATE TABLE `et_field` (
  `field_id` int(5) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(50) NOT NULL,
  `memo` varchar(100) DEFAULT NULL,
  `state` decimal(1,0) NOT NULL DEFAULT '1' COMMENT '1 正常 0 废弃',
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `et_field` */

insert  into `et_field`(`field_id`,`field_name`,`memo`,`state`) values 
(3,'ACCP','ACCP软件工程师',1);

/*Table structure for table `et_group` */

DROP TABLE IF EXISTS `et_group`;

CREATE TABLE `et_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `group_level_id` int(11) NOT NULL COMMENT '班组级别',
  `parent` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_level_id` (`group_level_id`),
  KEY `parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='班组';

/*Data for the table `et_group` */

/*Table structure for table `et_knowledge_point` */

DROP TABLE IF EXISTS `et_knowledge_point`;

CREATE TABLE `et_knowledge_point` (
  `point_id` int(5) NOT NULL AUTO_INCREMENT,
  `point_name` varchar(100) NOT NULL,
  `field_id` int(5) NOT NULL,
  `memo` varchar(100) DEFAULT NULL,
  `state` decimal(1,0) DEFAULT '1' COMMENT '1:正常 0：废弃',
  PRIMARY KEY (`point_id`),
  KEY `fk_knowledge_field` (`field_id`),
  CONSTRAINT `et_knowledge_point_ibfk_1` FOREIGN KEY (`field_id`) REFERENCES `et_field` (`field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Data for the table `et_knowledge_point` */

insert  into `et_knowledge_point`(`point_id`,`point_name`,`field_id`,`memo`,`state`) values 
(6,'SpringIOC',3,'IOC容器',1);

/*Table structure for table `et_news` */

DROP TABLE IF EXISTS `et_news`;

CREATE TABLE `et_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `titile` varchar(100) NOT NULL,
  `content` varchar(2000) NOT NULL,
  `user_id` int(11) NOT NULL COMMENT '创建人',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `is_expire` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否过期',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 新闻， 1 系统信息',
  `group_id` int(11) NOT NULL DEFAULT '-1' COMMENT '此系统属于哪个组',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `et_news_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_news` */

/*Table structure for table `et_practice_paper` */

DROP TABLE IF EXISTS `et_practice_paper`;

CREATE TABLE `et_practice_paper` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `content` mediumtext,
  `duration` int(11) NOT NULL COMMENT '试卷考试时间',
  `total_point` int(11) DEFAULT '0',
  `pass_point` int(11) DEFAULT '0',
  `group_id` int(11) NOT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否所有用户可见，默认为0',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试卷状态， 0未完成 -> 1已完成 -> 2已发布 -> 3通过审核 （已发布和通过审核的无法再修改）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `summary` varchar(100) DEFAULT NULL COMMENT '试卷介绍',
  `is_subjective` tinyint(1) DEFAULT NULL COMMENT '为1表示为包含主观题的试卷，需阅卷',
  `answer_sheet` mediumtext COMMENT '试卷答案，用答题卡的结构保存',
  `creator` varchar(40) DEFAULT NULL COMMENT '创建人的账号',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='试卷';

/*Data for the table `et_practice_paper` */

/*Table structure for table `et_question` */

DROP TABLE IF EXISTS `et_question`;

CREATE TABLE `et_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `content` varchar(2000) NOT NULL,
  `question_type_id` int(11) NOT NULL COMMENT '题型',
  `duration` int(11) DEFAULT NULL COMMENT '试题考试时间',
  `points` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL COMMENT '班组ID',
  `is_visible` tinyint(1) NOT NULL DEFAULT '0' COMMENT '试题可见性',
  `create_time` timestamp NULL DEFAULT NULL,
  `creator` varchar(20) NOT NULL DEFAULT 'admin' COMMENT '创建者',
  `last_modify` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `answer` mediumtext NOT NULL,
  `expose_times` int(11) NOT NULL DEFAULT '2',
  `right_times` int(11) NOT NULL DEFAULT '1',
  `wrong_times` int(11) NOT NULL DEFAULT '1',
  `difficulty` int(5) NOT NULL DEFAULT '1',
  `analysis` mediumtext,
  `reference` varchar(1000) DEFAULT NULL,
  `examing_point` varchar(5000) DEFAULT NULL,
  `keyword` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_type_id` (`question_type_id`),
  KEY `et_question_ibfk_5` (`creator`),
  CONSTRAINT `et_question_ibfk_1` FOREIGN KEY (`question_type_id`) REFERENCES `et_question_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8 COMMENT='试题';

/*Data for the table `et_question` */

/*Table structure for table `et_question_2_point` */

DROP TABLE IF EXISTS `et_question_2_point`;

CREATE TABLE `et_question_2_point` (
  `question_2_point_id` int(10) NOT NULL AUTO_INCREMENT,
  `question_id` int(10) DEFAULT NULL,
  `point_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`question_2_point_id`),
  KEY `fk_question_111` (`question_id`),
  KEY `fk_point_111` (`point_id`),
  CONSTRAINT `et_question_2_point_ibfk_1` FOREIGN KEY (`point_id`) REFERENCES `et_knowledge_point` (`point_id`),
  CONSTRAINT `et_question_2_point_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=134 DEFAULT CHARSET=utf8;

/*Data for the table `et_question_2_point` */

/*Table structure for table `et_question_2_tag` */

DROP TABLE IF EXISTS `et_question_2_tag`;

CREATE TABLE `et_question_2_tag` (
  `question_tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`question_tag_id`),
  KEY `fk_question_tag_tid` (`tag_id`),
  KEY `fk_question_tag_qid` (`question_id`),
  CONSTRAINT `fk_question_tag_qid` FOREIGN KEY (`question_id`) REFERENCES `et_question` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_question_tag_tid` FOREIGN KEY (`tag_id`) REFERENCES `et_tag` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `et_question_2_tag` */

/*Table structure for table `et_question_type` */

DROP TABLE IF EXISTS `et_question_type`;

CREATE TABLE `et_question_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `subjective` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='试题类型';

/*Data for the table `et_question_type` */

insert  into `et_question_type`(`id`,`name`,`subjective`) values 
(1,'单选题',0),
(2,'多选题',0),
(3,'判断题',0),
(4,'填空题',0),
(5,'简答题',1),
(6,'论述题',1),
(7,'分析题',1);

/*Table structure for table `et_r_user_role` */

DROP TABLE IF EXISTS `et_r_user_role`;

CREATE TABLE `et_r_user_role` (
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `role_id` int(11) NOT NULL COMMENT '角色ID',
  KEY `user_id` (`user_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `et_r_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `et_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户_角色 关联表';

/*Data for the table `et_r_user_role` */

insert  into `et_r_user_role`(`user_id`,`role_id`) values 
(4,1);

/*Table structure for table `et_reference` */

DROP TABLE IF EXISTS `et_reference`;

CREATE TABLE `et_reference` (
  `reference_id` int(5) NOT NULL AUTO_INCREMENT,
  `reference_name` varchar(200) NOT NULL,
  `memo` varchar(200) DEFAULT NULL,
  `state` decimal(10,0) NOT NULL DEFAULT '1' COMMENT '1 正常 0 废弃',
  PRIMARY KEY (`reference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

/*Data for the table `et_reference` */

/*Table structure for table `et_role` */

DROP TABLE IF EXISTS `et_role`;

CREATE TABLE `et_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authority` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `code` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='角色表';

/*Data for the table `et_role` */

insert  into `et_role`(`id`,`authority`,`name`,`code`) values 
(1,'ROLE_ADMIN','超级管理员','admin'),
(2,'ROLE_TEACHER','教师','teacher'),
(3,'ROLE_STUDENT','学员','student');

/*Table structure for table `et_tag` */

DROP TABLE IF EXISTS `et_tag`;

CREATE TABLE `et_tag` (
  `tag_id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(100) NOT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creator` int(11) NOT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '0',
  `memo` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `fk_tag_creator` (`creator`),
  CONSTRAINT `fk_tag_creator` FOREIGN KEY (`creator`) REFERENCES `et_user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `et_tag` */

insert  into `et_tag`(`tag_id`,`tag_name`,`create_time`,`creator`,`is_private`,`memo`) values 
(4,'Spring','2020-06-06 18:08:46',4,0,'Spring框架'),
(5,'SpringMVC','2020-06-06 18:09:22',4,0,'SpringMVC框架');

/*Table structure for table `et_user` */

DROP TABLE IF EXISTS `et_user`;

CREATE TABLE `et_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'PK',
  `username` varchar(20) NOT NULL COMMENT '账号',
  `truename` varchar(10) DEFAULT NULL COMMENT '真实姓名',
  `password` char(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `add_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expire_date` timestamp NULL DEFAULT NULL,
  `add_by` int(11) DEFAULT NULL COMMENT '创建人',
  `enabled` tinyint(1) DEFAULT '0' COMMENT '激活状态：0-未激活 1-激活',
  `field_id` int(10) NOT NULL,
  `last_login_time` timestamp NULL DEFAULT NULL,
  `login_time` timestamp NULL DEFAULT NULL,
  `province` varchar(20) DEFAULT NULL,
  `company` varchar(40) DEFAULT NULL,
  `department` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='用户表';

/*Data for the table `et_user` */

insert  into `et_user`(`id`,`username`,`truename`,`password`,`email`,`phone`,`add_date`,`expire_date`,`add_by`,`enabled`,`field_id`,`last_login_time`,`login_time`,`province`,`company`,`department`) values 
(4,'admin',NULL,'260acbffd3c30786febc29d7dd71a9880a811e77','1@1.1',NULL,'2020-06-06 18:50:17',NULL,NULL,1,3,'2020-06-06 17:27:30','2020-06-06 17:48:02',NULL,'2','3');

/*Table structure for table `et_user_exam_history` */

DROP TABLE IF EXISTS `et_user_exam_history`;

CREATE TABLE `et_user_exam_history` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) NOT NULL,
  `exam_paper_id` int(10) NOT NULL,
  `content` mediumtext,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `answer_sheet` mediumtext,
  `duration` int(10) NOT NULL,
  `point_get` float(10,1) NOT NULL DEFAULT '0.0',
  `submit_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Data for the table `et_user_exam_history` */

/*Table structure for table `et_user_question_history_t` */

DROP TABLE IF EXISTS `et_user_question_history_t`;

CREATE TABLE `et_user_question_history_t` (
  `user_question_hist_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `user_question_hist` mediumtext NOT NULL,
  `modify_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_question_hist_id`),
  UNIQUE KEY `idx_u_q_hist_userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `et_user_question_history_t` */

/*Table structure for table `t_c3p0` */

DROP TABLE IF EXISTS `t_c3p0`;

CREATE TABLE `t_c3p0` (
  `a` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Data for the table `t_c3p0` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
