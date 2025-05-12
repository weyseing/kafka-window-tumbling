USE db_data;

CREATE TABLE IF NOT EXISTS buyer (
  id INT PRIMARY KEY,
  name VARCHAR(100)
);

INSERT INTO buyer (id, name) VALUES
  (1, 'Alice'),
  (2, 'Bob'),
  (3, 'Charlie');
