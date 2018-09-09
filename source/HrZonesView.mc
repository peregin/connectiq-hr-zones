using Toybox.WatchUi;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.UserProfile as UserProfile;

class HrZonesView extends WatchUi.DataField {

    hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    hidden const RIGHT_BOTTOM = Graphics.TEXT_JUSTIFY_RIGHT;
    hidden const LEFT_BOTTOM = Graphics.TEXT_JUSTIFY_LEFT;

    hidden var curHr = 0;
    hidden var avgHr = 0;
    hidden var hrZones = new Histogram5();

    hidden var x = 0;
    hidden var width = 200;
    hidden var width2 = width/2;
    hidden var y = 0;
    hidden var height = 53;

    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;

    function initialize() {
        DataField.initialize();

        var profile = UserProfile.getProfile();
        var age = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - profile.birthYear;
        System.println("age is " + age);

        System.println("bucket for 0   " + hrZones.getBucketFor(0));
        System.println("bucket for 70  " + hrZones.getBucketFor(70));
        System.println("bucket for 110 " + hrZones.getBucketFor(110));
        System.println("bucket for 120 " + hrZones.getBucketFor(120));
        System.println("bucket for 121 " + hrZones.getBucketFor(121));
        System.println("bucket for 141 " + hrZones.getBucketFor(141));
        System.println("bucket for 161 " + hrZones.getBucketFor(161));
        System.println("bucket for 181 " + hrZones.getBucketFor(181));
        System.println("bucket for 185 " + hrZones.getBucketFor(185));
        System.println("bucket for 190 " + hrZones.getBucketFor(190));

    }

    // See Activity.Info in the documentation for available information.
    // It will be called once a second
    function compute(info) {
        if (info.currentHeartRate != null) {
            curHr = info.currentHeartRate;
        }
        if (info.averageHeartRate != null) {
            avgHr = info.averageHeartRate;
        }
    }

    function onLayout(dc) {
        backgroundColor = getBackgroundColor();
        if (backgroundColor == Graphics.COLOR_BLACK) {
            // night
            textColor = Graphics.COLOR_WHITE;
            unitColor = Graphics.COLOR_LT_GRAY;
        } else {
            // daylight
            textColor = Graphics.COLOR_BLACK;
            unitColor = 0x444444;
        }

        x = 0;
        width = dc.getWidth();
        y = 0;
        height = dc.getHeight();
        width2 = width/2;

        onUpdate(dc);
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    //
    // Resolution, WxH	200 x 265 pixels for both 520 and 820
    function onUpdate(dc) {
        // clear background
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width2, y, Graphics.FONT_LARGE, textOf(curHr), LEFT_BOTTOM);

        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width2, y, Graphics.FONT_MEDIUM, textOf(avgHr), RIGHT_BOTTOM);

        dc.setColor(unitColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width2, y, Graphics.FONT_MEDIUM, "bpm", CENTER);
        //textAt(dc, width2, y, width2, height, textOf(curHr), Graphics.FONT_LARGE, LEFT_BOTTOM);
        //textAt(dc, x + width2, y, width2, height, textOf(avgHr), Graphics.FONT_MEDIUM, RIGHT_BOTTOM);
    }

    function textOf(hr) {
        return hr > 0 ? hr.format("%d") : "_";
    }

    function textAt(dc, tx, ty, tw, th, text, font, alignment) {
        var textSize = dc.getTextDimensions(text, font);
        var ox = (alignment & Graphics.TEXT_JUSTIFY_CENTER) == Graphics.TEXT_JUSTIFY_CENTER ? tx + (tw - tx) / 2 : tx + (tw - tx);
        var oy = (alignment & Graphics.TEXT_JUSTIFY_VCENTER) == Graphics.TEXT_JUSTIFY_VCENTER ? th - y - textSize[1] : (th - y) / 2;
        if (ox > 0) {
        	dc.drawText(ox, oy, font, text, alignment);
        }
    }

}