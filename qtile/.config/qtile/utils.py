import os

BACKLIGHT_PATH = "/sys/class/backlight"


def guess_backlight_device():
    if not os.path.isdir(BACKLIGHT_PATH):
        return None

    devices = os.listdir(BACKLIGHT_PATH)
    if not devices:
        return None

    # prefre acpi_video0
    if "acpi_video0" in devices:
        return "acpi_video0"
    return devices[0]
