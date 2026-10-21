import 'dart:ui';
import 'package:aprende_mas/config/utils/general_utils.dart';
import 'package:aprende_mas/config/utils/app_theme.dart';
import 'package:aprende_mas/models/models.dart';

class Group {
  final int? grupoId;
  final String nombreGrupo;
  final String? descripcion;
  final String? codigoAcceso;
  // final String codigoColor;
  final List<Subject>? materias;
  final List<NoticeModel>? avisos;

  Group({
    this.grupoId,
    required this.nombreGrupo,
    this.descripcion,
    this.codigoAcceso,
    // required this.codigoColor,
    this.materias,
    this.avisos,
  });

  static Group empty() => Group(
        grupoId: -1,
        descripcion: '',
        nombreGrupo: '',
        codigoAcceso: '',
        avisos: [],
      );

  static List<Group> groupsJsonToEntityList(
      List<Map<String, dynamic>> groupsAndSubject) {
    List<Group> groups = [];

    for (var group in groupsAndSubject) {
      List<Subject> materias =
        ((group['Materias'] ?? group['materias']) as List? ?? []).map((materia) {
        List<Activity> actividades =
        ((materia['Actividades'] ?? materia['actividades']) as List? ?? []).map((actividad) {
          return Activity(
          activityId:
            actividad['ActividadId'] ?? actividad['actividadId'],
          nombreActividad: (actividad['NombreActividad'] ??
              actividad['nombreActividad']) as String? ??
            '',
          descripcion: actividad['Descripcion'] as String? ?? actividad['descripcion'] as String? ?? '',
          tipoActividadId: actividad['TipoActividadId'] ?? actividad['tipoActividadId'],
          fechaCreacion: formatDate((actividad['FechaCreacion'] ?? actividad['fechaCreacion']) as String? ?? ''),
          fechaLimite: formatDate((actividad['FechaLimite'] ?? actividad['fechaLimite']) as String? ?? ''),
          puntaje: actividad['Puntaje'] ?? actividad['puntaje'],
          materiaId: materia['MateriaId'] ?? materia['materiaId']);
        }).toList();

        return Subject(
        materiaId: materia['MateriaId'] ?? materia['materiaId'],
        nombreMateria: (materia['NombreMateria'] ??
            materia['nombreMateria']) as String? ?? '',
        descripcion: (materia['Descripcion'] ?? materia['descripcion']) as String? ?? '',
        codigoColor: (materia['CodigoColor'] ?? materia['codigoColor']) as String? ?? '',
        codigoAcceso: (materia['CodigoAcceso'] ?? materia['codigoAcceso']) as String? ?? '',
          actividades: actividades,
        );
      }).toList();

      groups.add(Group(
      grupoId: group['GrupoId'] ?? group['grupoId'],
      nombreGrupo: (group['NombreGrupo'] ?? group['nombreGrupo']) as String? ?? '',
      descripcion: (group['Descripcion'] ?? group['descripcion']) as String? ?? '',
      codigoAcceso: (group['CodigoAcceso'] ?? group['codigoAcceso']) as String? ?? '',
        // codigoColor: mainColorToHex,
        materias: materias,
      ));
    }
    return groups;
  }

  static Group mapToEntity(Map<String, dynamic> map) => Group(
      grupoId: map['grupoId'],
      nombreGrupo: map['nombreGrupo'],
      descripcion: map['descripcion'],
      codigoAcceso: map['codigoAcceso'],
      materias: Subject.subjectsJsonToEntityList(
        (map['materias'] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList(),
      ));

  static Group groupToEntity(Map<String, dynamic> group) {
    List<Subject> materias = (group['Materias'] as List? ?? []).map((materia) {
      final materiaMap = materia as Map<String, dynamic>;
      return Subject(
        materiaId: materiaMap['MateriaId'],
        nombreMateria: materiaMap['NombreMateria'],
        descripcion: materiaMap['Descripcion'] ?? "",
        codigoAcceso: materiaMap['CodigoAcceso'],
        codigoColor: materiaMap['CodigoColor'],
        actividades: (materiaMap['Actividades'] as List? ?? []).map((actividad) {
          final actividadMap = actividad as Map<String, dynamic>;
          return Activity(
            activityId: actividadMap['ActividadId'],
            nombreActividad: actividadMap['NombreActividad'],
            descripcion: actividadMap['Descripcion'],
            tipoActividadId: actividadMap['TipoActividadId'],
            fechaCreacion: formatDate(actividadMap['FechaCreacion']),
            fechaLimite: formatDate(actividadMap['FechaLimite']),
            puntaje: actividadMap['Puntaje'],
            materiaId: materiaMap['MateriaId'], // Usar el materiaId del Subject padre
          );
        }).toList(),
      );
    }).toList();

    return Group(
      grupoId: group['GrupoId'],
      nombreGrupo: group['NombreGrupo'],
      descripcion: group['Descripcion'],
      codigoAcceso: group['CodigoAcceso'],
      materias: materias,
    );
  }

  static Group queryToEntityGroup(Map<String, Object?> queryGroup) {
    final group = queryGroup as Group;
    return Group(
      nombreGrupo: group.nombreGrupo,
      descripcion: group.descripcion,
      codigoAcceso: group.codigoAcceso,
      // codigoColor: group.codigoColor
    );
  }

  Group copyWith({
    int? grupoId,
    String? nombreGrupo,
    String? descripcion,
    String? codigoAcceso,
    List<Subject>? materias,
  }) {
    return Group(
      grupoId: grupoId ?? this.grupoId,
      nombreGrupo: nombreGrupo ?? this.nombreGrupo,
      descripcion: descripcion ?? this.descripcion,
      codigoAcceso: codigoAcceso ?? this.codigoAcceso,
      materias: materias ?? this.materias,
    );
  }
}
