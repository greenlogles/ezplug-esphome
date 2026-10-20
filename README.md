# EZPlug v2 → ESPHome

ESPHome firmware for a TH3D EZPlug v2 smart plug (ESP32-C3 / ESP8685, 4MB flash, BL0937 power meter), replacing the stock Tasmota-based firmware.

## Pinout

| GPIO | Function |
|------|----------|
| 4    | Relay |
| 20   | Button (active low) |
| 6    | Power LED (inverted, follows relay) |
| 1    | Status LED (inverted) |
| 7    | BL0937 CF |
| 3    | BL0937 CF1 |
| 5    | BL0937 SEL (inverted) |

Calibration was converted from the Tasmota values (PowerCal 9058, VoltageCal 1465, CurrentCal 3142). Voltage has been checked against Tasmota. Power and current have not yet been checked with a known load.

## Build & flash

Requires Docker. WiFi credentials come from a `secrets.yaml` file with `wifi_ssid`, `wifi_password` and `wifi_ap_failback_password` (default path: `~/esp/secrets.yaml`).

```sh
./flash.sh                     # 172.16.3.68, ezplug-073548.yaml
./flash.sh 172.16.3.99         # another plug
SECRETS=./secrets.yaml ./flash.sh
```

For another plug, copy the YAML file and change `device_name` in its substitutions.

## Migrating a plug from Tasmota

Only this OTA script works once a plug runs ESPHome. To move a new plug off Tasmota:

1. Add `allow_partition_access: true` under `ota:` and build the firmware.
2. In Tasmota, go to Firmware Upgrade → Upgrade by file upload, and upload `.esphome/build/<name>/build/firmware.ota.bin`. Tasmota reboots into safeboot first.
3. Migrate the partition table ([ESPHome guide](https://esphome.io/guides/migrate_sonoff_tasmota)). The app is about 900 KB, so use Indirect Method A:
   ```sh
   esphome upload --partition-table --file partitions_tasmota_migration_a.bin <config>.yaml
   esphome upload --partition-table --file partitions_esphome.bin <config>.yaml
   ```
   Keep power stable during these steps. A power cut mid-write needs a serial reflash to recover.
4. Remove `allow_partition_access` and flash again with `./flash.sh`.
