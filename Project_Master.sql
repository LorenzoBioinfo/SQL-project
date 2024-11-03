
CREATE TABLE ExamTab (
 
    ID_cliente INT,
    ETA varchar(19)
);

#ETA'
INSERT INTO ExamTAB 
SELECT id_cliente, timestampdiff(YEAR,data_nascita,curdate())
FROM cliente;

#Numero di transazioni in uscita su tutti i conti
SELECT ExamTab.id_cliente,COUNT(*) AS numero_transazioni
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans>2
GROUP BY ExamTab.id_cliente;

CREATE VIEW transazioni_uscenti AS
SELECT ExamTab.id_cliente, COUNT(*) as numero_transazioni_uscenti
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans>2
GROUP BY ExamTab.id_cliente;

#Numero di transazioni in entrata su tutti i conti

SELECT ExamTab.id_cliente,COUNT(*) AS numero_transazioni
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans<=2
GROUP BY ExamTab.id_cliente;

CREATE VIEW transazioni_entranti AS
SELECT ExamTab.id_cliente, COUNT(*) as numero_transazioni_entranti
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans<=2
GROUP BY ExamTab.id_cliente;


#Importo transato in uscita su tutti i conti
CREATE VIEW importo_uscita AS
SELECT ExamTab.id_cliente,SUM(transazioni.importo) AS totale_transato
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans>2
GROUP BY ExamTab.id_cliente;




#Importo transato in entrata su tutti i conti
CREATE VIEW importo_entrata AS
SELECT ExamTab.id_cliente,SUM(transazioni.importo) AS totale_transato
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans<=2
GROUP BY ExamTab.id_cliente;


# Numero conti posseduti
CREATE VIEW totale_conti AS
SELECT ExamTab.id_cliente, COUNT(co.id_conto) AS totale_conti
FROM ExamTab 
LEFT JOIN conto co ON ExamTab.id_cliente = co.id_cliente
GROUP BY ExamTab.id_cliente;


# Numero di conti per tipologia 
create view  tipologia_conti as 
SELECT
  ExamTab.ID_cliente,
  SUM(CASE WHEN tc.id_tipo_conto = 0 THEN 1 ELSE 0 END) AS conti_tipo_Base,
  SUM(CASE WHEN tc.id_tipo_conto = 1 THEN 1 ELSE 0 END) AS conti_tipo_Business,
  SUM(CASE WHEN tc.id_tipo_conto = 2 THEN 1 ELSE 0 END) AS conti_tipo_Privati,
  SUM(CASE WHEN tc.id_tipo_conto = 3 THEN 1 ELSE 0 END) AS conti_tipo_Famiglie
FROM ExamTab
LEFT JOIN conto co ON ExamTab.ID_cliente = co.id_cliente
LEFT JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
GROUP BY ExamTab.id_cliente;


# Numero di transazioni per ogni tipologia uscita
create view  tipologia_transazioni_uscita as 
SELECT
  ExamTab.ID_cliente,
  SUM(CASE WHEN transazioni.id_tipo_trans = 3 THEN 1 ELSE 0 END) AS conti_tipo_Amazon,
  SUM(CASE WHEN transazioni.id_tipo_trans = 4 THEN 1 ELSE 0 END) AS conti_tipo_Mutuo,
  SUM(CASE WHEN transazioni.id_tipo_trans = 5 THEN 1 ELSE 0 END) AS conti_tipo_Hotel,
  SUM(CASE WHEN transazioni.id_tipo_trans = 6 THEN 1 ELSE 0 END) AS conti_tipo_Aereo,
  SUM(CASE WHEN transazioni.id_tipo_trans = 7 THEN 1 ELSE 0 END) AS conti_tipo_Supermercato
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans>2
GROUP BY ExamTab.id_cliente;


# Numero di transazioni per ogni tipologia entrata
create view  tipologia_transazioni_entrata as 
SELECT
  ExamTab.ID_cliente,
  SUM(CASE WHEN transazioni.id_tipo_trans = 0 THEN 1 ELSE 0 END) AS conti_tipo_Stipendio,
  SUM(CASE WHEN transazioni.id_tipo_trans = 1 THEN 1 ELSE 0 END) AS conti_tipo_Pensione,
  SUM(CASE WHEN transazioni.id_tipo_trans = 2 THEN 1 ELSE 0 END) AS conti_tipo_Dividenti
FROM ExamTab
JOIN conto ON ExamTab.id_cliente = conto.id_cliente
JOIN transazioni ON conto.id_conto = transazioni.id_conto
WHERE transazioni.id_tipo_trans<=2
GROUP BY ExamTab.id_cliente;



# Importo per tipologia in uscita

Create view importo_uscita_tipologia as 
SELECT
  ExamTab.id_cliente,
  SUM(CASE WHEN tc.id_tipo_conto = 0 THEN t.importo ELSE 0 END) AS importo_conto_tipo_0_uscita,
  SUM(CASE WHEN tc.id_tipo_conto = 1 THEN t.importo ELSE 0 END) AS importo_conto_tipo_1_uscita,
  SUM(CASE WHEN tc.id_tipo_conto = 2 THEN t.importo ELSE 0 END) AS importo_conto_tipo_2_uscita,
  SUM(CASE WHEN tc.id_tipo_conto = 3 THEN t.importo ELSE 0 END) AS importo_conto_tipo_3_uscita
FROM
  ExamTab 
  JOIN conto co ON  ExamTab .id_cliente = co.id_cliente
  JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
  LEFT JOIN transazioni t ON co.id_conto = t.id_conto
WHERE
  t.id_tipo_trans>2   
GROUP BY
   ExamTab .id_cliente;



Create view importo_entrata_tipologia as 
SELECT
  ExamTab.id_cliente,
  SUM(CASE WHEN tc.id_tipo_conto = 0 THEN t.importo ELSE 0 END) AS importo_conto_tipo_0_entrata,
  SUM(CASE WHEN tc.id_tipo_conto = 1 THEN t.importo ELSE 0 END) AS importo_conto_tipo_1_entrata,
  SUM(CASE WHEN tc.id_tipo_conto = 2 THEN t.importo ELSE 0 END) AS importo_conto_tipo_2_entrata,
  SUM(CASE WHEN tc.id_tipo_conto = 3 THEN t.importo ELSE 0 END) AS importo_conto_tipo_3_entrata
FROM
  ExamTab 
  JOIN conto co ON  ExamTab .id_cliente = co.id_cliente
  JOIN tipo_conto tc ON co.id_tipo_conto = tc.id_tipo_conto
  LEFT JOIN transazioni t ON co.id_conto = t.id_conto
WHERE
  t.id_tipo_trans<=2   
GROUP BY
   ExamTab .id_cliente;




########## Risultato finale

SELECT 
 ExamTab.ID_cliente,
 ExamTab.ETA,
 transazioni_uscenti.numero_transazioni_uscenti,
 transazioni_entranti.numero_transazioni_entranti,
 importo_uscita.totale_transato,
 importo_entrata.totale_transato,
 totale_conti.totale_conti,
 tipologia_conti.conti_tipo_Base,
 tipologia_conti.conti_tipo_Business,
 tipologia_conti.conti_tipo_Privati,
 tipologia_conti.conti_tipo_Famiglie,
 tipologia_transazioni_uscita.conti_tipo_Amazon,
 tipologia_transazioni_uscita.conti_tipo_Mutuo,
 tipologia_transazioni_uscita.conti_tipo_Hotel,
 tipologia_transazioni_uscita.conti_tipo_Aereo,
 tipologia_transazioni_uscita.conti_tipo_Supermercato,
 tipologia_transazioni_entrata.conti_tipo_Stipendio,
 tipologia_transazioni_entrata.conti_tipo_Pensione,
 tipologia_transazioni_entrata.conti_tipo_Dividenti,
 importo_uscita_tipologia.importo_conto_tipo_0_uscita,
 importo_uscita_tipologia.importo_conto_tipo_1_uscita,
 importo_uscita_tipologia.importo_conto_tipo_2_uscita,
 importo_uscita_tipologia.importo_conto_tipo_3_uscita,
 importo_entrata_tipologia.importo_conto_tipo_0_entrata,
 importo_entrata_tipologia.importo_conto_tipo_1_entrata,
 importo_entrata_tipologia.importo_conto_tipo_2_entrata,
 importo_entrata_tipologia.importo_conto_tipo_3_entrata
FROM ExamTab
LEFT JOIN transazioni_uscenti on ExamTab.ID_cliente =transazioni_uscenti.ID_cliente
LEFT JOIN transazioni_entranti on ExamTab.ID_cliente =transazioni_entranti.ID_cliente
LEFT JOIN importo_uscita on ExamTab.ID_cliente =importo_uscita.ID_cliente
LEFT JOIN importo_entrata on ExamTab.ID_cliente =importo_entrata.ID_cliente
LEFT JOIN totale_conti on ExamTab.ID_cliente =totale_conti.ID_cliente
LEFT JOIN tipologia_conti on ExamTab.ID_cliente =tipologia_conti.ID_cliente
LEFT JOIN tipologia_transazioni_uscita on ExamTab.ID_cliente =tipologia_transazioni_uscita.ID_cliente
LEFT JOIN tipologia_transazioni_entrata on ExamTab.ID_cliente =tipologia_transazioni_entrata.ID_cliente
LEFT JOIN importo_uscita_tipologia on ExamTab.ID_cliente =importo_uscita_tipologia.ID_cliente
LEFT JOIN importo_entrata_tipologia on ExamTab.ID_cliente =importo_entrata_tipologia.ID_cliente;







































