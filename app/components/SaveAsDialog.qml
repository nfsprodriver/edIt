import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    Dialog {
        id: dialogue
        title: i18n.tr("Save as")
        text: i18n.tr("Enter a name for the file to save.")
        Component.onCompleted: fileName.forceActiveFocus()
        TextField {
            id: fileName
            text: fileIO.getFullName(root.importItems[0].url)
            inputMethodHints:  Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
        }
        Button {
            text: i18n.tr("Save")
            color: UbuntuColors.green
            onClicked: {
                PopupUtils.close(dialogue)
                var newFileName = "file://" + fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/" +
                        fileName.text;
                if(!fileIO.write(newFileName, root.textArea.text)) {
                    showInfo(i18n.tr("Couldn't write"));
                } else {
                    showInfo(i18n.tr("Saved"));
                    root.saved = true;
                    root.importItems[0].url = newFileName;
                    root.title = fileIO.getFullName(root.importItems[0].url)
                    tabsModel.updateTabs()
                }
                if(saveAsDialog.closeAction !== null)
                    saveAsDialog.closeAction.trigger()
            }
        }
        Button {
            text: i18n.tr("Cancel")
            color: UbuntuColors.red
            onClicked: {
                PopupUtils.close(dialogue)
                if(saveAsDialog.closeAction !== null)
                    saveAsDialog.closeAction.trigger()
            }
        }
    }
}
