import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/dummy.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat siang,',
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Wei Ling',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== KARTU SALDO =====
              Container(
                width: double.infinity,
                clipBehavior:
                    Clip.antiAlias, // potong dekorasi sesuai sudut bulat
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: 0,
                      bottom: 0,
                      width: 110,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.skewX(-0.244),
                        child: Container(color: AppColors.primaryDark),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Savings Account · SGD',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xCCFFFFFF),
                                ),
                              ),
                              Text(
                                '•••• 4182',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xCCFFFFFF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Saldo tersedia',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xBFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'SGD 12,450.80',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Text(
                                'Saldo efektif SGD 12,450.80',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xCCFFFFFF),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Hold SGD 0.00',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xCCFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Row(
                children: [
                  Expanded(
                    child: _Shortcut(
                      icon: Icons.public_outlined,
                      label: 'Remittance',
                    ),
                  ),
                  Expanded(
                    child: _Shortcut(
                      icon: Icons.notes,
                      label: 'Mutasi',
                    ),
                  ),
                  Expanded(
                    child: _Shortcut(
                      icon: Icons.credit_card_outlined,
                      label: 'Rekening',
                    ),
                  ),
                  Expanded(
                    child: _Shortcut(
                      icon: Icons.description_outlined,
                      label: 'eForm saya',
                    ),
                  )
                ]
              ),
              const SizedBox(height: 26),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Transaksi terakhir',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              for (final t in dummyTransactions) _TxRow(t),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
       bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.muted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              label: 'eForm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              label: 'Notifikasi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Shortcut({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.soft,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        )
      ],
    );
  }
}

class _TxRow extends StatelessWidget {
  final Transaction tx;

  const _TxRow(this.tx);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.soft)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tx.date,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
                    Text(
            tx.amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tx.isIncome ? AppColors.success : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}