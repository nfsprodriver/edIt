/*
  Created by Paweł Stroka.
  Licensed undred the GNU GPL v3

  CAUTION!!!!
  If you are trying to learn QML or examine how to do something
  that was featured in this app, this code is a really BAD EXAMPLE.
  It seems to work but there are things that should be written in a very different way.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import EdIt 1.0
import Ubuntu.Content 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import "components"
import "ui"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.pawstr.edit"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    automaticOrientation: settings.autoOrientation

    // Removes the old toolbar and enables new features of the new header.
    //useDeprecatedToolbar: false

    anchorToKeyboard: true

    width: units.gu(45)
    height: units.gu(75)

    property string infoText: ""

    Settings {
        id: settings
        property bool infoFading: true
        property int  fadingTime: 2000
        property bool wordWrap: true
        property bool textPrediction: false
        property bool autoOrientation: false
    }

    Component {
        id: popover
        Popover {
            id: po
            Text {
                anchors.centerIn: parent
                text: infoText
            }
            MouseArea {
                anchors.fill: parent
                onClicked: PopupUtils.close(po)
            }
            Timer {
                interval: settings.fadingTime
                repeat: false
                running: settings.infoFading
                onTriggered: PopupUtils.close(po)
            }
        }
    }

    FileIO {id: fileIO}

    function moveFile(item,dir) {
        var initialUrl = item.url;
        item.move(dir);
        if(fileIO.isWritable(dir)) {
            if(item.url === initialUrl) {
                var name = fileIO.getFileName(initialUrl);
                var suffix = fileIO.getSuffix(initialUrl);
                if(suffix.length > 0) suffix = "." + suffix;
                var i = 0;
                do {
                    i++;
                    item.move(dir, name + "(" + i + ")" + suffix);
                } while(item.url === initialUrl);
                showInfo(i18n.tr("Couldn't overwrite.\nSaved as ") + name + "(" + i + ")" + suffix)
                root.title = fileIO.getFullName(root.importItems[0].url)
                tabsModel.updateTabs()
            } else
                showInfo(i18n.tr("Saved"));
            root.saved = true
        } else
            showInfo(i18n.tr("Location isn't writable"))
    }

    function saveFile(item,dir) {
        var newFileName = "file://" + dir + fileIO.getFullName(item.url);
        if(newFileName != item.url || !fileIO.write(newFileName, root.textArea.text)) {
            moveFile(item,dir);
            fileIO.write(item.url, root.textArea.text);
        } else
            showInfo(i18n.tr("Saved"));
        root.saved = true;
    }

    function showInfo(info) {
        infoText = "\n" + info + "\n";
        PopupUtils.open(popover);
    }

    function searchText(text) {
        var indexList = []
        var index = 0
        do {
            if(root.head.sections.selectedIndex === 0)
                index = root.textArea.text.indexOf(text,index)
            else
                index = root.textArea.text.toLowerCase().indexOf(text.toLowerCase(),index)
            if(index != -1) {
                indexList[indexList.length] = index
                index += text.length
            }
        } while(index != -1)
        return indexList
    }

    function selectionUpdate() {
        if(matchLabel.indexList.length > 0) {
            if(matchLabel.currentIndex == 0 || matchLabel.currentIndex > matchLabel.indexList.length) {
                matchLabel.currentIndex = 1
            }
            var start = matchLabel.indexList[matchLabel.currentIndex-1]
            root.textArea.select(start,start+searchField.text.length)
        } else {
            root.textArea.deselect()
            matchLabel.currentIndex = 0
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: {
            pageStack.push(root)
//            tabsPage.filesOpened[tabsPage.filesOpened.length] = root.textArea
//            console.log(Qt.application.name)
//            console.log(Qt.application.organization)
//            console.log(Qt.application.domain)
        }

        Connections {
            target: ContentHub
            onExportRequested: {
                root.activeTransfer = transfer;

                localFilePicker.exportRequest = true
                pageStack.push(localFilePicker)

                console.log ("Export requested");
            }
            onImportRequested: {
                tabsModel.addTab()
                tabsModel.selectTab(tabsModel.count-1)

                root.importItems = transfer.items
                root.textArea.text = fileIO.read(root.importItems[0].url);
                root.title = fileIO.getFullName(root.importItems[0].url);
                root.saved = false
                tabsModel.updateTabs()
                tabsModel.updateSaved()

                console.log ("Import requested");
            }
        }

        PageWithBottomEdge {
            id: root
            title: "edIt"

            Component.onCompleted: {
                tabsModel.addTab()
                tabsModel.selectTab(0)
            }

            TextAreaComponent {id:textAreaComponent}
            TabsModel {id: tabsModel}

            bottomEdgePageComponent: TabsPage {
                anchors.fill: parent
            }

            bottomEdgeTitle: i18n.tr("Tabs")

            ContentItem {
                id: nullItem
                url: ""
            }

            property Item textArea

            property list<ContentItem> importItems: [ContentItem{url: ""}]
            property list<ContentItem> tmpItems:    [ContentItem{url: ""}]
            property var fileList;
            property var activeTransfer;
            property bool saved: true

            CloseFileDialog {id: closeFileDialog; property Action closeAction}
            SaveAsDialog    {id: saveAsDialog   ; property Action closeAction}
            UnsavedDialog   {id: unsavedDialog  ; property Action closeAction}

//            RemoveFileDialog {id: removeFileDialog}

//            tools: Toolbar{id: bar}
            Toolbar {id: bar}

            onTextAreaChanged: {
                textArea.opacity = 0.0
            }

            state: "default"
            head.sections.onSelectedIndexChanged: {
                if(state === "search") {
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

            states: [
                PageHeadState {
                    name: "default"
                    head: root.head
                    actions: bar.actions
                    onCompleted: root.head.sections.model = undefined
                },
                PageHeadState {
                    name: "search"
                    head: root.head
                    onCompleted: root.head.sections.model = [i18n.tr("Case sensitive"), i18n.tr("Case insensitive")]
                    actions: [
                        Action {
                            iconName: "back"
                            onTriggered: {
                                if(matchLabel.indexList.length > 0) {
                                    if(matchLabel.currentIndex > 1) {
                                        matchLabel.currentIndex--
                                        selectionUpdate()
                                    } else {
                                        matchLabel.currentIndex = matchLabel.indexList.length
                                        selectionUpdate()
                                    }
                                }
                            }
                        },
                        Action {
                            iconName: "next"
                            onTriggered: {
                                if(matchLabel.indexList.length > 0) {
                                    if(matchLabel.indexList.length > matchLabel.currentIndex) {
                                        matchLabel.currentIndex++
                                        selectionUpdate()
                                    } else {
                                        matchLabel.currentIndex = 1
                                        selectionUpdate()
                                    }
                                }
                            }
                        }
                    ]
                    backAction: Action {
                        text: "back"
                        iconName: "back"
                        onTriggered: {
                            root.state = "default"
                        }
                    }
                    contents: Row {
                        anchors.centerIn: parent
                        spacing: units.gu(1)
                        TextField {
                            id: searchField
                            placeholderText: i18n.tr("search...")
                            width: parent.parent.width - units.gu(3) - matchLabel.width
                            inputMethodHints:  Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                            onTextChanged: {
                                if(text.length > 0) {
                                    matchLabel.indexList = searchText(text)
                                    selectionUpdate()
                                } else {
                                    matchLabel.indexList = []
                                    matchLabel.currentIndex = 0
                                    selectionUpdate()
                                }
                            }
                        }
                        Label {
                            id: matchLabel
                            property var indexList: []
                            property int currentIndex: 0
                            anchors.verticalCenter: parent.verticalCenter
                            text: currentIndex + i18n.tr(" of ") + indexList.length
                        }
                    }
                }
            ]

//            ContentTransferHint {
//                id: transferHint
//                anchors.fill: parent
//                activeTransfer: root.activeTransfer
//            }

            Action {
                id: importAction
                onTriggered: {
                    root.importItems = root.tmpItems;

                    root.textArea.text = fileIO.read(root.importItems[0].url);
                    root.title = fileIO.getFullName(root.importItems[0].url);
                    tabsModel.updateTabs()
                    root.saved = true
                }
            }

            Connections {
                target: root.activeTransfer
                onStateChanged: {
                    if (root.activeTransfer.state === ContentTransfer.Charged) {
                        if (root.activeTransfer.direction === ContentTransfer.Import) {
                            root.tmpItems = root.activeTransfer.items;
                            if(!root.saved) {
                                unsavedDialog.closeAction = importAction
                                PopupUtils.open(unsavedDialog)
                            } else
                                importAction.trigger()
                        } else if (root.activeTransfer.direction === ContentTransfer.Export) {
                            console.log("Charged")
                        }
                    }
                }
            }
        }

        SettingsPage {id: settingsPage}
        LocalFilePicker {id: localFilePicker}
//        TabsPage {id: tabsPage}

        Page {
            id: picker
            visible: false
            ContentPeerPicker {
                id: peerPicker
                visible: parent.visible
                handler: ContentHandler.Source
                contentType: ContentType.Documents

                onPeerSelected: {
                    peer.selectionType = ContentTransfer.Single;
                    root.activeTransfer = peer.request();
                    pageStack.pop();
                }
                onCancelPressed: pageStack.pop()
            }
        }

        Component {
            id: resultComponent
            ContentItem {}
        }

        Page {
            id: exportPicker
            visible: false
            property var curTransfer
            property var url
            property var handler: ContentHandler.Destination
            property alias contentType: exportPeerPicker.contentType

            function __exportItems(url) {
                if (exportPicker.curTransfer.state === ContentTransfer.InProgress)
                {
                    exportPicker.curTransfer.items = [ resultComponent.createObject(root, {"url": url}) ];
                    exportPicker.curTransfer.state = ContentTransfer.Charged;
                }
            }

            ContentPeerPicker {
                id: exportPeerPicker

                visible: parent.visible
                contentType: ContentType.Documents
                handler: exportPicker.handler

                onPeerSelected: {
                    exportPicker.curTransfer = peer.request();
                        pageStack.pop();
                        if (exportPicker.curTransfer.state === ContentTransfer.InProgress)
                            exportPicker.__exportItems(exportPicker.url);
                }
                onCancelPressed: pageStack.pop()
            }
            Connections {
                target: exportPicker.curTransfer
                onStateChanged: {
                    console.log("curTransfer StateChanged: " + exportPicker.curTransfer.state);
                    if (exportPicker.curTransfer.state === ContentTransfer.InProgress)
                    {
                        exportPicker.__exportItems(exportPicker.url);
                    }
                }
            }
        }
    }
}
