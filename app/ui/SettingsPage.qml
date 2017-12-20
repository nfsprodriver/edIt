import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Qt.labs.settings 1.0

Page {
    title: i18n.tr("Settings")

//    tools: ToolbarItems {
//        back: root.pageStack.pop()
//    }
    visible: false

    Column {
        anchors {fill: parent}
        visible: parent.visible

        ListItem.Standard {
            text: i18n.tr("Word wrap")
            control: Switch {
                id: wrap
                checked: settings.wordWrap
                text: i18n.tr("Word wrap")
                onCheckedChanged: {
                    settings.wordWrap = checked
                    if(checked)
                        root.textArea.wrapMode = TextEdit.Wrap
                    else
                        root.textArea.wrapMode = TextEdit.NoWrap
                }
            }
            onClicked: wrap.checked = !wrap.checked
        }
        ListItem.Standard {
            text: i18n.tr("Text prediction")
            control: Switch {
                id: pred
                checked: settings.textPrediction
                text: i18n.tr("Text prediction")
                onCheckedChanged: {
                    settings.textPrediction = checked
                    if(checked)
                        root.textArea.inputMethodHints = Qt.ImhMultiLine
                    else
                        root.textArea.inputMethodHints = Qt.ImhMultiLine | Qt.ImhNoPredictiveText
                }
            }
            onClicked: pred.checked = !pred.checked
        }
        ListItem.Standard {
            text: i18n.tr("Information popup fading")
            control: Switch {
                id: fade
                checked: settings.infoFading
                text: i18n.tr("Information popup fading")
                onCheckedChanged: {
                    settings.infoFading = checked
                }
            }
            onClicked: fade.checked = !fade.checked
        }
        ListItem.Caption {
            anchors {
                left: parent.left
                leftMargin: units.gu(2)
            }
            Label {
                anchors {
                    top: parent.top
                    topMargin: units.gu(1)
                }
                text: i18n.tr("Fading time: ") + (settings.fadingTime / 1000) + i18n.tr("s")
            }
        }
        ListItem.Standard {
            control: Slider {
                id: slider
                width: parent.parent.width - units.gu(4)
                function formatValue(v) { return v.toFixed(1) }
                minimumValue: 0.5
                maximumValue: 5
                value: settings.fadingTime / 1000
                live: false
                onValueChanged: settings.fadingTime = formatValue(value) * 1000
            }
        }
        ListItem.Standard {
            text: i18n.tr("Automatic orientation")
            control: Switch {
                id: orient
                checked: settings.autoOrientation
                text: i18n.tr("Automatic orientation")
                onCheckedChanged: {
                    settings.autoOrientation = checked
                }
            }
            onClicked: orient.checked = !orient.checked
        }
    }
}
