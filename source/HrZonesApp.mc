using Toybox.Application;

/**
 * Data field to show the current and average heart rate, and have a colourful bar on the top
 * displaying the heart rate zone histogram, time spent in each zone.
 *
 * Garmin Edge 820 Features:
 *
 * Screen Size: 2.3"
 * Resolution: 200px x 265px
 * 16-bit Color Display
 * 3 Button Control
 * Touch Screen
 * Smart Notifications
 * GPS / GLONASS
 * Bluetooth Classic and Bluetooth Low Energy
 * VIRB Control
 * Barometric Altimeter
 *
 */
class HrZonesApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new HrZonesView() ];
    }

}