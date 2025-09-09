#!/bin/bash

# Script para generar wordlists por defecto para herramientas que las requieren
# Esto mejora la compatibilidad con n8n al tener datos de entrada pre-configurados

echo "📝 Generando wordlists por defecto para herramientas Docker..."
echo "================================================================"

# Crear directorios si no existen
mkdir -p data/{ffuf,hashcat,dirsearch}/wordlists
mkdir -p data/hashcat/hashes

# Wordlist común para FFUF y Dirsearch
echo "🔤 Generando wordlist común..."
cat > data/ffuf/wordlists/common.txt << 'EOF'
admin
login
wp-admin
phpmyadmin
config
backup
test
api
docs
robots.txt
sitemap.xml
.htaccess
.htpasswd
EOF

# Copiar a otros directorios
cp data/ffuf/wordlists/common.txt data/dirsearch/wordlists/common.txt

# Wordlist específica para directorios web
echo "📁 Generando wordlist de directorios web..."
cat > data/ffuf/wordlists/directories.txt << 'EOF'
admin
administrator
adm
login
wp-admin
wp-content
wp-includes
phpmyadmin
config
backup
backups
test
testing
dev
development
staging
prod
production
api
v1
v2
docs
documentation
help
support
assets
images
css
js
uploads
downloads
temp
tmp
cache
logs
.htaccess
.htpasswd
robots.txt
sitemap.xml
EOF

# Wordlist para subdominios
echo "🌐 Generando wordlist de subdominios..."
cat > data/ffuf/wordlists/subdomains.txt << 'EOF'
www
mail
ftp
admin
blog
shop
store
api
dev
test
staging
prod
cdn
static
assets
img
images
css
js
upload
download
backup
db
database
sql
mysql
postgres
redis
cache
monitor
grafana
kibana
jenkins
git
gitlab
github
jira
confluence
EOF

# Wordlist para archivos
echo "📄 Generando wordlist de archivos..."
cat > data/ffuf/wordlists/files.txt << 'EOF'
index.php
index.html
index.htm
default.asp
default.aspx
web.config
.htaccess
.htpasswd
robots.txt
sitemap.xml
favicon.ico
crossdomain.xml
clientaccesspolicy.xml
security.txt
.well-known/security.txt
.well-known/host-meta
.well-known/robots.txt
EOF

# Wordlist para parámetros
echo "🔍 Generando wordlist de parámetros..."
cat > data/ffuf/wordlists/parameters.txt << 'EOF'
id
page
search
q
query
keyword
category
tag
user
username
email
password
pass
pwd
token
key
api_key
secret
file
path
url
redirect
next
target
dest
destination
callback
return
returnTo
goto
EOF

# Wordlist para tecnologías
echo "⚙️ Generando wordlist de tecnologías..."
cat > data/ffuf/wordlists/technologies.txt << 'EOF'
wordpress
joomla
drupal
magento
shopify
woocommerce
laravel
django
flask
express
node
php
asp
aspx
jsp
cfm
pl
py
rb
java
.net
spring
struts
hibernate
mybatis
symfony
codeigniter
cakephp
yii
zend
phalcon
slim
silex
EOF

# Wordlist para CMS
echo "📰 Generando wordlist de CMS..."
cat > data/ffuf/wordlists/cms.txt << 'EOF'
wp-admin
wp-content
wp-includes
wp-config.php
wp-login.php
wp-register.php
wp-cron.php
wp-load.php
wp-settings.php
wp-blog-header.php
wp-trackback.php
wp-comments-post.php
wp-mail.php
wp-links-opml.php
wp-rdf.php
wp-rss.php
wp-rss2.php
wp-atom.php
wp-feed.php
wp-sitemap.php
wp-cron.php
wp-cron.php?doing_wp_cron
wp-admin/admin-ajax.php
wp-admin/admin-post.php
wp-admin/admin-functions.php
wp-admin/admin-header.php
wp-admin/admin.php
wp-admin/async-upload.php
wp-admin/custom-header.php
wp-admin/customize.php
wp-admin/edit-comments.php
wp-admin/edit-form-advanced.php
wp-admin/edit-form-comment.php
wp-admin/edit-form.php
wp-admin/edit-link-categories.php
wp-admin/edit-links.php
wp-admin/edit-pages.php
wp-admin/edit-post.php
wp-admin/edit-tags.php
wp-admin/edit.php
wp-admin/export.php
wp-admin/import.php
wp-admin/index.php
wp-admin/link-add.php
wp-admin/link-manager.php
wp-admin/media-new.php
wp-admin/media.php
wp-admin/menu-header.php
wp-admin/menu.php
wp-admin/moderation.php
wp-admin/my-sites.php
wp-admin/nav-menus.php
wp-admin/network.php
wp-admin/options-discussion.php
wp-admin/options-general.php
wp-admin/options-head.php
wp-admin/options-media.php
wp-admin/options-permalink.php
wp-admin/options-privacy.php
wp-admin/options-reading.php
wp-admin/options-writing.php
wp-admin/options.php
wp-admin/plugin-editor.php
wp-admin/plugin-install.php
wp-admin/plugins.php
wp-admin/post-new.php
wp-admin/post.php
wp-admin/press-this.php
wp-admin/profile.php
wp-admin/setup-config.php
wp-admin/theme-editor.php
wp-admin/theme-install.php
wp-admin/themes.php
wp-admin/tools.php
wp-admin/update-core.php
wp-admin/update.php
wp-admin/upgrade.php
wp-admin/user-edit.php
wp-admin/user-new.php
wp-admin/users.php
wp-admin/widgets.php
EOF

# Wordlist para vulnerabilidades
echo "🛡️ Generando wordlist de vulnerabilidades..."
cat > data/ffuf/wordlists/vulnerabilities.txt << 'EOF'
admin
administrator
adm
login
wp-admin
phpmyadmin
config
backup
test
api
docs
robots.txt
sitemap.xml
.htaccess
.htpasswd
shell
cmd
command
exec
system
passthru
eval
assert
include
require
include_once
require_once
file_get_contents
file_put_contents
fopen
fwrite
fread
unlink
rmdir
mkdir
chmod
chown
copy
move
rename
delete
drop
insert
update
select
union
select
insert
update
delete
drop
create
alter
truncate
rename
index
view
procedure
function
trigger
event
database
table
column
row
record
field
value
data
info
information
config
configuration
setting
option
parameter
argument
input
output
result
response
request
query
sql
mysql
postgres
oracle
sqlite
mssql
db
database
backup
restore
dump
export
import
sync
replicate
cluster
master
slave
primary
secondary
replica
backup
archive
log
logs
error
debug
trace
profile
monitor
status
health
check
ping
test
testing
dev
development
staging
prod
production
live
beta
alpha
demo
sample
example
template
default
custom
user
admin
root
guest
anonymous
public
private
secret
hidden
internal
external
local
remote
internal
external
local
remote
EOF

# Crear archivo de hashes de ejemplo para Hashcat
echo "🔐 Generando archivo de hashes de ejemplo..."
cat > data/hashcat/hashes/example_hashes.txt << 'EOF'
5f4dcc3b5aa765d61d8327deb882cf99
21232f297a57a5a743894a0e4a801fc3
827ccb0eea8a706c4c34a16891f84e7b
098f6bcd4621d373cade4e832627b4f6
d8578edf8458ce06fbc5bb76a58c5ca4
EOF

# Crear archivo de configuración para herramientas
echo "⚙️ Generando archivos de configuración..."
cat > data/ffuf/config.json << 'EOF'
{
  "wordlists": {
    "common": "common.txt",
    "directories": "directories.txt",
    "subdomains": "subdomains.txt",
    "files": "files.txt",
    "parameters": "parameters.txt",
    "technologies": "technologies.txt",
    "cms": "cms.txt",
    "vulnerabilities": "vulnerabilities.txt"
  },
  "default_options": {
    "threads": 50,
    "timeout": 10,
    "follow_redirects": true,
    "ignore_body": false
  }
}
EOF

# Mostrar estadísticas
echo ""
echo "📊 Estadísticas de wordlists generadas:"
echo "========================================"
echo "FFUF:"
wc -l data/ffuf/wordlists/*.txt | tail -1
echo ""
echo "Hashcat:"
wc -l data/hashcat/hashes/*.txt | tail -1
echo ""
echo "Dirsearch:"
wc -l data/dirsearch/wordlists/*.txt | tail -1

echo ""
echo "✅ Wordlists generadas exitosamente!"
echo ""
echo "📋 Wordlists disponibles:"
echo "  • common.txt - Palabras comunes"
echo "  • directories.txt - Directorios web"
echo "  • subdomains.txt - Subdominios"
echo "  • files.txt - Archivos comunes"
echo "  • parameters.txt - Parámetros de URL"
echo "  • technologies.txt - Tecnologías web"
echo "  • cms.txt - Sistemas de gestión de contenido"
echo "  • vulnerabilities.txt - Patrones de vulnerabilidades"
echo ""
echo "🚀 Ahora las herramientas FFUF, Hashcat y Dirsearch son 100% compatibles con n8n!"
