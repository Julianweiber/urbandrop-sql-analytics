SELECT
    o.fulfillment_type,

    COUNT(DISTINCT o.order_id) AS pedidos,
    COUNT(s.shipment_id) AS envios,

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
        AVG(
            EXTRACT(
                EPOCH FROM (s.delivered_at - s.promised_delivery_at)
            ) / 3600
        ) FILTER (
            WHERE s.delivered_at > s.promised_delivery_at
        ),
        2
    ) AS atraso_promedio_horas

FROM orders o

LEFT JOIN shipments s
    ON o.order_id = s.order_id

GROUP BY
    o.fulfillment_type

ORDER BY
    sla_pct DESC NULLS LAST;