# ----------------------------------------
# Estudiante: José Quintana
# CI: 31.471.822
# Profesor: José Canache
# Practica 3
# ----------------------------------------

.eqv LUZ_CONTROL 0xFFFF0000
.eqv LUZ_ESTADO  0xFFFF0004
.eqv LUZ_DATOS   0xFFFF0008

.text 
main:
    jal InicializarSensorLuz
    jal LeerLuminosidad
    
    # El valor quedará en $v0 y el estado en $v1
    li $v0, 10      # Salida del programa
    syscall
    
# Procedimiento: InicializarSensorLuz
InicializarSensorLuz:
    li $t0, LUZ_CONTROL
    li $t1, 1
    sw $t1, 0($t0)          # Escribir 0x1 para inicializar

    li $t0, LUZ_ESTADO      # Cargar dirección de estado para el bucle
esperar_listo:
    lw $t1, 0($t0)          # Leer LuzEstado
    beq $t1, $zero, esperar_listo # Si es 0 (no listo), seguir esperando
    # Nota: Si es -1 o 1, sale del bucle según la lógica de inicialización básica
    jr $ra

# Procedimiento: LeerLuminosidad
# Retorna: 
#   $v0: Valor de luminosidad (0-1023) si tiene éxito.
#   $v1: Código de estado (0: éxito, -1: error).
LeerLuminosidad:
    li $t0, LUZ_ESTADO
    lw $t1, 0($t0)          # Leer estado actual

    # Verificar si hay error de hardware (-1)
    li $t2, -1
    beq $t1, $t2, error_hw

    # Verificar si la lectura está disponible (1)
    li $t2, 1
    bne $t1, $t2, lectura_no_disponible

    # Lectura correcta
    li $t0, LUZ_DATOS
    lw $v0, 0($t0)          # $v0 = valor de luminosidad
    li $v1, 0               # $v1 = código de éxito (0)
    jr $ra

error_hw:
    li $v0, 0               # Valor por defecto
    li $v1, -1              # Código de error (-1)
    jr $ra

lectura_no_disponible:
    # Manejar si se llama a leer cuando el sensor no está listo
    li $v1, -1
    jr $ra
