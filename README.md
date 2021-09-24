# forinterview

This project is only configured for Android.

Allows to roll the dice 10 times for each logged in user and puts them up on the leaderboard.

Packages Used:

 - `rxdart`
   
   Used as a State Management tool using the in-built BehaviorSubject
   and provided Streams and Sinks

 - `firebase_core`, `firebase_auth` and `google_sign_in`

    These are used for authentication of the user using firebase

 - `firebase_database`

    This single-handedly functions to store user's score and keeps the leaderboard real-time

 - `flutter_svg`

    For displaying vector svg

 - `get_version`

    Lets the app query it's build information to get current version.
