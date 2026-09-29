import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const FootballApp());
}

class FootballApp extends StatelessWidget {
  const FootballApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF102A43);
    return MaterialApp(
      title: 'Fútbol en vivo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A085),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: const MatchesPage(),
    );
  }
}

class Match {
  const Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.date,
    required this.time,
    required this.league,
    this.homeScore,
    this.awayScore,
    this.status,
    this.homeBadge,
    this.awayBadge,
    this.venue,
  });

  final String id;
  final String homeTeam;
  final String awayTeam;
  final DateTime date;
  final String time;
  final String league;
  final int? homeScore;
  final int? awayScore;
  final String? status;
  final String? homeBadge;
  final String? awayBadge;
  final String? venue;

  factory Match.fromJson(Map<String, dynamic> json) {
    final dateText = json['dateEvent'] as String? ?? '';
    final parsedDate = DateTime.tryParse(dateText) ?? DateTime.now();
    return Match(
      id: json['idEvent'] as String? ?? '${json['dateEvent']}-${json['strHomeTeam']}',
      homeTeam: json['strHomeTeam'] as String? ?? 'Local',
      awayTeam: json['strAwayTeam'] as String? ?? 'Visitante',
      date: parsedDate,
      time: _formatTime(json['strTime']),
      league: json['strLeague'] as String? ?? 'Fútbol',
      homeScore: _score(json['intHomeScore']),
      awayScore: _score(json['intAwayScore']),
      status: json['strStatus'] as String?,
      homeBadge: json['strHomeTeamBadge'] as String?,
      awayBadge: json['strAwayTeamBadge'] as String?,
      venue: json['strVenue'] as String?,
    );
  }

  bool get hasResult => homeScore != null && awayScore != null;

  static int? _score(Object? value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static String _formatTime(Object? value) {
    final raw = value as String? ?? '';
    if (raw.length >= 5 && raw[2] == ':') return raw.substring(0, 5);
    return raw.isEmpty ? '--:--' : raw;
  }
}

class FootballVideo {
  const FootballVideo({
    required this.title,
    required this.competition,
    required this.thumbnail,
    required this.matchviewUrl,
  });

  final String title;
  final String competition;
  final String thumbnail;
  final String matchviewUrl;

  factory FootballVideo.fromJson(Map<String, dynamic> json) {
    return FootballVideo(
      title: json['title'] as String? ?? 'Resumen del partido',
      competition: json['competition'] as String? ?? 'Fútbol',
      thumbnail: json['thumbnail'] as String? ?? '',
      matchviewUrl: json['matchviewUrl'] as String? ?? '',
    );
  }
}

class FootballApi {
  static const _baseUrl = 'https://www.thesportsdb.com/api/v1/json/3';
  static const _scoreBatUrl = 'https://www.scorebat.com/video-api/v3/';
  static const _leagueIds = <String, String>{
    'Premier League': '4328',
    'UEFA Champions League': '4480',
  };

  Future<List<Match>> fetchNextMatches() async {
    final matches = await Future.wait(
      _leagueIds.values.map(_fetchLeagueMatches),
    );
    final uniqueMatches = <String, Match>{
      for (final match in matches.expand((leagueMatches) => leagueMatches))
        match.id: match,
    };
    final result = uniqueMatches.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  Future<List<FootballVideo>> fetchVideos() async {
    try {
      final response = await http
          .get(Uri.parse(_scoreBatUrl))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return <FootballVideo>[];
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final videos = body['response'] as List<dynamic>? ?? <dynamic>[];
      return videos
          .whereType<Map<String, dynamic>>()
          .map(FootballVideo.fromJson)
          .where(
            (video) => video.competition.toLowerCase().contains('premier') ||
                video.competition.toLowerCase().contains('champions league'),
          )
          .take(8)
          .toList();
    } on Exception {
      return <FootballVideo>[];
    }
  }

  Future<List<Match>> _fetchLeagueMatches(String leagueId) async {
    final responses = await Future.wait([
      _getEvents('eventsnextleague.php', leagueId),
      _getEvents('eventspastleague.php', leagueId),
    ]);
    return responses
        .expand((body) => body['events'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .map(Match.fromJson)
        .toList();
  }

  Future<Map<String, dynamic>> _getEvents(String endpoint, String leagueId) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/$endpoint?id=$leagueId'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('El servidor respondió con ${response.statusCode}.');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final _api = FootballApi();
  final _searchController = TextEditingController();
  late Future<List<Match>> _matchesFuture;
  late Future<List<FootballVideo>> _videosFuture;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _matchesFuture = _api.fetchNextMatches();
    _videosFuture = _api.fetchVideos();
    _searchController.addListener(() {
      setState(() => _search = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _matchesFuture = _api.fetchNextMatches();
      _videosFuture = _api.fetchVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fútbol en vivo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Próximos partidos', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Actualizar partidos',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<Match>>(
          future: _matchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _ErrorView(onRetry: _reload);
            }
            final matches = snapshot.data ?? <Match>[];
            final filtered = matches.where(_matchesSearch).toList();
            return _MatchesBody(
              matches: filtered,
              totalMatches: matches.length,
              searchController: _searchController,
              videosFuture: _videosFuture,
            );
          },
        ),
      ),
    );
  }

  bool _matchesSearch(Match match) {
    if (_search.isEmpty) return true;
    return '${match.homeTeam} ${match.awayTeam} ${match.league}'
        .toLowerCase()
        .contains(_search);
  }
}

class _MatchesBody extends StatelessWidget {
  const _MatchesBody({
    required this.matches,
    required this.totalMatches,
    required this.searchController,
    required this.videosFuture,
  });

  final List<Match> matches;
  final int totalMatches;
  final TextEditingController searchController;
  final Future<List<FootballVideo>> videosFuture;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        Text(
          'Partidos y resultados',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF102A43),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$totalMatches partidos de Premier League y Champions',
          style: TextStyle(color: Colors.blueGrey.shade600),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Buscar equipo...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    onPressed: searchController.clear,
                    icon: const Icon(Icons.clear),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        _VideosSection(videosFuture: videosFuture),
        const SizedBox(height: 18),
        if (matches.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('No hay partidos para esa búsqueda.')),
          )
        else
          ...matches.map((match) => MatchCard(match: match)),
        const SizedBox(height: 12),
        Text(
          'Datos de TheSportsDB y vídeos de ScoreBat',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade500),
        ),
      ],
    );
  }
}

class _VideosSection extends StatelessWidget {
  const _VideosSection({required this.videosFuture});

  final Future<List<FootballVideo>> videosFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FootballVideo>>(
      future: videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }
        final videos = snapshot.data ?? <FootballVideo>[];
        if (videos.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vídeos destacados',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _VideoCard(video: videos[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({required this.video});

  final FootballVideo video;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 245,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: () => _openVideo(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      video.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(
                        color: Color(0xFFE8EEF2),
                        child: Icon(Icons.play_circle_outline, size: 42),
                      ),
                    ),
                    const Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      video.competition,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blueGrey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openVideo(BuildContext context) async {
    final uri = Uri.tryParse(video.matchviewUrl);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el vídeo.')),
        );
      }
    }
  }
}

class MatchCard extends StatelessWidget {
  const MatchCard({required this.match, super.key});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 15,
                  color: Colors.teal.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_dayName(match.date.weekday)}, ${match.date.day}/${match.date.month}',
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  match.time,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  Chip(
                    label: Text(match.league),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  Chip(
                    label: Text(match.hasResult ? 'RESULTADO' : 'PRÓXIMO'),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    backgroundColor: match.hasResult
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: TeamInfo(
                    name: match.homeTeam,
                    imageUrl: match.homeBadge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    match.hasResult
                        ? '${match.homeScore} - ${match.awayScore}'
                        : 'VS',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Expanded(
                  child: TeamInfo(
                    name: match.awayTeam,
                    imageUrl: match.awayBadge,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            if (match.venue != null && match.venue!.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Colors.blueGrey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      match.venue!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _dayName(int day) {
    const days = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    return days[day - 1];
  }
}

class TeamInfo extends StatelessWidget {
  const TeamInfo({
    required this.name,
    this.imageUrl,
    this.alignEnd = false,
    super.key,
  });

  final String name;
  final String? imageUrl;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (imageUrl != null && imageUrl!.isNotEmpty)
          SizedBox(
            height: 46,
            width: 46,
            child: Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.shield_outlined, size: 40),
            ),
          )
        else
          const SizedBox(
            height: 46,
            child: Icon(Icons.shield_outlined, size: 40),
          ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.blueGrey.shade300),
            const SizedBox(height: 16),
            const Text(
              'No pudimos cargar los partidos.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Revisa tu conexión e inténtalo de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
