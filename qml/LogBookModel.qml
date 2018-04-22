import QtQuick 2.2

Item {
    id: itemLogBook
    property alias logentries: lstmodLogBook

    ListModel {
        id: lstmodLogBook
    }

    function add(logentry) {
        app.logbook.db.doQuery("INSERT INTO LogBook VALUES (?,?,?,?,?,?,?)",[logentry.name,logentry.timestamp,logentry.date,logentry.time,logentry.type,logentry.finder,logentry.text],null);
        refresh();
    }

    function del(logindex) {
        var logentry = lstmodLogBook.get(logindex);
        console.debug("Deleting from database: " + logindex + " -> " + logentry.rowid);

        app.logbook.db.doQuery("DELETE FROM LogBook WHERE rowid = ?",[logentry.rowid],null);
        refresh();
    }

    function refresh() {
        console.debug("Refreshing LogBook ListModel");

        app.logbook.db.doQuery("SELECT rowid,* FROM LogBook ORDER BY timestamp",[],function(results) {
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

    Component.onCompleted: refresh();
}
