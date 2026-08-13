import 'package:flutter/material.dart';

/// TRELLIS — the quiet vault. Premium dark personal-finance app.
/// Espresso & Gold direction (from the design-brief swarm):
///   warm-ink surfaces, ONE scarce amber-gold accent, hairlines, no shadows,
///   tabular numerics, 5 screens with a pill bottom tab bar.
void main() => runApp(const TrellisApp());

const kGold = Color(0xFFD4A043);
const kBase = Color(0xFF221D1A);
const kDeep = Color(0xFF1A1614);
const kElev = Color(0xFF2C2520);
const kRaised = Color(0xFF352D28);
const kInk = Color(0xFFEDE6DE);
const kInk2 = Color(0xFFB0A69B);
const kMuted = Color(0xFF7D7165);
const kUp = Color(0xFF4CAF50);
const kDown = Color(0xFFE57373);

class TrellisApp extends StatelessWidget {
  const TrellisApp({super.key});
  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      title: 'TRELLIS',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: kBase,
        colorScheme: const ColorScheme.dark(
          primary: kGold,
          onPrimary: Color(0xFF201A12),
          surface: kElev,
          onSurface: kInk,
          secondary: kElev,
          onSecondary: kInk,
          error: kDown,
          onError: kInk,
        ),
        textTheme: base.textTheme.apply(bodyColor: kInk, displayColor: kInk),
        navigationBarTheme: const NavigationBarThemeData(backgroundColor: kElev),
      ),
      home: const TrellisShell(),
    );
  }
}

/* ---------------- shell with pill bottom bar ---------------- */
class TrellisShell extends StatefulWidget {
  const TrellisShell({super.key});
  @override
  State<TrellisShell> createState() => _TrellisShellState();
}

class _TrellisShellState extends State<TrellisShell> {
  int _tab = 0;
  final _screens = const [HomeScreen(), CardsScreen(), ActivityScreen(), InsightsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: _screens),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: _PillBar(tab: _tab, onTap: (i) => setState(() => _tab = i)),
      ),
    );
  }
}

class _PillBar extends StatelessWidget {
  const _PillBar({required this.tab, required this.onTap});
  final int tab;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (Icons.home_rounded, 'Home'),
      (Icons.credit_card_rounded, 'Cards'),
      (Icons.query_stats_rounded, 'Activity'),
      (Icons.bar_chart_rounded, 'Insights'),
      (Icons.settings_rounded, 'Settings'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: kDeep.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < tabs.length; i++) _tabItem(i, tabs[i].$1, tabs[i].$2),
        ],
      ),
    );
  }

  Widget _tabItem(int i, IconData icon, String label) {
    final active = tab == i;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onTap(i),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 32,
              decoration: BoxDecoration(
                color: active ? kGold.withValues(alpha: 0.14) : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, size: 21, color: active ? kGold : kMuted),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: active ? kGold : kMuted)),
            SizedBox(height: active ? 4 : 0, child: active ? Container(width: 5, height: 5, decoration: const BoxDecoration(color: kGold, shape: BoxShape.circle)) : null),
          ],
        ),
      ),
    );
  }
}

/* ---------------- shared bits ---------------- */
class Tnum extends StatelessWidget {
  const Tnum(this.text, {super.key, this.style});
  final String text;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) => Text(text, style: (style ?? const TextStyle()).copyWith(fontFamily: 'monospace', fontFeatures: const [FontFeature.tabularFigures()]));
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: kMuted, fontSize: 10.5, letterSpacing: 2.6, fontFamily: 'monospace'));
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(18)});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(color: kElev, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
        child: child,
      );
}

class _Row extends StatelessWidget {
  const _Row({required this.leading, required this.title, required this.subtitle, this.trailing});
  final Widget leading;
  final String title, subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          child: Row(children: [
            leading,
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kInk)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 12, color: kMuted))])),
            if (trailing != null) trailing!,
          ]),
        ),
      );
}

Widget _chip({required IconData icon}) => Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: kDeep, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 19, color: kGold),
    );

/* ---------------- screen headers ---------------- */
class _Head extends StatelessWidget {
  const _Head({required this.eyebrow, required this.title, this.trailing});
  final String eyebrow, title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Eyebrow(eyebrow.toUpperCase()), const SizedBox(height: 5), Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, height: 1.0))]),
          if (trailing != null) trailing!,
        ],
      );
}

/* ---------------- Home ---------------- */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _count = AnimationController(vsync: this, duration: const Duration(milliseconds: 950))
    ..forward();
  late final Animation<double> _bal = CurvedAnimation(parent: _count, curve: Curves.easeOutCubic);
  List<double> _trend = [34, 41, 38, 52, 46, 61, 55, 48, 58, 44, 50, 42, 56, 49];

  @override
  void dispose() {
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      children: [
        const _Head(
          eyebrow: 'good morning',
          title: 'Nadia.',
          trailing: _Bell(),
        ),
        const SizedBox(height: 22),
        _Card(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Available balance', style: TextStyle(color: kInk2, fontSize: 13)),
            const SizedBox(height: 7),
            AnimatedBuilder(
              animation: _bal,
              builder: (_, __) => Tnum(
                '\$${(_bal.value * 12480.42).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700, letterSpacing: -1, color: kInk),
              ),
            ),
            const SizedBox(height: 5),
            const Text('+\$4,250.00 this month', style: TextStyle(color: kGold, fontSize: 13)),
            const SizedBox(height: 14),
            SizedBox(height: 68, width: double.infinity, child: CustomPaint(painter: _TrendPainter(_trend))),
          ]),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Send', 'Request', 'Top up', 'More'].map((l) => _QuickAction(icon: _qaIcon(l), label: l)).toList(),
        ),
        const SizedBox(height: 24),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Recent activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), Text('All', style: TextStyle(color: kGold, fontSize: 13))]),
        const SizedBox(height: 10),
        _Card(
          padding: const EdgeInsets.all(6),
          child: Column(children: _txRows(_tx, count: 4)),
        ),
      ],
    );
  }

  static IconData _qaIcon(String l) => switch (l) {
        'Send' => Icons.north_east_rounded,
        'Request' => Icons.south_west_rounded,
        'Top up' => Icons.add_rounded,
        _ => Icons.more_horiz_rounded,
      };
}

class _Bell extends StatelessWidget {
  const _Bell();
  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: kElev, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white10)),
        child: const Icon(Icons.notifications_none_rounded, color: kInk2, size: 21),
      );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: kElev, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white10)),
          child: Icon(icon, color: kInk2, size: 20),
        ),
        const SizedBox(height: 7),
        Text(label, style: const TextStyle(color: kInk2, fontSize: 12)),
      ]);
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.data);
  final List<double> data;
  @override
  void paint(Canvas canvas, Size size) {
    final max = 72.0;
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / max) * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    final fill = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fill, Paint()..color = kGold.withValues(alpha: 0.16));
    canvas.drawPath(path, Paint()..color = kGold..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.data != data;
}

/* ---------------- transactions ---------------- */
class Tx {
  const Tx(this.name, this.when, this.amount);
  final String name, when;
  final double amount; // +in / -out
}

const _tx = [
  Tx('Salary — Meridian Labs', 'Today · 09:12', 4250.0),
  Tx('Spotify Premium', 'Today · 07:40', -10.99),
  Tx('Whole Foods Market', 'Yesterday · 18:22', -64.2),
  Tx('Gyro Bowl', 'Yesterday · 13:05', -18.4),
  Tx('Transfer to Marcus', 'Tue · 11:47', -250.0),
  Tx('Refund — Patagonia', 'Tue · 09:30', 129.0),
  Tx('Uber', 'Mon · 21:18', -12.6),
];

List<Widget> _txRows(List<Tx> list, {int? count}) {
  final rows = count != null ? list.take(count).toList() : list;
  return [
    for (final t in rows)
      _Row(
        leading: _chip(icon: t.amount >= 0 ? Icons.south_west_rounded : Icons.north_east_rounded),
        title: t.name,
        subtitle: t.when,
        trailing: Tnum(
          '${t.amount >= 0 ? '+' : '−'}\$${t.amount.abs().toStringAsFixed(2)}',
          style: TextStyle(color: t.amount >= 0 ? kGold : kInk, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
  ];
}

/* ---------------- Cards ---------------- */
class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});
  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  bool _frozen = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      children: [
        const _Head(eyebrow: 'your plastic', title: 'Cards'),
        const SizedBox(height: 22),
        Container(
          height: 196,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF3A332B), Color(0xFF241F1B), Color(0xFF171310)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kGold.withValues(alpha: 0.25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('TRELLIS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3)),
                if (_frozen) Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.white24), borderRadius: BorderRadius.circular(999)), child: const Text('FROZEN', style: TextStyle(fontSize: 9, letterSpacing: 2, color: kInk2, fontFamily: 'monospace'))),
              ]),
              const Spacer(),
              const Tnum('•••• •••• •••• 9037', style: TextStyle(fontSize: 19, letterSpacing: 2, color: kInk)),
              const Spacer(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('N. ZEITLER', style: TextStyle(fontSize: 12, letterSpacing: 2, color: kInk2)), Tnum('12/29', style: TextStyle(fontSize: 12, color: kInk2))]),
            ]),
          ),
        ),
        const SizedBox(height: 22),
        const Text('Card controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        _Card(
          padding: const EdgeInsets.all(6),
          child: Column(children: [
            _Row(leading: _chip(icon: Icons.lock_outline_rounded), title: 'Freeze card', subtitle: _frozen ? 'Transactions blocked' : 'Transactions allowed', trailing: _Switch(on: _frozen, onChanged: (v) => setState(() => _frozen = v))),
            const _Row(leading: _chip(icon: Icons.fingerprint_rounded), title: 'Contactless limit', subtitle: 'Set a ceiling for tap payments', trailing: Tnum('\$120', style: TextStyle(color: kMuted, fontSize: 13))),
            const _Row(leading: _chip(icon: Icons.pin_rounded), title: 'Card PIN', subtitle: 'View or change your PIN', trailing: Tnum('••••', style: TextStyle(color: kMuted, fontSize: 13))),
          ]),
        ),
      ],
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({required this.on, required this.onChanged});
  final bool on;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(!on),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 50,
          height: 30,
          decoration: BoxDecoration(color: on ? kGold : kDeep, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white12)),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(margin: const EdgeInsets.all(4), width: 22, height: 22, decoration: const BoxDecoration(color: Color(0xFF201A12), shape: BoxShape.circle)),
          ),
        ),
      );
}

/* ---------------- Activity ---------------- */
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _filter = 'All';
  @override
  Widget build(BuildContext context) {
    final list = _tx.where((t) => _filter == 'All' || (_filter == 'Income' ? t.amount >= 0 : t.amount < 0)).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      children: [
        const _Head(eyebrow: 'everything, dated', title: 'Activity'),
        const SizedBox(height: 18),
        Row(children: ['All', 'Income', 'Spending'].map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: _Chip(label: c, on: _filter == c, onTap: () => setState(() => _filter = c)))).toList()),
        const SizedBox(height: 20),
        _Card(padding: const EdgeInsets.all(6), child: Column(children: _txRows(list))),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.on, required this.onTap});
  final String label;
  final bool on;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          decoration: BoxDecoration(color: on ? kGold : Colors.transparent, borderRadius: BorderRadius.circular(999), border: Border.all(color: on ? kGold : Colors.white12)),
          child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: on ? const Color(0xFF201A12) : kInk2)),
        ),
      );
}

/* ---------------- Insights ---------------- */
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cats = [('Housing', 38.0), ('Food & drink', 26.0), ('Transport', 14.0), ('Subscriptions', 11.0), ('Leisure', 8.0), ('Other', 3.0)];
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      children: [
        const _Head(eyebrow: 'the why, quietly', title: 'Insights'),
        const SizedBox(height: 22),
        const _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Spent this month', style: TextStyle(color: kInk2, fontSize: 13)), SizedBox(height: 7), Tnum('\$640.20', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, letterSpacing: -1)), SizedBox(height: 5), Text('−12% vs last month', style: TextStyle(color: kDown, fontSize: 13))])),
        const SizedBox(height: 22),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Spending by category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), Text('Jun', style: TextStyle(color: kGold, fontSize: 13))]),
        const SizedBox(height: 12),
        _Card(child: Column(children: [for (final c in cats) _bar(c.$1, c.$2)])),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: kGold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16), border: Border.all(color: kGold.withValues(alpha: 0.3))),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Eyebrow('smart note'),
            SizedBox(height: 9),
            Text('Subscriptions rose 11% after the streamer price change. Pausing one unused tier saves \$10.99/mo.', style: TextStyle(color: kInk2, fontSize: 14, height: 1.5)),
          ]),
        ),
      ],
    );
  }

  Widget _bar(String name, double v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 88, child: Text(name, style: const TextStyle(color: kInk2, fontSize: 13))),
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: v / 100, minHeight: 8, color: kGold, backgroundColor: kDeep))),
          SizedBox(width: 34, child: Tnum('${v.toStringAsFixed(0)}%', style: const TextStyle(color: kInk2, fontSize: 12, textAlign: TextAlign.right))),
        ]),
      );
}

/* ---------------- Settings ---------------- */
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _lock = true, _biometrics = false, _notify = true, _round = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      children: [
        const _Head(eyebrow: 'your vault, your rules', title: 'Settings'),
        const SizedBox(height: 22),
        _Card(
          padding: const EdgeInsets.all(6),
          child: Column(children: [
            const _Row(leading: _chip(icon: Icons.person_outline_rounded), title: 'Nadia Zeitler', subtitle: 'nadia@trellis.bank', trailing: Tnum('›', style: TextStyle(color: kMuted))),
            _Row(leading: _chip(icon: Icons.lock_outline_rounded), title: 'Biometric lock', subtitle: 'Face ID or fingerprint', trailing: _Switch(on: _lock, onChanged: (v) => setState(() => _lock = v))),
            _Row(leading: _chip(icon: Icons.fingerprint_rounded), title: 'Require on payment', subtitle: 'Confirm every spend', trailing: _Switch(on: _biometrics, onChanged: (v) => setState(() => _biometrics = v))),
            _Row(leading: _chip(icon: Icons.notifications_none_rounded), title: 'Smart notifications', subtitle: 'Only what matters', trailing: _Switch(on: _notify, onChanged: (v) => setState(() => _notify = v))),
            _Row(leading: _chip(icon: Icons.add_rounded), title: 'Round-ups', subtitle: 'Save on every purchase', trailing: _Switch(on: _round, onChanged: (v) => setState(() => _round = v))),
          ]),
        ),
        const SizedBox(height: 18),
        _Card(
          padding: const EdgeInsets.all(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Close account permanently', style: TextStyle(color: kDown, fontWeight: FontWeight.w500)), SizedBox(height: 3), Text('Everything is removed after 30 days', style: TextStyle(color: kMuted, fontSize: 12))]),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const Center(child: Tnum('TRELLIS v1.0 · a quiet vault', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.5))),
      ],
    );
  }
}