SET NAMES 'utf8';

select login, email, p.nom as plateforme_origine
from UTILISATEUR u inner join PLATEFORME p
on p.plateforme_id = u.plateforme_orig_id
where super = 1;