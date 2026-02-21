/// Defines the available navigation tabs in the application
enum NavigationTab {
  home,
  analysis,
  transactions,
  budgets,
  profile,
}

/// Extension to get human-readable names or indices if needed later
extension NavigationTabExtension on NavigationTab {
  String get label {
    switch (this) {
      case NavigationTab.home:
        return 'Home';
      case NavigationTab.analysis:
        return 'Analysis';
      case NavigationTab.transactions:
        return 'Transactions';
      case NavigationTab.budgets:
        return 'Budgets';
      case NavigationTab.profile:
        return 'Profile';
    }
  }
}