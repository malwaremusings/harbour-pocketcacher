import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    property string host
    property var returnPage

    SilicaWebView {
        id: webView

        anchors.fill: parent

        onNavigationRequested: {
            console.debug("CacherOAuthWeb::onNavigationRequested: " + request.url);

            app.oauth.redirect(request.url);
        }
    }

    Component.onCompleted: {
        app.okapids.host = host;
        app.oauth.accessTokenChanged.connect(function() {
            console.debug(pageStack.pop());
        });
        app.oauth.authorise(host,webView);
    }
}
