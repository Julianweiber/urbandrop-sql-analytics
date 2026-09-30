SELECT
    c.courier_name,
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
    ) AS intentos_promedio

FROM shipments s

INNER JOIN couriers c
    ON s.courier_id = c.courier_id

INNER JOIN orders o
    ON s.order_id = o.order_id

GROUP BY
    c.courier_name,
    o.customer_zone

ORDER BY
    sla_pct ASC;