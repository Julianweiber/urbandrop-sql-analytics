SELECT
    i.incident_type,

    COUNT(*) AS total_incidentes,

    ROUND(
        AVG(i.incident_cost),
        2
    ) AS costo_promedio,

    ROUND(
        SUM(i.incident_cost),
        2
    ) AS costo_total,

    ROUND(
        AVG(i.resolution_hours),
        2
    ) AS resolucion_promedio_horas

FROM incidents i

GROUP BY
    i.incident_type

ORDER BY
    costo_total DESC;