class RakatInfo {
  final String waqt;
  final int farzRakats;
  final int totalRakats;
  final String rakatSummaryEn;
  final String rakatDetailsEn;

  // Compatibility getter
  String get name => waqt;
  int get farz => farzRakats;

  const RakatInfo({
    required this.waqt,
    required this.farzRakats,
    required this.totalRakats,
    required this.rakatSummaryEn,
    required this.rakatDetailsEn,
  });

  static const List<RakatInfo> allPrayers = [
    RakatInfo(
      waqt: 'Fajr',
      farzRakats: 2,
      totalRakats: 4,
      rakatSummaryEn: '2 Rakat Farz (Total 4 Rakats)',
      rakatDetailsEn: '2 Sunnah + 2 Farz',
    ),
    RakatInfo(
      waqt: 'Dhuhr',
      farzRakats: 4,
      totalRakats: 12,
      rakatSummaryEn: '4 Rakat Farz (Total 12 Rakats)',
      rakatDetailsEn: '4 Sunnah + 4 Farz + 2 Sunnah + 2 Nafl',
    ),
    RakatInfo(
      waqt: 'Asr',
      farzRakats: 4,
      totalRakats: 8,
      rakatSummaryEn: '4 Rakat Farz (Total 8 Rakats)',
      rakatDetailsEn: '4 Sunnah + 4 Farz',
    ),
    RakatInfo(
      waqt: 'Maghrib',
      farzRakats: 3,
      totalRakats: 7,
      rakatSummaryEn: '3 Rakat Farz (Total 7 Rakats)',
      rakatDetailsEn: '3 Farz + 2 Sunnah + 2 Nafl',
    ),
    RakatInfo(
      waqt: 'Isha',
      farzRakats: 4,
      totalRakats: 17,
      rakatSummaryEn: '4 Rakat Farz (Total 17 Rakats)',
      rakatDetailsEn: '4 Sunnah + 4 Farz + 2 Sunnah + 2 Nafl + 3 Witr + 2 Nafl',
    ),
  ];

  static RakatInfo getRakatInfo(String waqtName) {
    final search = waqtName.trim().toLowerCase();
    return allPrayers.firstWhere(
      (info) => info.waqt.toLowerCase() == search,
      orElse: () => RakatInfo(
        waqt: waqtName,
        farzRakats: 2,
        totalRakats: 2,
        rakatSummaryEn: '$waqtName: 2 Rakats',
        rakatDetailsEn: '2 Rakats',
      ),
    );
  }
}
