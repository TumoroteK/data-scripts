use tumo2codes;

-- keep copy of original libelle 
alter table CIM_MASTER add libelle_orig varchar(300);
update CIM_MASTER set libelle_orig=LIBELLE;

-- prepare la concatenation
alter table CIM_MASTER add libelle_parent varchar(300);
update CIM_MASTER n4 join CIM_MASTER n3 on n3.sid=n4.id3 set n4.libelle_parent=n3.LIBELLE where n4.level_ = 4 and n4.id1=932 and n4.id3 > 0 and n4.author not like 'HCLs';
update CIM_MASTER set libelle = concat(libelle_parent, ', ', libelle_orig) where libelle_parent is not null;

-- D47 
update CIM_MASTER set libelle = libelle_orig where libelle_parent is not null and code like 'D47.%';

-- Si le code est déja contenu, revert
select code, libelle, libelle_orig from CIM_MASTER where libelle_parent is not null and libelle_orig like concat('%', libelle_parent, '%');

update CIM_MASTER set libelle=libelle_orig where libelle_parent is not null and libelle_orig like concat('%', libelle_parent, '%');



