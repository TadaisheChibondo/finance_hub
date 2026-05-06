import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/loan_provider.dart';
import '../services/supabase_service.dart';

// ─── Colour tokens ────────────────────────────────────────────────────────────
const _bg = Color(0xFF0D0F14);
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
              SliverToBoxAdapter(child: _TopBar()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const SliverToBoxAdapter(child: _BalanceCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: _SectionLabel('Quick Actions')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _QuickActions()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: _SectionLabel('Spending Summary'),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _SpendingSummaryCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(child: _SectionLabel('Active Loan')),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: _ActiveLoanCard()),
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

// ─── Balance Card (LIVE) ──────────────────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    // PASTE YOUR UUID HERE
    const testBorrowerId = 'YOUR_BORROWER_UUID_HERE';

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
                  // LIVE DATA FETCH FROM SUPABASE
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: Supabase.instance.client
                        .from('students')
                        .select('balance')
                        .eq('id', testBorrowerId),
                    builder: (context, snapshot) {
                      String balance = '0.00';
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        balance = snapshot.data!.first['balance'].toString();
                      }
                      return Text(
                        balance,
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.5,
                          height: 1,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(height: 1, color: _divider),
              const SizedBox(height: 16),
              Row(
                children: [
                  _BalanceStat(
                    label: 'Weekly Limit',
                    value: '\$340.20',
                    color: _green,
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(width: 8),
                  Container(width: 1, height: 36, color: _divider),
                  const SizedBox(width: 8),
                  _BalanceStat(
                    label: 'Monthly Limit',
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
  final String label, value;
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
class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children:
            [
                  _ActionTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Request\nLoan',
                    color: _amber,
                  ),
                  _ActionTile(
                    icon: Icons.add_card_outlined,
                    label: 'Add\nExpense',
                    color: _blue,
                  ),
                  _ActionTile(
                    icon: Icons.pie_chart_outline,
                    label: 'Create\nBudget',
                    color: _green,
                  ),
                  _ActionTile(
                    icon: Icons.auto_awesome_outlined,
                    label: 'Get\nAdvice',
                    color: Color(0xFFBF8FFF),
                  ),
                ]
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: e,
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

// ─── Spending Summary (Static Prototype) ──────────────────────────────────────
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
          border: Border.all(color: _divider),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.65,
                minHeight: 8,
                backgroundColor: _cardAlt,
                valueColor: const AlwaysStoppedAnimation<Color>(_amber),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Active Loan (DYNAMIC) ────────────────────────────────────────────────────
class _ActiveLoanCard extends StatelessWidget {
  const _ActiveLoanCard();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, provider, child) {
        if (provider.pendingLoans.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "No active loan requests.",
              style: TextStyle(color: _textSecondary),
            ),
          );
        }

        final latestLoan = provider.pendingLoans.first;

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
              border: Border.all(color: _red.withOpacity(0.2)),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loan Request',
                            style: TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Status: ${latestLoan.status}',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '\$${latestLoan.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: _red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Requested',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 30, color: _divider),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            latestLoan.reason,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Reason',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Smart Insights (LIVE) ────────────────────────────────────────────────────
class _SmartInsights extends StatelessWidget {
  const _SmartInsights();

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService();
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.getFinancialAdvice(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: snapshot.data!
                .take(3)
                .map(
                  (advice) => _InsightTile(
                    title: advice['title'],
                    body: advice['content'],
                    color: _amber,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _InsightTile extends StatelessWidget {
  final String title, body;
  final Color color;
  const _InsightTile({
    required this.title,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: color, size: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
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
            ),
          ),
          const Spacer(),
          Text('See all', style: TextStyle(color: _green, fontSize: 12)),
        ],
      ),
    );
  }
}
