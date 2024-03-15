# WDemo - Installation of MariaDB

## Install mariadb with Helm

Check file `mariadb-values.yaml`

```yaml
auth:
  rootPassword: "root123"
  database: "wdemo"
  username: "dew"
  password: "dew123"

initdbScripts:
  dew_init_script.sh: |
    #!/bin/bash
    echo "dew_init_script."
  dew_init_script.sql: |
    CREATE DATABASE IF NOT EXISTS `wdemo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
    USE `wdemo`;
    
    CREATE TABLE IF NOT EXISTS `ana_regioni` (
      `ID_REGIONE` varchar(3) NOT NULL,
      `DESCRIZIONE` varchar(255) NOT NULL,
      PRIMARY KEY (`ID_REGIONE`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    
    /*!40000 ALTER TABLE `ana_regioni` DISABLE KEYS */;
    INSERT INTO `ana_regioni` (`ID_REGIONE`, `DESCRIZIONE`) VALUES
        ('000', '-'),
        ('010', 'PIEMONTE'),
        ('020', 'VALLE D\'AOSTA'),
        ('030', 'LOMBARDIA'),
        ('041', 'PROVINCIA AUT. BOLZANO'),
        ('042', 'PROVINCIA AUT. TRENTO'),
        ('050', 'VENETO'),
        ('060', 'FRIULI VENEZIA GIULIA'),
        ('070', 'LIGURIA'),
        ('080', 'EMILIA ROMAGNA'),
        ('090', 'TOSCANA'),
        ('100', 'UMBRIA'),
        ('110', 'MARCHE'),
        ('120', 'LAZIO'),
        ('130', 'ABRUZZO'),
        ('140', 'MOLISE'),
        ('150', 'CAMPANIA'),
        ('160', 'PUGLIA'),
        ('170', 'BASILICATA'),
        ('180', 'CALABRIA'),
        ('190', 'SICILIA'),
        ('200', 'SARDEGNA'),
        ('777', 'NON DISPONIBILE'),
        ('900', 'ESTERO'),
        ('999', 'REGIONE DI STATO ESTERO NON DISPON.');
    /*!40000 ALTER TABLE `ana_regioni` ENABLE KEYS */;
```

`helm install mariadb-dew -f mariadb-values.yaml bitnami/mariadb`

Wait a few minutes and check installation:

`helm status mariadb-dew`

Connect to pod shell:

`kubectl exec -ti mariadb-dew-0 -- bash`

Connect to database:

`mariadb --user=root --password=root123`

`show databases;`

`use wdemo;`

`show tables;`

`select * from ana_regioni;`

## Uninstall

`helm uninstall mariadb-dew`

## Install mariadb with Docker

`docker pull bitnami/mariadb:11.1.2-debian-11-r0`

`docker volume create wdemo-mariadb-vol`

`docker run --name mariadb-dew -e MARIADB_ROOT_PASSWORD=root123 -e MARIADB_DATABASE=wdemo -e MARIADB_USER=dew -e MARIADB_PASSWORD=dew123 --mount source=wdemo-mariadb-vol,target=/bitnami/mariadb -d bitnami/mariadb:11.1.2-debian-11-r0`

`docker cp wdemo-schema.sql mariadb-dew:/tmp`

`docker cp wdemo-schema.sh mariadb-dew:/tmp`

`docker exec -w /tmp mariadb-dew ./wdemo-schema.sh`

`docker exec -u 0 mariadb-dew /bin/rm -fr /tmp/wdemo-schema.sql`

`docker exec -u 0 mariadb-dew /bin/rm -fr /tmp/wdemo-schema.sh`

## Build mariadb image

`docker build -t mariadb-dew .`

`docker run --name mariadb-dew -d mariadb-dew`

`docker exec -w /tmp mariadb-dew ./wdemo-schema.sh`

## Contributors

* [Giorgio Silvestris](https://github.com/giosil)
