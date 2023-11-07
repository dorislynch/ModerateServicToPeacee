
# react-native-moderate-servic-to-peacee

## Getting started

`$ npm install react-native-moderate-servic-to-peacee --save`

### Mostly automatic installation

`$ react-native link react-native-moderate-servic-to-peacee`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-moderate-servic-to-peacee` and add `RNModerateServicToPeacee.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNModerateServicToPeacee.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNModerateServicToPeaceePackage;` to the imports at the top of the file
  - Add `new RNModerateServicToPeaceePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-moderate-servic-to-peacee'
  	project(':react-native-moderate-servic-to-peacee').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-moderate-servic-to-peacee/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-moderate-servic-to-peacee')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNModerateServicToPeacee.sln` in `node_modules/react-native-moderate-servic-to-peacee/windows/RNModerateServicToPeacee.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Moderate.Servic.To.Peacee.RNModerateServicToPeacee;` to the usings at the top of the file
  - Add `new RNModerateServicToPeaceePackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import RNModerateServicToPeacee from 'react-native-moderate-servic-to-peacee';

// TODO: What to do with the module?
RNModerateServicToPeacee;
```
  