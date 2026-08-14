enum ConnectorAvailability { available, requiresApproval, unavailable }

class ConnectorStatus {
  const ConnectorStatus({required this.availability, required this.message});
  final ConnectorAvailability availability;
  final String message;
}

abstract interface class EarningsConnector {
  String get providerName;
  ConnectorStatus get status;
}

class UberEarningsConnector implements EarningsConnector {
  const UberEarningsConnector();
  @override
  String get providerName => 'Uber';
  @override
  ConnectorStatus get status => const ConnectorStatus(
        availability: ConnectorAvailability.requiresApproval,
        message: 'Uber Drivers API is limited access. OAuth must run through a secured backend after approval.',
      );
}

class DidiEarningsConnector implements EarningsConnector {
  const DidiEarningsConnector();
  @override
  String get providerName => 'DiDi';
  @override
  ConnectorStatus get status => const ConnectorStatus(
        availability: ConnectorAvailability.unavailable,
        message: 'No verified public Australian driver-earnings API is configured. Import a DiDi statement CSV.',
      );
}
