update UTILISATEUR set timeout = DATE_ADD(CURDATE(), INTERVAL 6 MONTH) where super = 0;
