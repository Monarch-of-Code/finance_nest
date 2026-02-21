import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/widgets/navigaton/domain/navigation_service.dart'; // ✅ This is where NavigationTab lives

/// Notifier to manage the current navigation tab
class NavigationNotifier extends Notifier<NavigationTab> {
  @override
  NavigationTab build() {
    return NavigationTab.home;
  }

  void setTab(NavigationTab tab) {
    state = tab;
  }
}

/// Global provider for navigation state
final navigationProvider = NotifierProvider<NavigationNotifier, NavigationTab>(() {
  return NavigationNotifier();
});