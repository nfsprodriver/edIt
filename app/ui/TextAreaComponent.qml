import QtQuick 2.4
import Ubuntu.Components 1.3

Component {
    TextArea {
        id: textArea
        anchors {
            margins: units.gu(1)
            fill: root
//            bottomMargin: units.gu(3)
        }
        textFormat: TextEdit.AutoText
        inputMethodHints: settings.textPrediction ? Qt.ImhMultiLine : Qt.ImhMultiLine | Qt.ImhNoPredictiveText
        selectByMouse: true
        onTextChanged: root.saved = false;
        wrapMode: settings.wordWrap ? TextEdit.Wrap : TextEdit.NoWrap

        Behavior on opacity {
            UbuntuNumberAnimation {
                from: 0.0
                to: 1.0
                duration: UbuntuAnimation.SnapDuration
            }
        }
    }
}
