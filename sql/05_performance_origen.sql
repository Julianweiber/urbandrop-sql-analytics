SELECT
    st.store_name,
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

INNER JOIN stores st
    ON s.origin_store_id = st.store_id

GROUP BY
    st.store_name

ORDER BY
    sla_pct ASC;