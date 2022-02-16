#!/bin/bash

check_ram() {
  server=$1

  echo "<h3>RAM usage</h3>" >> compliance.html

  ram_used_frac=$(yes | ssh "$server" "free | grep Mem | awk '{print \$3/\$2}'")
  ram_used_percentage=$(echo "$ram_used_frac" | cut -f2 -d. | cut -c 1-2)

  echo "<div>$ram_used_percentage% RAM used.</div>" >> compliance.html
  if [[ $ram_used_percentage -ge 85 ]]; then
    echo "<div><b>WARNING: check server for high RAM usage.</b></div>" >> compliance.html
  fi
}

check_cpu() {
  server=$1

  echo "<h3>CPU usage</h3>" >> compliance.html

  cpu_used_percentage=$(yes | ssh "$server" "grep 'cpu ' /proc/stat | awk '{usage=(\$2+\$4)*100/(\$2+\$4+\$5)} END {print usage}'")

  echo "<div>$cpu_used_percentage% CPU used.</div>" >> compliance.html

  cpu_used_percentage=$(echo "$cpu_used_percentage" | cut -f1 -d.)

  if [[ $cpu_used_percentage -ge 85 ]]; then 
    echo "<div><b>WARNING: check server for high CPU usage.</b></div>" >> compliance.html
  fi
}

check_disks() {
  server=$1

  echo "<h3>Disk space and health</h3><pre>" >> compliance.html
  yes | ssh "$server" "for drive in \$( lsblk --nodeps --noheadings | awk '{ print \$1 }' ); do smartctl -t short /dev/\$drive && smartctl -H /dev/\$drive; done" >> compliance.html
  echo "</pre>" >> compliance.html
 
  echo "<table rules=\"all\"><tr><th>FS</th><th>Size</th><th>Used</th><th>Avail</th><th>Use percentage</th><th>Mountpoint</th></tr>" >> compliance.html

  warn=0

  yes | ssh "$server" "df -h | grep /dev | sed -e 1d" | \
  while read -r row; do
    read -ra arr <<< "$row"
    fs="${arr[0]}"
    size="${arr[1]}"
    used="${arr[2]}"
    avail="${arr[3]}"
    use_percentage="${arr[4]}"
    mountpoint="${arr[5]}"

    echo "<tr><td>$fs</td><td>$size</td><td>$used</td><td>$avail</td><td>$use_percentage</td><td>$mountpoint</td></tr>" >> compliance.html

    use_percentage=${use_percentage%\%}
    if [[ "$use_percentage" -ge 85 ]]; then
      warn=1
    fi
  done

  echo "</table>" >> compliance.html

  if [[ $warn -eq 1 ]]; then
    echo "<div><b>WARNING: prepare to expand storage!</b></div>" >> compliance.html
  fi
}

check_security() {
  server=$1

  echo "<h3>Security patches</h3><pre>" >> compliance.html
  yes | ssh "$server" "yum updateinfo list updates security" >> compliance.html
  echo "</pre>" >> compliance.html
  echo "<div>" >> compliance.html
  yes | ssh "$server" "yum updateinfo list updates security | sed -e 1d | wc -l" >> compliance.html
  echo " security updates pending.</div>" >> compliance.html
}

check_server() {
  server=$1

  echo "$server"
  echo "<h2>$server</h2>" >> compliance.html

  check_ram "$server"
  check_cpu "$server"
  check_disks "$server"
  check_security "$server"
}

echo "Generating reports..."

echo "<html><body><h1>Compliance report</h1>" > compliance.html

while read -r server
do
  check_server "$server"
done < "servers"

echo "</body></html>" >> compliance.html
