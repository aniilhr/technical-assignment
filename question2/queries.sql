/*
===========================================================
Question 2A
How many types of Acacia plants are present in taxonomy?
===========================================================
*/

SELECT COUNT(*) AS acacia_type_count
FROM taxonomy
WHERE species LIKE '%Acacia%';


/*
===========================================================
Question 2B
Which type of wheat has the longest DNA sequence?
===========================================================
*/

SELECT
    tx.species AS wheat_type,
    rf.length AS dna_sequence_length
FROM rfamseq AS rf
JOIN taxonomy AS tx
    ON rf.ncbi_id = tx.ncbi_id
WHERE tx.species LIKE '%wheat%'
ORDER BY rf.length DESC
LIMIT 1;


/*
===========================================================
Question 2C
Family name, accession and maximum DNA sequence length.

Only sequences greater than 1,000,000 are considered.

Results are sorted by maximum sequence length descending.

15 results per page.
Page 9 = OFFSET 120.
===========================================================
*/

SELECT
    f.rfam_acc AS family_accession,
    f.rfam_id AS family_name,
    MAX(rf.length) AS max_sequence_length
FROM family AS f
JOIN full_region AS fr
    ON f.rfam_acc = fr.rfam_acc
JOIN rfamseq AS rf
    ON fr.rfamseq_acc = rf.rfamseq_acc
WHERE rf.length > 1000000
GROUP BY
    f.rfam_acc,
    f.rfam_id
ORDER BY max_sequence_length DESC
LIMIT 15 OFFSET 120;
