#!/usr/bin/env python3

import math
import argparse
from datetime import datetime, timedelta
from datetime import datetime, timedelta, timezone

# Fallback for Python < 3.11 (no datetime.UTC)
try:
    UTC = datetime.UTC  # Python 3.11+
except AttributeError:
    UTC = timezone.utc

city_coords = {
    # US cities
    "Austin": (30.2672, -97.7431),
    "Charlotte": (35.2271, -80.8431),
    "Chicago": (41.8781, -87.6298),
    "Columbus": (39.9612, -82.9988),
    "Dallas": (32.7767, -96.7970),
    "Denver": (39.7392, -104.9903),
    "Fort Worth": (32.7555, -97.3308),
    "Houston": (29.7604, -95.3698),
    "Indianapolis": (39.7684, -86.1581),
    "Jacksonville": (30.3322, -81.6557),
    "Los Angeles": (34.0522, -118.2437),
    "New York": (40.7128, -74.0060),
    "Philadelphia": (39.9526, -75.1652),
    "Phoenix": (33.4484, -112.0740),
    "San Antonio": (29.4241, -98.4936),
    "San Diego": (32.7157, -117.1611),
    "San Francisco": (37.7749, -122.4194),
    "San Jose": (37.3382, -121.8863),
    "Seattle": (47.6062, -122.3321),
    "Washington": (38.9072, -77.0369),

    # International capitals
    "Tokyo": (35.6895, 139.6917),           # Japan
    "Canberra": (-35.2809, 149.1300),       # Australia
    "Berlin": (52.5200, 13.4050),           # Germany
    "London": (51.5074, -0.1278),           # United Kingdom
    "New Delhi": (28.6139, 77.2090),        # India
    "Beijing": (39.9042, 116.4074)          # China
}

def calculate_sun_times(lat, lon, date=None):
    if date is None:
        date = datetime.now(UTC).date()

    zenith = 90.833
    day = date.timetuple().tm_yday
    lng_hour = lon / 15

    def calc_time(is_sunrise):
        t = day + ((6 - lng_hour) / 24 if is_sunrise else (18 - lng_hour) / 24)
        M = (0.9856 * t) - 3.289
        L = (M + 1.916 * math.sin(math.radians(M)) +
             0.020 * math.sin(math.radians(2 * M)) + 282.634) % 360
        RA = math.degrees(math.atan(0.91764 * math.tan(math.radians(L)))) % 360
        RA += ((math.floor(L / 90) * 90) - (math.floor(RA / 90) * 90))
        RA /= 15

        sinDec = 0.39782 * math.sin(math.radians(L))
        cosDec = math.cos(math.asin(sinDec))
        cosH = (math.cos(math.radians(zenith)) - sinDec * math.sin(math.radians(lat))) / (cosDec * math.cos(math.radians(lat)))
        if cosH > 1 or cosH < -1:
            return None

        H = ((360 - math.degrees(math.acos(cosH))) if is_sunrise else math.degrees(math.acos(cosH))) / 15
        T = H + RA - (0.06571 * t) - 6.622
        UT = (T - lng_hour) % 24
        return datetime.combine(date, datetime.min.time(), UTC) + timedelta(hours=UT)

    return calc_time(True), calc_time(False)

def get_current_status(lat, lon, now=None):
    now = now or datetime.now(UTC)
    sunrise, sunset = calculate_sun_times(lat, lon)
    if sunrise and sunset:
        if sunrise < sunset:
            return ("day" if sunrise <= now <= sunset else "night")
        else:
            return ("day" if now >= sunrise or now <= sunset else "night")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("city", help="City name (e.g., 'Chicago')")
    parser.add_argument("--status", action="store_true", help="Return 'day' or 'night'")
    args = parser.parse_args()

    if args.city not in city_coords:
        print("Unknown city.")
        return

    lat, lon = city_coords[args.city]
    sunrise, sunset = calculate_sun_times(lat, lon)

    if args.status:
        print(get_current_status(lat, lon))
    else:
        print(f"Sunrise (UTC): {sunrise.strftime('%H:%M:%S') if sunrise else 'N/A'}")
        print(f"Sunset  (UTC): {sunset.strftime('%H:%M:%S') if sunset else 'N/A'}")

if __name__ == "__main__":
    main()

