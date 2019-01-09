delete an from ANNOTATION_ALPHANUM an, CHAMP_ANNOTATION c, BANQUE b where an.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A'; 

delete ab from ANNOTATION_BOOL ab, CHAMP_ANNOTATION c, BANQUE b where ab.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A';

delete ad from ANNOTATION_DATE ad, CHAMP_ANNOTATION c, BANQUE b where ad.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A';  

delete au from ANNOTATION_NUM au, CHAMP_ANNOTATION c, BANQUE b where au.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A'; 

delete at from ANNOTATION_TEXTE at, CHAMP_ANNOTATION c, BANQUE b where at.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A'; 

delete ah from ANNOTATION_THES ah, CHAMP_ANNOTATION c, BANQUE b where ah.champ_annotation_id=c.id and (c.table_annotation_id=b.anno_biol or c.table_annotation_id=b.anno_ech) and b.banque_nom='COLLECTION-A'; 

update PRELEVEMENT p, BANQUE b set p.banque_id=(select banque_id from BANQUE where banque_nom='COLLECTION-B')
where p.banque_id=b.banque_id and b.banque_nom='COLLECTION-A';

delete d from DISPOSER d, BANQUE b where b.banque_id = d.banque_id and b.banque_nom = 'COLLECTION-A';

delete from BANQUE where banque_nom = 'COLLECTION-A';


