# OBD-II expandable live dashboard

Changes in this build:

- `ObdDiagnosticsCard` is now expandable/collapsible with `AnimatedSize`, `AnimatedSwitcher`, `AnimatedRotation`, and animated gauges.
- While expanded and connected, diagnostics refresh automatically every 3 seconds. Refresh calls are skipped while another read/connect operation is already running.
- Added live gauges for:
  - RPM (`010C`)
  - Vehicle speed (`010D`)
  - Engine coolant temperature (`0105`)
- Added secondary live values for:
  - Adapter/vehicle voltage (`ATRV`)
  - Calculated engine load (`0104`)
  - Throttle position (`0111`)
  - Intake air temperature (`010F`)
- Stored DTCs are still shown from Mode `03`.
- Unsupported PIDs are nullable and simply do not render in the secondary metrics area.

No new Flutter package is required for this UI update.
