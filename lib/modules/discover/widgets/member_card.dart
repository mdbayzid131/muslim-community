import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/data/models/user_model.dart';

class MemberCard extends StatelessWidget {
  final UserModel user;
  final int index;
  final VoidCallback onConnect;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final VoidCallback? onTap;

  const MemberCard({
    super.key,
    required this.user,
    required this.index,
    required this.onConnect,
    required this.onCancel,
    required this.onConfirm,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final roleColor = AppColors.getRoleColor(user.role);

    final isConnected = user.connectionStatus.toLowerCase() == 'connected' ||
        user.connectionStatus.toLowerCase() == 'accepted';
    final isRequested = user.connectionStatus.toLowerCase() == 'pending' ||
        user.connectionStatus.toLowerCase() == 'requested';
    final isReceived = user.connectionStatus.toLowerCase() == 'received';

    return GestureDetector(
      onTap: onTap,
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
                  child: user.image.isNotEmpty &&
                          user.image.startsWith('http')
                      ? Image.network(
                          user.image,
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
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                ),
                if (user.isOnline)
                  Positioned(
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
                  ),
                if (user.isVerified)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: roleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 10.sp,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8.h),

            // --- NAME ---
            Text(
              user.name,
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
              '${user.age > 0 ? user.age : 20} • ${user.revertDateFormatted}',
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                color: const Color(0xFF636E72),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 6.h),

            // --- DISTANCE BADGE ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: roleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 10.sp, color: roleColor),
                  SizedBox(width: 4.w),
                  Text(
                    '${user.distance.isNotEmpty ? user.distance : "1.0"} mi',
                    style: GoogleFonts.inter(
                        fontSize: 10.sp, color: roleColor),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // --- ACTION BUTTON ---
            if (isReceived)
              SizedBox(
                width: double.infinity,
                height: 32.h,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: roleColor,
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
              )
            else
              SizedBox(
                width: double.infinity,
                height: 32.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (isRequested) {
                      onCancel();
                    } else if (!isConnected) {
                      onConnect();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isConnected || isRequested
                        ? Colors.white
                        : roleColor,
                    foregroundColor: isConnected || isRequested
                        ? roleColor
                        : Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: isConnected || isRequested
                          ? BorderSide(color: roleColor, width: 1.5)
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isConnected && !isRequested) ...[
                        Icon(Icons.person_add_alt_1, size: 14.sp),
                        SizedBox(width: 6.w),
                      ],
                      Text(
                        isConnected
                            ? 'Connected'
                            : isRequested
                                ? 'Requested'
                                : 'Connect',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
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
