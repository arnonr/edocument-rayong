-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: mysql
-- Generation Time: Mar 07, 2023 at 04:10 PM
-- Server version: 8.0.32
-- PHP Version: 8.0.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `edocument_rayong`
--

-- --------------------------------------------------------

--
-- Table structure for table `book_code`
--

CREATE TABLE `book_code` (
  `id` int NOT NULL,
  `book_in` int DEFAULT NULL,
  `book_out` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `status` int DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_code`
--

INSERT INTO `book_code` (`id`, `book_in`, `book_out`, `year`, `status`, `created_at`, `updated_at`, `active`) VALUES
(1, 622, 0, 2, 1, '2022-01-13 06:04:14', '2022-11-23 07:26:56', 1);

-- --------------------------------------------------------

--
-- Table structure for table `book_favorite`
--

CREATE TABLE `book_favorite` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `book_type` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `book_in`
--

CREATE TABLE `book_in` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก',
  `title` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'เรื่อง',
  `book_in_category_id` int DEFAULT NULL COMMENT 'หมวดหมู่เอกสาร',
  `book_in_type_id` int DEFAULT NULL COMMENT 'ประเภทเอกสาร',
  `book_from_no` varchar(255) DEFAULT NULL COMMENT 'เลขที่ต้นทาง',
  `book_from_date` date DEFAULT NULL COMMENT 'ลงวันที่ต้นทาง',
  `book_from` varchar(500) DEFAULT NULL COMMENT 'หน่วยงานต้นทาง',
  `receive_date` date DEFAULT NULL COMMENT 'วันที่รับเอกสาร',
  `book_no` varchar(255) DEFAULT NULL COMMENT 'เลขรับเอกสาร',
  `to_send` varchar(500) DEFAULT NULL COMMENT 'ผู้รับ(ส่งถึง)',
  `book_in_file` varchar(255) DEFAULT NULL COMMENT 'ไฟล์ต้นฉบับ',
  `book_in_success_file` varchar(255) DEFAULT NULL COMMENT 'ไฟล์ฉบับสมบูรณ์',
  `department_to` int DEFAULT NULL COMMENT 'หน่วยงานที่เกี่ยวข้อง',
  `book_to` longtext COMMENT 'ส่งเมล',
  `book_reference` varchar(255) DEFAULT NULL COMMENT 'อ้างถึงเลขรับเอกสาร',
  `book_year_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงปี',
  `remark` longtext COMMENT 'หมายเหตุ',
  `status_id` int DEFAULT NULL COMMENT 'รหัสสถานะ',
  `book_page_count` int NOT NULL DEFAULT '1',
  `book_page_count_sum` int DEFAULT '1',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_in`
--

INSERT INTO `book_in` (`id`, `title`, `book_in_category_id`, `book_in_type_id`, `book_from_no`, `book_from_date`, `book_from`, `receive_date`, `book_no`, `to_send`, `book_in_file`, `book_in_success_file`, `department_to`, `book_to`, `book_reference`, `book_year_id`, `remark`, `status_id`, `book_page_count`, `book_page_count_sum`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(233, 'ขออนุมัติใช้รถตู้', 1, 3, 'กน.รย.01/2566', '2023-01-03', 'กองกิจการนักศึกษา', '2023-01-03', '0001/2566', 'รองอธิการบดีฯ', '/document/book-in/2566/0001-2566-0001-66.pdf', '/document/book-in/2566/success/0001-2566-0001-66.pdf', 3, NULL, NULL, 1, 'กลุ่มงานกิจการนักศึกษา มจพ.วิทยาเขตระยอง', 4, 7, 7, 1, NULL, '2023-02-28 07:08:19', 'arnonr', '2023-02-28 07:08:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_in_category`
--

CREATE TABLE `book_in_category` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงหน่วยงาน',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อหน่วยงาน',
  `book_year_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงปี',
  `level` int DEFAULT NULL COMMENT 'ลำดับ',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT '	วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT '	ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_in_category`
--

INSERT INTO `book_in_category` (`id`, `name`, `book_year_id`, `level`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'เอกสารรับภายใน', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(2, 'เอกสารรับภายนอก', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_in_old`
--

CREATE TABLE `book_in_old` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก',
  `title` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'เรื่อง',
  `book_in_category_id` int DEFAULT NULL COMMENT 'หมวดหมู่เอกสาร',
  `book_in_type_id` int DEFAULT NULL COMMENT 'ประเภทเอกสาร',
  `book_from_no` varchar(255) DEFAULT NULL COMMENT 'เลขที่ต้นทาง',
  `book_from_date` date DEFAULT NULL COMMENT 'ลงวันที่ต้นทาง',
  `book_from` varchar(500) DEFAULT NULL COMMENT 'หน่วยงานต้นทาง',
  `receive_date` date DEFAULT NULL COMMENT 'วันที่รับเอกสาร',
  `book_no` varchar(255) DEFAULT NULL COMMENT 'เลขรับเอกสาร',
  `to_send` varchar(500) DEFAULT NULL COMMENT 'ผู้รับ(ส่งถึง)',
  `book_in_file` varchar(255) DEFAULT NULL COMMENT 'ไฟล์ต้นฉบับ',
  `book_in_success_file` varchar(255) DEFAULT NULL COMMENT 'ไฟล์ฉบับสมบูรณ์',
  `department_to` int DEFAULT NULL COMMENT 'หน่วยงานที่เกี่ยวข้อง',
  `book_to` longtext COMMENT 'ส่งเมล',
  `book_reference` varchar(255) DEFAULT NULL COMMENT 'อ้างถึงเลขรับเอกสาร',
  `book_year_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงปี',
  `remark` longtext COMMENT 'หมายเหตุ',
  `status_id` int DEFAULT NULL COMMENT 'รหัสสถานะ',
  `book_page_count` int NOT NULL DEFAULT '1',
  `book_page_count_sum` int DEFAULT '1',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `book_in_type`
--

CREATE TABLE `book_in_type` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงประเภท',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อประเภท',
  `book_in_category_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงหมวดหมู่',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT '	วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT '	ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_in_type`
--

INSERT INTO `book_in_type` (`id`, `name`, `book_in_category_id`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'ประกาศ', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(2, 'คำสั่ง', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(3, 'บันทึกข้อความ', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(4, 'มติ', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:58:50', NULL),
(5, 'ข้อบังคับ', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:59:00', NULL),
(6, 'ประชาสัมพันธ์', 2, 1, NULL, '2022-01-26 08:30:42', NULL, '2022-01-26 08:30:42', NULL),
(7, 'คำสั่งแต่งตั้ง', 2, 1, NULL, '2022-10-04 00:59:33', NULL, '2022-10-04 00:59:33', NULL),
(8, 'เชิญประชุม', 2, 1, NULL, '2022-10-04 00:59:33', NULL, '2022-10-04 00:59:33', NULL),
(9, 'บันทึกข้อความ', 2, 1, NULL, '2022-10-04 00:59:33', NULL, '2022-10-04 00:59:33', NULL),
(10, 'อื่นๆ', 2, 1, NULL, '2022-10-04 00:59:33', NULL, '2022-10-04 00:59:33', NULL),
(11, 'เอกสารหน่วยงานภายนอก', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:59:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_out`
--

CREATE TABLE `book_out` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก',
  `title` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'เรื่อง',
  `book_out_category_id` int DEFAULT NULL COMMENT 'หมวดหมู่เอกสาร',
  `book_out_type_id` int DEFAULT NULL COMMENT 'ประเภทเอกสาร',
  `receive_date` date DEFAULT NULL COMMENT 'วันที่รับเอกสาร',
  `return_date` date DEFAULT NULL COMMENT 'วันที่ส่งคืน',
  `book_no` varchar(255) DEFAULT NULL COMMENT 'เลขรับเอกสาร',
  `book_date` date DEFAULT NULL COMMENT 'ลงวันที่',
  `to_send` varchar(500) DEFAULT NULL COMMENT 'ผู้รับ(ส่งถึง)',
  `book_out_file` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ไฟล์ต้นฉบับ',
  `book_out_success_file` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ไฟล์ฉบับสมบูรณ์',
  `department_id` int DEFAULT NULL COMMENT 'หน่วยงาน',
  `book_to` longtext COMMENT 'ส่งเมล',
  `book_reference` varchar(255) DEFAULT NULL COMMENT 'อ้างถึงเลขรับเอกสาร',
  `book_year_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงปี',
  `remark` longtext COMMENT 'หมายเหตุ',
  `status_id` int DEFAULT NULL COMMENT 'รหัสสถานะ',
  `user_id` int DEFAULT NULL COMMENT 'ผู้รับผิดชอบ',
  `book_page_count` int NOT NULL DEFAULT '1',
  `book_page_count_sum` int DEFAULT '1',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_out`
--

INSERT INTO `book_out` (`id`, `title`, `book_out_category_id`, `book_out_type_id`, `receive_date`, `return_date`, `book_no`, `book_date`, `to_send`, `book_out_file`, `book_out_success_file`, `department_id`, `book_to`, `book_reference`, `book_year_id`, `remark`, `status_id`, `user_id`, `book_page_count`, `book_page_count_sum`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(234, 'ขอส่งรายงานวัสดุคงเหลือ เดือน ธันวาคม ประจำปีงบประมาณ พ.ศ.2566', 1, NULL, NULL, NULL, '0001/2566', '2023-01-03', 'ผู้อำนวยการกองงานพัสดุ', '/document/book-out/2566/001-2566-001.pdf', '/document/book-out/2566/success/001-2566-001.pdf', NULL, NULL, 'null', 1, 'null', 4, 159, 1, 1, 1, NULL, '2023-03-06 10:34:50', 'arnonr', '2023-03-06 10:47:57', NULL),
(235, 'สรุปผลการปฏิบัติงานพนักงานรักษาความปลอดภัย ประจำเดือน ธันวาคม 2565', 1, NULL, NULL, NULL, '0002/2566', '2023-01-03', 'รองอธิการบดีฯ', '/document/book-out/2566/0002-2566-002.pdf', '/document/book-out/2566/success/0002-2566-002-65.pdf', NULL, NULL, 'null', 1, 'null', 4, 154, 1, 1, 1, NULL, '2023-03-06 10:38:58', 'arnonr', '2023-03-06 10:47:43', NULL),
(236, 'สรุปผลการปฏิบัติงานพนักงานรักษาความสะอาด ประจำเดือน ธันวาคม 2565', 1, NULL, NULL, NULL, '0003/2566', '2023-01-03', 'รองอธิการบดีฯ', '/document/book-out/2566/003-2566-003.pdf', '/document/book-out/2566/success/003-2566-003-65.pdf', NULL, NULL, 'null', 1, 'null', 4, 154, 1, 1, 1, NULL, '2023-03-06 10:42:31', 'arnonr', '2023-03-06 10:47:28', NULL),
(237, 'แจ้งค่าจ้างเหมาบริการพนักงานรักษาความปลอดภัย ประจำเดือน ธันวาคม 2565', 1, NULL, NULL, NULL, '0004/2566', '2023-01-03', 'คณบดีคณะบริหารธุรกิจ , คณบดีคณะวิทยาศาสตร์ พลังงานและสิ่งแวดล้อม', '/document/book-out/2566/0004-2566-004-65.pdf', '/document/book-out/2566/success/0004-2566-004-65.pdf', NULL, NULL, 'null', 1, 'null', 4, 154, 1, 1, 1, NULL, '2023-03-06 10:46:53', 'arnonr', '2023-03-06 10:57:54', NULL),
(238, 'แจ้งค่าจ้างเหมาบริการพนักงานรักษาความปลอดภัย ประจำเดือน ธันวาคม 2565', 1, NULL, NULL, NULL, '0005/2566', '2023-01-03', 'คณบดีคณะวิศวกรรมศาสตร์และเทคโนโลยี', '/document/book-out/2566/0005-2566-005-65.pdf', '/document/book-out/2566/success/0005-2566-005-65.pdf', NULL, NULL, NULL, 1, NULL, 4, 154, 1, 1, 1, NULL, '2023-03-06 10:56:26', 'arnonr', '2023-03-06 10:56:26', NULL),
(239, 'ขออนุมัติจ้างเหมาบริการพนักงานล้างจานและทำความสะอาด โรงอาหารกลาง มจพ.วิทยาเขตระยอง ประจำเดือน ม.ค.-เม.ย.66 จำนวน 79 วัน วงเงิน 83,898.00 บาท', 1, NULL, NULL, NULL, '0006/2566', '2023-01-03', 'อธิการบดี', '/document/book-out/2566/0006-2566-006.pdf', '/document/book-out/2566/success/0006-2566-006-66.pdf', NULL, NULL, NULL, 1, NULL, 4, 148, 3, 3, 1, NULL, '2023-03-06 11:00:57', 'arnonr', '2023-03-06 11:00:57', NULL),
(240, 'รายงานผลการจัดทำร่างขอบเขตของงานรายละเอียดคุณลักษณะเฉพาะของพัสดุและราคากลาง รายการระบบภาพ เสียง และความปลอดภัยอาคารวิทยาศาสตร์การกีฬา วงเงิน 9,334,800.00 บาท', 1, NULL, NULL, NULL, '0011/2566', '2023-01-04', 'อธิการบดี', '/document/book-out/2566/0011-2566-011-66.pdf', '/document/book-out/2566/success/0011-2566-011-66.pdf', NULL, NULL, NULL, 1, NULL, 4, 146, 1, 1, 1, NULL, '2023-03-06 11:06:47', 'arnonr', '2023-03-06 11:06:47', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_out_category`
--

CREATE TABLE `book_out_category` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงหน่วยงาน',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อหน่วยงาน',
  `book_year_id` int DEFAULT NULL COMMENT 'รหัสอ้างอิงปี',
  `level` int DEFAULT NULL COMMENT 'ลำดับ',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT '	วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT '	ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_out_category`
--

INSERT INTO `book_out_category` (`id`, `name`, `book_year_id`, `level`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'ก.รย.', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(2, 'มจพ.รย.', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(3, 'อว 7101.16', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(4, 'คำสั่ง รย.', 1, NULL, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_out_favorite`
--

CREATE TABLE `book_out_favorite` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `book_id` int DEFAULT NULL,
  `book_type` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `book_out_old`
--

CREATE TABLE `book_out_old` (
  `id` int NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `book_out_category_id` int DEFAULT NULL,
  `book_no` varchar(255) DEFAULT NULL,
  `book_to` varchar(500) DEFAULT NULL,
  `status_id` int NOT NULL DEFAULT '1',
  `dep_id` int DEFAULT NULL,
  `file` varchar(500) DEFAULT NULL,
  `file_success` varchar(500) DEFAULT NULL,
  `detail` longtext,
  `date_send` datetime DEFAULT NULL,
  `to_send` varchar(500) DEFAULT NULL,
  `date_receive` datetime DEFAULT NULL,
  `date_return` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `book_year_id` int NOT NULL DEFAULT '1',
  `book_page_count` int DEFAULT '1',
  `book_page_count_sum` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `book_out_type`
--

CREATE TABLE `book_out_type` (
  `id` int NOT NULL,
  `title` varchar(500) DEFAULT NULL,
  `acronym` varchar(255) DEFAULT NULL,
  `code` int DEFAULT '0',
  `year` int DEFAULT NULL,
  `level` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_out_type`
--

INSERT INTO `book_out_type` (`id`, `title`, `acronym`, `code`, `year`, `level`, `created_at`, `updated_at`, `active`) VALUES
(1, 'ก.รย.', 'ก.รย.', 934, 2, NULL, '2022-01-13 06:05:15', '2023-02-08 14:16:30', 1),
(2, 'มจพ.รย.', 'มจพ.รย.', 31, 2, NULL, '2022-01-13 06:05:15', '2022-10-20 09:11:58', 1),
(3, 'บธ(2)', 'บธ(2)', 1, 2, 2, '2022-01-13 06:05:15', '2022-10-04 04:14:29', 0),
(4, 'อว 7101.16', 'อว 7101.16', 1, 2, NULL, '2022-01-13 06:05:15', '2022-10-04 04:31:09', 1),
(5, 'คำสั่ง รย.', 'คำสั่ง รย.', 4, 2, NULL, '2022-01-13 06:05:15', '2022-10-12 06:32:30', 1);

-- --------------------------------------------------------

--
-- Table structure for table `book_status`
--

CREATE TABLE `book_status` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงสถานะ',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อสถานะ',
  `color` varchar(255) DEFAULT NULL COMMENT 'สี',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_status`
--

INSERT INTO `book_status` (`id`, `name`, `color`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'รอสารบรรณรับเรื่อง', 'warning', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(2, 'อยู่ระหว่างดำเนินการ', 'info', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(3, 'อนุมัติเรียบร้อย', 'success', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(4, 'เสร็จสิ้น', 'success', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:58:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `book_year`
--

CREATE TABLE `book_year` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงหน่วยงาน',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อหน่วยงาน',
  `status` int NOT NULL DEFAULT '1',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT '	วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT '	ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `book_year`
--

INSERT INTO `book_year` (`id`, `name`, `status`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, '2566', 1, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(8, '2565', 0, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(9, '2564', 0, 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

CREATE TABLE `department` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงหน่วยงาน',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'ชื่อหน่วยงาน',
  `is_publish` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT '	วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT '	ผู้แก้ไขข้อมูลล่าสุด	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `department`
--

INSERT INTO `department` (`id`, `name`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'งานบริหารและธุรการ', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(2, 'งานพัฒนาบุคลากร', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(3, 'งานอาคารสถานที่และยานพาหนะ', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-01-12 15:44:02', NULL),
(4, 'งานประชาสัมพันธ์และงานสารสนเทศ', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:58:50', NULL),
(5, 'งานคลังและพัสดุ', 1, NULL, '2022-01-12 15:44:02', NULL, '2022-10-04 00:59:00', NULL),
(6, 'งานบริการการศึกษา', 1, NULL, '2022-01-26 08:30:42', NULL, '2022-01-26 08:30:42', NULL),
(7, 'ฝ่ายบริหาร', 1, NULL, '2022-10-04 00:59:33', NULL, '2022-10-04 00:59:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `email_group`
--

CREATE TABLE `email_group` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงเมล',
  `name` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ชื่อ',
  `email_all` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci COMMENT 'อีเมล',
  `is_publish` int DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `email_group`
--

INSERT INTO `email_group` (`id`, `name`, `email_all`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'คณะกรรมการ KM', '[{\"title\":\"อานนท์ รักจักร์ (arnon.r@tgde.kmutnb.ac.th)\",\"codeg\":1,\"email\":\"arnon.r@tgde.kmutnb.ac.th\"}]', 1, NULL, '2022-01-25 04:48:20', '1', NULL, NULL),
(2, 'คณะกรรมการทดสอบ', '[{\"title\":\"อานนท์ รักจักร์ (arnon.r@tgde.kmutnb.ac.th)\",\"code\":1,\"email\":\"arnon.r@tgde.kmutnb.ac.th\"}]', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(3, 'คณะกรรมการ Green', '[{\"title\":\"อานนท์ รักจักร์ (arnon.r@tgde.kmutnb.ac.th)\",\"code\":1,\"email\":\"arnon.r@tgde.kmutnb.ac.th\"}]', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `email_person`
--

CREATE TABLE `email_person` (
  `id` int NOT NULL COMMENT 'รหัสอ้างอิงเมล',
  `prefix` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'คำนำหน้า',
  `firstname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'ชื่อ',
  `lastname` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'นามสกุล',
  `email` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT 'อีเมล',
  `is_publish` int DEFAULT '1' COMMENT '1 = เผยแพร่ / 0 = ปิดการเผยแพร่',
  `deleted_at` datetime DEFAULT NULL COMMENT 'วันที่ลบข้อมูล',
  `created_at` datetime DEFAULT NULL COMMENT 'วันที่เพิ่มข้อมูล',
  `created_by` varchar(255) DEFAULT NULL COMMENT 'ผู้เพิ่มข้อมูล',
  `updated_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขข้อมูลล่าสุด',
  `updated_by` varchar(255) DEFAULT NULL COMMENT 'ผู้แก้ไขข้อมูลล่าสุด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `email_person`
--

INSERT INTO `email_person` (`id`, `prefix`, `firstname`, `lastname`, `email`, `is_publish`, `deleted_at`, `created_at`, `created_by`, `updated_at`, `updated_by`) VALUES
(1, 'นาย', 'อานนท์', 'รักจักร์', 'arnon.r@tgde.kmutnb.ac.th', 1, NULL, '2022-01-25 04:48:20', '1', NULL, NULL),
(2, 'นาง', 'บุศรา', 'สิทธิศศิธร', 'butsara.s@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', '2023-02-28 06:33:28', 'arnonr'),
(3, 'นาง', 'พิศมัย', 'เยี่ยมแสงทอง', 'pissmai.y@eat.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(4, 'นาย', 'จิรพงศ์', 'ศุภประดิษฐ์กุล', 'jirapong.s@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(5, 'นาง', 'ปวีณา', 'เขื่อนแก้ว', 'paweena.k@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(6, 'นาย', 'เดชาชัย', 'แบ่งสันเทียะ', 'dachachai.b@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(7, 'นาง', 'ณิชชา', 'หงษ์วิไล', 'nitcha.h@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(8, 'นาย', 'ปรมินทร์', 'มีมงคล', 'poramin.m@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(9, 'นาย', 'วชิรวิทย์', 'ตลุนจันทร์', 'wachiravit.t@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(10, 'นางสาว', 'จุฑามณี', 'จันทร์พันธ์', 'jutamanee.j@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(11, 'นางสาว', 'พัชรี', 'บุญทอ', 'patcharee.b@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(12, 'ว่าที่ร้อยตรี', 'สุเมธ', 'ขัดสาย', 'sumet.k@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(13, 'นางสาว', 'จริยา', 'คำสกล', 'jariya.c@op.kmutnb.ac.th', NULL, NULL, '2022-07-26 04:22:15', '1', NULL, NULL),
(14, 'นาง', 'น้ำฝน', 'ศรีโพธิ์', 'numphon.s@op.kmutnb.ac.th', NULL, NULL, '2022-01-15 04:18:31', '1', NULL, NULL),
(15, 'นาง', 'สุพัตรา', 'พูนแก้ว', 'supattra.p@lib.kmutnb.ac.th', NULL, NULL, '2022-01-25 04:38:51', '1', NULL, NULL),
(16, 'นาย', 'ธนัช', 'เดชาปัญญาสถิต', 'thanat.d@lib.kmutnb.ac.th', NULL, NULL, '2022-01-26 08:03:54', '1', NULL, NULL),
(17, 'นาย', 'พนพล', 'วรนุช', 'panapon.v@icit.kmutnb.ac.th', NULL, NULL, '2022-01-26 08:04:39', '1', NULL, NULL),
(18, 'นางสาว', 'แววดาว', 'ไชโย', 'waewdao.c@op.kmutnb.ac.th', NULL, NULL, '2022-01-26 08:04:39', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(4, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(5, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(6, '2016_06_01_000004_create_oauth_clients_table', 1),
(7, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1),
(8, '2019_08_19_000000_create_failed_jobs_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `client_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `scopes` text,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `oauth_access_tokens`
--

INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('009630195a9e8701bd7cdd69b81aaf1c0ad522899b45b62260d50e5de2d27f9091708f68640ab403', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:44:59', '2022-01-21 06:44:59', '2022-01-28 06:44:59'),
('0124b14c44f6d51050d2f90053a3f411ddf2010a4d6808985a92c1af9d18ec229cfe82284da8e054', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-21 04:09:22', '2022-10-21 04:09:22', '2023-10-21 04:09:22'),
('015c45231889a0843a2b67c427a124d609ad500daa0fc248bd82f1a3afb930ab3df3601940fedf39', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-19 02:29:22', '2022-01-19 02:29:22', '2022-01-26 02:29:22'),
('0275e1f81d3239f47e4e157d11011e50b5644c6b7018d340bfbe8f1da66978711017a3a7bcee783d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 06:48:09', '2022-01-16 06:48:09', '2022-01-23 06:48:09'),
('03a5a90bfaff04abb42e84827dbbad143c4fac1a7f9910486fe1532c4a7c736643a116337261daab', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:58:16', '2022-01-17 07:58:16', '2022-01-24 07:58:16'),
('03decbecf1e261ac2cc9b8cf673c9c6391eb576abb758138a2250e9ca9d1210a86ce8e08fb015546', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-13 15:41:56', '2023-02-13 15:41:56', '2024-02-13 15:41:56'),
('03f5bf8f0be0b2364c53347fd9c64a172a0086068827f9974b4f26c0dc2374abf2be6edeb62d080b', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:18:40', '2022-01-16 04:18:40', '2022-01-23 04:18:40'),
('04b26badf575ee806b67a110229226bf69132ce742580f9392d651f12f6fa244e7d20727bb2beea6', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:08:14', '2022-01-21 07:08:14', '2023-01-21 07:08:14'),
('05bc47fbd054b3428efe1febc49fcd4932327a6a0b323e0301af5f16106c6d3ab0dd6bee77e2815c', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:51:28', '2022-01-21 06:51:28', '2023-01-21 06:51:28'),
('06544350e3ff69e48dfa616968c50cb4caa9eb4c187c182bc883871488a4720d24f907e7427382b7', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:10:14', '2022-10-04 03:10:14', '2022-10-11 03:10:14'),
('0671668d99e16d729e3d11fb05db72b97013cc72941531facff65eb0bb4ead74cadbca899f18c371', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-18 07:03:09', '2022-01-18 07:03:09', '2023-01-18 07:03:09'),
('068f833af22208eb910e279a4dfd8ded36b59304e3597a91fe98e33d85ac0e370c766e36baadb406', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:42:03', '2023-03-04 07:42:03', '2024-03-04 07:42:03'),
('069668a750b7d1853c41677949a4759a48d759ca75862ff5eebff72b8f62e35cd3526214747b3374', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:03:17', '2022-06-07 10:03:17', '2023-06-07 10:03:17'),
('06977d32f04112572bf5f56de0ae04643af3131c857a3a334c39b77d5e37c23020b551ed3eb6f3cf', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 13:31:11', '2022-01-12 13:31:11', '2023-01-12 13:31:11'),
('06e5cce7d6a429ed495dc35680d55567f3a2659dfdc9f827cf52206661174e56d359fb116e510482', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:48:26', '2022-01-24 04:48:26', '2022-01-31 04:48:26'),
('06e8ce084dbb22fcd9dc88c72fb052491f54ba5db28108cd2de6a1f648d125220bcc621130d2fb28', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-05 12:47:42', '2022-10-05 12:47:42', '2022-10-12 12:47:42'),
('07706d416088907a7178d9920cb99cdec23fc9cd880ab1a60be024e764a71ace85606ac33fa58bba', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-03 01:51:25', '2022-11-03 01:51:25', '2023-11-03 01:51:25'),
('07f2a25d9f808db2842af03613b75bb6f72e74ec3afd1045c59efd58045d6766320f40929041c9a4', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-05 12:18:04', '2022-10-05 12:18:04', '2022-10-12 12:18:04'),
('0861f00224c62f33f1fa6b0a91cccb5ffa4de8a3eb466ec518ad93efba6c8c4a770ac53fb8bbe25d', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:10:01', '2022-10-04 03:10:01', '2022-10-11 03:10:01'),
('086e2e74f65abb5ae2882fac59014f4948ba0f30f3e30ad75ce439738263ac4571fd676acc249f5f', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 00:56:16', '2022-10-04 00:56:16', '2022-10-11 00:56:16'),
('089208a547ae91719b004376f98fe0d7a8cac75f35db0986099e919b3a0101e6dd7424d7fc72ee89', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 09:30:09', '2022-01-24 09:30:09', '2022-01-31 09:30:09'),
('08ba2b2fee17038dd0fd13da0f108367d11c6756f1a7f42409da29435dc42c901d37d3a7332e7f60', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:11:03', '2022-02-08 08:11:03', '2023-02-08 08:11:03'),
('0933d41b1755baaa91f3427570bd8f58cb268ee339fe9818c62006ed09fb8109d3c7e3a8297cae75', 5, 1, 'Personal Access Token', '[]', 0, '2022-10-03 03:58:22', '2022-10-03 03:58:22', '2022-10-10 03:58:22'),
('09d9933731f1b3ea43805739f6574c78e1dc01ae5893271788dcec23a1df0e7375d8e2dccf33c1d5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:04:22', '2022-01-21 10:04:22', '2022-01-28 10:04:22'),
('0aaa5511f02066aaefa2dc7c667ff8a7786329367f22fbc080be9e26d949600b10b907591d87b763', 14, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:22:26', '2022-08-03 08:22:26', '2022-08-10 08:22:26'),
('0ae6bedd17b92673c2bcae2cafae8cb51daa78f29bc370758b3a07cc01481d511bc72e2c144a86bc', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:45:56', '2022-10-07 06:45:56', '2023-10-07 06:45:56'),
('0b1b54f948fd1861f9ae2e4a5e4a7068211fdff22c4b3129f58ee5edab7ff4d0a1eb07c768937e8d', 16, 1, 'Personal Access Token', '[]', 0, '2023-03-03 08:30:15', '2023-03-03 08:30:15', '2024-03-03 08:30:15'),
('0b2827b76be6201554ac6be183aed2b4d8dae08c519935173131ab5cb2b39170ca453471c004ce30', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-20 01:40:17', '2022-10-20 01:40:17', '2023-10-20 01:40:17'),
('0b33a088958fbae4c68d79bd2a38a598a40369610d5d938c0fa267830705d2927cb32b87a843200a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:52:04', '2022-01-15 16:52:04', '2023-01-15 16:52:04'),
('0b43893b7160c205dd12a917262a6c544d0b91e1f62a0f9ea00450c77005812e6a6227f0f09f4841', 12, 1, 'Personal Access Token', '[]', 0, '2022-02-03 08:15:27', '2022-02-03 08:15:27', '2022-02-10 08:15:27'),
('0c1971436575990e97c18ea10643c426314e60ab59db6b7fb3f067f238bab8a841b3025e0fefcd40', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 09:29:00', '2022-07-26 09:29:00', '2022-08-02 09:29:00'),
('0cc17f3d8e40dbdbb913925fc78aadafb8e2be0103f8c0622f331676e04b2e162d075984664e9e89', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:17:43', '2022-10-04 03:17:43', '2022-10-11 03:17:43'),
('0cd18747737d3a5435a216876e7da6c676ebf2703148a62be77b9527afd6b918b7f3149d53f37a86', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 16:26:16', '2022-02-01 16:26:16', '2022-02-08 16:26:16'),
('0d0b699c07ca4810de35d91241897271b101a4f9401f1371178701ae96f26502a581e45e18304a4c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 03:20:46', '2022-01-24 03:20:46', '2022-01-31 03:20:46'),
('0d70835f3bc2b96554cb9471f857bb73ea4e4f9d9234ba4ff21d43ba04921e2e34da8c2412f07929', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:03:14', '2022-01-20 05:03:14', '2022-01-27 05:03:14'),
('0da364728a9d24f6596597b6d7f4fd24e35f1b6a78d6ea7c24fe6caf3b0fd95db335d96ff65fa9a2', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 03:29:37', '2022-01-16 03:29:37', '2023-01-16 03:29:37'),
('0e36884e0c5396162a141861b9b3f4fd713f3514ec3bc9bcc6dd14649dd569e80dbe6624ca056847', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:51:51', '2022-06-07 10:51:51', '2022-06-14 10:51:51'),
('0efcdcb02f617e8e83f06f95e150f00a17cd36ae2aec5e0d712180a10d9e5de419bd8fd89c474ece', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-11 01:58:14', '2022-10-11 01:58:14', '2022-10-18 01:58:14'),
('0f249a6fab6693b0d2c1b09e6c4ac554796ec3706fd4c2fb7143bfd518d4796d630e7051e0f9ff85', 132, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:30:57', '2022-01-21 06:30:57', '2023-01-21 06:30:57'),
('0f89c396742e4e034ca69912598199169123b78697c7f4f3292f340f46d2f19487d97eb47598621f', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:13:34', '2022-01-16 04:13:34', '2022-01-23 04:13:34'),
('0fa0fe40f601f81675e86da8f881b4d9adc9688d7b019240bee799f59b02d16e63ec3723eb2f65f7', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:05:28', '2022-01-21 10:05:28', '2022-01-28 10:05:28'),
('10e1153ce42123c7544737f8bcf9ed31cbc7a198d2cc3ca2956fbc268594b9b38cd54180230e4682', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 07:44:28', '2022-06-07 07:44:28', '2022-06-14 07:44:28'),
('10ee55df18fa5623e55c65503513bdf82e2a0b168caf6676e05aa3adbed3f07c1893a21a820e9731', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:28:33', '2022-01-16 04:28:33', '2022-01-23 04:28:33'),
('1171b0a7f070ebbc7122392493af84a98e5ef2859f05aec2e1bbf33e0451d9e935657d6df1763aec', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-18 07:57:50', '2022-08-18 07:57:50', '2022-08-25 07:57:50'),
('117c75e38212b3f1357a446de49840e9cf195e3ee8108d0b2e6db4f1fdd90d74f1be05cec051ab7c', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:08:38', '2022-06-07 10:08:38', '2022-06-14 10:08:38'),
('118a428e56792f8f5db341fd40e74853a130dc03efc074821a7aed16f41df809ef2a56d7ee7286ba', 11, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:31:28', '2022-07-26 04:31:28', '2022-08-02 04:31:28'),
('11abb607cdad977821046eb2278da9d53f67cfdbaec5ea54a92faff2109556e28b97b050db8e9a43', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-31 08:21:33', '2022-10-31 08:21:33', '2023-10-31 08:21:33'),
('12578e915820624058969cdfeb7e700a1a9c4965b5fd8f6cf5391dc0a07403e4719b58a85da73878', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:32', '2022-01-27 03:57:32', '2022-02-03 03:57:32'),
('12752ef177b35d66d00ee0132e1c4cf3a299ff38f6582bb269968b54da54bd38e0bab389955b370c', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:57:10', '2022-01-21 07:57:10', '2022-01-28 07:57:10'),
('12e9ca0d95f1995a9383bc207c3ac5808717780a51062da1ead90b21e0273c7455488ebb6d72627b', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 07:03:25', '2022-01-18 07:03:25', '2023-01-18 07:03:25'),
('13191ef5c0cc90e7448e306bbfd1dcf0fe433d827d612aa4b5dc3cd5c1f1debefb2478ae02802271', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 04:32:55', '2022-01-25 04:32:55', '2022-02-01 04:32:55'),
('1368e45814c661a3749e12d51da2ea2bbcb711ac959db81ff3bfda1a94e6efa24ba8897d9632e707', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:14:24', '2022-01-19 03:14:24', '2023-01-19 03:14:24'),
('14149975622c5599c310f83b8dbd68c4418884c31b52fc1f579796ad636b7ba13a7f7670fbffb5f2', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 06:36:07', '2022-01-28 06:36:07', '2022-02-04 06:36:07'),
('149bd3ab5f0de2f039047c8dc830b057bcd0e21937f0b4e2543fbbf46f88c914eea609a71b42935e', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:41:08', '2022-01-21 06:41:08', '2023-01-21 06:41:08'),
('14e38ec15746ed6173ab138d561bb487db0995d5cf72db3bf9aaca1ad351e542db1f9f5985e1e5c3', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 06:35:27', '2022-01-28 06:35:27', '2022-02-04 06:35:27'),
('156c9fae2678a58c8e8316e463c864bdbc05e32f5e26a856218aead9d826245d367f5b6bb8c90d1f', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:19:28', '2022-02-08 08:19:28', '2022-02-15 08:19:28'),
('15c3047432fce49f3201e2e2500322c390db2b0370ef7a3c2ee290eb139f88d35cf5b09e5df1e0fa', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:46:07', '2022-01-17 07:46:07', '2023-01-17 07:46:07'),
('15e8d6311b7910235df958315abbf39258e1b53bfb6c270f7809a939ded566f0279ede84be4c97f0', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:16:01', '2022-10-04 01:16:01', '2022-10-11 01:16:01'),
('16cacb548923070b28c47377f8f0fb705c0ea6af223815dc6c3b8ccbed2e6f5f7131a7208133a2f6', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:32:07', '2022-10-04 03:32:07', '2023-10-04 03:32:07'),
('1720c3b8ed57bc32d286668e38ff2c8f93325577ef3b0f094776ff847239cba345ba8951a08f95bf', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:26:30', '2022-10-04 03:26:30', '2023-10-04 03:26:30'),
('17462e3f809b8d9f94447b047773d0f22e102624941be8fc369b9d8420f85cdaae2742679f895e4e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:06:33', '2022-01-21 10:06:33', '2023-01-21 10:06:33'),
('179f3f617e8c4470ea388fedae6f76bb7793c3b8e09aae204b5006417bcf646040d88a8733188323', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:44:06', '2022-01-20 10:44:06', '2022-01-27 10:44:06'),
('17da7fe9a4323a2d158a9379fe5080ed5f521fcd6564149f337a90d0028e38beba44a411bb2f2450', 1, 1, 'Personal Access Token', '[]', 0, '2022-03-24 09:13:39', '2022-03-24 09:13:39', '2022-03-31 09:13:39'),
('17dbba06de4c7566511c6fae4a5ed61be7a10588ce5cb59467c4ec0a1cd74bc53faee981d8b4182c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:46:06', '2022-01-21 10:46:06', '2022-01-28 10:46:06'),
('1818f133679be1205b4db57107d7d589704f9b5dd784c5f3faac15f4ac095d757f12c8c75e04c866', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 06:30:20', '2022-01-16 06:30:20', '2022-01-23 06:30:20'),
('18382d3a6e16c449426f7b22c999ec776166ddd72cb426c95c006beeeee1daa2329922e23178f1d8', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 13:25:27', '2023-02-08 13:25:27', '2023-02-15 13:25:27'),
('18581f3972f09dd3f147e6ed32bdfdee6465abb0b9802e4ff6a8be4cb5e1e95047930ffbffed58fa', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:07:09', '2022-10-04 04:07:09', '2022-10-11 04:07:09'),
('18c659ed08d3c7f34a24bddcb4844201a419ea68f493ac80598e0e5b73ffef974014d3246fccfb0e', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:16:15', '2022-10-04 03:16:15', '2022-10-11 03:16:15'),
('19b0494ed0e06e82d87c9dc5bd32fa559133ec2146441d74a8c9885b6fb75e86dff1879e80402435', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:29:27', '2022-01-21 06:29:27', '2022-01-28 06:29:27'),
('19badbf23e7bfbad5f91139d1154aac5d5a7a5a1168d5c92763bae7cd405c13d6208e45c94f0063a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:08:27', '2022-01-27 03:08:27', '2023-01-27 03:08:27'),
('19c0665a08e0b366b46d83acf8657a186b46980e230d91d5cb1e466f42416aa13a23f90c3edb6a1b', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 17:53:22', '2022-02-01 17:53:22', '2022-02-08 17:53:22'),
('19d10e0e1a40261b811e6f13bd50215f4f8728b6253333c34231a978f0cf60b78bc0c8cacafe14c8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:13:11', '2022-01-24 16:13:11', '2022-01-31 16:13:11'),
('1a35f9ce219238f50190aa681da80f6271e906d5cf8106c036c499ecf7328edfd1b97231338fc53c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:58:47', '2022-01-24 04:58:47', '2022-01-31 04:58:47'),
('1ab252ddc10d7e3ddc189d58bf6bbd966c78b80817ffe91eeb2db5b33ca19c208bb06c52f63cf709', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:36:15', '2022-01-21 06:36:15', '2023-01-21 06:36:15'),
('1ac6b4005d008238d294703fdba25d6f1606038d7e4680ea048e9f521ca5b675e82de0204cb5a4a3', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-21 04:09:23', '2022-10-21 04:09:23', '2022-10-28 04:09:23'),
('1af070ea06274f868a0615fa521e8e614d3641591c23216f977afa906834e25c93eaca16403bae2a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:44:36', '2022-01-21 10:44:36', '2022-01-28 10:44:36'),
('1b540971c87aae6c7f551930e6edd7f1c5a2f8aba873d12788b50b0b0e666bae160aec3e3d198535', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:32:21', '2022-01-26 08:32:21', '2022-02-02 08:32:21'),
('1bfa018300e7c9005dbae9b78f6df2eace6288183f1e7138779723a3e8a59a42927c5ac8062696b0', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 08:40:07', '2022-01-24 08:40:07', '2022-01-31 08:40:07'),
('1cc102a9a03a6f4e7b5191c2fb2e414bf4400c493153d494d74e071dbde9bc0efa6e6bf96d543748', 134, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:03:52', '2022-01-25 09:03:52', '2022-02-01 09:03:52'),
('1cccd6d33e77b6161ad6c1450b2db4b9809b6d61abcea105e5c08ce9558017a5947fed0b03535cb3', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:43:17', '2022-01-20 09:43:17', '2023-01-20 09:43:17'),
('1cf79009ffb51466b29d618428a01d68dd2984bf7e442148d1fb16f4198193fcb40a7498e1c68bdc', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 04:27:47', '2022-02-01 04:27:47', '2023-02-01 04:27:47'),
('1da0738db590124d19fd4eab51cda2c766d6fa06c4b6ea14c42564ba0dfed0ad84c83375e4353ef4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:23:37', '2022-01-21 07:23:37', '2022-01-28 07:23:37'),
('1dbdacf297deccd91fb47e107c2838d946932d157c1d87be80432c26a83d6f447e1bdf2b0fc401cc', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:42:00', '2023-03-04 07:42:00', '2024-03-04 07:42:00'),
('1df7859d88fddc0ebb1a9be3aeda5f39658ba38845b0736885025c975f367b423be68522fbdbdc3b', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:01:16', '2022-01-21 07:01:16', '2022-01-28 07:01:16'),
('1e128446d798784b3b19bce951196b0e0936cd5a15d5b76af24f07f5e7d2264edde4bd2654b2f0a9', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-28 07:50:16', '2023-02-28 07:50:16', '2024-02-28 07:50:16'),
('1e85f209a0687645385183d6ce8698aaa1fc255f884d45a5f9eb0e3c5a26ba15356230d5e897221a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:06:39', '2022-01-25 09:06:39', '2023-01-25 09:06:39'),
('1ed72849b3d5d8c5dadfce9368eb4684b6c1a6ca428a9349a2b55de4ab3904a98f178ed4b4982a63', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:51:41', '2022-01-27 03:51:41', '2022-02-03 03:51:41'),
('1f48bf60972965981d7977bac3a30cd2fe20fcd8c336d9b37bcfa159e95cfcaab25603a065d79dda', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:49:40', '2022-01-21 10:49:40', '2022-01-28 10:49:40'),
('1f78bccb8b15e0f154fa85d7ae8f7f711af3c6f2787f67c2936e8d2ea4bf867c0902d0de60bdfa15', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:05:28', '2022-01-21 10:05:28', '2023-01-21 10:05:28'),
('1fc1dad336c7cd9a9b876c16b8b3dccd584fa2fa3c7d49de8394fef5d2a16620d53c2b44c63cfbaa', 1, 1, 'Personal Access Token', '[]', 0, '2022-03-24 08:29:11', '2022-03-24 08:29:11', '2023-03-24 08:29:11'),
('2014e6dd0e4086a994a0568e96a7856f22084a9925f0bfb3d12dc10647887099f948662174239998', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:16:58', '2022-06-07 10:16:58', '2022-06-14 10:16:58'),
('202c8d16fb08933e687964828a6456a8526863db557bb54eaf983a47436d7e08f55c139321b9e235', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:23:24', '2022-01-24 05:23:24', '2022-01-31 05:23:24'),
('207bf1c01c880404ac0ed2763623ca55df095a29bfb1943e78346661118cd3f35dd9d684ffd302a7', 12, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:19:43', '2022-07-26 04:19:43', '2023-07-26 04:19:43'),
('20ed942f7dc35d4a42cf6e845c0323f43f5d3a4c99a00541374cac356f4801d694643607696f95fc', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-17 04:32:00', '2022-01-17 04:32:00', '2022-01-24 04:32:00'),
('20f127c152c8195dde513ce4963a9bfafa28ee80b90c7a578dd76006e7c04ce5c03172d3795f5c08', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:20:38', '2022-10-04 03:20:38', '2023-10-04 03:20:38'),
('2175772e462a71f2e8bd488abdbaeab4d71bbd77da6ea47eaa9562bee3870a3071b476697bdd38c9', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 04:27:47', '2022-02-01 04:27:47', '2022-02-08 04:27:47'),
('2184cec1c139e573ed19804f44d789a644d59b26c0305b9438f8fe740219771ea6860958d1b1d150', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:34:34', '2022-01-21 10:34:34', '2022-01-28 10:34:34'),
('21cae68d96aea5674e2e1199e062032179f350e7962f9290e8b4ecbdda80b8d06644cfca957b9d6d', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:44:43', '2022-10-07 06:44:43', '2023-10-07 06:44:43'),
('21d4098c9b375d23f42adc1b5960f6eb08964ec14cd62d2ed2374c5bcd7ddf9e16f06b4142737575', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-18 03:00:50', '2022-10-18 03:00:50', '2023-10-18 03:00:50'),
('21f20b0a92ae832569eee4585b6489ce3837c3feb0cb1115edea470fa96420b4e5bdb1ce27c6587d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:45:18', '2022-01-20 10:45:18', '2022-01-27 10:45:18'),
('221f73a699cb80efb1397aef57dbb7b72a3e9f83b4dd73f4940f116df35efcb3395c0a30b66c1f41', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:12:44', '2022-01-18 09:12:44', '2022-01-25 09:12:44'),
('222035a963586151184dab199a69acc5ef40094aafd94be2966db6a5ec46e352d37c926a3fce49e1', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:40:50', '2022-01-20 05:40:50', '2022-01-27 05:40:51'),
('2259076877e095d569d194b81face9ece011ef823417e62a75627a6b519bda6e939f59d9dc53a152', 2, 1, 'Personal Access Token', '[]', 0, '2022-01-16 03:28:53', '2022-01-16 03:28:53', '2023-01-16 03:28:53'),
('2277aeed2bdc787f321dc98abf3a0474139c57b83864adb32c695988db86135a145123a1dc59eadd', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:23:41', '2022-01-25 09:23:41', '2022-02-01 09:23:41'),
('23563079a73801d1bf2041ff4281dcbc7d67769a61bec254d8e6fc8b0ecd9044d0ea8d3f530bcc3e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:58:19', '2022-01-17 07:58:19', '2022-01-24 07:58:19'),
('239784cd9dde874b6fbc26c4bbada4db4b8c0c8ffb885b9d157d4392dedaf41f287baefa0a63d7d0', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-28 06:21:39', '2023-02-28 06:21:39', '2024-02-28 06:21:39'),
('24a4f4767b9be9ec247858731490c411af933d8629fcbfc5c8545f24025abdb03abaf4d6dfcdba08', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:15:36', '2022-01-24 16:15:36', '2022-01-31 16:15:36'),
('250f8914d88827fafa1907d2612ada39d1824073d5153bf3dc71cd59536d34b5c73e6614c6c2ddd4', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:43:21', '2022-01-20 09:43:21', '2022-01-27 09:43:21'),
('251f84b58d76398f0c6cff8fcab736f026a710a0dc9aeb8e16e5f0b3b77812bc0ae5153e5e61c3cc', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-19 02:27:04', '2022-10-19 02:27:04', '2022-10-26 02:27:04'),
('2585e2e9cf95300eef18d3bf1324da6c78e436f1eefa2482a17ad94c30f7ce380a184b00ed32fbbf', 8, 1, 'Personal Access Token', '[]', 0, '2022-10-03 04:03:12', '2022-10-03 04:03:12', '2022-10-10 04:03:12'),
('25bd24626e6ac1462a01c165e9bab9290d47d7afbd4053240e656ec8c776ad0276d2cb24f5392cf3', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 00:56:05', '2022-10-04 00:56:05', '2022-10-11 00:56:05'),
('25ee5c86c9c85bbfbd5e8ccff2e6e9c8493a3f3326f43794db131c9298510c724c677d17d282e909', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:33:06', '2022-01-21 10:33:06', '2022-01-28 10:33:06'),
('25fee7df138569ed82643e349fc666c01742d337a9c9bc9efb69ac42c7d0e7aa2ccba3f26360e716', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:08:55', '2022-06-07 10:08:55', '2022-06-14 10:08:56'),
('2631e377b4cc059c1cbb7aa4eaa920086fa991e7fa575a4babe54ba2c16524768c2aed762bb5f2dd', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:59:40', '2022-01-20 09:59:40', '2023-01-20 09:59:40'),
('2697ca345848c1d02df1d5392559bb35a907c8361d92b98ddc2db5d4763e4e4eda3a3268b55b2a20', 5, 1, 'Personal Access Token', '[]', 0, '2022-09-29 03:13:39', '2022-09-29 03:13:39', '2022-10-06 03:13:39'),
('26ff2ec2aed864ce7be0fb507f69ae1c4ff9f0f459d0361ef6cd4c6680ca2d4a0ff0147661eec0ed', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:29:33', '2022-06-07 08:29:33', '2022-06-14 08:29:33'),
('2798be1fb21a5b89c72008b893ee08977d0cc5ac41aec4aafa1c02a3be3eff531bf869f9aa2dcbfa', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:36:24', '2022-01-21 10:36:24', '2022-01-28 10:36:24'),
('2869df4000f235328ef25a04ba673afab12e650eb1e440129b3491123d769d3d5beba54ca9e697fc', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-30 02:30:51', '2022-11-30 02:30:51', '2023-11-30 02:30:51'),
('29a65fe229857ddf503628dff705afe678cced4a69c0780119c58aa6001b63896883d379a06640f7', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:14:25', '2022-01-19 03:14:25', '2022-01-26 03:14:25'),
('29b5a08c97cfbb0be1a80518b2aeb3f7d14cc95fa9ac8d61b7bf0bd923b4213b49e40c0648672133', 134, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:04:19', '2022-01-25 09:04:19', '2022-02-01 09:04:19'),
('29caef59d0d8c504d40a0db6070188436820940a84a232c97a45591d8d4a23cdd70304c1074a4ff8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:02:24', '2022-01-26 08:02:24', '2022-02-02 08:02:24'),
('29e59371deedee129c0be329d0e36867be76aaf45f1652fbbe2694290c296f4fe0292ab14cb19d16', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:22:18', '2022-01-12 09:22:18', '2023-01-12 09:22:18'),
('29fd01916db92784f57c47a15c32dbe9f75c36f35e440f9ed1db5f345bb0b102e791d8c78a226770', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:57:52', '2022-10-04 03:57:52', '2022-10-11 03:57:52'),
('2a19d2e6058755c0f711df5fccfe7ba9a0abe718589ceede2d6111548c68b0f9ba96772631624d62', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 03:52:27', '2022-10-07 03:52:27', '2022-10-14 03:52:27'),
('2a52983288c2f75d10b57bb8b42b6eac4a4addf1a50d00fbb975dc09c57a25a11a0862735d6c8bb8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:33:39', '2022-01-17 07:33:39', '2022-01-24 07:33:39'),
('2a6c72386ca26c495195950b2c3e19dbd979ba4b44c63ce3d35a613e031cff07901e515bcb8d45ce', 131, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:29:40', '2022-01-21 06:29:40', '2022-01-28 06:29:40'),
('2ae3e769a8e1b66e95620f80a1abd026d83a9b2c3f050b7117e92a5ba45fa131f2793996b09fb2ef', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:23:20', '2022-01-24 05:23:20', '2022-01-31 05:23:20'),
('2b93fee40ccb4f346666672f8305d91f1a40cb8d63d1eba976d90e6397e26b720545925ee6dfa354', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:15:19', '2022-06-07 10:15:19', '2023-06-07 10:15:19'),
('2b974e4ba8cb498f788f75a334601f2357aeb5d726aa4d262ddc15eca943c7afcd0d122a33f6c8bd', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:17:10', '2023-02-08 14:17:10', '2024-02-08 14:17:10'),
('2bdb42e4f43be26ba24537295148636259fdde96e323af46ac4b2ad9608e579714dc125f11c09d15', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-09 14:44:15', '2022-08-09 14:44:15', '2022-08-16 14:44:15'),
('2c2f912b6e93f64d282ef47cc418cbcf89eaf188a5bef860869bc4588fc5c63ffa8e10c9f8d2e548', 15, 1, 'Personal Access Token', '[]', 0, '2022-10-03 07:06:36', '2022-10-03 07:06:36', '2023-10-03 07:06:36'),
('2c577abc72bca894d826b8c821d55150d120a24600fcd4038b0ef3dd8a07dfa0a4399658c063ad7c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 08:02:45', '2022-01-25 08:02:45', '2022-02-01 08:02:45'),
('2c674e0c40497fc71b77197e7e0c3f7f9a00b70201545c1ec2f6cc8404483cd592a8672a2a70c6d9', 5, 1, 'Personal Access Token', '[]', 0, '2022-09-09 02:50:58', '2022-09-09 02:50:58', '2022-09-16 02:50:58'),
('2c808e1aed4520524f7063d251a1132e08153d1db78f9a6268b5a48c507435efdb1d9e9fd1babe68', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:13:35', '2022-01-24 16:13:35', '2022-01-31 16:13:35'),
('2d4c403dd1ebc6d5580ea55719092453ba4f9fa519a3273d9382f065d369550d45f206877abaf204', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:15:55', '2022-01-26 08:15:55', '2022-02-02 08:15:55'),
('2d709b012fe3e62fe33168c2444720e424eb245f5e074b686eb1ee26f85ebaad3b5facef061b8d0c', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:18:46', '2022-01-16 04:18:46', '2022-01-23 04:18:46'),
('2d76fe7b0c3346f9b3e234238d1168176ed35a4b232b551d728b7a29ef7ede22cc4dfef55abbd614', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:17:56', '2022-06-07 10:17:56', '2023-06-07 10:17:56'),
('2d837260e307051269c15d35752f77efb1c248992a00558902608ae204a6a6af4158df25d253e642', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 14:23:17', '2022-01-24 14:23:17', '2022-01-31 14:23:17'),
('2d9158f1a7c8fc0420531d4df0b58fd3e21276decc265fc7e6a8bcfe98c9c0438f5af1c9f763619e', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-02 01:51:42', '2022-11-02 01:51:42', '2022-11-09 01:51:42'),
('2df01cdeee6c0699cd512ef1a6a60e4a54c4be562264be7a032c27d1740b1176ca9b7addcf177c7d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:26:32', '2022-01-26 08:26:32', '2022-02-02 08:26:33'),
('2e061eb7814dac67c3af55db0e6c8aa7f6314536698b42ec05c6b34279eee8681d7219b158d81bce', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-28 06:21:45', '2023-02-28 06:21:45', '2024-02-28 06:21:45'),
('2ec86818706a53b25765a16f94c437f392b1ec5656a6a2a0222ef6165d4561902626c800b3dc24a0', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:12:58', '2022-06-07 10:12:58', '2022-06-14 10:12:58'),
('2ed5159fbb4fae2dc33ed27261235d00ca23e476d5ff5deaafca0a84073fd5f288553c32647ff850', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:42:08', '2022-01-24 15:42:08', '2022-01-31 15:42:08'),
('2f0ad82a60e08e1a48c902b3669a1cd34552435b984bc7503751fde1f36335d79001cfe459778b83', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:42:11', '2022-01-24 15:42:11', '2022-01-31 15:42:11'),
('2f7232e38c9b49cfa4c708cbc7583ec54538e08a3603ea30155ef093239e6c18c4255258e3f5bb7a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:32', '2022-01-27 03:57:32', '2023-01-27 03:57:32'),
('2f82e5a0b6f6c2caedbd00eed3c224353479403c073ae2142f1243245ec7c51512a02522d04feac8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:58:44', '2022-01-24 04:58:44', '2022-01-31 04:58:44'),
('3008561f67e57952273e709bc6fffdbace3df8984a58ed40c7be8a343e2e2537148beeaad291aafe', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:57:46', '2022-01-21 06:57:46', '2023-01-21 06:57:46'),
('30097f9b9e12a00d7142c5deed013f02ce07a352b154d6e75abc3a96f43b77c679375f49d2dcdfce', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:26:08', '2022-01-24 02:26:08', '2022-01-31 02:26:08'),
('30d5ea0d9c2369ab4fde53e58cd4a8858e2217af636ab55703250132cad127b17f21750ab6793acd', 12, 1, 'Personal Access Token', '[]', 0, '2022-10-03 06:09:14', '2022-10-03 06:09:14', '2022-10-10 06:09:14'),
('3119f0f9cf819b0a241c774164bcf7619e8a7231f37ee11056e010accafc95733119beca272e10de', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:15:53', '2022-10-04 01:15:53', '2022-10-11 01:15:53'),
('3160e6d62039e9f8d8e72e2be9d74d1f24c04227241e280548d52ad29a59fb14ee703a9018c13d42', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-18 07:03:09', '2022-01-18 07:03:09', '2022-01-25 07:03:09'),
('31b3c1a2b5a35fed9c9c2722e44ee62113999592d199d2eb9c3273843d00254407456cbe5704a0c2', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-31 08:21:33', '2022-10-31 08:21:33', '2022-11-07 08:21:33'),
('326935f702f86616be4db1479e852461f4bd98f52f38d08217b6d74ead38dab47d87f5c9600da2e0', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:51:59', '2022-01-27 03:51:59', '2022-02-03 03:51:59'),
('3273c2d6a707075ed95fcfca282e1bfb437d5afa55c3f5fa283c84d080e4a377035e217ae38b126a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 03:28:29', '2022-01-16 03:28:29', '2023-01-16 03:28:29'),
('32e549b0c10d2c9dd97981e4de541cab148c3a04f35cc6d4b9db6a9badbe84d6d303ecc669bd7f2d', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:53:19', '2022-01-21 06:53:19', '2023-01-21 06:53:19'),
('33853fbccabc50052df23cea16450bb01bfd7547ec6ccaabb57a390a95ae05e492b3271b98c761eb', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 08:52:28', '2022-10-05 08:52:28', '2022-10-12 08:52:28'),
('33c057d73d30181eba46dc9e0a1de14f99072f0ce082c5294c7abd7d818188c7435586ed58823761', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 13:33:27', '2022-01-12 13:33:27', '2023-01-12 13:33:27'),
('34263a308d0703ea26f3d039c7d63ba97335274e6e23656bad9b262a1bf8125533d799069a8e244c', 6, 1, 'Personal Access Token', '[]', 0, '2022-10-03 08:17:51', '2022-10-03 08:17:51', '2022-10-10 08:17:51'),
('343dd5c50b3b05d5ebe1d95127d767d2f640e9ed7d440d51d2420cdf2c277314de28d4338059bc45', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:44:02', '2022-01-21 06:44:02', '2022-01-28 06:44:02'),
('3471a9402e09969fad17ea8bbb33330d2c6d6d20cc07bc214b1e7f5dc88afaaa25ee33d32cca4cd1', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:57:47', '2022-01-21 07:57:47', '2022-01-28 07:57:47'),
('34e9efeff1bacea3d8bd3bc0eeff4b33c7a00c424799fe44f29e0f27ff16aab3227ecf1e11a0590a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:25:35', '2022-01-24 02:25:35', '2022-01-31 02:25:35'),
('361ebd5b47dde5f4fb13e728a5ff702ef21df8e1963854c76d355faba9e4738db3f3b0aae7dcf4ec', 146, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:42:05', '2023-03-04 07:42:05', '2024-03-04 07:42:05'),
('36567620b606204d6d657c08bf9e69340cc4bef02c2767350525431ada365b8a10744c8296294024', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:24:43', '2022-01-24 02:24:43', '2022-01-31 02:24:43'),
('366406b2413d5e54ae9b9001d7ad9a9ef0f4f973d1fadca796ff825f0631bd14c5f25ef63955fcef', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 13:14:39', '2022-01-12 13:14:39', '2023-01-12 13:14:39'),
('36b1f10fe4d1d740753960090963fc38fc1ad91d4af50eb84d36f00dbe3ef870c969158b00ecae8b', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:18:51', '2022-02-08 08:18:51', '2022-02-15 08:18:51'),
('36c533c67431c333b9a114bd0a653fc438b5fac0680370ec5287b66630a55354041e6626161dbec9', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:54:22', '2022-10-07 06:54:22', '2023-10-07 06:54:22'),
('36fd591a9487e3e6f68317cf266d9e043c86c4363dbda42327fbe5b6b46e9531c4759e6ab78e6253', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 00:56:13', '2022-10-04 00:56:13', '2022-10-11 00:56:13'),
('37f648b1c8dd1fb3cfab88e60d0afa16a4347abaa892c7e5e3b7d07f20849a83f437bc95e0abd580', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 05:50:08', '2022-01-16 05:50:08', '2022-01-23 05:50:08'),
('383b90903d09f1013bdb10378969779c3015f7db54a2d6f20f3fad8cd1a9a3b87b14587e5ae12ada', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:13:57', '2022-01-27 03:13:57', '2022-02-03 03:13:57'),
('3879734e28b64e0b1b502d7b5f333f00fdbb500af64521230d18489adeeb871fc5933c99f73bef13', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 07:22:06', '2022-10-05 07:22:06', '2022-10-12 07:22:06'),
('387efd195070a35bb880026294f03f3ac429e97670a6013e1029cf7d29b88116859c116809ffc131', 134, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:08:05', '2022-01-25 09:08:05', '2022-02-01 09:08:05'),
('38d5fb37f2eb41494a6b1d53658b0326421b5a8eb92773c8792318796b13906c13f51ef35a1ac24a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:30:59', '2022-01-17 07:30:59', '2023-01-17 07:30:59'),
('391085be9685c08d49f49af8fcfd171f981df621c3ce7d42c04bcab2e9b91699e686b9b88e65b314', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 16:26:23', '2022-02-01 16:26:23', '2022-02-08 16:26:23'),
('39222e2e4831f13963eb2be2b97a615bbf4616e9529edf942bb35c5b2ee7a81705068c45191db1cf', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:07:08', '2022-10-04 04:07:08', '2023-10-04 04:07:08'),
('392731898e29267ef937df298490a039ed1d7d8f1b7fc895621035ce7ac966fc824273709434cb33', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:02:01', '2022-01-25 09:02:01', '2022-02-01 09:02:01'),
('3a27063d2f20395fa45b04f185c3e219695a5dc7b09fa064c23205fccb854ed8d9744fe1cda3ba7b', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 04:43:56', '2022-10-05 04:43:56', '2022-10-12 04:43:56'),
('3a6e0b4d635061051f9847b189521072544d6f0e6404ea0b48bca33d7fb5352809d3e2d61fd0c47b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:44:50', '2022-01-12 09:44:50', '2023-01-12 09:44:50'),
('3a8c89ee03b3ebad94c073e982b5e904fa1f72c9f28ca6a0e6605718137685893863d4c1d8daa359', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:04:09', '2022-01-17 07:04:09', '2023-01-17 07:04:09'),
('3b1c3e132478ac0ea752891d7801729c677aaa1545ed300d9e7870ce12745c0e7877944bc0c499b2', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:43:18', '2022-01-20 09:43:18', '2022-01-27 09:43:18'),
('3b20a1bb72703ac70bf90bdd97fcc057b9b6f90e2a9f272710bc2fef6c229655d8e5ced36db37a81', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:38:55', '2022-07-26 04:38:55', '2023-07-26 04:38:55'),
('3b74e6de22c8fa5153030440e58b5550796227aba2c857d46517a573edd0aca84f355c680dae8829', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:52:21', '2022-01-20 09:52:21', '2022-01-27 09:52:21'),
('3bfe15195ad2064ab1abea4f299dc4a9884cc931de53339c0c8e06993f5f6df1d6810f53955d8fdc', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 09:20:43', '2022-01-24 09:20:43', '2022-01-31 09:20:43'),
('3c1fa14a676ca45878de4f934bb6b7eec63531c87e6e5210c77e2bc1f65544c579c3651620341cf0', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:17:48', '2022-07-26 04:17:48', '2022-08-02 04:17:48'),
('3c7eddfe153d5bda45f8e6654fdd44f43ac6d3c360523682eadcd946426d9df5814ddf9975847ebc', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 16:26:26', '2022-02-01 16:26:26', '2022-02-08 16:26:26'),
('3dc89b9967c223998d7f1abb863798ed6fefc1b05655fcaa3529e81a6d9dab3dd6d416761f53b0c7', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-27 15:11:38', '2023-02-27 15:11:38', '2024-02-27 15:11:38'),
('3e120263ba8cb690fc0ad04a5d2923d54001ce77af86ec78270afc6e3dae2abc54a1a3a3ec026a9c', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:31:15', '2022-10-04 03:31:15', '2022-10-11 03:31:15'),
('3e519ec52ade5b2d51a7c81f507019ca85ad5353b39466f262bf78e664ea3cc4aef92fbd46180f68', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 07:36:49', '2022-01-25 07:36:49', '2022-02-01 07:36:49'),
('3e6c0b59501aa7d48a5e4a917234300e7954d3d2e28898fd7dde5a9e0aa3c8333a57ef13f83f5af1', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:59:05', '2022-10-04 01:59:05', '2022-10-11 01:59:05'),
('3e770055f84fb71216785c921c4011b758fadde7cde2c3fdfe55f370d27d0a36a66886e4c8b7d10b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:22:59', '2022-01-25 09:22:59', '2022-02-01 09:22:59'),
('3f12a8628b2c8a9d5cfa494db4d1cfe935daf63e13c3217bcaf2a73ce5fc2b1ce22aa595fd0c0a5f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 10:56:28', '2022-01-16 10:56:28', '2022-01-23 10:56:28'),
('3f28b33286cd95ba03f4b5605369430456aba9be5bbbaae16b07ea0811a802640d2af8b47e0697ec', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:13:58', '2022-01-24 02:13:58', '2022-01-31 02:13:58'),
('3f6ccf9a705e2a6f32aa746788da322793278144ff4fa643c9f5930f84ddef92838163f65a41a75d', 1, 1, 'Personal Access Token', '[]', 0, '2023-03-07 16:02:40', '2023-03-07 16:02:40', '2024-03-07 16:02:40'),
('3f9c5ab4d0f593fbb43a74e14e9859d58b007998e8fb40afff7a487354745876d433530551b1079e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 05:05:46', '2022-01-27 05:05:46', '2022-02-03 05:05:46'),
('3fcc58d90f527d6d68f34e107cfbff50a798ba06e8a1546f34b2e4df46b9358c451da39495aa20a3', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:40:49', '2022-01-21 10:40:49', '2022-01-28 10:40:49'),
('3feb229077ab164511dbb3a093ea005c22fa3d5f58b1a521f0492ed67ee3c998b918f8f29cd675c6', 151, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:09:49', '2023-03-04 07:09:49', '2024-03-04 07:09:49'),
('4000fb6671f9b646dc01b8ddd8c930c3079dd0e0c8226dbbf0db47b3ec27e5b4195b7b989a1803ed', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-17 04:32:19', '2022-01-17 04:32:19', '2022-01-24 04:32:19'),
('4020be3723f6619db71e04eb97925ad952a65ae220fd3e7fe81c06716d29d730dd3738f93209abe8', 1, 1, 'Personal Access Token', '[]', 0, '2022-03-25 03:09:27', '2022-03-25 03:09:27', '2022-04-01 03:09:27'),
('4047f0ebcca721eb3295b72653d30848dede31495fa183734cba0f9f8d776bb3effbc78f664c3ce9', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:16:56', '2022-01-21 06:16:56', '2023-01-21 06:16:56'),
('40f18f22e06db31c50e98f94663b6744ac15358d3f2e1adfbb6da3f095556d5b896e08fe30d66f67', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 04:45:42', '2022-01-20 04:45:42', '2023-01-20 04:45:42'),
('4104ce0d450d19c71fdee0bf622deb5e10d6d8d2e1a87c1c16e775ed424cb55aa21a0dee2fe90e50', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:51:37', '2022-01-21 06:51:37', '2022-01-28 06:51:37'),
('4122726d8bdc84bf34fdf62873fb74c02be7f27982c0a50ad464752fac306980d55f738364ed6c98', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:14:20', '2022-01-21 10:14:20', '2023-01-21 10:14:20'),
('41a4925ad11cd1d23d6a3e30c6e5ac8c0bc7926ec8d7f263572c4ddb0ea8c10c78a9ccbb4546cc80', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-29 03:51:29', '2022-09-29 03:51:29', '2023-09-29 03:51:29'),
('41a5f4287820758f8586a9de4b7c939caa49e2756b54af59ddb0331b4c9854a6022ef5f39300aadd', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:38:26', '2022-01-15 16:38:26', '2023-01-15 16:38:26'),
('41e7a9aa164d399e31cf5c63b834b57a5e4fcfcfd5054fe052b569e9df64e716d5e4a04df3dd87d7', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:16:36', '2022-06-07 10:16:36', '2023-06-07 10:16:36'),
('42b91365202bf6bf3394c1f03b8a7cae4cbc94ebdfe67cb9df9e9ca97f022820a8dc260798d11637', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 06:48:57', '2022-02-01 06:48:57', '2022-02-08 06:48:57'),
('43dd426689ba04006f94ae4aafc3a4c9804ea897e5419cc175b54f363896e1785d03a528bbd31f91', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:43:42', '2022-01-20 10:43:42', '2022-01-27 10:43:42'),
('440e1de0421358786f2656b34dedee7e27dd544462b80b3e3b079c815efaeccfc112605d44da22f5', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:26:04', '2023-02-08 14:26:04', '2023-02-15 14:26:04'),
('4415cb48b93b817e6dba5d3427c57adbb65e8d69ef6a08462f5f9ab767edfdb7ff9397ffcd3f9f0e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 05:51:18', '2022-01-28 05:51:18', '2022-02-04 05:51:18'),
('45768b2a9839c95fc599a36d40cecb3bd9f07b7dbde84f92ea8d13449bb566cf072c2ef583040a18', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:18:32', '2022-07-26 04:18:32', '2023-07-26 04:18:32'),
('46626101d4e97395fa9df650931e099dbbb7a84552e97a855427dbc4eae713f6d4376f7f5d45c392', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 03:13:57', '2022-01-24 03:13:57', '2022-01-31 03:13:57'),
('46d877581ba05551dcc71c0bcf82371499cd83719dd85efd587c394585ea5919e7633efdcf9f0d41', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:08:52', '2022-01-20 05:08:52', '2023-01-20 05:08:52'),
('4741c285a6f5172c1a19191c9de6733201608b59bd8acf78bc22b77f9651dc02ca4c48a35d038803', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-13 12:47:01', '2022-02-13 12:47:01', '2022-02-20 12:47:01'),
('476d3223f02b71e63f524ff5b6beafecfd7482c8f305b39d4efc909dad8848dc3906e24947dfa15d', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:36:12', '2022-10-04 03:36:12', '2022-10-11 03:36:12'),
('47a89e16a1e637d397174867e3e53c801b07e4de565fc38d8086bd569b28132d7034998a8ac3a678', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 06:48:09', '2022-01-16 06:48:09', '2023-01-16 06:48:09'),
('47ff92fe83772da94e61ae75d26650216677f50f849181fdf10f8056ae73acdfb1b5f7657eeba307', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 06:50:02', '2022-02-01 06:50:02', '2022-02-08 06:50:02'),
('4857f86df056fc4298cc45fc94dc78b848e8a2302ab2c0f9b649312a86d5fb4cd297eddd930595d7', 12, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:39:30', '2022-07-26 06:39:30', '2022-08-02 06:39:30'),
('490e5a4b64174f556ddfac95383ee701a57918e628f244ae599c380bc13e28bf551299f548e76a57', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:29:34', '2022-10-04 03:29:34', '2023-10-04 03:29:34'),
('4a24368550453e06fe16b0b5df1ef968db704c370bc935c95b749afd70d5aeb4aad1bdae0dbbd489', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:46:56', '2022-01-20 10:46:56', '2022-01-27 10:46:56'),
('4a6ebe73968b4e2f4871102a05424a18da770d7bbbf67965f0492dac6ab0785b131d32430b89fbd4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 04:38:43', '2022-01-25 04:38:43', '2022-02-01 04:38:43'),
('4a8bf5bb6772340e38c56b0aadf76e645823448ca2ce9d151dc88f6d6d4ecfa58311ecfec934495e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 09:48:28', '2022-01-24 09:48:28', '2022-01-31 09:48:28'),
('4a9c14ccc43cbb2130df97b7a1b93e0f3f849e21f8c83101b2e29d4fb2ea40771ac4485b0cacbb02', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:10:26', '2022-06-07 08:10:26', '2023-06-07 08:10:26'),
('4aea57e6d635baf079b6e0733d7eac9975b1a760e17da1cbeadf45fae442f8a5b36bbfb28ab91d1a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:40:57', '2022-01-21 10:40:57', '2022-01-28 10:40:57'),
('4b8cc5b62e6d634781ae7322c4304a516ae75a898ee52a637db19a969d0c40acd738e61627d7dfd2', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:14:00', '2023-02-08 14:14:00', '2024-02-08 14:14:00'),
('4bf206a40b37a9e782b1acf0d17fd1888948473fde65b0744cdac3b06c0297822ed6c201bd954164', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:52:21', '2022-01-20 09:52:21', '2023-01-20 09:52:21'),
('4c628441dfd85e2e77e7af57d37beb8edd502f94a7349422919679bb80e773c6b5526d69674e1d48', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 03:52:26', '2022-10-07 03:52:26', '2023-10-07 03:52:26'),
('4d21e952c85058432eb30742253b7df4715481449bbed30a471daccba3206acc31594e098f6a2855', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:26:30', '2022-10-04 03:26:30', '2022-10-11 03:26:30'),
('4e94b4caa240a582a4739ec4c29fd2af96b5c4dbb58c6f0357e5206dd33dea8b63041b4f1d8cfe2d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:03:26', '2022-01-24 16:03:26', '2022-01-31 16:03:26'),
('4e96321f7b80ddc779e0db87c0ee1f54f9930457d94265fcbc272076ddb125e57badffe81b8bf2a1', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 07:41:18', '2022-10-03 07:41:18', '2022-10-10 07:41:18'),
('4ef553c4a941c06dcb27e34e74d5f15acde40e7275540b377237ecab8b1e2df8e0ac0161b2c40ff7', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:31:14', '2022-10-04 03:31:14', '2023-10-04 03:31:14'),
('4fc2ef8ddf63fbe2cf7cf0c2b5a8d1c3d21648ce46b6c2af54f841f6835cc76fd51f5d734d1b3bd9', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-28 10:54:07', '2022-10-28 10:54:07', '2023-10-28 10:54:07'),
('51b63d4ca9324dac0024398a7f2b98fb2681aaed51bef2b73bfa7234e2e3b0cae631c2083a737faa', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-09 14:44:13', '2022-08-09 14:44:13', '2022-08-16 14:44:13'),
('51eef845a39500d27280c91e6e46b384e86fa931ff71fc83512c2d814f90dc9bac127c713170c101', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:17:39', '2022-01-21 09:17:39', '2022-01-28 09:17:39'),
('521484a383e92a0bfa3bc73b7381e6596845d2428d5c2d8f4a9e233390df92d2ba9b7077242e4c22', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:24:50', '2022-01-24 02:24:50', '2022-01-31 02:24:50'),
('52560354b3f8a408a60eb55b6213ef03ccc35a93bccc5d750258dcda64e5bf30789d6648bfbcc06a', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:18:30', '2022-02-08 08:18:30', '2023-02-08 08:18:30'),
('526f5506e4ffe0bde9195bcaa397f9136462cdfb39eb38033192e38ca234c3a1975077e75e066e50', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-17 01:38:14', '2022-10-17 01:38:14', '2022-10-24 01:38:14'),
('529ea00c2287c83055681a3d32a405b56aadd2795e447c32b90747b7b482265ae17b7be961c6e1e4', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 04:25:38', '2022-02-01 04:25:38', '2022-02-08 04:25:38'),
('529f394d0cf5cea748578425772c7e19f10ceb0cf3ae3a713d15ac70dc909dba578f68ec39fa71ff', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:50:34', '2022-01-12 09:50:34', '2023-01-12 09:50:34'),
('52c79d24f3a9eaf3e7bd1d1bb53084ab31e2a7b189a4a9598aa3a1097b1d0cf0edac0e18998d4b36', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-17 04:31:09', '2022-01-17 04:31:09', '2022-01-24 04:31:09'),
('5306ad6b8a5ae270410827775fdc81fc9f145608626e39a13768a35b3bde038979d282d78e76de6f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 08:35:46', '2022-01-24 08:35:46', '2022-01-31 08:35:46'),
('533139522d047536e7fc05fb9ae66bc903b0461fab0c89d89c088a1daa491bca970b239b7905dfa4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:51:52', '2022-01-27 03:51:52', '2022-02-03 03:51:52'),
('536b35958876079e737ef79927191454d11d5ca0335dc0c2f91dd932010433646db4d06c7cdbaf16', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:10:44', '2022-01-24 16:10:44', '2022-01-31 16:10:44'),
('53b00072c81f6be02764a2bb9c4f860245abd9b821d338fe108a3f81beb2a9baf595c67de61f5caf', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:46:34', '2022-01-27 03:46:34', '2023-01-27 03:46:34'),
('53e8a178c7e816a922a574201a0fb86f13626c5d537eaf855cb7d9ffcbe5111d6f1a9cef04c2271a', 7, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:17:06', '2022-07-26 06:17:06', '2022-08-02 06:17:06'),
('54264002fc8ef4d68260654ba3f599d155cd26dba20b72db13dee7c6ad3f69ba3a2bda23085e1b86', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-19 02:29:46', '2022-01-19 02:29:46', '2022-01-26 02:29:46'),
('5429d674637e883876dd1bb52176a261ab738aefffe19cab14d4921d6d238a7fddcd05243f397ee5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:53:37', '2022-01-20 10:53:37', '2022-01-27 10:53:37'),
('545b213d87ea8e392e8ff2513eb1b522d4e7ef835480b10713c94321127b1ccd6d4be02841a3a1b7', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-17 04:31:09', '2022-01-17 04:31:09', '2023-01-17 04:31:09'),
('54a829f37663cd369365f807a378dfd73897190437944e0f634b72fe080bc220b713f493487aca06', 12, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:19:43', '2022-07-26 04:19:43', '2022-08-02 04:19:43'),
('54d00e73241c8345ec6d77c63c9c189ea8e56a4c3df870a3559315c9453407d128fe9ccb894f371d', 11, 1, 'Personal Access Token', '[]', 0, '2022-10-03 08:02:56', '2022-10-03 08:02:56', '2023-10-03 08:02:56'),
('554bb00ef35f821a3d50436eed455f4552d0de34da23592e9c56be78d9f51d98f66d0df5fcd6479f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-23 12:32:17', '2022-01-23 12:32:17', '2022-01-30 12:32:17'),
('55ac11a3532a47f6eb3d0bac3f977b60dd991204b789604411ed604358cee38879e36a0e389169af', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-13 07:26:24', '2022-01-13 07:26:24', '2023-01-13 07:26:24'),
('55f779dce34e6942430e285f0d2597cdea38f0cd4ad1bfd263bdc3497fecc2de0a98703ce1fe347f', 15, 1, 'Personal Access Token', '[]', 0, '2022-10-03 03:17:58', '2022-10-03 03:17:58', '2022-10-10 03:17:58'),
('560c5070835ef6f881fef27e8cd8977bf07f6f7c494ad1edc1139b95868b2f4a2463d78a4c44c743', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:13:26', '2022-01-18 09:13:26', '2023-01-18 09:13:26'),
('58858d052281fb0c5c78ae1d2e3ffa6a83d7fd15cacd61c2157d3917a2fb18cbb5459080c40e5cd9', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 09:05:27', '2022-01-24 09:05:27', '2022-01-31 09:05:27'),
('58acb5d941daf6caf248c0b8ffc45c15f448a9ec02b07f7528274aa997b24861f7e6d2396a735733', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:25:34', '2022-10-04 03:25:34', '2023-10-04 03:25:34'),
('5906ed49769125e43dee29ceb058217e5f3a44e95588237127b0408f533a4706800342a328287bbb', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:28:23', '2022-01-24 04:28:23', '2022-01-31 04:28:23'),
('59cc26fa9caf9be297ae2764930c9cebc5bf6e7c132d35ed43948e61540659c2286797423f4da6e0', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-06 07:12:05', '2022-10-06 07:12:05', '2022-10-13 07:12:05'),
('59da92228f11d25ec3891b4e9031922d0f95978ca8c2aeb2e2442d144ffe33f09a24b3a9ca4fefec', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:24:33', '2022-01-26 07:24:33', '2023-01-26 07:24:33'),
('59e6db7d8aeb6bd94bfa7a31c412abffe1808eacb093c61009dc62bb759ce3fe9f6a86159a10149e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 08:21:22', '2022-01-17 08:21:22', '2022-01-24 08:21:22');
INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('59f1513153eb89fa456db93852465108a311b067b73b9c5a5accdc48c325d5483ef1faf3f87cfa83', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:10:49', '2022-01-24 16:10:49', '2022-01-31 16:10:49'),
('5a0ce8684852e5d6d7ac11ce119f889d218643fdfc67f819e049e4367ddc76328c66045d8023e215', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:47:01', '2022-01-20 10:47:01', '2022-01-27 10:47:01'),
('5a7002915b462f45a33a01762ccb01aa3032e5b28907508495aa184e83d35b10f5dd067c576b3ce2', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:14:01', '2023-02-08 14:14:01', '2023-02-15 14:14:01'),
('5a74c7407fd195d4f3a8995678353f4331bc35049f8935c10345c43f24c5b0cdfa28abca7697b8c3', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-19 06:38:33', '2022-01-19 06:38:33', '2022-01-26 06:38:33'),
('5ac303dee0eb9cc90acc65f1ab0f6240ba5de287ca34e857f32a41699383bf4a4c3948bf28decc5e', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:26:34', '2022-01-16 04:26:34', '2022-01-23 04:26:34'),
('5b08f6b72ae933c1e2172dee60cf91ece13a846d96c210146d38fbfe1f2c3aa45a82eae0b3960d37', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:18:32', '2022-07-26 04:18:32', '2022-08-02 04:18:32'),
('5b9f35d628f674d856182a7c174e27938dc85755f9a859c491bcf690a5dbd75366120d72629beaa8', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:41:53', '2022-01-21 06:41:53', '2022-01-28 06:41:53'),
('5bb4e6dbb6c01a2ec8a6d6e0e2c32ac8c24c36feeb169e45c4496a46051a841703407565135d19e1', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:13:43', '2022-01-16 04:13:43', '2022-01-23 04:13:43'),
('5c82890a20d53772ce5515942c186be620c42e99fc23be33b6eff87078d1b2a0d7bb773a7da2eb6c', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:16:37', '2022-02-08 08:16:37', '2022-02-15 08:16:37'),
('5c87fc3194aae1a4855a6b422e1c0b7f10056d2667cddd1685c58f331c09e06e7d85c9045b22baa6', 133, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:37:59', '2022-01-21 06:37:59', '2023-01-21 06:37:59'),
('5cdc9558277e4ceb53227e083979f8d1faa0f058f0a4b0d0376ee2ddda62a386810a8dcb3e68b787', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-04 09:08:10', '2022-08-04 09:08:10', '2023-08-04 09:08:10'),
('5d1c5aaa59ba45d11fadda5cee50f3698ff27704714f33ebcbbfcfb4edee0042a22d610d6fdc03d1', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:22:52', '2022-01-21 07:22:52', '2022-01-28 07:22:52'),
('5d4c5b19d33b0ebe76f4eb059a1d8adc3ef9e29b28c4bbff0719b6184d9b69617678617cf7e528cc', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:20:39', '2022-10-04 03:20:39', '2022-10-11 03:20:39'),
('5d6a6a905d764b39de5ce5e0905f9618944a6043a434466180bbc360871081348aca5a20b225e253', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 10:11:07', '2022-01-24 10:11:07', '2022-01-31 10:11:07'),
('5d7c15de1d6c5185697c37f49ad2e20725b0269de79949e79bfc804952a497ca615f88f10ccbd2d8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:36:09', '2022-10-05 01:36:09', '2022-10-12 01:36:09'),
('5e07c75fe03d6627c7a408302e02cc049731589fd28eabd39da03355f3c347c0692e4c86d6a53231', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:38:08', '2022-01-20 10:38:08', '2022-01-27 10:38:08'),
('5e8580aa79a953f02da05129e0af44367814ac6130a6b9833a4d37f7e5db81aff2e493c29d61d8c8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:25:34', '2022-10-04 03:25:34', '2022-10-11 03:25:35'),
('5e8edc5e628932565ad53cb620bd9cb3a0fd803822c79dc33bdda3a3716017efd47abae502ea9a0a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:51:57', '2022-01-27 03:51:57', '2022-02-03 03:51:57'),
('5eda9f8976b64eee19729e67410323db0187c49b949ba50c0239a2428bb055fe03af1387d9878cc4', 2, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:15:02', '2022-01-15 16:15:02', '2023-01-15 16:15:02'),
('5f671cc68aed9c61834ed46c117c7c5d5add965fde5b783c7df801eb44ef638320ff87c630318a3b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:42:17', '2022-01-24 15:42:17', '2022-01-31 15:42:17'),
('60a0e7bf65b49d1f20368118469da9a5b30f5441c20f34532b05dcbc13842a1ea386f705df3ad6ed', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:13:13', '2022-06-07 10:13:13', '2022-06-14 10:13:13'),
('610c7517565bb8dba651eeb83277b62593886163b2a397cd3a159e71e04f347e2b2b8479e726acf0', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-06 10:29:59', '2023-03-06 10:29:59', '2024-03-06 10:29:59'),
('610f2abce05e034f7d8131240c109a9d3b88b0102bdfca3237b3ecdebbc6915836fbac7b5e6659b4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:42:18', '2022-01-20 05:42:18', '2022-01-27 05:42:18'),
('6134ea530608e89569f342287d44fee8e8d061eb0f49f3c888525017df132606a7bf78b877d66db3', 12, 1, 'Personal Access Token', '[]', 0, '2022-10-03 06:09:13', '2022-10-03 06:09:13', '2023-10-03 06:09:13'),
('615a4bf72dd8e9118cc2131591cef00e2407bd3c68f5f041f3a2d1efb782c63b3080996b589ff090', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:43:45', '2022-01-20 10:43:45', '2022-01-27 10:43:45'),
('615a5aa799f45416c0bd7f7fd16383a36eba61921dde29b69d553ac86f6bf2f9768d31f5de660756', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:43:35', '2022-01-21 06:43:35', '2023-01-21 06:43:35'),
('621de1fd90184c73e486bb8059bb9966b4fe20aaf7e67cb51fabebaffe61bba5d5189fd5830cd67e', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-23 04:32:09', '2023-02-23 04:32:09', '2024-02-23 04:32:09'),
('6245d9d029e75fb27a51ca4302e944fd084d063753bd4a682092173512099095d3a113c3363448a0', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:14:05', '2022-01-21 10:14:05', '2022-01-28 10:14:05'),
('62c2774ad766a99c73b746d5ddc7f6ba444fa2acc2e69ced0bfcac9e67f9ad30361c50ed30b4b73f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 08:07:56', '2022-01-16 08:07:56', '2022-01-23 08:07:56'),
('63096bee99988c3c1d38feff44c9c7eef9b4e6fb2d283b47534df0f7098138e10b21174306f1df60', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:10:11', '2022-06-07 08:10:11', '2022-06-14 08:10:11'),
('63478775cda9b215d1270bfd078444ad222b10d73746b58f9f0da621c9da69ef8e5fc087af15de8d', 12, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:15:47', '2022-08-03 08:15:47', '2022-08-10 08:15:47'),
('638f55b38bdd024d2b304da6294b31bb1e30ec3e0a79f6e4215c36f3b4fea73d5cc7c41c2ee09b35', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:07:13', '2022-10-04 04:07:13', '2022-10-11 04:07:13'),
('639393d4d26ad00fa91abbb141080713711d108232f4b348bb24e770f221a93e17b604a3f9ddd124', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:26:53', '2022-01-24 05:26:53', '2022-01-31 05:26:53'),
('63cb785ad6c40521dcb0421e778cc1bf9e154bb9b3b39c03421592566dd0523e668b12a6b03467ff', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:28:28', '2022-01-21 06:28:28', '2022-01-28 06:28:28'),
('63d95703f94254d8021d250dd2b584cfe6f5b788af7c6f1a0eb0b833df875856924c73ea96ca945b', 6, 1, 'Personal Access Token', '[]', 0, '2022-09-30 02:55:17', '2022-09-30 02:55:17', '2023-09-30 02:55:17'),
('63f51deb8216b79bf57cb664f060dd03cdf43290be6e5cdbc631dbcd72b8de67558979efcba4d228', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 07:22:27', '2022-10-03 07:22:27', '2022-10-10 07:22:27'),
('6413b07e255adb4619b252d3f07d2ec6df69337dfac5d02077800ea082779ad3d3b32e0030243e7b', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:29:41', '2023-02-08 14:29:41', '2024-02-08 14:29:41'),
('64ea8e80851912a217fa97c7546c616998dbd853749775eb50668e125595cb402da08825fae6501c', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-12 01:34:51', '2022-10-12 01:34:51', '2022-10-19 01:34:51'),
('659ddd9ac4d9f1064d8022a25815f5441eb3ff10721661d6c3de100211aff1f8f74f2635abfc8cc5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:48:30', '2022-01-24 04:48:30', '2022-01-31 04:48:30'),
('662bb6863d0cd1920da2ec85e44a2ab4440a5c5ee169e8586d195cca5a972178b1ef2fa740515ba6', 146, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:42:02', '2023-03-04 07:42:02', '2024-03-04 07:42:02'),
('667d925eee4e3257d20e7dd581fe442a34fedb5919d9bad86426caa3cb0b2bfc6f6f947202c1c968', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:33:22', '2022-01-21 10:33:22', '2022-01-28 10:33:22'),
('668ad7b1cc6b51282d3b95166931e866108b8a15e99ebcdc69f90bd06fd69e974463d44aa48b5c6f', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:31:14', '2022-10-05 01:31:14', '2022-10-12 01:31:14'),
('66d85c1a80a668fd15f08afa88b11930c4c9b68c0aa7e9ee6ed68386cc5b62b56854903dbcf2795b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:50:22', '2022-01-21 10:50:22', '2022-01-28 10:50:22'),
('672626ffc4c53cfeb6686f7b935b27c291eb6d3474f2b2ba2bf304ebb6804df4a483ff88377b237e', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 03:44:08', '2022-02-01 03:44:08', '2022-02-08 03:44:08'),
('67338c8fcbe51b08fbba75ec6361e8a57b67eb122f61b81d1d7bca47263e5d05e6944b680165c1ef', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:16:57', '2022-01-21 06:16:57', '2022-01-28 06:16:57'),
('67d4d851d13e2675760c2001a93bdb688d9dd413ca704fe714dc01248a928e1124339547a1df65e2', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:10:41', '2022-01-26 07:10:41', '2022-02-02 07:10:41'),
('68102e9eddccf172811f4d8d4e389446f68a9c84dd0a3fca3bb4b85ac1f69454364fc4b3d1a489d9', 12, 1, 'Personal Access Token', '[]', 0, '2022-10-03 02:26:53', '2022-10-03 02:26:53', '2022-10-10 02:26:53'),
('6969ec72cc70eebdf1c41c18c5f1ec5e0e6892763068f74665636217cc48d171cee782386d858817', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-10 01:57:09', '2022-10-10 01:57:09', '2022-10-17 01:57:09'),
('6a5567d16bef95724f1d99d734596c750a837d53dd99a009c7b6141d6d24c2d2728af9b24f705c6a', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-28 10:54:07', '2022-10-28 10:54:07', '2022-11-04 10:54:07'),
('6b34cbb205aeeea412ab985bef0d86093ca8917379ee98cd963079cad18cd177e304f48a4ff5f0cf', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:45:32', '2022-01-20 10:45:32', '2022-01-27 10:45:32'),
('6b38d4921705ef25c5aa067821fb00ff02a047e3915f47c90b0c400363cfeb9efd746f1c8f6bf7eb', 5, 1, 'Personal Access Token', '[]', 0, '2022-09-27 07:52:40', '2022-09-27 07:52:40', '2022-10-04 07:52:40'),
('6b4edbe01f2e91fdddd4227c7e297d16b3976b8c6ae27c3ee8be43d757f778466b740ff7b05a8d04', 134, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:08:07', '2022-01-25 09:08:07', '2022-02-01 09:08:07'),
('6b8bf9c22e95a64db3d359e383a75d32b59c033b95fe1c00e6cdea914532b822b61596381ef95624', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:42:02', '2022-01-24 15:42:02', '2022-01-31 15:42:02'),
('6b9b8f7b9fbc8d259932537365381539d670c9c21bb28b6f95b34584d2f42333f3a556d51f5b820a', 7, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:17:14', '2022-07-26 06:17:14', '2022-08-02 06:17:14'),
('6c0017f654e59e9c1bf060d881b36d23e9945b83472a0dcec30bd5638d37b71867c364daa1b7696e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:47:05', '2022-01-24 04:47:05', '2022-01-31 04:47:05'),
('6c6219187582b0210a92e0586e1ee235d882c3429c752306ff0690305a760db07eefc3f560ffbffc', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:15:13', '2022-01-24 16:15:13', '2022-01-31 16:15:13'),
('6ca6588e573e2e28df7737130ff95d466b0178492efe58814eccb52cb93d350803f09f13e894dd89', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:14:05', '2022-01-21 10:14:05', '2023-01-21 10:14:05'),
('6cad315bb1c4a1c3d65d701e05d2f8ede5dc303c43f9bdd6358d789f0daeb1f951f9b9ce8577a8e6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:14:20', '2022-01-21 10:14:20', '2022-01-28 10:14:20'),
('6e4bd6eab8facc87db0e96a27de9f79e545d08c221e6e2db0c85e0113cfce101a87ca840de029947', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-22 03:03:58', '2022-11-22 03:03:58', '2023-11-22 03:03:58'),
('6e51a73f9372adaf3d2587b1c8dd480b70cc910fe0cbda1b0da036f5ef6280627bd1af2f288271fe', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:51:28', '2022-01-21 06:51:28', '2022-01-28 06:51:28'),
('6ecd043f58a758277a6ab80b8743fee447ed83ad6119b6022f54e5006cc34c18789636fdc91ac95f', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 13:25:27', '2023-02-08 13:25:27', '2024-02-08 13:25:27'),
('6ed9027337da5f57f65cfddf2053a1dbcf74fb722625f5b6a6bc86bdd2b031c5c3d3e17974f55f6b', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 00:56:04', '2022-10-04 00:56:04', '2023-10-04 00:56:04'),
('6f271442056376850c26b62f6e45c8ba4f028f97c9de2d6edbca9009cb71369154e0fcbf910bb885', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:45:07', '2022-01-21 10:45:07', '2022-01-28 10:45:07'),
('6f5a072b3635424d109732592cf6008d30c5d8d06f1a40b6103afa1dd152c708f5996b3d96d5acc8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:34:42', '2022-01-24 05:34:42', '2022-01-31 05:34:42'),
('6fa23ed6b692270f8f34182a15afcabb9b4fb1ac556274a5ced6da698330eb887732c942d69a6ac5', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:10:26', '2022-06-07 08:10:26', '2022-06-14 08:10:26'),
('6fbf3090e6ad53cbd2623ea35a82bd40792f16b3c6f55bff1d8302042d24be857db52ebb2edfdc48', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-17 01:38:13', '2022-10-17 01:38:13', '2023-10-17 01:38:13'),
('70b75d2d1cdeedd53f2927150ce72c5286ed5752b60c8d3c61bb805f08d89c1a6adf0e7e179076fb', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-06 07:18:35', '2022-10-06 07:18:35', '2022-10-13 07:18:35'),
('721a993ebe02569416cfa2f6e41962d05fee6b7feb9ef8763d867574eddab9b397908d82b60c661d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:42:43', '2022-01-21 10:42:43', '2022-01-28 10:42:43'),
('72357c38437c33ea323ae6115b3ab2a9ba2b2c6581a27dfda3362baae5af7983b994143c1697172b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:35:05', '2022-01-24 05:35:05', '2022-01-31 05:35:05'),
('7279d38589a8ca5a7b39f3dfcc7ae3d5efa456f02db51f0f38951824854e277f75d7a579b7ab6b19', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:07:13', '2022-01-26 07:07:13', '2022-02-02 07:07:13'),
('72fc36fe81b31e242057007791953db34b02a71a0685e73f86bc3c47df78518fb3bbd3eb295ece2f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:20:11', '2022-01-24 05:20:11', '2022-01-31 05:20:11'),
('73bb197654061fabee6c9c2e69d4b60df262393af183a7ead001b19ae64b877e2db594264f85d2c8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:15:49', '2022-01-27 03:15:49', '2022-02-03 03:15:49'),
('7421521bab24638595ae41b06cf8aea2a2db2e85ddbbabc10b04c8fb7a2f762a3be590873e1e116e', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:26:05', '2022-01-16 04:26:05', '2022-01-23 04:26:05'),
('757c08cf090748ebb697cec102e5e05d1c5f44868c948b209490bfa151ccd8849470a10147cf971f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:23:37', '2022-01-21 07:23:37', '2023-01-21 07:23:37'),
('75934ff1defffd677038e6593dff73bb68b84d8d7239f0a519c9247d7079a2752d920e9c1bee768b', 11, 1, 'Personal Access Token', '[]', 0, '2022-10-03 08:02:57', '2022-10-03 08:02:57', '2022-10-10 08:02:57'),
('75dd2976702e6d698379f2a2b18ce38d6561120f8a9ceade1401facc88bd8013d8e1f7e31d638026', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:44:38', '2022-01-20 09:44:38', '2022-01-27 09:44:38'),
('75f46a570d22108c40bf3588cb014d44b3945e7f8d8d51f4309370c225e1fc08a384a0484fdd59c8', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 03:40:01', '2022-02-01 03:40:01', '2022-02-08 03:40:01'),
('762cc6d369ad4630ba4ce01d81beb781e4237e150fd0044394b3b515a4f5ad04a1fb4d474740f711', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-17 10:27:10', '2022-10-17 10:27:10', '2022-10-24 10:27:10'),
('76effea00fb75600aedb3ee9aefd6c1dc94bd7b09a63fedc5261d52cdb1f010d084ee6434c0e679a', 14, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:32:08', '2022-07-26 04:32:08', '2022-08-02 04:32:08'),
('770d70d64173b5c6cc1258bb9fdc50681367adb8b803cfd0c36d73f3cef8f9442790ec745b4fc164', 1, 1, 'Personal Access Token', '[]', 0, '2023-03-06 06:05:51', '2023-03-06 06:05:51', '2024-03-06 06:05:51'),
('7733bc737cde15638851f461cd7651ec67869c6e3593e71a5b47fa86ee81d3d3676a354032d42bc4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:47:11', '2022-01-24 04:47:11', '2022-01-31 04:47:11'),
('77ab6960ff043e1421b059408bcaf94fd8a42f17ff7f186d8db16fb5c4894a093b177e434d8934e3', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 13:27:12', '2023-02-08 13:27:12', '2023-02-15 13:27:12'),
('782b586a8336077717b8f0dd831c34c66d3ee1076a2b4bbae9457496974791c1632d56ad254a5f6f', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:25:03', '2022-01-16 04:25:03', '2022-01-23 04:25:03'),
('78f2e59e42c14d055d121a1119e5a68b7411dd71faa05c67e8c3b6094963e5d598e72c4e941bbee8', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:48:59', '2022-01-20 05:48:59', '2022-01-27 05:48:59'),
('792a4e0f4fb2a4d5c8b1fdbd69cb4676950b0717b4a654730b4209da48c070cb02919f1f906aa16a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:59:40', '2022-01-20 09:59:40', '2022-01-27 09:59:40'),
('7a6122734ccabdafe72b8fd227f8dc42de284ec4a2200335e22816ea380406f9cc77e271ff1c30f7', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-27 01:41:33', '2022-10-27 01:41:33', '2023-10-27 01:41:33'),
('7bcda09d5431b1b86789231777373b116020ef531e751cd53cb2641c29090a30ee79a925c8dadf9c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:28:27', '2022-01-21 06:28:27', '2023-01-21 06:28:27'),
('7c0ace82ce76c046a8c8a1a34c3a627b8a094b9a091188cec4247dd9cc1f2076e22b0514a0d67da9', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:36:15', '2022-06-07 08:36:15', '2023-06-07 08:36:15'),
('7c14d6c4d27ae8822a6ab84fe2419372b08af50f021be614f4759ba7f0bc0a586e929515de08b301', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:16:21', '2022-06-07 08:16:21', '2022-06-14 08:16:21'),
('7d20a0cafaddf0bcfe407fe1cfb5050401c9202299030c4d2cc3fce2d70087e0f431c4afa05a8822', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:15:27', '2022-01-21 09:15:27', '2022-01-28 09:15:27'),
('7d8c11a1b33e98e67125ededd5c323b01eae49781272315b83755f42646cbfd9b9453ca00516d246', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:01:34', '2022-01-21 07:01:34', '2023-01-21 07:01:34'),
('7ddfce4a603bdaba3f1b19dab45e7e1e4d97c0d695daf406b6ebd00da14fce2fd3d615cc716ffbd4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:40:26', '2022-01-21 10:40:26', '2022-01-28 10:40:26'),
('7e6afd83e8d2381fd5cb0084fc8d00f1e9b3b634ab310608d8d4e3baa56f04c6de53f88edd7f07bb', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:54:16', '2022-01-21 06:54:16', '2022-01-28 06:54:16'),
('7ef0f6acfa34ebe48e10ac328d92aa836e0b23296b93f19dcd67a87e96c19d54fb66f5cb2db38e15', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:22:52', '2023-02-08 14:22:52', '2024-02-08 14:22:52'),
('7efbad6763185388eb38cfbf57b8d0db5362573e33fbff9e2024627c62707fced69ac7051b76822f', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-29 03:52:06', '2022-09-29 03:52:06', '2022-10-06 03:52:06'),
('7f1bf9aee4c739de9428b8a24447db813b6fd3a54941c3f1d8231f246100b7dceba766cecb42d132', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:38:55', '2022-07-26 04:38:55', '2022-08-02 04:38:55'),
('7f433f6588839b2bdbd0fa750babf9748a75c2fa3d5f7b32fbf97d4146b951bc1584a0c2cf01265c', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:24:33', '2022-01-26 07:24:33', '2022-02-02 07:24:33'),
('7fdc4d1c16f576b15dfef8351886771e31e3490ae9d0682293c4a4ef15f1e275f0aabb8d9a2cfbe8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:17:44', '2022-01-21 09:17:44', '2022-01-28 09:17:44'),
('7fdd635075e840b62067fd85ea7d517be680734931838eb3dd90c351e44d8d232feb9159249105d4', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:20:14', '2022-02-08 08:20:14', '2022-02-15 08:20:14'),
('800084bf2c845117f9794d1d2b67a878412d39ab45eda8722f981c19728f00b9c5cfcef18898f3b4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 09:30:16', '2022-01-24 09:30:16', '2022-01-31 09:30:16'),
('8033da32c64fa96fa8b3c9c5a1c638e18bbf2f86dc0ac69e0e324a14a3d78246ea66eaa0d7729b67', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:29:08', '2022-01-26 08:29:08', '2022-02-02 08:29:08'),
('8077bc411234c436e171baa8a99639eafb022415a331f73c72b8b923ef2148089e0c187ae9d28cb8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:22:38', '2022-01-12 09:22:38', '2023-01-12 09:22:38'),
('80d4f42b97d23413f59acdd90c719804e59548bb50f54779aba62462c75fb679e70a9607addebbb9', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:36:45', '2022-01-20 10:36:45', '2022-01-27 10:36:45'),
('81d8e98e4d52b0edc74e709ee2f7d28c61a06a97ef84470456e8792ac7e45aa9972044606e16d60e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 03:11:38', '2022-01-24 03:11:38', '2022-01-31 03:11:38'),
('82367d9a66270a691d816585ca9a2b52bbfd5fc0755c9d7159ad75145a13e38a644b2709ffd2fedd', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:17:10', '2023-02-08 14:17:10', '2023-02-15 14:17:10'),
('826de3a9c7e890bac234f5c4a78888da01da3128b4e8e41393bed4bc0c8a63a0c3185db5f27ff541', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:32:02', '2022-10-04 03:32:02', '2022-10-11 03:32:02'),
('82b65dae6980f81171d14ab03176f55802689a6809ead6b1f6dac70d986e2ab94b5935c16b1c3d26', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:25:15', '2022-01-24 02:25:15', '2022-01-31 02:25:15'),
('82cb2a4e761d21cadf783cf263259e71ce1c82a5e1364443a8fef024514148d31ecef44aa63089b4', 7, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:17:06', '2022-07-26 06:17:06', '2023-07-26 06:17:06'),
('8301aa53e6f8964da878cb06d2a0f157fbc9ea1599a2168277a9aba505a8f4ae6978fb3a3b9df073', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:17:50', '2022-10-04 03:17:50', '2022-10-11 03:17:50'),
('832200755ebda4ca741e2a8462f743b6f1b1836519f40783658f14f20af1c3aa54bf15e7e02c774e', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-26 01:46:52', '2022-10-26 01:46:52', '2023-10-26 01:46:52'),
('83d099730d31feacef60fb8a6744911c1316db11de7816c03db2d512ffb15212e695f139f8f2b79e', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 16:26:12', '2022-02-01 16:26:12', '2022-02-08 16:26:12'),
('83fd83e91200d964f47ff8e7132cacbbd678e14064b84547a9312c7dcd272d2bc78ba5cb5b0d2ebb', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 13:53:35', '2022-01-24 13:53:35', '2022-01-31 13:53:35'),
('840f63831b6255d0797969eda974231df774bfc89f786d8026aeb9e799c7525cafc9f17124a921be', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 07:03:07', '2022-06-07 07:03:07', '2023-06-07 07:03:07'),
('8437c67d7b6831ec592492b3d0f3f9a77869756ff04ca999fbfde46a49b79b1ef140e7f6a4889044', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:08:14', '2022-01-21 07:08:14', '2022-01-28 07:08:14'),
('853b59b608891a2f0bc605c3c5b006653c3c55509ccf0623cae24e774e49b0fdb96c03d44bc55663', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:24:16', '2022-01-24 02:24:16', '2022-01-31 02:24:16'),
('85637835f8948b9bcf5424d2401bdebbbfe95d9b09b870b8e19d7094fd7bbecbaa1e63fd3721e261', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-10 01:56:42', '2022-10-10 01:56:42', '2023-10-10 01:56:42'),
('85919b9ab4d416b9f1e36d2b1aeb8ede3c55f0f138ce0190c692e388fcd0a159f1cc50d0f3a08e15', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-23 02:54:44', '2022-09-23 02:54:44', '2022-09-30 02:54:44'),
('85974677023a0ae75db09834df1afb4e99dd24a7c1cd896aec72acfe42c34ac6b7652be34b396c1c', 5, 1, 'Personal Access Token', '[]', 0, '2022-09-27 07:53:06', '2022-09-27 07:53:06', '2022-10-04 07:53:06'),
('85b4ea2dd8d876f60301228b114aa571a91d2815fc979c0f368575ca58254f20852a87af73e89173', 6, 1, 'Personal Access Token', '[]', 0, '2022-09-30 02:55:17', '2022-09-30 02:55:17', '2022-10-07 02:55:17'),
('85e2315526675d60c252e20ca402230f1ad40829deb745752a852784858ff1199a7122416111230e', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:27:51', '2023-02-08 14:27:51', '2023-02-15 14:27:51'),
('8633bb99d9d1718ee922e0f50f55d00b6a1ae5e00eba7a6399893af1d429fdfae742fd8630220d5e', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-07 09:22:38', '2022-10-07 09:22:38', '2022-10-14 09:22:38'),
('863e9237aa8929995b1f997933b928052020ef20ed9fed2f9d1dd89394d8cca9638777bc96251dc4', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:49:10', '2022-10-04 01:49:10', '2022-10-11 01:49:10'),
('8843a88c6cbc29c2bb6a942ac8ffdcf96ede8f89b1656e370b4b030af3dc6beb810329fd7f710c93', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 08:02:44', '2022-01-25 08:02:44', '2023-01-25 08:02:44'),
('88708220409c8b31066c5aa36341669bef76c70e02b1b72f8407e852193b17fde7bbad494d932fc4', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:13:12', '2022-01-26 07:13:12', '2022-02-02 07:13:12'),
('8937e1753e452406d6d24fb985b4c6b486a1100f5b40ac80e0a3f7aef5e8e346c7525244f7ed2f14', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:27:04', '2022-01-24 02:27:04', '2022-01-31 02:27:04'),
('8959758213d90d0efb84ce81b4dc7219751b7057f12760964fa54ab8dde7f717af0535a47f0f38e2', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-23 04:32:14', '2023-02-23 04:32:14', '2024-02-23 04:32:14'),
('89c295abde913ff74a0a4c21a32d3b9f2e2b52170cc69e1c3dbe5a94d8da4cbdc3873ffd571e8fb5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:30:39', '2022-01-20 09:30:39', '2022-01-27 09:30:39'),
('8a80216f307bc340c0be7ca7fb2c9dbe64c48b3d2953661a6bbb4b7bd709b330505a2f69cce5daef', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-03 01:51:25', '2022-11-03 01:51:25', '2022-11-10 01:51:25'),
('8a8a9653e33fcf01fc1874424db36a916d5f6ecbe731a368c8a2ad179210e69c6b9174a074665d3d', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-25 01:54:32', '2022-10-25 01:54:32', '2023-10-25 01:54:32'),
('8abaacfaed4c3cb209f08c4973c4c3997cf924233f405f0af4843df4df8c5280b7022ce99549ae97', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:44:43', '2022-10-07 06:44:43', '2022-10-14 06:44:43'),
('8b0b218a7e63b38e9464a0674a743979abb36619efd26ef7a487cc6cfec0f2a044558db38027bb97', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:45:52', '2022-01-12 09:45:52', '2023-01-12 09:45:52'),
('8b48a723e2c7d3e13561c5bb8e47f306994b82fcc2c1dff51cc98f2cc08478d06358472eb94c919c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 08:41:37', '2022-01-17 08:41:37', '2022-01-24 08:41:37'),
('8b5e8199ffadfec3aaa270cd578d0d4cdaa1a3a88dc7096d75052e58988cfd17bc6bb140eefe9289', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:03:17', '2022-06-07 10:03:17', '2022-06-14 10:03:17'),
('8b8e573e298c8c9f0b0edc39defa37c1f0fe566e7092d6df9976a923c2bfad85cd647a80d5ba7bdc', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-22 03:03:59', '2022-11-22 03:03:59', '2022-11-29 03:03:59'),
('8baa7a09a2cefd4003c502835bda18e977ce23406a5742902aeab0055e59bba18582b1580b0f4f0d', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-10 01:56:42', '2022-10-10 01:56:42', '2022-10-17 01:56:42'),
('8c7df00347e70e6f2f9beba4e3b6e317e012848471ea5a773ce1cfc666838084e0e005aac2f36ee4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:42:42', '2022-01-17 07:42:42', '2023-01-17 07:42:42'),
('8cffe66750f4130dfd53fb75ec2e893d099fea1c4a7d22f4caa4396305a3b9b8b223d05840b2c5ea', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:31:46', '2022-01-24 15:31:46', '2022-01-31 15:31:46'),
('8d4a4848fce3cf9dc0df1c68136cc0aba075c53a08b42681205db11140c4234e55ac7100a81b0838', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:44:57', '2022-01-21 10:44:57', '2022-01-28 10:44:57'),
('8d7df7a670b2da1e29ddfa978ec21e04f0b86d55d8aac38b13f18018a73a4131cad3f25f996e3b9d', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:37:49', '2022-06-07 08:37:49', '2022-06-14 08:37:49'),
('8e20d12212cd93e584f9b4799858d31b3ae2d0060fb4917eb7f4ec070053d1d7c5eba94ce671e9de', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:17:56', '2022-06-07 10:17:56', '2022-06-14 10:17:56'),
('8ebfd286325a04132c9d5fb797b9951c55b3844fb34e64eb8b10b27137dc9bdcce5b33d07a71bbf0', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-28 08:26:53', '2023-02-28 08:26:53', '2024-02-28 08:26:53'),
('8ee630e1ff39ac952844e8e576cd7f0d6e449a5c4c586cb59a1215e5471f871648d911536b5c2a0a', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:16:54', '2022-06-07 10:16:54', '2022-06-14 10:16:54'),
('8f0a8d7bf76a9a0e3254bf7caaaac1a396b89ee7b8c17f35327a7d60761e9cbd41d384626f4dea0d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:18:52', '2022-01-24 05:18:52', '2022-01-31 05:18:52'),
('8f8e16f25d79a92f490d40cedcca6312eb7960ef652e951d7357162ec1a5b784018f676fb940919d', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:43:35', '2022-01-21 06:43:35', '2022-01-28 06:43:35'),
('8fd13518edc2f214dc1a70e47657e9dad92e64b42deeff68278f8bdc440d3ccde2acab3aa432dd7f', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:17:06', '2022-01-21 07:17:06', '2023-01-21 07:17:06'),
('902401d191ee53b4b23779af38c02e55577a2dc9f46b4e569ed87ea99500e00c200c52dba5ea8f84', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:07:23', '2022-06-07 10:07:23', '2022-06-14 10:07:23'),
('90941c36cfc8a1f95892191c78be36a29a14024feebbf870ff2e82233bb445be515d1615ca4cc622', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:07:17', '2022-06-07 10:07:17', '2022-06-14 10:07:17'),
('9181abd1302932d9632e8c0aa52565313b90bb2c4c8d7ce8342d1c7e8f5545179b6adcbf9068b06e', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:43:16', '2022-01-21 06:43:16', '2022-01-28 06:43:16'),
('91e79f67493543525311f829a514bfaa6e0b07bb87df4db7cae1324d2716edf75c0447032c9323c2', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-04 12:43:35', '2022-08-04 12:43:35', '2022-08-11 12:43:35'),
('93a9716c0c3f5934f14b95c9af5fcb0663782b065c5e4d8671d906dd4ff7a7d77a99426671ffd938', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-02 01:51:41', '2022-11-02 01:51:41', '2023-11-02 01:51:41'),
('93e3b0474f9b5b82d5c927c14173324e97e5c7be4b6ad39aa0ad0057935b78923d46af0cdbde32c2', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 07:04:45', '2022-01-28 07:04:45', '2022-02-04 07:04:45'),
('947217f5c067e1223c641d4f4ea2bf3deb8f668d2cbd53bb11e2a00c2151ce220d3b0e7d7ecfc655', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:25:37', '2022-01-12 09:25:37', '2023-01-12 09:25:37'),
('94be5037c85037bd781373a27df4ab4f56c660ae5393fa39948ee95e1b3aa4ba3039dd31f6d27610', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:19:29', '2022-10-05 01:19:29', '2022-10-12 01:19:29'),
('960db708b31c7fec6321bc81881ce9f07d544af75d7d439fcb0d8044f12fea4fe22bb1a021c83fe6', 15, 1, 'Personal Access Token', '[]', 0, '2022-10-03 03:17:58', '2022-10-03 03:17:58', '2023-10-03 03:17:58'),
('9684f52a9d68d4e5e56e3230e327ece0e400adcb348325eece8bd289d293ff6e6cef0541e9b5c80f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:34:31', '2022-01-24 15:34:31', '2022-01-31 15:34:31'),
('96b417a7735946f25e1667c631b301de7bf7673c6380465fb466babf86579b54fdf28362dec5e2ac', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:18:31', '2022-02-08 08:18:31', '2022-02-15 08:18:31'),
('980e1d2a3101f8d74b2a6418c19caabb1495c3e88f5e00d64abf096a1e64680e5c422d083a1edf82', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-12 01:34:49', '2022-10-12 01:34:49', '2023-10-12 01:34:49'),
('98e8321e56bbdf386b5a8b2d2eb295a2cc94f10cf45af1447c8eaaafee69d38a470203a122f4eacc', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:13:19', '2022-01-19 03:13:19', '2022-01-26 03:13:19'),
('98ea7faa9be2254ea6f47b4447ab0d6a6935f7e2d77ba025ba6a4d808488d3eef1d1d6cdc82e486d', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:16:37', '2022-06-07 10:16:37', '2022-06-14 10:16:37'),
('994a54657e26e29d398b29d66bb3c602f13616afc18175c36c511d6423d88e9bba059cf4d9783034', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 13:14:15', '2023-02-08 13:14:15', '2023-02-15 13:14:15'),
('99b59d90644b09bf4a306b5c6d00b274fc7d2032329839f4bcd9a9c1b0663107b708b50a77d96df8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:12:35', '2022-01-24 16:12:35', '2022-01-31 16:12:35'),
('9a132fe2a0cb0bf72204476b63fe91ee13702d80317973912d1b745a4b3b0b538f343d633399d270', 132, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:30:57', '2022-01-21 06:30:57', '2022-01-28 06:30:57'),
('9a5ab8597e95005e171345a75e7c3234d5559b6bd7ba5a309c8f37f0b7b6fc413072a43798f323e7', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:58:27', '2022-10-04 03:58:27', '2022-10-11 03:58:27'),
('9a791aed4c8b08a230a8c4300099553937a56ea15ea6475b650c7a555c528dc7eeaf403c6d372147', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:39:04', '2022-01-21 10:39:04', '2022-01-28 10:39:04'),
('9b2043c400fbc2a9d90f42cbb32472b5365c4a30a7aa8dd856981d981154717c52be4ee53aba304a', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-23 02:55:43', '2022-09-23 02:55:43', '2022-09-30 02:55:43'),
('9b75168c9b480d5ff843b61f6b8bd6bc437427d50fc1f2d2c361ba7db380759c7fc261abacf53cfb', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:54:56', '2022-01-21 06:54:56', '2023-01-21 06:54:56'),
('9bdcb067ebb2e1c8c1bd7192d0a1afaa3ec08cb4b4f0a96e3a31b9a7ca5adc456e836bb6b3b33c12', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 04:19:37', '2022-01-27 04:19:37', '2022-02-03 04:19:37'),
('9c75ed55f9df6c8445b5c122051b0b391f782f90f35ba605690a07744f6bdf702ff13627b931ad76', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-05 03:19:44', '2022-10-05 03:19:44', '2022-10-12 03:19:44'),
('9d26a39cf5095a79a66c5a570bb870997bc0ab48d1f0a48ce70fd7002c68cf8eb9431a3308c1904d', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:17:02', '2022-01-16 04:17:02', '2022-01-23 04:17:02'),
('9e3af4ee93f9ef0354a2cad3374c0b96adf4f1628d05ac67ba40717e0876824028aab124064ccd92', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-31 02:46:44', '2022-10-31 02:46:44', '2022-11-07 02:46:44'),
('9e550b44f643d5706f485cb31223d0c09f7480d07e115cc95a88c14cce3626756269dfd0d415b3bd', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:49:38', '2022-01-12 09:49:38', '2023-01-12 09:49:38'),
('9e89db5fe13ed2b4ae313d0ece214a965eaa84c8a1b0f5b77d814b2bca706c7968829d86d4463fb1', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:37:13', '2022-01-20 10:37:13', '2022-01-27 10:37:13'),
('9eb9883192b189c2ab179afe0b13ac328b3419d222f4e4cfc35c087da152bdbae2d7197cfc43dbe1', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 06:53:42', '2022-01-26 06:53:42', '2022-02-02 06:53:42'),
('9f7ab689b62f4fba513643aeced3c6bea8912315d2147aab9d352f5334efc056f9372044b98b367d', 12, 1, 'Personal Access Token', '[]', 0, '2022-02-03 08:13:49', '2022-02-03 08:13:49', '2022-02-10 08:13:49'),
('9fcee289ab676fc6bbb7dad479fab7e6fb776e6b94992470702553fe26a6f2c72c3f9e4f92bb4679', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 06:08:57', '2022-01-25 06:08:57', '2022-02-01 06:08:57'),
('a03ffa51fcb02b2fb6557db8deab7bc1f0caf63ad98c317ea9c4982c2534daa4f3005fc1d1462d18', 130, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:24:47', '2022-01-21 06:24:47', '2023-01-21 06:24:47'),
('a1d304465988803f501b465d28cb432f19cd6adb5f95868cd50ba7f6e0146023d235109af5f473cc', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 05:01:57', '2022-02-01 05:01:57', '2022-02-08 05:01:57'),
('a1daf7b637638f3248c50567747da36e3f2464187fbcd7d9262fd5c0931f0d7862bae49fee9c4d19', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:36:16', '2022-01-21 06:36:16', '2022-01-28 06:36:16'),
('a20549b6ceb007e936fab8444c9eb634867c76f6482904de226490a4041162f4399db1f5f2f53395', 8, 1, 'Personal Access Token', '[]', 0, '2022-10-03 04:03:12', '2022-10-03 04:03:12', '2023-10-03 04:03:12'),
('a246b4778f1c453606a57561688806da0fef0013e12827717e1cb9ad83737cdac087df2f88456530', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:08:52', '2022-01-20 05:08:52', '2022-01-27 05:08:52'),
('a2e7374f31b11514cf9866469ee14d5f2306d9e87e1d3ee53bec1d57978547d1366d06ff56245f34', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:17:07', '2022-01-21 07:17:07', '2022-01-28 07:17:07'),
('a3a94a37a776bce7a58cc109c6f6833e483337296ca48969a94fd3f19e8a172da60b0ac3c7d2b855', 14, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:23:02', '2022-08-03 08:23:02', '2022-08-10 08:23:02'),
('a48ad01548b381ba2c4762a88c858163f9fa9d1124270644f64da60073a9170653c6a39062e4b169', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:11:40', '2022-02-08 08:11:40', '2022-02-15 08:11:40'),
('a49a43800968ed3f781eded22a4888257ca4b6cfca35144b6fa232913eb1b0c744fc4036611b046b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:52:03', '2022-01-27 03:52:03', '2022-02-03 03:52:03'),
('a4cb991256bb8a22aa286f92987f8dd845b27ea5b43e5a0aa52e297afdcc910451c282dfb8c80246', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:12:08', '2022-01-24 16:12:08', '2022-01-31 16:12:08'),
('a594b7f134e44dff703f4caecbfadb0e27e5d67aabeae6acca8bb8e7b391f023a88faea628846490', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:41:45', '2022-01-21 06:41:45', '2022-01-28 06:41:45'),
('a5f283234ef3f4272bbb0641931f21bf47ebd072eba0eec5cffe24f65448a0dee70f9065fcae1f35', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 06:48:50', '2022-02-01 06:48:50', '2022-02-08 06:48:50'),
('a611d750b2a980d9b29ff77fffc5c58d86353d2ef5d8886fa1a8912b69b04a2ae24704283f69c8e6', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-18 07:57:50', '2022-08-18 07:57:50', '2023-08-18 07:57:50'),
('a6295040263cea00fcbbec2bacf116555eb0746df1be300d3e6ec58cb4d49b1ba62591c43df49fa4', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 06:43:10', '2022-02-01 06:43:10', '2022-02-08 06:43:10'),
('a641422fe26fbe6c9d27c45696742f1ca09a20d10d3c04ae7236dbac7cc3b3005b5de1eb2ce344c7', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-25 03:02:55', '2022-11-25 03:02:55', '2022-12-02 03:02:55'),
('a6586e0fe6f3aa8de057e7b17d1a6dedf9ae6063343b8d2b03ecba7639987093c51d6075626ca10d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:39:27', '2022-01-24 02:39:27', '2022-01-31 02:39:28'),
('a6f7a952d14f7008b4ce0d4323128bb821c04713e642d48d961ffd87164a5415741459a5e11ec269', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 06:47:43', '2022-02-01 06:47:43', '2022-02-08 06:47:43'),
('a730a8916cf3175d2335197f42267d8155d3359e0d3240607decaed4ffe82a48f7155b01530ec5eb', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:38:00', '2022-01-21 10:38:00', '2022-01-28 10:38:00'),
('a74059a69fda67103872c1d738cd7171abc6cdae23783fa0fe9119c80fba91f0ef6e9bbc7dcf91de', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-19 02:29:46', '2022-01-19 02:29:46', '2023-01-19 02:29:46'),
('a75336529154722c42b0f52955d5f037e114ecf321cf5577d7b57b70dbfdc0923581039b906a3f01', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:48:15', '2022-01-20 10:48:15', '2022-01-27 10:48:15'),
('a76920fb6ae44216e4d077d018d4155c7af4076fd95cff4ca568a88e2e21d51bab8213353c0b04d8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 07:35:40', '2022-10-03 07:35:40', '2022-10-10 07:35:40'),
('a775434d35bc4d7c12c15648005517059791d0204ae87dbad61430b6d870519322843b0e8f6d16f6', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-06 01:48:54', '2022-10-06 01:48:54', '2022-10-13 01:48:54'),
('a7c26ca962c1a6173905f6351bc7998c235b09b9a7c497593ec1653298969f9d31fe307b76719ac5', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 08:34:49', '2022-10-03 08:34:49', '2022-10-10 08:34:49'),
('a7cd0f0c71c0e2a02a628c9c2378495dd2aa341ca561272d7b540d229a6387f8ff16b511b579a140', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 07:03:25', '2022-01-18 07:03:25', '2022-01-25 07:03:25'),
('a7d99d5dcaa4ce81f760d3b5b9fe20d7e52ca8b9a3afb08c8590aab0cfe422bb824e936e8ead0edf', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-06 01:48:53', '2022-10-06 01:48:53', '2023-10-06 01:48:53'),
('a7ef851d9aa36dd188eb4d47e18fc766843a569cf0a3e56da4b55fe425f19e2c2b8aef1698c6af75', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:49:31', '2022-10-04 01:49:31', '2023-10-04 01:49:31'),
('a8906c7a059de8b3b18489735a00bfd84699699037d3a2355af57502fb2a796d91f91a3ee47e1163', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-21 02:14:25', '2022-11-21 02:14:25', '2022-11-28 02:14:25'),
('a91806432fa56db1dcdc342c7ebd36ae444a8327addbe601d85a49de61ea75f95e0290ac5838b557', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-10 09:03:21', '2022-08-10 09:03:21', '2022-08-17 09:03:21'),
('a9d4596425754d290b72f085f40be8671f642d9e2a27a96595d7a3d5b3bea433bfc897cc057d3d0e', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 06:53:41', '2022-01-26 06:53:41', '2023-01-26 06:53:41'),
('aad18625c9cabe96c5bbdeb8bcaadbf358bca3387a394095a665f2a80cb5278f957c7ce471fd5ef8', 15, 1, 'Personal Access Token', '[]', 0, '2022-10-03 06:19:19', '2022-10-03 06:19:19', '2022-10-10 06:19:19'),
('ab3c86b583aaa52b652ba897e7445bb9ef1289dd73b37df62c0546b8aa0b7da6c07987202d4b58f5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:49:40', '2022-01-24 04:49:40', '2022-01-31 04:49:40'),
('ab4a8562608c14894e583d349c34e3de07dc05b3ba9c641a063ee032a182b554b28add56fd950001', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:12:33', '2022-01-24 16:12:33', '2022-01-31 16:12:33'),
('ab9a3599b6933ea496ebbceee1be43bbffc7a84975a8b6b3383efd347a8133b27945afbbb1516d16', 5, 1, 'Personal Access Token', '[]', 0, '2022-08-31 05:39:00', '2022-08-31 05:39:00', '2022-09-07 05:39:00'),
('ac08ecf510ac1d435466f8d0791f162ea77c613ff66f67c62e27af769b551827eff8cf50f6f1363d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 12:33:17', '2022-01-16 12:33:17', '2022-01-23 12:33:17'),
('ac66419572f9808726eb9968d9109ee5c069908fbb94229458fbaa198c1617d31dc1aa1d31f39a73', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:01:35', '2022-01-21 07:01:35', '2022-01-28 07:01:35'),
('ac7b3830235d1c55d147cbd4b821c082698c93a07934c0132d9bf0e82cb6c081661a633a1d588e80', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:18', '2022-01-27 03:57:18', '2022-02-03 03:57:18'),
('ac8f34c808f6aed122ca1cce8424b200b85e7ef1c5002ae1b02f8fd44f7ba2a9a1c13ca6762829d0', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-21 02:14:25', '2022-11-21 02:14:25', '2023-11-21 02:14:25'),
('ad7959495c9a257961e0cd47ee3762bfa65cfca4a1e336eb102713447c5502cbca04e96846ba5a27', 13, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:56:51', '2022-07-26 04:56:51', '2022-08-02 04:56:51'),
('ad8450f984161ebaa1d23c61a2d35c1ca2bc664fd52b62b34cf01d819eb112c72e5debd2037c6f59', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:29:42', '2022-01-24 02:29:42', '2022-01-31 02:29:42'),
('adb77a95d0718bb3d759bc9acc7f06a35d2076635f2ef08bbb8176f7d27bdb97cf95569114a0ab2b', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-23 02:54:35', '2022-09-23 02:54:35', '2022-09-30 02:54:35'),
('adb85720187bcd6c98879f319bcca1e5fa54c73605703077f9a3e3bb7ba69f6c93a1522f79a88131', 13, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:56:51', '2022-07-26 04:56:51', '2023-07-26 04:56:51'),
('adcad192a447de90117c2a4fced0c18be4e099f995d41e6f6f1a7e34c6a2c3c1957c0190e4e2834a', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-06 05:52:14', '2023-03-06 05:52:14', '2024-03-06 05:52:14'),
('ae16d60e42492aee5a9ea6e2894970231ac601a63f37eb467c8e20667ce48e86fb612217c8157573', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:18:31', '2022-01-21 09:18:31', '2022-01-28 09:18:31'),
('ae2d0a17662e6911d45e6767db510007567470b256ef8596104bc86f04b20cd0d8c36cdd6970ebd6', 12, 1, 'Personal Access Token', '[]', 0, '2022-10-03 09:01:53', '2022-10-03 09:01:53', '2022-10-10 09:01:53'),
('ae411ed6da83911533f968f9745728f7d216d01b5aead650962cfb80547b93b91d1185036095066e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:02', '2022-01-27 03:57:02', '2022-02-03 03:57:02'),
('ae6d433c02550ad1311da31b47d637fcfcd548df65c7bfbf7567c0d8f2268fe09278a62266ee01c8', 11, 1, 'Personal Access Token', '[]', 0, '2022-01-26 08:02:33', '2022-01-26 08:02:33', '2022-02-02 08:02:33'),
('ae90496eb7810e8a0980b6976a97fcab8a8139dc722246171952ca45c073edc9a93276fd24fc7622', 6, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:59:58', '2022-08-03 08:59:58', '2022-08-10 08:59:58'),
('af29cfb55b3aa056a4b4a0dc57281c81829585fc3f48265e6e9777f3ab6c39adee8dd44bec59112d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:24:38', '2022-01-24 02:24:38', '2022-01-31 02:24:38'),
('af5484dde65e883ab0ea7d52a99ea040dfecdb9d0cd7cc19018719c45ca7c6e137f3b23aa1842233', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:32:41', '2022-06-07 08:32:41', '2023-06-07 08:32:41'),
('b0042356b969d865e3c496b0c78eb4495e74210d495930a38e720fccbde29a9e5e35a9ebf6769370', 6, 1, 'Personal Access Token', '[]', 0, '2022-08-29 03:30:58', '2022-08-29 03:30:58', '2022-09-05 03:30:58'),
('b045f29d076d3f846a0cc14affbda7c1da197b6351c8abec6d6b4085b256ae6020b343c3f5901b80', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 05:17:43', '2022-10-03 05:17:43', '2022-10-10 05:17:43'),
('b0f28ab0c3e200bcd1048be9a37d195ffb08dc230ea18d7c9522ab4601e031f9c38f440e05c09ef0', 12, 1, 'Personal Access Token', '[]', 0, '2022-08-29 04:20:15', '2022-08-29 04:20:15', '2022-09-05 04:20:15'),
('b168bb94b4a1986d295cbe3b1d2d81670793bbf684dc60f91ad6f26cfacad69468d088fc4fead95a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:48:48', '2022-01-20 10:48:48', '2022-01-27 10:48:48'),
('b18a8d1aa5cba804f3fa0550af0c9defa475ad6456c907b93d015f087d7c444cd0bceac60e78c90f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 08:00:50', '2022-01-25 08:00:50', '2022-02-01 08:00:50'),
('b1a4db3c321e83602beece153067a85aea64d98f5c5966fcc390e7a460abd2eab78ce613804f9e4a', 12, 1, 'Personal Access Token', '[]', 0, '2022-09-29 03:51:29', '2022-09-29 03:51:29', '2022-10-06 03:51:29'),
('b2279fedbbc61292130409e58dbb2b47394d9ae5bfeca65c27a13bfc1bc788aff0b4f7768ca2c4d9', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:54:35', '2022-10-04 01:54:35', '2022-10-11 01:54:35'),
('b279aab7169aa3861c00ebce0eaaafd7b42ac8524a9d6fac8c01bcfefcc768e20d3c3fd8e127506f', 132, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:35:38', '2022-01-21 06:35:38', '2022-01-28 06:35:38'),
('b2b5cbed82c64433954f1b5c7bf7bac0543e5ece263a08d5bd88953fc140aab98b5cd96c8d2a13fe', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:24:40', '2022-01-24 02:24:40', '2022-01-31 02:24:40'),
('b2c123c4d77df63c480e7b03b4962592282eceb89df489b5372cccc2d13e488c0b46f64bc5fb1c8f', 7, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:18:08', '2022-07-26 06:18:08', '2022-08-02 06:18:08'),
('b3822b043a413fd456097890f018faa6ee3302a1a18c2780a552cee645b061c9e2dda541f0a2b776', 12, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:39:51', '2022-07-26 04:39:51', '2022-08-02 04:39:51'),
('b391e0d00e4e24dc86524f59dd6cfc0c3838b1c7db5a46fc6a99e49fc9b052da3b04464524d8a25a', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-08 08:22:52', '2022-08-08 08:22:52', '2022-08-15 08:22:52'),
('b3b9adb9e7a84156cf57eceb4627c5252f407d3aea5e726ad0aecca91a0ac81736b0b4db2edca7c0', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:46:54', '2022-01-21 10:46:54', '2022-01-28 10:46:54'),
('b49fb81f570fb27ecf35147a22b289630de2e7894d77a7b821cc9721dbaa2078fd6a10bd6983a4d8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 05:18:01', '2022-10-03 05:18:01', '2023-10-03 05:18:01'),
('b4ac2cffd360013628aff919e3b4f41c292c8d65b63ec30a57bbe6b71399f02e2cdcc430a85be30e', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:53:22', '2022-01-21 06:53:22', '2022-01-28 06:53:22'),
('b4c1bf25117d09a3840f93c7359e1c9c92c5e3d7a75eb504b4adbf5ed3a1bd3864693efbaa3302aa', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:45:57', '2022-10-07 06:45:57', '2022-10-14 06:45:57'),
('b57c85bf482e21d86a9a1d301b6b234bbba080073792d7f9a02607a25ff203050784828eb9f349c9', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:44:23', '2022-01-20 10:44:23', '2022-01-27 10:44:23'),
('b5abf509604fb00f68dbb95d813f8d2d9720e83736e9e1a5cf0456779902acffaeadcd64e66ea21c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 08:40:15', '2022-01-24 08:40:15', '2022-01-31 08:40:15'),
('b5e0a58f9fa21f87ef700d8f1f4cf3ce0c9a7480b587758fc1c77b8f9efcd340a2debf8fc7633e84', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:41:09', '2022-01-21 06:41:09', '2022-01-28 06:41:09'),
('b68bf51007eca926548732b6ac81f27657aca7939d93b5be981de5ecdd12b392d5abd83d537501db', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:16:53', '2022-01-16 04:16:53', '2022-01-23 04:16:53'),
('b691a37fea5a4038f90784fead8565d074eefab07eb0fbe66a5adef1124826684e034be51550aa9f', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:18:48', '2022-02-08 08:18:48', '2022-02-15 08:18:48'),
('b6cd23f2ca9345e5416f2eb75798302076aa24ff5c56fe069e4cf4d5b82e4bedc8afc2b3707bb842', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 04:32:37', '2022-01-25 04:32:37', '2022-02-01 04:32:37'),
('b70b2ceb0296b31ca15c96821a6288b86527d2c244f43588a81e82b3ca74fea3d51e1d6bb1d6839d', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 03:44:17', '2022-02-01 03:44:17', '2022-02-08 03:44:17'),
('b77edfdf0719b9ff40e4382132c7e1e4bf49753c2db0d91cd0ec61329a7e4c72d01dac9016e939f1', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:51:59', '2022-01-21 06:51:59', '2022-01-28 06:51:59'),
('b780c7fe7fb4b358439098e28f0670d867192f65beee9b098ab8808a54c67ef9d6b1a2db682c6d87', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:44:29', '2022-01-20 09:44:29', '2022-01-27 09:44:29'),
('b7960af13fc09cadbd1c05b98f5da44fe7f44b94d129d8e6ca0990c8c8d24a60f9044c3eefda18f2', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:36:15', '2022-06-07 08:36:15', '2022-06-14 08:36:15'),
('b797cc122743bb72c9a40c19d78a84b7fb34c46d4a72e34ee7203de2c9c9403f3037fc3c96bc223f', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:13:42', '2022-02-08 08:13:42', '2022-02-15 08:13:42'),
('b89a1de4012253e53ba7b5ef7ca9b7bae61c927475fca9a2ddbc4c612324da4820a770d3bc8aaadc', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 05:50:00', '2022-01-16 05:50:00', '2022-01-23 05:50:00'),
('b8d914a9982ed25ad64ddef5856864f83504b417e7f275e8c0e026f5b3b5c742ea3c71ecccab37e7', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:31:13', '2022-10-05 01:31:13', '2023-10-05 01:31:13'),
('b8dbc472cd3aa9b83eaaf9a556d2cd1eba3aea6b04f4a4ad4646266ae3393d4dd22cb31f7ac85170', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:39:51', '2022-01-21 10:39:51', '2022-01-28 10:39:51'),
('b8f5840cb1eceb64c5560a779c00c3734a498b8e17a55ea5ece887d0c21e7c76597ce1379865fca4', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:28:04', '2022-06-07 08:28:04', '2023-06-07 08:28:04'),
('b90bfcf487ad20e076b64d19258f271185b42c1c3021b5a99efb7f0ce3180449dd2830970a080a09', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-12 03:26:12', '2022-10-12 03:26:12', '2022-10-19 03:26:13'),
('ba0a32b543731d2f455898985808b59a038e1ff69e6317b109379fdf8ea25d3200e9f466007b2a9f', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:54:11', '2022-10-04 03:54:11', '2022-10-11 03:54:11');
INSERT INTO `oauth_access_tokens` (`id`, `user_id`, `client_id`, `name`, `scopes`, `revoked`, `created_at`, `updated_at`, `expires_at`) VALUES
('ba8c78b9667e6462d17fb3ed39cd9b1ce16df743e85a3a7f1365a6f425fcfc94a41a84b3337e8152', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 05:18:02', '2022-10-03 05:18:02', '2022-10-10 05:18:02'),
('bb30612cb2f17709fe28b97cb4c7ce0c9d15f8778e8870f21c11d3af8d48cb99c52a00d7efe5d2e5', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 02:06:24', '2022-10-04 02:06:24', '2022-10-11 02:06:24'),
('bb9a503bf7a207894364aa5abd4134b48ba7310ff715acb805d210baae60db92d56cb33be0a8dc41', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-18 03:00:50', '2022-10-18 03:00:50', '2022-10-25 03:00:50'),
('bbebf5a6054c32d77ef84ee8659087127f501f45019210968e80c4a4482a6041bbd0318266b17ba4', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:24:15', '2022-01-24 05:24:15', '2022-01-31 05:24:15'),
('bc4a2ef39adc62304e5b73a1db656c3f07df4a556fef313d5f5d10946f8dce22017e701a926926e9', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:18:26', '2022-02-08 08:18:26', '2022-02-15 08:18:26'),
('bc5224c495466aeddbb97b5d8f9cc55a80ce4a4d4eac6d72991bcea0bd6bd35207360d618146fd10', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:46:11', '2022-01-20 10:46:11', '2022-01-27 10:46:11'),
('bc6b1ace9ee2458f44ccd70c312a6226650660fe52a6cee692064fa790d424984ecb63124ecbda84', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:23:15', '2022-01-24 05:23:15', '2022-01-31 05:23:15'),
('bc6e35e6fd177c387a888b9eabf9d7499d815e5c9729f0ed445ad7a0df9d85694d646e68b533c42a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:06:39', '2022-01-25 09:06:39', '2022-02-01 09:06:39'),
('bce16887478da9c8d0dfa16ec626c6e37166bf2f6c20d6ce6932e84085ef88409faa36f339ab2ffa', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 16:26:06', '2022-02-01 16:26:06', '2022-02-08 16:26:06'),
('bcf8dfb0a713177928051a81a6bf1dd20ea35db46a9c2b62095e4822586000d061d5ff8f6ed2c7de', 8, 1, 'Personal Access Token', '[]', 0, '2022-10-03 04:03:28', '2022-10-03 04:03:28', '2022-10-10 04:03:29'),
('bd43da2748f17a20b1b1ea24efa0ba933e0489bb74ac2540a0d243762b298e61a8e269713ad00f71', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:19:10', '2022-01-21 09:19:10', '2022-01-28 09:19:10'),
('bd7bb61c30fea8d3144687e41cfef26893e52513e5cd3485f9b1d42ddd847d361a2d2a4651a0c28f', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 08:54:33', '2022-01-18 08:54:33', '2022-01-25 08:54:33'),
('bdba6de239b068e26e49e3d3255ad017d1a7bdf7af680914d3828c3d82316cbf862b4105435ea5d6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:30:59', '2022-01-17 07:30:59', '2022-01-24 07:30:59'),
('bde2d783cca4e94139e4a234d437941d0fa4baa70b5cd8457cb440cfd4e7a83f16ea38858ad26629', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:54:23', '2022-10-07 06:54:23', '2022-10-14 06:54:23'),
('bdfdae381211bdee294fe1ae300988dec7c6d024e34bc8d0dd0477b5910db8cc30b240ab7937bf32', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-08 06:02:14', '2022-06-08 06:02:14', '2022-06-15 06:02:15'),
('be3621c30d40d9654517a1a3b7f8f036a24419dd03ca7d2eeb697c92fcc1ffc38cc0642b795634f8', 145, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:28:38', '2022-10-04 03:28:38', '2022-10-11 03:28:38'),
('bed726ddf936a7e7b30c64e478917aef525f805ce750631bfd3e0f0c135860a72746f4d8ff943302', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:46:07', '2022-01-17 07:46:07', '2022-01-24 07:46:07'),
('c048ef8ca792fadb35aa63cac1da1b3deb78371c0d0afe44519089b83e85b0421cabdcc893289489', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:06:33', '2022-01-21 10:06:33', '2022-01-28 10:06:33'),
('c0610e332bffc0d78751bed57d2622cb1db1d53e9ba1849ae65bc08e7adc7b5ff215e3bc198c2286', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:30:35', '2022-01-20 09:30:35', '2022-01-27 09:30:35'),
('c1443445084605107fae91bfeeed93a181beeaecd6140e8021103178eb769923cceeb4ffd5540425', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-05 03:49:08', '2022-08-05 03:49:08', '2022-08-12 03:49:08'),
('c14df03ca53b49c2a4ed915a2edfce338f385f86c8149df938d015f7558532ccf46cf4fa4054163e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:47:39', '2022-01-21 10:47:39', '2022-01-28 10:47:39'),
('c16f72d7024c9a9afd8aefef0755d797b57ca1dddf48efe0be8875cd5731df01f9c9f23969bddc40', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-28 06:21:40', '2023-02-28 06:21:40', '2024-02-28 06:21:40'),
('c1b2aec44a4cbbab81eb978c18842f1ac6e3ae1633350613f37389a74c8e61792fbf161106a837d0', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:14:04', '2022-01-27 03:14:04', '2022-02-03 03:14:04'),
('c1bc50354c315f54e3cd81ed1efd89cc6c01ad908ff2001bd807ee12aaee307f15c735db5c6b2c12', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:30:10', '2022-01-24 15:30:10', '2022-01-31 15:30:10'),
('c1bd102b54478ad7f6af40121214f8326a650847d4c0d34fef46925515031e0bf6df481fcc160ee9', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-07 09:22:38', '2022-10-07 09:22:38', '2023-10-07 09:22:38'),
('c3925745460c596ccef015d06f4b8a02ce40855fcb864dd54e5d1301dfaed9098df3a51687c8b27c', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:57:42', '2022-01-21 07:57:42', '2022-01-28 07:57:42'),
('c3c31a1466d85bd2f8344d74cd0513d15fdf1aebd91b9972eb188939848525a215da6cee4ae69dc6', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-20 01:40:17', '2022-10-20 01:40:17', '2022-10-27 01:40:17'),
('c427687b26b8b41e40d7edf1cda919c205e31069c2730b8fabb82286374dafbbcc7103ecac7e56c6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 04:45:14', '2022-01-24 04:45:14', '2022-01-31 04:45:14'),
('c4297d8198cbceddda5d082e4a8cd8667b15645e71495f7ca9712fe253180d90a35370d6f5f4ec2c', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:42:31', '2022-01-21 06:42:31', '2022-01-28 06:42:31'),
('c4fa6e185ca8524742cd797d445f2ea186e261eaefc186e2f666629775565a702835a2a0784b0ddd', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:40:50', '2022-01-20 05:40:50', '2023-01-20 05:40:50'),
('c4fbbd4e60209d78a02457389638f8320d130513d909ea0badf1cf462335fa37ba0465d27aad0c0b', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:32:02', '2022-10-04 03:32:02', '2023-10-04 03:32:02'),
('c5baac339319617534f7666473c5d651da60d37a7c10d7081f7258fff5c6a5f6eb682be0abebae67', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 08:35:51', '2022-01-24 08:35:51', '2022-01-31 08:35:51'),
('c6027e0294af0f7e7c41214e98f4cbf5644d883d24501340ad4a54b3c171d174870e65f692e51d26', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:15:44', '2022-10-04 01:15:44', '2022-10-11 01:15:44'),
('c61580590a32456326a6f0df2a016ca6d2300e31b4b0bac17ca896cc66ece289f4b0760f7a224c62', 12, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:24:27', '2022-08-03 08:24:27', '2022-08-10 08:24:27'),
('c66b462cfbfd52d651ff248fe5354cb02e8634ed2b772156739d30efffa8b487460539a893adf100', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:51:39', '2022-01-27 03:51:39', '2023-01-27 03:51:39'),
('c6fc3d3141f9887e97b21c99f2ea119b2715bda907781ce82c18327117842e1eb2742cf462680043', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:32:41', '2022-06-07 08:32:41', '2022-06-14 08:32:41'),
('c7658d01bdb4663c25ec4673e23d32143f9a895cf445862f5cf165611da025a551d0b18b1db6c0f4', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-21 03:00:34', '2023-02-21 03:00:34', '2024-02-21 03:00:34'),
('c7f1088d9b8d988e3a84aeed47efcc3406a14940c34b2c9b63a594f425758d5d1522a614f5ad72c6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:02', '2022-01-27 03:57:02', '2023-01-27 03:57:02'),
('c81a1c82495e35fc36e16db5b323364a168c2553a7f7c3b203c8fc366f175017499f6a759861466b', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:46:22', '2022-01-21 06:46:22', '2022-01-28 06:46:22'),
('c85e0bd5cb1bfd60cc39f80fcb256b856bb8ded6c8c39d0b14750356d395d4c4eaa4bc635a9ec449', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:37:13', '2022-01-21 10:37:13', '2022-01-28 10:37:13'),
('c88c91d301bdf669cf9286e2064b88c5185729e69ea42ea23764759d870006967b42f8d0f9c7ff8b', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-01 03:08:56', '2022-11-01 03:08:56', '2023-11-01 03:08:56'),
('c99591107ccf24e9bd11125ee559e23e0f9ffd6a9899052376291fa1a24ac8c3ba8c0fed925bfbc6', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 06:54:33', '2022-10-07 06:54:33', '2022-10-14 06:54:33'),
('caf55297101721cf8aa161978a5d4594fc0e304616320066d98247914e5c1201c07ca6455165b08a', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-25 03:02:55', '2022-11-25 03:02:55', '2023-11-25 03:02:55'),
('cb0ff5f5c48b470728922f6b55d8241dbaf3310a2730381af24a025a09ed752b2e9c7e21b229ed8e', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 03:38:50', '2022-02-01 03:38:50', '2022-02-08 03:38:50'),
('cb5de80e934eb13541773e424cd4963c24b6e5461f56e123244b9a240d3ca8ab55833123aa2a9b6b', 130, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:24:47', '2022-01-21 06:24:47', '2022-01-28 06:24:47'),
('cb63ca160078b820f20de0796b475dbd29c795129026844a22b316e6dce80b88efc80b36acb2b2af', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:40:07', '2022-01-21 10:40:07', '2022-01-28 10:40:07'),
('cc1d7b5ee6b2ec0502482cdbf4f7d7bfde3ab74c1b1bd7042bb15c69b635410f8cdee1de7ede5308', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:10:00', '2022-10-04 03:10:00', '2023-10-04 03:10:00'),
('cc1e25b1ea74e485f3adc4fa008989692630f78b2a557d214323a20d88cddc28739d86ae4379523c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:53:30', '2022-01-12 09:53:30', '2023-01-12 09:53:30'),
('cc584301f6c52476627c480f34ec5681dd50ef519d5300a6183298424288a157149505ad7ddc7ae7', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 05:16:15', '2022-10-03 05:16:15', '2022-10-10 05:16:15'),
('cc7e0a090e03028086f06689224c268b975a85aa053055868465e019b09f0d55d8afba173dc49569', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-09 14:42:49', '2022-08-09 14:42:49', '2022-08-16 14:42:49'),
('cc8c2b3879289aa15ef6aaddd80f2605e49fe64eb1b691f4e7002b16228689da193771f0c47328e4', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-23 01:36:13', '2022-11-23 01:36:13', '2022-11-30 01:36:13'),
('cc95079bd4571479d1c9409b8c000105d10de56d4b2cc57caf52bb20cea8ad864a189a971cf31cf7', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:08:28', '2022-01-27 03:08:28', '2022-02-03 03:08:28'),
('cca2e84e0e482a1cef1093bed23843f515efc1c2b94d8eef1d9081c4fe258f79c638793c96997b9e', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:26:04', '2023-02-08 14:26:04', '2024-02-08 14:26:04'),
('cced6517072084f1b84df0d36283288b371f3005f99c9b4d73c275c86d4407bfe707e586c8502f55', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:45:28', '2022-01-21 10:45:28', '2022-01-28 10:45:28'),
('cd105ec5113d7d4272e2a9a9e9a1ea04d5c29316b3b91ffc1e57f596ba633f7387ab89443bc64e72', 10, 1, 'Personal Access Token', '[]', 0, '2022-10-03 03:21:09', '2022-10-03 03:21:09', '2022-10-10 03:21:09'),
('cd2fc425585553e91c0ee338d5e4abcbe2a2aaac60d587984b7ed5f443aaa6b22f26fbd7381d730a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:50:10', '2022-01-15 16:50:10', '2023-01-15 16:50:10'),
('cd43f4a520b32f304722e455900ed4d91b3d4658cec96fad105ab00b7b48722e925b390fc4d238d3', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:09:55', '2022-10-04 03:09:55', '2022-10-11 03:09:55'),
('cda28e6a5cad447eb4af15451ec21af15c72c8c6786095f3d23c397cb822ea5f7846738cf9fcdfa5', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:49:24', '2022-01-21 10:49:24', '2022-01-28 10:49:24'),
('cdc0b6ce19f08120c3392af1c08bcc3c824d4e0a3bb880e1f4890fb4dcff6e95f383cdb92f8f64e3', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:50:51', '2022-01-20 09:50:51', '2022-01-27 09:50:51'),
('ce001eac0c9b4a0fe1e5241ca051e06171579b967d1bb688bb7c079c40bcaec5d948de560f7810a1', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:29:35', '2023-02-08 14:29:35', '2024-02-08 14:29:35'),
('ce0dc56e9ef56c5321706ca00321a3e28f22751308eb938532c520fc34d1c325a35f3fc2aca71e89', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-27 01:41:34', '2022-10-27 01:41:34', '2022-11-03 01:41:34'),
('ce0f297957341a9a441a2174458b79c5dd1419efd96c77fbecfd2fa999e9475373fa9c175a9b1b64', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:13:26', '2022-01-18 09:13:26', '2022-01-25 09:13:26'),
('ce76f6d335631b65e6174fe4bdfee6021ba72dd6df7ba1cbe3baab99e6603dad51e92ced0dfaa53c', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 00:57:33', '2022-10-04 00:57:33', '2022-10-11 00:57:33'),
('ce80a63f73accd2d425370d4e91681974b45ecde30fe6b41154d491328e0383be7542af8540b9cde', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:12:44', '2022-01-18 09:12:44', '2023-01-18 09:12:44'),
('ce94cbea9ea0dc78e0f13f422e95dcc494381999630c02e08bbb85997bda7e133cfcebcb55b68cab', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:52:25', '2022-01-20 09:52:25', '2022-01-27 09:52:25'),
('cebe0766f12ff593b6b9cf20ce0adc1928957525d1fe0a90030e241009d6e8e33040fa265d3cc1cf', 146, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:08:25', '2022-10-04 04:08:25', '2022-10-11 04:08:25'),
('cfcb251fd3070f1516db5cb4eb01d0fada9cd3cf351e77279e1f0fddb68d90be1a367768b2a01cdc', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:16:15', '2022-10-04 03:16:15', '2023-10-04 03:16:15'),
('cffe73c50ba59b0f71a04c1dc9ada7b6b5023d6e5254856f17fb971f42323aa0ba7386e8e819a93f', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:17:42', '2022-10-04 03:17:42', '2023-10-04 03:17:42'),
('d00ea955823844f0d8275bf3a400682d08e82337101a5570825a72ecaa8d6716d4a8104b7d0deb1d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 09:56:44', '2022-01-12 09:56:44', '2023-01-12 09:56:44'),
('d01bad31a6e27728980a6f9b2050f1678637601ea77ce8e21c1ea1c83f812bb9f07278db61239303', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:01:44', '2022-01-21 10:01:44', '2022-01-28 10:01:44'),
('d0526682a42827d63f7c89b1b87e559e6ecd7f9ac5e99957bda6ce311f68662bb50b0e4dc93b1c08', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:14:38', '2022-01-19 03:14:38', '2022-01-26 03:14:38'),
('d0b527b1480f77dd0a86f9ffdd6aafebf6b0e42e0900f882d8e863d78cd6dada5f9fdc81f8d6ee09', 1, 1, 'Personal Access Token', '[]', 0, '2022-08-04 09:08:11', '2022-08-04 09:08:11', '2022-08-11 09:08:11'),
('d18d4603a99bd5c6b1ebf42a9d6da7a14b9f19928b6b5d97aecb76c728b94530102f73b5d70c6211', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-19 01:54:03', '2022-10-19 01:54:03', '2023-10-19 01:54:03'),
('d1a18d1ca5e59fcf6fef9a53ecad343b7b41f311633095afccb955c4923e06a4a69b47f369793482', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:57:47', '2022-01-21 06:57:47', '2022-01-28 06:57:47'),
('d2262c2f280119b415ee43ba177e1a22ee406649f037674a055937b1cd97d860569317169b6f49f2', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 14:23:11', '2022-01-24 14:23:11', '2022-01-31 14:23:11'),
('d2f2a5337e6c23c9ee0895c63e3b542a489acb4e3241e34832f10a65c22321cac6ea989c93a49876', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:12:58', '2022-06-07 10:12:58', '2023-06-07 10:12:58'),
('d36d17aa188d2edc02f4333aca2e6e4d1a63a7148ecc5ebdbd89cabdc1abc5e2cdd9f0983aebcad8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 09:17:50', '2022-01-21 09:17:50', '2022-01-28 09:17:50'),
('d371862f2ebedf42559f34a584e579c0acfbf39cf0ec5ad4ae7316c78e15a086cfafb13d49af5247', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:15:47', '2022-10-04 01:15:47', '2022-10-11 01:15:47'),
('d3a03986edff57b0e37e8ff0c6e84b1e5528f5af0deb8522f287e173468597fec34d67c2ad1a5794', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:50:34', '2022-01-15 16:50:34', '2023-01-15 16:50:34'),
('d3c8eb8ce3a76068f54516eb3de1221ccacb70ea0911ba80de261198eddb3282426d582f2cca75bb', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 13:14:14', '2023-02-08 13:14:14', '2024-02-08 13:14:14'),
('d3f506f713f61e53c2ce39771da0bf4ee5ed54cd6cd8f5d236f20f137dacc310c4957d209d721ad3', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-25 01:54:32', '2022-10-25 01:54:32', '2022-11-01 01:54:32'),
('d4c9df769ce1c2996728a1da8ceb4840961b4c5636d6a0276097e803566dc7e05d9fccb116b742a1', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:29:35', '2022-10-04 03:29:35', '2022-10-11 03:29:35'),
('d512b77446b7664a141bc3cff659a626ac9106abfa4f9524e9d3375687ac4f60cabc46c5e011888c', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:39:17', '2022-10-04 03:39:17', '2022-10-11 03:39:17'),
('d54b1b429d845b2f18f9c9cd9e01a4b85efc06cf79d006f454d5a4ab4193482467772a5007ef4dce', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:46:35', '2022-01-27 03:46:35', '2022-02-03 03:46:35'),
('d5a398d34f81d056191e3b2fd1605d57e569813f8156e0b58bc697d2f46a5cb1a33ee68d677f81c6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:04:10', '2022-01-17 07:04:10', '2022-01-24 07:04:10'),
('d5a9cc0c3d1667475d0a137772e7e997e789dc86f8586214603a25bcaaeff93bd8bdc6698b2de931', 7, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:19:02', '2022-07-26 06:19:02', '2022-08-02 06:19:02'),
('d6d9828c5e505918bff925831d5ba38b0e0eaa3561ce2bcb4286c35989c136d30daca6f7f47c794f', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-26 01:46:53', '2022-10-26 01:46:53', '2022-11-02 01:46:53'),
('d6f1e583e5b400569a1c62dd5fa57ae1aca5e42c7848dcdcbc20298052b39c2f31094703a66c2b84', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-22 02:05:56', '2022-11-22 02:05:56', '2022-11-29 02:05:56'),
('d8b1e67b22e314c3303dcba2abea78d58ca58f5e344b5d03dc974658a0b3608b80fd94d7ad22fd31', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 02:11:45', '2022-01-21 02:11:45', '2022-01-28 02:11:46'),
('d8b81329212025428157e2ab3e7ff801624706fb5fb1a3f9a67b76e94962d1d70a0d2f5b24dabda6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:37:52', '2022-01-20 10:37:52', '2022-01-27 10:37:53'),
('d98b29f93516280123d3645457bea26e28e653e54b3d2ff70818ea71056495be5f3e1a32e98db839', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:32:08', '2022-10-04 03:32:08', '2022-10-11 03:32:08'),
('d9ba7dcb67c0c67533aa9075aa065f90aaf35f06fc514947f600f40fef251f2308027c13036d6da6', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:23:16', '2022-01-21 07:23:16', '2023-01-21 07:23:16'),
('d9bcf69a5d99708db41bd5b77a00184b6adbec83c801720b6f264f97e76b9c735872b375d8fccc54', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:15:41', '2022-10-04 01:15:41', '2022-10-11 01:15:41'),
('da145bf27e597d8822c9888b5455de13798a55291c66ba2d48ce786c90520e1c221a3a11ed638687', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 06:55:05', '2022-01-28 06:55:05', '2022-02-04 06:55:05'),
('da40472038448f3038d5f10800fd1e93c6ba8b02fa8e0c3e9f73dc8b2add4f59db6f0e571f58aa08', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-01 15:12:34', '2022-02-01 15:12:34', '2022-02-08 15:12:34'),
('daa24e0e4e3e62976773d73ad9e4a7dbb1125a74e5bda11c576f06a2e6d4b79b7f0d5c5fba23f88b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:20:42', '2022-01-21 07:20:42', '2023-01-21 07:20:42'),
('daabb5f624119f25ccfc71e78a52f2fde0142ffc736d7c84da58e0f6b51487fc3673d024dcbba9c2', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:13:13', '2022-06-07 10:13:13', '2023-06-07 10:13:13'),
('dab72bebad3e2ce594183bb45b9bfbbc565a7561e69488d25b526f1303e699e2305e54edcdcbabc6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:36:55', '2022-01-21 10:36:55', '2022-01-28 10:36:55'),
('dafae8dc63864830f6ceebf9b73ebde6ca5ee0a8c5d8ad0a00908a887b62418ff651f4ef697beae6', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:23:17', '2022-01-21 07:23:17', '2022-01-28 07:23:17'),
('dafc1d65bc6b53586d6377bf723902403e9cd1ef88fc34100815cab7ccd810f896d07698f9acc74c', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:16:58', '2022-06-07 10:16:58', '2023-06-07 10:16:58'),
('db02f0af2b61481cb2ece066e6283ae5c8546dadfcc5cadbd25625967fd9f6e62b8afd4ba0556d7a', 12, 1, 'Personal Access Token', '[]', 0, '2022-08-03 08:12:23', '2022-08-03 08:12:23', '2022-08-10 08:12:23'),
('db75ea7b49465ec01a86329e1427d590383b904600292d0d78304ce2984a9f59a7d3a5a0ed231c90', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:27:50', '2023-02-08 14:27:50', '2024-02-08 14:27:50'),
('db8e66399b9d4f4f94c040ed2a28b98c0dadd76442c9f5307a82e7b41c93634e86ca142b847fa7ba', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-01 03:08:56', '2022-11-01 03:08:56', '2022-11-08 03:08:57'),
('dbcd1495fb93c168da983c95ad2fbbe12f622e9fe4e4f827eaa829f150ab3f2f6be79625f4c10765', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:13:18', '2022-01-19 03:13:18', '2023-01-19 03:13:18'),
('dc2b2b78eee5f17596091e9c2c272dfe4239e438eb8d3d7703f96b5277b0d489d048e606006f4eab', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-17 04:31:53', '2022-01-17 04:31:53', '2022-01-24 04:31:53'),
('dc97b47e5da68c929682a1864c223c4960e4b6f0d1429e19f711f391d8170436fc1c8845926b60ab', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:34:28', '2022-10-04 03:34:28', '2022-10-11 03:34:28'),
('dcbb61948f592d0bd736de7c0eca01f41dc5244da34d6e7f6b43590ccdc7c250670ce9c619d60a9b', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-23 04:32:08', '2023-02-23 04:32:08', '2024-02-23 04:32:08'),
('dd7176bcb317df6711b46ee7f8df64ecfea9410149f7f70ad41f6b2d5218d6d6611fb8490f94125e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:42:43', '2022-01-17 07:42:43', '2022-01-24 07:42:43'),
('ddf31c7ca58f417e35c754917f40eb746e83577c9b6e1cb41daab78d749861f492e282179e860d4f', 134, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:03:52', '2022-01-25 09:03:52', '2023-01-25 09:03:52'),
('de61abe914a84abe1fa18f313f26889516611bc305d14597dc24ca3dc541ee3153ac1a31f2d65ae7', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:43:47', '2022-10-04 03:43:47', '2023-10-04 03:43:47'),
('deb5966b051388ec15424071fcfc5138179de19638d1931248334ef32b74f8738ddb48e5d3897def', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:20:43', '2022-01-21 07:20:43', '2022-01-28 07:20:43'),
('def753870ab51a3b495bf781cf65f6b5cba08b6159caf0010a745bad3299cc21ba3d1a293de8ea9f', 1, 1, 'Personal Access Token', '[]', 0, '2022-03-24 09:13:22', '2022-03-24 09:13:22', '2022-03-31 09:13:22'),
('df207d88b5b1778ca2e3938b5291562619d42bcf08d813c7a58db33640b50c61cd4cf96da86210c0', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-06 02:45:51', '2022-10-06 02:45:51', '2022-10-13 02:45:51'),
('df40f129c9c22ce89cf50d262cee4c175474580575e0f1aced2b90d850d56754e28b7a5e6f98d91c', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:48:59', '2022-01-20 05:48:59', '2023-01-20 05:48:59'),
('df63ea15c369395444b09b7a3872c0ea768a0db01593a4c5dffb8e9e27d5c940159b92075f652a24', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:29:50', '2022-10-04 03:29:50', '2022-10-11 03:29:50'),
('df84b8fff2c19dee771f590643d5f47238e686be372aa4de7ca9ac79dc15afaa59c598770f3557f4', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-06 05:52:13', '2023-03-06 05:52:13', '2024-03-06 05:52:13'),
('e014bccf47233a855cc4285a24cd74ac4a28f4ce91e8c507f1eedb2dbfe57c767a794395a1b418e6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:34:38', '2022-01-24 05:34:38', '2022-01-31 05:34:38'),
('e03ed69034a6d9f7b7096100358eaf59bbf9b331d4dbe12d0519d1c85bdaa529e1fe6c5d4000ee4f', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:29:15', '2022-10-05 01:29:15', '2022-10-12 01:29:15'),
('e074a74dd4377f9766610c73f5e0dc553e493bfb55633760b51664c467f015d892c93568f58193f8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:38:57', '2022-01-21 10:38:57', '2022-01-28 10:38:57'),
('e1376416e599cea3f059b14649707cc936331371b47caebb521f75d820134d93a31b23a1bd923898', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-22 02:05:56', '2022-11-22 02:05:56', '2023-11-22 02:05:56'),
('e13d7455f4c59ca60d4764a3cd48d823e08df3cc196846edc20b9b13e28526ef411d24251994839e', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-19 01:54:03', '2022-10-19 01:54:03', '2022-10-26 01:54:04'),
('e173a3cda896a4df40a619cc939a736d6c5878dedf24fc8c7418b061d528607f949e6a5da366fe42', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:35:03', '2022-01-24 05:35:03', '2022-01-31 05:35:03'),
('e189d12db7a42d798193a89e770430b49923743c129b817ed92c5ac0726569b5fbf3b72b60fa7253', 1, 1, 'Personal Access Token', '[]', 0, '2022-03-24 08:29:12', '2022-03-24 08:29:12', '2022-03-31 08:29:12'),
('e1e606a466def293369d91c74d971acbacd9347ddaacc8dfd8ae1940bed9ae653b9599fa645b007c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:54:57', '2022-01-21 06:54:57', '2022-01-28 06:54:57'),
('e2232956f33aa2a6cd0018840f5e57d80d665b26d1bb9251d5f917b1c569b58dea6de0fd60065bf8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-16 13:00:09', '2022-01-16 13:00:09', '2022-01-23 13:00:09'),
('e329564b11c88879b25dad6687625bafabc362e19e88a49938c24d969e9d17782ee18e57f2253934', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 07:03:07', '2022-06-07 07:03:07', '2022-06-14 07:03:07'),
('e3ad7f3e771173f89bfef78cdac0c758249938d52340bf0ee9f2e9852487a2bdda707853bc5a4aab', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 07:03:44', '2022-01-18 07:03:44', '2022-01-25 07:03:44'),
('e3e0905d2def8e0eedc4197d8b09b5846c8e9178cc6fede5d9816f86f07e7fc922d6232deb4bbfc9', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-21 03:02:51', '2023-02-21 03:02:51', '2024-02-21 03:02:51'),
('e406989615c2a4211c9e96c3911695a43bcddaf6fe0cbbf29eda253a84f487a5ebff6460d622dc85', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:44:41', '2022-01-20 09:44:41', '2022-01-27 09:44:41'),
('e4588dedbad579dfe137731069229be4730f59e19a4aa21d45fcfe1b3c39a245a999db80271e06e1', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:36:31', '2022-10-04 03:36:31', '2022-10-11 03:36:31'),
('e4eb24b81ce0ec2fa6351fcd1036e41a2d0e86adafefa20ddc13cfdc92b264731bb86b6cce4904f5', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:08:55', '2022-06-07 10:08:55', '2023-06-07 10:08:55'),
('e4f4aee4524ea5d666ac60d67b9d29be077f6d46c68156f9ed570e37dc06793d05e93a90199666d3', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:29:41', '2023-02-08 14:29:41', '2023-02-15 14:29:41'),
('e50cd27ac25c4d21c12d063ba1aa31baf575ae20e7899cd843add2231dcfab93a682438505d21fa9', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-08 06:47:14', '2022-06-08 06:47:14', '2022-06-15 06:47:14'),
('e5316b53a1286c5f8cc87a81d3eaeb40473e37d84365abaa4d3cdf51ce400418d3f44049d096b1cf', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 16:12:11', '2022-01-24 16:12:11', '2022-01-31 16:12:11'),
('e6ff80754f16915a3a8c03daf12a2aad5f9ebc6cff6e2080d577a1dd5ca5f5a993f15b4433b3461e', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:49:32', '2022-10-04 01:49:32', '2022-10-11 01:49:32'),
('e7488fe4660a1c4e5250a6488164c359b38e742d59f4f8fbcc3f25eeef29fad5ac24ab74e77d2419', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:42:18', '2022-01-20 05:42:18', '2023-01-20 05:42:18'),
('e87459d05095f915b668a9b6f1fbfac68b0dc5316e122e7262f5a5a41e78c61c7792ffd135802717', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-03 15:25:34', '2022-10-03 15:25:34', '2022-10-10 15:25:34'),
('e89da3db4089111ab1c7b72d57d6163e10f4e5c078b29ef5cea04c4c81004b46107caf736e74d06a', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 04:45:43', '2022-01-20 04:45:43', '2022-01-27 04:45:43'),
('e90baa14c2d93d60b296b663234870ce68ad17dfe86ebe3a240bacd140ea767bea853b2dd8255ce8', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-18 05:45:10', '2022-01-18 05:45:10', '2022-01-25 05:45:10'),
('e96de88fcb72fe71e72440b76684ce26112bc7f99126ba642cdc2fb9fd7cfae97d98cd6b9021254b', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 05:51:40', '2022-01-16 05:51:40', '2022-01-23 05:51:40'),
('e9b1e6604678a63f5c4cc924b06ff73a96ab6b368e35af5faeb035cb77e6f055691f0d41cb069aa6', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:04:20', '2022-01-26 07:04:20', '2022-02-02 07:04:20'),
('e9c72c6898f67fa95f2411a7b71d710b218067268f2ce87a4b820cde215e3cc17f7fd557e9d4d1da', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-05 01:19:28', '2022-10-05 01:19:28', '2023-10-05 01:19:28'),
('ea181c41c33f21fe28711fbebda5b0b3bee8dbfe78a01099a0d2e4d9bde11cc79b0f2c70056274cc', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-20 09:44:29', '2022-01-20 09:44:29', '2023-01-20 09:44:29'),
('ea47a184fcd8ed9500c4d9bd3634b414e2c1fe0b97f635a8ddbb04033123490ab6a396739e008736', 1, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:17:48', '2022-07-26 04:17:48', '2023-07-26 04:17:48'),
('ea9e6375434c4dd34f12d4bbf2f86a27f9015cd6f09d8b9cd8b89dea135bd537f49e1945e33a2b26', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 05:19:32', '2022-01-24 05:19:32', '2022-01-31 05:19:32'),
('ead107fbcff74d9e8690236720746a84f40d89b2515f5a635e589456727ff51a81e2ec3ba2bc139f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:28:21', '2022-01-24 02:28:21', '2022-01-31 02:28:21'),
('eb5ce375e10c4adf59303ced7ddbbd924ec4ff94b7fb8a83715a7a6e8bde0dab1925ba58b1af935e', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:41:50', '2022-01-21 06:41:50', '2022-01-28 06:41:50'),
('eb5d85a44cc7a94e9b8bbf85255340cc39247b542b84d8e4c8a4aa9f10756225033b50f3140f8f3d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-12 13:36:05', '2022-01-12 13:36:05', '2023-01-12 13:36:05'),
('ebaac2726cd279d5f05bc57a21b40f923d25865843bacf0c85ff5fed04f37aa1144d6467bc54ebfd', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:15:19', '2022-06-07 10:15:19', '2022-06-14 10:15:19'),
('ec0dc4ecfdd2c2d821daf03486ef20c36822092333957cd76a774d5b96806cfffc4c272db59d4755', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:00:51', '2022-01-18 09:00:51', '2022-01-25 09:00:51'),
('ec54d4d60816d0564f61d410199ee6a093a66405289c80451c1a5572635801ed9a8aac4deb76e3ee', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:25:39', '2022-01-24 02:25:39', '2022-01-31 02:25:39'),
('ec89e5501a2b23db3bc3358042b1e5a8bdf4f91d9fd76674ebfbf50fd5f5f6551342a6b04b38ea21', 1, 1, 'Personal Access Token', '[]', 0, '2023-02-21 02:52:18', '2023-02-21 02:52:19', '2024-02-21 02:52:18'),
('edaf82c389703bc9fa1b59f751f838c3bd073909c39302c8b4758938970b70af9e94308dcdcbc9f6', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:29:35', '2023-02-08 14:29:35', '2023-02-15 14:29:35'),
('ee336a81cb8262c151a6a13ae2f5dc1eed523e0f4f6a675e4ea91abb2672e717c7df13fe0c00e528', 145, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:28:22', '2022-10-04 03:28:22', '2022-10-11 03:28:22'),
('ee34cf3b4ac53c1d8421e8c7ccbc9d92094d3f52fb98911c19e5ced64980b07b5a23c567ec398614', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-16 04:25:51', '2022-01-16 04:25:51', '2022-01-23 04:25:51'),
('ee77606468f6234688dc4c6981ea95e464278c005b20a963a6eb2da51dced1d018a47a3974b00ed2', 1, 1, 'Personal Access Token', '[]', 0, '2022-06-07 08:28:05', '2022-06-07 08:28:05', '2022-06-14 08:28:05'),
('eeacebf6d64c90fbe79df370a40d7dfba9a4461f0742073a9d7a30053ac3570d5e60870bba7221e7', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:43:15', '2022-01-15 16:43:15', '2023-01-15 16:43:15'),
('eee69a75a01d8be841bb56ee5caec3b5865817b3a037adebda0d66733bc04bb7d41adae9d6051756', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:49:46', '2022-01-20 05:49:46', '2022-01-27 05:49:46'),
('f049e115667fcdea0597b63f1153bd21077a0a38ae58c22ae7ae8a70a502f46be36a8014a521e8f5', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:01:46', '2022-01-26 07:01:46', '2022-02-02 07:01:46'),
('f05676aa4742841b17f8bcdf1671be7850d95de9dd3d53a0ce360df6c6f5dde9dc050e98b6485f45', 2, 1, 'Personal Access Token', '[]', 0, '2023-02-23 04:32:13', '2023-02-23 04:32:13', '2024-02-23 04:32:13'),
('f0a0fc84f047a11db66fcf774766c42c7b7664b864a454a7df2ef8f2098c29fcce754ce268a8de7e', 3, 1, 'Personal Access Token', '[]', 0, '2022-01-18 09:04:49', '2022-01-18 09:04:49', '2022-01-25 09:04:49'),
('f1475748b5e479a021d86ae8c1646abf5283a0854768985aa7d098031afc1e7c66c5db54564d34b8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 03:43:47', '2022-10-04 03:43:47', '2022-10-11 03:43:47'),
('f1a4609bb9557ed487ac1ce3548f86bc35a3efdf0d4f81a7b56cbc549f606730311ab3a650b0d484', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-23 01:36:13', '2022-11-23 01:36:13', '2023-11-23 01:36:13'),
('f1ab9a9c0545490934558e6119737a300c893b00e1c99449ff89d4531931a5f0d45d65cba7ce914f', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 06:47:13', '2022-01-27 06:47:13', '2022-02-03 06:47:13'),
('f1eb70cf0932a3a556210bdf56776f5a820b14a17175b544a70b4fd00681fef18abe41bb08b35e19', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-26 07:07:13', '2022-01-26 07:07:13', '2023-01-26 07:07:13'),
('f237ef1f8d4349ff4f8781394e15c12fa9bcc37a68ed67ca4841f021ae2a85b5841c230cf2b1ed32', 12, 1, 'Personal Access Token', '[]', 0, '2022-10-03 04:02:14', '2022-10-03 04:02:14', '2022-10-10 04:02:14'),
('f242ef1e237b62c12d82ba076fd1263febeb1eea9a81b7977ee6a879fa1d9bccc159f917a37c7797', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:42:30', '2022-01-21 06:42:30', '2023-01-21 06:42:30'),
('f280ac2a753390f32a32d0ff93770571423206bf8a7a976c68eba68416ce219d72e682e04ab228c4', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-04 01:02:23', '2022-10-04 01:02:23', '2022-10-11 01:02:23'),
('f2ed63c62635d6755b7d3354309da8c867906e45436f954d3af20f53ffa473d0adc22dc3ff9a3172', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 05:48:42', '2022-01-25 05:48:42', '2022-02-01 05:48:42'),
('f2ef7439026626510c4e54501c23d487d24796c54f89f1b9a43391eb5b9e8887b8ba9ec4dc3d332d', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-19 03:14:37', '2022-01-19 03:14:37', '2023-01-19 03:14:37'),
('f32dad82b0e3dddbe974293f60e082a653c343b29e5b0caf67d0e559d01fe25efb127d9ac82d88a1', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:39:39', '2022-01-24 02:39:39', '2022-01-31 02:39:39'),
('f35c1d8ab2e36b801eb69a6aa7418a2898cc0079b785e474fe26cdc74876e254c7e2cddffaa00ba6', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-11 01:58:13', '2022-10-11 01:58:13', '2023-10-11 01:58:13'),
('f3973c6a92aebaad5d8cf973cb9fe18530d1f2778848a452b3d7d9cf05b53f05fca584c8cca22407', 16, 1, 'Personal Access Token', '[]', 0, '2023-02-08 14:22:52', '2023-02-08 14:22:52', '2023-02-15 14:22:52'),
('f39d40ccb445e9c08f8854ea673e913f1d60ba107dd06b240b700c719d3bddaf36b05528a357f8f1', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 03:12:20', '2022-01-24 03:12:20', '2022-01-31 03:12:20'),
('f4dc1f182b32097d7b91e18fdbd7fb1b9743b838a1d768ef9cd05f051ad687896442c34d81a8cbd0', 13, 1, 'Personal Access Token', '[]', 0, '2022-07-26 04:31:46', '2022-07-26 04:31:46', '2022-08-02 04:31:46'),
('f551449f1ae35064c709e1f407177252380c01a18896a2815741a19a061528e37eb564534ff8ddd8', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-07 03:52:27', '2022-10-07 03:52:27', '2023-10-07 03:52:27'),
('f572657a1deeefd21a2c65fbc8f68595438b6b87b904c95890d50b09b17eff28ef5601268a2bea35', 146, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:08:34', '2022-10-04 04:08:34', '2022-10-11 04:08:34'),
('f5f1ec1bcd23be77ccd95ae6f08f3962a58a5ddd93d6a13814e75b990624cb9cc11ea23996a6db3e', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 04:43:10', '2022-10-04 04:43:10', '2022-10-11 04:43:10'),
('f6937f5a470e0da48ecb936a8439506a75aa17d300992be28cc0aca961a084e6e0f133cc0d9b448c', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 05:49:45', '2022-01-20 05:49:45', '2023-01-20 05:49:45'),
('f6d669632d4b6602743b677b14329a41819571d1a2e2df90c3dc8f730929253e5a2f5b71d0903489', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:11:03', '2022-02-08 08:11:03', '2022-02-15 08:11:03'),
('f709a467b956e7733eadd04bf06d5a6338d3b301f95fce9c6bdff5514145be6a40c5a5c7732d703b', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-03 08:36:33', '2022-02-03 08:36:33', '2022-02-10 08:36:33'),
('f74b264c232bd7eecbf1204ef02cdcfd4d4da186ee4bfaf2a94c47317122aad2c3dd8189a31d5aaf', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-28 06:34:22', '2022-01-28 06:34:22', '2022-02-04 06:34:22'),
('f75b4216c554a09bdbd0017716ac7028cdceaed82606684290763e3899b60c1694dec804cab94adb', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 02:39:20', '2022-01-24 02:39:20', '2022-01-31 02:39:20'),
('f7aa39ce1e9a45ff79f6e828f69b1802639fa805b6f30251256164ef09ba2f3206c665b7cbe27333', 16, 1, 'Personal Access Token', '[]', 0, '2022-06-07 10:07:17', '2022-06-07 10:07:17', '2023-06-07 10:07:17'),
('f80d6a219dd47004ec1e15bd0170e1663eb2cb8cb2e1693625b72696db4716c8473e5ba2e848d6f0', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 07:22:31', '2022-01-21 07:22:31', '2023-01-21 07:22:31'),
('f81bd46c8f744b840e69b6447c7bb0a8eaaa77c13b441ba5083f1b0edc3148952540517f3f279f9d', 2, 1, 'Personal Access Token', '[]', 0, '2022-10-06 06:28:45', '2022-10-06 06:28:45', '2022-10-13 06:28:45'),
('f82ac681bc7be737a38e090b0c05c7d4f41d041553e0ff23574d2ca9fb95bd9cddcef41092cf522e', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:43:51', '2022-01-20 10:43:51', '2022-01-27 10:43:51'),
('f88506b59b06652df624d8040686c0a238440acdb8c8fb9f5173528fabdca6c6727eb4689ecc4765', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:43:56', '2022-01-15 16:43:56', '2023-01-15 16:43:56'),
('f8ec3c608c581dc244ebd8c955a2e33c13cb43ca0cabe1e32b500f737ee1af462485a205a70ce2c3', 1, 1, 'Personal Access Token', '[]', 0, '2022-02-08 08:19:31', '2022-02-08 08:19:31', '2022-02-15 08:19:31'),
('f97e00172df37b9fd283993c7c6ec99b3338c83ed6e2dccb5d9f0a71f97c6e6ccb63143da335e47c', 2, 1, 'Personal Access Token', '[]', 0, '2022-11-30 02:30:52', '2022-11-30 02:30:52', '2022-12-07 02:30:52'),
('f9ab3f452021a51e8d0e2ef116053c0eb886339c62f66f2785931c148b51ef929316c4db4e5cd1b9', 5, 1, 'Personal Access Token', '[]', 0, '2022-09-09 02:50:58', '2022-09-09 02:50:58', '2023-09-09 02:50:58'),
('f9ba6fed981a12f06c5a9e66bcb7e6fae13172c33dd492712301bf3ca839422f573e15b261e96436', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:42:20', '2022-01-21 10:42:20', '2022-01-28 10:42:20'),
('f9c49fa71f01d12fc73fce72bf180d29541779922e388d507e3a5c78bf02b31cce3ad0eed3730ecb', 12, 1, 'Personal Access Token', '[]', 0, '2022-07-26 06:41:10', '2022-07-26 06:41:10', '2022-08-02 06:41:10'),
('fa0ca6bd4a8737369f16f6d17f21150b4d0a446f9250aa19ea1c2f115d61755d78d33c467b5d71bb', 131, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:29:40', '2022-01-21 06:29:40', '2023-01-21 06:29:40'),
('fa3da5aa2fb601fd2e7fd2bbc55b6a4c238a3bfc9fb6d0b9f691b760f5152a2607076add7ba62506', 15, 1, 'Personal Access Token', '[]', 0, '2022-10-03 07:06:36', '2022-10-03 07:06:36', '2022-10-10 07:06:36'),
('faa62603eaf5cd1c0ff3b9179d9e699aa3f269d217ad44e64e1b77b8ede33113738a2f9a4479ce4b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-17 07:33:38', '2022-01-17 07:33:38', '2023-01-17 07:33:38'),
('fb110480aa6a68abd159a9d2972b6985167035c70fdf2eeef4155d8e78f5bae6d4d0887a2b97c52b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-21 10:36:02', '2022-01-21 10:36:02', '2022-01-28 10:36:02'),
('fcb1c6c029886322ac7740cb818b94720394fdbf9cac6699e03511a05d0a3daf449db4a68b0664f3', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-25 09:14:56', '2022-01-25 09:14:56', '2022-02-01 09:14:56'),
('fcea13714bd7cc0de8c519bf38025177d1b047aa112423341c884fe57bdf495f19700477506c62a3', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-15 16:45:36', '2022-01-15 16:45:36', '2023-01-15 16:45:36'),
('fd413439820f8bb55537b553fd5ceecd9fde6952465ed314eb84f612959ed9a6fbcc6c5db5f2206d', 12, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:54:15', '2022-01-21 06:54:15', '2023-01-21 06:54:15'),
('fd56ff6d3b96bbe4b89ea7d09ff029df02779f4817105ba7d6fcf51c88ec8d785fc7e5be54381630', 2, 1, 'Personal Access Token', '[]', 0, '2023-03-04 07:42:01', '2023-03-04 07:42:01', '2024-03-04 07:42:01'),
('fd72273e394cd6e121075553fdc80819448d2a5d7c9b790daac590a9af0ff7b3b2a303a493406051', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 04:19:36', '2022-01-27 04:19:36', '2023-01-27 04:19:36'),
('fe6d8b8408a0849b22d0e6ad7deac24e60fccde634bf98faf2c0be3a63c4499cee139f349204635b', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-27 03:57:12', '2022-01-27 03:57:12', '2022-02-03 03:57:12'),
('ff2094def7011ed660e7dc643e4b3c58c1581f7cc35d69041fe4adbb9134d7ec23cfbdafa451c177', 133, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:38:00', '2022-01-21 06:38:00', '2022-01-28 06:38:00'),
('ff277597bd2cf1e9e7741cb44d39b006030b84ce1d0b9c1de42a1de06540a72a3ff348c4ad73fff6', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-24 15:42:35', '2022-01-24 15:42:35', '2022-01-31 15:42:35'),
('ff6e582ed6c7cecca3987180fe15de5e333cf23372680fcd6017414ecfbce87b5927f99cfff93b3e', 16, 1, 'Personal Access Token', '[]', 0, '2022-01-21 06:57:58', '2022-01-21 06:57:58', '2022-01-28 06:57:58'),
('ff991240c3eb32000ee7f438a4f405c5d5d1438315615f3b80e5e008a09841bbc79c7e46a7cdd7f3', 1, 1, 'Personal Access Token', '[]', 0, '2022-10-04 02:06:23', '2022-10-04 02:06:23', '2023-10-04 02:06:23'),
('ffb78a48a175a6dd9d3116a1444a65200f76a2219b68a6bcd4dfc8f4e7c2be2c85975c28cb8b2ade', 1, 1, 'Personal Access Token', '[]', 0, '2022-01-20 10:36:43', '2022-01-20 10:36:43', '2022-01-27 10:36:43');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `client_id` bigint UNSIGNED NOT NULL,
  `scopes` text,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `secret` varchar(100) DEFAULT NULL,
  `provider` varchar(255) DEFAULT NULL,
  `redirect` text NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `provider`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Edocument Personal Access Client', 'u58qfgs7cWEGAgJGsmCMKIEgOwSvsTZW2IMLYGIS', NULL, 'http://localhost', 1, 0, 0, '2022-01-12 07:32:53', '2022-01-12 07:32:53'),
(2, NULL, 'Edocument Password Grant Client', 'qb1koIoEVEzOGW3eBh1uL1gbaxX3Ytzcqf8THozk', 'users', 'http://localhost', 0, 1, 0, '2022-01-12 07:32:54', '2022-01-12 07:32:54');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint UNSIGNED NOT NULL,
  `client_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2022-01-12 07:32:53', '2022-01-12 07:32:53');

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) NOT NULL,
  `access_token_id` varchar(100) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `id` int NOT NULL,
  `email` varchar(500) DEFAULT NULL,
  `password` varchar(500) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `active` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `setting`
--

INSERT INTO `setting` (`id`, `email`, `password`, `created_at`, `updated_at`, `active`) VALUES
(1, 'arnon.r@tgde.kmutnb.ac.th', '123456', '2022-01-24 16:14:16', '2022-01-24 16:14:16', 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `icit_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `prefix` varchar(50) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `icit_email` varchar(255) DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `pid` varchar(255) DEFAULT NULL,
  `account_type` varchar(255) DEFAULT NULL,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'staff',
  `status` int NOT NULL DEFAULT '1',
  `dep_id` int DEFAULT NULL,
  `email_person_id` int DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `active` int NOT NULL DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `icit_name`, `prefix`, `firstname`, `lastname`, `icit_email`, `name`, `email`, `email_verified_at`, `avatar`, `username`, `password`, `pid`, `account_type`, `type`, `status`, `dep_id`, `email_person_id`, `remember_token`, `created_at`, `updated_at`, `active`, `deleted_at`) VALUES
(1, 'อานนท์ รักจักร์', 'นาย', 'อานนท์', 'รักจักร์', 'arnonr@kmutnb.ac.th', NULL, 'arnon.r@tgde.kmutnb.ac.th', NULL, NULL, 'arnonr', '$2y$10$oVKqrCDy1uIamg5F8MMp2uyDQ.Xaf72khcbCTG9eWG1huZ2/ZAjeG', '1100200629414', 'personel', 'admin', 2, 1, NULL, NULL, '2022-01-12 09:22:18', '2023-03-07 16:02:40', 1, NULL),
(2, 'บุศรา สิทธิศศิธร', 'นาง', 'บุศรา', 'สิทธิศศิธร', 'butsaras@kmutnb.ac.th', NULL, 'butsara.s@op.kmutnb.ac.th', NULL, NULL, 'butsaras', '$2y$10$nRh.aCTQ6PbF.5JJNfi.MuSJK0FPS7imfJFB9QlPLncUBCX8I2OXa', '3210500683274', 'personel', 'admin', 2, 1, NULL, NULL, '2022-01-16 03:29:37', '2023-03-06 10:29:59', 1, NULL),
(12, 'พิศมัย เยี่ยมแสงทอง', 'นาง', 'พิศมัย', 'เยี่ยมแสงทอง', 'pissmai.y@eat.kmutnb.ac.th', NULL, 'pissmai.y@eat.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 5, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:45:23', 1, NULL),
(16, 'แสงเดือน พุทธัง', 'นางสาว', 'แสงเดือน', 'พุทธัง', 'sangduanp@kmutnb.ac.th', NULL, 'sangduan.p@tgde.kmutnb.ac.th', NULL, NULL, 'sangduanp', '$2y$10$80JrWpdd9MNQ5yIv.f9CG.uip//ZSbkGTmXQILKnQZmo8ju0iqr.y', '3521200342658', 'personel', 'staff', 2, 1, NULL, NULL, '2022-01-20 09:43:17', '2023-03-03 08:30:15', 1, NULL),
(145, 'จิรพงศ์ ศุภประดิษฐ์กุล', 'นาย', 'จิรพงศ์', 'ศุภประดิษฐ์กุล', 'jirapong.s@op.kmutnb.ac.th', NULL, 'jirapong.s@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 4, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:43:49', 1, NULL),
(146, 'ปวีณา เขื่อนแก้ว', 'นาง', 'ปวีณา', 'เขื่อนแก้ว', 'paweenak@kmutnb.ac.th', NULL, 'paweena.k@op.kmutnb.ac.th', NULL, NULL, 'paweenak', '$2y$10$vBxsYsvYAp2RIKUiO88VEOv771Pbk9iFFTyC018i5AbT9mu44/u6m', '1469900244740', 'personel', 'staff', 2, 5, NULL, NULL, '2022-01-16 03:29:37', '2023-03-04 07:42:05', 1, NULL),
(147, 'เดชาชัย แบ่งสันเทียะ', 'นาย', 'เดชาชัย', 'แบ่งสันเทียะ', 'dachachai.b@op.kmutnb.ac.th', NULL, 'dachachai.b@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 6, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:48:35', 1, NULL),
(148, 'ณิชชา', 'นาง', 'ณิชชา', 'หงษ์วิไล', 'nitcha.h@op.kmutnb.ac.th', NULL, 'nitcha.h@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 6, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:46:31', 1, NULL),
(149, 'ปรมินทร์ มีมงคล', 'นาย', 'ปรมินทร์', 'มีมงคล', 'poramin.m@op.kmutnb.ac.th', NULL, 'poramin.m@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 2, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:43:35', 1, NULL),
(150, 'วชิรวิทย์ ตลุนจันทร์', 'นาย', 'วชิรวิทย์', 'ตลุนจันทร์', 'wachiravit.t@op.kmutnb.ac.th', NULL, 'wachiravit.t@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 4, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:44:11', 1, NULL),
(151, 'จุฑามณี จันทร์พันธ์', 'นางสาว', 'จุฑามณี', 'จันทร์พันธ์', 'jutamaneeja@kmutnb.ac.th', NULL, 'jutamanee.j@op.kmutnb.ac.th', NULL, NULL, 'jutamaneeja', '$2y$10$pvZMuNbmQgGe.E1VWHTbRuH51.osiNP5r3l0NbJB6EvMS2nlt4i4i', '1350100018446', 'personel', 'admin', 2, 1, NULL, NULL, '2022-01-16 03:29:37', '2023-03-04 07:09:49', 1, NULL),
(152, 'พัชรี บุญทอ', 'นางสาว', 'พัชรี', 'บุญทอ', 'patcharee.b@op.kmutnb.ac.th', NULL, 'patcharee.b@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'ceo', 2, 5, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:44:42', 1, NULL),
(153, 'สุเมธ ขัดสาย', 'ว่าที่ร้อยตรี', 'สุเมธ', 'ขัดสาย', 'sumet.k@op.kmutnb.ac.th', NULL, 'sumet.k@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 3, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:43:23', 1, NULL),
(154, 'จริยา คำสกล', 'นางสาว', 'จริยา', 'คำสกล', 'jariya.c@op.kmutnb.ac.th', NULL, 'jariya.c@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 3, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:38:19', 1, NULL),
(155, 'น้ำฝน ศรีโพธิ์', 'นาง', 'น้ำฝน', 'ศรีโพธิ์', 'numphon.s@op.kmutnb.ac.th', NULL, 'numphon.s@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 5, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:45:35', 1, NULL),
(156, 'สุพัตรา พูนแก้ว', 'นาง', 'สุพัตรา', 'พูนแก้ว', 'supattra.p@lib.kmutnb.ac.th', NULL, 'supattra.p@lib.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 6, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:49:25', 1, NULL),
(157, 'ธนัช เดชาปัญญาสถิต', 'นาย', 'ธนัช', 'เดชาปัญญาสถิต', 'thanat.d@lib.kmutnb.ac.th', NULL, 'thanat.d@lib.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 6, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:49:06', 1, NULL),
(158, 'พนพล วรนุช', 'นาย', 'พนพล', 'วรนุช', 'panapon.v@icit.kmutnb.ac.th', NULL, 'panapon.v@icit.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 6, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:48:49', 1, NULL),
(159, 'แววดาว ไชโย', 'นางสาว', 'แววดาว', 'ไชโย', 'waewdao.c@op.kmutnb.ac.th', NULL, 'waewdao.c@op.kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, 'personel', 'staff', 2, 5, NULL, NULL, '2022-01-16 03:29:37', '2023-02-28 03:46:01', 1, NULL),
(160, NULL, NULL, 'ธัญชนก', 'พัฒนสว่าง', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 1, NULL, NULL, '2023-02-28 03:33:49', '2023-02-28 03:33:49', 1, NULL),
(163, NULL, NULL, 'เพ็ญพิชชา', 'สาคเรศ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 2, NULL, NULL, '2023-02-28 03:37:22', '2023-02-28 03:37:22', 1, NULL),
(164, NULL, NULL, 'ละม่อม', 'มีบุญ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 2, NULL, NULL, '2023-02-28 03:37:46', '2023-02-28 03:37:46', 1, NULL),
(165, NULL, NULL, 'คร', 'ล้ำสุทธิ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:38:47', '2023-02-28 03:38:47', 1, NULL),
(166, NULL, NULL, 'อนันต์', 'ชูจรัส', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:39:23', '2023-02-28 03:39:23', 1, NULL),
(167, NULL, NULL, 'สหะภาค', 'กระพรรณ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:40:19', '2023-02-28 03:40:19', 1, NULL),
(168, NULL, NULL, 'จักรกฤษ์', 'ภารดีวิสุทธ์', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:41:22', '2023-02-28 03:41:22', 1, NULL),
(169, NULL, NULL, 'สัญญา', 'คำพงษา', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:42:01', '2023-02-28 03:42:01', 1, NULL),
(170, NULL, NULL, 'ประกด', 'เสือดำ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:42:17', '2023-02-28 03:42:17', 1, NULL),
(171, NULL, NULL, 'สุชาติ', 'คำพงษา', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:42:40', '2023-02-28 03:42:40', 1, NULL),
(172, NULL, NULL, 'ณัฐพงษ์', 'บุญบรรจง', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 3, NULL, NULL, '2023-02-28 03:43:03', '2023-02-28 03:43:03', 1, NULL),
(173, NULL, NULL, 'สาวิตรี', 'กัลยาลัง', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 5, NULL, NULL, '2023-02-28 03:45:12', '2023-02-28 03:45:12', 1, NULL),
(174, NULL, NULL, 'ชาญชัย', 'วิทยาลัย', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 6, NULL, NULL, '2023-02-28 03:47:08', '2023-02-28 03:47:08', 1, NULL),
(175, NULL, NULL, 'ทัศนีย์', 'งามประเสริฐ', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 6, NULL, NULL, '2023-02-28 03:47:54', '2023-02-28 03:47:54', 1, NULL),
(176, NULL, NULL, 'ศิริมา', 'ศิริคช', NULL, NULL, '@kmutnb.ac.th', NULL, NULL, NULL, NULL, NULL, NULL, 'staff', 1, 6, NULL, NULL, '2023-02-28 03:48:22', '2023-02-28 03:48:22', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `book_code`
--
ALTER TABLE `book_code`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_favorite`
--
ALTER TABLE `book_favorite`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_in`
--
ALTER TABLE `book_in`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_in_category`
--
ALTER TABLE `book_in_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_in_old`
--
ALTER TABLE `book_in_old`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_in_type`
--
ALTER TABLE `book_in_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_out`
--
ALTER TABLE `book_out`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_out_category`
--
ALTER TABLE `book_out_category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_out_favorite`
--
ALTER TABLE `book_out_favorite`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_out_old`
--
ALTER TABLE `book_out_old`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_out_type`
--
ALTER TABLE `book_out_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_status`
--
ALTER TABLE `book_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `book_year`
--
ALTER TABLE `book_year`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email_group`
--
ALTER TABLE `email_group`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email_person`
--
ALTER TABLE `email_person`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `book_code`
--
ALTER TABLE `book_code`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `book_favorite`
--
ALTER TABLE `book_favorite`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `book_in`
--
ALTER TABLE `book_in`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก', AUTO_INCREMENT=234;

--
-- AUTO_INCREMENT for table `book_in_category`
--
ALTER TABLE `book_in_category`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงหน่วยงาน', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `book_in_old`
--
ALTER TABLE `book_in_old`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก', AUTO_INCREMENT=226;

--
-- AUTO_INCREMENT for table `book_in_type`
--
ALTER TABLE `book_in_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงประเภท', AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `book_out`
--
ALTER TABLE `book_out`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงเอกสารรับเข้า-ส่งออก', AUTO_INCREMENT=241;

--
-- AUTO_INCREMENT for table `book_out_category`
--
ALTER TABLE `book_out_category`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงหน่วยงาน', AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `book_out_favorite`
--
ALTER TABLE `book_out_favorite`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `book_out_old`
--
ALTER TABLE `book_out_old`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;

--
-- AUTO_INCREMENT for table `book_out_type`
--
ALTER TABLE `book_out_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `book_status`
--
ALTER TABLE `book_status`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงสถานะ', AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `book_year`
--
ALTER TABLE `book_year`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงหน่วยงาน', AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงหน่วยงาน', AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `email_group`
--
ALTER TABLE `email_group`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงเมล', AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `email_person`
--
ALTER TABLE `email_person`
  MODIFY `id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสอ้างอิงเมล', AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `setting`
--
ALTER TABLE `setting`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=177;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
