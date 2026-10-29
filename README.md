# Activity 11 - The Haunted Creature Registry

**Course:** MAD 4360 - Mobile App Development  
**Track:** Undergraduate  
**GitHub:** https://github.com/abubekerm1/haunted_creature_registry

## Project Description

For Activity 11, we used our Activity 10 signup form and changed it into a Haunted Creature Registry. The app now has three screens: Welcome, Signup, and Success. The user can enter their information, select a creature, and register it. After registration, the app shows the user's name and their selected creature.

## App Structure

The app has three screen files inside the lib/screens folder.

- welcome_screen.dart - Shows the animated title and the Enter the Registry button.
- signup_screen.dart - Contains the signup form, validators, creature dropdown, date picker, password visibility, and loading button.
- success_screen.dart - Shows the registered name and creature with a confetti animation.

The main.dart file only starts the app and opens the Welcome screen. I think this makes the code easier to read because each screen has its own file.

## Navigation

I used Navigator.push() from Welcome to Signup. This keeps the Welcome screen in the navigation stack, so the user can go back.

After valid registration, I used Navigator.pushReplacement() to open Success. This removes Signup from the stack. I tested the Android Back button from Success, and it returned to Welcome instead of the old signup form.

## Form State

The name, email, and password use TextEditingController. The birth date and selected creature are stored in the SignupScreen State. The password visibility also uses a boolean State variable.

I rotated the Android Emulator while the signup form had information. The name, password visibility, birth date, and creature selection stayed the same in my test.

I also tested leaving Signup and opening it again. All five fields were empty because it was a new Signup screen.

## Dispose

The dispose() method releases the text controllers when the Signup screen is removed. The Success screen also uses dispose() for the ConfettiController. This helps clean up resources when the screens are no longer used.

## Activity 10 Signup Tip

I kept the local signup-tip feature from Activity 10. It uses preset tips from SignupTipCoach and does not connect to a server or live AI service. The tip is separate from form validation.

## Testing

I tested the app using the Android Emulator.

| Test | Observed Result |
|---|---|
| Empty signup form | All five validation errors appeared |
| Email without @ | Email validation error appeared |
| Password under 6 characters | Password validation error appeared |
| Password visibility | Password could be shown and hidden |
| Birth date 10/15/2000 | Date was accepted |
| Future date 10/30/2026 | Date picker showed Out of range |
| Creature dropdown | All five choices appeared and worked |
| Successful registration | Name and creature appeared on Success |
| Back from Success | Returned to Welcome |
| Reopen Signup | Form fields were empty |
| Emulator rotation | Form information stayed the same |
| Loading spinner | Appeared before navigation |

I ran `flutter analyze` and got "No issues found." I also ran `flutter test`, and all 7 tests passed.

## How to Run

Open the project in Visual Studio Code and run:

```bash
flutter pub get
flutter run
```

The Android release APK is located at:

`build/app/outputs/flutter-apk/app-release.apk`

## Bugs and Fixes

The old Activity 10 widget tests still used the MyApp and SignupPage class names. After we changed the app structure, Flutter analysis showed errors. We updated the test file to use HauntedMansionApp and SignupScreen. After that, Flutter analysis passed.

## Group Members and Contributions

Add each group member's name and their actual contribution here before submitting.

## My Contribution

I worked on the Flutter app, tested the form validation, checked the navigation, tested the date picker and creature choices, and built the release APK.