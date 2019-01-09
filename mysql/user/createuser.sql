create user tumo@'localhost' identified by 'tumo';
GRANT ALL PRIVILEGES ON tumo2.* TO tumo@'localhost';
GRANT SELECT ON mysql.proc TO 'tumo'@'localhost';
flush privileges;
