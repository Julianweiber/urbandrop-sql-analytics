-- =====================================================
-- URBANDROP | 01 - PERFORMANCE OPERATIVA GENERAL
-- =====================================================

SELECT
    COUNT(*) AS total_envios,

    ROUND(
        100.0 * AVG(CASE WHEN sla_met THEN 1 ELSE 0 END),
        2
    ) AS cumplimiento_sla_pct,

    ROUND(
        AVG(shipping_cost),
        2
    ) AS costo_promedio_envio,

    ROUND(
        AVG(delivery_attempts),
        2
    ) AS intentos_promedio,

    ROUND(
        100.0 * AVG(
            CASE WHEN delivery_attempts = 1 THEN 1 ELSE 0 END
        ),
        2
    ) AS entrega_primer_intento_pct

FROM shipments;