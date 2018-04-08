import QtQuick 2.2
import QtQuick.LocalStorage 2.0

Item {
    id: itemLogBook
    property alias logentries: lstmodLogBook

    property var db

    ListModel {
        id: lstmodLogBook
    }

    function refresh() {
        console.debug("Refreshing LogBook ListModel");

        db.transaction(function(tx) {
            try {
                console.debug("Selecting from database");
                var results = tx.executeSql("SELECT rowid,* FROM LogBook ORDER BY timestamp");
                console.debug("Done selecting");
            } catch (e) {
                console.debug("exception selecting from database: " + e);
            }

                if (results.rows.length > 0) {
                    lstmodLogBook.clear();

                    for (var i = 0;i < results.rows.length;i++) {
                        var r = results.rows.item(i);

                        lstmodLogBook.append({
                                    "rowid": r.rowid,
                                    "timestamp": r.timestamp,
                                    "date": r.date,
                                    "time": r.time,
                                    "name": r.name,
                                    "date": r.date,
                                    "type": r.type,
                                    "finder": r.finder,
                                    "text": r.text
                                    });
                    }
                }
        });

        console.debug("Done refreshing LogBook ListModel");
    }

    function add(logentry) {
        db.transaction(function(tx) {
            try {
                console.debug("Inserting into database: " + logentry.name + ":" + logentry.date);
                var results = tx.executeSql("INSERT INTO LogBook VALUES (?,?,?,?,?,?,?)",[logentry.name,logentry.timestamp,logentry.date,logentry.time,logentry.type,logentry.finder,logentry.text]);
                console.debug("Done inserting (" + results.rows.length + ")");
            } catch (e) {
                console.debug("exception inserting in to databae" + e);
            }
        });

        refresh();
    }

    function del(logindex) {
        var logentry = lstmodLogBook.get(logindex);
        console.debug("Deleting from database: " + logindex + " -> " + logentry.rowid);

        db.transaction(function(tx) {
            try {
                /* Using rowid stops us from being able to delete log entries that were added during
                 * this session, because the rowid is assigned by the database and are not available
                 * to the model until the model is refreshed
                 *
                 * Undecided about whether to use rowid and refresh the model after adding/deleting
                 * from db, or to use our own unique id to delete.
                 * This table should only be modified on adding and deleting cache entries so a
                 * refresh isn't going to add too much overhead.
                 */
                var results = tx.executeSql("DELETE FROM LogBook WHERE rowid = ?",[logentry.rowid]);
                //var results = tx.executeSql("DELETE FROM LogBook WHERE name = ? AND timestamp = ?",[logentry.name,logentry.timestamp]);

                // lstmodLogBook.remove(logindex,1);
                console.debug("Done deleting (" + results.rows.length + ")");
            } catch (e) {
                console.debug("exception deleting from databae" + e);
            }
        });

        refresh();
    }

    Component.onCompleted: {
        try {
            db = LocalStorage.openDatabaseSync("pocketcacher","0.1","Pocket Cacher database for storing stuff",1000);

            if (db) {
                db.transaction(
                            function(tx) {
                                // Create the database if it doesn't exist
                                // (after dropping it if it does :) )
                                //tx.executeSql("DROP TABLE IF EXISTS LogBook");
                                tx.executeSql("CREATE TABLE IF NOT EXISTS LogBook(name TEXT,timestamp REAL,date TEXT,time TEXT,type TEXT,finder TEXT,text TEXT)");
                            });
                refresh();

                /*
                 * need to connect this signal handler after calling refresh()
                 * as refresh() will add items to the model and trigger this
                 * signal handler!
                 *
                 * disable this in favour of updating the db then refreshing
                 * the model, rather than updating the model and updating the db
                 * as a result. this approach allows us to use thw rowid
                 * generated by sqlite as a unique id and since the model is
                 * refreshed from the db after adds, we can remove log entries
                 * there were added during this session
                 *
                 * code commented rather than removed as i may change my mind!
                 */

                // lstmodLogBook.onRowsInserted.connect(function (start,end,list) {
                //     console.debug("LogBookModel::ListModel::onRowsInserted(" + list + ")");
                //     console.debug(lstmodLogBook.get(end).name);
                //     itemLogBook.add(lstmodLogBook.get(end));
                // });
            }
        } catch (e) {
            console.debug("database creation failed: " + e);
        }
    }
}
