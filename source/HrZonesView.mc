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
    hidden var tolerance = 3; // to show the curent hear rate in a different color

    hidden var x = 0;
    hidden var width = 200;
    hidden var width2 = width/2;
    hidden var width3 = width/3;
    hidden var y = 0;
    hidden var height = 53;

    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;

    function initialize() {
        DataField.initialize();

        // use age to calculate max HR or make it editable for this data field.
        var profile = UserProfile.getProfile();
        var age = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - profile.birthYear;
        System.println("age is " + age);
    }

    // See Activity.Info in the documentation for available information.
    // It will be called once a second
    function compute(info) {
        if (info.currentHeartRate != null) {
            curHr = info.currentHeartRate;
            hrZones.add(curHr);
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
        hrZones.textColor = textColor;

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

        // current heart rate
        var text = textOf(curHr);
        var font = Graphics.FONT_NUMBER_MEDIUM;
        var sz = dc.getTextDimensions(text, font);
        if (curHr > avgHr + tolerance && curHr > 0) {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        } else if (curHr < avgHr - tolerance && curHr > 0) {
            dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(textColor, backgroundColor);
        }
        dc.drawText(width3, y + height - sz[1] + 4, font, text, RIGHT_BOTTOM);

        // average heart rate
        text = textOf(avgHr);
        font = Graphics.FONT_MEDIUM;
        dc.setColor(textColor, backgroundColor);
        dc.drawText(width3 + 2, y + height - sz[1] + 4, font, text, LEFT_BOTTOM);

        // draw the unit
        text = "bpm";
        font = Graphics.FONT_SYSTEM_XTINY;
        sz = dc.getTextDimensions(text, font);
        dc.setColor(unitColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width3 + 4, y + height - sz[1] - 2, font, text, LEFT_BOTTOM);

        hrZones.draw(dc, x + 2, y + 1, width - 4, height / 4);
    }

    function textOf(hr) {
        return hr > 0 ? hr.format("%d") : "_";
    }
}