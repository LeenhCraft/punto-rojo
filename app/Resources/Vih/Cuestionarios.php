<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="row justify-content-start">
    <div class="col-12 col-lg-10">
        <div class="form-container px-5 py-4 m-0">
            <div class="text-center mb-4">
                <h1 class="display-4 font-weight-bold text-primary">
                    <i class="fas fa-heartbeat"></i>
                    Formulario de Seguimiento
                </h1>
                <p class="lead text-muted">Pacientes con VIH - Sistema de Monitoreo</p>
            </div>

            <div class="alert alert-info mb-5">
                <i class="fas fa-info-circle"></i>
                <strong>Información Confidencial:</strong> Este formulario contiene información médica sensible y debe ser tratado con la máxima confidencialidad.
            </div>

            <form id="formularioVIH">
                <!-- Sección 0: Datos del Paciente -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="fas fa-user"></i>
                        1. Datos del Paciente
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="form-group">
                                <label for="nombres" class="font-weight-bold">Nombres: <span class="required">*</span></label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="nombres"
                                    name="nombres"
                                    required />
                                <div class="invalid-feedback">
                                    Por favor ingrese los nombres del paciente.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="form-group">
                                <label for="apellidos" class="font-weight-bold">Apellidos: <span class="required">*</span></label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="apellidos"
                                    name="apellidos"
                                    required />
                                <div class="invalid-feedback">
                                    Por favor ingrese los apellidos del paciente.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <div class="form-group">
                                <label for="tipo_documento" class="font-weight-bold">Tipo de Documento: <span class="required">*</span></label>
                                <select
                                    class="form-control"
                                    id="tipo_documento"
                                    name="tipo_documento"
                                    required>
                                    <option value="">Seleccione...</option>
                                    <option value="DNI">DNI</option>
                                    <option value="CE">Carné de Extranjería</option>
                                    <option value="Pasaporte">Pasaporte</option>
                                </select>
                                <div class="invalid-feedback">
                                    Por favor seleccione el tipo de documento.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="form-group">
                                <label for="numero_documento" class="font-weight-bold">Número de Documento: <span class="required">*</span></label>
                                <input
                                    type="text"
                                    class="form-control"
                                    id="numero_documento"
                                    name="numero_documento"
                                    required />
                                <div class="invalid-feedback">
                                    Por favor ingrese el número de documento.
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="form-group">
                                <label for="fecha_nacimiento" class="font-weight-bold">Fecha de Nacimiento: <span class="required">*</span></label>
                                <input
                                    type="date"
                                    class="form-control"
                                    id="fecha_nacimiento"
                                    name="fecha_nacimiento"
                                    required />
                                <div class="invalid-feedback">
                                    Por favor ingrese la fecha de nacimiento.
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="font-weight-bold mb-3">Estado del Paciente:</label>
                                <div class="form-check-inline mr-4">
                                    <input
                                        class="form-check-input"
                                        type="radio"
                                        name="activo"
                                        id="activo_si"
                                        value="true"
                                        checked />
                                    <label class="form-check-label" for="activo_si">Activo</label>
                                </div>
                                <div class="form-check-inline">
                                    <input
                                        class="form-check-input"
                                        type="radio"
                                        name="activo"
                                        id="activo_no"
                                        value="false" />
                                    <label class="form-check-label" for="activo_no">Inactivo</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Sección 1: Identificación Geográfica -->
                <div class="section-header">
                    <i class="fas fa-map-marker-alt"></i>
                    2. Identificación Geográfica y Establecimiento de Salud
                </div>

                <div class="d-flex mb-4">
                    <div class="form-group col-md-6">
                        <label class="me-4 mb-0">Zona:</label>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="zona" id="urbana" value="urbana">
                            <label class="form-check-label" for="urbana">Urbana</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="zona" id="rural" value="rural">
                            <label class="form-check-label" for="rural">Rural</label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Establecimiento de salud al que pertenece:</label>
                    <div class="checkbox-grid">
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="hospital_moyobamba" value="hospital_moyobamba">
                                <label class="form-check-label" for="hospital_moyobamba">
                                    Hospital II-1 Moyobamba - Barrio Calvario, Moyobamba
                                </label>
                            </div>
                        </div>
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="ps_tahuishco" value="ps_tahuishco">
                                <label class="form-check-label" for="ps_tahuishco">
                                    Puesto de Salud Tahuishco - Microred Lluyllucucha
                                </label>
                            </div>
                        </div>
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="ps_calzada" value="ps_calzada">
                                <label class="form-check-label" for="ps_calzada">
                                    Puesto de Salud Calzada - Microred Calzada
                                </label>
                            </div>
                        </div>
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="ps_san_marcos" value="ps_san_marcos">
                                <label class="form-check-label" for="ps_san_marcos">
                                    Puesto de Salud San Marcos - Microred Soritor
                                </label>
                            </div>
                        </div>
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="cs_habana" value="cs_habana">
                                <label class="form-check-label" for="cs_habana">
                                    Centro de Salud Habana - Microred Habana
                                </label>
                            </div>
                        </div>
                        <div class="custom-checkbox">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="establecimiento" id="cs_jerillo" value="cs_jerillo">
                                <label class="form-check-label" for="cs_jerillo">
                                    Centro de Salud Jerillo - Micro Red Jerillo
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group mt-3 px-2">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="establecimiento" id="otro_establecimiento" value="otro">
                            <label class="form-check-label" for="otro_establecimiento">
                                Otro (especifique):
                            </label>
                        </div>
                        <input
                            type="text"
                            class="form-control mt-2"
                            id="otro_especifique"
                            name="otro_especifique"
                            placeholder="Especifique el establecimiento"
                            disabled
                            style="display: none;">
                    </div>
                </div>

                <!-- Sección 2: Datos Sociodemográficos -->
                <div class="section-header">
                    <i class="fas fa-user"></i>
                    2. Datos Sociodemográficos
                </div>

                <div class="d-flex gap-3 mb-4">
                    <div class="form-group col-md-auto me-4">
                        <label>Sexo:</label>
                        <div class="ms-4 d-flex gap-5">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="sexo" id="masculino" value="masculino">
                                <label class="form-check-label" for="masculino">Masculino</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="sexo" id="femenino" value="femenino">
                                <label class="form-check-label" for="femenino">Femenino</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="sexo" id="otro_sexo" value="otro">
                                <label class="form-check-label" for="otro_sexo">Otro</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col-md-2">
                        <label>Inserte su edad:</label>
                        <div>
                            <input type="number" class="form-control" id="edad" name="edad" placeholder="Edad en años">
                        </div>
                    </div>
                    <div class="form-group col-md-4">
                        <label>Estado civil:</label>
                        <select class="form-control" name="estado_civil">
                            <option value="">Seleccione</option>
                            <option value="soltero">Soltero/a</option>
                            <option value="casado">Casado/a</option>
                            <option value="divorciado">Divorciado/a</option>
                            <option value="viudo">Viudo/a</option>
                            <option value="conviviente">Conviviente</option>
                        </select>
                    </div>
                </div>

                <div class="d-md-flex gap-4">
                    <div class="form-group w-100 mb-4">
                        <label>Nivel educativo:</label>
                        <select class="form-control" name="nivel_educativo">
                            <option value="">Seleccione</option>
                            <option value="ninguno">Ninguno</option>
                            <option value="primaria_incompleta">Primaria incompleta</option>
                            <option value="primaria_completa">Primaria completa</option>
                            <option value="secundaria_incompleta">Secundaria incompleta</option>
                            <option value="secundaria_completa">Secundaria completa</option>
                            <option value="tecnico">Técnico</option>
                            <option value="universitario">Universitario</option>
                        </select>
                    </div>
                    <div class="form-group w-100 mb-4">
                        <label for="ocupacion">Ocupación actual:</label>
                        <input type="text" class="form-control" id="ocupacion" name="ocupacion">
                    </div>
                </div>

                <div class="form-group">
                    <label for="residencia">Lugar de residencia:</label>
                    <input type="text" class="form-control" id="residencia" name="residencia">
                </div>

                <!-- Sección 3: Comportamientos y Factores de Riesgo -->
                <div class="section-header">
                    <i class="fas fa-exclamation-triangle"></i>
                    3. Comportamientos y Factores de Riesgo
                </div>

                <div class="form-group mb-4">
                    <label>¿Usaba preservativos antes del diagnóstico?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativos_antes" id="preservativos_siempre" value="siempre">
                            <label class="form-check-label" for="preservativos_siempre">Siempre</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativos_antes" id="preservativos_veces" value="a_veces">
                            <label class="form-check-label" for="preservativos_veces">A veces</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativos_antes" id="preservativos_nunca" value="nunca">
                            <label class="form-check-label" for="preservativos_nunca">Nunca</label>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <label>¿Ha tenido relaciones sexuales sin protección desde su diagnóstico?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="relaciones_sin_proteccion" id="relaciones_si" value="si">
                            <label class="form-check-label" for="relaciones_si">Sí</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="relaciones_sin_proteccion" id="relaciones_no" value="no">
                            <label class="form-check-label" for="relaciones_no">No</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex mb-4">
                    <div class="form-group col-md-6 pe-2">
                        <label for="parejas_sexuales">Número estimado de parejas sexuales en el último año:</label>
                        <input type="number" class="form-control" id="parejas_sexuales" name="parejas_sexuales" min="0">
                    </div>
                    <div class="form-group col-md-6 ps-2">
                        <label>¿Ha tenido relaciones con personas del mismo sexo?</label>
                        <div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="mismo_sexo" id="mismo_sexo_si" value="si">
                                <label class="form-check-label" for="mismo_sexo_si">Sí</label>
                            </div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="mismo_sexo" id="mismo_sexo_no" value="no">
                                <label class="form-check-label" for="mismo_sexo_no">No</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex mb-4">
                    <div class="form-group col-md-6 pe-2">
                        <label>¿Ha usado drogas inyectables?</label>
                        <div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="drogas_inyectables" id="drogas_si" value="si">
                                <label class="form-check-label" for="drogas_si">Sí</label>
                            </div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="drogas_inyectables" id="drogas_no" value="no">
                                <label class="form-check-label" for="drogas_no">No</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group col-md-6 ps-2">
                        <label>¿Recibió transfusiones en los últimos 5 años?</label>
                        <div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="transfusiones" id="transfusiones_si" value="si">
                                <label class="form-check-label" for="transfusiones_si">Sí</label>
                            </div>
                            <div class="form-check-inline">
                                <input class="form-check-input" type="radio" name="transfusiones" id="transfusiones_no" value="no">
                                <label class="form-check-label" for="transfusiones_no">No</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>¿Tiene antecedentes de infecciones de transmisión sexual (ITS)?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="antecedentes_its" id="its_si" value="si">
                            <label class="form-check-label" for="its_si">Sí</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="antecedentes_its" id="its_no" value="no">
                            <label class="form-check-label" for="its_no">No</label>
                        </div>
                    </div>
                    <div class="form-group mt-2">
                        <label for="its_especificar">Si respondió "Sí", indicar:</label>
                        <input type="text" class="form-control" id="its_especificar" name="its_especificar">
                    </div>
                </div>

                <!-- Sección 4: Información Clínica Relevante -->
                <div class="section-header">
                    <i class="fas fa-stethoscope"></i>
                    4. Información Clínica Relevante
                </div>

                <div class="d-flex mb-4">
                    <div class="form-group col-md-6 pe-2">
                        <label for="fecha_diagnostico">Fecha de diagnóstico de VIH:</label>
                        <input type="date" class="form-control" id="fecha_diagnostico" name="fecha_diagnostico">
                    </div>
                    <div class="form-group col-md-6 ps-2">
                        <label>Tipo de prueba de diagnóstico:</label>
                        <select class="form-control" name="tipo_prueba">
                            <option value="">Seleccione</option>
                            <option value="prueba_rapida">Prueba rápida</option>
                            <option value="elisa">ELISA</option>
                            <option value="western_blot">Western Blot</option>
                            <option value="otro">Otro</option>
                        </select>
                    </div>
                </div>

                <div class="form-group mb-4" style="display: none;">
                    <label for="otro_prueba">Si seleccionó "Otro", especifique:</label>
                    <input type="text" class="form-control" id="otro_prueba" name="otro_prueba">
                </div>

                <div class="form-group mb-4">
                    <label>¿Recibe tratamiento antirretroviral (TAR)?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="tar" id="tar_si" value="si">
                            <label class="form-check-label" for="tar_si">Sí</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="tar" id="tar_no" value="no">
                            <label class="form-check-label" for="tar_no">No</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex mb-4">
                    <div class="form-group col-md-4 pe-2">
                        <label for="fecha_inicio_tar">Fecha de inicio del TAR:</label>
                        <input type="date" class="form-control" id="fecha_inicio_tar" name="fecha_inicio_tar">
                    </div>
                    <div class="form-group col-md-4 px-2">
                        <label for="cd4">Último conteo de CD4 (células/mm³):</label>
                        <input type="number" class="form-control" id="cd4" name="cd4" min="0">
                    </div>
                    <div class="form-group col-md-4 ps-2">
                        <label for="carga_viral">Última carga viral (copias/mL):</label>
                        <input type="number" class="form-control" id="carga_viral" name="carga_viral" min="0">
                    </div>
                </div>

                <div class="form-group mb-4">
                    <label>¿Presenta alguna ITS actualmente?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="its_actual" id="its_actual_si" value="si">
                            <label class="form-check-label" for="its_actual_si">Sí</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="its_actual" id="its_actual_no" value="no">
                            <label class="form-check-label" for="its_actual_no">No</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="its_actual" id="its_actual_no_sabe" value="no_sabe">
                            <label class="form-check-label" for="its_actual_no_sabe">No lo sabe</label>
                        </div>
                    </div>
                </div>

                <!-- Sección 5: Riesgo de Transmisión Actual -->
                <div class="section-header">
                    <i class="fas fa-shield-alt"></i>
                    5. Riesgo de Transmisión Actual
                </div>

                <div class="form-group mb-4">
                    <label>¿Tiene pareja sexual activa actualmente?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="pareja_activa" id="pareja_si" value="si">
                            <label class="form-check-label" for="pareja_si">Sí</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="pareja_activa" id="pareja_no" value="no">
                            <label class="form-check-label" for="pareja_no">No</label>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <label>¿Informa a sus parejas sexuales que tiene VIH?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="informa_parejas" id="informa_siempre" value="siempre">
                            <label class="form-check-label" for="informa_siempre">Siempre</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="informa_parejas" id="informa_veces" value="a_veces">
                            <label class="form-check-label" for="informa_veces">A veces</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="informa_parejas" id="informa_nunca" value="nunca">
                            <label class="form-check-label" for="informa_nunca">Nunca</label>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <label>¿Utiliza preservativo actualmente en sus relaciones sexuales?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativo_actual" id="preservativo_actual_siempre" value="siempre">
                            <label class="form-check-label" for="preservativo_actual_siempre">Siempre</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativo_actual" id="preservativo_actual_veces" value="a_veces">
                            <label class="form-check-label" for="preservativo_actual_veces">A veces</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="preservativo_actual" id="preservativo_actual_nunca" value="nunca">
                            <label class="form-check-label" for="preservativo_actual_nunca">Nunca</label>
                        </div>
                    </div>
                </div>

                <div class="form-group mb-4">
                    <label>¿Sabe si su(s) pareja(s) se ha(n) realizado la prueba de VIH?</label>
                    <div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="pareja_prueba" id="pareja_prueba_si" value="si">
                            <label class="form-check-label" for="pareja_prueba_si">Sí, al menos una vez</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="pareja_prueba" id="pareja_prueba_no" value="no">
                            <label class="form-check-label" for="pareja_prueba_no">No</label>
                        </div>
                        <div class="form-check-inline">
                            <input class="form-check-input" type="radio" name="pareja_prueba" id="pareja_prueba_no_sabe" value="no_sabe">
                            <label class="form-check-label" for="pareja_prueba_no_sabe">No sabe</label>
                        </div>
                    </div>
                </div>

                <!-- Botones de acción -->
                <div class="text-center">
                    <button type="button" class="btn btn-secondary mr-3" onclick="limpiarFormulario()">
                        <i class="fas fa-eraser me-2"></i> Limpiar Formulario
                    </button>
                    <button type="submit" class="btn btn-submit">
                        <i class="fas fa-save me-2"></i> Guardar Información
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal de confirmación -->
<div class="modal fade" id="confirmacionModal" tabindex="-1" style="display: none;" role="dialog" aria-labelledby="confirmacionModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title text-white" id="confirmacionModalLabel">
                    <i class="fas fa-check-circle"></i> Formulario Enviado
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body text-center">
                <i class="fas fa-check-circle text-success" style="font-size: 3rem;"></i>
                <h4 class="mt-3">¡Información guardada exitosamente!</h4>
                <p class="text-muted">Los datos del formulario han sido registrados correctamente en el sistema.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" data-bs-dismiss="modal">Entendido</button>
            </div>
        </div>
    </div>
</div>

<?php footer_web('Template.FooterDashboard', $data); ?>