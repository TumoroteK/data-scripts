insert into CONTENEUR_BANQUE(conteneur_id, banque_id)
select c.conteneur_id, b.banque_id from BANQUE b 
	join CONTENEUR c on c.NOM in ('[NOM_CONTENEUR_1]', '[NOM_CONTENEUR_2]', ...)
	left outer join CONTENEUR_BANQUE cb on cb.BANQUE_ID = b.BANQUE_ID and cb.conteneur_id = c.conteneur_id 
where 
	b.PLATEFORME_id in (select plateforme_id from PLATEFORME where nom = '[NOM_PLATEOFMRE]') 
	and b.archive = 0
	and cb.conteneur_id is null;