La volumétrie étant importante, le temps de réponse est autour de 5 minutes (avec l'index sur OBJET_ID de OBJET_NON_CONFORME : https://tumorotek.myjetbrains.com/youtrack/issue/TK-382)
Si les temps de réponse se dégradaient et la requête ne répondait plus, il faut découper en 4 requêtes pour sortir "à côté" les non conformités (cf z_archive).

NB : la V4 prend en compte le critère sur la date de prélèvement

V5 : ajout d'une colonne après le statut : cession CRBS-2022-96 Externalisation ADN/Serum REALYSA (colonne K). Si elle contient  6623 (l’id technique de la cession) c’est que l’échantillon faisait partie de cette cession qui correspond à une externalisation des échantillons
Cela permet de répondre à cette demande faite en juin 2026 :
-------------
"Par ailleurs, l’équipe m’a demandé une petite modification sur l’export mais je ne sais pas si cela est possible :
En 2022, une grande partie d’échantillons de sérum et d’ADN sont partis pour externalisation dans la structure Cryoport Systems faute de place chez nous. 
Il s’agit de la cession CRBS-2022-96 Externalisation ADN/Serum REALYSA contenant 4293 échantillons de sérum et 1699 échantillons d’ADN.

Ces échantillons étant partis de chez nous, ils ont le statut « EPUISE » sur TK et sur l’export général que vous me fournissez. 
L’équipe du Lysarc n’a donc pas de moyen de savoir, sur l’export, si l’échantillon est épuisé car : 
-	Cédé donc plus disponible ;
-	Externalisé chez Cryoport Systems donc encore disponible pour des cessions.

Est-il possible de faire apparaitre sur l’export, une quelconque indication/une nouvelle colonne/… sur les échantillons concernés par la cession CRBS-2022-96 Externalisation ADN/Serum REALYSA ?"
-------------


Pour la transformation en excel :
	• Choisir le format 65001 : Unicode (UTF-8), vers la fin de la liste (cf ci-dessous)
	• Choisir le format texte pour les colonnes : 
		○ T : N° Laboratoire (2e champ prélèvement - après les champs échantillons)
		○ AV : Nom Patient (avant dernière colonne)
