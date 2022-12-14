import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12

Window {

    id: mainwindow

    width: 1920
    height: 1080
    visible: true

    flags: Qt.Window | Qt.FramelessWindowHint

    visibility: Window.Maximized
    UniversalMessage {
        visible: false
        id: error
    }

    function set_error(text_, window = "", error_ = true) {
        error.text__ = text_
        error.visible = true
        error.next_window = window
        error.error_information = error_
    }
    property alias cardview: lv
    property alias cardlist: card_model
    property alias paymentview: selected_payments
    property alias paymentlist: selected_paymentModel
    property alias recentPaymentView: history
    property alias recentPaymentList: historyModel

    Rectangle {
        id: header
        height: 100
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
        }
        color: "#274cac"
        Rectangle {
            id: logo_white
            width: 200
            height: 200
            radius: 50
            anchors {
                margins: 5
                left: logo.left
                top: logo.top
                bottom: logo.bottom
                right: logo.right
            }
        }

        Image {
            id: logo
            width: 177
            height: 100
            source: "/images/Logo.png"
            anchors {
                left: header.left
                top: header.top
                bottom: header.bottom
            }
        }

        Text {
            id: clientname
            anchors {
                margins: 45
                left: logo.right
                verticalCenter: logo.verticalCenter
            }
            font.pixelSize: 28
            font.bold: true
            color: "white"

            text: Controller.getUserName(
                      ) ///тут должен присваиваться ник клиента.
        }

        Rectangle {
            id: exit
            width: 200
            height: 200
            anchors {
                top: header.top
                right: header.right
                verticalCenter: header.verticalCenter
                margins: 15
            }
            color: "#6e91de"
            border.color: "#264892"
            border.width: 2
            radius: 10

            Text {
                anchors.centerIn: parent
                text: "Выйти"
                //color: "#222024"
                font.family: "Helvetica"
                font.pointSize: 17
                color: "white"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    set_authorization_window()
                }
                onPressed: {
                    parent.color = "#242f67"
                    parent.border.color = "dark gray"
                }
                onReleased: {
                    parent.color = "#6e91de"
                    parent.border.color = "#264892"
                }
            }
        }

        Text {
            id: call_number
            anchors {
                top: header.top
                topMargin: 12
                right: exit.left
                rightMargin: 45
            }
            text: "142"
            color: "white"
            font.pixelSize: 35
            font.bold: true
        }

        Image {
            id: phone_icon
            width: 44
            height: 44
            anchors {
                verticalCenter: call_number.verticalCenter
                rightMargin: 15
                right: call_number.left
            }
            source: "/images/free-icon-telephone-4996346 (1).png"
        }

        Text {
            anchors {
                top: phone_icon.bottom
                topMargin: 3
                rightMargin: 37
                right: exit.left
            }
            font.pixelSize: 20
            font.bold: true
            text: "+375336314010"
            color: "white"
        }

        Text {
            id: our_session
            anchors {
                verticalCenter: call_number.verticalCenter
                horizontalCenter: header.horizontalCenter
            }
            font.pixelSize: 20
            text: "Текущая сессия:"
            color: "white"
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: time.text = Date().toString()
        }

        Text {
            anchors {
                horizontalCenter: header.horizontalCenter
                bottom: header.bottom
                bottomMargin: 23
            }
            font.pixelSize: 18
            id: time
            color: "white"
        }
    }

    Rectangle {

        id: body
        anchors {
            top: header.bottom
            bottom: footer.top
            right: parent.right
            left: parent.left
        }
        color: "white"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: finance
            width: 600
            anchors {
                top: body.top
                bottom: body.bottom
                left: body.left
                margins: 10
            }
            radius: 8
            border.width: 3
            border.color: "#386cde"
            color: "white"

            Text {
                id: finance_text
                anchors {
                    horizontalCenter: finance.horizontalCenter
                    top: finance.top
                }
                text: "Финансы"
                font.pixelSize: 30
            }
            Rectangle {
                Text {
                    text: "У вас отсутствуют карты"
                    font.pixelSize: 40
                    color: "gray"
                    visible: !lv.count ? true : false
                    anchors {
                        centerIn: parent
                    }
                }

                width: 500
                height: 200
                color: "#d5e2ff"
                anchors {
                    top: finance_text.top
                    left: finance.left
                    right: finance.right
                    margins: 40
                }
                radius: 10
                visible: !lv.count ? true : false
            }

            ListView {

                id: lv
                height: 240
                width: 500
                anchors {
                    top: finance_text.top
                    left: finance.left
                    right: finance.right
                    margins: 40
                }
                highlightRangeMode: ListView.StrictlyEnforceRange
                clip: true
                snapMode: ListView.SnapOneItem
                orientation: ListView.Horizontal

                delegate: Component {
                    id: card_delegate
                    Rectangle {
                        id: rect_for_flip_card

                        width: 500
                        height: 240
                        color: "white"

                        Flipable {
                            id: card
                            property bool flipped: false
                            property bool type: model.type === "gold"
                            property bool system: model.system === "visa"
                            anchors.fill: parent
                            front: Image {
                                id: card_img
                                width: 700
                                height: 310
                                anchors {
                                    // fill: parent
                                    centerIn: parent
                                }
                                function getCard() {
                                    var sorce
                                    console.log("get cards " + card.type)
                                    if (card.type) {
                                        if (card.system) {
                                            sorce = "/images/Golden card VISA.png"
                                        } else if (model.system === "mastercard") {
                                            sorce = "/images/Golden Card Mastercard.png"
                                        } else {
                                            sorce = "/images/Golden card MIR .png"
                                        }
                                    } else {
                                        if (card.system) {
                                            sorce = "/images/Silver card VISA.png"
                                        } else if (model.system === "mastercard") {
                                            sorce = "/images/Silver card Mastercard.png"
                                        } else {
                                            sorce = "/images/Silver card MIR.png"
                                        }
                                    }
                                    return sorce
                                }
                                source: getCard()
                                Text {
                                    id: balance_text
                                    anchors {
                                        bottom: balance.bottom
                                        left: balance.right
                                        leftMargin: 10
                                        bottomMargin: 30
                                    }
                                    font.pixelSize: 18
                                    text: "BYN"
                                    color: "#0048ad"
                                }
                                Text {
                                    id: balance
                                    anchors {
                                        left: parent.left
                                        leftMargin: 280
                                        top: card_img.top
                                        topMargin: card_img.height / 2 - 20
                                    }
                                    font.pixelSize: 40
                                    // font.bold: true
                                    text: model.balance //model[1][4] // model.balance
                                    color: "#0048ad"
                                }
                            }
                            back: Rectangle {
                                id: card_info
                                height: 180
                                width: 480
                                anchors {
                                    //fill: parent
                                    centerIn: parent
                                }
                                color: "#d5e2ff"
                                radius: 12

                                Text {
                                    color: "black"

                                    text: "Данные о карте:"
                                    anchors {
                                        horizontalCenter: card_info.horizontalCenter
                                        top: card_info.top
                                        topMargin: 10
                                    }
                                    font.pixelSize: 24
                                }
                                Text {
                                    color: "black"

                                    id: cardholder_name_text
                                    anchors {
                                        left: card_info.left
                                        top: card_info.top
                                        topMargin: 50
                                        leftMargin: 15
                                    }
                                    text: "Имя держателя:"
                                    font.pixelSize: 22
                                    Text {
                                        color: "black"

                                        ///////////////////////////////
                                        id: cardholder_name
                                        anchors {
                                            verticalCenter: cardholder_name_text.verticalCenter
                                            left: cardholder_name_text.right
                                            leftMargin: 13
                                        }
                                        text: model.name //model.name
                                        font.pixelSize: 22
                                    }
                                }
                                Text {
                                    id: card_number_text
                                    color: "black"
                                    text: "Номер карты:"
                                    font.pixelSize: 20
                                    anchors {
                                        left: card_info.left
                                        top: card_info.top
                                        topMargin: 85
                                        leftMargin: 15
                                    }
                                    Text {
                                        ///////////////////////////////
                                        color: "black"

                                        id: card_number
                                        anchors {
                                            verticalCenter: card_number_text.verticalCenter
                                            left: card_number_text.right
                                            leftMargin: 13
                                        }
                                        text: model.number //model.number
                                        font.pixelSize: 20
                                    }
                                }
                                Text {
                                    color: "black"

                                    id: valid_thru_text
                                    text: "Годна до:"
                                    font.pixelSize: 20
                                    anchors {
                                        left: card_info.left
                                        top: card_info.top
                                        topMargin: 120
                                        leftMargin: 15
                                    }
                                    Text {
                                        ///////////////////////////////
                                        color: "black"

                                        id: valid_thru
                                        anchors {
                                            verticalCenter: valid_thru_text.verticalCenter
                                            left: valid_thru_text.right
                                            leftMargin: 13
                                        }
                                        text: model.valid //model.valid
                                        font.pixelSize: 20
                                    }
                                }
                            }

                            transform: Rotation {
                                origin.x: card.width / 2
                                origin.y: card.height / 2
                                axis.x: 1
                                axis.y: 0
                                axis.z: 0
                                angle: card.flipped ? 180 : 0

                                Behavior on angle {
                                    NumberAnimation {
                                        duration: 600
                                    }
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: card.flipped = !card.flipped
                            }
                        }
                    }
                }

                model: ListModel {
                    id: card_model
                }

                function addElement(number, name, type, valid, system, balance) {
                    card_model.append({
                                          "number": number,
                                          "name": name,
                                          "valid": valid,
                                          "type": type,
                                          "system": system,
                                          "balance": balance
                                      })
                }
                function clearModel() {
                    card_model.clear()
                }
            }
            Rectangle {

                id: cash
                height: 230
                color: "#d5e2ff"
                anchors {
                    top: add_card.bottom
                    topMargin: 20
                    bottom: finance.bottom
                    left: finance.left
                    right: finance.right
                    bottomMargin: 20
                    rightMargin: 50
                    leftMargin: 50
                }
                radius: 8

                GridLayout {
                    id: grid__
                    rows: 7
                    columns: 4
                    Layout.fillHeight: true
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                        left: parent.left
                        rightMargin: 30
                        leftMargin: 30
                        bottomMargin: 20
                    }

                    Text {
                        Layout.row: 0
                        Layout.columnSpan: 4
                        Layout.column: 0

                        id: cash_title
                        font.pixelSize: 22

                        //font.bold: true
                        Layout.alignment: Qt.AlignCenter
                        text: "Курсы валют в отделениях БелБанка"
                    }
                    Text {
                        Layout.row: 1
                        Layout.columnSpan: 2
                        Layout.column: 0
                        font.pixelSize: 17
                        font.bold: true
                        text: "    Валюта:"
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        id: sell
                        Layout.row: 1
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: 17
                        font.bold: true

                        text: "   Продажа:"
                    }
                    Text {
                        id: buy
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 1
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: 17
                        font.bold: true

                        text: "Покупка:"
                    }
                    Text {
                        Layout.row: 2
                        Layout.columnSpan: 1
                        Layout.column: 1
                        id: rub
                        text: "100RUB"
                        font.pixelSize: 18
                        Image {
                            Layout.row: 2
                            Layout.columnSpan: 1
                            Layout.column: 0
                            width: 40
                            height: 30
                            source: "/images/RUB.png"
                            anchors {
                                right: rub.left
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 2
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[0]
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 2
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[1]
                    }
                    Text {
                        Layout.row: 3
                        Layout.columnSpan: 1
                        Layout.column: 1
                        id: usd
                        text: "1USD"
                        font.pixelSize: 18
                        Image {
                            width: 40
                            height: 30
                            source: "/images/USD.png"
                            anchors {
                                right: usd.left
                            }
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 3
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[2]
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 3
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[3]
                    }
                    Text {
                        Layout.row: 4
                        Layout.columnSpan: 1
                        Layout.column: 1
                        id: euro
                        text: "1EUR"
                        font.pixelSize: 18
                        Image {
                            width: 40
                            height: 30
                            source: "/images/EURO.png"
                            anchors {
                                right: euro.left
                            }
                        }
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 4
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[4]
                    }
                    Text {
                        Layout.alignment: Qt.AlignCenter

                        Layout.row: 4
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[5]
                    }

                    Text {
                        Layout.row: 5
                        Layout.columnSpan: 1
                        Layout.column: 1
                        id: china
                        text: "10CNY"
                        font.pixelSize: rub.font.pixelSize
                        Image {
                            width: 40
                            height: 30
                            source: "/images/china.jpg"
                            anchors {
                                right: china.left
                            }
                        }
                    }
                    Text {
                        Layout.row: 5
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[6]
                        Layout.alignment: Qt.AlignCenter
                    }
                    Text {
                        Layout.row: 5
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[7]
                        Layout.alignment: Qt.AlignCenter
                    }

                    Text {
                        Layout.row: 6
                        Layout.columnSpan: 1
                        Layout.column: 1
                        id: pln
                        text: "10PLN"
                        font.pixelSize: rub.font.pixelSize
                        Image {
                            width: 40
                            height: 30
                            source: "/images/PLN.jpg"
                            anchors {
                                right: pln.left
                            }
                        }
                    }
                    Text {
                        Layout.row: 6
                        Layout.columnSpan: 1
                        Layout.column: 2
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[8]
                        Layout.alignment: Qt.AlignCenter
                    }
                    Text {
                        Layout.row: 6
                        Layout.columnSpan: 1
                        Layout.column: 3
                        font.pixelSize: rub.font.pixelSize
                        text: Controller.exchangeRatesForBank()[9]
                        Layout.alignment: Qt.AlignCenter
                    }
                }
            }

            Rectangle {
                id: new_card
                height: 23
                anchors {
                    top: lv.bottom
                    left: finance.left
                    right: finance.right
                    rightMargin: 50
                    leftMargin: 50
                    bottomMargin: 20
                }
                color: "#6e91de"
                border.color: "#264892"
                border.width: 2
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: "Создать новую карту"
                    font.family: "Helvetica"
                    font.pointSize: 13
                    font.bold: true
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        set_new_card_window()
                    }

                    onPressed: {
                        parent.color = "#242f67"
                        parent.border.color = "dark gray"
                    }
                    onReleased: {
                        parent.color = "#6e91de"
                        parent.border.color = "#7d3a9c"
                    }
                }
            }

            Rectangle {
                id: add_card
                height: 23
                anchors {
                    top: new_card.bottom
                    left: finance.left
                    right: finance.right
                    rightMargin: 50
                    leftMargin: 50
                    topMargin: 10
                    bottomMargin: 20
                }
                color: "#6e91de"
                border.color: "#264892"
                border.width: 2
                radius: 10
                Text {
                    anchors.centerIn: parent
                    text: "Добавить карту"
                    font.family: "Helvetica"
                    font.pointSize: 13
                    font.bold: true
                    color: "white"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        set_add_card_window()
                    }

                    onPressed: {
                        parent.color = "#242f67"
                        parent.border.color = "dark gray"
                    }
                    onReleased: {
                        parent.color = "#6e91de"
                        parent.border.color = "#7d3a9c"
                    }
                }
            }
        }

        Rectangle {
            id: payments
            anchors {
                top: body.top
                bottom: body.bottom
                left: finance.right
                right: body.right
                margins: 10
            }
            radius: 8
            border.width: 3
            anchors.rightMargin: 8
            anchors.bottomMargin: 10
            anchors.leftMargin: 12
            anchors.topMargin: 10
            border.color: "#386cde"
            color: "white"

            Text {
                id: payments_text
                anchors {
                    top: payments.top
                    horizontalCenter: payments.horizontalCenter
                }
                text: "Платежи и переводы"
                font.pixelSize: 30
            }

            Text {
                id: erip_text
                x: 30
                y: 60
                width: 295
                height: 37
                text: qsTr("Система Расчета ЕРИП")
                font.pixelSize: 28
                anchors {
                    horizontalCenter: erip.horizontalCenter
                    top: payments_text.bottom
                    topMargin: 15
                }
            }

            Rectangle {
                id: popular_payments

                height: payments.height / 2
                //                border.color: "#d088f2"
                //                color: "#fdffbd"
                //                border.width: 3
                radius: 20
                color: "transparent"
                anchors {
                    left: erip.right
                    leftMargin: 25
                    right: payments.right
                    rightMargin: 30
                    top: erip.top
                }

                Flipable {
                    id: popular_or_selected
                    property bool flipped: false

                    anchors.fill: parent
                    front: Rectangle {
                        id: popular
                        anchors {
                            fill: parent
                            margins: 2
                        }

                        color: "#d5e2ff"
                        radius: 10
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: "transparent"
                            id: swap_button_to_selected
                            anchors {
                                bottom: popular.bottom
                                left: popular.left
                                margins: 10
                            }
                            Image {
                                id: img_1
                                visible: true
                                width: 40
                                height: 40

                                anchors {
                                    centerIn: parent
                                }
                                source: "/images/swap.png"
                            }

                            Rectangle {
                                id: swap_rect_1
                                // rounded corners for img
                                anchors.fill: img_1
                                color: "transparent"
                                border.color: "#264892"
                                border.width: 1
                                radius: 10
                            }
                            MouseArea {

                                anchors {
                                    fill: swap_rect_1
                                }
                                function popular_text() {
                                    popular_payments_text.text = "Избранные платежи"
                                }

                                onClicked: {
                                    popular_or_selected.flipped = !popular_or_selected.flipped
                                    popular_text()
                                }
                                onPressed: {
                                    swap_rect_1.border.width = 3
                                }
                                onReleased: {
                                    swap_rect_1.border.width = 1
                                }
                            }
                        }

                        GridLayout {
                            rows: 5
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            columns: 4
                            anchors {
                                leftMargin: 50
                                topMargin: 15
                                rightMargin: 50
                                bottomMargin: 20
                                fill: parent
                            }

                            MouseArea {
                                id: mts_mouse_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 0
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: beltelecom_text.width
                                height: 140
                                onClicked: {
                                    set_payment_window("МТС")
                                }
                                onPressed: {
                                    mts_text.font.bold = true
                                }
                                onReleased: {
                                    mts_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: a1_mouse_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 1
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: beltelecom_text.width
                                height: 140
                                onClicked: {
                                    set_payment_window("А1")
                                }
                                onPressed: {
                                    a1_text.font.bold = true
                                }
                                onReleased: {
                                    a1_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: life_mouse_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 1
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: beltelecom_text.width
                                height: 140
                                onClicked: {
                                    set_payment_window("Лайф")
                                }
                                onPressed: {
                                    life_text.font.bold = true
                                }
                                onReleased: {
                                    life_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: beltelecom_mouse_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 3
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: beltelecom_text.width + 10
                                height: 140
                                onClicked: {
                                    set_payment_window("Белтелеком")
                                }
                                onPressed: {
                                    beltelecom_text.font.bold = true
                                }
                                onReleased: {
                                    beltelecom_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: byfly_mouse_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 0
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: beltelecom_text.width
                                height: 140
                                onClicked: {
                                    set_payment_window("ByFly")
                                }
                                onPressed: {
                                    byfly_text.font.bold = true
                                }
                                onReleased: {
                                    byfly_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: card_to_card_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 2
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: card_to_card_text.width
                                height: 140

                                onClicked: {
                                    set_payment_window("Перевод на карту", true)
                                }
                                onPressed: {
                                    card_to_card_text.font.bold = true
                                }
                                onReleased: {
                                    card_to_card_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: requisites_area
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 2
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                width: requisites_text.width
                                height: 140
                                onClicked: {
                                    set_payment_window("Платеж по реквизитам")
                                }
                                onPressed: {
                                    requisites_text.font.bold = true
                                }
                                onReleased: {
                                    requisites_text.font.bold = false
                                }
                            }

                            MouseArea {
                                id: loans_area
                                width: loans_text.width
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 3
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1

                                height: 140
                                onClicked: {
                                    set_payment_window("Погашение кредита")
                                }
                                onPressed: {
                                    loans_text.font.bold = true
                                }
                                onReleased: {
                                    loans_text.font.bold = false
                                }
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                id: mts

                                Layout.row: 0
                                Layout.column: 0
                                width: beltelecom_text.width
                                height: 105

                                clip: true
                                border.width: 10
                                border.color: "#6e91de"

                                Image {
                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    smooth: true
                                    source: "/images/MTS.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: mts_text
                                Layout.row: 1
                                Layout.column: 0
                                font.pixelSize: 20
                                text: "МТС"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 1
                                width: beltelecom_text.width
                                height: mts.height

                                Image {
                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/A1.jpg"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: a1_text
                                Layout.row: 1
                                Layout.column: 1
                                font.pixelSize: 20
                                text: "А1"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 1
                                width: beltelecom_text.width
                                height: mts.height

                                Image {
                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/LIFE.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: life_text
                                Layout.row: 4
                                Layout.column: 1
                                font.pixelSize: 20
                                text: "Life"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 3
                                width: beltelecom_text.width + 13
                                height: mts.height
                                color: "transparent"

                                Image {
                                    fillMode: Image.PreserveAspectCrop
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/Beltelecom.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: beltelecom_text
                                Layout.row: 1
                                Layout.column: 3
                                font.pixelSize: 20
                                text: "Белтелеком"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 0
                                width: beltelecom_text.width
                                height: mts.height

                                Image {
                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/ByFly.jpg"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: byfly_text
                                Layout.row: 4
                                Layout.column: 0
                                font.pixelSize: 20
                                text: "ByFly"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 0
                                Layout.column: 2
                                width: card_to_card_text.width + 13
                                height: mts.height

                                Image {
                                    Layout.alignment: Qt.AlignHCenter

                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/card_to_card_payment.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: card_to_card_text
                                Layout.row: 1
                                Layout.column: 2
                                font.pixelSize: 20
                                text: "Перевод на\n     карту"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 2
                                width: requisites_text.width + 13
                                height: mts.height

                                Image {
                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/requisites_payment.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter

                                id: requisites_text
                                Layout.row: 4
                                Layout.column: 2
                                font.pixelSize: 20
                                text: "Перевод по\nреквизитам"
                            }

                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter

                                Layout.row: 3
                                Layout.column: 3
                                width: loans_text.width + 13
                                height: mts.height

                                Image {

                                    fillMode: Image.Stretch
                                    anchors {
                                        fill: parent
                                    }
                                    source: "/images/percentage_icon.png"
                                }
                            }
                            Text {
                                Layout.alignment: Qt.AlignHCenter
                                id: loans_text
                                Layout.row: 4
                                Layout.column: 3
                                font.pixelSize: 20
                                text: "Погашение\n кредитов"
                            }
                        }
                    }
                    back: Rectangle {
                        id: selected

                        anchors {
                            fill: parent
                            margins: 3
                        }
                        color: "#d5e2ff"
                        radius: 10

                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: "transparent"
                            id: swap_button_to_popular
                            anchors {
                                bottom: selected.bottom
                                left: selected.left
                                margins: 10
                            }
                            Image {
                                id: img_2
                                visible: true
                                width: 40
                                height: 40

                                anchors {
                                    centerIn: parent
                                }
                                source: "/images/swap.png"
                            }

                            Rectangle {
                                id: swap_rect_2
                                // rounded corners for img
                                anchors.fill: img_2
                                color: "transparent"
                                border.color: "#274cac"
                                border.width: 1
                                radius: 10
                            }
                            MouseArea {

                                anchors {
                                    fill: swap_rect_2
                                }

                                function selected_text() {
                                    popular_payments_text.text = "Популярные платежи"
                                }

                                onClicked: {
                                    popular_or_selected.flipped = !popular_or_selected.flipped
                                    selected_text()
                                }
                                onPressed: {
                                    swap_rect_2.border.width = 3
                                }
                                onReleased: {
                                    swap_rect_2.border.width = 1
                                }
                            }
                        }

                        Text {
                            id: selected_payments_text
                            text: "Наименование платежа"
                            visible: !selected_payments.count ? false : true
                            font.pixelSize: 16
                            anchors {
                                top: selected.top
                                topMargin: 5
                                bottomMargin: 5
                                bottom: selected_payments.top
                                horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Text {
                            visible: !selected_payments.count ? true : false
                            anchors {
                                centerIn: parent
                            }
                            font.pixelSize: 50
                            color: "gray"

                            text: "Избранных платежей нет"
                        }

                        ListView {
                            currentIndex: -1
                            id: selected_payments
                            x: 41
                            y: 112
                            width: 385
                            height: 719
                            anchors {
                                top: selected.top
                                topMargin: 40
                                left: parent.left
                                leftMargin: 20
                                rightMargin: 20
                                right: parent.right
                                bottomMargin: 20
                                bottom: parent.bottom
                            }
                            model: selected_paymentModel
                            delegate: selected_paymentDelegate

                            focus: true
                            clip: true
                            highlight: Rectangle {
                                z: 1
                                color: "transparent"
                                border.width: 3
                                border.color: "#6e91de"
                            }

                            function addFavPayment(payment) {
                                selected_paymentModel.append({
                                                                 "name": payment
                                                             })
                            }
                            function clearModel() {
                                selected_paymentModel.clear()
                            }
                        }

                        ListModel {
                            id: selected_paymentModel
                        }

                        Component {
                            id: selected_paymentDelegate

                            Rectangle {
                                radius: 3
                                color: index % 2 ? "#d5e2ff" : "#bed2ff"
                                height: 40
                                clip: true
                                width: 385
                                border.width: 1
                                border.color: "gray"
                                readonly property ListView __lv: ListView.view

                                anchors {
                                    left: parent.left
                                    right: parent.right
                                }
                                Text {

                                    height: parent.height
                                    text: model.name
                                    font.pixelSize: 20
                                    anchors {
                                        horizontalCenter: parent.horizontalCenter
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: __lv.currentIndex = index
                                    onDoubleClicked: {
                                        set_payment_window()
                                    }
                                }
                            }
                        }
                    }

                    transform: Rotation {
                        origin.x: popular_or_selected.width / 2
                        origin.y: popular_or_selected.height / 2
                        axis.x: 0
                        axis.y: 1
                        axis.z: 0
                        angle: popular_or_selected.flipped ? 180 : 0

                        Behavior on angle {
                            NumberAnimation {
                                duration: 600
                            }
                        }
                    }
                }
            }

            Text {
                id: popular_payments_text

                text: qsTr("Популярные платежи")
                font.pixelSize: 28
                anchors {
                    top: erip_text.top
                    horizontalCenter: popular_payments.horizontalCenter
                }
            }

            Text {
                id: payments_history_text
                text: "История платежей"
                font.pixelSize: 28
                anchors {
                    top: popular_payments.bottom
                    topMargin: 10
                    horizontalCenter: popular_payments.horizontalCenter
                }
            }

            Rectangle {
                id: payments_history

                anchors {

                    top: payments_history_text.bottom
                    topMargin: 15
                    left: erip.right
                    leftMargin: 25
                    right: payments.right
                    rightMargin: 30
                    bottom: payments.bottom
                    bottomMargin: 20
                }
                radius: 10

                color: "#d5e2ff"

                Text {
                    visible: !history.count ? true : false
                    text: "Нет недавних платежей"
                    font.pixelSize: 50
                    anchors {
                        centerIn: parent
                    }
                    color: "gray"
                }

                Text {
                    visible: history.count ? true : false

                    id: operation_name
                    anchors {
                        left: history.left
                        leftMargin: 5
                        top: payments_history.top
                        topMargin: 5
                    }
                    text: "Название платежа"
                    font.pixelSize: 16
                }

                Text {
                    visible: history.count ? true : false

                    id: operation_date
                    anchors {
                        top: payments_history.top
                        topMargin: 5
                        horizontalCenter: payments_history.horizontalCenter
                    }
                    text: "Дата проведения платежа"
                    font.pixelSize: 16
                }

                Text {
                    visible: history.count ? true : false

                    id: value
                    anchors {
                        right: history.right
                        rightMargin: 5
                        top: payments_history.top
                        topMargin: 5
                    }
                    text: "Сумма платежа"
                    font.pixelSize: 16
                }

                ListView {
                    currentIndex: -1
                    id: history
                    x: 41
                    y: 112
                    width: 385
                    height: 719
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        leftMargin: 30
                        rightMargin: 30
                        bottomMargin: 14
                        top: operation_name.bottom
                        topMargin: 6
                    }
                    model: historyModel
                    delegate: historyDelegate

                    focus: true
                    clip: true
                    highlight: Rectangle {
                        z: 1
                        color: "transparent"
                        border.width: 3
                        border.color: "#6e91de"
                    }
                    function addElement(name, date, time, cost) {
                        historyModel.append({
                                                "value": cost,
                                                "name": name,
                                                "date": date + ' ' + time
                                            })
                    }
                    function clearModel() {
                        historyModel.clear()
                    }
                }

                ListModel {
                    id: historyModel
                }
                Component {
                    id: historyDelegate

                    Rectangle {
                        radius: 8
                        color: index % 2 ? "#a8c2ff" : "#bed2ff"
                        height: 37
                        // clip: true
                        width: 385
                        border.width: 1
                        border.color: "#264892"
                        readonly property ListView __lv: ListView.view

                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        Text {
                            id: payment_name
                            height: parent.height
                            text: model.name
                            font.pixelSize: 19
                            anchors {
                                top: parent.top
                                topMargin: 4
                                left: parent.left
                                leftMargin: 15
                            }
                        }
                        Text {

                            height: parent.height
                            text: model.value
                            font.pixelSize: 19
                            anchors {
                                top: parent.top
                                topMargin: 4
                                right: parent.right
                                rightMargin: 15
                            }
                        }
                        Text {

                            height: parent.height
                            text: model.date
                            font.pixelSize: 19

                            anchors {
                                top: parent.top
                                topMargin: 4
                                horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: __lv.currentIndex = index

                            onDoubleClicked: {
                                set_payment_window(payment_name.text)
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors {
                    top: erip.top
                    bottom: erip.bottom
                    right: erip.right
                    left: erip.left
                    margins: 5
                }
                color: "#d5e2ff"
            }

            ListView {
                currentIndex: -1
                id: erip
                property var collapsed: ({})
                x: 41
                y: 112
                width: 385
                height: 719
                anchors {
                    left: payments.left
                    leftMargin: 40
                    bottom: payments.bottom
                    bottomMargin: 20
                    top: erip_text.bottom
                    topMargin: 15
                }
                model: nameModel
                delegate: nameDelegate

                focus: true
                clip: true

                highlight: Rectangle {
                    z: 1
                    color: "transparent"
                    border.width: 3
                    border.color: "#6e91de"
                }
                section {
                    property: "team"
                    criteria: ViewSection.FullString
                    delegate: Rectangle {

                        id: section_
                        signal clicked

                        radius: 4
                        color: "#6e91de"
                        width: 385
                        height: 35

                        border.width: 2
                        border.color: "black"
                        Text {
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }

                            font.pixelSize: 16
                            font.bold: true
                            text: section
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                section_.clicked()
                                erip.toggleSection(section)
                            }
                        }
                        Component.onCompleted: erip.hideSection(section)
                    }
                }

                function isSectionExpanded(section) {
                    return !(section in collapsed)
                }

                function showSection(section) {
                    delete collapsed[section]
                    collapsedChanged()
                }

                function hideSection(section) {
                    collapsed[section] = true
                    collapsedChanged()
                }

                function toggleSection(section) {
                    if (isSectionExpanded((section))) {
                        hideSection(section)
                    } else {
                        showSection(section)
                    }
                }

                ListModel {
                    id: nameModel
                    ListElement {
                        name: "Погашение кредита"
                        team: "Банки, НКФО"
                    }
                    ListElement {
                        name: "Пополнение счета"
                        team: "Банки, НКФО"
                    }
                    ListElement {
                        name: "Пополнение безотзывного вклада"
                        team: "Банки, НКФО"
                    }
                    ListElement {
                        name: "Bynex"
                        team: "Криптобиржи, криптообменники"
                    }
                    ListElement {
                        name: "Currency.com"
                        team: "Криптобиржи, криптообменники"
                    }
                    ListElement {
                        name: "Free2x.com"
                        team: "Криптобиржи, криптообменники"
                    }
                    ListElement {
                        name: "Пополнение QIWI Кошелька"
                        team: "Электронные деньги"
                    }
                    ListElement {
                        name: "Пополнение ЮMoney"
                        team: "Электронные деньги"
                    }
                    ListElement {
                        name: "Продажа WMB (эл.денег)"
                        team: "Электронные деньги"
                    }
                    ListElement {
                        name: "Интернет, ТВ"
                        team: "А1"
                    }
                    ListElement {
                        name: "Кабельное ТВ"
                        team: "А1"
                    }
                    ListElement {
                        name: "Абонентская плата"
                        team: "А1"
                    }
                    ListElement {
                        name: "Услуга VOKA"
                        team: "А1"
                    }
                    ListElement {
                        name: "ZALA, byfly, Умный дом, пакеты"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "Закрытый телефон"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "Разовый платеж"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "Реализация товаров"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "Телефон"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "ТСИС:карт/абон/корпоратив.счет"
                        team: "Белтелеком"
                    }
                    ListElement {
                        name: "Домашний интернет"
                        team: "МТС"
                    }
                    ListElement {
                        name: "Промывка водопроводных сетей"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Приемка в эксплуатацию"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Утилизация сточных вод"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Экспертная проверка водомера"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Вывоз мусора"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Газоснабжение"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Прочие услуги"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "ТО, ремонт, услуги"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Коммун. платежи АИС Расчет-ЖКУ"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Платно-бытовые услуги"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Платежи через ЦИТ"
                        team: "Коммунальные платежи"
                    }
                    ListElement {
                        name: "Выдача ВУ"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Выдача дубликата ВУ"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Компьютерные услуги"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Оформление заявления"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Практический экзамен на авто"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Практический экзамен на мото"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Предоставление автодрома"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Предоставление ТС для экзамена"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Теоретический экзамен"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Тестирование знаний ПДД"
                        team: "ГАИ"
                    }
                    ListElement {
                        name: "Репетиционное тестирование"
                        team: "Образование и развитие"
                    }
                    ListElement {
                        name: "Централизованное тестирование"
                        team: "Образование и развитие"
                    }
                    ListElement {
                        name: "Физкультурно-оздоровит. услуги"
                        team: "Образование и развитие"
                    }
                    ListElement {
                        name: "Посещение бассейна"
                        team: "Образование и развитие"
                    }
                }
                Component {
                    id: nameDelegate

                    Rectangle {
                        radius: 8
                        color: index % 2 ? "#d5e2ff" : "#bed2ff"
                        height: expanded ? 27 : 0
                        clip: true
                        width: 385
                        border.width: 1
                        border.color: "gray"
                        readonly property ListView __lv: ListView.view
                        property bool expanded: __lv.isSectionExpanded(
                                                    model.team)

                        Text {
                            id: delegate_text

                            height: parent.height
                            text: model.name
                            font.pixelSize: 17
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                            }
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: 300
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: __lv.currentIndex = index
                            onDoubleClicked: {
                                set_payment_window(model.name)
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: footer
        property int index

        height: 130
        anchors {
            bottom: parent.bottom
            right: parent.right
            left: parent.left
        }

        color: "#274cac"

        Text {
            id: faq

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: 20
                topMargin: 5
            }
            font.pixelSize: 15
            color: "white"
            text: "Возник вопрос?"
        }

        Rectangle {

            id: qr_code_rect
            width: height
            anchors {
                bottom: parent.bottom
                left: parent.left
                top: faq.bottom
                topMargin: 5

                leftMargin: 30
                bottomMargin: 5
            }

            Image {
                id: qr_code
                anchors {
                    fill: parent
                }

                source: "/images/BelBankQR.jpg"
            }
        }

        PageIndicator {
            Rectangle {
                id: left_page_indicator
                width: parent.width / 2
                height: parent.height
                anchors {
                    left: parent.left
                    top: parent.top
                }
                color: "transparent"
                radius: 4
                MouseArea {
                    anchors {
                        fill: parent
                    }
                    onClicked: {
                        info_lv.decrementCurrentIndex()
                    }
                }
            }
            Rectangle {
                id: right_page_indicator
                width: parent.width / 2
                height: parent.height
                anchors {
                    right: parent.right
                    top: parent.top
                }
                color: "transparent"
                radius: 4
                MouseArea {
                    anchors {
                        fill: parent
                    }

                    onClicked: {
                        info_lv.incrementCurrentIndex()
                    }
                }
            }

            id: control
            count: 2
            currentIndex: info_lv.currentIndex

            anchors {
                top: info_lv.bottom
                topMargin: 5
                horizontalCenter: info_lv.horizontalCenter
            }

            delegate: Rectangle {
                implicitWidth: 10
                implicitHeight: 10

                radius: width / 2
                color: "#f9b54c"

                opacity: index === control.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 100
                    }
                }
            }
        }

        ListView {
            id: info_lv

            width: 400
            height: 90

            anchors {
                top: footer.top

                bottomMargin: 5
                topMargin: 10
                horizontalCenter: footer.horizontalCenter
            }
            highlightRangeMode: ListView.StrictlyEnforceRange
            clip: true
            snapMode: ListView.SnapOneItem
            orientation: ListView.Horizontal
            delegate: info_delegate
            model: ListModel {
                id: info_model
                ListElement {
                    source__: "/images/password_safety.jpg"
                    text__: '<html><style type="text/css"></style><a href="https://belarusbank.by/ru/33139/press/bank_news/36608">google</a></html>'
                }
                ListElement {
                    source__: "/images/news.jpg"
                    text__: '<html><style type="text/css"></style><a href="https://primepress.by/news/finansi/">google</a></html>'
                }
            }
            Component {
                id: info_delegate
                Rectangle {
                    id: rect_for_flip_card
                    width: info_lv.width
                    height: info_lv.height
                    color: "transparent"

                    Image {
                        fillMode: info_lv.currentIndex ? Image.PreserveAspectCrop : Image.Stretch

                        anchors {
                            fill: parent
                        }
                        source: source__

                        Text {
                            anchors {
                                fill: parent
                            }
                            font.pixelSize: 500
                            id: link_Text
                            text: text__
                            onLinkActivated: Qt.openUrlExternally(link)
                        }
                    }
                }
            }
        }

        Text {
            anchors {
                right: footer.right
                verticalCenter: footer.verticalCenter
                rightMargin: 45
            }
            font.bold: true
            font.pixelSize: 26
            text: "Белбанк, 2022"
            color: "white"
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:1}D{i:3}D{i:4}D{i:5}D{i:7}D{i:8}D{i:6}D{i:9}D{i:10}
D{i:11}D{i:12}D{i:13}D{i:14}D{i:2}D{i:17}D{i:18}D{i:38}D{i:39}D{i:40}D{i:41}D{i:43}
D{i:42}D{i:44}D{i:45}D{i:47}D{i:46}D{i:48}D{i:49}D{i:51}D{i:50}D{i:52}D{i:53}D{i:55}
D{i:54}D{i:56}D{i:57}D{i:59}D{i:58}D{i:60}D{i:61}D{i:37}D{i:36}D{i:63}D{i:64}D{i:62}
D{i:66}D{i:67}D{i:65}D{i:16}D{i:69}D{i:70}D{i:72}D{i:71}D{i:126}D{i:127}D{i:129}D{i:130}
D{i:131}D{i:132}D{i:133}D{i:135}D{i:136}D{i:128}D{i:142}D{i:145}D{i:191}D{i:143}D{i:68}
D{i:15}D{i:196}D{i:198}D{i:197}D{i:201}D{i:200}D{i:203}D{i:202}D{i:199}D{i:209}D{i:205}
D{i:213}D{i:195}
}
##^##*/

