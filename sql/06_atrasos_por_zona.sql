SELECT
    o.customer_zone,

    COUNT(*) FILTER (
        WHERE s.delivered_at IS NOT NULL
    ) AS envios_entregados,

    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (s.delivered_at - s.promised_delivery_at)
            ) / 3600
        ) FILTER (
            WHERE s.delivered_at > s.promised_delivery_at
        ),
        2
    ) AS atraso_promedio_horas,

    ROUND(
        MAX(
            EXTRACT(
                EPOCH FROM (s.delivered_at - s.promised_delivery_at)
            ) / 3600
        ) FILTER (
            WHERE s.delivered_at > s.promised_delivery_at
        ),
        2
    ) AS atraso_maximo_horas

FROM shipments s

INNER JOIN orders o
    ON s.order_id = o.order_id

GROUP BY
    o.customer_zone

ORDER BY
    atraso_promedio_horas DESC;