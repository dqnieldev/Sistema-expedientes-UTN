-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('administrador', 'docente', 'alumno', 'personal_adm');

-- CreateEnum
CREATE TYPE "EstatusAlumno" AS ENUM ('activo', 'inactivo', 'egresado', 'baja');

-- CreateEnum
CREATE TYPE "EstatusInscripcion" AS ENUM ('activo', 'cancelado', 'aprobado', 'reprobado');

-- CreateEnum
CREATE TYPE "ResultadoCalificacion" AS ENUM ('aprobado', 'reprobado', 'sin_calificar');

-- CreateEnum
CREATE TYPE "TipoRespaldo" AS ENUM ('manual', 'automatico');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "rol" "Rol" NOT NULL,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "alumnos" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "matricula" TEXT NOT NULL,
    "carrera" TEXT NOT NULL,
    "cuatrimestre" TEXT NOT NULL,
    "turno" TEXT NOT NULL,
    "fecha_ingreso" TIMESTAMP(3) NOT NULL,
    "estatus" "EstatusAlumno" NOT NULL DEFAULT 'activo',

    CONSTRAINT "alumnos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "docentes" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "num_empleado" TEXT NOT NULL,
    "especialidad" TEXT NOT NULL,
    "departamento" TEXT NOT NULL,

    CONSTRAINT "docentes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personal_adm" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "num_empleado" TEXT NOT NULL,
    "puesto" TEXT NOT NULL,
    "area" TEXT NOT NULL,

    CONSTRAINT "personal_adm_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "materias" (
    "id" SERIAL NOT NULL,
    "clave" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "creditos" INTEGER NOT NULL,
    "carrera" TEXT NOT NULL,
    "cuatrimestre" INTEGER NOT NULL,

    CONSTRAINT "materias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "inscripciones" (
    "id" SERIAL NOT NULL,
    "alumno_id" INTEGER NOT NULL,
    "materia_id" INTEGER NOT NULL,
    "docente_id" INTEGER NOT NULL,
    "periodo" TEXT NOT NULL,
    "estatus" "EstatusInscripcion" NOT NULL DEFAULT 'activo',

    CONSTRAINT "inscripciones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "calificaciones" (
    "id" SERIAL NOT NULL,
    "inscripcion_id" INTEGER NOT NULL,
    "parcial1" DECIMAL(65,30),
    "parcial2" DECIMAL(65,30),
    "parcial3" DECIMAL(65,30),
    "final" DECIMAL(65,30),
    "resultado" "ResultadoCalificacion" NOT NULL DEFAULT 'sin_calificar',

    CONSTRAINT "calificaciones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documentos" (
    "id" SERIAL NOT NULL,
    "alumno_id" INTEGER NOT NULL,
    "subido_por" INTEGER NOT NULL,
    "tipo_doc" TEXT NOT NULL,
    "nombre_archivo" TEXT NOT NULL,
    "ruta" TEXT NOT NULL,
    "fecha_subida" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verificado" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "documentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "respaldos" (
    "id" SERIAL NOT NULL,
    "realizado_por" INTEGER NOT NULL,
    "nombre_archivo" TEXT NOT NULL,
    "ruta" TEXT NOT NULL,
    "fecha" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "tipo" "TipoRespaldo" NOT NULL,
    "automatico" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "respaldos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "alumnos_usuario_id_key" ON "alumnos"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "alumnos_matricula_key" ON "alumnos"("matricula");

-- CreateIndex
CREATE UNIQUE INDEX "docentes_usuario_id_key" ON "docentes"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "docentes_num_empleado_key" ON "docentes"("num_empleado");

-- CreateIndex
CREATE UNIQUE INDEX "personal_adm_usuario_id_key" ON "personal_adm"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "personal_adm_num_empleado_key" ON "personal_adm"("num_empleado");

-- CreateIndex
CREATE UNIQUE INDEX "materias_clave_key" ON "materias"("clave");

-- CreateIndex
CREATE UNIQUE INDEX "calificaciones_inscripcion_id_key" ON "calificaciones"("inscripcion_id");

-- AddForeignKey
ALTER TABLE "alumnos" ADD CONSTRAINT "alumnos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "docentes" ADD CONSTRAINT "docentes_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personal_adm" ADD CONSTRAINT "personal_adm_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inscripciones" ADD CONSTRAINT "inscripciones_alumno_id_fkey" FOREIGN KEY ("alumno_id") REFERENCES "alumnos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inscripciones" ADD CONSTRAINT "inscripciones_materia_id_fkey" FOREIGN KEY ("materia_id") REFERENCES "materias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "inscripciones" ADD CONSTRAINT "inscripciones_docente_id_fkey" FOREIGN KEY ("docente_id") REFERENCES "docentes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calificaciones" ADD CONSTRAINT "calificaciones_inscripcion_id_fkey" FOREIGN KEY ("inscripcion_id") REFERENCES "inscripciones"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documentos" ADD CONSTRAINT "documentos_alumno_id_fkey" FOREIGN KEY ("alumno_id") REFERENCES "alumnos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documentos" ADD CONSTRAINT "documentos_subido_por_fkey" FOREIGN KEY ("subido_por") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "respaldos" ADD CONSTRAINT "respaldos_realizado_por_fkey" FOREIGN KEY ("realizado_por") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
