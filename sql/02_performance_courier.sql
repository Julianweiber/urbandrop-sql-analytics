SELECT
    c.courier_name,
    COUNT(*) AS total_envios,
    ROUND(
        100.0 * AVG(CASE WHEN s.sla_met THEN 1 ELSE 0 END),
        2
    ) AS sla_pct,
    ROUND(AVG(s.shipping_cost), 2) AS costo_promedio,
    ROUND(AVG(s.delivery_attempts), 2) AS intentos_promedio,
    ROUND(
        100.0 * AVG(
            CASE WHEN s.delivery_attempts = 1 THEN 1 ELSE 0 END
        ),
        2
    ) AS primer_intento_pct
FROM shipments s
INNER JOIN couriers c
    ON s.courier_id = c.courier_id
GROUP BY c.courier_name
ORDER BY sla_pct DESC;