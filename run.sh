#!/bin/bash

docker inspect fdb >/dev/null 2>&1 || docker run -d --name fdb foundationdb/fdb-server
docker inspect sql >/dev/null 2>&1 || docker run -d --volumes-from fdb --name sql foundationdb/sql-layer

case "$1" in

lefp)
  docker run -d --link sql:fdbsql -p 49080:80 foundationdb/lefp
  echo "Visit http://localhost:49080"
  ;;

dbal-test)
  docker run --link sql:fdbsql dbal-test
  ;;

spree)
  docker run -d --link sql:fdbsql --name spree foundationdb/spree init
  docker run -d --volumes-from spree --link spree:spree p 49085:80 --name spree-web foundationdb/spree-nginx
  echo "Visit http://localhost:49085"
  ;;

jpetstore)
  docker run -d -p 49088:8080 --link sql:sql foundationdb/mybatis-jpetstore
  echo "Visit http://localhost:49088/jpetstore"
  ;;

*)
  echo "Usage: $0 {lefp,dbal-test,spree,jpetstore}" >&2
  exit 1
  ;;
esac