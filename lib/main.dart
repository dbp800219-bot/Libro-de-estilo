import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Error en la UI:\n${details.exceptionAsString()}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Libro de Estilo',
      home: const HomePage(),
    );
  }
}

// Modelo de datos
class Tema {
  final String id; // ID único para cada tema
  final String categoria;
  final String subtema;
  final String subsubtema;
  final String contenido;
  final List<Map<String, String>> tableData;

  Tema({
    required this.id,
    required this.categoria,
    required this.subtema,
    required this.subsubtema,
    required this.contenido,
    this.tableData = const [],
  });
}

// Modelo para favoritos
class Favorito {
  final String temaId;
  final String nota;

  Favorito({required this.temaId, this.nota = ''});

  Map<String, dynamic> toJson() => {'temaId': temaId, 'nota': nota};

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      temaId: json['temaId'] ?? '',
      nota: json['nota'] ?? '',
    );
  }
}

// Servicio de favoritos
class FavoritosService {
  static const String _key = 'favoritos';

  Future<List<Favorito>> cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritosJson = prefs.getString(_key);

    if (favoritosJson == null) return [];

    final List<dynamic> decoded = json.decode(favoritosJson);
    return decoded.map((item) => Favorito.fromJson(item)).toList();
  }

  Future<void> guardarFavoritos(List<Favorito> favoritos) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(favoritos.map((f) => f.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<void> agregarFavorito(String temaId) async {
    final favoritos = await cargarFavoritos();
    if (!favoritos.any((f) => f.temaId == temaId)) {
      favoritos.add(Favorito(temaId: temaId));
      await guardarFavoritos(favoritos);
    }
  }

  Future<void> eliminarFavorito(String temaId) async {
    final favoritos = await cargarFavoritos();
    favoritos.removeWhere((f) => f.temaId == temaId);
    await guardarFavoritos(favoritos);
  }

  Future<void> actualizarNota(String temaId, String nota) async {
    final favoritos = await cargarFavoritos();
    final index = favoritos.indexWhere((f) => f.temaId == temaId);
    if (index != -1) {
      favoritos[index] = Favorito(temaId: temaId, nota: nota);
      await guardarFavoritos(favoritos);
    }
  }

  Future<bool> esFavorito(String temaId) async {
    final favoritos = await cargarFavoritos();
    return favoritos.any((f) => f.temaId == temaId);
  }

  Future<String> obtenerNota(String temaId) async {
    final favoritos = await cargarFavoritos();
    final favorito = favoritos.firstWhere(
          (f) => f.temaId == temaId,
      orElse: () => Favorito(temaId: ''),
    );
    return favorito.nota;
  }
}

// Lista completa de temas según el índice del libro
final List<Tema> _temasCompletos = [
  // ============ LA CORRECCIÓN ORTOGRÁFICA ============

  // --- LA ACENTUACIÓN ---
  Tema(
    id: 'acentuacion_acento_tilde',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'El acento y la tilde',
    contenido: 'El acento indica la sílaba de mayor intensidad. El español es lengua de acento libre.',
    tableData: [
      {
        'Tipo': 'Agudas',
        'Sílaba': 'Última',
        'Terminación': 'Consonante distinta de n o s',
        'Ejemplos': 'cal, matiz, cordón, inmortalizar',
      },
      {
        'Tipo': 'Llanas',
        'Sílaba': 'Penúltima',
        'Terminación': 'Vocal, n o s',
        'Ejemplos': 'calma, sastre, joven, gafas',
      },
      {
        'Tipo': 'Esdrújulas',
        'Sílaba': 'Antepenúltima',
        'Terminación': '-',
        'Ejemplos': 'trágico, sólido, magnético',
      },
      {
        'Tipo': 'Sobresdrújulas',
        'Sílaba': 'Antes de la antepenúltima',
        'Terminación': '-',
        'Ejemplos': 'consígueselo, comunícamelo',
      },
    ],
  ),
  Tema(
    id: 'acentuacion_diptongos_hiatos',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'La tilde en los diptongos e hiatos',
    contenido: 'En los diptongos, la tilde se coloca sobre la vocal abierta. En los hiatos, se acentúa la vocal cerrada cuando va sola: río, frío, caída, baúl, reír.',
  ),
  Tema(
    id: 'acentuacion_diacritica',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'La tilde diacrítica',
    contenido: 'La tilde diacrítica se usa para distinguir palabras de igual forma pero diferente significado o función gramatical.\n\nEjemplos: sí (afirmación) / si (condicional), té (bebida) / te (pronombre), él (pronombre) / el (artículo), más (cantidad) / mas (pero).',
  ),
  Tema(
    id: 'acentuacion_palabras_compuestas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'Acentuación de las palabras compuestas',
    contenido: 'En las palabras compuestas, solo el último componente puede llevar tilde según las reglas de acentuación: baloncesto, subibajas, decimoséptimo.',
  ),
  Tema(
    id: 'acentuacion_latinismos_extranjerismos',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'Acentuación de los latinismos y extranjerismos',
    contenido: 'Los latinismos y extranjerismos adaptados al español siguen las reglas de acentuación normales: déficit, accésit, élite, estrés.',
  ),
  Tema(
    id: 'acentuacion_errores_frecuentes',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'La acentuación',
    subsubtema: 'Errores frecuentes de acentuación',
    contenido: 'Errores comunes: solo (debe escribirse sin tilde en la mayoría de casos), guion (sin tilde), eje (sin tilde), período vs período.',
  ),

  // --- ORTOGRAFÍA DE LAS LETRAS ---
  Tema(
    id: 'ortografia_letras_general',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Ortografía de las letras',
    subsubtema: 'Reglas de ortografía de las letras',
    contenido: 'La ortografía de las letras incluye reglas sobre b/v, c/s/z, g/j, ll/y, x y otras letras de difícil distinción en español.',
  ),

  // --- LAS MAYÚSCULAS ---
  Tema(
    id: 'mayusculas_uso',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las mayúsculas',
    subsubtema: 'Uso de las mayúsculas',
    contenido: 'Se usan mayúsculas al inicio de oración, después de punto, en nombres propios, instituciones, festividades, cargos, títulos de obras y siglas.',
  ),
  Tema(
    id: 'mayusculas_errores_frecuentes',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las mayúsculas',
    subsubtema: 'Errores frecuentes en el uso de las mayúsculas',
    contenido: 'Errores comunes: escribir estaciones en mayúscula, usar mayúscula en títulos completos (solo primera palabra), no diferenciar entre nombre propio e apelativo.',
  ),

  // --- LOS SIGNOS DE PUNTUACIÓN ---
  Tema(
    id: 'puntuacion_coma',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'La coma - Usos',
    contenido: 'La coma separa elementos en enumeración, aísla aposiciones, marca incisos, separa oraciones coordinadas y pausa oraciones complejas.',
  ),
  Tema(
    id: 'puntuacion_coma_errores',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'La coma - Errores frecuentes',
    contenido: 'Errores: coma entre sujeto y verbo, coma antes de "y" en enumeración sin "sino", comas excesivas en textos.',
  ),
  Tema(
    id: 'puntuacion_punto_coma',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'El punto y coma',
    contenido: 'El punto y coma separa oraciones independientes relacionadas o elementos complejos en enumeración con comas internas.',
  ),
  Tema(
    id: 'puntuacion_punto',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'El punto - Usos',
    contenido: 'Punto seguido (final de oración, continúa párrafo), punto aparte (final de párrafo) y punto final (final de texto).',
  ),
  Tema(
    id: 'puntuacion_punto_errores',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'El punto - Errores frecuentes',
    contenido: 'Errores: no separar oraciones independientes, punto en abreviaturas (en siglas), abuso de puntos seguidos.',
  ),
  Tema(
    id: 'puntuacion_dos_puntos',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'Los dos puntos',
    contenido: 'Introducen enumeración, explicación, consecuencia de lo anterior, cita textual o cambio de speaker en diálogos.',
  ),
  Tema(
    id: 'puntuacion_puntos_suspensivos',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'Los puntos suspensivos',
    contenido: 'Los puntos suspensivos (…) indican omisión de palabras, silencio, suspenso o interrupción. Siempre son tres puntos.',
  ),
  Tema(
    id: 'puntuacion_interrogacion_exclamacion',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Los signos de puntuación',
    subsubtema: 'Los signos de interrogación y exclamación',
    contenido: 'En español, las interrogativas se abren con ¿ y cierran con ?. Las exclamativas se abren con ¡ y cierran con !. Siempre van emparejados.',
  ),

  // --- SIGNOS DE PUNTUACIÓN SECUNDARIOS O AUXILIARES ---
  Tema(
    id: 'puntuacion_auxiliar_parentesis_corchetes_llaves',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Signos de puntuación secundarios o auxiliares',
    subsubtema: 'Los paréntesis, los corchetes y las llaves',
    contenido: 'Paréntesis ( ) para aclaraciones. Corchetes [ ] para aclaraciones dentro de paréntesis u omisiones en citas. Llaves { } para agrupar información.',
  ),
  Tema(
    id: 'puntuacion_auxiliar_comillas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Signos de puntuación secundarios o auxiliares',
    subsubtema: 'Las comillas',
    contenido: 'Se usan para citas textuales, palabras extranjeras, apodos, títulos de artículos. En español se prefieren « » o " ". También se pueden usar \' \'.',
  ),
  Tema(
    id: 'puntuacion_auxiliar_raya_guion_menos',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Signos de puntuación secundarios o auxiliares',
    subsubtema: 'La raya, el guion y el menos',
    contenido: 'Raya (–) encierra incisos, marca cambios de speaker. Guion (-) divide palabras al final de línea y une componentes de palabras compuestas. Menos (−) símbolo matemático.',
  ),
  Tema(
    id: 'puntuacion_auxiliar_barra',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Signos de puntuación secundarios o auxiliares',
    subsubtema: 'La barra, la barra inversa y la pleca',
    contenido: 'Barra (/) separa opciones (y/o), marca división, alternancia. Barra inversa (\\) en direcciones web. Pleca (|) en ciertos contextos técnicos.',
  ),

  // --- ESCRITURA DE LA PALABRA ---
  Tema(
    id: 'escritura_palabra_variantes',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Escritura de la palabra',
    subsubtema: 'Palabras que admiten variantes gráficas',
    contenido: 'Palabras con más de una forma correcta: guion/guión, fútbol/futbol, coctel/cóctel, estrés/estres.',
  ),
  Tema(
    id: 'escritura_palabra_compuestas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Escritura de la palabra',
    subsubtema: 'Palabras compuestas',
    contenido: 'Las palabras compuestas pueden escribirse en una palabra (telaraña), con guion (semana-trabajo) o separadas según su grado de lexicalización.',
  ),
  Tema(
    id: 'escritura_palabra_expresiones_juntas_separadas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Escritura de la palabra',
    subsubtema: 'Expresiones que pueden escribirse juntas o separadas',
    contenido: 'Expresiones que se escriben: solo juntas (adonde, aún), solo separadas (a donde, a un), o juntas/separadas según el contexto (porque/por que, sino/si no).',
  ),

  // --- LAS ABREVIATURAS, SIGLAS, SIGNOS Y SÍMBOLOS ---
  Tema(
    id: 'abreviaturas_general',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las abreviaturas, las siglas, los signos y los símbolos',
    subsubtema: 'Las abreviaturas',
    contenido: 'Representaciones acortadas de palabras. Siempre terminan en punto. Ejemplos: Sr., Dra., pág., obs., etc.',
  ),
  Tema(
    id: 'siglas_general',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las abreviaturas, las siglas, los signos y los símbolos',
    subsubtema: 'Las siglas',
    contenido: 'Palabras formadas por iniciales de expresiones complejas. Se escriben en mayúsculas sin puntos: ONU, UNESCO, ONCE. No se pluralizan.',
  ),
  Tema(
    id: 'signos_general',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las abreviaturas, las siglas, los signos y los símbolos',
    subsubtema: 'Los signos',
    contenido: 'Elementos gráficos que representan conceptos: @, #, &, ‰, ©, ®, ™, etc.',
  ),
  Tema(
    id: 'simbolos_general',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Las abreviaturas, las siglas, los signos y los símbolos',
    subsubtema: 'Los símbolos',
    contenido: 'Representaciones gráficas de unidades y conceptos',
  ),

  // --- RESALTES TIPOGRÁFICOS ---
  Tema(
    id: 'resaltes_negrita',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'La negrita',
    contenido: 'Se usa para destacar palabras clave, títulos de secciones, términos importantes. Debe usarse con moderación.',
  ),
  Tema(
    id: 'resaltes_cursiva',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'La cursiva',
    contenido: 'Se usa para títulos de obras, palabras en otros idiomas, nombres científicos (géneros y especies), apodos y énfasis.',
  ),
  Tema(
    id: 'resaltes_subrayado',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'El subrayado',
    contenido: 'Menos usado en textos digitales. Se empleaba en textos manuscritos o mecanografiados para destacar información.',
  ),
  Tema(
    id: 'resaltes_voladita',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'La letra voladita (o superíndice)',
    contenido: 'Se usa en notas a pie de página (números superíndices), fórmulas químicas, expresiones matemáticas y marcas registradas.',
  ),
  Tema(
    id: 'resaltes_mayusculas_tipograficas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'Las mayúsculas como resalte tipográfico',
    contenido: 'Las mayúsculas pueden usarse para destacar, aunque es menos recomendable que la negrita o cursiva en textos modernos.',
  ),
  Tema(
    id: 'resaltes_versalitas',
    categoria: 'LA CORRECCIÓN ORTOGRÁFICA',
    subtema: 'Resaltes tipográficos',
    subsubtema: 'Las versalitas',
    contenido: 'Mayúsculas reducidas al tamaño de minúsculas. Se usan en siglas extensas, nombres de autor o épocas históricas.',
  ),

  // ============ LA CORRECCIÓN GRAMATICAL ============

  // --- EL SUSTANTIVO: GÉNERO Y NÚMERO ---
  Tema(
    id: 'sustantivo_genero',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El género',
    contenido: 'Los sustantivos tienen género masculino o femenino. Algunos son ambiguos, comunes o cambian de significado según el género.',
  ),
  Tema(
    id: 'sustantivo_genero_ambiguos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Sustantivos ambiguos en cuanto al género',
    contenido: 'Sustantivos que pueden usarse indistintamente en masculino o femenino sin cambiar de significado: mar, azúcar, lápiz.',
  ),
  Tema(
    id: 'sustantivo_genero_comunes',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Sustantivos comunes en cuanto al género',
    contenido: 'Sustantivos que tienen una única forma para ambos géneros: el/la periodista, el/la dentista, el/la artista.',
  ),
  Tema(
    id: 'sustantivo_genero_cambio_significado',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Palabras que cambian de significado según el género',
    contenido: 'El orden (secuencia) / la orden (mandato). El cura (sacerdote) / la cura (curación). El papa (pontífice) / la papa (patata).',
  ),
  Tema(
    id: 'sustantivo_genero_sexo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El género y el sexo',
    contenido: 'El género gramatical no siempre coincide con el sexo biológico. "Víctima" es femenino aunque se refiera a personas de ambos sexos.',
  ),
  Tema(
    id: 'sustantivo_genero_profesiones',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El género en los nombres de profesiones',
    contenido: 'Modernamente se recomiendan formas para ambos géneros: jueza (no la juez), médica (no la médico), abogada (no la abogado).',
  ),
  Tema(
    id: 'sustantivo_genero_errores',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Errores frecuentes en la asignación de género',
    contenido: 'Errores comunes: "la problema" (es masculino), "el fuente" (es femenino), "la sartén" vs "el sartén".',
  ),
  Tema(
    id: 'sustantivo_numero',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El número',
    contenido: 'Formación del plural: añadir -s a vocales, -es a consonantes. Particularidades con -z, palabras invariables.',
  ),
  Tema(
    id: 'sustantivo_numero_formacion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Aspectos particulares sobre la formación del número',
    contenido: 'Plurales irregulares, palabras con cambio vocálico, plurales latinos (álbumes, fórumes), plurales de palabras compuestas.',
  ),
  Tema(
    id: 'sustantivo_numero_solo_plural',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Palabras que habitualmente solo se usan en plural',
    contenido: 'Palabras que solo existen en plural: tijeras, gafas, pantalones, noticias, alrededores, afueras.',
  ),
  Tema(
    id: 'sustantivo_numero_solo_singular',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Palabras que habitualmente solo se usan en singular',
    contenido: 'Palabras que generalmente van en singular: sed, hambre, caos, canícula, bullicio, gentío.',
  ),
  Tema(
    id: 'sustantivo_numero_sin_cambio',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Palabras sin cambio de significado entre singular y plural',
    contenido: 'Palabras que mantienen su significado al cambiar de número: dinero, cobre, viruela, viruelas.',
  ),
  Tema(
    id: 'sustantivo_numero_cambio_significado',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Palabras con cambio de significado según el número',
    contenido: 'Esposa (cónyuge) / esposas (grilletes). Comedia (obra teatral) / comedias (situaciones cómicas).',
  ),
  Tema(
    id: 'sustantivo_numero_compuestos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El plural de los nombres compuestos',
    contenido: 'El plural depende de la estructura: abrelatas (invariable), sofacama (sofacamas), quitamanchas (invariable).',
  ),
  Tema(
    id: 'sustantivo_numero_latinismos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El plural de los latinismos',
    contenido: 'Se recomienda adaptar el plural al español: los álbumes (no álbum), los fórumes (no fóra), los currículos (no curricula).',
  ),
  Tema(
    id: 'sustantivo_numero_extranjerismos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El plural de los extranjerismos',
    contenido: 'Extranjerismos adaptados siguen reglas españolas: fútboles, líders, tisús. Los no adaptados pueden variar: DVDs o DVD.',
  ),
  Tema(
    id: 'sustantivo_numero_propios',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El plural en los nombres propios',
    contenido: 'Rara vez se pluralizan. Usos especiales: "Los García" (familia), "los Juanes" (cantantes llamados Juan).',
  ),
  Tema(
    id: 'sustantivo_numero_acortamientos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'El plural de acortamientos, abreviaturas, siglas y símbolos',
    contenido: 'Acortamientos: las fotos (no fotoes). Abreviaturas: Dres. (de Doctor). Siglas: invariables. Símbolos: invariables.',
  ),
  Tema(
    id: 'sustantivo_numero_vulgarismos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El sustantivo: género y número',
    subsubtema: 'Vulgarismos en la formación del plural',
    contenido: 'Errores comunes: "azúcares" por "azúcar", "los polices" por "los policías", "árbols" por "árboles".',
  ),

  // --- EL ADJETIVO ---
  Tema(
    id: 'adjetivo_genero_numero',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Género y número',
    contenido: 'El adjetivo concuerda en género y número con el sustantivo. Varían según terminación: -o/-a, -e (invariable), consonante (varían en -es).',
  ),
  Tema(
    id: 'adjetivo_apocope',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'La apócope',
    contenido: 'Algunos adjetivos pierden el final ante sustantivos masculinos: buen (no bueno), mal (no malo), primer (no primero), tercer (no tercero).',
  ),
  Tema(
    id: 'adjetivo_comparativos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Comparativos y superlativos',
    contenido: 'Comparativos: más/menos + adjetivo, tan + adjetivo. Superlativos: muy + adjetivo o adjetivo + -ísimo.',
  ),
  Tema(
    id: 'adjetivo_comparativos_irregulares',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Comparativos irregulares',
    contenido: 'Formas irregulares: mejor (no más bueno), peor (no más malo), mayor, menor, superior, inferior, anterior, posterior.',
  ),
  Tema(
    id: 'adjetivo_superlativos_isimo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Superlativos irregulares en -ísimo',
    contenido: 'Cambios vocálicos: bueno → bonísimo, malo → malísimo, cierto → certísimo, fuerte → fortísimo.',
  ),
  Tema(
    id: 'adjetivo_superlativos_errimo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Superlativos irregulares en -érrimo',
    contenido: 'Forma culta de superlativos: pobre → pauperísimo, célebre → celebérrimo, miserable → miserabilísimo.',
  ),
  Tema(
    id: 'adjetivo_uso_incorrecto',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Usos incorrectos de comparativos y superlativos',
    contenido: 'Errores: "más mejor" (solo mejor), "muy óptimo" (óptimo ya es superlativo), "lo más mejor" (lo mejor).',
  ),
  Tema(
    id: 'adjetivo_normas_uso',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El adjetivo',
    subsubtema: 'Normas sobre el uso de algunos adjetivos',
    contenido: 'Acuerdos sobre uso de adjetivos particulares, concordancia con sustantivos colectivos, posición del adjetivo.',
  ),

  // --- EL ARTÍCULO ---
  Tema(
    id: 'articulo_el_femenino',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El artículo',
    subsubtema: 'El artículo el ante sustantivos femeninos con a- tónica',
    contenido: 'Se usa "el" ante sustantivos femeninos que comienzan con a tónica: el agua, el ala, el alma. El plural es "las aguas".',
  ),
  Tema(
    id: 'articulo_contraccion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El artículo',
    subsubtema: 'Las contracciones de a y de con el artículo el',
    contenido: 'Contracciones obligatorias: al (a + el), del (de + el). No existen contracciones con artículos femeninos o plurales.',
  ),
  Tema(
    id: 'articulo_uso_incorrecto',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El artículo',
    subsubtema: 'Usos incorrectos del artículo',
    contenido: 'Errores comunes: omisión ante nombres propios, uso excesivo de artículos, artículo con pronombres posesivos.',
  ),

  // --- LOS POSESIVOS ---
  Tema(
    id: 'posesivos_posicion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Posición en el grupo sintáctico',
    contenido: 'Los posesivos pueden ir antepuestos (mi libro) o pospuestos (un libro mío). La posición varía según contexto y énfasis.',
  ),
  Tema(
    id: 'posesivos_combinacion_determinantes',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Combinación con otros determinantes',
    contenido: 'Los posesivos átonos (mi, tu, su) no pueden combinarse con artículos o demostrativos directamente.',
  ),
  Tema(
    id: 'posesivos_combinacion_adverbios',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Combinación con adverbios',
    contenido: 'Posibilidad de combinar posesivos con adverbios de lugar: arriba mío, enfrente suyo, debajo tuyo.',
  ),
  Tema(
    id: 'posesivos_sustitucion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Sustitución por de + pronombre',
    contenido: 'En lugar de posesivos pospuestos, se puede usar construcción "de + pronombre": un amigo mío = un amigo de mí.',
  ),
  Tema(
    id: 'posesivos_concordancia',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Concordancia',
    contenido: 'El posesivo debe concordar con el poseedor en persona y número, no con el objeto poseído: nosotros = nuestro/a/os/as.',
  ),
  Tema(
    id: 'posesivos_ambiguedad',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'Ambigüedad por el empleo de los posesivos',
    contenido: 'El posesivo "su" es ambiguo: puede referirse a él, ella, usted, ellos, ellas, ustedes. A veces requiere aclaración con "de + pronombre".',
  ),
  Tema(
    id: 'posesivos_articulo_lugar',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los posesivos',
    subsubtema: 'El artículo en lugar del posesivo',
    contenido: 'En contextos claros, se prefiere artículo a posesivo: "Me duele la cabeza" en lugar de "Me duele mi cabeza".',
  ),

  // --- LOS DEMOSTRATIVOS ---
  Tema(
    id: 'demostrativos_general',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los demostrativos',
    subsubtema: 'Los demostrativos',
    contenido: 'Palabras que señalan: este/a/o/s (cercanía), ese/a/o/s (distancia media), aquel/la/lo/s (distancia lejana). También: esto, eso, aquello.',
  ),

  // --- LOS NUMERALES ---
  Tema(
    id: 'numerales_cardinales',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Los cardinales',
    contenido: 'Numerales que indican cantidad: uno, dos, tres... Acuerdos sobre escritura: uno/a, veintiuno/a, los tres mil habitantes.',
  ),
  Tema(
    id: 'numerales_cardinales_normas',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Normas sobre el uso de algunos numerales cardinales',
    contenido: 'Apócope de "uno": un libro (masculino), una puerta (femenino). "Mil" es invariable. Concordancia de género y número.',
  ),
  Tema(
    id: 'numerales_cardinales_escritura',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'La escritura de los números cardinales',
    contenido: 'Del 0 al 30 en una palabra. Del 31 en adelante, separados o con "y": treinta y uno, ciento veintitrés.',
  ),
  Tema(
    id: 'numerales_cardinales_vulgarismos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Vulgarismos en la pronunciación de los numerales',
    contenido: 'Errores comunes: "cincuenta" (no "cincuantá"), "sesenta" (no "sesantá"), aspiración incorrecta de sonidos.',
  ),
  Tema(
    id: 'numerales_ordinales',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Los ordinales',
    contenido: 'Indican orden: primero, segundo, tercero... Hasta décimo se usan ordinales; después, generalmente cardinales: el piso 21 (no vigesimoprimer).',
  ),
  Tema(
    id: 'numerales_fraccionarios',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Los fraccionarios o partitivos',
    contenido: 'Indican división: mitad, tercio, cuarto, quinto... Se usan también los cardinales: una quinta parte, tres cuartos.',
  ),
  Tema(
    id: 'numerales_multiplicativos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los numerales cardinales, ordinales, partitivos y multiplicativos',
    subsubtema: 'Los multiplicativos',
    contenido: 'Indican multiplicación: doble, triple, cuádruple... También se usan construcciones: tres veces mayor, cuatro veces superior.',
  ),

  // --- LOS INDEFINIDOS ---
  Tema(
    id: 'indefinidos_general',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los indefinidos',
    subsubtema: 'Los indefinidos',
    contenido: 'Palabras que aluden a cantidad o identidad de manera imprecisa: alguno, ninguno, poco, mucho, varios, otro, mismo, cierto, etc.',
  ),

  // --- LOS RELATIVOS ---
  Tema(
    id: 'relativos_general',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los relativos',
    subsubtema: 'Los relativos',
    contenido: 'Palabras que introducen oraciones subordinadas relativas: que, cual, quien, cuyo, donde, cuando, como. Forman nexo entre antecedente y subordinada.',
  ),

  // --- LOS PRONOMBRES PERSONALES ---
  Tema(
    id: 'pronombres_personales_tonicos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los pronombres personales',
    subsubtema: 'Pronombres personales tónicos',
    contenido: 'Formas tónicas con acento prosódico: yo, tú, él, ella, usted, nosotros/as, vosotros/as, ellos/as, ustedes. Funcionan como sujeto.',
  ),
  Tema(
    id: 'pronombres_personales_atonos_orden',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los pronombres personales',
    subsubtema: 'Orden en la colocación de los pronombres átonos',
    contenido: 'Pronombres átonos (me, te, se, nos, os, le, la, lo, les, las, los) van antepuestos al verbo o pospuestos en imperativo e infinitivo.',
  ),
  Tema(
    id: 'pronombres_personales_combinacion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los pronombres personales',
    subsubtema: 'La combinación de los pronombres átonos con las formas verbales',
    contenido: 'Reglas de combinación: "me lo", "se la", "te los". El dativo precede al acusativo. "Se" es forma neutra para tercera persona.',
  ),
  Tema(
    id: 'pronombres_personales_duplicacion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los pronombres personales',
    subsubtema: 'Duplicación del pronombre y el grupo nominal',
    contenido: 'Es frecuente duplicar el pronombre con su referente nominal: "Al doctor le recomendé...", "A los niños les encanta...".',
  ),
  Tema(
    id: 'pronombres_personales_leismo_laismo_loismo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los pronombres personales',
    subsubtema: 'Leísmo, laísmo, loísmo',
    contenido: 'Leísmo (le por lo/la): usar "le" como complemento directo. Laísmo (la por le): usar "la" como complemento indirecto. Loísmo (lo por le): menos frecuente.',
  ),

  // --- LOS VERBOS ---
  Tema(
    id: 'verbos_conjugacion',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'La conjugación',
    contenido: 'Variación del verbo según persona, número, tiempo y modo. Tres conjugaciones según terminación: -ar, -er, -ir.',
  ),
  Tema(
    id: 'verbos_voseo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'El voseo',
    contenido: 'En algunas regiones de América, se usa "vos" en lugar de "tú": vos sos (eres), vos tenés (tienes). Afecta a la conjugación verbal.',
  ),
  Tema(
    id: 'verbos_irregulares',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Verbos irregulares',
    contenido: 'Verbos que no siguen el patrón regular: ser, estar, haber, tener, hacer, ir, venir, poder, saber, querer, decir, etc.',
  ),
  Tema(
    id: 'verbos_defectivos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Verbos defectivos',
    contenido: 'Verbos que no se conjugan en todas las formas: llover, nevar, amanecer, atardecer. Solo se usan en tercera persona.',
  ),
  Tema(
    id: 'verbos_dos_participios',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Verbos con dos participios',
    contenido: 'Verbos que tienen dos formas de participio: frito/freído, impreso/imprimido, confundido/confuso. Usos diferenciados.',
  ),
  Tema(
    id: 'verbos_incorrecciones',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Incorrecciones y vulgarismos relacionados con la conjugación',
    contenido: 'Errores: "andé" por "anduve", "vinistes" por "vinisteis", "habría" por "habría", formas arcaicas o dialectales.',
  ),
  Tema(
    id: 'verbos_regimen',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Régimen sintáctico de algunos verbos',
    contenido: 'Verbos con preposición obligatoria: "constar de", "consistir en", "aspirar a", "renunciar a", "prescindir de", etc.',
  ),
  Tema(
    id: 'verbos_usos_condicional',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos del condicional',
    contenido: 'Errores: condicional en lugar de imperfecto ("habría dicho" por "había dicho"), usos incorrectos en oraciones condicionales.',
  ),
  Tema(
    id: 'verbos_usos_subjuntivo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos del subjuntivo',
    contenido: 'Errores: subjuntivo donde va indicativo, indicativo donde va subjuntivo, formas arcaicas o incorrectas de subjuntivo.',
  ),
  Tema(
    id: 'verbos_usos_infinitivo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos del infinitivo',
    contenido: 'Errores: infinitivo en lugar de imperativo (muy coloquial), infinitivos sin preposición donde la requieren.',
  ),
  Tema(
    id: 'verbos_usos_gerundio',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos del gerundio',
    contenido: 'Errores: gerundio de posterioridad ("comió corriendo a casa"), gerundio con referente ambiguo, gerundio absorbido.',
  ),
  Tema(
    id: 'verbos_usos_imperativo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos del imperativo',
    contenido: 'Errores: imperativo con sujeto ("tú coge"), formas del infinitivo como imperativo coloquial, confusión de personas.',
  ),
  Tema(
    id: 'verbos_correlacion_tiempos',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los verbos',
    subsubtema: 'Usos incorrectos en la correlación de los tiempos',
    contenido: 'Concordancia temporal entre oraciones: presente con presente, pasado con pasado, futuro con futuro.',
  ),

  // --- LOS ADVERBIOS ---
  Tema(
    id: 'adverbios_adjetivos_determinantes',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los adverbios',
    subsubtema: 'Uso de adjetivos y determinantes como adverbios',
    contenido: 'Algunos adjetivos funcionan como adverbios: "hablas alto" (no "altamente"), "te quiero mucho" (no "muchamente").',
  ),
  Tema(
    id: 'adverbios_normas_uso',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Los adverbios',
    subsubtema: 'Normas sobre el uso de algunos adverbios',
    contenido: 'Usos correctos de adverbios particulares: "recientemente" vs "hace poco", "actualmente" vs "ahora", "sólo/solo".',
  ),

  // --- LAS PREPOSICIONES ---
  Tema(
    id: 'preposiciones_normas',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Las preposiciones y locuciones prepositivas',
    subsubtema: 'Normas sobre el uso de las preposiciones',
    contenido: 'Reglas de uso de preposiciones comunes: "a", "ante", "bajo", "con", "contra", "de", "desde", "durante", "en", "entre", "hacia", "hasta", "para", "por", "según", "sin", "sobre", "tras".',
  ),
  Tema(
    id: 'preposiciones_dequeismo_queismo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Las preposiciones y locuciones prepositivas',
    subsubtema: 'Dequeísmo y queísmo',
    contenido: 'Dequeísmo: "de que" innecesario ("pienso de que"). Queísmo: omisión de "de" donde es necesaria ("me di cuenta que" en lugar de "me di cuenta de que").',
  ),

  // --- LAS CONJUNCIONES ---
  Tema(
    id: 'conjunciones_general',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'Las conjunciones y locuciones conjuntivas',
    subsubtema: 'Las conjunciones y locuciones conjuntivas',
    contenido: 'Palabras que enlazan oraciones u elementos: coordinantes (y, o, pero, sino), subordinantes (que, si, porque, como, cuando, aunque).',
  ),

  // --- EL ORDEN DE PALABRAS ---
  Tema(
    id: 'orden_palabras',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'El orden de palabras',
    subsubtema: 'El orden de palabras',
    contenido: 'El español tiene orden relativamente flexible, pero preferencias normativas: sujeto-verbo-objeto. Variaciones para énfasis o estilo.',
  ),

  // --- LA CONCORDANCIA ---
  Tema(
    id: 'concordancia_sustantivo_adjetivo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'La concordancia',
    subsubtema: 'Concordancia entre el sustantivo y el adjetivo',
    contenido: 'El adjetivo concuerda en género y número con el sustantivo: "casa blanca", "libros rojos", "niña pequeña".',
  ),
  Tema(
    id: 'concordancia_sustantivo_pronombre',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'La concordancia',
    subsubtema: 'Concordancia entre el sustantivo y el pronombre personal',
    contenido: 'El pronombre concuerda con el sustantivo referente: "El niño vino. Él estaba contento." (número y género si es posible).',
  ),
  Tema(
    id: 'concordancia_sujeto_verbo',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'La concordancia',
    subsubtema: 'Concordancia entre el sujeto y el verbo',
    contenido: 'El verbo concuerda con el sujeto en número y persona: "Yo voy", "Nosotros vamos", "Ellas irán".',
  ),
  Tema(
    id: 'concordancia_oraciones_impersonales',
    categoria: 'LA CORRECCIÓN GRAMATICAL',
    subtema: 'La concordancia',
    subsubtema: 'Concordancia en las oraciones impersonales',
    contenido: 'Oraciones sin sujeto explícito: "Llueve mucho", "Hay muchos coches", "Se vende bien". El verbo va en tercera persona singular.',
  ),

  // ============ LA CORRECCIÓN LÉXICO-SEMÁNTICA ============
  Tema(
    id: 'lexico_impropiedades',
    categoria: 'LA CORRECCIÓN LÉXICO-SEMÁNTICA',
    subtema: 'Las impropiedades',
    subsubtema: 'Las impropiedades',
    contenido: 'Uso incorrecto de palabras por confusión de significado: usar "prescribir" por "proscribir", "eminente" por "inminente", "infligir" por "infringir".',
  ),
  Tema(
    id: 'lexico_extranjerismos',
    categoria: 'LA CORRECCIÓN LÉXICO-SEMÁNTICA',
    subtema: 'Los extranjerismos',
    subsubtema: 'Los extranjerismos',
    contenido: 'Palabras de otros idiomas usadas en español. Se recomiendan adaptaciones al español cuando existen equivalentes: "fútbol" (no "football"), "líder" (no "leader").',
  ),
  Tema(
    id: 'lexico_redundancias',
    categoria: 'LA CORRECCIÓN LÉXICO-SEMÁNTICA',
    subtema: 'Las redundancias',
    subsubtema: 'Las redundancias',
    contenido: 'Repetición innecesaria de conceptos: "subir arriba", "bajar abajo", "volver a repetir", "verdaderamente cierto".',
  ),
];

// HOME PAGE
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FavoritosService _favoritosService = FavoritosService();

  String _searchQuery = '';
  Tema? _selectedTema;
  int _selectedIndex = 0; // 0: Inicio, 1: Favoritos
  List<String> _favoritosIds = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final favoritos = await _favoritosService.cargarFavoritos();
    setState(() {
      _favoritosIds = favoritos.map((f) => f.temaId).toList();
    });
  }

  List<Tema> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();

    return _temasCompletos.where((tema) {
      final categoria = tema.categoria.toLowerCase();
      final subtema = tema.subtema.toLowerCase();
      final subsubtema = tema.subsubtema.toLowerCase();
      final contenido = tema.contenido.toLowerCase();

      final textoTabla = tema.tableData
          .map((fila) => fila.values.join(' ').toLowerCase())
          .join(' ');

      return categoria.contains(query) ||
          subtema.contains(query) ||
          subsubtema.contains(query) ||
          contenido.contains(query) ||
          textoTabla.contains(query);
    }).toList();
  }

  List<Tema> get _temasFavoritos {
    return _temasCompletos.where((tema) => _favoritosIds.contains(tema.id)).toList();
  }

  void _selectTema(Tema tema) {
    setState(() {
      _selectedTema = tema;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  Future<void> _toggleFavorito(String temaId) async {
    if (_favoritosIds.contains(temaId)) {
      await _favoritosService.eliminarFavorito(temaId);
    } else {
      await _favoritosService.agregarFavorito(temaId);
    }
    await _cargarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, List<Tema>>> estructura = {};
    for (var tema in _temasCompletos) {
      estructura.putIfAbsent(tema.categoria, () => {});
      estructura[tema.categoria]!.putIfAbsent(tema.subtema, () => []);
      estructura[tema.categoria]![tema.subtema]!.add(tema);
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(estructura),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (_selectedIndex == 0) _buildSearchBar(),
          Expanded(
            child: _selectedIndex == 0 ? _buildContenidoInicio() : _buildFavoritos(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _selectedTema = null;
            _searchController.clear();
            _searchQuery = '';
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favoritos'),
        ],
      ),
    );
  }

  Widget _buildDrawer(Map<String, Map<String, List<Tema>>> estructura) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF072F6B)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secciones',
                  style: TextStyle(
                      color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Libro de Estilo',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
          ...estructura.entries.map((categoriaEntry) {
            final categoria = categoriaEntry.key;
            final subtemas = categoriaEntry.value;

            return ExpansionTile(
              title: Text(categoria, style: const TextStyle(fontWeight: FontWeight.bold)),
              children: subtemas.entries.map((subtemaEntry) {
                final subtema = subtemaEntry.key;
                final subsubtemas = subtemaEntry.value;

                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ExpansionTile(
                    title: Text(subtema),
                    children: subsubtemas.map((tema) {
                      return ListTile(
                        contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0),
                        title: Text(tema.subsubtema),
                        onTap: () {
                          Navigator.pop(context);
                          _selectTema(tema);
                        },
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: const Color(0xFF072F6B),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.white,
                iconSize: 30,
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const Expanded(
                child: Text(
                  'Libro de estilo de la Comisaría General de Información',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Buscar...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildContenidoInicio() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: _selectedTema != null
          ? _buildDetalleTema(_selectedTema!)
          : _searchQuery.isNotEmpty
          ? _buildResultadosBusqueda()
          : const Center(child: Text('Selecciona un tema desde el menú ☰')),
    );
  }

  Widget _buildResultadosBusqueda() {
    if (_searchResults.isEmpty) {
      return const Center(child: Text('No se encontraron resultados'));
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final tema = _searchResults[index];
        return ListTile(
          title: Text(tema.subsubtema),
          subtitle: Text('${tema.categoria} > ${tema.subtema}'),
          onTap: () => _selectTema(tema),
        );
      },
    );
  }

  Widget _buildFavoritos() {
    if (_temasFavoritos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No tienes favoritos aún', style: TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _temasFavoritos.length,
      itemBuilder: (context, index) {
        final tema = _temasFavoritos[index];
        return FutureBuilder<String>(
          future: _favoritosService.obtenerNota(tema.id),
          builder: (context, snapshot) {
            final nota = snapshot.data ?? '';
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      tema.subsubtema,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${tema.categoria} > ${tema.subtema}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.star, color: Colors.amber),
                          onPressed: () => _toggleFavorito(tema.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarNota(tema),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _toggleFavorito(tema.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        _selectTema(tema);
                      });
                    },
                  ),
                  if (nota.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        nota,
                        style: TextStyle(color: Colors.blue.shade900, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _editarNota(Tema tema) async {
    final nota = await _favoritosService.obtenerNota(tema.id);
    final controller = TextEditingController(text: nota);

    if (!mounted) return;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nota'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Escribe una nota personal...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      await _favoritosService.actualizarNota(tema.id, result);
      setState(() {});
    }
  }

  Widget _buildDetalleTema(Tema tema) {
    final esFavorito = _favoritosIds.contains(tema.id);

    // Separar contenido de ejemplos
    final contenidoParts = tema.contenido.split('\n\n');
    final contenidoPrincipal = contenidoParts.first;
    final ejemplos = contenidoParts.length > 1 ? contenidoParts.sublist(1) : <String>[];

    return ListView(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedTema = null;
                });
              },
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                esFavorito ? Icons.star : Icons.star_border,
                color: esFavorito ? Colors.amber : Colors.grey,
              ),
              onPressed: () => _toggleFavorito(tema.id),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Etiqueta de categoría en recuadro gris
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                tema.categoria,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Título del tema
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            tema.subsubtema,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        // Tarjeta principal con fondo azul claro
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200, width: 1.5),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contenidoPrincipal,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                // Ejemplos con fondo gris claro
                ...ejemplos.map((ejemplo) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      ejemplo,
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade800,
                        height: 1.4,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
        if (tema.tableData.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Tipo',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Sílaba acentuada',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Terminación típica',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Ejemplos',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
                ...tema.tableData.map((row) {
                  return TableRow(
                    children: [
                      Padding(padding: const EdgeInsets.all(6.0), child: Text(row['Tipo'] ?? '')),
                      Padding(padding: const EdgeInsets.all(6.0), child: Text(row['Sílaba'] ?? '')),
                      Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(row['Terminación'] ?? '')),
                      Padding(
                          padding: const EdgeInsets.all(6.0), child: Text(row['Ejemplos'] ?? '')),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}