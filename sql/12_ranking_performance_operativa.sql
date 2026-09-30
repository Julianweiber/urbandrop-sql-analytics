WITH performance_courier_zona AS (
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
            AVG(
                EXTRACT(
                    EPOCH FROM (s.delivered_at - s.promised_delivery_at)
                ) / 3600
            ) FILTER (
                WHERE s.delivered_at > s.promised_delivery_at
            ),
            2
        ) AS atraso_promedio_horas

    FROM shipments s

    INNER JOIN couriers c
        ON s.courier_id = c.courier_id

    INNER JOIN orders o
        ON s.order_id = o.order_id

    GROUP BY
        c.courier_name,
        o.customer_zone

    HAVING COUNT(*) >= 100
)

SELECT
    courier_name,
    customer_zone,
    total_envios,
    sla_pct,
    costo_promedio,
    atraso_promedio_horas,

    RANK() OVER (
        ORDER BY sla_pct DESC
    ) AS ranking_sla

FROM performance_courier_zona

ORDER BY
    ranking_sla;