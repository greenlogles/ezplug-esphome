# CLAUDE.md

ESPHome config for TH3D EZPlug v2 plugs (ESP32-C3, esp-idf, BL0937). See README.md for pinout and migration steps.

- Build/flash: `./flash.sh [ip] [config.yaml]`. It runs the ESPHome Docker image and flashes over OTA on port 3232. There is no local esphome install.
- Secrets are not in the repo. `flash.sh` mounts `~/esp/secrets.yaml` (override with `SECRETS=`). Never commit `secrets.yaml`.
- `.esphome/` is the build cache, and the Docker container creates it as root. Never commit it.
- To view logs: `docker run --rm --network host -v $PWD:/config -v ~/esp/secrets.yaml:/config/secrets.yaml:ro ghcr.io/esphome/esphome:latest logs <config>.yaml --device <ip>`. It streams until killed.
- Config style follows the user's other ESPHome plugs in `~/ha-config/esphome/sonoff-s31-*.yaml`.
- Logger must stay on `USB_SERIAL_JTAG`, because GPIO20 (UART0 RX) is the button.
- The BL0937 SEL pin must be `inverted: True`. Without it, voltage was reported as current (verified on the device).
- Plug 172.16.3.68 (`ezplug-073548`) is already migrated to the ESPHome partition table, so plain OTA works.
