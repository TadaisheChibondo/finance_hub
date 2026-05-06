import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/loan_provider.dart';

// ─── Colour tokens (shared across app) ───────────────────────────────────────
const _bg = Color(0xFF0D0F14);
const _card = Color(0xFF1E2330);
const _cardAlt = Color(0xFF252B3A);
const _green = Color(0xFF00E5A0);
const _amber = Color(0xFFFFB547);
const _red = Color(0xFFFF5C5C);
const _blue = Color(0xFF4E9DFF);
const _textPrimary = Color(0xFFEEF0F6);
const _textSecondary = Color(0xFF8A90A2);
const _divider = Color(0xFF2A3045);

extension _ColorAlphaExtension on Color {
  Color withAlphaOpacity(double opacity) =>
      withValues(alpha: opacity.clamp(0.0, 1.0));
}

// ─── Entry point ──────────────────────────────────────────────────────────────
void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: _bg),
    home: const LoansScreen(),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  LOANS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});
  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  double _loanAmount = 150;
  int _repayWeeks = 4;

  double get _interest => _loanAmount * 0.05 * _repayWeeks;
  double get _totalRepay => _loanAmount + _interest;
  DateTime get _dueDate => DateTime.now().add(Duration(days: _repayWeeks * 7));

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _EligibilityCard()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _sectionLabel('Request a Loan')),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: _LoanRequestCard(
                amount: _loanAmount,
                weeks: _repayWeeks,
                interest: _interest,
                totalRepay: _totalRepay,
                dueDate: _dueDate,
                onAmountChanged: (v) => setState(() => _loanAmount = v),
                onWeeksChanged: (v) => setState(() => _repayWeeks = v),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _sectionLabel('Active Loans')),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: _ActiveLoansSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _sectionLabel('Loan History')),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: _LoanHistorySection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(child: _sectionLabel('Know Before You Borrow')),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: _EducationSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loans',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            Text(
              'Borrow responsibly, repay on time',
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _green.withAlphaOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _green.withAlphaOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user_outlined, color: _green, size: 14),
              const SizedBox(width: 6),
              Text(
                'Eligible',
                style: TextStyle(
                  color: _green,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Text(
      text,
      style: TextStyle(
        color: _textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: -0.3,
      ),
    ),
  );
}

// ─── Eligibility Card ─────────────────────────────────────────────────────────
class _EligibilityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2E25), Color(0xFF0F1E2A)],
          ),
          border: Border.all(color: _green.withAlphaOpacity(0.18)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You can borrow up to',
                        style: TextStyle(color: _textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$',
                            style: TextStyle(
                              color: _green.withAlphaOpacity(0.7),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '500',
                            style: TextStyle(
                              color: _textPrimary,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _ScoreRing(score: 82),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: _divider),
            const SizedBox(height: 16),
            Row(
              children: [
                _EligFactor(
                  icon: Icons.check_circle_outline,
                  label: 'Consistent spending',
                  color: _green,
                ),
                _EligFactor(
                  icon: Icons.check_circle_outline,
                  label: '2 loans repaid on time',
                  color: _green,
                ),
                _EligFactor(
                  icon: Icons.radio_button_unchecked,
                  label: 'Budget plan set',
                  color: _textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int score;
  const _ScoreRing({required this.score});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 6,
            backgroundColor: _divider,
            valueColor: const AlwaysStoppedAnimation<Color>(_green),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              Text(
                'Score',
                style: TextStyle(color: _textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EligFactor extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _EligFactor({
    required this.icon,
    required this.label,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: _textSecondary, fontSize: 10, height: 1.3),
        ),
      ],
    ),
  );
}

// ─── Loan Request Card ────────────────────────────────────────────────────────
class _LoanRequestCard extends StatelessWidget {
  final double amount, interest, totalRepay;
  final int weeks;
  final DateTime dueDate;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<int> onWeeksChanged;

  const _LoanRequestCard({
    required this.amount,
    required this.weeks,
    required this.interest,
    required this.totalRepay,
    required this.dueDate,
    required this.onAmountChanged,
    required this.onWeeksChanged,
  });

  static const _weekOptions = [2, 4, 6, 8];

  String _fmt(DateTime d) =>
      '${d.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _divider),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Loan Amount',
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _blue.withAlphaOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: _blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 5,
                activeTrackColor: _blue,
                inactiveTrackColor: _cardAlt,
                thumbColor: _blue,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayColor: _blue.withAlphaOpacity(0.15),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: amount, // This is a double
                min: 20.0, // Add .0 to be explicit
                max: 500.0, // Add .0 to be explicit
                divisions: 48, // This MUST be an int
                onChanged: onAmountChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$20',
                  style: TextStyle(color: _textSecondary, fontSize: 11),
                ),
                Text(
                  '\$500',
                  style: TextStyle(color: _textSecondary, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Repayment period
            Text(
              'Repayment Period',
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Row(
              children: _weekOptions
                  .map(
                    (w) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => onWeeksChanged(w),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: weeks == w
                                  ? _blue.withAlphaOpacity(0.15)
                                  : _cardAlt,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: weeks == w
                                    ? _blue.withAlphaOpacity(0.4)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$w',
                                  style: TextStyle(
                                    color: weeks == w ? _blue : _textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'wks',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Summary
            Container(
              decoration: BoxDecoration(
                color: _cardAlt,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SummaryRow(
                    'Principal',
                    '\$${amount.toStringAsFixed(2)}',
                    _textPrimary,
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    'Interest (5%/wk)',
                    '\$${interest.toStringAsFixed(2)}',
                    _amber,
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: _divider),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    'Total Repayment',
                    '\$${totalRepay.toStringAsFixed(2)}',
                    _textPrimary,
                    bold: true,
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow('Due Date', _fmt(dueDate), _green),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Honest warning
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _amber.withAlphaOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _amber.withAlphaOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Missing a payment reduces your borrowing limit and credit score.',
                      style: TextStyle(
                        color: _amber,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: _bg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  // Grab the provider
                  final loanProvider = Provider.of<LoanProvider>(
                    context,
                    listen: false,
                  );
                  final messenger = ScaffoldMessenger.of(context);

                  // PASTE YOUR SUPABASE UUID HERE
                  const studentId = '9c003de2-e227-48f2-8f8a-7129e25594df';

                  // Show a loading message
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Submitting loan request...')),
                  );

                  // Send the actual amount from the slider to Supabase!
                  final success = await loanProvider.requestLoan(
                    studentId,
                    amount,
                    'Requested via App UI',
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success! Loan request submitted.'),
                        backgroundColor: Color(0xFF00E5A0), // Green
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to submit request.'),
                        backgroundColor: Color(0xFFFF5C5C), // Red
                      ),
                    );
                  }
                },
                child: const Text(
                  'Apply for Loan',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool bold;
  const _SummaryRow(this.label, this.value, this.color, {this.bold = false});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: TextStyle(color: _textSecondary, fontSize: 13)),
      const Spacer(),
      Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontSize: bold ? 15 : 13,
        ),
      ),
    ],
  );
}

// ─── Active Loans ─────────────────────────────────────────────────────────────
class _ActiveLoansSection extends StatelessWidget {
  const _ActiveLoansSection();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: _red, width: 3)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _red.withAlphaOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    color: _red,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '8 days left',
                style: TextStyle(
                  color: _amber,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Student Emergency Loan',
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Borrowed: \$500.00',
                style: TextStyle(color: _textSecondary, fontSize: 12),
              ),
              Text(
                'Owed: \$350.00',
                style: TextStyle(
                  color: _red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.30,
              minHeight: 8,
              backgroundColor: _cardAlt,
              valueColor: const AlwaysStoppedAnimation<Color>(_green),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('30% repaid', style: TextStyle(color: _green, fontSize: 11)),
              Text(
                'Due: 14 May 2025',
                style: TextStyle(color: _textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textSecondary,
                    side: BorderSide(color: _divider),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Repay Now',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ─── Loan History ─────────────────────────────────────────────────────────────
class _LoanHistorySection extends StatelessWidget {
  const _LoanHistorySection();

  static const _history = [
    _LoanRecord(
      amount: '\$200',
      date: 'Jan 2025',
      status: 'Paid',
      color: _green,
    ),
    _LoanRecord(
      amount: '\$150',
      date: 'Nov 2024',
      status: 'Paid',
      color: _green,
    ),
    _LoanRecord(
      amount: '\$100',
      date: 'Sep 2024',
      status: 'Overdue',
      color: _red,
    ),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _divider),
      ),
      child: Column(
        children: [
          ..._history.asMap().entries.map(
            (e) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: e.value.color.withAlphaOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          e.value.status == 'Paid'
                              ? Icons.check_circle_outline
                              : Icons.warning_amber_rounded,
                          color: e.value.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan ${e.value.amount}',
                            style: TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            e.value.date,
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: e.value.color.withAlphaOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          e.value.status,
                          style: TextStyle(
                            color: e.value.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (e.key < _history.length - 1)
                  Container(height: 1, color: _divider),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _LoanRecord {
  final String amount, date, status;
  final Color color;
  const _LoanRecord({
    required this.amount,
    required this.date,
    required this.status,
    required this.color,
  });
}

// ─── Education Section ────────────────────────────────────────────────────────
class _EducationSection extends StatelessWidget {
  const _EducationSection();

  static const _items = [
    _EduItem(
      icon: Icons.timer_off_outlined,
      color: _red,
      title: 'What happens if you miss a payment?',
      body:
          'Your credit score drops, your borrowing limit decreases, and a late fee is added to your balance. Two missed payments suspend your account.',
    ),
    _EduItem(
      icon: Icons.percent_outlined,
      color: _blue,
      title: 'How interest works',
      body:
          'We charge 5% per week on the outstanding amount. Repay early and you only pay for the weeks used — no early repayment penalties.',
    ),
    _EduItem(
      icon: Icons.shield_outlined,
      color: _green,
      title: 'Your data is safe',
      body:
          'We never share your financial information with third parties. Your borrowing history is only used to improve your eligibility.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: _items
          .map(
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _EduTile(item: i),
            ),
          )
          .toList(),
    ),
  );
}

class _EduItem {
  final IconData icon;
  final Color color;
  final String title, body;
  const _EduItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });
}

class _EduTile extends StatefulWidget {
  final _EduItem item;
  const _EduTile({required this.item});
  @override
  State<_EduTile> createState() => _EduTileState();
}

class _EduTileState extends State<_EduTile> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _expanded = !_expanded),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _expanded ? widget.item.color.withAlphaOpacity(0.3) : _divider,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.item.color.withAlphaOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.item.icon,
                  color: widget.item.color,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: _textSecondary,
                size: 20,
              ),
            ],
          ),
          if (_expanded) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: _divider),
            const SizedBox(height: 12),
            Text(
              widget.item.body,
              style: TextStyle(
                color: _textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
