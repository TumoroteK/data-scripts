select p1.patient_id, p1.nip, p1.nom, p1.prenom, p1.date_naissance, 
    p2.patient_id, p2.nip, p2.nom, p2.prenom, p2.date_naissance   
from PATIENT p1, PATIENT p2 
where p1.nom=p2.nom and p1.prenom=p2.prenom and p1.patient_id>p2.patient_id 
and p1.patient_id in 
    (select patient_id from MALADIE m join PRELEVEMENT e on e.maladie_id=m.maladie_id and e.banque_id=2)

