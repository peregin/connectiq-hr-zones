using Toybox.Graphics;
/**
 * Collects data periodically (at each second) in 5 zones.
 *
 * Various formulas:
 * HR max = 220 - age
 * HR max = 207 - 0.7 * age
 *
 * zone 1 = recovery 50-60% of HR max
 * zone 2 = endurance 70-80% of HR max
 * zone 3 = aerobic 70-80% of HR max
 * zone 4 = lactate 80-90% of HR max
 * zone 5 = VO2 90-100% of HR max
 */
class Histogram5 {

    // generic for heart rate (0 -> [0, 120], 1 -> [120, 140], ...)
    hidden var bucketMinThreshold = [0, 120, 140, 160, 180];
    hidden var secondsInBucket = [0, 0, 0, 0, 0];
    hidden var zoneFillColors = [
        Graphics.COLOR_BLUE,
        Graphics.COLOR_GREEN,
        Graphics.COLOR_YELLOW,
        Graphics.COLOR_ORANGE,
        Graphics.COLOR_RED
    ];

    // bucket value is a range betwen 0 -> 4
    function getBucketFor(value) {
        if (value <= bucketMinThreshold[0]) {
            return 0;
        }
        var bucket = 0;
        while (bucket < bucketMinThreshold.size() && value > bucketMinThreshold[bucket]) {
            bucket++;
        }
        return bucket - 1;
    }
}