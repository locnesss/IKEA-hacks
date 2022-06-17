-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 17, 2022 at 05:16 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ikea_hacks`
--
CREATE DATABASE IF NOT EXISTS `ikea_hacks` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ikea_hacks`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `søg efter contributor posts med contributor_ID` (IN `XX` INT(11))  SELECT * 
FROM content
	INNER JOIN contributors 
        	ON content.contributor_ID = contributors.contributor_ID
WHERE content.contributor_ID = XX$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `søg efter contributors med contributor_ID` (IN `XX` INT(11))  SELECT *
FROM contributors
WHERE contributors.contributor_ID = XX$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `søg efter indlæg med product_name` (IN `XX` VARCHAR(20))  SELECT *
FROM content
	INNER JOIN product
		ON content.product_ID = product.product_ID
WHERE product_name = XX$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `underkategorier og antal post` ()  SELECT subcategory.subcategory_name, COUNT(subcategory.subcategory_ID) AS count_of_subcategory
FROM content
	INNER JOIN category 
		ON content.category_ID = category.category_ID
	INNER JOIN subcategory 
		ON category.subcategory_ID = subcategory.subcategory_ID
WHERE content.category_ID = category.category_ID 
AND subcategory.subcategory_ID = category.subcategory_ID
GROUP BY category.category_name
ORDER BY count_of_subcategory$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Vis over- og underkategorier` ()  SELECT category.category_name, subcategory.subcategory_name
FROM category
INNER JOIN subcategory ON category.subcategory_ID = subcategory.subcategory_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Vis udgivede over- og underkategorier med antal underkategorier` ()  SELECT category.category_name, subcategory.subcategory_name, COUNT(subcategory.subcategory_ID) AS count_of_subcategory
FROM content
	INNER JOIN category 
		ON content.category_ID = category.category_ID
	INNER JOIN subcategory 
		ON category.subcategory_ID = subcategory.subcategory_ID
WHERE content.published = 1
GROUP BY category.category_name
ORDER BY count_of_subcategory$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE IF NOT EXISTS `category` (
  `category_name` varchar(25) NOT NULL,
  `category_ID` int(11) NOT NULL AUTO_INCREMENT,
  `subcategory_ID` int(11) NOT NULL,
  PRIMARY KEY (`category_ID`),
  KEY `subcategory_ID` (`subcategory_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_name`, `category_ID`, `subcategory_ID`) VALUES
('stuen', 1, 4),
('soveværelset', 2, 2),
('entreen', 3, 3),
('badeværelset', 4, 5),
('køkkenet', 5, 1),
('bryggers', 6, 3);

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

CREATE TABLE IF NOT EXISTS `content` (
  `contributor_ID` int(11) NOT NULL,
  `content_ID` int(11) NOT NULL AUTO_INCREMENT,
  `category_ID` int(11) NOT NULL,
  `product_ID` int(11) NOT NULL,
  `content_title` varchar(150) NOT NULL,
  `content_text` text NOT NULL,
  `created_on` date NOT NULL,
  `published` tinyint(1) NOT NULL,
  PRIMARY KEY (`content_ID`),
  KEY `contributor_ID` (`contributor_ID`),
  KEY `category_ID` (`category_ID`),
  KEY `product_ID` (`product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `content`
--

INSERT INTO `content` (`contributor_ID`, `content_ID`, `category_ID`, `product_ID`, `content_title`, `content_text`, `created_on`, `published`) VALUES
(1, 1, 1, 2, 'IKEA hack til Lack bord', 'giv dit bord nyt liv med dette hack', '2022-06-20', 1),
(3, 2, 2, 4, 'Hack til Tullsta stol', 'Du kan polstre din Tullsta stol for nyt look i dit soveværelse', '2022-06-22', 1),
(5, 3, 3, 5, 'Planten der kan give et godt indeklima på badeværelset', 'planten er med til at suge fugt', '2022-06-30', 1),
(2, 4, 5, 6, 'Sådan hacker du din teodores stol', 'den passer perfekt til dit nye køkken med dette hack', '2022-06-27', 1),
(4, 5, 6, 3, 'Mere opbevaring til dit bryggers', 'med dette hack kan du opbevare alt', '2022-06-15', 0);

-- --------------------------------------------------------

--
-- Table structure for table `contributors`
--

CREATE TABLE IF NOT EXISTS `contributors` (
  `contributor_ID` int(11) NOT NULL AUTO_INCREMENT,
  `contributor_name` varchar(25) NOT NULL,
  `contributor_email` varchar(25) NOT NULL,
  `password` varchar(14) NOT NULL,
  PRIMARY KEY (`contributor_ID`),
  UNIQUE KEY `contributor_email` (`contributor_email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `contributors`
--

INSERT INTO `contributors` (`contributor_ID`, `contributor_name`, `contributor_email`, `password`) VALUES
(1, 'Jens Jensen', 'jensjensen@gmail.com', 'jensjensen'),
(2, 'søren sørensen', 'soren@gmail.com', 'soren123'),
(3, 'lars larsen', 'lars@gmail.com', 'lars123'),
(4, 'ulrik ulriksen', 'ulrik@gmail.com', 'ulrik123'),
(5, 'martin martin', 'martin@gmail.com', 'martin123');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE IF NOT EXISTS `product` (
  `product_name` varchar(30) NOT NULL,
  `product_ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`product_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_name`, `product_ID`) VALUES
('Kivik', 1),
('Lack', 2),
('Metod', 3),
('Tullsta', 4),
('Strelitzia', 5),
('Teodores', 6);

-- --------------------------------------------------------

--
-- Table structure for table `subcategory`
--

CREATE TABLE IF NOT EXISTS `subcategory` (
  `subcategory_name` varchar(25) NOT NULL,
  `subcategory_ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`subcategory_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subcategory`
--

INSERT INTO `subcategory` (`subcategory_name`, `subcategory_ID`) VALUES
('stole', 1),
('sofaer', 2),
('skabe', 3),
('borde', 4),
('planter', 5);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `category_ibfk_1` FOREIGN KEY (`subcategory_ID`) REFERENCES `subcategory` (`subcategory_ID`);

--
-- Constraints for table `content`
--
ALTER TABLE `content`
  ADD CONSTRAINT `content_ibfk_1` FOREIGN KEY (`contributor_ID`) REFERENCES `contributors` (`contributor_ID`),
  ADD CONSTRAINT `content_ibfk_2` FOREIGN KEY (`category_ID`) REFERENCES `category` (`category_ID`),
  ADD CONSTRAINT `content_ibfk_3` FOREIGN KEY (`product_ID`) REFERENCES `product` (`product_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
