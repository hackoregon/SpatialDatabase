#! /bin/bash
#
# Copyright (C) 2013 by M. Edward (Ed) Borasky
#
# This program is licensed to you under the terms of version 3 of the
# GNU Affero General Public License. This program is distributed WITHOUT
# ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING THOSE OF NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Please refer to the
# AGPL (http://www.gnu.org/licenses/agpl-3.0.txt) for more details.
#

sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

# install the extensions
sudo su - postgres -c \
  "psql -c 'CREATE EXTENSION IF NOT EXISTS adminpack;'"
sudo su - postgres -c \
  "psql -c 'CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;'"

# create a non-root user - can can log in and create schemas/tables only!
sudo su - postgres -c "dropdb ${USER}"
sudo su - postgres -c "dropdb or_geocoder"
sudo su - postgres -c "dropdb us_geocoder"
sudo su - postgres -c "dropdb districts"
sudo su - postgres -c "dropuser ${USER}"
sudo su - postgres -c "createuser ${USER}"

# create a 'home' database for the user
sudo su - postgres -c "createdb --owner=${USER} ${USER}"

# create 'spatial' tablespace
export HERE=`pwd`
#sudo su - postgres -c "psql -f ${HERE}/make-tablespace.sql"
sudo ls -altr /home/spatial

# VACUUM!
time sudo su - postgres -c "vacuumdb --all --analyze"
