DELIMITER &&

DROP PROCEDURE IF EXISTS z_specific_export_utilisateurs_actifs &&
CREATE PROCEDURE z_specific_export_utilisateurs_actifs ()
BEGIN
    DECLARE query TEXT DEFAULT '';

    SET @query = 
    "select autres_data.login, autres_data.collaborateur, autres_data.service, autorisations.autorisation, autres_data.plateforme_origine, autres_data.date_creation
    from 
    (
        select u.login, CONCAT(c.nom, ' ', c.prenom) as collaborateur, GROUP_CONCAT(s.nom SEPARATOR ', ') as service, CONCAT(p.NOM) as plateforme_origine, date_format(o.date_, '%d/%m/%Y %H:%i:%s') as date_creation
        from UTILISATEUR u
            inner join COLLABORATEUR c on c.COLLABORATEUR_ID = u .COLLABORATEUR_ID
            inner join SERVICE_COLLABORATEUR sc on sc.COLLABORATEUR_ID = c.COLLABORATEUR_ID
            inner join SERVICE s on s.SERVICE_ID = sc.SERVICE_ID
            inner join PLATEFORME p on p.PLATEFORME_ID = u.PLATEFORME_ORIG_ID
            left outer join OPERATION o on o.OBJET_ID = u.UTILISATEUR_ID and o.ENTITE_ID = 13 and o.OPERATION_TYPE_ID = 3    
        where
            u.ARCHIVE = 0
        group by u.login, c.nom, c.prenom, p.NOM, o.date_
    ) as autres_data
    inner join (
        -- v2 : ajout admin plateforme :
		select u.login, CONCAT(p.nom, ' - Administrateur de plateforme') as autorisation  
        from PLATEFORME_ADMINISTRATEUR pa, PLATEFORME p, UTILISATEUR u
		where p.PLATEFORME_ID = pa.PLATEFORME_ID and u.UTILISATEUR_ID = pa.UTILISATEUR_ID 
		UNION all  	
		-- fin v2	
        select u.login, CONCAT(b.NOM, ' - ', prf.NOM) as autorisation
        from UTILISATEUR u
            inner join PROFIL_UTILISATEUR pu on pu.UTILISATEUR_ID = u.UTILISATEUR_ID
            inner join PROFIL prf on prf.PROFIL_ID = pu.PROFIL_ID
            inner join BANQUE b on b.BANQUE_ID = pu.BANQUE_ID 
    ) as autorisations
    on autres_data.login = autorisations.login
    order by autres_data.login";

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END&&
