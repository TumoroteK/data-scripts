delete from CHAMP_IMPRIME;
delete from BLOC_IMPRESSION_TEMPLATE;
delete from TABLE_ANNOTATION_TEMPLATE;
delete from TEMPLATE;

delete from RETOUR;

delete from AFFECTATION_IMPRIMANTE;
delete from CHAMP_LIGNE_ETIQUETTE;
delete from LIGNE_ETIQUETTE;
delete from MODELE;
delete from IMPRIMANTE;

delete from RECHERCHE_BANQUE;
delete from RECHERCHE;
delete from AFFICHAGE;
delete from REQUETE;
delete from RESULTAT;
delete from GROUPEMENT;
delete from CRITERE;
delete from COMBINAISON;

delete from IMPORTATION;
delete from IMPORT_HISTORIQUE;
delete from IMPORT_COLONNE;
delete from IMPORT_TEMPLATE_ENTITE;
delete from IMPORT_TEMPLATE;

delete from COULEUR_ENTITE_TYPE;
delete from OBJET_NON_CONFORME;
delete from NON_CONFORMITE;
delete from NUMEROTATION;
delete from RESERVATION;

update CHAMP set champ_parent_id = null;
delete from CHAMP;

delete from ANNOTATION_VALEUR;
delete from ANNOTATION_DEFAUT;
delete from TABLE_ANNOTATION_BANQUE;
delete from ITEM;
delete from CHAMP_ANNOTATION;
delete from TABLE_ANNOTATION;

delete from CODE_ASSIGNE;
delete from CODE_SELECT;
update CODE_DOSSIER set dossier_parent_id = null;
delete from CODE_DOSSIER;
delete from CODE_UTILISATEUR;
delete from TRANSCODE_UTILISATEUR;

delete from CEDER_OBJET;
delete from CESSION;
delete from CESSION_EXAMEN;
delete from DESTRUCTION_MOTIF;
delete from CONTRAT;

delete from RETOUR;

delete from PROD_DERIVE;
delete from TRANSFORMATION;
delete from MODE_PREPA_DERIVE;
-- delete from PROD_TYPE;
delete from PROD_QUALITE;

delete from ECHANTILLON;
delete from MODE_PREPA;
-- delete from ECHANTILLON_TYPE;
delete from ECHAN_QUALITE;

delete from INCIDENT;
delete from EMPLACEMENT;
delete from TERMINALE;
delete from ENCEINTE_BANQUE;
update ENCEINTE set enceinte_pere_id = null;
delete from ENCEINTE;
delete from CONTENEUR_BANQUE;
delete from CONTENEUR_PLATEFORME;
delete from CONTENEUR;
-- delete from CONTENEUR_TYPE;

delete from PRELEVEMENT_SERO_PROTOCOLE;
delete from PRELEVEMENT_SERO;
delete from PRELEVEMENT_XENO;
delete from PRELEVEMENT_DELEGATE;

delete from LABO_INTER;
delete from PRELEVEMENT_RISQUE;
delete from PRELEVEMENT;
delete from CONSENT_TYPE where plateforme_id = 2;
delete from CONDIT_MILIEU;
delete from CONDIT_TYPE;
-- delete from CONSENT_TYPE;
-- delete from ENCEINTE_TYPE;
delete from PROTOCOLE;
delete from PROTOCOLE_TYPE;
-- delete from PRELEVEMENT_TYPE;
-- delete from NATURE;
delete from RISQUE;

delete from STATS_MODELE_BANQUE;
delete from STATS_MODELE_INDICATEUR;
delete from STATS_INDICATEUR;
delete from STATS_MODELE;

delete from MALADIE_SERO;
delete from MALADIE_DELEGATE;

delete from PATIENT_MEDECIN;
delete from MALADIE_MEDECIN;
delete from MALADIE;
delete from PATIENT_LIEN;
delete from PATIENT;
-- delete from PATIENT_SIP;

delete from BANQUE_CATALOGUE;
delete from BANQUE_TABLE_CODAGE;
delete from PROFIL_UTILISATEUR;
delete from BANQUE;

delete from COLLABORATEUR_COORDONNEE;
delete from SERVICE_COLLABORATEUR;
update PLATEFORME set collaborateur_id = null;
update UTILISATEUR set collaborateur_id = null;
delete from COLLABORATEUR;
delete from SERVICE;
delete from ETABLISSEMENT;
delete from TRANSPORTEUR;
delete from COORDONNEE;

delete from CATEGORIE;
delete from SPECIALITE;

delete from CONSULTATION_INTF;

delete from FICHIER;
delete from FANTOME;
delete from OPERATION;
delete from VERSION;
delete from CHAMP;
delete from PLATEFORME_ADMINISTRATEUR;
delete from UTILISATEUR;

delete from STATS_MODELE_INDICATEUR;


-- delete from PLATEFORME;
