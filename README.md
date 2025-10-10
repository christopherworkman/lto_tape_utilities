Stage data in /mnt/staging 8 TB SSD

Ti2 Microscope computer mounted at /mnt/winG and /mnt/winD

# Run write_archive.sh to write archive

sudo -v

sudo nohup ./write_archive.sh &

# Monitor Progress

less "${FILE%.*}_tar.log"

# Quickly read the name of the first file in each archive

read_all_archives_first_file.sh

# Fast forward one archive

sudo mt -f /dev/nst0 fsf 1

# Rewind tape

sudo mt -f /dev/nst0 rewind

# Check tape status

sudo mt -f /dev/nst0 status
