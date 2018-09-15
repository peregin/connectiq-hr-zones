using Toybox.WatchUi;

class HrZonesView extends WatchUi.DataField {

    hidden const CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;
    hidden const RIGHT_BOTTOM = Graphics.TEXT_JUSTIFY_RIGHT;
    hidden const LEFT_BOTTOM = Graphics.TEXT_JUSTIFY_LEFT;

    hidden var curHr = 0;
    hidden var avgHr = 0;
    hidden var hrZones = new Histogram5();
    hidden var tolerance = 3; // to show the curent hear rate in a different color

    hidden var x = 0;
    hidden var width = 200; // it is recalculated in onLayout
    hidden var width2 = width/2;
    hidden var width23 = width*2/3;
    hidden var y = 0;
    hidden var height = 50; // it is recalculated in onLayout
    hidden var isWide = false; // when the data field is wider than 100 pixels the layout will be different

    hidden var hasBackgroundColorOption = false;
    hidden var obscurity = 0; // non-rectangular screens have certain portions of the screen obscured.
    hidden var backgroundColor = Graphics.COLOR_WHITE;
    hidden var textColor = Graphics.COLOR_BLACK;
    hidden var unitColor = 0x444444;

    function initialize() {
        DataField.initialize();

        hasBackgroundColorOption = (self has :getBackgroundColor);
        System.println("has background color = " + hasBackgroundColorOption);

        var age = HeartRate.getAge();
        var maxHr = HeartRate.maxHr(age);
        System.println("age is " + age + ", max HR is " + maxHr);
        var thresholds = HeartRate.lowerThresholdsForAge(maxHr);
        HeartRate.printThresholds(thresholds);
        hrZones.setThresholds(thresholds);
    }

    function onLayout(dc) {
        if (hasBackgroundColorOption) {
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
        }
        hrZones.textColor = textColor;

        calculateSize(dc);
        //System.println("size is [" + width + "," + height + "] wide = " + isWide);

        onUpdate(dc);
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


    // Display the value you computed here. This will be called once a second when the data field is visible.
    // Resolution, WxH	200 x 265 pixels for both 520 and 820
    function onUpdate(dc) {
        // clear background
        dc.setColor(textColor, backgroundColor);
        dc.clear();

        // current heart rate
        var text = textOf(curHr);
        var font = Graphics.FONT_NUMBER_MILD;
        var curHrSize = dc.getTextDimensions(text, font);
        if (curHr > avgHr + tolerance && curHr > 0) {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        } else if (curHr < avgHr - tolerance && curHr > 0) {
            dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(textColor, backgroundColor);
        }
        var splitLeft = isWide || obscurity > 0 ? width2 : width23;
        dc.drawText(splitLeft, y + height - curHrSize[1] + 5, font, text, RIGHT_BOTTOM);
        var splitRight = isWide || obscurity > 0 ? width2 + 15 : width23;

        // average heart rate
        text = textOf(avgHr);
        font = Graphics.FONT_MEDIUM;
        dc.setColor(textColor, backgroundColor);
        dc.drawText(splitRight + 2, y + height - curHrSize[1] + 4, font, text, LEFT_BOTTOM);

        // draw the unit
        var zoneWidth = 0;
        if (obscurity == 0) {
            text = "bpm";
            font = Graphics.FONT_SYSTEM_XTINY;
            var unitSize = dc.getTextDimensions(text, font);
            dc.setColor(unitColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(splitRight + 4, y + height - unitSize[1] - 2, font, text, LEFT_BOTTOM);
            zoneWidth = unitSize[0];
        }

        // draw the historgram
        var hrZoneWidth = isWide ? width : width - zoneWidth;
        hrZones.draw(dc, x + 2, y + 1, hrZoneWidth, height - curHrSize[1] - 2);

        // draw current zone
        if (obscurity == 0) {
            var zx = isWide ? splitLeft + width2/2 + 4 : x + hrZoneWidth;
            var zy = isWide ? y + height - curHrSize[1] + 4 : y + 1;
            font = isWide ? Graphics.FONT_MEDIUM : Graphics.FONT_SYSTEM_TINY;
            var currentZone = hrZones.getCurrentBucket();
            dc.setColor(hrZones.bucketColor[currentZone], backgroundColor);
            dc.drawText(zx, zy, font, "Z" + (currentZone + 1), LEFT_BOTTOM);
        }
    }

    function textOf(hr) {
        return hr > 0 ? hr.format("%d") : "_";
    }

    function calculateSize(dc) {
        x = 0;
        width = dc.getWidth();
        y = 0;
        height = dc.getHeight();

        width2 = width/2;
        width23 = width*2/3;
        isWide = width > 100; // wider than 100 pixels

        obscurity = getObscurityFlags();
        if (obscurity > 0) {
            //System.println("obscurity is " + obscurity);
            var wf = width * 0.1;
            var hf = height * 0.1;
            if ((obscurity & OBSCURE_LEFT) || (obscurity & OBSCURE_RIGHT)  > 0) {
                x += wf;
                width -= 2 * wf;
                height -= 0.5 * hf;
            }
            if ((obscurity & OBSCURE_TOP) || (obscurity & OBSCURE_BOTTOM)  > 0) {
                y += hf;
                height -= 2 * hf;
            }
        }
    }

}