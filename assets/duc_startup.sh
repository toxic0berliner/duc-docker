#!/bin/bash
# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/*

# Set variable for index.cgi path
index_file="/var/www/duc/index.html"

# Check for existing index.cgi and remove it
if [ -f "/var/www/duc/index.cgi" ]; then
  rm -f "/var/www/duc/index.cgi"
fi

# Check for existing index and empty it if it exists, ensure it is executable
if [ -f "$index_file" ]; then
  > "$index_file"
  chmod 644 "$index_file"
fi

db_dir="/duc/db/"
# Start building the index.cgi content
index_content="#!/bin/sh
echo 'Content-type: text/html'
echo ''
echo '<html><head><title>Available DUC databases</title></head><body>'"
echo "<ul>" >> "$index_file"

for file in "${db_dir}"*.db; do
	[ -f "${file}" ] || break
	filename="$(basename "${file}")"
	filename="${filename%.*}"
	# Add a link to the index.cgi, skip if filename is duc or index
	if [[ "$filename" != "duc" && "$filename" != "index" ]]; then
		echo "#!/bin/sh
		/usr/local/bin/duc cgi $DUC_CGI_OPTIONS -d ${file}" > /var/www/duc/"${filename}".cgi
		chmod +x /var/www/duc/"${filename}".cgi
		echo "<li><a href=\"/${filename}.cgi\">${filename}</a></li>" >> "$index_file"
	fi
done

echo "</ul>" >> "$index_file"
echo "</body></html>" >> "$index_file"

/usr/sbin/apache2ctl -D FOREGROUND
