Stage data in /mnt/staging 8 TB SSD

Ti2 Microscope computer mounted at /mnt/winG and /mnt/winD

# Run write_archive.sh to write archive
```
sudo -v
sudo nohup ./write_archive.sh &
```
# Monitor Progress
```
less "${FILE%.*}_tar.log"
```
# Quickly read the name of the first file in each archive
```
./read_all_archives_first_file.sh
```
# Fast forward one archive
```
sudo mt -f /dev/nst0 fsf 1
```
# Rewind tape
```
sudo mt -f /dev/nst0 rewind
```
# Check tape status
```
sudo mt -f /dev/nst0 status
```
# Extract archive

fsf to desired archive

```
sudo -v
sudo nohup bash -c '
  tar -xvf /dev/nst0 -C /mnt/staging \
      --strip-components=2 "mnt/staging/filename.ext" \
    > /mnt/staging/log_title.log 2>&1
' &

tail -f /mnt/staging/round4_2348on_extract.log
```
