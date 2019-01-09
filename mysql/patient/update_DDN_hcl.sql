-- update des dates de naissances des patients : on ne conserve que la date
update PATIENT set date_naissance = MAKEDATE(YEAR(date_naissance), 1);
