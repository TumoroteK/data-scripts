truncate table CHAMP_IMPRIME;
truncate table BLOC_IMPRESSION_TEMPLATE;
truncate table TABLE_ANNOTATION_TEMPLATE;
truncate table TEMPLATE;

truncate table RETOUR;

truncate table AFFECTATION_IMPRIMANTE;
truncate table CHAMP_LIGNE_ETIQUETTE;
truncate table LIGNE_ETIQUETTE;
truncate table MODELE;
truncate table IMPRIMANTE;

truncate table RECHERCHE_BANQUE;
truncate table RECHERCHE;
truncate table AFFICHAGE;
truncate table REQUETE;
truncate table RESULTAT;
truncate table GROUPEMENT;
truncate table CRITERE;
truncate table COMBINAISON;

truncate table IMPORTATION;
truncate table IMPORT_HISTORIQUE;
truncate table IMPORT_COLONNE;
truncate table IMPORT_TEMPLATE_ENTITE;
truncate table IMPORT_TEMPLATE;

truncate table COULEUR_ENTITE_TYPE;
truncate table OBJET_NON_CONFORME;
truncate table NON_CONFORMITE;
truncate table NUMEROTATION;
truncate table RESERVATION;

update CHAMP set champ_parent_id = null;
truncate table CHAMP;

truncate table ANNOTATION_VALEUR;
truncate table ANNOTATION_DEFAUT;
truncate table TABLE_ANNOTATION_BANQUE;
truncate table ITEM;
truncate table CHAMP_ANNOTATION;
truncate table TABLE_ANNOTATION;

truncate table CODE_ASSIGNE;
truncate table CODE_SELECT;
update CODE_DOSSIER set dossier_parent_id = null;
truncate table CODE_DOSSIER;
truncate table CODE_UTILISATEUR;
truncate table TRANSCODE_UTILISATEUR;

truncate table CEDER_OBJET;
truncate table CESSION;
truncate table CESSION_EXAMEN;
truncate table DESTRUCTION_MOTIF;
truncate table CONTRAT;

truncate table RETOUR;

truncate table PROD_DERIVE;
truncate table TRANSFORMATION;
truncate table MODE_PREPA_DERIVE;
-- truncate table PROD_TYPE;
truncate table PROD_QUALITE;

truncate table ECHANTILLON;
truncate table MODE_PREPA;
-- truncate table ECHANTILLON_TYPE;
truncate table ECHAN_QUALITE;

truncate table INCIDENT;
truncate table EMPLACEMENT;
truncate table TERMINALE;
truncate table ENCEINTE_BANQUE;
update ENCEINTE set enceinte_pere_id = null;
truncate table ENCEINTE;
truncate table CONTENEUR_BANQUE;
truncate table CONTENEUR_PLATEFORME;
truncate table CONTENEUR;
-- truncate table CONTENEUR_TYPE;

truncate table PRELEVEMENT_SERO_PROTOCOLE;
truncate table PRELEVEMENT_SERO;
truncate table PRELEVEMENT_XENO;
truncate table PRELEVEMENT_DELEGATE;

truncate table LABO_INTER;
truncate table PRELEVEMENT_RISQUE;
truncate table PRELEVEMENT;
truncate table CONSENT_TYPE;
truncate table CONDIT_MILIEU;
truncate table CONDIT_TYPE;
-- truncate table CONSENT_TYPE;
-- truncate table ENCEINTE_TYPE;
truncate table PROTOCOLE;
truncate table PROTOCOLE_TYPE;
-- truncate table PRELEVEMENT_TYPE;
-- truncate table NATURE;
truncate table RISQUE;

truncate table STATS_STATEMENT;
truncate table STATS_INDICATEUR_MODELE;

truncate table MALADIE_SERO;
truncate table MALADIE_DELEGATE;

truncate table PATIENT_MEDECIN;
truncate table MALADIE_MEDECIN;
truncate table MALADIE;
truncate table PATIENT_LIEN;
truncate table PATIENT;
truncate table PATIENT_SIP;
truncate table PATIENT_SIP_SEJOUR;

truncate table BANQUE_CATALOGUE;
truncate table BANQUE_TABLE_CODAGE;
truncate table PROFIL_UTILISATEUR;
truncate table BANQUE;

truncate table COLLABORATEUR_COORDONNEE;
truncate table SERVICE_COLLABORATEUR;
update PLATEFORME set collaborateur_id = null;
update UTILISATEUR set collaborateur_id = null;
truncate table COLLABORATEUR;
truncate table SERVICE;
truncate table ETABLISSEMENT;
truncate table TRANSPORTEUR;
truncate table COORDONNEE;

truncate table CATEGORIE;
truncate table SPECIALITE;

truncate table FICHIER;
truncate table FANTOME;
truncate table OPERATION;
truncate table VERSION;
truncate table CHAMP;
truncate table PLATEFORME_ADMINISTRATEUR;
truncate table UTILISATEUR;

-- truncate table PLATEFORME;
