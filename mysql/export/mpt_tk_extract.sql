select b.NOM as 'T_001',
   p.CODE as 'T_002',
   n.NATURE as 'T_003',
   a.NIP as 'T_004',
   m.LIBELLE as 'T_005',
   m.CODE as 'T_006',
   a.NOM as 'T_007',
   a.NOM_NAISSANCE as 'T_008',
   a.PRENOM as 'T_009',
   DATE_FORMAT(a.DATE_NAISSANCE, '%d/%m/%Y') as 'T_010',
   a.SEXE as 'T_011',
   DATE_FORMAT(p.DATE_PRELEVEMENT, '%d/%m/%Y') as 'T_012',
   DATE_FORMAT(p.DATE_PRELEVEMENT, '%H:%i') as 'T_013',
   t.TYPE as 'T_014',
   s.NOM as 'T_015', 
   c.NOM as 'T_016',
   ct.TYPE as 'T_017',
   p.CONDIT_NBR as 'T_018',
   cm.MILIEU as 'T_019',
   cs.TYPE as 'T_020',
   DATE_FORMAT(p.CONSENT_DATE, '%d/%m/%Y') as 'T_021',
   DATE_FORMAT(p.DATE_DEPART, '%d/%m/%Y') as 'T_022',
   DATE_FORMAT(p.DATE_DEPART, '%H:%i') as 'T_023',
   tr.NOM as 'T_024',
   p.TRANSPORT_TEMP as 'T_025',
   DATE_FORMAT(p.DATE_ARRIVEE, '%d/%m/%Y') as 'T_026',
   DATE_FORMAT(p.DATE_ARRIVEE, '%H:%i') as 'T_027',
   p.CONFORME_ARRIVEE as 'T_028',
   e.CODE as 'T_029',
   et.TYPE as 'T_030',
   e.QUANTITE_INIT as 'T_031',
   e.QUANTITE as 'T_032',
   mp.NOM as 'T_033',
   DATE_FORMAT(e.DATE_STOCK, '%d/%m/%Y') as 'T_034',
   DATE_FORMAT(e.DATE_STOCK, '%H:%i') as 'T_035',
   e.DELAI_CGL as 'T_036',
   o.NOM as 'T_037',
   e.CONFORME_TRAITEMENT as 'T_038',
   e.CONFORME_CESSION as 'T_039', 
   pr.label
from BANQUE b
join PRELEVEMENT p on p.banque_id=b.banque_id 
join NATURE n on p.nature_id=n.nature_id 
left outer join PRELEVEMENT_TYPE t on p.prelevement_type_id=t.prelevement_type_id 
left outer join CONDIT_TYPE ct on p.condit_type_id = ct.condit_type_id 
left outer join CONDIT_MILIEU cm on p.condit_milieu_id = cm.condit_milieu_id 
join CONSENT_TYPE cs on p.consent_type_id=cs.consent_type_id 
join MALADIE m on p.maladie_id=m.maladie_id 
join PATIENT a on a.patient_id=m.patient_id 
left outer join SERVICE s on p.service_preleveur_id = s.service_id 
left outer join COLLABORATEUR c on p.preleveur_id = c.collaborateur_id 
left outer join TRANSPORTEUR tr on p.transporteur_id = tr.transporteur_id 
join ECHANTILLON e on e.prelevement_id=p.prelevement_id 
join ECHANTILLON_TYPE et on e.echantillon_type_id=et.echantillon_type_id 
left outer join MODE_PREPA mp on e.mode_prepa_id=mp.mode_prepa_id 
left outer join COLLABORATEUR o on e.collaborateur_id = o.collaborateur_id
left outer join (select i.label, v.objet_id from ITEM i join ANNOTATION_VALEUR v on v.item_id=i.item_id 
    join CHAMP_ANNOTATION c on c.champ_annotation_id=v.champ_annotation_id 
    join TABLE_ANNOTATION t on t.table_annotation_id=c.table_annotation_id 
    where t.entite_id=2 and t.nom = 'BIOCHIMIE' and c.nom = 'Protocole') pr on p.prelevement_id=pr.objet_id;
