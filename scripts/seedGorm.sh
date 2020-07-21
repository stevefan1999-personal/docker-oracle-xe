#!/bin/bash

. oraenv 

echo "Seeding Gorm for CI/CD testing"
sqlplus / as sysdba @/opt/oracle/scripts/gorm_init.sql