var component;
var filename;

function finishPocketQuery(callback) {
    console.debug("> finishPocketQuery()");

    if (component.status === Component.Ready) {
        var pocketQuery = component.createObject(pagePocketQueryList,{"filename": filename});
        if (pocketQuery) callback(pocketQuery);
    } else {
        console.debug("Error loading PocketQuery component: ", component.errorString());
    }

    console.debug("< finishPocketQuery()");
}

function createPocketQuery(strFilename,callback) {
    console.debug("> createPocketQuery(" + strFilename + ")");

    component = Qt.createComponent("PocketQuery.qml");
    filename = strFilename;

    if (component.status === Component.Ready || component.status === Component.Error) {
        finishPocketQuery(callback);
    } else {
        component.statusChanged.connect(finishPocketQuery);
    }

    console.debug("< createPocketQuery(" + strFilename + ")");
}
