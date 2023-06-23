using Toybox.UserProfile as UserProfile;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time;
using Toybox.System;

/**
 * Try first from Garmin setup: Select > My Stats > Training Zones > Heart Rate Zones
 *
 * Otherwise use the formula from below:
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

    static function calculateThresholds() as Toybox.Lang.Array<Toybox.Lang.Number> {
        var zoneInfo = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
        if (zoneInfo != null && zoneInfo.size() >= 5) {
            System.println("biking zone profile");
            return zoneInfo;
        }
        zoneInfo = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        if (zoneInfo != null && zoneInfo.size() >= 5) {
            System.println("generic zone profile");
            return zoneInfo;
        }
      	var profile = UserProfile.getProfile();
      	if (profile != null) {
            // calculate the age from the profile
            System.println("age from user profile");
      		var age = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - profile.birthYear;
      		return thresholdsFromAge(age);
        }
        // average for 40 years old
        System.println("age 40 user profile");
     	return thresholdsFromAge(40);
    }
    
    static function printThresholds(thresholds as Toybox.Lang.Array<Toybox.Lang.Number>) {
        for (var i = 0; i < thresholds.size(); i++) {
           System.println("zone[" + (i+1) + "]=" + thresholds[i]);
        }
    }
    
    private static function thresholdsFromAge(age) {
    	var maxHr = 220 - age;
    	System.println("age is " + age + ", max HR is " + maxHr);
    	var lowerThreshold = [
            0,
            threshold(maxHr, 0.59),
            threshold(maxHr, 0.78),
            threshold(maxHr, 0.87),
            threshold(maxHr, 0.96)
        ];
        return lowerThreshold;
    	
    }

    private static function threshold(value, factor) {
        return (value * factor).toLong();
    }
}