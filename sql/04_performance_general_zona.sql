SELECT
    o.customer_zone,

    COUNT(*) AS total_envios,

    ROUND(
        100.0 * AVG(CASE WHEN s.sla_met THEN 1 ELSE 0 END),
        2
    ) AS sla_pct,

    ROUND(
        AVG(s.shipping_cost),
        2
    ) AS costo_promedio,

    ROUND(
        AVG(s.delivery_attempts),
        2
    ) AS intentos_promedio,

    ROUND(
        100.0 * AVG(
            CASE WHEN s.delivery_attempts = 1 THEN 1 ELSE 0 END
        ),
        2
    ) AS primer_intento_pct

FROM shipments s

INNER JOIN orders o
    ON s.order_id = o.order_id

GROUP BY
    o.customer_zone

ORDER BY
    sla_pct ASC;