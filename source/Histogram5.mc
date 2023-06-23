using Toybox.Graphics;

/**
 * Collects data periodically (at each second) in 5 zones.
 */
class Histogram5 {

    // generic for heart rate (20 -> [20, 120], 1 -> [120, 140], ...)
    // 0 -> -1 means rest zone
    hidden var bucketMinThreshold as Toybox.Lang.Array<Toybox.Lang.Number> = [20, 120, 140, 160, 180];
    hidden var secondsInBucket as Toybox.Lang.Array<Toybox.Lang.Number> = [0, 0, 0, 0, 0];
    // TODO: test data, comment it out!!!
    //hidden var secondsInBucket = [30, 50, 60, 40, 10];
    var bucketColor as Toybox.Lang.Array<Toybox.Lang.Number> = [
        Graphics.COLOR_DK_GRAY,
        Graphics.COLOR_BLUE,
        Graphics.COLOR_DK_GREEN,
        Graphics.COLOR_ORANGE,
        Graphics.COLOR_RED
    ];

    hidden var curValue = 0;
    hidden var curBucket = -1;

    var textColor = Graphics.COLOR_BLACK;

    function setThresholds(thresholds) {
        bucketMinThreshold = thresholds;
    }

    // invoked periodically each second
    function add(value) {
        curValue = value;
        curBucket = getBucketFor(curValue);
        if (curBucket >= 0) {
        	secondsInBucket[curBucket] += 1;
        }
    }

    function getCurrentBucket() {
        return curBucket;
    }

    // bucket value is a range betwen 0 -> 4
    function getBucketFor(value) as Toybox.Lang.Number {
        if (value < bucketMinThreshold[0]) {
            return -1; // means less than the minimal threshold => is the rest zone
        }
        var bucket = 0;
        while (bucket < bucketMinThreshold.size() && value >= bucketMinThreshold[bucket]) {
            bucket++;
        }
        return bucket - 1;
    }

    function getMaxBucket() {
        var maxBucket = secondsInBucket[0];
        for (var i = 1; i < secondsInBucket.size(); i++) {
            if (secondsInBucket[i] > maxBucket) {
                maxBucket = secondsInBucket[i];
            }
        }
        return maxBucket;
    }

    function draw(dc, x, y, w, h) {
        var zones = secondsInBucket.size();
        var maxBucket = getMaxBucket();
        var spaceF = 0.2;
        var barH = h;
        var barW = (w / (zones * (1 + spaceF))).toLong();
        var barGap = (spaceF * barW).toLong();
        var barGap2 = barGap / 2;

        dc.setPenWidth(1);
        for (var i = 0; i < zones; i++) {
            var bucketF = maxBucket == 0 ? 0 : secondsInBucket[i].toFloat() / maxBucket;
            var bH = (bucketF * barH).toLong();
            var bX = x + barGap2 + (barW + barGap) * i;
            dc.setColor(bucketColor[i], Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(bX, y + barH - bH, barW, bH);

            // highlight the current zone
            if (i == curBucket) {
                dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(bX, y + barH + 1, barW, 3);
            } else {
                dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(bX, y + barH + 1, barW, 1);
            }
        }
    }

    (:test)
    function testZones(logger) {
        var hrZones = new Histogram5();
        logger.debug("bucket for 0   " + hrZones.getBucketFor(0));
        logger.debug("bucket for 70  " + hrZones.getBucketFor(70));
        logger.debug("bucket for 110 " + hrZones.getBucketFor(110));
        logger.debug("bucket for 120 " + hrZones.getBucketFor(120));
        logger.debug("bucket for 121 " + hrZones.getBucketFor(121));
        logger.debug("bucket for 141 " + hrZones.getBucketFor(141));
        logger.debug("bucket for 161 " + hrZones.getBucketFor(161));
        logger.debug("bucket for 181 " + hrZones.getBucketFor(181));
        logger.debug("bucket for 185 " + hrZones.getBucketFor(185));
        logger.debug("bucket for 190 " + hrZones.getBucketFor(190));
    }
}