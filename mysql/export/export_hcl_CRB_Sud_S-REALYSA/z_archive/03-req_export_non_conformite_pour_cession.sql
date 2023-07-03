	select ech.echantillon_id, group_concat(nc.nom) as  'Raison_de_non_conformtie_pour_la_cession'
            FROM ECHANTILLON ech INNER JOIN OBJET_NON_CONFORME onc on onc.objet_id=ech.echantillon_id
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 3
              AND ech.banque_id=227 group by ech.echantillon_id;