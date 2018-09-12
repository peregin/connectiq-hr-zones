using Toybox.UserProfile as UserProfile;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time;
using Toybox.System;

/**
 *
 * https://healthiack.com/heart-rate-zone-calculator#calculator
 * Various formulas (standard, Miller, Londeree):
 * HR max = 220 - age (standard formula)
 *
 * zone 1 = recovery 50-60% of HR max
 * zone 2 = endurance 60-70% of HR max
 * zone 3 = aerobic 70-80% of HR max
 * zone 4 = lactate 80-90% of HR max
 * zone 5 = VO2 90-100% of HR max
 */
class HeartRate {

    static function getAge() {
        // use age to calculate max HR or make it editable for this data field.
        var profile = UserProfile.getProfile();
        if (profile != null) {
            return Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - profile.birthYear;
        } else {
            return 40;
        }
    }

    static function maxHr(age) {
        return 220 - age;
    }

    static function threshold(age, factor) {
        return (age * factor).toLong();
    }

    static function lowerThresholdsForAge(maxHr) {
        var lowerThreshold = [
            0,
            threshold(maxHr, 0.58),
            threshold(maxHr, 0.77),
            threshold(maxHr, 0.86),
            threshold(maxHr, 0.96)
        ];
        return lowerThreshold;
    }

    static function printThresholds(thresholds) {
        for (var i = 0; i < thresholds.size(); i++) {
           System.println("zone[" + (i+1) + "]=" + thresholds[i]);
        }
    }
}