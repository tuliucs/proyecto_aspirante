USE DICRI_DATABASE;

-- ==========================================================
-- SEED Catálogos (idempotente)
-- ==========================================================

-- Helper: insertar catálogo si no existe
INSERT INTO catalogo (codigo, nombre, descripcion) VALUES
('TIPO_DELITO', 'Tipo de Delito', 'Clasificación general del delito'),
('ESTADO_CASO', 'Estado del Caso', 'Estados del flujo del caso'),
('TIPO_ESCENA', 'Tipo de Escena', 'Clasificación del tipo de escena'),
('TIPO_INDICIO', 'Tipo de Indicio', 'Clasificación del indicio/evidencia'),
('METODO_RECOLECCION', 'Método de Recolección', 'Métodos de levantamiento/recolección'),
('TIPO_EMBALAJE', 'Tipo de Embalaje', 'Contenedor/embalaje utilizado'),
('ESTADO_INDICIO', 'Estado del Indicio', 'Estados del indicio en el ciclo de custodia'),
('TIPO_MOVIMIENTO_CUSTODIA', 'Tipo de Movimiento de Custodia', 'Eventos de cadena de custodia'),
('TIPO_SOLICITUD', 'Tipo de Solicitud de Peritaje', 'Tipos de solicitudes de peritaje'),
('PRIORIDAD', 'Prioridad', 'Prioridad operacional'),
('ESTADO_SOLICITUD', 'Estado de Solicitud', 'Estados de la solicitud'),
('ESTADO_ASIGNACION', 'Estado de Asignación', 'Estados de asignación de trabajo'),
('TIPO_ANALISIS', 'Tipo de Análisis', 'Tipos de análisis/peritajes'),
('ESTADO_ANALISIS', 'Estado de Análisis', 'Estados del análisis'),
('ESTADO_INFORME', 'Estado de Informe', 'Estados del informe pericial')
ON DUPLICATE KEY UPDATE
  nombre = VALUES(nombre),
  descripcion = VALUES(descripcion),
  activo = 1;

-- ==========================================================
-- 1) TIPO_DELITO
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_DELITO');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'HOMICIDIO','Homicidio',10),
(@CAT,'FEMICIDIO','Femicidio',11),
(@CAT,'LESIONES','Lesiones',12),
(@CAT,'ROBO','Robo',20),
(@CAT,'HURTO','Hurto',21),
(@CAT,'EXTORSION','Extorsión',22),
(@CAT,'SECUESTRO','Secuestro',23),
(@CAT,'NARCOTRAFICO','Narcotráfico',30),
(@CAT,'LAVADO_DINERO','Lavado de dinero',31),
(@CAT,'DELITO_SEXUAL','Delitos sexuales',40),
(@CAT,'VIOLENCIA_INTRAFAMILIAR','Violencia intrafamiliar',41),
(@CAT,'ARMAS','Delitos relacionados con armas',50),
(@CAT,'FRAUDE','Fraude/Estafa',60),
(@CAT,'CORRUPCION','Corrupción',61),
(@CAT,'DELITO_INFORMATICO','Delito informático',70),
(@CAT,'OTRO','Otro',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 2) ESTADO_CASO
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_CASO');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'ABIERTO','Abierto',10),
(@CAT,'EN_INVESTIGACION','En investigación',20),
(@CAT,'EN_ANALISIS','En análisis',30),
(@CAT,'INFORME_EMITIDO','Informe emitido',40),
(@CAT,'CERRADO','Cerrado',90),
(@CAT,'ARCHIVADO','Archivado',95),
(@CAT,'ANULADO','Anulado',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 3) TIPO_ESCENA
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_ESCENA');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'ABIERTA','Escena abierta',10),
(@CAT,'CERRADA','Escena cerrada',20),
(@CAT,'VEHICULO','Vehículo',30),
(@CAT,'ACUATICA','Acuática',40),
(@CAT,'INCENDIO','Incendio',50),
(@CAT,'EXPLOSION','Explosión',60),
(@CAT,'DIGITAL','Escena digital',70),
(@CAT,'OTRA','Otra',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 4) TIPO_INDICIO
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_INDICIO');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'BIOLOGICO','Biológico',10),
(@CAT,'MATERIAL','Material/Físico',20),
(@CAT,'BALISTICO','Balístico',30),
(@CAT,'DOCUMENTAL','Documental',40),
(@CAT,'DIGITAL','Digital',50),
(@CAT,'QUIMICO','Químico',60),
(@CAT,'TRAZAS','Trazas/Microindicios',70),
(@CAT,'OTRO','Otro',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 5) METODO_RECOLECCION
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='METODO_RECOLECCION');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'LEVANTAMIENTO_DIRECTO','Levantamiento directo',10),
(@CAT,'HISOPADO','Hisopado',20),
(@CAT,'PINZAS','Recolección con pinzas',30),
(@CAT,'ASPIRACION','Aspiración/Recolector',40),
(@CAT,'MOLDEO','Moldeo/Impresión',50),
(@CAT,'CAPTURA_FORENSE','Captura forense (digital)',60),
(@CAT,'IMAGEN_FORENSE','Imagen forense (disco)',70),
(@CAT,'OTRO','Otro',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 6) TIPO_EMBALAJE
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_EMBALAJE');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'SOBRE_PAPEL','Sobre de papel',10),
(@CAT,'BOLSA_PAPEL','Bolsa de papel',11),
(@CAT,'BOLSA_PLASTICO','Bolsa plástica',20),
(@CAT,'BOLSA_EVIDENCIA','Bolsa de evidencia (sellable)',21),
(@CAT,'CAJA_CARTON','Caja de cartón',30),
(@CAT,'CAJA_RIGIDA','Caja rígida',31),
(@CAT,'TUBO','Tubo/Contenedor tubular',40),
(@CAT,'FRASCO','Frasco/Contenedor hermético',50),
(@CAT,'CONTENEDOR_ESTERIL','Contenedor estéril',60),
(@CAT,'EMBALAJE_ANTIESTATICO','Embalaje antiestático',70),
(@CAT,'OTRO','Otro',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 7) ESTADO_INDICIO
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_INDICIO');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'EN_ESCENA','En escena',10),
(@CAT,'EN_TRASLADO','En traslado',20),
(@CAT,'EN_BODEGA','En bodega',30),
(@CAT,'EN_LABORATORIO','En laboratorio',40),
(@CAT,'EN_ANALISIS','En análisis',50),
(@CAT,'DEVUELTO','Devuelto',80),
(@CAT,'DESTRUIDO','Destruido',90),
(@CAT,'ANULADO','Anulado',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 8) TIPO_MOVIMIENTO_CUSTODIA
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_MOVIMIENTO_CUSTODIA');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'RECOLECCION','Recolección',10),
(@CAT,'ENTREGA','Entrega',20),
(@CAT,'RECEPCION','Recepción',30),
(@CAT,'TRASLADO','Traslado',40),
(@CAT,'ALMACENAJE','Almacenaje',50),
(@CAT,'EGRESO_BODEGA','Egreso de bodega',60),
(@CAT,'INGRESO_LAB','Ingreso a laboratorio',70),
(@CAT,'SALIDA_LAB','Salida de laboratorio',80),
(@CAT,'DEVOLUCION','Devolución',90),
(@CAT,'DESTRUCCION','Destrucción',95),
(@CAT,'RECTIFICACION','Rectificación',98),
(@CAT,'ANULACION','Anulación',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 9) TIPO_SOLICITUD
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_SOLICITUD');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'BALISTICA','Balística',10),
(@CAT,'DACTILOSCOPIA','Dactiloscopía',20),
(@CAT,'ADN','Genética/ADN',30),
(@CAT,'QUIMICA_FORENSE','Química forense',40),
(@CAT,'TOXICOLOGIA','Toxicología',50),
(@CAT,'DOCUMENTOLOGIA','Documentología',60),
(@CAT,'INFORMATICA_FORENSE','Informática forense',70),
(@CAT,'FOTOGRAFIA_FORENSE','Fotografía forense',80),
(@CAT,'ANTROPOLOGIA','Antropología forense',90),
(@CAT,'OTRA','Otra',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 10) PRIORIDAD
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='PRIORIDAD');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'URGENTE','Urgente',10),
(@CAT,'ALTA','Alta',20),
(@CAT,'MEDIA','Media',30),
(@CAT,'BAJA','Baja',40)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 11) ESTADO_SOLICITUD
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_SOLICITUD');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'PENDIENTE','Pendiente',10),
(@CAT,'ASIGNADA','Asignada',20),
(@CAT,'EN_PROCESO','En proceso',30),
(@CAT,'FINALIZADA','Finalizada',80),
(@CAT,'RECHAZADA','Rechazada',90),
(@CAT,'ANULADA','Anulada',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 12) ESTADO_ASIGNACION
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_ASIGNACION');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'ASIGNADA','Asignada',10),
(@CAT,'ACEPTADA','Aceptada',20),
(@CAT,'EN_PROCESO','En proceso',30),
(@CAT,'SUSPENDIDA','Suspendida',40),
(@CAT,'FINALIZADA','Finalizada',80),
(@CAT,'ANULADA','Anulada',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 13) TIPO_ANALISIS
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='TIPO_ANALISIS');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'BALISTICO','Análisis balístico',10),
(@CAT,'DACTILAR','Análisis dactilar',20),
(@CAT,'GENETICO','Análisis genético/ADN',30),
(@CAT,'QUIMICO','Análisis químico',40),
(@CAT,'TOXICOLOGICO','Análisis toxicológico',50),
(@CAT,'DOCS','Análisis documentológico',60),
(@CAT,'FORENSE_DIGITAL','Análisis forense digital',70),
(@CAT,'FOTOGRAFICO','Análisis fotográfico',80),
(@CAT,'OTRO','Otro',999)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 14) ESTADO_ANALISIS
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_ANALISIS');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'PENDIENTE','Pendiente',10),
(@CAT,'EN_PROCESO','En proceso',20),
(@CAT,'EN_REVISION','En revisión',30),
(@CAT,'FINALIZADO','Finalizado',80),
(@CAT,'ANULADO','Anulado',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- 15) ESTADO_INFORME
-- ==========================================================
SET @CAT := (SELECT id_catalogo FROM catalogo WHERE codigo='ESTADO_INFORME');
INSERT INTO catalogo_detalle (catalogo_id, codigo, nombre, orden) VALUES
(@CAT,'BORRADOR','Borrador',10),
(@CAT,'EN_REVISION','En revisión',20),
(@CAT,'APROBADO','Aprobado',30),
(@CAT,'EMITIDO','Emitido',40),
(@CAT,'NOTIFICADO','Notificado',50),
(@CAT,'ANULADO','Anulado',99)
ON DUPLICATE KEY UPDATE nombre=VALUES(nombre), orden=VALUES(orden), activo=1;

-- ==========================================================
-- (Opcional) Verificación rápida
-- ==========================================================
-- SELECT c.codigo, c.nombre, COUNT(d.id_catalogo_detalle) items
-- FROM catalogo c
-- LEFT JOIN catalogo_detalle d ON d.catalogo_id = c.id_catalogo
-- GROUP BY c.id_catalogo
-- ORDER BY c.codigo;
