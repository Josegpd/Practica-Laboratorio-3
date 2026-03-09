# ----------------------------------------
# Estudiante: José Quintana
# CI: 31.471.822
# Profesor: José Canache
# Practica 3
# ----------------------------------------

.eqv PRESION_CONTROL 0xFFFF0010
.eqv PRESION_ESTADO  0xFFFF0014
.eqv PRESION_DATOS   0xFFFF0018

.text

# Procedimiento: InicializarSensorPresion
InicializarSensorPresion:
    li $t0, PRESION_CONTROL
    li $t1, 0x5
    sw $t1, 0($t0)          # Comando de inicialización 0x5

    li $t0, PRESION_ESTADO
bucle_espera:
    lw $t1, 0($t0)
    beq $t1, $zero, bucle_espera # Si es 0, sigue esperando
    jr $ra


### Procedimiento: LeerPresion
# Retorna: 
#   $v0: Valor de presión.
#   $v1: Estado (0: OK, -1: Error tras reintento).
LeerPresion:
    # Guardar $ra en la pila
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $t0, PRESION_ESTADO
    lw $t1, 0($t0)          # Primera lectura de estado

    # Si el estado es 1 (OK), saltar a lectura
    li $t2, 1
    beq $t1, $t2, exito_lectura

    # Si el estado es -1 (Error), intentar reintento
    li $t2, -1
    beq $t1, $t2, reintento
    
    # Si llega aquí y es 0 (no listo), podríamos decidir fallar o esperar
    j fallo_final

reintento:
    jal InicializarSensorPresion # Re-inicializar
    
    li $t0, PRESION_ESTADO
    lw $t1, 0($t0)          # Segunda lectura de estado postreintento
    li $t2, 1
    bne $t1, $t2, fallo_final # Si sigue fallando, terminar con error

exito_lectura:
    li $t0, PRESION_DATOS
    lw $v0, 0($t0)          # Cargar dato de presión
    li $v1, 0               # Código de éxito
    j fin_leer

fallo_final:
    li $v0, 0
    li $v1, -1              # Código de error persistente

fin_leer:
    # Restaurar $ra y volver
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
