const { PrismaClient } = require('@prisma/client')
const bcrypt = require('bcryptjs')

const prisma = new PrismaClient()

async function main() {
  console.log('Sembrando datos...')

  const adminPass = await bcrypt.hash('admin123', 10)
  const docentePass = await bcrypt.hash('docente123', 10)
  const alumnoPass = await bcrypt.hash('alumno123', 10)
  const admPass = await bcrypt.hash('personal123', 10)

  const admin = await prisma.usuario.create({
    data: {
      nombre: 'Juan',
      apellido: 'Tovar',
      email: 'admin@utn.mx',
      passwordHash: adminPass,
      rol: 'administrador',
    },
  })

  const usuarioDocente = await prisma.usuario.create({
    data: {
      nombre: 'Carlos',
      apellido: 'López',
      email: 'docente@utn.mx',
      passwordHash: docentePass,
      rol: 'docente',
    },
  })

  const usuarioAlumno = await prisma.usuario.create({
    data: {
      nombre: 'Daniel',
      apellido: 'García',
      email: 'alumno@utn.mx',
      passwordHash: alumnoPass,
      rol: 'alumno',
    },
  })

  const usuarioAdm = await prisma.usuario.create({
    data: {
      nombre: 'María',
      apellido: 'Hernández',
      email: 'personal@utn.mx',
      passwordHash: admPass,
      rol: 'personal_adm',
    },
  })

  await prisma.docente.create({
    data: {
      usuarioId: usuarioDocente.id,
      numEmpleado: 'D-001',
      especialidad: 'Ingeniería de Software',
      departamento: 'IDGS',
    },
  })

  const alumno = await prisma.alumno.create({
    data: {
      usuarioId: usuarioAlumno.id,
      matricula: '2024001',
      carrera: 'IDGS',
      cuatrimestre: '3ro',
      turno: 'Matutino',
      fechaIngreso: new Date('2024-01-15'),
      estatus: 'activo',
    },
  })

  await prisma.personalAdm.create({
    data: {
      usuarioId: usuarioAdm.id,
      numEmpleado: 'PA-001',
      puesto: 'Control Escolar',
      area: 'Servicios Escolares',
    },
  })

  const materia = await prisma.materia.create({
    data: {
      clave: 'BD-301',
      nombre: 'Administración de Base de Datos',
      creditos: 8,
      carrera: 'IDGS',
      cuatrimestre: 3,
    },
  })

  const docente = await prisma.docente.findFirst()

  const inscripcion = await prisma.inscripcion.create({
    data: {
      alumnoId: alumno.id,
      materiaId: materia.id,
      docenteId: docente.id,
      periodo: 'Enero-Abril 2026',
      estatus: 'activo',
    },
  })

  await prisma.calificacion.create({
    data: {
      inscripcionId: inscripcion.id,
      parcial1: 85,
      parcial2: 90,
      parcial3: null,
      resultado: 'sin_calificar',
    },
  })

  console.log('Datos sembrados correctamente')
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })