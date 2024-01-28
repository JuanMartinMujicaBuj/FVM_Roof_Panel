tpFinal2_mallanueva.m es el script principal (main).

En éste se encuentran las ecuaciones del problema de FVM.

El mismo llama a caseManager_mallanueva.m, a funciones y a scripts auxiliares,
como get_h_in.m, get_h_out.m, propiedades_materiales.m, etc.

Otros scripts como tpFinal2_surfs.m son versiones parecidas a tpFinal2_mallanueva.m,
pero están destinados a guardar datos para obtener gráficos para el informe.

Los scripts restantes, como resultados_principales.m, sensibilidad_malla.m, etc
utilizan datos obtenidos del solver (tpFinal2_mallanueva.m) para generar gráficos
para el informe.

Dichos datos estan guardados como archivos .mat, cuyos nombres
coinciden con el del script (por ejemplo, resultados_principales.mat,
sensibilidad_malla.mat).