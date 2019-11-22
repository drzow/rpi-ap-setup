# rpi-ap-setup
Script to setup a WiFi Access Point (AP) on the Raspberry Pi's (3 or 4) built-in WiFi interface with bridged (Internet) access out the secondary WiFi interface.

Based on https://gist.github.com/Lewiscowles1986/fecd4de0b45b2029c390

Changes from the original:
- Expanded DHCP space
- Retain Wireless Networking config for secondary WiFi interfaces (wlan1) (in progress)
- Set up a forwarded connection from the AP on wlan0 to wlan1 -- assuming wlan1 has Internet access,
  this will provide all AP users Internet access (in progress)
- Removed WPA configuration so that the Access Point is wide open -- NOTE: This is not what most
  users will want or need, but is necessary in limited settings (a public meeting space, in this case)
