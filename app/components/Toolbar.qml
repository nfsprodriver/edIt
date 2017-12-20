import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Content 1.3
import Ubuntu.Components.Popups 1.3

ActionList {
    children: [
        Action {
            text: i18n.tr("Undo")
            iconName: "undo"
            onTriggered: {
                root.textArea.undo()
            }
        },
        Action {
            text: i18n.tr("Redo")
            iconName: "redo"
            onTriggered: {
                root.textArea.redo()
            }
        },
        Action {
            text: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                pageStack.push(settingsPage)
                settingsPage.visible = true
            }
        },
        Action {
            text: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                root.state = "search"
                searchField.forceActiveFocus()
                if(searchField.text.length > 0) {
                    matchLabel.indexList = searchText(searchField.text)
                    selectionUpdate()
                } else {
                    matchLabel.indexList = []
                    matchLabel.currentIndex = 0
                    selectionUpdate()
                }
            }
        },
//        Action {
//            text: i18n.tr("Tabs")
//            iconName: "browser-tabs"
//            onTriggered: {
//                tabsPage.tabs.updateSaved()
//                pageStack.push(tabsPage)
//                tabsPage.visible = true
//            }
//        },
//        Action {
//            text: i18n.tr("New file")
//            iconName: "note-new"
//            property Action closeAction: Action {
//                id: closeAction
//                onTriggered: {
//                    root.importItems = [nullItem]
//                    root.textArea.text = ""
//                    root.title = "edIt"
//                }
//            }
//            onTriggered: {
//                closeFileDialog.closeAction = closeAction
//                PopupUtils.open(closeFileDialog)
//            }
//        },
        Action {
            text: i18n.tr("Save")
            iconName: "save"
            onTriggered: {
                if(root.importItems[0].url == "") {
                    saveAsDialog.closeAction = null
                    PopupUtils.open(saveAsDialog)
                } else {
                    saveFile(root.importItems[0],fileIO.getHomePath() + "/.local/share/edit.nfsprodriver/")
                }
            }
        },
        Action {
            text: i18n.tr("Save as")
            iconName: "save-as"
            onTriggered: {
                saveAsDialog.closeAction = null
                PopupUtils.open(saveAsDialog)
            }
        },
        Action {
            text: i18n.tr("Open with")
            iconName: "external-link"
            onTriggered: {
                if(root.importItems[0].url != "") {
                    exportPeerPicker.contentType = ContentType.Documents;
                    exportPicker.url = root.importItems[0].url;
                    pageStack.push(exportPicker);
                } else {
                    showInfo(i18n.tr("File must be saved"))
                }
            }
        },
        Action {
            text: i18n.tr("Open")
            iconSource: Qt.resolvedUrl("../../../../graphics/open.png")
            onTriggered: {
                peerPicker.contentType = ContentType.Documents;
                pageStack.push(picker);
            }
        },
        Action {
            text: i18n.tr("Local files")
            iconSource: Qt.resolvedUrl("../../../../graphics/reopen.png")
            onTriggered: {
                pageStack.push(localFilePicker);
            }
        }
    ]
}
/*
ToolbarItems {
    ToolbarButton {
        action: Action {
            text: i18n.tr("Undo")
            iconName: "undo"
            onTriggered: {
                root.textArea.undo()
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Redo")
            iconName: "redo"
            onTriggered: {
                root.textArea.redo()
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                pageStack.push(settingsPage)
                settingsPage.visible = true
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                root.state = "search"
                searchField.forceActiveFocus()
                if(searchField.text.length > 0) {
                    matchLabel.indexList = searchText(searchField.text)
                    selectionUpdate()
                } else {
                    matchLabel.indexList = []
                    matchLabel.currentIndex = 0
                    selectionUpdate()
                }
            }
        }
    }
    ToolbarButton {
        Action {
            id: closeAction
            onTriggered: {
                root.importItems = [nullItem]
                root.textArea.text = ""
                root.title = "edIt"
            }
        }
        action: Action {
            text: i18n.tr("New file")
            iconName: "note-new"
            onTriggered: {
                newFileDialog.closeAction = closeAction
                PopupUtils.open(newFileDialog)
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Save")
            iconName: "save"
            onTriggered: {
                if(root.importItems[0].url == "") {
                    saveAsDialog.closeAction = null
                    PopupUtils.open(saveAsDialog)
                } else {
                    saveFile(root.importItems[0],fileIO.getHomePath() + "/.local/share/edit.nfsprodriver/")
                }
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Save as")
            iconName: "save-as"
            onTriggered: {
                saveAsDialog.closeAction = null
                PopupUtils.open(saveAsDialog)
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Open")
            iconSource: Qt.resolvedUrl("../../../../graphics/open.png")
            onTriggered: {
                peerPicker.contentType = ContentType.Documents;
                pageStack.push(picker);
            }
        }
    }
    ToolbarButton {
        action: Action {
            text: i18n.tr("Open local file")
            iconSource: Qt.resolvedUrl("../../../../graphics/reopen.png")
            onTriggered: {
                pageStack.push(localFilePicker);
            }
        }
    }
}
*/
