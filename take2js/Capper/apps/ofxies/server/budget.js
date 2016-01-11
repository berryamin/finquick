const Q = require('q');

const makeSecretTool = require('./secret-tool').makeSecretTool;


function integrationTestMain(process, mysql) {
    'use strict';

    const argv = process.argv,
          dbName = argv[2], host = 'localhost',
          acctName = argv[3], since = argv[4];

    const optsP = makeSecretTool(process.spawn).lookup({
        protocol: 'mysql',
        server: host,
        object: dbName
    }).then(password => ({
        host     : host,
        user     : process.env.LOGNAME,
        password : password,
        database : dbName
    }));
    const db = makeDB(mysql, optsP);
    const budget = makeBudget(db);

    budget.acctBalance(acctName, since).then(
        info => console.log('balance: ', info.balance)
    )
        .then(() => db.end())
        .done();
}


function makeDB(mysql, optsP) {
    'use strict';

    const connP = optsP.then(opts => mysql.createConnection(opts));

    function query(dml, params) {
        return connP.then(c => {
            // console.log('DEBUG: db.query: ', dml, params || '');

            // This seems like the Q.ninvoke pattern, but I'm struggling...
            return Q.promise(
                (resolve, reject) =>
                    c.query(dml, params, (err, rows) => {
                        if (err) return reject(err);
                        console.log('DEBUG: db.query result: ', rows);
                        resolve(rows);
                    }));
        });
    }

    return Object.freeze({
        query: query,
        end: err => connP.then(c => c.end(err))
    });
}



function makeBudget(db) {
    'use strict';

    function guids(objs) {
        return objs.map(o => o.guid).map(u => '\'' + u + '\'').join(', ');
    }

    function first(rows) {
        return rows[0];
    }

    function subAccounts(acctP) {
        function recur(parents, generations, resolve, reject) {
            db.query(
                `select child.guid, child.name
                from accounts child
                join accounts parent on child.parent_guid = parent.guid
                where parent.guid in (${guids(parents)})`
            ).then(
                children => {
                    if (children.length == 0) {
                        const acctIds = [].concat.apply([], generations);
                        return resolve(acctIds);
                    }
                    generations.push(children);
                    recur(children, generations, resolve, reject);
                }, reject);
        }

        return Q.promise(
            (resolve, reject) =>
                acctP.then(acct => recur([acct], [[acct]], resolve, reject),
                           reject)
        );
    }

    function acctBalance(acctName, since) {
        return subAccounts(acctByName(acctName)).then(
            accts =>
                db.query(
                    `select sum(value_num / value_denom) balance
                    , ? name, ? since
                    from splits s
                    join accounts a on a.guid = s.account_guid
                    join transactions tx on tx.guid = s.tx_guid
                    where a.guid in (${guids(accts)})
                    and tx.post_date >= ?`,
                    [acctName, since, since]).then(first)
        );
    }

    function getStatement(acctName, since) {
        const sinceWhen = new Date(since.year, since.month, since.day);
        return subAccounts(acctByName(acctName)).then(
            acct =>
                db.query(
                    `select tx.post_date, tx.description
                    , s.value_num / s.value_denom amount
                    , s.memo
                    , fid.string_val fid
                    , s.guid, s.tx_guid
                    from splits s
                    join transactions tx on tx.guid = s.tx_guid
                    join accounts sa on sa.guid = s.account_guid
                    left join slots fid on fid.obj_guid = s.guid

                    where fid.name = 'online_id'
                    and sa.guid = ?
                        and tx.post_date > ?
                    order by tx.post_date desc`, [acct.guid, sinceWhen]));
    }

    function acctByName(acctName) {
        return db.query(
            'select guid, name from accounts where name = ?',
            [acctName])
            .then(first);
    }

    return Object.freeze({
        subAccounts: acctName => subAccounts(acctByName(acctName)),
        acctBalance: acctBalance,
        getStatement: getStatement
    });
}

if (process.env.TESTING) {
    integrationTestMain(
        {
            argv: process.argv,
            env: process.env,
            spawn: require('child_process').spawn
        },
        require('mysql'));
}

exports.makeDB = makeDB;
