# LiveQ
Collaborative Music Queue

## Directory Structure

.\
├── README.md\
├── api\
├── deliverables\
├── deliverables.zip\
├── ios\
├── liveq\
├── requisition_forms\
├── server\
├── spotify-app-remote-release-0.7.0.aar\
└── spotify-auth-release-1.2.3.aar\

server/    Server Source\  
    - Django Rest API Server for backend  
ios/       XCode Project\  
    - This houses the iOS project. Work is shoddy because it was done about a week before the project was due!  
liveq/     Flutter Project\  
    - This is where the Flutter project is. This project will work for web and Android.  

This application helps users add songs from their phone to a shared queue which can play songs off of one phone, such as the one connected to the Bluetooth Speaker. It's meant to work for iOS, Android, and Web. Users can add songs to the queue from Services that the Host is subscribed to, except SoundCloud where anyone can play any sound. So, if I don't have Spotify then Guests cannot add songs from Spotify to the Queue.

The Search feature allows you to choose which service you'll be searching a song from.

This application allows for a seamless transition between Spotify and SoundCloud streams. Those are the only two supported services for now.

Special Note: The reason why iOS is made natively instead of with Flutter is because Spotify's iOS SDK is a .framework package, and we were having difficulties trying to import it into the Flutter project. I had tried absolutely everything I could, to no avail. So we decided to make the iOS app natively real quick, since most of our friends have iPhones. We also placed importance on the inclusion of a website for this application, as that would allow anyone attending a function to easily add songs. The purpose was ease of use and inclusion because now they don't have to download the app. Only the Host really has to download the app, but you can Host from the Web too.
