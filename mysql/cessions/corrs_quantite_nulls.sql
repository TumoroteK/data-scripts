-- corrige les cessions d'échantillons ayant une quantité restante passée à 0
-- alors que la quantité demandée = null, ce qui bloque toute modification de cession
-- La cause est la cession directe d'échantillon sans quantité -> passe à 0
-- bug corrigé à partir de la version 2.2.1 
update ECHANTILLON e join CEDER_OBJET c on c.objet_id=e.echantillon_id set e.quantite = null where c.entite_id=3 and e.banque_id = 72 and c.quantite is null and e.quantite = 0;
