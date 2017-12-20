import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    Dialog {
        id: dialogue
        title: i18n.tr("Unsaved changes")
        text: i18n.tr("There are unsaved changes. Do you want to save this file before closing?")
        Component.onCompleted: dialogue.forceActiveFocus()
        Button {
            text: i18n.tr("Save")
            color: UbuntuColors.green
            onClicked: {
                PopupUtils.close(dialogue)

                if(root.importItems[0].url == "") {
                    saveAsDialog.closeAction = unsavedDialog.closeAction
                    PopupUtils.open(saveAsDialog)
                } else {
                    saveFile(root.importItems[0],fileIO.getHomePath() + "/.local/share/com.ubuntu.developer.pawstr.edit/")

                    if(unsavedDialog.closeAction !== null)
                        unsavedDialog.closeAction.trigger()
                }
            }
        }
        Button {
            text: i18n.tr("Save as")
            color: UbuntuColors.green
            onClicked: {
                PopupUtils.close(dialogue)

                saveAsDialog.closeAction = unsavedDialog.closeAction
                PopupUtils.open(saveAsDialog)
            }
        }
        Button {
            text: i18n.tr("Close without saving")
            color: UbuntuColors.red
            onClicked: {
                PopupUtils.close(dialogue)

                if(unsavedDialog.closeAction !== null)
                    unsavedDialog.closeAction.trigger()
            }
        }
    }
}
