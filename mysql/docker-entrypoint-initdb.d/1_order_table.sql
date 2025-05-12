USE db_data;

CREATE TABLE IF NOT EXISTS `order` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product VARCHAR(100),
  amount INT,
  buyer VARCHAR(100)
);