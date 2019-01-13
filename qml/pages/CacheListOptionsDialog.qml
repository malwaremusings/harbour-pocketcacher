import QtQuick 2.0
import Sailfish.Silica 1.0
import com.malwaremusings 0.2

Dialog {
    property bool sortEnabled
    property int sortRole
    property int sortOrder

    property bool filterEnabled
    property int filterRole
    property string filterString
    property int filterCaseSensitivity

    property bool groupEnabled
    property string groupProperty
    property int groupCriteria

    Column {
        width: parent.width

        DialogHeader {
            title: "Options"
        }

        SectionHeader {
            text: "Sort"
        }

        Row {
            width: parent.width

            ComboBox {
                id: sortFieldBox

                width: parent.width / 2
                label: "Field"
                currentIndex: sortRole - CacheListModel.GsNameRole
                menu: ContextMenu {
                    /* this order must match that of enum CacheListModel::CacheRoles */
                    MenuItem {
                        text: "Name"
                        property string groupBy: "gsname"
                        property int groupCriteria: ViewSection.FirstCharacter
                    }

                    MenuItem {
                        text: "Type"
                        property string groupBy: "type"
                    }

                    MenuItem { text: "Identifier" }

                    MenuItem {
                        text: "Owner"
                        property string groupBy: "owner"
                    }

                    MenuItem {
                        text: "Difficulty"
                        property string groupBy: "difficulty"
                    }

                    MenuItem {
                        text: "Terrain"
                        property string groupBy: "terrain"
                    }

                    MenuItem {
                        text: "Container"
                        property string groupBy: "container"
                    }

                    MenuItem {
                        text: "Last Found"
                    }

                    MenuItem {
                        text: "Placed Time"
                    }

                    MenuItem { text: "Latitude" }
                    MenuItem { text: "Longitude" }
                    MenuItem { text: "Colour" }
                    MenuItem { text: "Distance" }
                    MenuItem { text: "Bearing" }
                }
            }

            ComboBox {
                id: sortOrderBox

                width: parent.width / 2
                visible: sortFieldBox.currentIndex >= 0
                label: "Order"
                menu: ContextMenu {
                    MenuItem { text: "Ascending" }
                    MenuItem { text: "Descending" }
                }
            }
        }

        SectionHeader {
            text: "Filter"
        }

        Row {
            width: parent.width

            ComboBox {
                id: filterFieldBox

                width: parent.width / 2
                label: "Field"
                currentIndex: filterRole - CacheListModel.GsNameRole
                menu: ContextMenu {
                    /* this order must match that of enum CacheListModel::CacheRoles */
                    MenuItem { text: "Name" }
                    MenuItem { text: "Type" }
                    MenuItem { text: "Identifier" }
                    MenuItem { text: "Owner" }
                    MenuItem { text: "Difficulty" }
                    MenuItem { text: "Terrain" }
                    MenuItem { text: "Container" }
                    MenuItem { text: "Last Found" }
                    MenuItem { text: "Placed Time" }
                    MenuItem { text: "Latitude" }
                    MenuItem { text: "Longitude" }
                    MenuItem { text: "Colour" }
                    MenuItem { text: "Distance" }
                    MenuItem { text: "Bearing" }
                }
            }

            TextSwitch {
                id: filterCaseSensitive

                visible: filterFieldBox.currentIndex >= 0
                width: parent.width / 2
                text: "Case sensitive"
            }
        }

        TextField {
            id: filterTextField

            visible: filterFieldBox.currentIndex >= 0
            width: parent.width
            label: "Filter string"
            placeholderText: "Regular expression to filter on"
        }
    }

    onDone: {
        if (result === DialogResult.Accepted) {
            console.debug("  sortDialog: " + sortFieldBox.currentIndex);
            sortEnabled = sortFieldBox.currentIndex >= 0;
            if (sortEnabled) {
                sortRole = CacheListModel.GsNameRole + sortFieldBox.currentIndex

                /*
                * bit of a hack, but it works
                * (at least until the value of Qt.AscendingOrder/DecendingOrder changes
                */
                sortOrder = Qt.AscendingOrder + sortOrderBox.currentIndex;
            }

            groupEnabled = sortEnabled && sortFieldBox.currentItem.hasOwnProperty("groupBy");
            if (groupEnabled) {
                groupProperty = sortFieldBox.currentItem.groupBy;
                if (sortFieldBox.currentItem.hasOwnProperty("groupCriteria")) {
                    groupCriteria = sortFieldBox.currentItem.groupCriteria;
                }
            }

            filterEnabled = filterFieldBox.currentIndex >= 0;
            if (filterEnabled) {
                filterRole = CacheListModel.GsNameRole + filterFieldBox.currentIndex;
                filterString = filterTextField.text;
                filterCaseSensitivity = filterCaseSensitive.checked ? Qt.CaseSensitive : Qt.CaseInsensitive
            }
        }
    }
}
