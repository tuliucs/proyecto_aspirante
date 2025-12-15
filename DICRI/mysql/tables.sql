SET NAMES utf8mb4;
SET time_zone = '-06:00';

-- ==========================================
-- 1) Catálogos (2 tablas)
-- ==========================================
CREATE TABLE catalogo (
  id_catalogo BIGINT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(80) NOT NULL,          -- EJ: ESTADO_CASO, TIPO_INDICIO, PRIORIDAD
  nombre VARCHAR(120) NOT NULL,
  descripcion VARCHAR(255) NULL,
  activo TINYINT NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_catalogo_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE catalogo_detalle (
  id_catalogo_detalle BIGINT PRIMARY KEY AUTO_INCREMENT,
  catalogo_id BIGINT NOT NULL,
  codigo VARCHAR(80) NULL,              -- EJ: ABIERTO, CERRADO, ALTA, BAJA
  nombre VARCHAR(120) NOT NULL,
  orden INT NOT NULL DEFAULT 0,
  activo TINYINT NOT NULL DEFAULT 1,

  UNIQUE KEY uk_cat_det_codigo (catalogo_id, codigo),
  KEY idx_cat_det_catalogo (catalogo_id),
  KEY idx_cat_det_activo (activo),

  CONSTRAINT fk_cat_det_catalogo
    FOREIGN KEY (catalogo_id) REFERENCES catalogo(id_catalogo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 2) Organización / Seguridad
-- ==========================================
CREATE TABLE dependencia (
  id_dependencia BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(180) NOT NULL,
  tipo VARCHAR(80) NOT NULL,
  region VARCHAR(120) NULL,
  departamento VARCHAR(120) NULL,
  municipio VARCHAR(120) NULL,
  direccion VARCHAR(220) NULL,
  telefono VARCHAR(40) NULL,
  activo TINYINT NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_dependencia_nombre_tipo (nombre, tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rol (
  id_rol BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(80) NOT NULL,
  descripcion VARCHAR(255) NULL,
  UNIQUE KEY uk_rol_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE permiso (
  id_permiso BIGINT PRIMARY KEY AUTO_INCREMENT,
  codigo VARCHAR(120) NOT NULL,
  descripcion VARCHAR(255) NULL,
  UNIQUE KEY uk_permiso_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE rol_permiso (
  rol_id BIGINT NOT NULL,
  permiso_id BIGINT NOT NULL,
  PRIMARY KEY (rol_id, permiso_id),
  CONSTRAINT fk_rol_permiso_rol FOREIGN KEY (rol_id) REFERENCES rol(id_rol),
  CONSTRAINT fk_rol_permiso_permiso FOREIGN KEY (permiso_id) REFERENCES permiso(id_permiso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE usuario (
  id_usuario BIGINT PRIMARY KEY AUTO_INCREMENT,
  dependencia_id BIGINT NOT NULL,
  rol_id BIGINT NOT NULL,
  nombres VARCHAR(120) NOT NULL,
  apellidos VARCHAR(120) NOT NULL,
  username VARCHAR(80) NOT NULL,
  email VARCHAR(160) NULL,
  password_hash VARCHAR(255) NOT NULL,
  estado VARCHAR(30) NOT NULL DEFAULT 'ACTIVO',
  firma_digital TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_usuario_username (username),
  UNIQUE KEY uk_usuario_email (email),
  KEY idx_usuario_dependencia (dependencia_id),
  KEY idx_usuario_rol (rol_id),

  CONSTRAINT fk_usuario_dependencia FOREIGN KEY (dependencia_id) REFERENCES dependencia(id_dependencia),
  CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES rol(id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 3) Caso / Escena
-- ==========================================
CREATE TABLE caso (
  id_caso BIGINT PRIMARY KEY AUTO_INCREMENT,
  fiscalia_id BIGINT NOT NULL,
  fiscal_asignado_id BIGINT NOT NULL,
  numero_expediente VARCHAR(80) NOT NULL,

  -- catalogos (detalle)
  tipo_delito_id BIGINT NOT NULL,    -- CATALOGO: TIPO_DELITO
  estado_id BIGINT NOT NULL,         -- CATALOGO: ESTADO_CASO

  fecha_hora_hecho DATETIME NULL,
  lugar_hecho VARCHAR(240) NULL,
  descripcion_hechos TEXT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_caso_numero_expediente (numero_expediente),
  KEY idx_caso_fiscalia (fiscalia_id),
  KEY idx_caso_fiscal (fiscal_asignado_id),
  KEY idx_caso_estado (estado_id),
  KEY idx_caso_tipo_delito (tipo_delito_id),

  CONSTRAINT fk_caso_dependencia FOREIGN KEY (fiscalia_id) REFERENCES dependencia(id_dependencia),
  CONSTRAINT fk_caso_fiscal FOREIGN KEY (fiscal_asignado_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_caso_tipo_delito FOREIGN KEY (tipo_delito_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_caso_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE escena (
  id_escena BIGINT PRIMARY KEY AUTO_INCREMENT,
  caso_id BIGINT NOT NULL,

  fecha_hora_inicio DATETIME NULL,
  fecha_hora_fin DATETIME NULL,
  ubicacion_detalle VARCHAR(240) NULL,
  latitud DECIMAL(10,7) NULL,
  longitud DECIMAL(10,7) NULL,

  tipo_escena_id BIGINT NULL,        -- CATALOGO: TIPO_ESCENA
  observaciones TEXT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  KEY idx_escena_caso (caso_id),
  KEY idx_escena_tipo (tipo_escena_id),

  CONSTRAINT fk_escena_caso FOREIGN KEY (caso_id) REFERENCES caso(id_caso),
  CONSTRAINT fk_escena_tipo FOREIGN KEY (tipo_escena_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE escena_equipo (
  escena_id BIGINT NOT NULL,
  usuario_id BIGINT NOT NULL,
  rol_en_escena VARCHAR(80) NULL,
  PRIMARY KEY (escena_id, usuario_id),
  CONSTRAINT fk_escena_equipo_escena FOREIGN KEY (escena_id) REFERENCES escena(id_escena),
  CONSTRAINT fk_escena_equipo_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 4) Indicio / Custodia / Bodega
-- ==========================================
CREATE TABLE indicio (
  id_indicio BIGINT PRIMARY KEY AUTO_INCREMENT,
  caso_id BIGINT NOT NULL,
  escena_id BIGINT NOT NULL,

  codigo_indicio VARCHAR(80) NOT NULL,     -- QR/Barcode
  tipo_indicio_id BIGINT NOT NULL,         -- CATALOGO: TIPO_INDICIO

  descripcion TEXT NULL,
  cantidad DECIMAL(12,3) NULL,
  unidad_medida VARCHAR(40) NULL,

  fecha_hora_recoleccion DATETIME NULL,
  recolectado_por_id BIGINT NOT NULL,

  metodo_recoleccion_id BIGINT NULL,       -- CATALOGO: METODO_RECOLECCION
  embalaje_tipo_id BIGINT NULL,            -- CATALOGO: TIPO_EMBALAJE
  precinto_numero VARCHAR(80) NULL,

  riesgo_biohazard TINYINT NOT NULL DEFAULT 0,
  estado_id BIGINT NOT NULL,               -- CATALOGO: ESTADO_INDICIO

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_indicio_codigo (codigo_indicio),
  KEY idx_indicio_caso (caso_id),
  KEY idx_indicio_escena (escena_id),
  KEY idx_indicio_tipo (tipo_indicio_id),
  KEY idx_indicio_estado (estado_id),
  KEY idx_indicio_recolectado_por (recolectado_por_id),

  CONSTRAINT fk_indicio_caso FOREIGN KEY (caso_id) REFERENCES caso(id_caso),
  CONSTRAINT fk_indicio_escena FOREIGN KEY (escena_id) REFERENCES escena(id_escena),
  CONSTRAINT fk_indicio_tipo FOREIGN KEY (tipo_indicio_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_indicio_recolector FOREIGN KEY (recolectado_por_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_indicio_metodo FOREIGN KEY (metodo_recoleccion_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_indicio_embalaje FOREIGN KEY (embalaje_tipo_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_indicio_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cadena_custodia (
  id_cadena BIGINT PRIMARY KEY AUTO_INCREMENT,
  indicio_id BIGINT NOT NULL,
  fecha_apertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  responsable_inicial_id BIGINT NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVA',
  observaciones TEXT NULL,

  UNIQUE KEY uk_cadena_indicio (indicio_id),
  KEY idx_cadena_responsable (responsable_inicial_id),

  CONSTRAINT fk_cadena_indicio FOREIGN KEY (indicio_id) REFERENCES indicio(id_indicio),
  CONSTRAINT fk_cadena_responsable FOREIGN KEY (responsable_inicial_id) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ubicacion (
  id_ubicacion BIGINT PRIMARY KEY AUTO_INCREMENT,
  dependencia_id BIGINT NOT NULL,
  tipo VARCHAR(60) NOT NULL,         -- bodega, laboratorio, refrigeracion, digital, etc.
  nombre VARCHAR(160) NOT NULL,
  descripcion VARCHAR(255) NULL,
  activo TINYINT NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  KEY idx_ubicacion_dependencia (dependencia_id),
  KEY idx_ubicacion_tipo (tipo),

  CONSTRAINT fk_ubicacion_dependencia FOREIGN KEY (dependencia_id) REFERENCES dependencia(id_dependencia)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movimiento_custodia (
  id_movimiento BIGINT PRIMARY KEY AUTO_INCREMENT,
  cadena_id BIGINT NOT NULL,

  tipo_movimiento_id BIGINT NOT NULL,   -- CATALOGO: TIPO_MOVIMIENTO_CUSTODIA
  fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  de_usuario_id BIGINT NULL,
  a_usuario_id BIGINT NULL,
  de_dependencia_id BIGINT NULL,
  a_dependencia_id BIGINT NULL,
  origen_ubicacion_id BIGINT NULL,
  destino_ubicacion_id BIGINT NULL,

  condicion_sello VARCHAR(60) NULL,
  acta_numero VARCHAR(80) NULL,
  motivo VARCHAR(180) NULL,
  observaciones TEXT NULL,

  KEY idx_mov_cadena (cadena_id),
  KEY idx_mov_fecha (fecha_hora),
  KEY idx_mov_tipo (tipo_movimiento_id),
  KEY idx_mov_de_usuario (de_usuario_id),
  KEY idx_mov_a_usuario (a_usuario_id),
  KEY idx_mov_origen_ubic (origen_ubicacion_id),
  KEY idx_mov_destino_ubic (destino_ubicacion_id),

  CONSTRAINT fk_mov_cadena FOREIGN KEY (cadena_id) REFERENCES cadena_custodia(id_cadena),
  CONSTRAINT fk_mov_tipo FOREIGN KEY (tipo_movimiento_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_mov_de_usuario FOREIGN KEY (de_usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_mov_a_usuario FOREIGN KEY (a_usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_mov_de_dep FOREIGN KEY (de_dependencia_id) REFERENCES dependencia(id_dependencia),
  CONSTRAINT fk_mov_a_dep FOREIGN KEY (a_dependencia_id) REFERENCES dependencia(id_dependencia),
  CONSTRAINT fk_mov_origen_ubic FOREIGN KEY (origen_ubicacion_id) REFERENCES ubicacion(id_ubicacion),
  CONSTRAINT fk_mov_destino_ubic FOREIGN KEY (destino_ubicacion_id) REFERENCES ubicacion(id_ubicacion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ingreso_bodega (
  id_ingreso BIGINT PRIMARY KEY AUTO_INCREMENT,
  indicio_id BIGINT NOT NULL,
  ubicacion_id BIGINT NOT NULL,
  fecha_ingreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  responsable_recibe_id BIGINT NOT NULL,

  condicion_empaque VARCHAR(80) NULL,
  observaciones TEXT NULL,

  KEY idx_ingreso_indicio (indicio_id),
  KEY idx_ingreso_ubicacion (ubicacion_id),
  KEY idx_ingreso_fecha (fecha_ingreso),

  CONSTRAINT fk_ingreso_indicio FOREIGN KEY (indicio_id) REFERENCES indicio(id_indicio),
  CONSTRAINT fk_ingreso_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(id_ubicacion),
  CONSTRAINT fk_ingreso_recibe FOREIGN KEY (responsable_recibe_id) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 5) Solicitudes / Asignaciones
-- ==========================================
CREATE TABLE solicitud_peritaje (
  id_solicitud BIGINT PRIMARY KEY AUTO_INCREMENT,
  caso_id BIGINT NOT NULL,

  solicitante_usuario_id BIGINT NULL,
  solicitante_dependencia_id BIGINT NULL,

  tipo_solicitud_id BIGINT NOT NULL,   -- CATALOGO: TIPO_SOLICITUD
  prioridad_id BIGINT NOT NULL,        -- CATALOGO: PRIORIDAD
  estado_id BIGINT NOT NULL,           -- CATALOGO: ESTADO_SOLICITUD

  fecha_solicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_requerida DATETIME NULL,

  observaciones TEXT NULL,

  KEY idx_solicitud_caso (caso_id),
  KEY idx_solicitud_tipo (tipo_solicitud_id),
  KEY idx_solicitud_prioridad (prioridad_id),
  KEY idx_solicitud_estado (estado_id),
  KEY idx_solicitud_fecha (fecha_solicitud),

  CONSTRAINT fk_solicitud_caso FOREIGN KEY (caso_id) REFERENCES caso(id_caso),
  CONSTRAINT fk_solicitud_solicitante_usuario FOREIGN KEY (solicitante_usuario_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_solicitud_solicitante_dep FOREIGN KEY (solicitante_dependencia_id) REFERENCES dependencia(id_dependencia),
  CONSTRAINT fk_solicitud_tipo FOREIGN KEY (tipo_solicitud_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_solicitud_prioridad FOREIGN KEY (prioridad_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_solicitud_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE asignacion_trabajo (
  id_asignacion BIGINT PRIMARY KEY AUTO_INCREMENT,
  solicitud_id BIGINT NOT NULL,
  responsable_id BIGINT NOT NULL,

  estado_id BIGINT NOT NULL,          -- CATALOGO: ESTADO_ASIGNACION
  fecha_asignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_inicio DATETIME NULL,
  fecha_fin DATETIME NULL,

  observaciones TEXT NULL,

  KEY idx_asignacion_solicitud (solicitud_id),
  KEY idx_asignacion_responsable (responsable_id),
  KEY idx_asignacion_estado (estado_id),

  CONSTRAINT fk_asignacion_solicitud FOREIGN KEY (solicitud_id) REFERENCES solicitud_peritaje(id_solicitud),
  CONSTRAINT fk_asignacion_responsable FOREIGN KEY (responsable_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_asignacion_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 6) Análisis / Informes
-- ==========================================
CREATE TABLE analisis (
  id_analisis BIGINT PRIMARY KEY AUTO_INCREMENT,
  indicio_id BIGINT NOT NULL,

  tipo_analisis_id BIGINT NOT NULL,   -- CATALOGO: TIPO_ANALISIS
  perito_id BIGINT NOT NULL,
  laboratorio_id BIGINT NULL,

  estado_id BIGINT NOT NULL,          -- CATALOGO: ESTADO_ANALISIS

  fecha_inicio DATETIME NULL,
  fecha_fin DATETIME NULL,

  metodologia TEXT NULL,
  resultados_resumen TEXT NULL,
  conclusiones TEXT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  KEY idx_analisis_indicio (indicio_id),
  KEY idx_analisis_tipo (tipo_analisis_id),
  KEY idx_analisis_perito (perito_id),
  KEY idx_analisis_estado (estado_id),
  KEY idx_analisis_laboratorio (laboratorio_id),

  CONSTRAINT fk_analisis_indicio FOREIGN KEY (indicio_id) REFERENCES indicio(id_indicio),
  CONSTRAINT fk_analisis_tipo FOREIGN KEY (tipo_analisis_id) REFERENCES catalogo_detalle(id_catalogo_detalle),
  CONSTRAINT fk_analisis_perito FOREIGN KEY (perito_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_analisis_laboratorio FOREIGN KEY (laboratorio_id) REFERENCES ubicacion(id_ubicacion),
  CONSTRAINT fk_analisis_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE informe_pericial (
  id_informe BIGINT PRIMARY KEY AUTO_INCREMENT,
  caso_id BIGINT NOT NULL,
  solicitud_id BIGINT NOT NULL,

  numero_informe VARCHAR(80) NOT NULL,
  fecha_emision DATETIME NULL,

  emitido_por_id BIGINT NOT NULL,
  aprobado_por_id BIGINT NULL,

  estado_id BIGINT NOT NULL,          -- CATALOGO: ESTADO_INFORME

  archivo_url VARCHAR(255) NULL,
  hash_sha256 CHAR(64) NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,

  UNIQUE KEY uk_informe_numero (numero_informe),
  KEY idx_informe_caso (caso_id),
  KEY idx_informe_solicitud (solicitud_id),
  KEY idx_informe_estado (estado_id),

  CONSTRAINT fk_informe_caso FOREIGN KEY (caso_id) REFERENCES caso(id_caso),
  CONSTRAINT fk_informe_solicitud FOREIGN KEY (solicitud_id) REFERENCES solicitud_peritaje(id_solicitud),
  CONSTRAINT fk_informe_emitido_por FOREIGN KEY (emitido_por_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_informe_aprobado_por FOREIGN KEY (aprobado_por_id) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_informe_estado FOREIGN KEY (estado_id) REFERENCES catalogo_detalle(id_catalogo_detalle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE informe_analisis (
  informe_id BIGINT NOT NULL,
  analisis_id BIGINT NOT NULL,
  PRIMARY KEY (informe_id, analisis_id),
  CONSTRAINT fk_inf_ana_informe FOREIGN KEY (informe_id) REFERENCES informe_pericial(id_informe),
  CONSTRAINT fk_inf_ana_analisis FOREIGN KEY (analisis_id) REFERENCES analisis(id_analisis)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 7) Archivos digitales (integridad)
-- ==========================================
CREATE TABLE archivo_digital (
  id_archivo BIGINT PRIMARY KEY AUTO_INCREMENT,

  indicio_id BIGINT NULL,
  analisis_id BIGINT NULL,

  tipo VARCHAR(40) NOT NULL,                 -- imagen/video/audio/doc/dump/hashlist etc.
  nombre_original VARCHAR(220) NOT NULL,
  url VARCHAR(255) NOT NULL,
  tamano_bytes BIGINT NOT NULL DEFAULT 0,
  hash_sha256 CHAR(64) NOT NULL,
  fecha_carga DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  cargado_por_id BIGINT NOT NULL,

  KEY idx_archivo_indicio (indicio_id),
  KEY idx_archivo_analisis (analisis_id),
  KEY idx_archivo_hash (hash_sha256),
  KEY idx_archivo_fecha (fecha_carga),

  CONSTRAINT fk_archivo_indicio FOREIGN KEY (indicio_id) REFERENCES indicio(id_indicio),
  CONSTRAINT fk_archivo_analisis FOREIGN KEY (analisis_id) REFERENCES analisis(id_analisis),
  CONSTRAINT fk_archivo_usuario FOREIGN KEY (cargado_por_id) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ==========================================
-- 8) Auditoría
-- ==========================================
CREATE TABLE bitacora_auditoria (
  id_evento BIGINT PRIMARY KEY AUTO_INCREMENT,
  usuario_id BIGINT NOT NULL,

  accion VARCHAR(40) NOT NULL,        -- CREATE/UPDATE/DELETE/VIEW/EXPORT/APPROVE/ANNUL etc.
  entidad VARCHAR(80) NOT NULL,       -- nombre tabla o entidad lógica
  registro_id BIGINT NULL,

  fecha_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ip VARCHAR(60) NULL,
  detalle JSON NULL,

  KEY idx_audit_usuario_fecha (usuario_id, fecha_hora),
  KEY idx_audit_entidad_reg (entidad, registro_id),

  CONSTRAINT fk_audit_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
