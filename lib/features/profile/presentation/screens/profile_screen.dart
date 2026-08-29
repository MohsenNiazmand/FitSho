import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitsho/config/router/routes.dart';
import 'package:fitsho/config/theme/app_radius.dart';
import 'package:fitsho/core/constants/app_assets.dart';
import 'package:fitsho/core/constants/colors.dart';
import 'package:fitsho/core/constants/constants.dart';
import 'package:fitsho/core/extensions/context_extensions.dart';
import 'package:fitsho/core/utils/persian_digits.dart';
import 'package:fitsho/features/auth/presentation/providers/current_user_provider.dart';
import 'package:fitsho/features/auth/presentation/providers/delete_account_provider.dart';
import 'package:fitsho/features/auth/presentation/providers/logout_provider.dart';
import 'package:fitsho/features/profile/presentation/providers/profile_providers.dart';
import 'package:fitsho/shared/presentation/utils/toast_utils.dart';
import 'package:fitsho/shared/presentation/widgets/app_image_cover.dart';
import 'package:fitsho/shared/presentation/widgets/app_loading_indicator.dart';
import 'package:fitsho/shared/presentation/widgets/app_primary_button.dart';
import 'package:fitsho/shared/presentation/widgets/gap.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  static const double _headerHeight = 200;
  static const double _avatarSize = 96;
  static const double _avatarBorderWidth = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final updateState = ref.watch(updateProfileNotifierProvider);
    final logoutState = ref.watch(logoutNotifierProvider);
    final deleteAccountState = ref.watch(deleteAccountNotifierProvider);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final nameController = useTextEditingController(text: user?.name ?? '');
    final isBusy = updateState.isLoading ||
        logoutState.isLoading ||
        deleteAccountState.isLoading;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayName = user?.name?.isNotEmpty ?? false
        ? user!.name!
        : context.tr.noDisplayName;

    useEffect(
      () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          ref.read(profileRefreshNotifierProvider.notifier).refreshUser();
        });
        return null;
      },
      const [],
    );

    useEffect(
      () {
        nameController.text = user?.name ?? '';
        return null;
      },
      [user?.name],
    );

    Future<void> saveProfile() async {
      if (formKey.currentState?.validate() != true) return;

      final failure = await ref
          .read(updateProfileNotifierProvider.notifier)
          .updateProfile(nameController.text.trim());

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      showSuccessToast(context.tr.profileUpdatedSuccess);
    }

    Future<void> confirmLogout() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(context.tr.logoutTitle),
            content: Text(context.tr.logoutConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(context.tr.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(context.tr.confirm),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !context.mounted) return;

      final failure =
          await ref.read(logoutNotifierProvider.notifier).logout();

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      context.go(AppRoutes.login);
    }

    Future<void> confirmDeleteAccount() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(context.tr.deleteAccountTitle),
            content: Text(context.tr.deleteAccountConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(context.tr.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(dialogContext).colorScheme.error,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(context.tr.confirm),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !context.mounted) return;

      final failure = await ref
          .read(deleteAccountNotifierProvider.notifier)
          .deleteAccount();

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        return;
      }

      context.go(AppRoutes.login);
    }

    Future<void> contactSupport() async {
      final mailUri = Uri(
        scheme: 'mailto',
        path: Constants.supportEmail,
        query: 'subject=${Uri.encodeComponent('FitSho Support')}',
      );

      final launched = await launchUrl(mailUri);
      if (launched || !context.mounted) return;

      await Clipboard.setData(
        const ClipboardData(text: Constants.supportEmail),
      );
      if (context.mounted) {
        showMessageToast(context.tr.contactUsNoMailApp);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: user == null
            ? const AppLoadingIndicator()
            : SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: 24 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProfileCoverHeader(colorScheme: colorScheme),
                    Gap.custom(height: _avatarSize / 2 + 8),
                    Text(
                      displayName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Gap.v8(),
                    Text(
                      PersianDigits.toPersian(user.mobileNumber),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cTextHint,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap.v32(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: nameController,
                        enabled: !isBusy,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          labelText: context.tr.displayNameLabel,
                          hintText: context.tr.displayNameHint,
                          alignLabelWithHint: false,
                          filled: true,
                          fillColor: cSurfaceElevated,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: cBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: cBorder.withValues(alpha: 0.9),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.6),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.tr.displayNameRequired;
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => saveProfile(),
                      ),
                    ),
                    Gap.v24(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: AppRadius.button,
                          boxShadow: [
                            BoxShadow(
                              color: cPrimary.withValues(alpha: 0.22),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: AppPrimaryButton(
                          label: context.tr.saveProfile,
                          isLoading: updateState.isLoading,
                          onPressed: isBusy ? null : saveProfile,
                        ),
                      ),
                    ),
                    Gap.v32(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: cSurfaceElevated,
                          borderRadius: AppRadius.card,
                          border: Border.all(color: cBorder),
                        ),
                        child: ListTile(
                          onTap: contactSupport,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.card,
                          ),
                          leading: Icon(
                            Icons.mail_outline_rounded,
                            color: colorScheme.primary,
                          ),
                          title: Text(context.tr.contactUsTitle),
                          subtitle: Text(context.tr.contactUsSubtitle),
                          trailing: const Icon(Icons.chevron_left_rounded),
                        ),
                      ),
                    ),
                    Gap.v32(),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: cDivider,
                      indent: 24,
                      endIndent: 24,
                    ),
                    Gap.v16(),
                    Center(
                      child: TextButton.icon(
                        onPressed: isBusy ? null : confirmLogout,
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        icon: logoutState.isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.error,
                                ),
                              )
                            : const Icon(Icons.logout_rounded, size: 20),
                        label: Text(context.tr.logout),
                      ),
                    ),
                    Center(
                      child: TextButton.icon(
                        onPressed: isBusy ? null : confirmDeleteAccount,
                        style: TextButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        icon: deleteAccountState.isLoading
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.error,
                                ),
                              )
                            : const Icon(
                                Icons.delete_forever_rounded,
                                size: 20,
                              ),
                        label: Text(context.tr.deleteAccount),
                      ),
                    ),
                    Gap.v8(),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _ProfileCoverHeader extends StatelessWidget {
  const _ProfileCoverHeader({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const avatarRadius = ProfileScreen._avatarSize / 2;
    const avatarBorder = ProfileScreen._avatarBorderWidth;

    return SizedBox(
      height: ProfileScreen._headerHeight + avatarRadius,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: ProfileScreen._headerHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AppImageCover(
                  assetPath: AppAssets.profileBg,
                  fit: BoxFit.cover,
                  overlayOpacity: 0.12,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 88,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.28),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: ProfileScreen._avatarSize + avatarBorder * 2,
              height: ProfileScreen._avatarSize + avatarBorder * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(avatarBorder),
              child: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  size: 44,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
