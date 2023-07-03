	select prel.prelevement_id, group_concat(nc.nom) as  'non_conformite_arrivee'
            FROM PRELEVEMENT prel INNER JOIN OBJET_NON_CONFORME onc on onc.objet_id=prel.prelevement_id 
                   LEFT JOIN NON_CONFORMITE nc ON onc.non_conformite_id = nc.non_conformite_id
                   LEFT JOIN CONFORMITE_TYPE ct ON nc.conformite_type_id = ct.conformite_type_id
            WHERE ct.conformite_type_id = 1
              AND prel.banque_id=227 group by prel.prelevement_id;