#!/usr/bin/env sh

cd out/

cat <<XML
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <title>Packrat386's Blog</title>
  <id>https://packrat386.com/blog/</id>
  <link rel="self" href="https://packrat386.com/blog/feed.xml" />
  <link rel="alternate" href="https://packrat386.com/blog/" />
  <author><name>packrat386</name></author>
  <updated>$(date -u +%Y-%m-%dT%H:%M:%SZ)</updated>
XML

for fname in $(find blog/ -type f -name '*.html' -not -name index.html); do
  echo "<entry>"
  cat ${fname} | grep -Eo '<title>.*</title>'
  printf '<id>https://packrat386.com/%s</id>\n' "${fname}"
  printf '<link rel="alternate" href="https://packrat386.com/%s" />\n' "${fname}"
  cat ${fname} | grep '<meta name="dcterms.date"' | sed -E 's/^[[:space:]]+<meta name=".*" content="(.*)" \/>/<updated>\1T00:00:00Z<\/updated>/'
  echo "</entry>"
done

echo "</feed>"
