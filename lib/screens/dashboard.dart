import 'package:flutter/material.dart';
import 'dart:math' as math;

// ─── Colour tokens ────────────────────────────────────────────────────────────
const _bg = Color(0xFF0D0F14);
const _surface = Color(0xFF161A23);
const _card = Color(0xFF1E2330);
const _cardAlt = Color(0xFF252B3A);
const _green = Color(0xFF00E5A0);
const _greenDim = Color(0xFF00A372);
const _amber = Color(0xFFFFB547);
const _red = Color(0xFFFF5C5C);
const _blue = Color(0xFF4E9DFF);
const _textPrimary = Color(0xFFEEF0F6);
const _textSecondary = Color(0xFF8A90A2);
const _divider = Color(0xFF2A3045);

// ─── Entry point (remove if embedding in existing app) ────────────────────────
void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: _bg),
    home: const DashboardScreen(),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  DASHBOARD SCREEN
// ═══════════════════════════════════════════════════════════════════════════════
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Top bar ──────────────────────────────────────────────────
              SliverToBoxAdapter(child: _TopBar()),

              // ── Balance card ─────────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const SliverToBoxAdapter(child: _BalanceCard()),

              // ── Quick actions ────────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: _SectionLabel('Quick Actions')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _QuickActions()),

              // ── Spending summary ─────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: _SectionLabel('Spending Summary'),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _SpendingSummaryCard()),

              // ── Active loan ──────────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: _SectionLabel('Active Loan')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _ActiveLoanCard()),

              // ── Smart insights ───────────────────────────────────────────
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: _SectionLabel('Smart Insights')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _SmartInsights()),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'Tadaishe 👋',
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          _IconBtn(icon: Icons.notifications_outlined, badge: true),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundColor: _greenDim,
            child: Text(
              'T',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  const _IconBtn({required this.icon, this.badge = false});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: _textSecondary, size: 20),
        ),
        if (badge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: _green, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }
}

// ─── Balance Card ─────────────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2E25), Color(0xFF0F1E2A)],
          ),
          border: Border.all(color: _green.withOpacity(0.18), width: 1),
          boxShadow: [
            BoxShadow(
              color: _green.withOpacity(0.07),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: _green, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          '+2.4%',
                          style: TextStyle(
                            color: _green,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$',
                    style: TextStyle(
                      color: _green.withOpacity(0.7),
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '1,240.50',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      height: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: _divider),
              const SizedBox(height: 16),
              Row(
                children: [
                  _BalanceStat(
                    label: 'Money left this week',
                    value: '\$340.20',
                    color: _green,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 36, color: _divider),
                  const SizedBox(width: 8),
                  _BalanceStat(
                    label: 'Money left this month',
                    value: '\$890.00',
                    color: _blue,
                    icon: Icons.date_range_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _BalanceStat({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: _textSecondary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────
// ─── Quick Actions ────────────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _actions = [
    _Action(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Request\nLoan',
      color: _amber,
    ),
    _Action(icon: Icons.add_card_outlined, label: 'Add\nExpense', color: _blue),
    _Action(
      icon: Icons.pie_chart_outline,
      label: 'Create\nBudget',
      color: _green,
    ),
    _Action(
      icon: Icons.auto_awesome_outlined,
      label: 'Get\nAdvice',
      color: Color(0xFFBF8FFF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // FIXED: Added a horizontal scroll view so it never overflows on small screens!
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: _actions
            .map(
              (a) => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _ActionTile(action: a),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Action {
  final IconData icon;
  final String label;
  final Color color;
  const _Action({required this.icon, required this.label, required this.color});
}

class _ActionTile extends StatelessWidget {
  final _Action action;
  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: action.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: action.color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(action.icon, color: action.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Spending Summary ─────────────────────────────────────────────────────────
class _SpendingSummaryCard extends StatelessWidget {
  const _SpendingSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _divider, width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "You've spent",
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  'This Month',
                  style: TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '65%',
                  style: TextStyle(
                    color: _amber,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'of your budget',
                  style: TextStyle(color: _textSecondary, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Budget progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 8,
                backgroundColor: _cardAlt,
                valueColor: const AlwaysStoppedAnimation<Color>(_amber),
              ),
            ),
            const SizedBox(height: 20),
            // Category bars
            const _CategoryBar(
              label: 'Food & Dining',
              icon: Icons.restaurant_outlined,
              spent: 120,
              total: 200,
              color: _green,
            ),
            const SizedBox(height: 12),
            const _CategoryBar(
              label: 'Transport',
              icon: Icons.directions_bus_outlined,
              spent: 45,
              total: 80,
              color: _blue,
            ),
            const SizedBox(height: 12),
            const _CategoryBar(
              label: 'Airtime & Data',
              icon: Icons.phone_android_outlined,
              spent: 30,
              total: 40,
              color: Color(0xFFBF8FFF),
            ),
            const SizedBox(height: 12),
            const _CategoryBar(
              label: 'Entertainment',
              icon: Icons.movie_outlined,
              spent: 60,
              total: 60,
              color: _red,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final double spent;
  final double total;
  final Color color;
  const _CategoryBar({
    required this.label,
    required this.icon,
    required this.spent,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (spent / total).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: _textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '\$${spent.toStringAsFixed(0)} / \$${total.toStringAsFixed(0)}',
              style: TextStyle(color: _textSecondary, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: _cardAlt,
              valueColor: AlwaysStoppedAnimation<Color>(
                pct >= 1 ? _red : color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Active Loan ──────────────────────────────────────────────────────────────
class _ActiveLoanCard extends StatelessWidget {
  const _ActiveLoanCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_red.withOpacity(0.15), _cardAlt],
          ),
          border: Border.all(color: _red.withOpacity(0.2), width: 1),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _red.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: _red,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Emergency Loan',
                      style: TextStyle(
                        color: _textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Issued: 15 Apr 2025',
                      style: TextStyle(color: _textSecondary, fontSize: 11),
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
                    color: _red.withOpacity(0.15),
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
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: _divider),
            const SizedBox(height: 16),
            Row(
              children: [
                _LoanStat(label: 'Amount Owed', value: '\$350.00', color: _red),
                Container(width: 1, height: 40, color: _divider),
                _LoanStat(
                  label: 'Original Amount',
                  value: '\$500.00',
                  color: _textSecondary,
                ),
                Container(width: 1, height: 40, color: _divider),
                _LoanStat(label: 'Due In', value: '8 days', color: _amber),
              ],
            ),
            const SizedBox(height: 16),
            // Repayment progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Repayment Progress',
                      style: TextStyle(color: _textSecondary, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      '30%',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.30,
                    minHeight: 7,
                    backgroundColor: _cardAlt,
                    valueColor: const AlwaysStoppedAnimation<Color>(_green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payments_outlined, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Repay Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _LoanStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ─── Smart Insights ───────────────────────────────────────────────────────────
class _SmartInsights extends StatelessWidget {
  const _SmartInsights();

  static const _insights = [
    _Insight(
      icon: Icons.restaurant_outlined,
      title: 'Food spending up this week',
      body:
          "You've spent \$32 more on food than last week. Consider cooking more at home.",
      color: _amber,
      tag: 'Spending',
    ),
    _Insight(
      icon: Icons.warning_amber_rounded,
      title: 'Budget runway: ~3 days',
      body:
          'At your current spending rate you may run out of funds by Thursday.',
      color: _red,
      tag: 'Alert',
    ),
    _Insight(
      icon: Icons.emoji_events_outlined,
      title: 'Loan repayment on track!',
      body:
          "You're ahead on repayments. Keep it up to improve your credit score.",
      color: _green,
      tag: 'Good News',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: _insights
            .map(
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InsightTile(insight: i),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Insight {
  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final String tag;
  const _Insight({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.tag,
  });
}

class _InsightTile extends StatelessWidget {
  final _Insight insight;
  const _InsightTile({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: insight.color, width: 3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(insight.icon, color: insight.color, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        insight.title,
                        style: TextStyle(
                          color: _textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: insight.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        insight.tag,
                        style: TextStyle(
                          color: insight.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  insight.body,
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helper: Section Label ────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Text('See all', style: TextStyle(color: _green, fontSize: 12)),
        ],
      ),
    );
  }
}
