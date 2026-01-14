/*
   Net Tuition and Discount Rate by Term
   Approved on: 20251119
   Calculates net tuition by term by subtracting institutional aid from gross tuition.
   Gross tuition is calculated by applying different discount rates to various tuition detail codes.
   Institutional aid is summed from specific detail codes representing aid amounts.
   Calculates discount rate as the percentage of institutional aid relative to gross tuition.
   The final output includes term ID, gross tuition, total institutional aid, net tuition, and discount rate.
*/
WITH cte_tuition AS (
    /* Calculates gross tuition by applying discount rates to various detail codes */
    SELECT
        tbraccd_term_code AS term_id,
        SUM(
            CASE
                WHEN tbraccd_detail_code IN (
                    '1450','1451','1452','1453','1460','1461','1462','1475','1476','1477',
                    '1478','1479','1480'
                ) THEN tbraccd_amount::numeric * 0.784
                WHEN tbraccd_detail_code IN ('1464','1465','1468') THEN tbraccd_amount::numeric * 0.8533
                WHEN tbraccd_detail_code IN ('1463','1466','1467') THEN tbraccd_amount::numeric * 0.8564
                WHEN tbraccd_detail_code IN (
                    '1469','1470','1471','1472','1473','1474'
                ) THEN tbraccd_amount::numeric * 0.8625
                WHEN tbraccd_detail_code IN (
                    '1900','1901','1902','1903','1904','1905','1906','1907','1908','1909',
                    '1910','1911'
                ) THEN tbraccd_amount::numeric * 0.869
                WHEN tbraccd_detail_code IN ('1914','1917') THEN tbraccd_amount::numeric * 0.8942
                WHEN tbraccd_detail_code IN ('1912','1913','1915','1916') THEN tbraccd_amount::numeric * 0.8964
                WHEN tbraccd_detail_code IN (
                    '1918','1919','1920','1921','1922','1923','1924','1925','1926','1927',
                    '1928','1929'
                ) THEN tbraccd_amount::numeric * 0.90
                WHEN tbraccd_detail_code IN (
                    '1001','1002','1003','1004','1005','1006','1008','1009','1010','1011',
                    '1012','1013','1014','1015','1016','1017','1018','1150','1151','1152',
                    '1153','1154','1155','1200','1201','1250','1255','1256','1257','1260',
                    '1261','1262','1263','1264','1265','1266','1267','1268','1300','1301',
                    '1302','1401','1402','1403','1404','1410','1411','1412','1413','1414',
                    '1415','1416','1417','1601','1603','1605','1620','1621','1622','1623',
                    '1624','1625','1626','1627','1628','1629','1630','1631','1632','1633',
                    '1634','1635','1636','1637','1638','1720','1721','1722'
                ) THEN tbraccd_amount::numeric
                ELSE 0
            END
        ) AS gross_tuition
    FROM banner.tbraccd
    WHERE tbraccd_term_code >= '201940'
      AND tbraccd_term_code <> 'ARTERM' -- non-student AR
    GROUP BY tbraccd_term_code
),
cte_institutional_aid AS (
    /* Calculates institutional aid from specific detail codes */
    SELECT
        tbraccd_term_code AS term_id,
        SUM(
            CASE
                WHEN tbraccd_detail_code IN (
                    '8003','8008','8012','8013','8014','8015','8016','8017','8020','8021',
                    '8022','8023','8024','8025','8026','8029','8030','8034','8035','8036',
                    '8037','8058','8061','8084','8106','8107','8108','8119','8140','8141',
                    '8142','8143','8144','8145','8146','8147','8148','8149','8150','8151',
                    '8152','8154','8155','8156','8158','8159','8160','8161','8162','8163',
                    '8164','8166','8167','8168','8170','8171','8172','8173','8174','8175',
                    '8176','8177','8188','8220','8317','8318','8325','8326','8327','8356',
                    '8361','8362','8381','8405','8429','8539','8559','8571','8572','8936',
                    '8944','8945','8946','7005','8127','8183','8190','8191','8194','8211',
                    '8246','8299','8901','8908','8919','8924','8956','8958','8968','8978',
                    '7056'
                )
                THEN tbraccd_amount::numeric
                ELSE 0
            END
        ) AS institutional_aid
    FROM banner.tbraccd
    WHERE tbraccd_term_code >= '201940'
      AND tbraccd_term_code <> 'ARTERM'
    GROUP BY tbraccd_term_code
)
SELECT
    a.term_id,
    a.gross_tuition,
    COALESCE(b.institutional_aid, 0) AS total_inst_aid, -- Net tuition = gross tuition - institutional aid
    ROUND(a.gross_tuition - COALESCE(b.institutional_aid, 0), 2) AS net_tuition, -- Discount rate = institutional aid / gross * 100
    ROUND(
        CASE
            WHEN a.gross_tuition > 0
                THEN (COALESCE(b.institutional_aid, 0) / a.gross_tuition) * 100
            ELSE 0
        END
    , 2) AS discount_rate
FROM cte_tuition a
LEFT JOIN cte_institutional_aid b
  ON a.term_id = b.term_id
WHERE a.gross_tuition > 0
ORDER BY a.term_id;
