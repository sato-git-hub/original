CREATE DATABASE IF NOT EXISTS original_development;
CREATE DATABASE IF NOT EXISTS original_test;
GRANT ALL PRIVILEGES ON original_development.* TO 'original-user'@'%';
GRANT ALL PRIVILEGES ON original_test.* TO 'original-user'@'%';
FLUSH PRIVILEGES;