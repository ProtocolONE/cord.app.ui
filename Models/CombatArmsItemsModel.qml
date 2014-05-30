/****************************************************************************
** This file is a part of Syncopate Limited GameNet Application or it parts.
**
** Copyright (©) 2011 - 2013, Syncopate Limited and/or affiliates.
** All rights reserved.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
****************************************************************************/
import QtQuick 1.1

ListModel {
    id: rootModel;

    Component.onCompleted: {
        var fields = ['title', 'description', 'shortDescription']
        , elem
        , i;

        var option, j;

        for (i = 0; i < rootModel.count; i++) {
            elem = rootModel.get(i);
            fields.forEach(function(el) {
                if (elem[el]) {
                    rootModel.setProperty(i, el, qsTr(elem[el]));
                }

                
            });

            if (elem.options) {
                var translateOptions = ['label'];
                var optionsModel = elem.options;

                for (j = 0; j < optionsModel.count; j++) {
                    option = optionsModel.get(j);
                    translateOptions.forEach(function(opt) {
                        if (option[opt]) {
                            optionsModel.setProperty(j, opt, qsTr(option[opt]));
                        }
                    });
                }
            }
        }
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1790_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1790.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1790_DESCRIPTION");
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1790_DESCRIPTION_SHORT");
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1790;
                label: QT_TR_NOOP("CA_SHOP_1PCS")
                price: 45;
            },
            ListElement {
                optionId: 1791;
                label: QT_TR_NOOP("CA_SHOP_7PCS")
                price: 315;
            },
            ListElement {
                optionId: 1792;
                label: QT_TR_NOOP("CA_SHOP_15PCS")
                price: 675;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1735_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1735.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1735_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1735_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1735;
                label: QT_TR_NOOP("CA_SHOP_1PCS")
                price: 60;
            },
            ListElement {
                optionId: 1736;
                label: QT_TR_NOOP("CA_SHOP_7PCS")
                price: 420;
            },
            ListElement {
                optionId: 1737;
                label: QT_TR_NOOP("CA_SHOP_15PCS")
                price: 900;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1631_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1631.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1631_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1631_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1631;
                label: QT_TR_NOOP("CA_SHOP_1DAY")
                price: 20;
            },
            ListElement {
                optionId: 1632;
                label: QT_TR_NOOP("CA_SHOP_7DAYS")
                price: 120;
            },
            ListElement {
                optionId: 1633;
                label: QT_TR_NOOP("CA_SHOP_30DAYS")
                price: 400;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1339_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1339.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1339_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1339_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1339;
                label: QT_TR_NOOP("CA_SHOP_1PCS")
                price: 30;
            },
            ListElement {
                optionId: 1340;
                label: QT_TR_NOOP("CA_SHOP_7PCS")
                price: 210;
            },
            ListElement {
                optionId: 1341;
                label: QT_TR_NOOP("CA_SHOP_15PCS")
                price: 450;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1004_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1004.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1004_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1004_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1004;
                label: QT_TR_NOOP("CA_SHOP_1PCS")
                price: 80;
            },
            ListElement {
                optionId: 1005;
                label: QT_TR_NOOP("CA_SHOP_7PCS")
                price: 560;
            },
            ListElement {
                optionId: 1006;
                label: QT_TR_NOOP("CA_SHOP_15PCS")
                price: 1200;
            }
        ]
    }


    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_4125_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_4125.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_4125_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_4125_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 4125;
                label: QT_TR_NOOP("CA_SHOP_1PCS")
                price: 100;
            },
            ListElement {
                optionId: 4126;
                label: QT_TR_NOOP("CA_SHOP_7PCS")
                price: 700;
            },
            ListElement {
                optionId: 4127;
                label: QT_TR_NOOP("CA_SHOP_15PCS")
                price: 1500;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_645_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_645.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_645_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_645_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 645;
                label: QT_TR_NOOP("CA_SHOP_1DAY")
                price: 10;
            },
            ListElement {
                optionId: 646;
                label: QT_TR_NOOP("CA_SHOP_7DAYS")
                price: 60;
            },
            ListElement {
                optionId: 647;
                label: QT_TR_NOOP("CA_SHOP_30DAYS")
                price: 200;
            }
        ]
    }


    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_784_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_784.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_784_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_784_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 784;
                label: QT_TR_NOOP("CA_SHOP_1DAY")
                price: 15;
            },
            ListElement {
                optionId: 785;
                label: QT_TR_NOOP("CA_SHOP_7DAYS")
                price: 90;
            },
            ListElement {
                optionId: 786;
                label: QT_TR_NOOP("CA_SHOP_30DAYS")
                price: 300;
            }
        ]
    }



    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_1533_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_1533.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_1533_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_1533_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 1533;
                label: QT_TR_NOOP("CA_SHOP_1DAY")
                price: 20;
            },
            ListElement {
                optionId: 1534;
                label: QT_TR_NOOP("CA_SHOP_7DAYS")
                price: 120;
            },
            ListElement {
                optionId: 1535;
                label: QT_TR_NOOP("CA_SHOP_30DAYS")
                price: 400;
            }
        ]
    }

    ListElement {
        title: QT_TR_NOOP("CA_SHOP_ITEM_375_TITLE")
        preview: "Assets/Images/Features/CombatArmsShop/Item_375.png";
        description: QT_TR_NOOP("CA_SHOP_ITEM_375_DESCRIPTION")
        shortDescription: QT_TR_NOOP("CA_SHOP_ITEM_375_DESCRIPTION_SHORT")
        options: [
            ListElement {
                defaultItem: true;
                optionId: 375;
                label: QT_TR_NOOP("CA_SHOP_FOREVER")
                price: 150;
            }
        ]
    }

}
