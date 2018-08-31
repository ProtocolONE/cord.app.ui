import QtQuick 2.4
import Tulip 1.0
import ProtocolOne.Controls 1.0
import Dev 1.0

Rectangle {
    id: root

    color: "#002336"
    width: 800
    height: 600

    Column {
        x: 50
        y: 30
        spacing: 20

        Button {
            id: firstButton

            width: 200
            height: 50

            text: "Button"
            toolTip: "Simple button tooltip"
            inProgress: inProgressRadioButton.checked
            enabled: !disabledRadioButton.checked

            style: ButtonStyleColors {
                normal: "#3498db"
                hover: "#118011"
                disabled: "#888888"
            }
        }

        Button {
            enabled: false

            width: 200
            height: 50

            toolTip: "Disabled button"
            text: "Button2"
        }

        TextButton {
            width: 350
            height: 40
            text: "Text button"
            toolTip: "Text button tooltip"
            style: ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }

            Rectangle {
                anchors {
                    fill: parent
                }
                color: "red"
                opacity: 0.2
            }
        }

        TextButton {
            text: "Text button"
            toolTip: "Text button tooltip"
            style: ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }

            Rectangle {
                anchors {
                    fill: parent
                }
                color: "red"
                opacity: 0.2
            }
        }

        TextButton {
            width: 200
            icon: installPath + "/Assets/Images/Application/Blocks/Auth/support.png"
            text: "Multi line Text button example with really long text"
            toolTip: "Text button tooltip"
            style: ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }

            Rectangle {
                anchors {
                    fill: parent
                }
                color: "red"
                opacity: 0.2
            }
        }

        TextButton {
            width: 200
            layoutDirection: Qt.RightToLeft
            icon: installPath + "/Assets/Images/Application/Blocks/Auth/support.png"
            text: "Multi line Text button example with really long text"
            toolTip: "Text button tooltip"
            style: ButtonStyleColors {
                normal: "#3498db"
                hover: "#3670DC"
                disabled: "#3498db"
            }

            Rectangle {
                anchors {
                    fill: parent
                }
                color: "red"
                opacity: 0.2
            }
        }



        ImageButton {
            width: 40
            height: 40

            toolTip: "Iconed button"

            style: ButtonStyleColors {
                normal: "#1ABC9C"
                hover: "#019074"
                disabled: "#1ABC9C"
            }
            styleImages: ButtonStyleImages {
                normal: installPath + "Samples/images/mail.png"
            }
        }

        CheckBox {
            //width: 300
            //height: 16

            text: "Check box"
            toolTip: "CheckBox button tooltip"
            style {
                normal: "#7e8f9e"
                hover: "#a1c1d2"
                disabled: "#7e8f9e"

                active: "#31bca0"
                activeHover: "#3cccb6"
            }
        }

        RadioButton {
            id: inProgressRadioButton

            width: 300
            height: 40

            text: "In progress"
            toolTip: "In progress button tooltip"
            style: ButtonStyleColors {
                normal: "#1ADC9C"
                hover: "#019074"
                disabled: "#1ADC9C"
            }
            onClicked: {
                if (disabledRadioButton.checked) {
                    disabledRadioButton.checked = false;
                }

                if (normalRadioButton.checked) {
                    normalRadioButton.checked = false;
                }

                checked = true;
            }
        }

        RadioButton {
            id: disabledRadioButton

            width: 300
            height: 40

            text: "Disable button"
            toolTip: "Disable button tooltip"
            style: ButtonStyleColors {
                normal: "#1ADC9C"
                hover: "#019074"
                disabled: "#1ADC9C"
            }
            onClicked: {
                if (inProgressRadioButton.checked) {
                    inProgressRadioButton.checked = false;
                }

                if (normalRadioButton.checked) {
                    normalRadioButton.checked = false;
                }

                checked = true;
            }
        }

        RadioButton {
            id: normalRadioButton

            width: 300
            height: 40

            text: "Normal state button"
            toolTip: "Normal state button tooltip"
            style: ButtonStyleColors {
                normal: "#1ADC9C"
                hover: "#019074"
                disabled: "#1ADC9C"
            }
            onClicked: {
                if (inProgressRadioButton.checked) {
                    inProgressRadioButton.checked = false;
                }
                if (disabledRadioButton.checked) {
                    disabledRadioButton.checked = false;
                }

                checked = true;
            }
        }
    }
}
