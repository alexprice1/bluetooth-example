'use strict';
const BluetoothLibrary = require('react-native').NativeModules.Bluetooth;

const React = require('react-native');
const {
  AppRegistry,
  StyleSheet,
  TouchableWithoutFeedback,
  TabBarIOS,
  Text,
  TextInput,
  TouchableHighlight,
  Image,
  View,
  Navigator
} = React;

export default class Bluetooth extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      wifiName: '',
      wifiPassword: '',
      images: []
    };
    this._handleClick = this._handleClick.bind(this);
  }

  _handleClick() {
    BluetoothLibrary.sendMessage(JSON.stringify({
      message: 'Some message',
    }));
  }

  _renderLogin() {
    return (
      <View>
        <Text style={styles.paddingBottom}>Setup Wifi</Text>
        <TextInput
          placeholder="Wifi Name"
          style={styles.textInput}
          onChangeText={(wifiName) => this.setState({wifiName})}
          keyboardType="default"
          value={this.state.wifiName}
        />
        <TextInput
          placeholder="Wifi Password"
          style={styles.textInput}
          onChangeText={(wifiPassword) => this.setState({wifiPassword})}
          keyboardType="default"
          value={this.state.wifiPassword}
        />
        <TouchableHighlight onPress={this._handleClick}>
          <Text style={styles.button}> Setup </Text>
        </TouchableHighlight>
      </View>
    );
  }

  _renderSettings() {
    return (
      <TouchableHighlight onPress={() => BluetoothLibrary.reconnect()}>
        <Text style={styles.button}> Reconnect To Bluetooth </Text>
      </TouchableHighlight>
    );
  }

  _renderContent(color: string, pageText: string, num?: number) {
    return (
      <View style={styles.container}>
        {this['_render' + pageText]()}
      </View>
    )
  }

  render() {
    return (
      <TabBarIOS
      tintColor="white"
      barTintColor="darkslateblue">
        <TabBarIOS.Item
          title="Setup Wifi"
          icon={{uri: base64Icon}}
          selected={this.state.selectedTab === 'blueTab' || !this.state.selectedTab}
          onPress={() => {
            this.setState({
              selectedTab: 'blueTab',
            });
          }}>
          {this._renderContent('#414A8C', 'Login')}
        </TabBarIOS.Item>
        <TabBarIOS.Item
          systemIcon="history"
          badge={this.state.notifCount > 0 ? this.state.notifCount : undefined}
          selected={this.state.selectedTab === 'redTab'}
          onPress={() => {
            this.setState({
              selectedTab: 'redTab',
              notifCount: this.state.notifCount + 1,
            });
          }}>
          {this._renderContent('#783E33', 'Images', this.state.notifCount)}
        </TabBarIOS.Item>
        <TabBarIOS.Item
          icon={{uri: base64Icon2, scale: 3}}
          title="Settings"
          selected={this.state.selectedTab === 'greenTab'}
          onPress={() => {
            this.setState({
              selectedTab: 'greenTab',
              presses: this.state.presses + 1
            });
          }}>
          {this._renderContent('#21551C', 'Settings', this.state.presses)}
        </TabBarIOS.Item>
      </TabBarIOS>
    );
  }
}

const styles = StyleSheet.create({
  paddingBottom: {
    padding: 5
  },
  textInput: {
    padding: 5,
    height: 40,
    borderColor: 'gray',
    borderWidth: 2,
    width: 250
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  tabContent: {
    flex: 1,
    alignItems: 'center',
  },
  tabText: {
    color: 'white',
    margin: 50,
  },
  button: {
    backgroundColor: '#eeeeee',
    padding: 10,
  }
});
