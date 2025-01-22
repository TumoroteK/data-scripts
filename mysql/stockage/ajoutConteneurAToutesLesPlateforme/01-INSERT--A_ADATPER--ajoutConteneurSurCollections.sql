insert into CONTENEUR_BANQUE(conteneur_id, banque_id)
select c.conteneur_id, b.banque_id from BANQUE b 
	join CONTENEUR c on c.NOM in ('CRB Nord 4.44 CNG80 PRIMARY', 'CRB Nord 4.44 CNG80 BIS', 'CRB Nord 4.46 Ambiant', 'CRB Nord 4.44 CNG80 PROJETS EN COURS', 'CRB Nord 4.46 Frigo 5°C')
	left outer join CONTENEUR_BANQUE cb on cb.BANQUE_ID = b.BANQUE_ID and cb.conteneur_id = c.conteneur_id 
where 
	b.PLATEFORME_id in (select plateforme_id from PLATEFORME where nom = 'CRB NORD') 
	and b.archive = 0
	and cb.conteneur_id is null;