import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/male_role/discover/model/brother_model.dart';
import 'package:muslim_community/male_role/discover/ui/male_profile_details_ui.dart';
import 'package:get/get.dart';
import 'package:muslim_community/male_role/discover/controller/brothergetcontroller.dart';

/// Reusable card for a single brother — mirrors SisterCard with maleColor (0xFF5B7C99)
class BrotherCard extends StatelessWidget {
  final BrotherModel brother;
  final int index;
  final VoidCallback onConnectPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onConfirmPressed;

  // maleColor — used exactly where SisterCard uses femaleColor (0xFFD18E8E)
  static const Color _roleColor = Color(0xFF5B7C99);

  const BrotherCard({
    super.key,
    required this.brother,
    required this.index,
    required this.onConnectPressed,
    required this.onCancelPressed,
    required this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MaleProfileDetailsUI(brother: brother)),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- IMAGE ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child:
                      brother.imageUrl.isNotEmpty &&
                          brother.imageUrl.startsWith('http')
                      ? Image.network(
                          brother.imageUrl,
                          height: 100.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 100.h,
                                width: double.infinity,
                                color: Colors.black,
                              ),
                        )
                      : Container(
                          height: 100.h,
                          width: double.infinity,
                          color: Colors.black,
                        ),
                ),
                if (brother.isOnline) _buildOnlineIndicator(),
                if (brother.isVerified) _buildVerifiedBadge(),
              ],
            ),

            SizedBox(height: 8.h),

            // --- NAME ---
            Text(
              brother.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2.h),

            // --- AGE & JOINED ---
            Text(
              '${brother.age} • ${brother.joinedAgo}',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: const Color(0xFF636E72),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 6.h),

            _buildDistanceBadge(),

            SizedBox(height: 8.h),

            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  // Green dot — online status
  Widget _buildOnlineIndicator() {
    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }

  // maleColor checkmark — verified badge (same position as female)
  Widget _buildVerifiedBadge() {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: _roleColor, // maleColor instead of femaleColor
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 10.sp),
      ),
    );
  }

  // Distance badge — maleColor text/icon
  Widget _buildDistanceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF1F7), // Light blue-grey tint of maleColor
        borderRadius: BorderRadius.circular(
          20.r,
        ), // Pill shape matching female card
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, size: 10.sp, color: _roleColor),
          SizedBox(width: 4.w),
          Text(
            '${brother.distance} mi',
            style: GoogleFonts.inter(fontSize: 10.sp, color: _roleColor),
          ),
        ],
      ),
    );
  }

  // Connect / Connected / Requested button — maleColor replacing femaleColor
  Widget _buildActionButton() {
    final ctrl = Get.find<BrotherGetController>();
    return Obx(() {
      // Read live status from the observable list
      final liveBrother = ctrl.brothers.length > index
          ? ctrl.brothers[index]
          : brother;
      final bool isConnected = liveBrother.status == 'Connected';
      final bool isRequested = liveBrother.status == 'Requested';
      final bool isReceived = liveBrother.status == 'Received';
      final bool isConnect = liveBrother.status == 'Connect';

      // Show Confirm Request for received requests
      if (isReceived) {
        return SizedBox(
          width: double.infinity,
          height: 32.h,
          child: ElevatedButton(
            onPressed: onConfirmPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _roleColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              'Confirm Request',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }

      return SizedBox(
        width: double.infinity,
        height: 32.h,
        child: ElevatedButton(
          onPressed: () {
            if (isConnect) {
              onConnectPressed();
            } else if (isRequested) {
              onCancelPressed();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isConnected || isRequested
                ? Colors.white
                : _roleColor,
            foregroundColor: isConnected || isRequested
                ? _roleColor
                : Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: isConnected || isRequested
                  ? const BorderSide(color: _roleColor, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isConnect) ...[
                Icon(Icons.person_add_alt_1, size: 14.sp),
                SizedBox(width: 6.w),
              ],
              Text(
                liveBrother.status,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
