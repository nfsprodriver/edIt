import QtQuick 2.4
import Ubuntu.Components 1.3

ListModel {
    id: tabsModel

    property int selectedIndex: 0

    function addTab() {
        var tabObject = textAreaComponent.createObject(root);
        tabsModel.append({tab: tabObject, title: i18n.tr("[untitled]"), url: "", saved: true});
        tabObject.visible = false;
    }

    function __disableTab(tab) {
        tab.visible = false;
        tab.z = 0;
        tab.focus = false;
//        root.textArea = null;
    }

    function __enableTab(tab) {
        tab.visible = true;
        tab.z = 1;
//        tab.forceActiveFocus();
        root.textArea = tab;
    }

    function selectTab(index) {
        __disableTab(get(selectedIndex).tab);
        __enableTab(get(index).tab);
        selectedIndex = index;
        root.title = get(index).title
        root.importItems[0].url = get(index).url
        root.saved = get(index).saved
    }

    function removeTab(index) {
        if (tabsModel.count <= 1) return;

        get(index).tab.destroy();
        remove(index);

        // Decrease the selected index to keep the state consistent.
        if (index <= selectedIndex)
            selectedIndex = Math.max(selectedIndex - 1, 0);
        selectTab(selectedIndex);
    }

    function updateTabs() {
        get(selectedIndex).title = root.title
        get(selectedIndex).url = root.importItems[0].url
    }

    function updateSaved() {
        get(selectedIndex).saved = root.saved
    }
}

