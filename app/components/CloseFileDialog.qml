import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    Dialog {
        id: dialogue
        title: i18n.tr("Close file")
        text: i18n.tr("Are you sure you want to close this file?")
        Component.onCompleted: dialogue.forceActiveFocus()
        Button {
            text: i18n.tr("Yes")
            color: UbuntuColors.green
            onClicked: {
                PopupUtils.close(dialogue)
                if(!root.saved) {
                    unsavedDialog.closeAction = closeFileDialog.closeAction
                    PopupUtils.open(unsavedDialog)
                }
                else
                    closeFileDialog.closeAction.trigger()
            }
        }
        Button {
            text: i18n.tr("No")
            color: UbuntuColors.red
            onClicked: {
                PopupUtils.close(dialogue)
            }
        }
    }
}
