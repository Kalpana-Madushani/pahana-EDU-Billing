-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 21, 2025 at 07:09 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pahanabookshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `bill_date` timestamp NULL DEFAULT current_timestamp(),
  `total_amount` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`id`, `customer_id`, `bill_date`, `total_amount`) VALUES
(36, 36, '2025-08-20 20:16:51', 5200),
(34, 36, '2025-08-20 20:16:31', 2500),
(35, 23, '2025-08-20 20:16:41', 10200),
(33, 42, '2025-08-20 20:14:48', 5000),
(32, 41, '2025-08-20 20:14:39', 2500),
(31, 40, '2025-08-20 20:13:55', 8500),
(30, 43, '2025-08-20 20:13:22', 3000);

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `id` int(11) NOT NULL,
  `bill_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` double DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill_items`
--

INSERT INTO `bill_items` (`id`, `bill_id`, `book_id`, `quantity`, `price`) VALUES
(22, 17, 5, 1, 3000),
(44, 34, 31, 1, 2500),
(47, 36, 29, 1, 5200),
(46, 35, 30, 1, 5000),
(45, 35, 29, 1, 5200),
(43, 33, 28, 1, 5000),
(42, 32, 31, 1, 2500),
(41, 31, 28, 1, 5000),
(40, 31, 27, 1, 3500),
(39, 30, 32, 1, 3000);

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `price` double DEFAULT NULL,
  `imageUrl` varchar(500) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `author`, `category`, `stock`, `publisher`, `year`, `price`, `imageUrl`) VALUES
(33, 'Toy Story: Woody\'s Adventures', 'Disney Storybook Team', 'Children\'s', 25, 'Disney Press', 2022, 3200, 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1367546726i/17879187.jpg'),
(32, 'Beauty and the Beast: Lost in a Book', 'Jennifer Donnelly', 'Fairy Tale', 50, 'Disney-Hyperion', 2017, 3000, 'https://www.brotherhoodbooks.org.au/media/catalog/product/cache/9903d275d05bbeaff4132993adf9325a/I/M/IMG_0006_149.jpg'),
(31, 'Mickey Mouse Adventures ', 'Walt Disney Company', 'Children\'s', 0, 'Disney Press', 2020, 2500, 'https://upload.wikimedia.org/wikipedia/en/3/35/Mickey_Mouse_Adventures_1.jpg'),
(29, 'Cinderella: The Great Mouse Mistake', 'Ellie OÃ¢ÂÂRyan', 'Fairy Tale', 0, 'RH/Disney', 2020, 5200, 'https://i.ebayimg.com/images/g/lYgAAOSwaWhfPUIr/s-l400.png'),
(30, 'The Lion King: A Tale of Two Brothers', 'Alex Simmons', 'Adventure', 2, 'Disney-Hyperion', 2021, 5000, 'https://media.s-bol.com/qJ9y0ExD5N2/550x684.jpg'),
(28, 'Frozen: The Story of Anna & Elsa', 'Jennifer Lee', 'Fantasy', 8, 'Random House', 2019, 5000, 'https://upload.wikimedia.org/wikipedia/en/0/05/Frozen_%282013_film%29_poster.jpg'),
(27, 'Moana and the Ocean', 'Heather Knowles', 'Picture Book', 11, 'Disney Press', 2018, 3500, 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1475264212i/28963887.jpg'),
(34, 'Aladdin: Far from Agrabah', 'Aisha Saeed', 'Fantasy', 15, 'Disney Book Group', 2019, 4000, 'https://m.media-amazon.com/images/I/81RUslENbHL._UF1000,1000_QL80_.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `phone` varchar(40) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `email`, `address`) VALUES
(42, 'Emma Thompson', '0790123456', 'emma.t@email.com', '101 Station Road, Anuradhapura'),
(36, 'Alice Johnson', '0761234567', 'alice.johnson@email.com', '45 Galle Road, Colombo 03'),
(37, 'Brian Smith', '0762345678', 'bsmith99@email.com', '12 Kandy Road, Nugegoda'),
(41, 'Isabella Carter', '0739012345', 'isabella.c@email.com', '27 Peradeniya Road, Polonnaruwa'),
(40, 'David Kim', '0754567890', 'dkim2020@email.com', '21 Main Street, Gampaha'),
(39, 'Jack Reynolds', '0791234567', 'jackr@email.com', '59 Hill Street, Matara'),
(23, 'Kalpana Madushani', '0781234567', 'abc@123gmail.com', 'colombo'),
(38, 'Grace Lee', '0782345789', 'glee@email.com', '88 Temple Road, Kandy'),
(43, 'Carla Martinezz', '0747890121', 'carlaa.m@email.com', '32 Lake Drive, Nuwara Eliya');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(20) DEFAULT 'admin',
  `status` varchar(20) DEFAULT 'ACTIVE',
  `created_date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `status`, `created_date`) VALUES
(1, 'admin', '123', 'admin', 'ACTIVE', '2025-08-07 13:58:43'),
(8, 'cashier', '123', 'cashier', 'ACTIVE', '2025-08-16 16:44:18'),
(14, 'Nancy Anderson', '123', 'cashier', 'INACTIVE', '2025-08-20 19:47:21'),
(7, 'stock', '123', 'stock_keeper', 'ACTIVE', '2025-08-16 13:59:04'),
(13, 'Sarah Brown', '123', 'cashier', 'ACTIVE', '2025-08-20 19:46:38'),
(15, 'Jennifer Miller', '123', 'stock_keeper', 'INACTIVE', '2025-08-20 19:47:46'),
(16, 'Lisa Davis', '123', 'cashier', 'ACTIVE', '2025-08-20 19:48:10');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
