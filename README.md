# Hand Sanitiser App
## Primary Objectives
- Create an app to alert users when their hand sanitisers are running low on refill or battery.
- Alerts come in the form of app notifications
- Minimalist Style with few pages and user friendly UI
- Dispensers belong to companies, and the users that are registered to that company can receive notifications whenever a dispenser of that company is running low
- Users of the same company can all see the same dispensers, but can have different notification settings. They can also add, update or delete dispensers
- When dispensers are manufactured, it comes with a QR code with the dispenser ID. The dispenser ID is also printed on the casing. Manufacturer can also register the dispenser ID when it is sold. When users register their new dispenser, the dispenserID can be mapped to the company that registered it. This ensures that the dispenser belongs to only 1 company and cannot be scanned to another company without being removed from the original company.

## Design Considerations
- There are only 3 non-logged in pages and 4 logged-in pages. I used as few pages as possible to make the app simple.
- Many of the additional information, such as keying in of details or the info page, are displayed through the use of dialogs
- Overlays are used extensively. The appbar is not a standard Flutter appbar, but a custom made on based on overlays. Dialogs also use overlays to focus users' attention onto the dialog.
- Animations are used in dialogs and in Edit Profile page. They are used to provide a smoother transition in between dialogs and pages

## Non Logged In Pages
- Users can log in and sign up.
- When signing up, they need to key in the name of a company that is registered to the system. Users cannot directly add new companies. It has to be done by the administrators of the system. Admin will create a document for new companies. After which, users will be able to sign up with the company
- Forget password function which will send a reset password link to the user's email if they are registered. They can use this link to reset their password

## Logged In Pages
- Users must be authenticated in order to access these pages
- Whenever a user logs in, the deviceTokens array in the user document will be updated with the new device token. This allows users to receive notifications via Firebase Cloud Messaging, which sends notifications via device tokens
- When the user logs out, the device token is removed so that the user does not receive notifications anymore.

### Home Screen
- Provides an overview of all the dispensers in the company's system.
- Can see refill level, location
- Users can also reset the refill here, just in case there was some error in resetting via the reset button on the dispenser
- Users can also see info on when the dispenser was used and refilled in the info section.

### Edit Profile
- Users can change their name or reset their password here
- Snackbars will inform users if they succeeded or failed

### Notifications
- Users can choose the refill level at which they want to receive notifications (from 5%-50%)
- Users can also choose if they want to be notified when the dispensers are refilled

### Edit Devices
- In this page, users can see their existing devices, edit the location, delete devices or add new ones.
- Adding new devices:
  - To add a new device, users need to key in the location (location is checked to ensure that it is not the same as an existing dispenser)
  - Every dispenser has a dispenser ID that is printed on the dispenser itself. Users can either scan the QR code with the dispenserId on the dispenser unit or key it in manually into the app. In order to scan the QR code, users can press the QR code scanner. This will autofill the input field for the dispenserId.
- Editing devices
  - Users can see the dispenserId but cannot edit it. (this allows users to identify the dispenser by looking at the dispenserId, but they cannot change it as the dispenserId is mapped to the database when the dispenser is manufactured)
  - Location can be changed but cannot be the same as another existing dispenser
- Delete devices
  - Users will need to confirm that they want to delete the device.

### Potential Improvemnts
- Animations are currently quite laggy. The animation duration can be lengthened in order to make them smoother. 
- Include battery level indicator for each dispenser in the home screen. This has to be integrated with the battery level monitor in the dispenser.

