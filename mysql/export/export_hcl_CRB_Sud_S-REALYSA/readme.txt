La volumétrie étant importante, le temps de réponse est autour de 5 minutes (avec l'index sur OBJET_ID de OBJET_NON_CONFORME : https://tumorotek.myjetbrains.com/youtrack/issue/TK-382)
Si les temps de réponse se dégradaient et la requête ne répondait plus, il faut découper en 4 requêtes pour sortir "à côté" les non conformités (cf z_archive).

Pour la transformation en excel :
	• Choisir le format 65001 : Unicode (UTF-8), vers la fin de la liste (cf ci-dessous)
	• Choisir le format texte pour les colonnes : 
		○ T : N° Laboratoire
		○ AV : Nom Patient
