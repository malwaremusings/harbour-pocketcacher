import QtQuick 2.0
import Sailfish.Silica 1.0
import com.malwaremusings 0.1

Dialog {
    property int role
    property int order

    Column {
        width: parent.width

        DialogHeader { }

        ComboBox {
            id: fieldBox

            width: parent.width
            label: "Field"
            currentIndex: role - CacheListModel.GsNameRole
            menu: ContextMenu {
                /* this order must match that of enum CacheListModel::CacheRoles */
                MenuItem { text: "Name" }
                MenuItem { text: "Type" }
                MenuItem { text: "Identifier" }
                MenuItem { text: "Difficulty" }
                MenuItem { text: "Terrain" }
                MenuItem { text: "Latitude" }
                MenuItem { text: "Longitude" }
            }
        }

        ComboBox {
            id: orderBox

            width: parent.width
            label: "Order"
            menu: ContextMenu {
                MenuItem { text: "Ascending" }
                MenuItem { text: "Descending" }
            }
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            console.debug("  sortDialog: " + fieldBox.currentIndex);
            role = CacheListModel.GsNameRole + fieldBox.currentIndex;

            /*
             * bit of a hack, but it works
             * (at least until the value of Qt.AscendingOrder/DecendingOrder changes
             */
            order = Qt.AscendingOrder + orderBox.currentIndex;
        }
    }
}
