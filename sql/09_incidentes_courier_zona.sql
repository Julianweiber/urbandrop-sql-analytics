SELECT
    c.courier_name,
    o.customer_zone,

    COUNT(DISTINCT s.shipment_id) AS envios,
    COUNT(i.incident_id) AS incidentes,

    ROUND(
        100.0 * COUNT(i.incident_id)
        / NULLIF(COUNT(DISTINCT s.shipment_id), 0),
        2
    ) AS incidentes_cada_100_envios,

    ROUND(
        COALESCE(SUM(i.incident_cost), 0),
        2
    ) AS costo_total_incidentes

FROM shipments s

INNER JOIN couriers c
    ON s.courier_id = c.courier_id

INNER JOIN orders o
    ON s.order_id = o.order_id

LEFT JOIN incidents i
    ON s.shipment_id = i.shipment_id

GROUP BY
    c.courier_name,
    o.customer_zone

HAVING COUNT(DISTINCT s.shipment_id) >= 100

ORDER BY
    incidentes_cada_100_envios DESC;