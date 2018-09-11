
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

    static function lowerThresholdsForAge(age) {
        var lowerThreshold = [0, 120, 140, 160, 180];
        return lowerThreshold;
    }
}