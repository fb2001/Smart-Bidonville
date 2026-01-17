import '../../core/models/fan_mode.dart';
import '../../core/models/fan_speed.dart';
import '../../l10n/app_localizations.dart';

extension FanModeLocalization on FanMode {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case FanMode.auto:
        return l10n.fanModeAuto;
      case FanMode.manual:
        return l10n.fanModeManual;
    }
  }
}

extension FanSpeedLocalization on FanSpeed {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case FanSpeed.slow:
        return l10n.fanSpeedSlow;
      case FanSpeed.medium:
        return l10n.fanSpeedMedium;
      case FanSpeed.fast:
        return l10n.fanSpeedFast;
    }
  }
}
