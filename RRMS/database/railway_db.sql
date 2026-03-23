-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 22, 2026 at 07:27 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `railway_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `TicketID` int(11) NOT NULL,
  `PassengerID` int(11) DEFAULT NULL,
  `ScheduleID` int(11) DEFAULT NULL,
  `BookingDate` datetime DEFAULT NULL,
  `SeatStatus` varchar(20) DEFAULT NULL,
  `DynamicPricingFactor` decimal(3,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`TicketID`, `PassengerID`, `ScheduleID`, `BookingDate`, `SeatStatus`, `DynamicPricingFactor`) VALUES
(1, 1, 14, '2026-03-22 23:19:34', 'Confirmed', 1.00);

-- --------------------------------------------------------

--
-- Table structure for table `cancellations`
--

CREATE TABLE `cancellations` (
  `CancellationID` int(11) NOT NULL,
  `TicketID` int(11) DEFAULT NULL,
  `CancellationDate` datetime DEFAULT NULL,
  `Reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fares`
--

CREATE TABLE `fares` (
  `FareID` int(11) NOT NULL,
  `RouteID` int(11) DEFAULT NULL,
  `ClassType` varchar(50) DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fares`
--

INSERT INTO `fares` (`FareID`, `RouteID`, `ClassType`, `TotalAmount`) VALUES
(1, 1, 'AC Chair', 1250.00),
(2, 1, 'AC Sleeper', 1850.00),
(3, 1, 'Snigdha', 950.00),
(4, 1, 'Shovan Chair', 450.00),
(5, 1, 'General', 280.00),
(6, 2, 'AC Chair', 1250.00),
(7, 2, 'AC Sleeper', 1850.00),
(8, 2, 'Snigdha', 950.00),
(9, 2, 'Shovan Chair', 450.00),
(10, 2, 'General', 280.00),
(11, 3, 'AC Chair', 1050.00),
(12, 3, 'AC Sleeper', 1650.00),
(13, 3, 'Snigdha', 750.00),
(14, 3, 'Shovan Chair', 380.00),
(15, 3, 'General', 230.00),
(16, 4, 'AC Chair', 1050.00),
(17, 4, 'AC Sleeper', 1650.00),
(18, 4, 'Snigdha', 750.00),
(19, 4, 'Shovan Chair', 380.00),
(20, 4, 'General', 230.00),
(21, 5, 'AC Chair', 1150.00),
(22, 5, 'AC Sleeper', 1750.00),
(23, 5, 'Snigdha', 850.00),
(24, 5, 'Shovan Chair', 420.00),
(25, 5, 'General', 260.00),
(26, 6, 'AC Chair', 1150.00),
(27, 6, 'AC Sleeper', 1750.00),
(28, 6, 'Snigdha', 850.00),
(29, 6, 'Shovan Chair', 420.00),
(30, 6, 'General', 260.00),
(31, 7, 'AC Chair', 1100.00),
(32, 7, 'AC Sleeper', 1700.00),
(33, 7, 'Snigdha', 800.00),
(34, 7, 'Shovan Chair', 400.00),
(35, 7, 'General', 250.00),
(36, 8, 'AC Chair', 1100.00),
(37, 8, 'AC Sleeper', 1700.00),
(38, 8, 'Snigdha', 800.00),
(39, 8, 'Shovan Chair', 400.00),
(40, 8, 'General', 250.00);

-- --------------------------------------------------------

--
-- Table structure for table `passengers`
--

CREATE TABLE `passengers` (
  `PassengerID` int(11) NOT NULL,
  `UserID` int(11) DEFAULT NULL,
  `PassportNumber` varchar(50) DEFAULT NULL,
  `FullName` varchar(100) DEFAULT NULL,
  `DateOfBirth` date DEFAULT NULL,
  `Gender` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passengers`
--

INSERT INTO `passengers` (`PassengerID`, `UserID`, `PassportNumber`, `FullName`, `DateOfBirth`, `Gender`) VALUES
(1, 1, 'ABC123', 'EVA', '2026-03-22', 'Male');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `PaymentID` int(11) NOT NULL,
  `TicketID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `PaymentDate` datetime DEFAULT NULL,
  `Method` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`PaymentID`, `TicketID`, `Amount`, `PaymentDate`, `Method`) VALUES
(1, 1, 1250.00, '2026-03-22 23:19:34', 'Cash');

-- --------------------------------------------------------

--
-- Table structure for table `refunds`
--

CREATE TABLE `refunds` (
  `RefundID` int(11) NOT NULL,
  `CancellationID` int(11) DEFAULT NULL,
  `RefundAmount` decimal(10,2) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `routes`
--

CREATE TABLE `routes` (
  `RouteID` int(11) NOT NULL,
  `SourceStation` varchar(100) NOT NULL,
  `DestinationStation` varchar(100) NOT NULL,
  `Distance` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `routes`
--

INSERT INTO `routes` (`RouteID`, `SourceStation`, `DestinationStation`, `Distance`) VALUES
(1, 'ঢাকা', 'চট্টগ্রাম', NULL),
(2, 'চট্টগ্রাম', 'ঢাকা', NULL),
(3, 'ঢাকা', 'রাজশাহী', NULL),
(4, 'রাজশাহী', 'ঢাকা', NULL),
(5, 'ঢাকা', 'খুলনা', NULL),
(6, 'খুলনা', 'ঢাকা', NULL),
(7, 'ঢাকা', 'সিলেট', NULL),
(8, 'সিলেট', 'ঢাকা', NULL),
(9, 'ঢাকা', 'রংপুর', NULL),
(10, 'রংপুর', 'ঢাকা', NULL),
(11, 'ঢাকা', 'বরিশাল', NULL),
(12, 'বরিশাল', 'ঢাকা', NULL),
(13, 'চট্টগ্রাম', 'কক্সবাজার', NULL),
(14, 'কক্সবাজার', 'চট্টগ্রাম', NULL),
(15, 'চট্টগ্রাম', 'সিলেট', NULL),
(16, 'সিলেট', 'চট্টগ্রাম', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `schedules`
--

CREATE TABLE `schedules` (
  `ScheduleID` int(11) NOT NULL,
  `TrainNumber` varchar(10) DEFAULT NULL,
  `RouteID` int(11) DEFAULT NULL,
  `DepartureTime` datetime DEFAULT NULL,
  `ArrivalTime` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedules`
--

INSERT INTO `schedules` (`ScheduleID`, `TrainNumber`, `RouteID`, `DepartureTime`, `ArrivalTime`) VALUES
(1, '701', 1, '2026-03-25 07:00:00', '2026-03-25 13:30:00'),
(2, '701', 2, '2026-03-25 15:00:00', '2026-03-25 21:30:00'),
(3, '702', 1, '2026-03-25 08:30:00', '2026-03-25 15:00:00'),
(4, '702', 2, '2026-03-25 16:30:00', '2026-03-25 23:00:00'),
(5, '704', 3, '2026-03-25 06:30:00', '2026-03-25 13:00:00'),
(6, '704', 4, '2026-03-25 14:30:00', '2026-03-25 21:00:00'),
(7, '715', 7, '2026-03-25 07:30:00', '2026-03-25 14:30:00'),
(8, '715', 8, '2026-03-25 15:30:00', '2026-03-25 22:30:00'),
(9, '709', 5, '2026-03-25 07:45:00', '2026-03-25 15:45:00'),
(10, '709', 6, '2026-03-25 16:15:00', '2026-03-26 00:15:00'),
(11, '710', 1, '2026-03-25 22:00:00', '2026-03-26 04:30:00'),
(12, '710', 2, '2026-03-25 23:00:00', '2026-03-26 05:30:00'),
(13, '714', 3, '2026-03-25 22:30:00', '2026-03-26 05:00:00'),
(14, '711', 1, '2026-03-25 06:00:00', '2026-03-25 14:30:00'),
(15, '708', 7, '2026-03-25 09:00:00', '2026-03-25 16:00:00'),
(16, '707', 7, '2026-03-25 20:00:00', '2026-03-26 03:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `trains`
--

CREATE TABLE `trains` (
  `TrainNumber` int(11) NOT NULL,
  `TrainName` varchar(100) NOT NULL,
  `TotalSeats` int(11) NOT NULL,
  `Speed` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `trains`
--

INSERT INTO `trains` (`TrainNumber`, `TrainName`, `TotalSeats`, `Speed`) VALUES
(701, 'সুবর্ণ এক্সপ্রেস | Subarna Express', 450, NULL),
(702, 'সোনার বাংলা এক্সপ্রেস | Sonar Bangla Express', 400, NULL),
(703, 'ঈগল এক্সপ্রেস | Eagle Express', 350, NULL),
(704, 'মহানগর এক্সপ্রেস | Mohanagar Express', 380, NULL),
(705, 'মহানগর প্রভাতী | Mohanagar Provati', 360, NULL),
(706, 'মহানগর গোধূলী | Mohanagar Godhuli', 360, NULL),
(707, 'কালনী এক্সপ্রেস | Kalni Express', 320, NULL),
(708, 'জয়ন্তিকা এক্সপ্রেস | Joyantika Express', 340, NULL),
(709, 'উপকূল এক্সপ্রেস | Upakul Express', 300, NULL),
(710, 'তূর্ণা এক্সপ্রেস | Turna Express', 420, NULL),
(711, 'ঢাকা মেইল | Dhaka Mail', 500, NULL),
(712, 'চট্টগ্রাম মেইল | Chittagong Mail', 480, NULL),
(713, 'রাজশাহী এক্সপ্রেস | Rajshahi Express', 380, NULL),
(714, 'বরেন্দ্র এক্সপ্রেস | Barendra Express', 360, NULL),
(715, 'সিল্ক সিটি এক্সপ্রেস | Silk City Express', 340, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `PasswordHash` varchar(255) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `FullName` varchar(100) DEFAULT NULL,
  `Role` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `Username`, `PasswordHash`, `Email`, `FullName`, `Role`) VALUES
(1, 'guest_user', 'guest', 'guest@railway.com', 'Guest User', 'Passenger'),
(2, 'ukj', 'abc123', 'samieajahaneva9543@gmail.com', 'Samiea Jahan Eva', 'Passenger');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`TicketID`);

--
-- Indexes for table `cancellations`
--
ALTER TABLE `cancellations`
  ADD PRIMARY KEY (`CancellationID`);

--
-- Indexes for table `fares`
--
ALTER TABLE `fares`
  ADD PRIMARY KEY (`FareID`),
  ADD KEY `RouteID` (`RouteID`);

--
-- Indexes for table `passengers`
--
ALTER TABLE `passengers`
  ADD PRIMARY KEY (`PassengerID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`PaymentID`);

--
-- Indexes for table `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`RefundID`);

--
-- Indexes for table `routes`
--
ALTER TABLE `routes`
  ADD PRIMARY KEY (`RouteID`);

--
-- Indexes for table `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`ScheduleID`);

--
-- Indexes for table `trains`
--
ALTER TABLE `trains`
  ADD PRIMARY KEY (`TrainNumber`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `TicketID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cancellations`
--
ALTER TABLE `cancellations`
  MODIFY `CancellationID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fares`
--
ALTER TABLE `fares`
  MODIFY `FareID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `passengers`
--
ALTER TABLE `passengers`
  MODIFY `PassengerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `PaymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `refunds`
--
ALTER TABLE `refunds`
  MODIFY `RefundID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `routes`
--
ALTER TABLE `routes`
  MODIFY `RouteID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `schedules`
--
ALTER TABLE `schedules`
  MODIFY `ScheduleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `fares`
--
ALTER TABLE `fares`
  ADD CONSTRAINT `fares_ibfk_1` FOREIGN KEY (`RouteID`) REFERENCES `routes` (`RouteID`);

--
-- Constraints for table `passengers`
--
ALTER TABLE `passengers`
  ADD CONSTRAINT `passengers_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
