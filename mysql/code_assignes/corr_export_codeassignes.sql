-- ex: HCLs no export!
update CODE_ASSIGNE c join (select min(code_assigne_id) as id from CODE_ASSIGNE where is_morpho = 1 group by echantillon_id having sum(export) = 0) zz on zz.id = c.code_assigne_id set c.export = 1;
