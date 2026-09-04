import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/event_logs_provider.dart';

void showEventLogsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const EventLogsBottomSheet(),
  );
}

class EventLogsBottomSheet extends ConsumerWidget {
  const EventLogsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventLogsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF071B13),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF10B981), width: 1.2),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 38,
              height: 4.5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Title & Refresh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF10B981).withOpacity(0.35),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.bell,
                      size: 18,
                      color: Color(0xFF34D399),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifikasi & Event Log',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Riwayat peringatan dan telemetri backend',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(LucideIcons.refreshCw, size: 16, color: Color(0xFF34D399)),
                tooltip: 'Refresh',
                onPressed: () => ref.read(eventLogsProvider.notifier).fetchLogs(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Content List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.55,
            ),
            child: state.isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: Color(0xFF10B981)),
                    ),
                  )
                : state.logs.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(LucideIcons.shieldCheck, size: 36, color: Color(0xFF34D399)),
                            const SizedBox(height: 8),
                            Text(
                              'Semua sistem aman! Belum ada log peringatan.',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, idx) {
                          final log = state.logs[idx];
                          final isWarn = log.level.toUpperCase() == 'WARNING';
                          final isErr = log.level.toUpperCase() == 'ERROR';
                          final accentColor = isErr
                              ? const Color(0xFFF43F5E)
                              : isWarn
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF38BDF8);

                          final timeStr = DateFormat('dd MMM • HH:mm:ss').format(log.createdAt.toLocal());

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: accentColor.withOpacity(0.30),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  margin: const EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.18),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isErr
                                        ? LucideIcons.alertOctagon
                                        : isWarn
                                            ? LucideIcons.alertTriangle
                                            : LucideIcons.info,
                                    size: 13,
                                    color: accentColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: accentColor.withOpacity(0.18),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              log.level.toUpperCase(),
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 8.5,
                                                fontWeight: FontWeight.w800,
                                                color: accentColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            timeStr,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 9.5,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        log.message,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (log.nodeName != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Stasiun: ${log.nodeName}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 9.5,
                                            color: const Color(0xFF6EE7B7),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
