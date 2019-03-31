# DB UCV FHE

## Prerequisites
Have installed PostgreSQL 9 or higher on the local machine with any operating system (Linux, Windows or Mac 'OS) or DOCKER CE

## Install Database and Usage

### Install database via the Linux console
-- 1 Clone clone the repository db
```bash
$ git clone https://gitlab.com/ucv-fhe/db.git
```
-- 2 Create Database in postgres using syntax via console
```bash
$ sudo -i -u postgres
$ psql
$ psql: CREATE DATABASE db_ucv_fhe_sist;
$ psql: \q
```
-- 3  go to the folder where the files are and run the file **install_database.sh**
```bash
$ sudo -i -u postgres
$ cd /home/${USER}/db/
$ sh install_database.sh
```

### Install database via DOCKER
-- 1 Clone clone the repository db
```bash
$ git clone https://gitlab.com/ucv-fhe/db.git
```

-- 2  Go to the folder where the files are and run the file and build the image through the **Dockerfile**
```bash
$ cd /db/
$ docker volume create postgres
$ docker build -t db_ucv .
```
-- 3 Already with the created image run the command docker run to create the container
```bash
$ docker run -itd --restart always --name db_ucv -p 5440:5432 --mount source=postgres,target=/db --network ucv_fhe db_ucv
```
