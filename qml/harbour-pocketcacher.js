function _createCacheFinalise(c) {
    var cache = cacheComponent.createObject(app.cachemodel,c);

    if (cache === null) {
        console.debug("Error creating cache object: " + c.name);
    }
}

function createCache(c) {
    var cacheComponent = Qt.createComponent("Cache.qml");
    cacheComponent.statusChanged.connect(_createCacheFinalise);

    if (cacheComponent.status === Component.Ready) {
    }

    return cache;
}

function rot13(str) {
    var encoding = true;

    var encoded_str = "";
    for (var j = 0;j < str.length;j++) {
        if (str[j] === '[') {
            encoding = false;
        } else if (str[j] === ']') {
            encoding = true;
        }

        if (encoding){
            if (str[j].toLowerCase() >= 'a' && str[j].toLowerCase() <= 'z') {
                var chr = str.charCodeAt(j);
                var cse = (chr & 0x20);

                /* convert to uppercase */
                chr &= 0xdf;

                chr = (chr % 26) + 0x41;
                chr |= cse;

                encoded_str += String.fromCharCode(chr);
            } else {
                encoded_str += str[j];
            }
        } else {
            encoded_str += str[j];
        }
    }

    return encoded_str;
}
