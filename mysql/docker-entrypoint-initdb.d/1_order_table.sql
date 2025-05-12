USE db_data;

CREATE TABLE IF NOT EXISTS `order` (
  id INT PRIMARY KEY,
  product VARCHAR(100),
  amount INT,
  buyer_id INT
);


INSERT INTO `order` (id, product, amount, buyer_id) VALUES
  (1,  'Widget',      2, 1),
  (2,  'Gadget',      3, 2),
  (3,  'Doodad',      1, 3),
  (4,  'Gizmo',       5, 1),
  (5,  'Widget',      7, 2),
  (6,  'Gadget',      4, 3),
  (7,  'Doodad',      6, 1),
  (8,  'Thingamajig', 8, 2),
  (9,  'Gizmo',       2, 3),
  (10, 'Widget',      9, 1);