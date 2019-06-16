install postgresql:
  pkg.installed:
    - pkgs:
      - postgresql: 9.6+181+deb9u2

create baur db user:
  postgres_user.present:
    - name: baur
    - password: baur
    - user: postgres

create baur db RO user:
  postgres_user.present:
    - name: ro-baur
    - password: ro-baur
    - user: postgres

create baur db:
  postgres_database.present:
    - name: baur
    - owner: baur
    - user: postgres

set privileges for baur db:
  postgres_privileges.present:
    - name: baur
    - object_name: 'ALL'
    - object_type: table
    - privileges:
      - ALL
    - user: postgres

set privileges for ro-baur db:
  postgres_privileges.present:
    - name: ro-baur
    - object_type: table
    - privileges:
      - SELECT
    - user: postgres
