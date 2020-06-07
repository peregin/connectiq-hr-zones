using Toybox.Application;

/**
 * Data field to show the current and average heart rate, and have a colourful bar on the top
 * displaying the heart rate zone histogram, time spent in each zone.
 *
 * Garmin Edge 820
 * ---------------
 * Screen Size: 2.3"
 * Resolution: 200px x 265px
 * 16-bit Color Display
 *
 * Garmin Edge 830
 * ---------------
 * Screen Size: 2.6"
 * Resolution: 246px x 322px
 * 16-bit Color Display
 *
 *
 * Garmin Forerunner 735XT
 * -----------------------
 * Resolution: 215px x 185px
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