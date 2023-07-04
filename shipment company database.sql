-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 27, 2023 at 07:49 AM
-- Server version: 10.2.38-MariaDB
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `HAN21080174`
--

-- --------------------------------------------------------

--
-- Table structure for table `bankAccountInfo`
--

CREATE TABLE `bankAccountInfo` (
  `bankAccountID` int(45) NOT NULL,
  `customerID` varchar(45) CHARACTER SET utf8 NOT NULL,
  `bankName` varchar(70) CHARACTER SET utf8 NOT NULL,
  `bankAccountNumber` text CHARACTER SET utf8 NOT NULL,
  `bankBranch` varchar(45) CHARACTER SET utf8 NOT NULL,
  `country` varchar(10) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bankAccountInfo`
--

INSERT INTO `bankAccountInfo` (`bankAccountID`, `customerID`, `bankName`, `bankAccountNumber`, `bankBranch`, `country`) VALUES
(1, 'CM_001', 'ABC Bank', '123456789', 'Main Street', 'US'),
(2, 'CM_002', 'XYZ Bank', '987654321', 'Broadway', 'US'),
(3, 'CM_003', 'First National Bank', '456789123', 'Park Avenue', 'US'),
(4, 'CM_004', 'Second National Bank', '789123456', 'Fifth Avenue', 'US'),
(5, 'CM_005', 'Global Bank', '321654987', 'Wall Street', 'US'),
(6, 'CM_006', 'Regional Bank', '654987321', 'Main Street', 'CA'),
(7, 'CM_007', 'City Bank', '2468101214', 'Madison Avenue', 'US'),
(8, 'CM_008', 'State Bank', '13579111315', 'Lexington Avenue', 'US'),
(9, 'CM_009', 'Federal Bank', '1618202224', 'Park Avenue', 'US'),
(10, 'CM_010', 'Liberty Bank', '2324252628', 'Broadway', 'US');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryID` varchar(45) NOT NULL,
  `categoryName` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryID`, `categoryName`) VALUES
('CT_001', 'Electronics'),
('CT_002', 'Fashion'),
('CT_003', 'Home and Kitchen'),
('CT_004', 'Beauty and Personal Care'),
('CT_005', 'Sports and Outdoors'),
('CT_006', 'Toys and Games'),
('CT_007', 'Automotive'),
('CT_008', 'Pet Supplies'),
('CT_009', 'Health and Wellness'),
('CT_010', 'Books and Stationery'),
('CT_011', 'Music and Movies'),
('CT_012', 'Food and Beverages'),
('CT_013', 'Jewelry and Accessories'),
('CT_014', 'Art and Crafts'),
('CT_015', 'Office Supplies');

--
-- Triggers `category`
--
DELIMITER $$
CREATE TRIGGER `category_autoID` BEFORE INSERT ON `category` FOR EACH ROW BEGIN  
SET @latestID=substring_index((SELECT categoryID from category order by categoryID desc limit 1),'_',-1);
IF (@latestID IS NOT NULL)
THEN
SET @NextID=CAST(@latestID AS unsigned)+1;
ELSE
SET @NextID=1;
END IF;
SET NEW.categoryID = CONCAT('CT_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `containeritems`
--

CREATE TABLE `containeritems` (
  `containerNumber` varchar(45) NOT NULL,
  `orderItemNumber` varchar(45) NOT NULL,
  `productID` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `containeritems`
--

INSERT INTO `containeritems` (`containerNumber`, `orderItemNumber`, `productID`, `quantity`) VALUES
('CN_002', 'OD_001', 'PD_001', 70),
('CN_001', 'OD_001', 'PD_002', 60),
('CN_010', 'OD_002', 'PD_004', 150),
('CN_003', 'OD_002', 'PD_003', 50),
('CN_004', 'OD_002', 'PD_004', 50),
('CN_005', 'OD_003', 'PD_005', 10),
('CN_005', 'OD_003', 'PD_006', 5),
('CN_007', 'OD_004', 'PD_008', 250),
('CN_007', 'OD_006', 'PD_011', 300),
('CN_009', 'OD_009', 'PD_012', 150),
('CN_009', 'OD_009', 'PD_016', 50),
('CN_007', 'OD_009', 'PD_016', 150),
('CN_008', 'OD_009', 'PD_017', 300);

--
-- Triggers `containeritems`
--
DELIMITER $$
CREATE TRIGGER `checkOrderItemQuantity` BEFORE INSERT ON `containeritems` FOR EACH ROW BEGIN
SET @orderitem=(Select quantity FROM orderitems WHERE productID=New.productID and orderID=new.orderItemNumber);

IF (New.quantity > @orderItem)
THEN
 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'More items than order needed';
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `checkOrderItemStock` BEFORE INSERT ON `containeritems` FOR EACH ROW BEGIN
SET @Stock=(Select enoughStock FROM orderitems WHERE productID=New.productID and orderID=new.orderItemNumber);

IF (@Stock ='No')
THEN
 SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Product does not have in stock';
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `containers`
--

CREATE TABLE `containers` (
  `containerID` varchar(45) NOT NULL,
  `containerTypeID` int(11) NOT NULL,
  `arrivalDate` date DEFAULT NULL,
  `transitDate` date DEFAULT NULL,
  `Location` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `containers`
--

INSERT INTO `containers` (`containerID`, `containerTypeID`, `arrivalDate`, `transitDate`, `Location`) VALUES
('CN_001', 5, '2023-08-22', '2023-08-15', 'on ship SP_002'),
('CN_002', 6, '2023-06-22', '2023-06-15', 'on ship SP_002'),
('CN_003', 5, '2023-07-07', '2023-07-03', 'on ship SP_003'),
('CN_004', 1, '2023-07-07', '2023-07-03', 'on ship SP_003'),
('CN_005', 3, '2023-08-04', '2023-07-31', 'on ship SP_004'),
('CN_006', 4, NULL, NULL, 'in warehouse'),
('CN_007', 2, NULL, NULL, 'in warehouse'),
('CN_008', 6, NULL, NULL, 'in warehouse'),
('CN_009', 2, NULL, NULL, 'at port P_001'),
('CN_010', 5, '2023-07-07', '2023-07-07', 'on ship SP_003');

--
-- Triggers `containers`
--
DELIMITER $$
CREATE TRIGGER `container_autoID` BEFORE INSERT ON `containers` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT containerID from containers order by containerID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.containerID = CONCAT('CN_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `containertype`
--

CREATE TABLE `containertype` (
  `typeID` int(11) NOT NULL,
  `containerType` text NOT NULL,
  `containerSize` varchar(45) NOT NULL,
  `typeQuantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `containertype`
--

INSERT INTO `containertype` (`typeID`, `containerType`, `containerSize`, `typeQuantity`) VALUES
(1, 'Standard', '20ft', 1000),
(2, 'high cube', '45ft', 800),
(3, 'open top', '20ft', 500),
(4, 'flat rack', '40ft', 400),
(5, 'reefer', '20ft', 700),
(6, 'reefer high cube', '40ft', 400);

-- --------------------------------------------------------

--
-- Table structure for table `creditcardinfo`
--

CREATE TABLE `creditcardinfo` (
  `customerID` varchar(45) NOT NULL,
  `cardNumber` varchar(45) NOT NULL,
  `cardHolderName` varchar(225) NOT NULL,
  `expireDate` date NOT NULL,
  `securityCode` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `creditcardinfo`
--

INSERT INTO `creditcardinfo` (`customerID`, `cardNumber`, `cardHolderName`, `expireDate`, `securityCode`) VALUES
('CM_012', '1234567890123456', 'Laura Miller', '2025-09-01', '123'),
('CM_013', '2345678901234567', 'Kevin Martinez', '2024-12-01', '456'),
('CM_014', '3456789012345678', 'Rachel Hernandez', '2023-06-01', '789'),
('CM_015', '4567890123456789', 'Brian Gonzalez', '2026-02-01', '234'),
('CM_010', '5678901234567890', 'Jessica Garcia', '2027-11-01', '567'),
('CM_016', '6789012345678901', 'Franka Tylier', '2028-08-01', '890'),
('CM_008', '7890123456789012', 'Karen Anderson', '2022-04-01', '123');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerID` varchar(45) NOT NULL,
  `firstName` varchar(45) NOT NULL,
  `lastName` varchar(45) NOT NULL,
  `billingAddress` text NOT NULL,
  `phoneNumber` varchar(90) NOT NULL,
  `country` varchar(45) NOT NULL,
  `zipCode` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerID`, `firstName`, `lastName`, `billingAddress`, `phoneNumber`, `country`, `zipCode`) VALUES
('CM_001', 'John', 'Doe', '123 Main St', '555-123-4567', 'AU', '12345'),
('CM_002', 'Jane', 'Smith', '456 Elm St', '555-234-5678', 'FR', '23456'),
('CM_003', 'Bob', 'Johnson', '789 Oak St', '555-345-6789', 'AU', '34567'),
('CM_004', 'Sarah', 'Williams', '321 Pine St', '555-456-7890', 'EG', '45678'),
('CM_005', 'Mark', 'Davis', '654 Maple St', '555-567-8901', 'ES', '56789'),
('CM_006', 'Emily', 'Wilson', '987 Cedar St', '555-678-9012', 'FR', '67890'),
('CM_007', 'David', 'Taylor', '246 Birch St', '555-789-0123', 'IN', '78901'),
('CM_008', 'Karen', 'Anderson', '369 Walnut St', '555-890-1234', 'IT', '89012'),
('CM_009', 'Steven', 'Brown', '802 Chestnut St', '555-901-2345', 'JP', '90123'),
('CM_010', 'Jessica', 'Garcia', '147 Sycamore St', '555-012-3456', 'MX', '01234'),
('CM_011', 'Michael', 'Jones', '258 Cherry St', '555-123-4567', 'RU', '12345'),
('CM_012', 'Laura', 'Miller', '369 Pineapple St', '555-234-5678', 'SE', '23456'),
('CM_013', 'Kevin', 'Martinez', '471 Orange St', '555-345-6789', 'TH', '34567'),
('CM_014', 'Rachel', 'Hernandez', '582 Banana St', '555-456-7890', 'UK', '45678'),
('CM_015', 'Brian', 'Gonzalez', '693 Grape St', '555-567-8901', 'ZA', '56789'),
('CM_016', 'Franka', 'Liskarm', '101 Atelier St', '555-0901-6401', 'ES', '46636');

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `customer_autoID` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT customerID from customer order by customerID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.customerID = CONCAT('CM_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `deliverycountries`
--

CREATE TABLE `deliverycountries` (
  `countryID` varchar(45) NOT NULL,
  `country` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `deliverycountries`
--

INSERT INTO `deliverycountries` (`countryID`, `country`) VALUES
('AU', 'Australia'),
('BR', 'Brazil'),
('CA', 'Canada'),
('EG', 'Egypt'),
('ES', 'Spain'),
('FR', 'France'),
('IN', 'India'),
('IT', 'Italy'),
('JP', 'Japan'),
('MX', 'Mexico'),
('RU', 'Russia'),
('SE', 'Sweden'),
('TH', 'Thailand'),
('UK', 'United Kingdom'),
('ZA', 'South Africa');

-- --------------------------------------------------------

--
-- Table structure for table `deliveryport`
--

CREATE TABLE `deliveryport` (
  `portID` varchar(45) NOT NULL,
  `portName` text NOT NULL,
  `country` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `deliveryport`
--

INSERT INTO `deliveryport` (`portID`, `portName`, `country`) VALUES
('P_001', 'Port of Durban', 'ZA'),
('P_002', 'Port of Le Havre', 'FR'),
('P_003', 'Port of Dunkirk', 'FR'),
('P_004', 'Laem Chabang Port', 'TH'),
('P_005', 'Port of Liverpool', 'UK'),
('P_006', 'Tokyo Port', 'JP'),
('P_007', 'Marseille Port', 'FR'),
('P_008', 'Port of Algeciras', 'ES'),
('P_009', 'Port Said East', 'EG'),
('P_010', 'Vladivostok Port', 'RU'),
('P_011', 'Port of Manzanillo', 'MX'),
('P_012', 'Felixstowe Port', 'UK'),
('P_013', 'Yokohama Port', 'JP'),
('P_014', 'Chennai Port', 'IN'),
('P_015', 'Valencia Port', 'ES'),
('P_016', 'Alexandria Port', 'EG'),
('P_017', 'Novorossiysk Port', 'RU'),
('P_018', 'Bangkok Port', 'TH'),
('P_019', 'Southampton Port', 'UK'),
('P_020', 'Kobe Port', 'JP'),
('P_021', 'Mundra Port', 'IN'),
('P_022', 'Barcelona Port', 'ES'),
('P_023', 'Damietta Port', 'EG'),
('P_024', 'Port of Melbourne', 'AU');

--
-- Triggers `deliveryport`
--
DELIMITER $$
CREATE TRIGGER `port_autoID` BEFORE INSERT ON `deliveryport` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT portID from deliveryport order by portID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.portID = CONCAT('P_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `landroute`
--

CREATE TABLE `landroute` (
  `landRouteID` int(45) NOT NULL,
  `truckID` varchar(45) NOT NULL,
  `originID` varchar(45) NOT NULL,
  `destinationID` varchar(45) NOT NULL,
  `distance` varchar(45) NOT NULL,
  `startingDate` date NOT NULL,
  `estimatedTravelDay` int(11) NOT NULL,
  `landTravelCost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `landroute`
--

INSERT INTO `landroute` (`landRouteID`, `truckID`, `originID`, `destinationID`, `distance`, `startingDate`, `estimatedTravelDay`, `landTravelCost`) VALUES
(1, 'TK_001', 'P_024', 'CM_001', '120', '2023-08-21', 2, 129),
(2, 'TK_002', 'P_002', 'CM_002', '342', '2023-07-04', 3, 456),
(3, 'TK_003', 'P_024', 'CM_003', '78', '2023-07-02', 1, 100),
(4, 'TK_004', 'P_004', 'P_018', '2000', '2023-08-06', 4, 567),
(5, 'TK_005', 'P_015', 'P_022', '321', '2023-07-02', 2, 215);

-- --------------------------------------------------------

--
-- Table structure for table `orderitems`
--

CREATE TABLE `orderitems` (
  `orderItemID` int(11) NOT NULL,
  `orderID` varchar(45) NOT NULL,
  `productID` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL,
  `enoughStock` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orderitems`
--

INSERT INTO `orderitems` (`orderItemID`, `orderID`, `productID`, `quantity`, `enoughStock`) VALUES
(3, 'OD_001', 'PD_001', 70, 'Yes'),
(4, 'OD_001', 'PD_002', 60, 'Yes'),
(5, 'OD_002', 'PD_003', 50, 'Yes'),
(6, 'OD_002', 'PD_004', 200, 'Yes'),
(7, 'OD_003', 'PD_005', 10, 'Yes'),
(8, 'OD_003', 'PD_006', 5, 'Yes'),
(9, 'OD_004', 'PD_008', 250, 'Yes'),
(10, 'OD_005', 'PD_009', 500, 'No'),
(11, 'OD_006', 'PD_011', 300, 'Yes'),
(12, 'OD_010', 'PD_017', 1200, 'No'),
(13, 'OD_009', 'PD_012', 150, 'Yes'),
(14, 'OD_009', 'PD_016', 200, 'Yes'),
(15, 'OD_009', 'PD_017', 300, 'Yes');

--
-- Triggers `orderitems`
--
DELIMITER $$
CREATE TRIGGER `checkQuantity` BEFORE INSERT ON `orderitems` FOR EACH ROW BEGIN
SET @quantity= (SELECT quantity FROM products WHERE productID= New.productID);
IF (New.quantity > @quantity)
THEN
SET New.enoughStock='No';
ELSE
Set New.enoughStock='Yes';
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `checkQuantityUpdate` BEFORE UPDATE ON `orderitems` FOR EACH ROW BEGIN
SET @quantity= (SELECT quantity FROM products WHERE productID= New.productID);
IF (New.quantity > @quantity)
THEN
SET New.enoughStock='No';
ELSE
Set New.enoughStock='Yes';
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `increaseQuantityAfterDelete` AFTER DELETE ON `orderitems` FOR EACH ROW BEGIN
IF (Old.enoughStock='Yes')
THEN
SET @oldQuantity=(Select quantity from products WHERE productID=Old.productID);

Set @NewQuantity=@oldQuantity+Old.quantity;

UPDATE products
SET quantity=@NewQuantity
WHERE productID=Old.productID;

END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reduceProductQuantity` AFTER INSERT ON `orderitems` FOR EACH ROW BEGIN
IF (New.enoughStock='Yes')
THEN
SET @oldQuantity=(Select quantity from products WHERE productID=New.productID);

Set @NewQuantity=@oldQuantity-New.quantity;

UPDATE products
SET quantity=@NewQuantity
WHERE productID=New.productID;

END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reduceProductQuantityUpdate` AFTER UPDATE ON `orderitems` FOR EACH ROW BEGIN
IF (New.enoughStock='Yes')
THEN
SET @oldQuantity=(Select quantity from products WHERE productID=New.productID);

Set @NewQuantity=@oldQuantity-New.quantity;

UPDATE products
SET quantity=@NewQuantity
WHERE productID=New.productID;

END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orderlist`
--

CREATE TABLE `orderlist` (
  `orderID` varchar(45) NOT NULL,
  `customer` varchar(45) NOT NULL,
  `orderDate` date NOT NULL,
  `requiredDate` date NOT NULL,
  `completedDate` date DEFAULT NULL,
  `status` text NOT NULL DEFAULT 'waiting for payment' COMMENT 'waiting for payment,paid,processing,transiting,completed',
  `paymentMode` varchar(45) NOT NULL COMMENT 'cash,bank,cards,paypal,none',
  `priority` varchar(45) NOT NULL DEFAULT 'normal' COMMENT 'normal,fast,same day shipping\n',
  `paymentDate` date DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 NOT NULL,
  `rating` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orderlist`
--

INSERT INTO `orderlist` (`orderID`, `customer`, `orderDate`, `requiredDate`, `completedDate`, `status`, `paymentMode`, `priority`, `paymentDate`, `comment`, `rating`) VALUES
('OD_001', 'CM_001', '2023-08-10', '2023-08-24', NULL, 'transiting', 'CASH', 'normal', '2023-08-09', '', NULL),
('OD_002', 'CM_002', '2023-07-01', '2023-07-08', NULL, 'transiting', 'bank transfer', 'high', '2023-08-08', '', NULL),
('OD_003', 'CM_003', '2023-06-30', '2023-07-03', NULL, 'transiting', 'bank transfer', 'very high', '2023-06-30', '', NULL),
('OD_004', 'CM_016', '2023-07-01', '2023-08-07', NULL, 'processing', 'PayPal', 'normal', '2023-07-01', '', NULL),
('OD_005', 'CM_005', '2023-09-09', '2023-09-27', NULL, 'processing', 'bank transfer', 'normal', '2023-09-10', '', NULL),
('OD_006', 'CM_015', '2023-07-14', '2023-07-18', NULL, 'processing', 'PayPal', 'normal', '2023-07-16', '', NULL),
('OD_007', 'CM_012', '2023-06-12', '2023-06-15', '2023-06-15', 'completed', 'credit card', 'very high', '2023-06-12', 'Excellent service, package remains whole when delivered', 5),
('OD_008', 'CM_004', '2023-05-10', '2023-06-09', '2023-06-09', 'completed', 'CASH', 'normal', '2023-05-06', 'Package is safe when delivered, service is somewhat slow', 4),
('OD_009', 'CM_013', '2023-08-06', '2023-08-13', NULL, 'transiting', 'credit card', 'high', '2023-06-15', '', NULL),
('OD_010', 'CM_007', '2023-08-10', '2023-08-24', NULL, 'waiting for payment', '', 'normal', NULL, '', NULL),
('OD_011', 'CM_013', '2023-05-11', '2023-06-01', '2023-06-02', 'completed', 'credit card', 'high', '2023-06-11', 'service deliver slower than the required date', 2),
('OD_012', 'CM_012', '2023-04-05', '2023-05-13', '2023-05-11', 'completed', 'credit card', 'normal', '2023-04-05', 'Company delivered on time, products are in good condition ', 5),
('OD_013', 'CM_011', '2023-03-01', '2023-03-12', '2023-03-11', 'completed', 'credit card', 'very high', '2023-03-12', 'Goods are delivered early however the wrapping is not careful', 4),
('OD_014', 'CM_009', '2023-05-11', '2023-05-18', '2023-05-18', 'completed', 'CASH', 'normal', '2023-05-13', 'delivered on time however the products did not look like the advertised image', 4);

--
-- Triggers `orderlist`
--
DELIMITER $$
CREATE TRIGGER `order_autoID` BEFORE INSERT ON `orderlist` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT orderID from orderlist order by orderID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.orderID = CONCAT('OD_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `paypalinfo`
--

CREATE TABLE `paypalinfo` (
  `customerID` varchar(45) NOT NULL,
  `paypalEmail` varchar(90) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `paypalinfo`
--

INSERT INTO `paypalinfo` (`customerID`, `paypalEmail`) VALUES
('CM_001', 'jonh.paypal@gmail.com'),
('CM_002', 'jane.paypal@gmail.com'),
('CM_014', 'rachel.paypal@gmail.com'),
('CM_015', 'brian.paypal@gmail.com'),
('CM_016', 'franka.paypal@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `productID` varchar(45) NOT NULL,
  `productName` varchar(225) NOT NULL,
  `vendorID` varchar(225) NOT NULL,
  `categoryID` varchar(45) NOT NULL,
  `pricePerUnit` float NOT NULL,
  `description` text NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`productID`, `productName`, `vendorID`, `categoryID`, `pricePerUnit`, `description`, `quantity`) VALUES
('PD_001', 'Lipitor', 'VD_001', 'CT_009', 20, 'a medication used to lower cholesterol levels in the blood', 100),
('PD_002', 'Advair Diskus', 'VD_001', 'CT_009', 40, 'a medication used to treat asthma and chronic obstructive pulmonary disease', 90),
('PD_003', 'Humira', 'VD_001', 'CT_009', 50, 'a medication used to treat autoimmune diseases like rheumatoid arthritis and Crohn disease', 80),
('PD_004', 'Paper clips', 'VD_003', 'CT_015', 1, 'Paper clips are small, thin wire or plastic clips that are used to hold sheets of paper together', 300),
('PD_005', 'Desk organizer', 'VD_004', 'CT_015', 5, 'A desk organizer is a container or tray designed to keep office supplies organized and easily accessible', 240),
('PD_006', 'The Necronomicon', 'VD_002', 'CT_010', 100, 'The book is said to contain knowledge and rituals for summoning powerful supernatural entities known as the Old Ones', 10),
('PD_007', 'Frankenstein', 'VD_002', 'CT_010', 20, 'this Gothic horror novel tells the story of Victor Frankenstein, a young scientist who creates a sapient creature in an unorthodox scientific experiment', 90),
('PD_008', 'Michelin Pilot Sport 4S Tires', 'VD_004', 'CT_007', 900, 'These high-performance tires are designed for sports cars and provide excellent handling and control on both wet and dry roads', 150),
('PD_009', 'Hyperion VR Headset', 'VD_005', 'CT_001', 799, 'This advanced virtual reality headset provides an immersive experience with stunning visuals and realistic sound. It has a high-resolution display, built-in surround sound speakers, and haptic feedback for enhanced tactile sensations', 250),
('PD_010', 'Lumina Shoes', 'VD_006', 'CT_002', 599, 'These high-end shoes are made from the finest materials and feature a unique design that incorporates advanced LED technology', 500),
('PD_011', 'Apollo Smart Kitchen Hub', 'VD_008', 'CT_004', 799, 'This state-of-the-art device is the ultimate kitchen assistant, featuring a large touchscreen display that allows you to access recipes, stream cooking videos, and control your smart home devices all in one place', 200),
('PD_012', 'M314 Motion Tracker', 'VD_018', 'CT_001', 1200, 'The M314 Motion Tracker is a handheld device used by the Colonial Marines to detect movement in their vicinity. It emits a radar signal that bounces off of nearby objects and displays their location on a small screen', 150),
('PD_013', 'HydraGlow Facial Oil', 'VD_007', 'CT_004', 30, 'This facial oil is infused with nourishing ingredients such as vitamin E, jojoba oil, and rosehip oil to help hydrate and brighten the skin', 100),
('PD_014', 'Portable Camping Hammock', 'VD_009', 'CT_005', 40, 'This durable and lightweight hammock is perfect for camping or backyard lounging. It is made of parachute nylon and can support up to 400 pounds', 50),
('PD_015', 'Cat Condo Tree', 'VD_010', 'CT_008', 100, 'This multi-level cat condo tree provides a cozy and fun space for your feline friend to climb, play and nap', 300),
('PD_016', 'LEGO Star Wars Millennium Falcon Building Kit', 'VD_011', 'CT_006', 149.99, 'This kit includes over 1,300 pieces that allow you to build your very own Millennium Falcon spaceship from the Star Wars universe', 500),
('PD_017', 'Gourmet Chocolates Assortment', 'VD_012', 'CT_012', 39.99, ' Each chocolate is handmade using premium ingredients, and the flavors range from classic milk chocolate to unique combinations like raspberry truffle and salted caramel', 1000),
('PD_018', 'The Lord of the Rings Trilogy Blu-Ray Set', 'VD_013', 'CT_011', 49.99, 'ollow Frodo and his companions as they journey through Middle Earth to destroy the One Ring and defeat the evil Sauron. Bonus features include behind-the-scenes content and audio commentaries', 235),
('PD_019', 'Sterling Silver Rose Quartz Pendant Necklace', 'VD_011', 'CT_013', 79.99, 'This elegant necklace features a teardrop-shaped rose quartz stone set in a sterling silver pendant', 148),
('PD_020', 'Abstract Oil Painting on Canvas', 'VD_014', 'CT_014', 299.99, 'This beautiful painting features vibrant colors and bold brushstrokes, creating a dynamic and eye-catching work of art', 59);

--
-- Triggers `products`
--
DELIMITER $$
CREATE TRIGGER `product_autoID` BEFORE INSERT ON `products` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT productID from products order by productID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.productID = CONCAT('PD_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `searoute`
--

CREATE TABLE `searoute` (
  `routeID` int(45) NOT NULL,
  `shipOnRoute` varchar(45) NOT NULL,
  `originPort` varchar(45) NOT NULL,
  `destinationPort` varchar(45) NOT NULL,
  `distance` int(11) NOT NULL,
  `estimatedTime` int(12) NOT NULL,
  `cost` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `searoute`
--

INSERT INTO `searoute` (`routeID`, `shipOnRoute`, `originPort`, `destinationPort`, `distance`, `estimatedTime`, `cost`) VALUES
(1, 'SP_002', 'P_013', 'P_024', 9078, 5, 18904),
(2, 'SP_003', 'P_008', 'P_007', 9876, 4, 12006),
(3, 'SP_004', 'P_008', 'P_024', 15000, 6, 20000),
(4, 'SP_007', 'P_013', 'P_005', 15000, 7, 21000),
(5, 'SP_008', 'P_011', 'P_002', 14999, 10, 18756),
(6, 'SP_009', 'P_010', 'P_021', 13456, 12, 35924),
(7, 'SP_010', 'P_012', 'P_019', 5000, 2, 7906);

-- --------------------------------------------------------

--
-- Table structure for table `ship`
--

CREATE TABLE `ship` (
  `shipID` varchar(45) NOT NULL,
  `shipName` text NOT NULL,
  `type` int(11) NOT NULL,
  `yearOfRegistration` year(4) NOT NULL,
  `portOfRegistry` varchar(45) DEFAULT NULL,
  `status` text NOT NULL,
  `lastKnownPort` varchar(45) DEFAULT NULL,
  `currentLocation` text NOT NULL,
  `licensePlateNum` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ship`
--

INSERT INTO `ship` (`shipID`, `shipName`, `type`, `yearOfRegistration`, `portOfRegistry`, `status`, `lastKnownPort`, `currentLocation`, `licensePlateNum`) VALUES
('SP_001', 'Contact Light', 1, 2010, 'P_004', 'maintaining', 'P_006', 'Tokyo Port', 'XJH-9524'),
('SP_002', 'Safe Travel', 6, 2015, 'P_012', 'transiting', 'P_013', '25.023501927857° N   -22.890308544114° W', 'KLM-8306'),
('SP_003', 'Speed of Light', 2, 2005, 'P_001', 'transiting', 'P_008', '8.492878292067° N   -48.328994718896° W', 'QRS-1754'),
('SP_004', 'Oceanic Odyssey', 1, 2010, 'P_002', 'transiting', 'P_008', '42.065822892078° N   147.506621208449° W', 'MNO-4985'),
('SP_005', 'Crimson Voyager', 4, 2006, 'P_003', 'loading goods at port', 'P_016', 'Alexandra Port', 'UVW-6721'),
('SP_006', 'Starlight Sentinel', 5, 2007, 'P_011', 'maintaining', 'P_004', 'Laem Chabang Port', 'PQR-3659'),
('SP_007', 'Solar Serenade', 3, 2004, 'P_007', 'transiting', 'P_013', '-67.888826909523° N   -99.472947552871° W', 'STU-2378'),
('SP_008', 'Galactic Galleon', 2, 1990, 'P_023', 'transiting', 'P_011', '-70.087007330887° N   64.499185592042° W\r\n', 'ABC-6194'),
('SP_009', 'Celestial Cruiser', 6, 2012, 'P_017', 'transiting', 'P_010', '-28.378616092275° N   -156.057115306619° W', 'DEF-7832'),
('SP_010', 'Aquatic Adventure', 1, 2016, 'P_020', 'transiting', 'P_012', '-63.283204959476° N   123.221047388956° W', 'GHI-5403');

--
-- Triggers `ship`
--
DELIMITER $$
CREATE TRIGGER `ship_autoID` BEFORE INSERT ON `ship` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT shipID from ship order by shipID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.shipID = CONCAT('SP_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shipcontainer`
--

CREATE TABLE `shipcontainer` (
  `shipID` varchar(45) CHARACTER SET utf8 NOT NULL,
  `containerID` varchar(45) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shipcontainer`
--

INSERT INTO `shipcontainer` (`shipID`, `containerID`) VALUES
('SP_002', 'CN_001'),
('SP_002', 'CN_002'),
('SP_003', 'CN_003'),
('SP_003', 'CN_004'),
('SP_003', 'CN_010'),
('SP_004', 'CN_005');

-- --------------------------------------------------------

--
-- Table structure for table `shiptype`
--

CREATE TABLE `shiptype` (
  `shipTypeID` int(11) NOT NULL,
  `shipType` text NOT NULL,
  `shipDescription` text NOT NULL,
  `quantity` int(11) NOT NULL,
  `gasMillage` int(11) NOT NULL,
  `capacity` varchar(45) NOT NULL,
  `length` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `shiptype`
--

INSERT INTO `shiptype` (`shipTypeID`, `shipType`, `shipDescription`, `quantity`, `gasMillage`, `capacity`, `length`) VALUES
(1, 'Container Ship', 'A large cargo ship designed to carry shipping containers', 100, 1200, '10,000 TEU', 400),
(2, 'Bulk Carrier', 'A cargo vessel used to transport bulk goods such as coal, iron ore, and grain', 70, 800, '200,000 DWT', 300),
(3, 'Ro-Ro (Roll-on/Roll-off)', 'A type of vessel designed to carry wheeled cargo such as cars, trucks, and trailers', 70, 600, '6,000 lane meters', 250),
(4, 'LNG Carrier', 'A specialized tanker designed to transport liquefied natural gas', 90, 1000, '266,000 cubic meters', 300),
(5, 'Oil Tanker', 'A large vessel designed to transport crude oil and refined petroleum products', 50, 200, '2 million barrels', 330),
(6, 'Reefer ship', 'a reefrigated ship used to transport perishable cargo', 80, 800, '200,000 sq ft', 450);

-- --------------------------------------------------------

--
-- Table structure for table `truck`
--

CREATE TABLE `truck` (
  `truckID` varchar(45) NOT NULL,
  `truckType` int(11) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'idle' COMMENT 'idle,transiting,returning',
  `licensePlateNum` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `truck`
--

INSERT INTO `truck` (`truckID`, `truckType`, `status`, `licensePlateNum`) VALUES
('TK_001', 4, 'transiting', 'TCK-8592'),
('TK_002', 1, 'transiting', 'FRG-1275'),
('TK_003', 3, 'transiting', 'BLM-4806'),
('TK_004', 6, 'transiting', 'JNS-6324'),
('TK_005', 5, 'transiting', 'MDT-7913'),
('TK_006', 4, 'transiting', 'KPR-9430'),
('TK_007', 1, 'maintaining', 'GTR-5082');

--
-- Triggers `truck`
--
DELIMITER $$
CREATE TRIGGER `truck_autoID` BEFORE INSERT ON `truck` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT truckID from truck order by truckID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.truckID = CONCAT('TK_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `truckitems`
--

CREATE TABLE `truckitems` (
  `truckID` varchar(45) NOT NULL,
  `orderItemsID` varchar(45) NOT NULL,
  `productID` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `truckitems`
--

INSERT INTO `truckitems` (`truckID`, `orderItemsID`, `productID`, `quantity`) VALUES
('TK_001', 'OD_001', 'PD_001', 50),
('TK_001', 'OD_001', 'PD_002', 30),
('TK_001', 'OD_002', 'PD_003', 25),
('TK_002', 'OD_002', 'PD_017', 30),
('TK_003', 'OD_003', 'PD_005', 10),
('TK_003', 'OD_003', 'PD_006', 5),
('TK_004', 'OD_009', 'PD_012', 75),
('TK_004', 'OD_009', 'PD_016', 25),
('TK_005', 'OD_009', 'PD_017', 100);

-- --------------------------------------------------------

--
-- Table structure for table `trucktype`
--

CREATE TABLE `trucktype` (
  `typeID` int(11) NOT NULL,
  `typeName` varchar(45) NOT NULL,
  `quantity` int(11) NOT NULL,
  `gasMillage` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `trucktype`
--

INSERT INTO `trucktype` (`typeID`, `typeName`, `quantity`, `gasMillage`) VALUES
(1, 'semi-trailer truck', 300, 75),
(2, 'flatbed truck', 150, 70),
(3, 'open top', 200, 80),
(4, 'refrigated truck', 200, 90),
(5, 'tanker truck', 250, 80),
(6, 'dump truck', 100, 75);

-- --------------------------------------------------------

--
-- Table structure for table `vendor`
--

CREATE TABLE `vendor` (
  `vendorID` varchar(45) NOT NULL,
  `vendorName` varchar(90) NOT NULL,
  `vendorNumber` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `vendor`
--

INSERT INTO `vendor` (`vendorID`, `vendorName`, `vendorNumber`) VALUES
('VD_001', 'Rhodes Island Pharmateucials', '555-160-1202'),
('VD_002', 'Mysterious Bookstore', '555-666-6666'),
('VD_003', 'Alpha Supplies', '555-123-4567'),
('VD_004', 'Beta Distributors', '555-234-5678'),
('VD_005', 'Gamma Enterprises', '555-345-6789'),
('VD_006', 'Delta Trading Co.', '555-456-7890'),
('VD_007', 'Epsilon Imports', '555-567-8901'),
('VD_008', 'Zeta Industries', '555-678-9012'),
('VD_009', 'Eta Supplies Inc.', '555-789-0123'),
('VD_010', 'Theta Distributors LLC', '555-890-1234'),
('VD_011', 'Iota Enterprises Corp', '555-901-2345'),
('VD_012', 'Kappa Trading Company', '555-012-3456'),
('VD_013', 'Lambda Imports & Exports', '555-123-4567'),
('VD_014', 'Mu Industries', '555-234-5678'),
('VD_015', 'Nu Supplies Inc.', '555-345-6789'),
('VD_016', 'Xi Distributors LLC', '555-456-7890'),
('VD_017', 'Omicron Trading Company', '555-567-8901'),
('VD_018', 'Weiland-Yutani Corp', '555-060-9979');

--
-- Triggers `vendor`
--
DELIMITER $$
CREATE TRIGGER `vendor_autoID` BEFORE INSERT ON `vendor` FOR EACH ROW BEGIN
SET @latestID=substring_index((SELECT vendorID from vendor order by vendorID desc limit 1),'_',-1);
IF (@latestID IS NULL)
THEN
SET @latestID=0;
END IF;
SET @NextID=CAST(@latestID AS unsigned)+1;

  SET NEW.vendorID = CONCAT('VD_', LPAD(@NextID, 3, '0'));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_a`
-- (See below for the actual view)
--
CREATE TABLE `view_a` (
`clientNum` bigint(21)
,`productID` varchar(45)
,`totalClientNum` bigint(21)
,`percentage` decimal(26,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_b`
-- (See below for the actual view)
--
CREATE TABLE `view_b` (
`country` varchar(45)
,`clientNumber` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_c`
-- (See below for the actual view)
--
CREATE TABLE `view_c` (
`requestDate` date
,`orderCount` bigint(21)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_d`
-- (See below for the actual view)
--
CREATE TABLE `view_d` (
`productID` varchar(45)
,`productName` varchar(225)
,`total_InternationalSale` decimal(32,0)
,`country` varchar(45)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_e`
-- (See below for the actual view)
--
CREATE TABLE `view_e` (
`averageOrderInContainer` decimal(23,2)
,`averageOrderPrice` double(19,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_f_latest5RouteStat`
-- (See below for the actual view)
--
CREATE TABLE `view_f_latest5RouteStat` (
`averageSeaDistance` decimal(13,2)
,`averageSeaTravelDays` decimal(14,2)
,`averageSeaRouteCost` double(19,2)
,`averageLandDistance` double(19,2)
,`averageLandTravelDays` decimal(13,2)
,`averageLandRouteCost` decimal(13,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_g_latest10Rating`
-- (See below for the actual view)
--
CREATE TABLE `view_g_latest10Rating` (
`rating` int(11)
,`rateAmount` bigint(21)
,`averageRate` decimal(13,2)
);

-- --------------------------------------------------------

--
-- Structure for view `view_a`
--
DROP TABLE IF EXISTS `view_a`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_a`  AS SELECT count(`customer`.`firstName`) AS `clientNum`, `orderitems`.`productID` AS `productID`, (select count(0) from `customer`) AS `totalClientNum`, round(count(`customer`.`firstName`) / (select count(0) from `customer`) * 100,2) AS `percentage` FROM ((`customer` join `orderlist` on(`customer`.`customerID` = `orderlist`.`customer`)) join `orderitems` on(`orderitems`.`orderID` = `orderlist`.`orderID`)) GROUP BY `orderitems`.`productID` HAVING `orderitems`.`productID` = 'PD_016''PD_016'  ;

-- --------------------------------------------------------

--
-- Structure for view `view_b`
--
DROP TABLE IF EXISTS `view_b`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_b`  AS SELECT `deliverycountries`.`country` AS `country`, count(0) AS `clientNumber` FROM (`customer` join `deliverycountries` on(`customer`.`country` = `deliverycountries`.`countryID`)) GROUP BY `deliverycountries`.`country` HAVING `clientNumber` <= all (select count(0) AS `clientNumber` from (`customer` join `deliverycountries` on(`customer`.`country` = `deliverycountries`.`countryID`)) group by `customer`.`country`)  ;

-- --------------------------------------------------------

--
-- Structure for view `view_c`
--
DROP TABLE IF EXISTS `view_c`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_c`  AS SELECT cast(`orderlist`.`requiredDate` as date) AS `requestDate`, count(0) AS `orderCount` FROM `orderlist` GROUP BY cast(`orderlist`.`requiredDate` as date) HAVING `orderCount` >= all (select count(0) AS `orderCount` from `orderlist` group by `orderlist`.`requiredDate`)  ;

-- --------------------------------------------------------

--
-- Structure for view `view_d`
--
DROP TABLE IF EXISTS `view_d`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_d`  AS SELECT `highestSale`.`productID` AS `productID`, `p`.`productName` AS `productName`, `highestSale`.`total_InternationalSale` AS `total_InternationalSale`, `d`.`country` AS `country` FROM (((((((select `orderitems`.`productID` AS `productID`,sum(`orderitems`.`quantity`) AS `total_InternationalSale` from `orderitems` group by `orderitems`.`productID` having `total_InternationalSale` >= all (select sum(`orderitems`.`quantity`) from `orderitems` group by `orderitems`.`productID`))) `highestSale` join `orderitems` on(`orderitems`.`productID` = `highestSale`.`productID`)) join `orderlist` on(`orderlist`.`orderID` = `orderitems`.`orderID`)) join `customer` on(`orderlist`.`customer` = `customer`.`customerID`)) join `deliverycountries` `d` on(`d`.`countryID` = `customer`.`country`)) join `products` `p` on(`p`.`productID` = `highestSale`.`productID`))  ;

-- --------------------------------------------------------

--
-- Structure for view `view_e`
--
DROP TABLE IF EXISTS `view_e`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_e`  AS SELECT `orderInContainer`.`averageOrderInContainer` AS `averageOrderInContainer`, `orderPrice`.`averageOrderPrice` AS `averageOrderPrice` FROM ((select round(avg(`totalOrder`.`orderNum`),2) AS `averageOrderInContainer` from (select count(`containeritems`.`orderItemNumber`) AS `orderNum` from `containeritems` group by `containeritems`.`containerNumber`) `totalOrder`) `orderInContainer` join (select round(avg(`totalOrderCost`.`total`),2) AS `averageOrderPrice` from (select sum(`o1`.`quantity` * `p`.`pricePerUnit`) AS `total` from ((`orderlist` `o2` join `orderitems` `o1` on(`o1`.`orderID` = `o2`.`orderID`)) join `products` `p` on(`o1`.`productID` = `p`.`productID`)) group by `o2`.`orderID`) `totalOrderCost`) `orderPrice`)  ;

-- --------------------------------------------------------

--
-- Structure for view `view_f_latest5RouteStat`
--
DROP TABLE IF EXISTS `view_f_latest5RouteStat`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_f_latest5RouteStat`  AS SELECT `averageLatest5SeaRouteStat`.`averageSeaDistance` AS `averageSeaDistance`, `averageLatest5SeaRouteStat`.`averageSeaTravelDays` AS `averageSeaTravelDays`, `averageLatest5SeaRouteStat`.`averageSeaRouteCost` AS `averageSeaRouteCost`, `latest5LandRouteStat`.`averageLandDistance` AS `averageLandDistance`, `latest5LandRouteStat`.`averageLandTravelDays` AS `averageLandTravelDays`, `latest5LandRouteStat`.`averageLandRouteCost` AS `averageLandRouteCost` FROM ((select round(avg(`latest5Route`.`distance`),2) AS `averageSeaDistance`,round(avg(`latest5Route`.`estimatedTime`),2) AS `averageSeaTravelDays`,round(avg(`latest5Route`.`cost`),2) AS `averageSeaRouteCost` from (select `searoute`.`routeID` AS `routeID`,`searoute`.`distance` AS `distance`,`searoute`.`estimatedTime` AS `estimatedTime`,`searoute`.`cost` AS `cost` from `searoute` limit 5) `latest5Route`) `averageLatest5SeaRouteStat` join (select round(avg(`latest5Route`.`distance`),2) AS `averageLandDistance`,round(avg(`latest5Route`.`estimatedTravelDay`),2) AS `averageLandTravelDays`,round(avg(`latest5Route`.`landTravelCost`),2) AS `averageLandRouteCost` from (select `landroute`.`distance` AS `distance`,`landroute`.`estimatedTravelDay` AS `estimatedTravelDay`,`landroute`.`landTravelCost` AS `landTravelCost` from `landroute` limit 5) `latest5Route`) `latest5LandRouteStat`)  ;

-- --------------------------------------------------------

--
-- Structure for view `view_g_latest10Rating`
--
DROP TABLE IF EXISTS `view_g_latest10Rating`;

CREATE ALGORITHM=UNDEFINED DEFINER=`HAN21080174`@`%` SQL SECURITY DEFINER VIEW `view_g_latest10Rating`  AS SELECT `orderlist`.`rating` AS `rating`, count(`orderlist`.`rating`) AS `rateAmount`, `averageRating`.`averageRate` AS `averageRate` FROM (`orderlist` join (select round(avg(`orderlist`.`rating`),2) AS `averageRate` from `orderlist`) `averageRating`) WHERE `orderlist`.`status` = 'completed' GROUP BY `orderlist`.`rating` LIMIT 0, 1010  ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bankAccountInfo`
--
ALTER TABLE `bankAccountInfo`
  ADD PRIMARY KEY (`bankAccountID`),
  ADD KEY `fk_customerIDforBank` (`customerID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryID`);

--
-- Indexes for table `containeritems`
--
ALTER TABLE `containeritems`
  ADD KEY `fk_containerID` (`containerNumber`),
  ADD KEY `fk_containerProductID` (`productID`),
  ADD KEY `fk_orderID_idx` (`orderItemNumber`);

--
-- Indexes for table `containers`
--
ALTER TABLE `containers`
  ADD PRIMARY KEY (`containerID`),
  ADD KEY `fk_type_idx` (`containerTypeID`);

--
-- Indexes for table `containertype`
--
ALTER TABLE `containertype`
  ADD PRIMARY KEY (`typeID`);

--
-- Indexes for table `creditcardinfo`
--
ALTER TABLE `creditcardinfo`
  ADD PRIMARY KEY (`cardNumber`),
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerID`),
  ADD KEY `fk_country_idx` (`country`);

--
-- Indexes for table `deliverycountries`
--
ALTER TABLE `deliverycountries`
  ADD PRIMARY KEY (`countryID`);

--
-- Indexes for table `deliveryport`
--
ALTER TABLE `deliveryport`
  ADD PRIMARY KEY (`portID`),
  ADD KEY `fk_country_idx` (`country`);

--
-- Indexes for table `landroute`
--
ALTER TABLE `landroute`
  ADD PRIMARY KEY (`landRouteID`),
  ADD KEY `fk_truckID_idx` (`truckID`),
  ADD KEY `fk_portID_idx` (`originID`),
  ADD KEY `fk_destinationPortID_idx` (`destinationID`);

--
-- Indexes for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD PRIMARY KEY (`orderItemID`),
  ADD KEY `fk_productID` (`productID`),
  ADD KEY `fk_orderID_idx` (`orderID`);

--
-- Indexes for table `orderlist`
--
ALTER TABLE `orderlist`
  ADD PRIMARY KEY (`orderID`),
  ADD KEY `fk_customerOrderID` (`customer`);

--
-- Indexes for table `paypalinfo`
--
ALTER TABLE `paypalinfo`
  ADD PRIMARY KEY (`paypalEmail`),
  ADD KEY `fk_customerPayPalID` (`customerID`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`productID`),
  ADD KEY `fk_vendorID` (`vendorID`),
  ADD KEY `fk_categoryID` (`categoryID`);

--
-- Indexes for table `searoute`
--
ALTER TABLE `searoute`
  ADD PRIMARY KEY (`routeID`),
  ADD KEY `fk_routeShipID` (`shipOnRoute`),
  ADD KEY `fk_originPort` (`originPort`),
  ADD KEY `fk_destinationPort` (`destinationPort`);

--
-- Indexes for table `ship`
--
ALTER TABLE `ship`
  ADD PRIMARY KEY (`shipID`),
  ADD UNIQUE KEY `licensePlateNum` (`licensePlateNum`),
  ADD KEY `fk_portID` (`portOfRegistry`),
  ADD KEY `fk_lastPortID` (`lastKnownPort`),
  ADD KEY `fk_shipType_idx` (`type`);

--
-- Indexes for table `shipcontainer`
--
ALTER TABLE `shipcontainer`
  ADD KEY `fk_shipContainer_shipID` (`shipID`),
  ADD KEY `fk_shipContainer_containerID` (`containerID`);

--
-- Indexes for table `shiptype`
--
ALTER TABLE `shiptype`
  ADD PRIMARY KEY (`shipTypeID`);

--
-- Indexes for table `truck`
--
ALTER TABLE `truck`
  ADD PRIMARY KEY (`truckID`),
  ADD KEY `fk_truckType_idx` (`truckType`);

--
-- Indexes for table `truckitems`
--
ALTER TABLE `truckitems`
  ADD KEY `fk_productID_idx` (`productID`),
  ADD KEY `fk_orderItemsID_idx` (`orderItemsID`),
  ADD KEY `fk_truckID` (`truckID`);

--
-- Indexes for table `trucktype`
--
ALTER TABLE `trucktype`
  ADD PRIMARY KEY (`typeID`);

--
-- Indexes for table `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`vendorID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bankAccountInfo`
--
ALTER TABLE `bankAccountInfo`
  MODIFY `bankAccountID` int(45) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `containertype`
--
ALTER TABLE `containertype`
  MODIFY `typeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `landroute`
--
ALTER TABLE `landroute`
  MODIFY `landRouteID` int(45) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orderitems`
--
ALTER TABLE `orderitems`
  MODIFY `orderItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `searoute`
--
ALTER TABLE `searoute`
  MODIFY `routeID` int(45) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `shiptype`
--
ALTER TABLE `shiptype`
  MODIFY `shipTypeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `trucktype`
--
ALTER TABLE `trucktype`
  MODIFY `typeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bankAccountInfo`
--
ALTER TABLE `bankAccountInfo`
  ADD CONSTRAINT `fk_customerIDforBank` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `containeritems`
--
ALTER TABLE `containeritems`
  ADD CONSTRAINT `fk_containerID` FOREIGN KEY (`containerNumber`) REFERENCES `containers` (`containerID`),
  ADD CONSTRAINT `fk_containerItemID` FOREIGN KEY (`orderItemNumber`) REFERENCES `orderitems` (`orderID`),
  ADD CONSTRAINT `fk_containerProductID` FOREIGN KEY (`productID`) REFERENCES `orderitems` (`productID`);

--
-- Constraints for table `containers`
--
ALTER TABLE `containers`
  ADD CONSTRAINT `fk_type` FOREIGN KEY (`containerTypeID`) REFERENCES `containertype` (`typeID`);

--
-- Constraints for table `creditcardinfo`
--
ALTER TABLE `creditcardinfo`
  ADD CONSTRAINT FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `customer`
--
ALTER TABLE `customer`
  ADD CONSTRAINT `fk_country` FOREIGN KEY (`country`) REFERENCES `deliverycountries` (`countryID`);

--
-- Constraints for table `deliveryport`
--
ALTER TABLE `deliveryport`
  ADD CONSTRAINT `fk_portCountry` FOREIGN KEY (`country`) REFERENCES `deliverycountries` (`countryID`);

--
-- Constraints for table `landroute`
--
ALTER TABLE `landroute`
  ADD CONSTRAINT `fk_routetruckID` FOREIGN KEY (`truckID`) REFERENCES `truck` (`truckID`);

--
-- Constraints for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD CONSTRAINT `fk_orderID` FOREIGN KEY (`orderID`) REFERENCES `orderlist` (`orderID`),
  ADD CONSTRAINT `fk_productID` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`);

--
-- Constraints for table `orderlist`
--
ALTER TABLE `orderlist`
  ADD CONSTRAINT `fk_customerOrderID` FOREIGN KEY (`customer`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `paypalinfo`
--
ALTER TABLE `paypalinfo`
  ADD CONSTRAINT `fk_customerPayPalID` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customerID`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_categoryID` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`),
  ADD CONSTRAINT `fk_vendorID` FOREIGN KEY (`vendorID`) REFERENCES `vendor` (`vendorID`);

--
-- Constraints for table `searoute`
--
ALTER TABLE `searoute`
  ADD CONSTRAINT `fk_destinationPort` FOREIGN KEY (`destinationPort`) REFERENCES `deliveryport` (`portID`),
  ADD CONSTRAINT `fk_originPort` FOREIGN KEY (`originPort`) REFERENCES `deliveryport` (`portID`),
  ADD CONSTRAINT `fk_routeShipID` FOREIGN KEY (`shipOnRoute`) REFERENCES `ship` (`shipID`);

--
-- Constraints for table `ship`
--
ALTER TABLE `ship`
  ADD CONSTRAINT `fk_lastPortID` FOREIGN KEY (`lastKnownPort`) REFERENCES `deliveryport` (`portID`),
  ADD CONSTRAINT `fk_portID` FOREIGN KEY (`portOfRegistry`) REFERENCES `deliveryport` (`portID`),
  ADD CONSTRAINT `fk_shipType` FOREIGN KEY (`type`) REFERENCES `shiptype` (`shipTypeID`);

--
-- Constraints for table `shipcontainer`
--
ALTER TABLE `shipcontainer`
  ADD CONSTRAINT `fk_shipContainer_containerID` FOREIGN KEY (`containerID`) REFERENCES `containers` (`containerID`),
  ADD CONSTRAINT `fk_shipContainer_shipID` FOREIGN KEY (`shipID`) REFERENCES `ship` (`shipID`);

--
-- Constraints for table `truck`
--
ALTER TABLE `truck`
  ADD CONSTRAINT `fk_truckType` FOREIGN KEY (`truckType`) REFERENCES `trucktype` (`typeID`);

--
-- Constraints for table `truckitems`
--
ALTER TABLE `truckitems`
  ADD CONSTRAINT `fk_truckID` FOREIGN KEY (`truckID`) REFERENCES `truck` (`truckID`),
  ADD CONSTRAINT `fk_truckOrderItemsID` FOREIGN KEY (`orderItemsID`) REFERENCES `orderitems` (`orderID`),
  ADD CONSTRAINT `fk_truckProductID` FOREIGN KEY (`productID`) REFERENCES `products` (`productID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
