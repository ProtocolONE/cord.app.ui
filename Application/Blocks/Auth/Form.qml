import QtQuick 1.1
import "../../Core/Styles.js" as Styles

FocusScope {
    property AuthFormStyle style: AuthFormStyle {
        authTitleText: Styles.style.authTitleText
        authDelimiter: Styles.style.authDelimiter
        authSubTitleText: Styles.style.authSubTitleText
    }
}
