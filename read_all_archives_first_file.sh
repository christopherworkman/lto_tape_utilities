#!/usr/bin/env bash
TAPE_NR=/dev/nst0    # non‑rewinding path for reads
TAPE_RW=/dev/st0     # rewinding alias (only for the initial rewind)

# 1) rewind once at the start
sudo mt -f "$TAPE_RW" rewind >/dev/null 2>&1

i=0
while :; do
  # 2) read the TAR header and extract the filename, silencing dd errors
  name=$(
    sudo dd if="$TAPE_NR" bs=10240 count=1 iflag=fullblock status=none 2>/dev/null \
      | head -c512 \
      | awk -v RS='\0' 'NR==1{print; exit}'
  )

  # 3) if empty, try skipping one file‑mark and retry
  if [[ -z $name ]]; then
    sudo mt -f "$TAPE_NR" fsf 1 >/dev/null 2>&1
    name=$(
      sudo dd if="$TAPE_NR" bs=10240 count=1 iflag=fullblock status=none 2>/dev/null \
        | head -c512 \
        | awk -v RS='\0' 'NR==1{print; exit}'
    )
    [[ -z $name ]] && break
  fi

  # 4) print the result
  printf 'archive %d : %s\n' "$i" "$name"

  # 5) advance one file‑mark, quiet any messages
  sudo mt -f "$TAPE_NR" fsf 1 >/dev/null 2>&1

  ((i++))
done

# 6) rewind when done (optional)
sudo mt -f "$TAPE_RW" rewind >/dev/null 2>&1

echo "Total archives: $i"
