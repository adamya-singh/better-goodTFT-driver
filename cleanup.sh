#!/bin/bash

# Function to safely remove files with logging
safe_remove() {
    local file="$1"
    if [ -e "$file" ]; then
        echo "Removing: $file"
        rm -f "$file"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to remove $file"
            exit 1
        fi
    else
        echo "Warning: $file does not exist"
    fi
}

# Function to safely remove directories with logging
safe_remove_dir() {
    local dir="$1"
    if [ -d "$dir" ]; then
        echo "Removing directory: $dir"
        rm -rf "$dir"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to remove directory $dir"
            exit 1
        fi
    else
        echo "Warning: Directory $dir does not exist"
    fi
}

# Check if we're in the correct directory
if [ ! -f "MHS35-show" ]; then
    echo "Error: This script must be run from the directory containing MHS35-show"
    exit 1
fi

# Create a backup of the current state
echo "Creating backup of current state..."
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="backup_$timestamp"
mkdir -p "$backup_dir"
cp -r usr "$backup_dir/"
cp -r etc "$backup_dir/"
cp -r boot "$backup_dir/"
cp *.sh "$backup_dir/"
cp *.py "$backup_dir/"
cp *.deb "$backup_dir/"
cp *.tar.gz "$backup_dir/"
cp README.md "$backup_dir/"

echo "Starting cleanup process..."

# Remove unnecessary calibration configs
echo "Removing unnecessary calibration configs..."
for file in usr/99-calibration.conf-mhs35b-* \
            usr/99-calibration.conf-mhs32-* \
            usr/99-calibration.conf-mhs24 \
            usr/99-calibration.conf-HDMI7C \
            usr/99-calibration.conf-5-* \
            usr/99-calibration.conf-mhs397-* \
            usr/99-calibration.conf-mhs395-* \
            usr/99-calibration.conf-397-* \
            usr/99-calibration.conf-3971-* \
            usr/99-calibration.conf-43 \
            usr/99-calibration.conf-3508-* \
            usr/99-calibration.conf-24 \
            usr/99-calibration.conf-28 \
            usr/99-calibration.conf-32-* \
            usr/99-calibration.conf-35-*; do
    safe_remove "$file"
done

# Remove unnecessary overlay and device tree files
echo "Removing unnecessary overlay and device tree files..."
for file in usr/mis35-overlay.dtb \
            usr/qddpi18.dtb \
            usr/qddpi24.dtb \
            usr/ft6236.dtb \
            usr/goodix.dtbo \
            usr/goodix_dpi.dtb \
            usr/ads7846-overlay.dtb \
            usr/bcm2709-rpi-2-b.dtb \
            usr/bcm2710-rpi-3-b.dtb; do
    safe_remove "$file"
done

# Remove redundant configuration files
echo "Removing redundant configuration files..."
for file in usr/99-fbturbo.conf-original \
            usr/99-fbturbo.conf-HDMI \
            usr/cmdline.txt-original \
            usr/cmdline.txt-noobs-original \
            usr/cmdline.txt-noobs \
            usr/cmdline.txt \
            usr/local.desktop \
            usr/modules-HDMI; do
    safe_remove "$file"
done

# Remove unnecessary directories
echo "Removing unnecessary directories..."
safe_remove_dir "usr/fbcp-ili9341"

# Remove unnecessary libinput configs
echo "Removing unnecessary libinput configs..."
for file in usr/40-libinput.conf-*; do
    safe_remove "$file"
done

echo "Cleanup completed successfully!"
echo "A backup of the original files has been created in: $backup_dir"
echo "To restore the original state, run: cp -r $backup_dir/* ." 