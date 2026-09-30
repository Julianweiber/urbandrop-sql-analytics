WITH performance_mensual AS (
    SELECT
        DATE_TRUNC('month', dispatch_at)::date AS mes,
        COUNT(*) AS total_envios,

        ROUND(
            100.0 * AVG(CASE WHEN sla_met THEN 1 ELSE 0 END),
            2
        ) AS sla_pct,

        ROUND(
            AVG(shipping_cost),
            2
        ) AS costo_promedio

    FROM shipments

    WHERE dispatch_at < '2026-09-01'

    GROUP BY
        DATE_TRUNC('month', dispatch_at)
)

SELECT
    mes,
    total_envios,
    sla_pct,
    costo_promedio,

    ROUND(
        sla_pct - LAG(sla_pct) OVER (ORDER BY mes),
        2
    ) AS variacion_sla_pp,

    ROUND(
        costo_promedio - LAG(costo_promedio) OVER (ORDER BY mes),
        2
    ) AS variacion_costo

FROM performance_mensual

ORDER BY mes;