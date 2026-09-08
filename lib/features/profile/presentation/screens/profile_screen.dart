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
    final isEditingName = useState(false);
    final nameFocusNode = useFocusNode();
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

    useEffect(() {
      void listener() {
        if (!nameFocusNode.hasFocus && isEditingName.value) {
          // Revert and exit edit mode if focus is lost without saving
          isEditingName.value = false;
          nameController.text = user?.name ?? '';
        }
      }

      nameFocusNode.addListener(listener);
      return () => nameFocusNode.removeListener(listener);
    }, [user?.name]);

    Future<void> saveProfile() async {
      if (formKey.currentState?.validate() != true) return;

      isEditingName.value = false;
      final newName = nameController.text.trim();

      final failure = await ref
          .read(updateProfileNotifierProvider.notifier)
          .updateProfile(newName);

      if (!context.mounted) return;

      if (failure != null) {
        showFailureToast(context, failure);
        nameController.text = user?.name ?? '';
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
      final mailUri = Uri(scheme: 'mailto', path: Constants.supportEmail);

      var launched = false;
      try {
        launched = await launchUrl(mailUri);
      } on Object {
        launched = false;
      }

      if (launched || !context.mounted) return;

      await Clipboard.setData(
        const ClipboardData(text: Constants.supportEmail),
      );
      if (context.mounted) {
        showMessageToast(context.tr.contactUsNoMailApp);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
                      Gap.custom(height: _avatarSize / 2 + 16),
                      if (isEditingName.value)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: nameController,
                                  focusNode: nameFocusNode,
                                  textAlign: TextAlign.center,
                                  autofocus: true,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onFieldSubmitted: (_) => saveProfile(),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.blue),
                                onPressed: saveProfile,
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 48), // Balance for edit icon
                            Text(
                              displayName,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () {
                                isEditingName.value = true;
                                nameFocusNode.requestFocus();
                              },
                            ),
                          ],
                        ),
                      Gap.v8(),
                      Text(
                        PersianDigits.toPersian(user.mobileNumber),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Gap.v32(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SettingsActionsCard(
                          isBusy: isBusy,
                          logoutState: logoutState,
                          deleteAccountState: deleteAccountState,
                          onContactSupport: contactSupport,
                          onLogout: confirmLogout,
                          onDeleteAccount: confirmDeleteAccount,
                        ),
                      ),
                      Gap.v16(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _SettingsActionsCard extends StatelessWidget {
  const _SettingsActionsCard({
    required this.isBusy,
    required this.logoutState,
    required this.deleteAccountState,
    required this.onContactSupport,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final bool isBusy;
  final AsyncValue logoutState;
  final AsyncValue deleteAccountState;
  final VoidCallback onContactSupport;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final destructiveColor = Colors.red.shade600;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            onTap: onContactSupport,
            leading: const Icon(Icons.email_outlined, color: cPrimary),
            title: Text(context.tr.contactUsTitle),
            subtitle: Text(
              context.tr.contactUsSubtitle,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            onTap: isBusy ? null : onLogout,
            leading: logoutState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Icon(Icons.logout_rounded, color: destructiveColor),
            title: Text(
              context.tr.logout,
              style: TextStyle(
                color: destructiveColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            onTap: isBusy ? null : onDeleteAccount,
            leading: deleteAccountState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Icon(Icons.delete_outline_rounded, color: destructiveColor),
            title: Text(
              context.tr.deleteAccount,
              style: TextStyle(
                color: destructiveColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
          ),
        ],
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
