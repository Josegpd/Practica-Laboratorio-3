# ----------------------------------------
# Estudiante: José Quintana
# CI: 31.471.822
# Profesor: José Canache
# Practica 3
# ----------------------------------------

# Definición de constantes para las direcciones de los registros
.eqv TENSION_CONTROL 0xFFFF0020
.eqv TENSION_ESTADO  0xFFFF0024
.eqv TENSION_SISTOL  0xFFFF0028
.eqv TENSION_DIASTOL 0xFFFF002C

.text

# Procedimiento: controlador_tension
# Salidas:
#   $v0: Valor de tensión Sistólica (entero 32 bits)
#   $v1: Valor de tensión Diastólica (entero 32 bits)

controlador_tension:
    # 1. Iniciar la medición
    li $t0, TENSION_CONTROL
    li $t1, 1
    sw $t1, 0($t0)          # Escribir 1 en TensionControl

    # 2. Esperar a que la medición termine (Polling)
    li $t0, TENSION_ESTADO
    li $t2, 1
esperar_medicion:
    lw $t1, 0($t0)          # Leer TensionEstado
    bne $t1, $t2, esperar_medicion # Si el estado NO es 1, sigue esperando

    # 3. Leer los resultados una vez que TensionEstado es 1
    li $t0, TENSION_SISTOL
    lw $v0, 0($t0)          # Cargar resultado Sistólico en $v0

    li $t0, TENSION_DIASTOL
    lw $v1, 0($t0)          # Cargar resultado Diastólico en $v1

    # 4. Retornar al programa principal
    jr $ra
