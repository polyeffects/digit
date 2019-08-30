import QtQuick 2.9
import QtQuick.Controls 2.3
// import QtQuick.Window 2.2
import Qt.labs.folderlistmodel 2.2
import QtQuick.VirtualKeyboard 2.1
// import QtQuick.Controls.Material 2.3

// ApplicationWindow {
//     visible: true
//     width: 400
//     height: 480
//     title: qsTr("Hello World")

//     Material.theme: Material.Dark
//     Material.primary: Material.Green
//     Material.accent: Material.Pink
//
//     preset list
//     add item to list
//     remove item 
//     change preset mapped to number
//     
//     list of buttons,  + or - at top
//     each button opens select preset
//     save
//


    Item {
        id: preset_widget
        property bool is_system_preset: false
        property int map_index: 0

		// save or load
        Component {
            id: loadOrSave
            Item {
				height:720
				width:1280
                Row {
                    spacing: 100
					anchors.centerIn: parent

                    Button {
                        text: "LOAD"
						width: 300
						// height: 500
                        onClicked: presetStack.push(loadPresetWidget)
						font {
							pixelSize: fontSizeLarge
						}
                    }

                    Button {
                        text: "SAVE"
						width: 300
						// height: 500
                        onClicked: is_system_preset ? presetStack.push(choosePresetFolder) : presetStack.push(newOrOverwrite) 
						font {
							pixelSize: fontSizeLarge
						}
                    }

                    Button {
                        text: "MAP"
						width: 300
						// height: 500
                        onClicked: presetStack.push(mapPresets)
						font {
							pixelSize: fontSizeLarge
						}
                    }
                }

				Button {
					text: "BACK"
					anchors.right: parent.right
					anchors.rightMargin: 10
					anchors.topMargin: 10
					width: 100
					height: 100
					onClicked: mainStack.pop()
					font {
						pixelSize: fontSizeMedium
					}
					// onClicked: is_system_preset ? presetStack.push(choosePresetFolder) : presetStack.push(newOrOverwrite) 
				}
            }
        }

        Component {
            id: loadPresetWidget
            // height:parent.height
            // Column {
                // width:300
                // spacing: 20
                // height:parent.height
                Item {
					height:700
					width:1280

					// anchors.centerIn: parent
                    GlowingLabel {
                        // color: "#ffffff"
						y: 20
						x: 400
                        text: qsTr("Select Preset")
                    }

                    FolderBrowser {
                        y: 60
						x: 400
                        // Layout.fillHeight: true
                        height: 650
                        width: 500
						top_folder: "file:///presets/"
						after_file_selected: (function(name) { 
							console.log("loading preset file");
							console.log("file  is", name.toString());
							knobs.ui_load_preset_by_name(name.toString());
							mainStack.pop()
							// some way to handle errors also needed
						})
						
                    } // preset loaded on click on preset

                    // Button {
                    //     y: 460
						// x: 400
                    //     width: 500
                    //     height: 60
                    //     text: "LOAD"
                    //     onClicked: presetStack.push(setPresetName) // load preset and close
                    // }
					Button {
						font {
							pixelSize: fontSizeMedium
						}
						text: "BACK"
						anchors.right: parent.right
						anchors.rightMargin: 10
						anchors.topMargin: 10
						width: 100
						height: 100
                        onClicked: presetStack.pop()
					}
                }
            // }
        }

        // if we've got a user preset loaded, 
        // give option to save as new or update existing
        Component {
            id: newOrOverwrite
            Item {
				height:700
				width:1280
                Row {
                    spacing: 100
					anchors.centerIn: parent

                    Button {
						font {
							pixelSize: fontSizeLarge
						}
                        text: "OVERWRITE"
						width: 300
                        onClicked: { // save preset and close browser
							knobs.ui_save_preset(currentPreset.name);
							mainStack.pop()
						}
                    }

                    Button {
						font {
							pixelSize: fontSizeLarge
						}
                        text: "CREATE NEW"
						width: 300
                        onClicked: presetStack.push(choosePresetFolder)
                    }
                }
				Button {
					font {
						pixelSize: fontSizeMedium
					}
					text: "BACK"
					anchors.right: parent.right
					anchors.rightMargin: 10
					anchors.topMargin: 10
					width: 100
					height: 100
					onClicked: presetStack.pop()
				}
            }
        }


        Component {
            id: choosePresetFolder
            // height:parent.height
            // Column {
                // width:300
                // spacing: 20
                // height:parent.height
                Item {
					height:700
					width:1280
                    // height:parent.height
                    GlowingLabel {
                        // color: "#ffffff"
						y: 30
						x: 400
                        text: qsTr("Choose Folder")
                    }

                    FolderBrowser {
                        y: 70
						x: 400
                        // Layout.fillHeight: true
                        height: 400
                        width: 500
						top_folder: "file:///presets"
                    }
                    // create new folder

                    Button {
						font {
							pixelSize: fontSizeLarge
						}
                        y: 490
						x: 400
                        text: "NEXT"
                        height: 80
                        width: 500
                        onClicked: presetStack.push(setPresetName)
                    }
					Button {
						font {
							pixelSize: fontSizeMedium
						}
						text: "BACK"
						anchors.right: parent.right
						anchors.rightMargin: 10
						anchors.topMargin: 10
						width: 100
						height: 100
						onClicked: presetStack.pop()
					}
                }
            // }
        }

        Component {
            id: setPresetName

            Item {
				height:720
				width:1280
                Column {
                    width:300
					x: 400
					y: 10
					anchors.horizontalCenter:  parent.horizontalCenter
                    spacing: 20
                    // height:parent.height
                    GlowingLabel {
                        // color: "#ffffff"
                        text: qsTr("Enter Preset Name")
                    }

                    TextField {
						id: new_preset_name
						width: 250
						height: 100
						font {
							pixelSize: fontSizeMedium
						}
                        placeholderText: qsTr("Preset Name")    
                    }

                    Button {
						font {
							pixelSize: fontSizeMedium
						}
						width: 250
						height: 100
                        text: "SAVE"
                        enabled: new_preset_name.text.length > 0
						onClicked: {
							knobs.ui_save_preset(new_preset_name.text);
							mainStack.pop()
						}
                    }
                }
				InputPanel {
					id: inputPanel
					// parent:mainWindow.contentItem
					z: 1000002
					anchors.bottom:parent.bottom
					anchors.left: parent.left
					anchors.right: parent.right

					visible: Qt.inputMethod.visible
				}
				Button {
					font {
						pixelSize: fontSizeMedium
					}
					text: "BACK"
					anchors.right: parent.right
					anchors.rightMargin: 10
					anchors.topMargin: 10
					width: 100
					height: 100
					onClicked: presetStack.pop()
				}
            }
        }

        Component {
            id: mapPresets
            Item {
                id: mapPresetsCont
				height:700
				width:1280


                SpinBox {
                    y: 80
                    x: 500
                    // width: 500
                    font.pixelSize: fontSizeMedium
                    from: 1
                    value: presetList.rowCount()
                    to: 127
                    onValueModified: {
                        knobs.set_preset_list_length(value);
                    }
                }
                ListView {
                    x: 500
                    y: 150
                    width: 600
                    height: 500
                    clip: true
                    delegate: ItemDelegate {
                        width: parent.width
                        height: 50
                        text: index + " " + edit
                        bottomPadding: 10
                        font.pixelSize: fontSizeMedium
                        topPadding: 10
                        onClicked: {
                            // knobs.ui_add_connection(effect, sourcePort, edit)
                            preset_widget.map_index = index;
                            presetStack.push(mapPresetBrowser)
                        }
                    }
                    ScrollIndicator.vertical: ScrollIndicator {
                        anchors.top: parent.top
                        parent: mapPresetsCont
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.bottom: parent.bottom
                    }
                    model: presetList
                }
                // Row {
                //     spacing: 100
					// anchors.centerIn: parent
                //     Button {
						// font {
							// pixelSize: fontSizeLarge
						// }
                //         text: "OVERWRITE"
						// width: 300
                //         onClicked: { // save preset and close browser
							// knobs.ui_save_preset(currentPreset.name);
							// mainStack.pop()
						// }
                //     }
                //     Button {
						// font {
							// pixelSize: fontSizeLarge
						// }
                //         text: "CREATE NEW"
						// width: 300
                //         onClicked: presetStack.push(choosePresetFolder)
                //     }
                // }
				Button {
					font {
						pixelSize: fontSizeMedium
					}
					text: "BACK"
					anchors.right: parent.right
					anchors.rightMargin: 20
					anchors.topMargin: 20
					width: 100
					height: 100
                    onClicked: {
                        knobs.save_preset_list()
                        presetStack.pop()
                    }
				}
            }
        }

        Component {
            id: mapPresetBrowser
            // height:parent.height
            // Column {
                // width:300
                // spacing: 20
                // height:parent.height
                Item {
					height:700
					width:1280

					// anchors.centerIn: parent
                    GlowingLabel {
                        // color: "#ffffff"
						y: 20
						x: 400
                        text: qsTr("Select Preset")
                    }

                    FolderBrowser {
                        y: 60
						x: 400
                        // Layout.fillHeight: true
                        height: 650
                        width: 500
						top_folder: "file:///presets/"
						after_file_selected: (function(name) { 
							console.log("mapping preset file");
							knobs.map_preset(preset_widget.map_index, name.toString());
                            presetStack.pop()
						})
						
                    } // preset loaded on click on preset

                    // Button {
                    //     y: 460
						// x: 400
                    //     width: 500
                    //     height: 60
                    //     text: "LOAD"
                    //     onClicked: presetStack.push(setPresetName) // load preset and close
                    // }
					Button {
						font {
							pixelSize: fontSizeMedium
						}
						text: "BACK"
						anchors.right: parent.right
						anchors.rightMargin: 10
						anchors.topMargin: 10
						width: 100
						height: 100
                        onClicked: presetStack.pop()
					}
                }
            // }
        }

        StackView {
            id: presetStack
            initialItem: loadOrSave
        }

    }
// }
