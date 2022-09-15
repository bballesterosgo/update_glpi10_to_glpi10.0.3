#!/bin/bash
#
# Script para actualizar GLPI a la versión 10.0.1
#
# Copyright (C) 2022 by TICgal
## Variables
fecha="$( date '+%F' )"
plugin="costs scalade itilcategorygroups oauthimap"
propietario="www-data"
usuario="ticgal"
php glpi/bin/console -n glpi:maintenance:enable
echo Iniciando actualización de GLPI ...
wget https://github.com/glpi-project/glpi/releases/download/10.0.3/glpi-10.0.3.tgz
tar -xvzf glpi-10.0.3.tgz
chown -R $propietario:$propietario *
php glpi/bin/console -n glpi:database:update
php glpi/bin/console -n glpi:system:clear_cache
php glpi/bin/console -n glpi:migration:myisam_to_innodb
php glpi/bin/console -n glpi:migration:timestamps
php glpi/bin/console -n glpi:migration:utf8mb4
php glpi/bin/console -n glpi:migration:unsigned_keys
php glpi/bin/console -n glpi:plugin:activate $plugin
php glpi/bin/console -n glpi:system:clear_cache
rm -f glpi/install/install.php
php glpi/bin/console -n glpi:maintenance:disable
# Establecer permisos de lectura para GLPI (propietario)
chmod -R 0500 glpi/
# Establecer permisos de escritura para directorio config
chmod -R 0700 glpi/config/
# Establecer permisos de lectura para el archivo de configuración
chmod -R 0400 glpi/config/config_db.php
# Establecer permisos de lectura y escritura para files y marketplace (propietario)
chmod -R 0700 glpi/files
chmod -R 0700 glpi/marketplace
# Propietario
chown -R $propietario:$propietario *
rm -f update_glpi10_to_glpi10.0.3.sh
