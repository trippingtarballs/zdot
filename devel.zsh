#!/usr/bin/env zsh


# ALL THE SOFTWARE TINGS

# global vars

# what's the plurarl of 'alias'?
alias jles="cd ~/Code/commercial/daredev/lesEssence"

alias jfull="cd ~/Code/commercial/arcadiagroup/full-monty && nvml && nvm use v6.9.4"
alias jmono="cd ~/Code/commercial/arcadiagroup/mono-monty"
alias jv2="cd ~/Code/commercial/arcadiagroup/monty-idd"
alias jngapp="cd ~/Code/commercial/daredev/NGApp"

alias jreason="cd ~/Code/tutorials/a-reason-react-tutorial"



### Virtual Environments - run each once after a Python update

excelsior-make-virtualenv-trivium () {
    venvl
    rmvirtualenv trivium
    mkvirtualenv --always-copy -a ~/Code/commercial/triviumre/excelsior trivium
    cd python/IdCol
    pip install -e .
    cd ../../
    cd python/FindTables
    pip install -e .
    cd ../../
}

excelsior-make-virtualenv-trivium-dbs () {
    venvl
    rmvirtualenv trivium-dbs
    mkvirtualenv \
        --always-copy \
        -a ~/Code/commercial/triviumre/DatabaseSchema \
        -r ~/Code/commercial/triviumre/DatabaseSchema/requirements.txt \
        trivium-dbs
}



### Rebuild Project: Excelsior
excelsior-submodules () {
    cdproject

    git submodule update
}

excelsior-clean () {
    cdproject

    stack clean --full

    rm -rf python/FindTables/find_tables/classifiers/*.p
    rm -rf python/IdCol/id_col/classifiers/*.p

    rm -rf frontend/node_modules frontend/src/elm/Generated/*.elm frontend/www
}

excelsior-rebuild-db-ci () {
    cdproject

    docker container stop excelsior-db
    docker container rm excelsior-db
    docker run -d --name excelsior-db -p 5432:5432 d6d27a9c7b92
    sleep 10

    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER excelsior-db createuser -U postgres --superuser $EXCELSIOR_DB_USER
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e EXCELSIOR_DB_NAME=$EXCELSIOR_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $EXCELSIOR_DB_NAME
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e TEST_DB_NAME=$TEST_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $TEST_DB_NAME

    cd DatabaseSchema
    gunzip --keep tests/dump.sql.gz
    psql "$EXCELSIOR_DB_ADMIN" < tests/dump.sql
    psql "$EXCELSIOR_DB_ADMIN" -c "drop table cdm_variable_df"
    rm -rf tests/dump.sql
    cdproject

    pip install -r DatabaseSchema/requirements.txt
    ./DatabaseSchema/excelsiordb.sh build
}

excelsior-rebuild-db () {
    cdproject

    docker container stop excelsior-db
    docker container rm excelsior-db
    docker run -d --name excelsior-db -p 5432:5432 d6d27a9c7b92
    sleep 10

    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER excelsior-db createuser -U postgres --superuser $EXCELSIOR_DB_USER
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e EXCELSIOR_DB_NAME=$EXCELSIOR_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $EXCELSIOR_DB_NAME
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e TEST_DB_NAME=$TEST_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $TEST_DB_NAME

    pip install -r DatabaseSchema/requirements.txt

    ./DatabaseSchema/excelsiordb.sh build
}

excelsior-rebuild-e2e () {
    cdproject
    pip install -r e2e/requirements.txt
}

excelsior-rebuild-ml () {
    cdproject

    pip install -r python/FindTables/requirements.txt
    tar -xf python/FindTables/latest-pickles.tar.gz -C python/FindTables/find_tables/classifiers

    pip install -r python/IdCol/requirements.txt
    tar -xf python/IdCol/latest-pickles.tar.gz -C python/IdCol/id_col/classifiers
}

excelsior-rebuild-hs () {
    cdproject

    stack build --fast
    stack exec code-gen
    cd frontend
    npm install
    npm run build
    cd ../
}

excelsior-everything () {
    docker system info > /dev/null 2>&1;

    local RESULT=$?

    if [ $RESULT -eq 0 ]; then
        excelsior-submodules

        excelsior-clean

        excelsior-rebuild-db

        excelsior-rebuild-e2e

        excelsior-rebuild-ml

        excelsior-rebuild-hs
    else
        echo "Error. Docker is not running."
        [ $PS1 ] && return 1 || exit 1;
    fi
}


### Rebuild Prokect: DatabaseSchema
databaseschema-rebuild-db () {
    cdproject

    docker container stop excelsior-db
    docker container rm excelsior-db
    docker run -d --name excelsior-db -p 5432:5432 d6d27a9c7b92
    sleep 10

    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER excelsior-db createuser -U postgres --superuser $EXCELSIOR_DB_USER
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e EXCELSIOR_DB_NAME=$EXCELSIOR_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $EXCELSIOR_DB_NAME
    docker exec -it -e EXCELSIOR_DB_USER=$EXCELSIOR_DB_USER -e TEST_DB_NAME=$TEST_DB_NAME excelsior-db createdb -U postgres --owner=$EXCELSIOR_DB_USER $TEST_DB_NAME

    pip install -r requirements.txt

    ./excelsiordb.sh build
}


### Project Jumping

jtrivium-db () {
    # Pinned postgresql@9.6 to v9.6.7 instead
    # brew switch postgresql@9.6 9.6.7

    # PostgreSQL Support - v9.6.x
    path=("${(@)path:#'/usr/local/opt/postgresql@9.6/bin'}")
    path=(/usr/local/opt/postgresql@9.6/bin $path)

    export EXCELSIOR_DB_USER=maverick
    export EXCELSIOR_DB_NAME=excelsior
    export EXCELSIOR_DB_CONN="host=localhost dbname=$EXCELSIOR_DB_NAME user=$EXCELSIOR_DB_USER"
    export EXCELSIOR_DB_ADMIN="host=localhost dbname=$EXCELSIOR_DB_NAME user=$EXCELSIOR_DB_USER"
    export TEST_DB_NAME="excelsior_test"
    export TEST_DB_ADMIN="host=localhost dbname=$TEST_DB_NAME user=$EXCELSIOR_DB_USER"
    export TEST_DB_CONN="host=localhost dbname=$TEST_DB_NAME user=$EXCELSIOR_DB_USER"
    export PG_HOST="localhost"
    export PG_USER="$EXCELSIOR_DB_USER"
    export PG_PORT="5432"

    # ensure the PostgreSQL DB is running
    # brew services run postgresql@9.6 &> /dev/null
}

jtrivium-excelsior () {
    venvl
    workon trivium

    nvml --no-use
    nvm use     # will lookup `.nvmrc` .. use `cdproject`

    # GCC v5 ... assumes already run once, `$ brew install gcc@5`
    path=("${(@)path:#'/usr/local/opt/gcc@5/bin'}")
    path=(/usr/local/opt/gcc@5/bin $path)
    # https://xgboost.readthedocs.io/en/latest/build.html#building-on-macos
    export CC="gcc-5"
    export CXX="g++-5"
}

jd () {
    venvl
    workon trivium-dbs
    jtrivium-db
}

je () {
    jtrivium-db
    jtrivium-excelsior
}

jef () {
    je
    cd frontend
    npm run start
}

# stack build --verbosity warn --fast --ghc-options=-Werror
